import re

from datetime import datetime

from mysql.connector import IntegrityError, MySQLConnection
from terminaltables import SingleTable, DoubleTable, AsciiTable

from .db import config


def execute(action, data):
    cnx = MySQLConnection(**config.credentials)
    cursor = cnx.cursor(buffered=True, dictionary=True)
    cursor.execute(action, data)
    cnx.commit()
    return cursor


def create_new_user(
    username, first_name, last_name, email, role, address, city, state, zip_code
):
    insert_user = (
        "INSERT INTO User "
        "(username, firstName, lastName, email, role, street, city, state, zip) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
    )

    user_data = (
        username,
        first_name.title(),
        last_name.title(),
        email,
        role.lower(),
        address,
        city,
        state,
        zip_code,
    )

    try:
        execute(insert_user, user_data)
        return username, role
    except IntegrityError:
        print("This username chosen is already taken. Please choose a different one.")


def retrieve_user(username):
    select_user = "SELECT * FROM User WHERE username = %s LIMIT 1"
    try:
        cursor = execute(select_user, (username,))
        row = cursor.fetchone()
        return row
    except AttributeError:
        return None


def get_user_table(username):
    user_data = retrieve_user(username)

    table_data = [
        ["First name", user_data["firstName"]],
        ["Last name", user_data["lastName"]],
        ["Email", user_data["email"]],
        ["Username", user_data["username"]],
        ["Role", user_data["role"]],
        ["Street", user_data["street"]],
        ["City", user_data["city"]],
        ["State", user_data["state"]],
        ["Zip", user_data["zip"]],
    ]
    table = DoubleTable(table_data, " User Info ")
    table.inner_heading_row_border = False
    table.inner_row_border = True
    return table.table


def retrieve_distinct_book_names(author=None, publisher=None):
    select_names = "select distinct name from Book limit 10000"  # remove limit to get all the books (this is here for speed)
    try:
        if author:
            select_names = select_names = """
            select * from Book where Book.isbn in (select bookID from BookAuthor where authorID=%s);"""
            cursor = execute(select_names, (author,))
        elif publisher:
            select_names = "select distinct name from Book where publisher= %s"
            cursor = execute(select_names, (publisher,))
        else:
            cursor = execute(select_names, ())
        names_dict_list = cursor.fetchall()
        names_list = [name["name"] for name in names_dict_list]
        return names_list
    except Exception as e:
        print(e)


def retrieve_distinct_publisher_names():
    select_names = "select distinct publisher from Book where publisher is not null"
    try:
        cursor = execute(select_names, ())
        publisher_dict_list = cursor.fetchall()
        publisher_name_list = [
            publisher["publisher"] for publisher in publisher_dict_list
        ]
        return publisher_name_list
    except Exception as e:
        print(e)


def retrieve_distinct_author_names():
    select_names = "select distinct name from Author"
    try:
        cursor = execute(select_names, ())
        names_dict_list = cursor.fetchall()
        names_list = [name["name"] for name in names_dict_list]
        return names_list
    except Exception as e:
        print(e)


def retrieve_distinct_isbns():
    select_names = "select isbn from Book limit 10000"
    try:
        cursor = execute(select_names, ())
        isbn_dict_list = cursor.fetchall()
        isbn_list = [isbn["isbn"] for isbn in isbn_dict_list]
        return isbn_list
    except Exception as e:
        print(e)


def retrieve_distinct_usernames():
    select_usernames = "select username from User"
    try:
        cursor = execute(select_usernames, ())
        username_dict_list = cursor.fetchall()
        username_list = [username["username"] for username in username_dict_list]
        return username_list
    except Exception as e:
        print(e)


def retrieve_book_row(book_data, query):
    try:
        cursor = execute(query, (book_data,))
        return cursor.fetchone()
    except Exception as e:
        print(e)


def build_ascii_book_table(row):
    if row:
        row = {k: "N/A" if not v else v for k, v in row.items()}
        if len(row["subjects"]) > 50:
            row["subjects"] = "\n".join(row["subjects"].split(", "))

        table_data = [
            ["Name", row["name"]],
            ["Publisher", row["publisher"]],
            ["ISBN", row["isbn"]],
            ["Language", row["language"]],
            ["Number of pages", row["numPages"]],
            ["Rating", row["rating"]],
            ["Number of Ratings", row["numRatings"]],
            ["Subjects", row["subjects"]],
        ]
        table = DoubleTable(table_data, " Book Info ")
        table.inner_heading_row_border = False
        table.inner_row_border = True
        return table.table
    else:
        return None


def get_book_table(book_data):
    query = "select * from Book where isbn = %s"

    row = retrieve_book_row(book_data, query)
    return build_ascii_book_table(row)


def retrieve_all_branches():
    select_branches = "select distinct longName from Library"
    try:
        cursor = execute(select_branches, ())
        branch_dict_list = cursor.fetchall()
        branch_list = [branch["longName"] for branch in branch_dict_list]
        return branch_list
    except Exception as e:
        print(e)


def retrieve_isbn_by_book_name(book_name):
    select_isbn = "select isbn from Book where name = %s"
    try:
        cursor = execute(select_isbn, (book_name,))
        row = cursor.fetchone()
        return row.get("isbn")
    except AttributeError:
        return None


def retrieve_branch_short_name(long_name):
    select_isbn = "select shortName from Library where longName = %s"
    try:
        cursor = execute(select_isbn, (long_name,))
        row = cursor.fetchone()
        return row.get("shortName")
    except AttributeError:
        return None


def check_availability(branch_long_name, book_isbn):
    """
    Returns the number of copies of the selected book based on
    the user's branch.
    """
    select_num_copies = (
        "select numCopies from BookCopy where libraryID = %s and bookID = %s;"
    )
    branch_short_name = retrieve_branch_short_name(branch_long_name)
    try:
        cursor = execute(select_num_copies, (branch_short_name, book_isbn))
        row = cursor.fetchone()
        return row["numCopies"]
    except TypeError:
        return 0


def checkout_book(isbn, username, branch_long_name, num_copies):
    branch_short_name = retrieve_branch_short_name(branch_long_name)
    insert_checkout_record = (
        "insert into Checkout "
        "(id, bookID, userID, libraryID, checkoutDate, returnDate, dueDate) "
        "values (null, %s, %s, %s, CURRENT_TIMESTAMP(), null, "
        "date_add(CURRENT_TIMESTAMP(), interval 30 day))"
    )
    checkout_data = (isbn, username, branch_short_name)

    if num_copies <= 1:
        update_num_copies = "delete from BookCopy where libraryID = %s and bookID = %s;"
        num_copy_data = (branch_short_name, isbn)
    else:
        num_copies_reduced = num_copies - 1
        update_num_copies = (
            "update BookCopy set numCopies = %s where libraryID = %s and bookID = %s;"
        )
        num_copy_data = (num_copies_reduced, branch_short_name, isbn)

    try:
        execute(update_num_copies, num_copy_data)
        execute(insert_checkout_record, checkout_data)
    except Exception as e:
        print(e)


def is_checked_out_now(isbn, username):
    select_checkout = "select * from Checkout where bookID = %s and userID = %s and returnDate is null"
    select_checkout_data = (isbn, username)
    try:
        cursor = execute(select_checkout, select_checkout_data)
        row = cursor.fetchone()
        if row:
            return True
        return False
    except Exception as e:
        print(e)


def retrieve_user_checkouts(username):
    select_checkouts = (
        "select name, isbn, checkoutDate, dueDate from Checkout "
        "inner join Book on Checkout.bookID = Book.isbn where userID=%s and returnDate is null"
    )
    try:
        cursor = execute(select_checkouts, (username,))
        rows = cursor.fetchall()
        checkouts_formatted = []
        counter = 1
        for row in rows:
            checkouts_formatted.append(
                f"{counter}. Name: {row['name']} | ISBN: {row['isbn']} | Checked out on: {row['checkoutDate']} | Due on: {row['dueDate']}"
            )
            counter += 1
        return checkouts_formatted, rows
    except AttributeError:
        return None


def check_if_overdue(username, isbn):
    select_overdue = (
        "select id, dueDate from Checkout where userID = %s"
        " and bookID = %s and returnDate is null"
    )
    select_overdue_data = (username, isbn)

    try:
        cursor = execute(select_overdue, select_overdue_data)
        row = cursor.fetchone()

        checkout_id = row['id']
        due_date = row["dueDate"]

        if datetime.now() > due_date:
            insert_overdue = "insert into OverDue values (%s, %s)"
            insert_overdue_data = (checkout_id, username)
            execute(insert_overdue, insert_overdue_data)

    except Exception as e:
        print(e)


def return_book(book_data, branch_long_name, username):
    isbn = book_data["isbn"]
    num_copies = check_availability(branch_long_name, isbn)
    branch_short_name = retrieve_branch_short_name(branch_long_name)

    if num_copies > 0:
        update_numcopies = (
            "update BookCopy set numCopies = %s where libraryID = %s and bookID = %s"
        )
        num_copies += 1
        update_numcopies_data = (num_copies, branch_short_name, isbn)
    else:
        update_numcopies = "insert into BookCopy values (%s, %s, 1)"
        update_numcopies_data = (isbn, branch_short_name)

    update_checkout = (
        "update Checkout set returnDate = CURRENT_TIMESTAMP() "
        "where userID = %s and bookID = %s and returnDate is null"
    )
    update_checkout_data = (username, isbn)

    check_if_overdue(username, isbn)

    try:
        execute(update_numcopies, update_numcopies_data)
        execute(update_checkout, update_checkout_data)

    except Exception as e:
        print(e)


def delete_account(username):
    update_assoc_checkouts = "update Checkout set userID = 'anonymous' where userID = %s"
    update_assoc_reviews = "update Review set userID = 'anonymous' where userID = %s"
    update_assoc_overdue = "update OverDue set userID = 'anonymous' where userID = %s"
    delete_user = "delete from User where username = %s;"

    try:
        execute(update_assoc_checkouts, (username,))
        execute(update_assoc_reviews, (username,))
        execute(update_assoc_overdue, (username,))
        execute(delete_user, (username,))
    except Exception as e:
        print(e)


def add_rating_and_review(num_stars, review, isbn, username):
    insert_rating_review = (
        "insert into Review "
        "(id, bookID, userID, rating, comment, date)"
        "values (null, %s, %s, %s, %s, curdate())"
    )
    insert_rating_review_data = (isbn, username, format(num_stars, ".2f"), review)

    update_numratings = "update Book set numRatings = numRatings + 1 where isbn = %s"

    update_overall_rating = (
        "update Book set rating = "
        "CAST((rating * numRatings + %s)/(numRatings + 1) as decimal (5,2)) where isbn = %s"
    )

    try:
        execute(insert_rating_review, insert_rating_review_data)
        execute(update_numratings, (isbn,))
        execute(update_overall_rating, (num_stars, isbn,))
    except Exception as e:
        print(e)


def delete_book(isbn):

    delete_book_query1 = "delete from BookAuthor where bookID = %s"
    delete_book_query2 = "delete from BookCopy where bookID = %s"
    delete_book_query3 = "delete from Review where bookID = %s"
    delete_book_query4 = "delete from Checkout where bookID = %s"
    delete_book_query5 = "delete from Book where isbn = %s"

    try:
        execute(delete_book_query1, (isbn,))
        execute(delete_book_query2, (isbn,))
        execute(delete_book_query3, (isbn,))
        execute(delete_book_query4, (isbn,))
        execute(delete_book_query5, (isbn,))
    except Exception as e:
        print(e)


def get_reviews(isbn):
    select_reviews = "select comment, rating, userID, date from Review where bookID = %s order by date desc"

    try:
        cursor = execute(select_reviews, (isbn,))
        rows = cursor.fetchall()
        reviews = ''

        for row in rows:
            stars = ''
            for i in range((int(row['rating']))):
                stars += '*'
            stars = stars.ljust(12)

            new = '\n'.join(line.strip() for line in re.findall(r'.{1,40}(?:\s+|$)', row['comment']))

            table_data = [
                ["Rating: ", f"{stars}"],
                [f"User: ", f"{row['userID']}"],
                ["Comment: ", f"{new}"],
                ["Date: ", f"{row['date']}"],
            ]
            table = AsciiTable(table_data)
            table.inner_heading_row_border = False
            # table.inner_footing_row_border  = False
            table.inner_column_border = False
            table.inner_row_border = False
            table.padding_right = 2
            reviews += (table.table + '\n')
        return reviews

    except Exception as e:
        print(e)
        return None


def create_new_book(book):
    branch = book.get('branch')
    name = book.get('name')
    isbn = book.get('isbn')
    author = book.get('author')
    language = book.get('language')
    publisher = book.get('publisher')
    publish_year = book.get('publish_year')
    num_pages = book.get('num_pages')
    num_copies = book.get('num_copies')
    subjects = book.get('subjects')
    author_is_new = book.get('author_is_new')
    publisher_is_new = book.get('publisher_is_new')

    insert_book = ("insert into Book values "
                   "(%s, %s, %s, %s, %s, 0.00, 0, %s, %s)")
    if not num_pages:
        num_pages = None
    insert_book_data = (isbn, name, language, publisher, publish_year, num_pages, subjects)

    insert_numcopies = "insert into BookCopy values (%s, %s, %s)"
    insert_numcopies_data = (isbn, retrieve_branch_short_name(branch), num_copies)

    insert_book_author = "insert into BookAuthor values (null, %s, %s);"
    insert_book_author_data = (isbn, author)

    try:
        if author and author_is_new:
            insert_author = "insert into Author values (%s)"
            execute(insert_author, (author,))
        if publisher and publisher_is_new:
            insert_publisher = "insert into Publisher values (%s)"
            execute(insert_publisher, (publisher,))

        execute(insert_book, insert_book_data)
        execute(insert_numcopies, insert_numcopies_data)
        execute(insert_book_author, insert_book_author_data)
    except Exception as e:
        print(e)
