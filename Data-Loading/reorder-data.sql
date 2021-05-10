# alter table Book drop constraint book_publisher_fk;
# alter table BookAuthor drop constraint ba_book_fk;
# alter table BookAuthor drop constraint ba_author_fk;
# alter table BookCopy drop constraint copy_book_fk;
# alter table BookCopy drop constraint copy_library_fk;
# alter table Review drop constraint review_book_fk;
# alter table Review drop constraint review_user_fk;
# alter table Checkout drop constraint checkout_book_fk;
# alter table Checkout drop constraint checkout_user_fk;
# alter table Checkout drop constraint checkout_library_fk;
# alter table OverDue drop constraint overdue_checkout_fk;
# alter table OverDue drop constraint overdue_user_fk;

drop table if exists Book;
drop table if exists Author;
drop table if exists BookAuthor;
drop table if exists Publisher;
drop table if exists BookCopy;
drop table if exists Review;
drop table if exists Checkout;
drop table if exists User;
drop table if exists OverDue;


# Create main tables
# ----------------------------------------

create table Book (
    isbn varchar(13) primary key,
    name varchar(255) not null,
    language char (3) null,
    publisher varchar(255) not null,
    publishYear decimal(4) null,
    rating decimal (5, 2) null,
    numRatings integer unsigned not null,
    numPages integer unsigned null,
    subjects varchar(255) null,
    check (char_length(isbn) = 10 or char_length(isbn) = 13),
    check (publishYear is null or publishYear >= 1000),
    index book_name_idx (name),
    index book_language_idx (language),
    index book_publisher_idx (publisher),
    index book_year_idx (publishYear)
);

create table Author (
   name varchar(255) primary key
);

create table BookAuthor (
    id integer auto_increment primary key,
    bookID varchar(13) null,
    authorID varchar(255) null
);

create table Publisher (
   name varchar(255) primary key
);

create table BookCopy (
    bookID varchar(13),
    libraryID varchar(3),
    numCopies integer unsigned not null,
    primary key (bookID, libraryID)
);

create table Review (
    id integer auto_increment primary key,
    bookID varchar(13) not null,
    userID varchar(12) not null,
    rating decimal(5, 2) null,
    comment varchar(1000) null,
    date date null,
    index review_bookid_idx (bookID)
);

create table Checkout (
    id integer auto_increment primary key,
    bookID varchar(13) not null,
    userID varchar(12) not null,
    libraryID varchar(3) not null,
    checkoutDate datetime not null,
    returnDate datetime null,
    dueDate datetime not null,
    index checkout_bookid_idx (bookID),
    index checkout_userid_idx (userID)
);

create table User (
    username varchar(12) primary key,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
    email varchar(70) not null,
    role varchar(20) not null,
    street varchar(255) null,
    city varchar (20) null,
    state varchar(2) null,
    zip varchar(10) null
);

create table OverDue (
    checkoutID integer primary key,
    userID varchar(12) not null
);


# Fill main tables
# ----------------------------------------

insert into Book
    select isbn, name, language, publisher, publishYear, rating, numRatings, numPages, subjects
    from LibraryCollectionUniqueMatchedISBN;

insert into Author
    select distinct author
    from LibraryCollectionUniqueMatchedISBN
    where author is not null;

insert into BookAuthor
    select distinct null, isbn, author
    from LibraryCollectionUniqueMatchedISBN;

insert into Publisher
    select distinct publisher
    from LibraryCollectionUniqueMatchedISBN
    where publisher is not null;

insert into BookCopy
    select distinct l.isbn, c.itemLocation, c.itemCount
    from LibraryCollectionUniqueMatchedISBN l
        inner join LibraryCollection c
            using (bibNum);

insert into User
    values ('anonymous', 'Anonymous', 'Anonymous', 'anon@nymus.com', 'client', '123 Nowhere Street', 'Unknown Hills',
            'AN', '12345');

insert into Review
    select null, l.isbn, 'anonymous', null, g.comment, null
    from LibraryCollectionUniqueMatchedISBN l
        inner join GoodreadsRatings g
            on l.name = g.bookName;

insert into Checkout
    select distinct null, m.isbn, 'anonymous', l.itemLocation, c.checkoutDate,
                    date_add(c.checkoutDate, interval 20 day), date_add(c.checkoutDate, interval 30 day)
    from LibraryCollectionUniqueMatchedISBN m
        inner join LibraryCheckouts c
            using (bibNum)
        inner join LibraryCollection l
            using (bibNum);


# Create constraints
# ----------------------------------------

alter table Book add constraint book_publisher_fk foreign key (publisher) references Publisher(name);

alter table BookAuthor add constraint ba_book_fk foreign key (bookID) references Book(isbn);
alter table BookAuthor add constraint ba_author_fk foreign key (authorID) references Author(name);

alter table BookCopy add constraint copy_book_fk foreign key (bookID) references Book(isbn);
alter table BookCopy add constraint copy_library_fk foreign key (libraryID) references Library(shortName);

alter table Review add constraint review_book_fk foreign key (bookID) references Book(isbn);
alter table Review add constraint review_user_fk foreign key (userID) references User(username);

alter table Checkout add constraint checkout_book_fk foreign key (bookID) references Book(isbn);
alter table Checkout add constraint checkout_user_fk foreign key (userID) references User(username);
alter table Checkout add constraint checkout_library_fk foreign key (libraryID) references Library(shortName);

alter table OverDue add constraint overdue_checkout_fk foreign key (checkoutID) references Checkout(id);
alter table OverDue add constraint overdue_user_fk foreign key (userID) references User(username);


# Drop temporary tables
# ----------------------------------------

# drop table if exists GoodreadsBooks;
# drop table if exists GoodreadsRatings;
# drop table if exists LibraryCollection;
# drop table if exists LibraryCollectionUniqueISBN;
# drop table if exists LibraryCollectionUniqueMatchedISBN;
# drop table if exists LibraryItemClassifications;
# drop table if exists LibraryCheckouts;
