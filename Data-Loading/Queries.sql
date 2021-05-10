############## Checkout a book (by isbn)
# Example 1: user = anonymous, branch = cen, isbn = 0004990226 (11 copies) - SET THESE IN THE BACKEND
# Example 2: user = anonymous, branch = cen, isbn = 0002000199 (1 copy) - SET THESE IN THE BACKEND

# 1. check if available: returns number of copies
select numCopies from BookCopy where libraryID = 'cen' and bookID = '0004990226'; # returns 11
select numCopies from BookCopy where libraryID = 'cen' and bookID = '0002000199'; # returns 1

# 2. if 0 available: baiiiiii

# if more than 1 copy available:
update BookCopy set numCopies = 10 where libraryID = 'cen' and bookID = '0004990226'; # 11 -> 10

# if only 1 copy available:
delete from BookCopy where libraryID = 'cen' and bookID = '0002000199'; # row removed

# 3. register a checkout:
insert into Checkout values (null, '0004990226', 'anonymous', 'cen', CURRENT_TIMESTAMP(), null, date_add(CURRENT_TIMESTAMP(), interval 30 day));


############## return a book (by isbn)
# Example 1: user = anonymous, branch = cen, isbn = 0004990226 (10 copies) - SET THESE IN THE BACKEND
# Example 2: user = anonymous, branch = cen, isbn = 0002000199 (1 copy) - SET THESE IN THE BACKEND

# 1. check how many available: returns number of copies
select numCopies from BookCopy where libraryID = 'cen' and bookID = '0004990226'; # returns 10
select numCopies from BookCopy where libraryID = 'cen' and bookID = '0002000199'; # returns null

# 2. if more than 1 copy available:
update BookCopy set numCopies = 11 where libraryID = 'cen' and bookID = '0004990226'; # 10 -> 11

# if no copies available:
insert into BookCopy values ('0002000199', 'cen', 1);

# 3. check due date and update checkout record:
select id, dueDate from Checkout where userID = 'anonymous' and bookID = '0004990226' and returnDate is null; # checkout id and due date
update Checkout set returnDate = CURRENT_TIMESTAMP() where userID = 'anonymous' and bookID = '0004990226' and returnDate is null;

# 4. Check that book was returned on time

# if today < dueDate: all good

# if today > dueDate: add to OverDue table (i.e 17956593)
insert into OverDue values (17956593, 'anonymous');


############## write a review
# Example: user = anonymous, isbn = 0004990226, rating = 4, comment = "trashhhhhhhh" - SET THESE IN THE BACKEND

# 1. insert into Review table
insert into Review values (null, '0004990226', 'anonymous', 4, 'trashhhhhhhh', curdate());

# 2. update numRatings of the book
update Book set numRatings = numRatings + 1 where isbn = '0004990226'; # increase numRatings by 1

#3. update book rating
update Book set rating = (rating * numRatings + 4)/(numRatings + 1) where isbn = '0004990226'; # replace isbn and 4. DON'T touch the 1


############## delete a book
# Example: isbn = 0007149697
delete from BookAuthor where bookID = '0007149697';
delete from BookCopy where bookID = '0007149697';
delete from Review where bookID = '0007149697';
delete from Checkout where bookID = '0007149697';
delete from Book where isbn = '0007149697';

############## add a new book
# Example: isbn=0123456789, name=peep, language=null, publisher=poop, publishYear=2000, rating=0,
# numRatings=0, numPages=69, subjects=luvee, author=peepoop, copies=7, branch="bro"

# 1. verify publisher
select count(name) from Publisher where name = 'poop'; # 1 - publisher already exists, 0 - new publisher

# only if new publisher:
insert into Publisher values ('poop');

# 2. insert the new book
insert into Book values ('0123456789', 'peep', null, 'poop', 2000, 0, 0, 69, 'luvee');

# 3. verify author
select count(name) from Author where name = 'peepoop'; # 1 - author already exists, 0 - new author

# only if new author:
insert into Author values ('peepoop');

# 4. fix bookAuthor (anyway)
insert into BookAuthor values (null, '0123456789', 'peepoop');

# 5. set book copies
insert into BookCopy values ('0123456789', 'bro', 7);

############## delete a user
# Example: username = 'bra'
update Checkout set userID = 'anonymous' where userID = 'bra';
update Review set userID = 'anonymous' where userID = 'bra';
update OverDue set userID = 'anonymous' where userID = 'bra';
delete from User where username = 'bra';
