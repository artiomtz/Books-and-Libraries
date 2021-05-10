import pyinputplus as pyip
from backend import service as backend_service
from pick import pick
from prompt_toolkit import prompt

from frontend.constants.library import (book_languages, book_search_options,
                               client_menu_options, staff_menu_options)
from frontend.constants.registration import role_options, us_states
from frontend.utilities import SearchCompleter, Session
from frontend.validation import library as library_validation
from frontend.validation import login as login_validation
from frontend.validation import registration as registration_validation


def logout():
    Session.first_name = None
    Session.last_name = None
    Session.username = None
    Session.role = None
    Session.branch = None
    return


def login_or_signup():
    title =  "Are you a new user or do you have an account?"
    options = ["Register", "Sign in"]
    option, index = pick(options, title)
    username = None

    if option == "Register":
        (
            username,
            first_name,
            last_name,
            email,
            role,
            address,
            city,
            state,
            zip_code,
        ) = get_signup_info(option)
        username, role = backend_service.create_new_user(
            username, first_name, last_name, email, role, address, city, state, zip_code
        )

    elif option == "Sign in":
        username = pyip.inputCustom(
            login_validation.get_username,
            prompt="Please enter your username: ",
            strip=True,
        )

    user_data = backend_service.retrieve_user(username)
    if user_data["role"].lower() == "client":
        branch = get_current_branch()
        Session(
            user_data["firstName"],
            user_data["lastName"],
            user_data["username"],
            user_data["role"],
            branch,
        )
    else:
        Session(
            user_data["firstName"],
            user_data["lastName"],
            user_data["username"],
            user_data["role"],
        )


def get_current_branch():
    title = "Please select your current branch: "
    options = backend_service.retrieve_all_branches()
    branch, index = pick(options, title)
    return branch


def get_signup_info(option):
    if option == "Register":
        first_name = pyip.inputCustom(
            registration_validation.get_first_name,
            prompt="Please enter your first name: ",
            strip=True,
        )
        last_name = pyip.inputCustom(
            registration_validation.get_last_name,
            prompt="Please enter your last name: ",
            strip=True,
        )
        email = pyip.inputEmail(prompt="Please enter your email address: ", strip=True)
        username = pyip.inputCustom(
            registration_validation.get_username,
            prompt="Please enter a username: ",
            strip=True,
        )
        address = pyip.inputCustom(
            registration_validation.get_address, prompt="Address (optional): ", blank=True
        )
        city = pyip.inputCustom(
            registration_validation.get_city, prompt="City (optional): ", strip=True, blank=True
        )

        title = "Which state do you reside in?"
        options = us_states
        state, index = pick(options, title)
        zip_code = pyip.inputCustom(
            registration_validation.get_zip, prompt="Please enter a valid US zip code (ex: 22313): "
        )

        title = "Are you a client or a staff member?"
        options = role_options
        role, index = pick(options, title)

        return (
            username,
            first_name,
            last_name,
            email,
            role,
            address,
            city,
            state,
            zip_code,
        )


def get_rating_and_review(isbn):
    title = "How many stars would you give this book?"
    rating_options = ["*", "**", "***", "****", "*****", 'Back']
    option, index = pick(rating_options, title)

    if option != 'Back':
        review = pyip.inputCustom(
            library_validation.get_review,
            prompt="Please enter your review (optional): ",
            blank=True,
        )
        num_stars = index + 1
        backend_service.add_rating_and_review(num_stars, review, isbn, Session.username)
        message = "Your review was added successfully!"
        show_book_data(isbn, optional_message=message)
    else:
        show_book_data(isbn)


def show_menu_options():
    title = f"Welcome {Session.first_name}! What would you like to do?"
    if Session.branch:
        title = title + f"\nCurrent branch: {Session.branch}"

    if Session.role.lower() == "staff":
        options = staff_menu_options
        option, index = pick(options, title)
        if index == 0:  # search for book
            show_book_search_options()
        elif index == 1:  # search the user database
            show_user_search_options()
        elif index == 2:  # add new book
            get_new_book_info()
        elif index == 3:  # view account details
            show_account_options()
        elif index == 4:  # logout
            logout()  # return to sign in or register screen
    elif Session.role.lower() == "client":
        options = client_menu_options
        option, index = pick(options, title)

        if index == 0:  # search for book
            show_book_search_options()
        elif index == 1:  # return a book
            show_checkouts()
        elif index == 2:  # view account details
            show_account_options()
        elif index == 3:  # logout
            logout()  # return to sign in or register screen


def show_account_options():
    title = "Please choose from the following actions"
    options = ["Show personal details", "Delete account", "Back"]
    option, index = pick(options, title)
    if index == 0:
        show_user_details()
    elif index == 1:

        response = pyip.inputYesNo(
            prompt="Are you sure you want to delete your account? Type 'yes' or 'no': "
        )
        if response == "yes":
            backend_service.delete_account(Session.username)
            logout()
        else:
            show_account_options()
    else:
        show_menu_options()


def show_user_details(username=None):

    # will be true if staff is searching for a particular user (not themselves)
    if Session.role.lower() == "staff" and username:
        user_table = backend_service.get_user_table(username)
        title = user_table
        options = ["Delete user", "Back"]
        option, index = pick(options, title)
        if index == 0:
            response = pyip.inputYesNo(
                prompt="Are you sure you want to delete this account? Type 'yes' or 'no': "
            )
            if response == "yes":
                backend_service.delete_account(username)
            show_user_search_options(optional_message="User deleted successfully!")
        else:
            show_user_search_options()

    else:
        username = Session.username
        user_table = backend_service.get_user_table(username)
        title = user_table
        options = ["Back"]
        option, index = pick(options, title)
        if index == 0:
            show_account_options()


def show_user_search_options(optional_message=None):
    title = ""
    if optional_message:
        title += optional_message + '\n'
    title += "How would you like to search for users?"
    options = [
        "Search by username",
        "Back",
    ]  # TODO: search by full name if we have more time
    option, index = pick(options, title)
    if index == 0:
        search_for_user(index)
    elif index == 1:
        show_menu_options()


def search_for_user(search_method):
    if search_method == 0:  # search by name
        username_list = backend_service.retrieve_distinct_usernames()
        while 1:
            username = prompt(
                "Search by username: ",
                completer=SearchCompleter(username_list),
            )
            break
        if backend_service.retrieve_user(username):
            show_user_details(username=username)
        else:
            title = "No users matched your query"
            options = [
                "Search by username",
                "Back",
            ]
            option, index = pick(options, title)
            if index == 0:
                search_for_user(index)
            elif index == 1:
                show_menu_options()


def show_book_search_options():
    title = "How would you like to search for the book?"
    options = book_search_options
    option, index = pick(options, title)
    search_for_book(index)


def search_for_book(search_method):
    """
    Enables book to be fuzzy searched by its title, author, publisher or isbn.
    Displays list of results as user is typing the query.
    """

    if search_method == 0:  # search by name
        book_name_list = backend_service.retrieve_distinct_book_names()
        while 1:
            book_name = prompt(
                "Search by name: ",
                completer=SearchCompleter(book_name_list),
            )
            break
        book_isbn = backend_service.retrieve_isbn_by_book_name(book_name)
        show_book_data(book_isbn)

    elif search_method == 1:  # search by author
        author_name_list = backend_service.retrieve_distinct_author_names()
        while 1:
            book_author = prompt(
                "Search by author: ",
                completer=SearchCompleter(author_name_list),
            )
            break

        # allow user to search books filtered by author
        filtered_list = backend_service.retrieve_distinct_book_names(author=book_author)
        while 1:
            book_name = prompt(
                f"Search books written by {book_author}: ",
                completer=SearchCompleter(filtered_list),
            )
            break
        book_isbn = backend_service.retrieve_isbn_by_book_name(book_name)
        show_book_data(book_isbn)

    elif search_method == 2:  # search by publisher
        publisher_name_list = backend_service.retrieve_distinct_publisher_names()
        while 1:
            book_publisher = prompt(
                "Search by publisher: ",
                completer=SearchCompleter(publisher_name_list),
            )
            break

        # allow user to search books filtered by publisher
        filtered_list = backend_service.retrieve_distinct_book_names(
            publisher=book_publisher
        )
        while 1:
            book_name = prompt(
                f"Search books published by {book_publisher}: ",
                completer=SearchCompleter(filtered_list),
            )
            break
        book_isbn = backend_service.retrieve_isbn_by_book_name(book_name)
        show_book_data(book_isbn)

    elif search_method == 3:  # search by ISBN
        isbn_list = backend_service.retrieve_distinct_isbns()
        while 1:
            book_isbn = prompt(
                "Search by ISBN: ",
                completer=SearchCompleter(isbn_list),
            )
            break
        show_book_data(book_isbn)
    elif search_method == 4:  # return to main menu
        show_menu_options()


def show_book_data(isbn, optional_message=None):
    """
    Displays a table which contains the selected book's information like publisher, author,
    reviews, isbn etc. and allows the user to check it out or write a review.
    By default, book_data will contain the book name however if the user searches by ISBN,
    it will contain ISBN and search_by_isbn will be true.

    If the user's selected branch doesn't contain the searched book, checkout
    is disabled and a warning message is displayed.
    """

    book_table = backend_service.get_book_table(isbn)
    if book_table is not None:
        if Session.role.lower() == "client":
            num_copies = backend_service.check_availability(Session.branch, isbn)
            checked_out_now = backend_service.is_checked_out_now(isbn, Session.username)
            title = book_table
            if optional_message:
                title += "\n" + optional_message
            if (
                num_copies < 1 or checked_out_now
            ):  # book is unavailable to checkout in both cases
                title += f"\n! This book is UNAVAILABLE for checkout at your branch: {Session.branch} !"
                if checked_out_now:
                    title += "\nYou already have this book checked out."
                options = ["Write a review", "Show reviews", "View checkouts", "Back"]
                option, index = pick(options, title)

                if index == 0:  # write a review
                    get_rating_and_review(isbn)
                elif index == 1:
                    show_reviews(isbn)
                elif index == 2:  # view checkouts
                    show_checkouts()
                else:
                    show_book_search_options()
            else:
                title = book_table
                options = ["Checkout", "Write a review", "Show reviews", "Back"]
                option, index = pick(options, title)

                if index == 0:  # checkout book
                    backend_service.checkout_book(
                        isbn, Session.username, Session.branch, num_copies
                    )
                    title = "Book checkout success!"
                    options = [
                        "Search again",
                        "Show reviews",
                        "View checkouts",
                        "Back to main menu",
                    ]
                    option, index = pick(options, title)
                    if index == 0:
                        show_book_search_options()
                    elif index == 1:
                        show_reviews(isbn)
                    elif index == 2:
                        show_checkouts()
                    else:
                        show_menu_options()

                elif index == 1:  # write a review
                    get_rating_and_review(isbn)
                elif index == 2:  # write a review
                    show_reviews(isbn)
                elif index == 3:  # go back to book search method
                    show_book_search_options()
        else:  # Staff have different options
            title = book_table
            options = ["Delete book", "Show Reviews", "Back"]
            option, index = pick(options, title)
            if index == 0:
                response = pyip.inputYesNo(
                    prompt="Are you sure you want to delete this book? Type 'yes' or 'no': "
                )
                if response == "yes":
                    backend_service.delete_book(isbn)
                    title = "Book deleted successfully! What would you like to do next?"
                else:
                    title = "Book deletion cancelled. What would you like to do next?"
                options = ["Search again", "Back to main menu"]
                option, index = pick(options, title)
                if index == 0:
                    show_book_search_options()
                else:
                    show_menu_options()
            elif index == 1:
                show_reviews(isbn)
            else:
                show_book_search_options()

    else:  # Allow user to search again
        title = "No book matched your search query. Would you like to search again or exit to the main menu?"
        options = ["Search again", "Back to main menu"]
        option, index = pick(options, title)
        if index == 0:  # search again
            show_book_search_options()
        else:  # back to main menu
            show_menu_options()


def show_checkouts(return_success=None):
    checkouts_formatted, checkouts_raw = backend_service.retrieve_user_checkouts(
        Session.username
    )
    checkouts_formatted.append("Cancel")

    if not checkouts_raw:
        title = "You have no books currently checked out."
        if return_success:
            title = return_success + "\n" + title
        options = ["Back"]
        option, index = pick(options, title)
        if index == 0:
            show_menu_options()
    else:
        title = "Please select the book you'd like to return:"
        if return_success:
            title = return_success + "\n" + title
        options = checkouts_formatted
        option, index = pick(options, title)

        if option != "Cancel":
            backend_service.return_book(
                checkouts_raw[index], Session.branch, Session.username
            )
            show_checkouts("Book return success!")
        else:
            show_menu_options()


def show_reviews(isbn):
    reviews = backend_service.get_reviews(isbn)
    if not reviews:
        title = "There are no reviews for this book."
    else:
        title = reviews
    options = ["Back"]
    option, index = pick(options, title)
    if index == 0:
        show_book_data(isbn)


def get_new_book_info():
    title = "Please select the branch you're adding this book to: "
    options = backend_service.retrieve_all_branches()
    branch, index = pick(options, title)

    author_is_new = False
    publisher_is_new = False

    name = pyip.inputCustom(
        library_validation.get_book_name,
        prompt="Please enter the name of the book: ",
    )

    isbn = pyip.inputCustom(
        library_validation.get_isbn,
        prompt="Please enter the isbn: ",
    )

    title = "Please enter the book's language: "
    options = book_languages
    language, index = pick(options, title)

    author_name_list = backend_service.retrieve_distinct_author_names()
    while 1:
        author = prompt(
            "Please enter the book's author (optional): ",
            completer=SearchCompleter(author_name_list),
        )
        author = author.replace('\r', '').replace('\n', '')
        break
    if author not in author_name_list:
        author_is_new = True

    publisher_name_list = backend_service.retrieve_distinct_publisher_names()
    while 1:
        publisher = prompt(
            "Please enter the book's publisher (optional): ",
            completer=SearchCompleter(publisher_name_list),
        )
        publisher = publisher.replace('\r', '').replace('\n', '')
        break
    if publisher not in publisher_name_list:
        publisher_is_new = True

    publish_year = pyip.inputCustom(
        library_validation.get_publish_year,
        prompt="Please enter the book's publish year in the format 'yyyy' (optional): ",
        blank=True
    )

    num_pages = pyip.inputInt(prompt="Please enter the number of pages (optional): ", default=0, blank=True)

    num_copies = pyip.inputInt(prompt="Please enter the number of copies at the branch: ")

    subjects = pyip.inputCustom(
        library_validation.get_subjects,
        prompt="Please enter the book subjects (optional): ", blank=True
    )

    book = {
        'branch': branch,
        'name': name,
        'isbn': isbn,
        'language': language,
        'author': author,
        'publisher': publisher,
        'publish_year': publish_year,
        'num_pages': num_pages,
        'num_copies': num_copies,
        'subjects': subjects,
        'author_is_new': author_is_new,
        'publisher_is_new': publisher_is_new,
    }

    backend_service.create_new_book(book)

    title = "Book added successfully!: "
    options = ["Add another book", "Back"]
    option, index = pick(options, title)

    if index == 0:
        get_new_book_info()
    else:
        show_menu_options()
