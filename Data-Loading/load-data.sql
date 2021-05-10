drop table if exists GoodreadsBooks;
drop table if exists GoodreadsRatings;
drop table if exists Library;
drop table if exists LibraryCollection;
drop table if exists LibraryCollectionUniqueISBN;
drop table if exists LibraryCollectionUniqueMatchedISBN;
drop table if exists LibraryItemClassifications;
drop table if exists LibraryCheckouts;


# Import Goodreads books
# ----------------------------------------

create table GoodreadsBooks (
     isbn varchar(13) primary key,
     name varchar(255) null,
     publisher varchar(255) null,
     author varchar(255) null,
     language char (3) null,
     numPages integer null,
     numRatings integer null,
     publishYear decimal(4) null,
     rating decimal (5, 2) null,
     check (char_length(isbn) = 10 or char_length(isbn) = 13),
     index goodreads_name_idx (name)
);

# Loading data
load data infile '/var/lib/mysql-files/20-Books/book1-100k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1-100k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 57000 lines
     ignore 1 lines
     (@dummy, @name, @dummy, @numPages, @dummy, @numRatings, @dummy, @dummy, @publisher, @dummy, @publishYear, @language, @author, @rating, @dummy, @dummy, @isbn, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book100k-200k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book100k-200k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 56000 lines
     ignore 1 lines
     (@numPages, @author, @publisher, @rating, @language, @numRatings, @dummy, @dummy, @dummy, @dummy, @isbn, @dummy, @dummy, @dummy, @publishYear, @dummy, @dummy, @name)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book200k-300k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book200k-300k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 55000 lines
     ignore 1 lines
     (@publisher, @numRatings, @dummy, @dummy, @name, @rating, @numPages, @language, @dummy, @dummy, @dummy, @dummy, @isbn, @dummy, @dummy, @author, @dummy, @publishYear)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book300k-400k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book300k-400k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 55000 lines
     ignore 1 lines
     (@dummy, @dummy, @isbn, @author, @dummy, @numPages, @language, @dummy, @name, @publishYear, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @rating, @publisher)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book400k-500k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book400k-500k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 54000 lines
     ignore 1 lines
     (@publishYear, @rating, @numRatings, @isbn, @dummy, @publisher, @dummy, @dummy, @name, @author, @dummy, @dummy, @dummy, @dummy, @numPages, @dummy, @dummy, @language)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book500k-600k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book500k-600k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 53000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book600k-700k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book600k-700k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 55000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book700k-800k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book700k-800k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 55000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book800k-900k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book800k-900k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 50000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book900k-1000k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book900k-1000k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 41000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1000k-1100k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1000k-1100k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 40000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1100k-1200k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1100k-1200k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 42000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1200k-1300k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1200k-1300k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 44000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1300k-1400k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1300k-1400k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 38000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1400k-1500k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1400k-1500k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 35000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1500k-1600k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1500k-1600k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 33000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1600k-1700k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1600k-1700k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 33000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1700k-1800k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1700k-1800k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 32000 lines
     ignore 1 lines
     (@author, @dummy, @dummy, @isbn, @dummy, @language, @name, @dummy, @dummy, @publishYear, @publisher, @rating, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @numPages)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1800k-1900k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1800k-1900k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 39000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book1900k-2000k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book1900k-2000k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 43000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book2000k-3000k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book2000k-3000k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 404000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book3000k-4000k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book3000k-4000k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 260000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @dummy, @language, @numPages, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');

load data infile '/var/lib/mysql-files/20-Books/book4000k-5000k.csv' ignore into table GoodreadsBooks
# load data infile 'D:\\Downloads\\356\\GoodReads\\book4000k-5000k.csv' ignore into table GoodreadsBooks
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 283000 lines
     ignore 1 lines
     (@dummy, @name, @author, @isbn, @rating, @publishYear, @dummy, @dummy, @publisher, @dummy, @dummy, @dummy, @dummy, @dummy, @numRatings, @reviewCount, @language, @numPages, @dummy)
      set isbn = nullif(@isbn, (char_length(@isbn) != 10 and char_length(@isbn) != 13) or @isbn = ''),
          language = if(@language like 'en-%', 'eng', nullif(@language, '')),
          publishYear = if(@publishYear > YEAR(CURDATE()) or @publishYear < 1000 or @publishYear = '', null, @publishYear),
          numPages = if(@numpages <= 0 or @numpages = '', null, @numpages),
          numRatings = if(@numRatings = '', 0, if(SUBSTRING_INDEX(@numRatings,':',-1) <= 0 or SUBSTRING_INDEX(@numRatings,':',-1) = '', 0, SUBSTRING_INDEX(@numRatings,':',-1))),
          rating = if(@rating < 0 or @rating > 5 or @rating = '', 0, @rating),
          publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, '');


# Import Goodreads reviews
# ----------------------------------------

create table GoodreadsRatings (
    bookName varchar(255) null,
    comment varchar(255) null,
    check (bookName != '' and bookName != 'Rating'),
    check (comment != '' and comment != 'This user doesn\'t have any rating'),
    index goodreviews_name_idx (bookName)
);

load data infile '/var/lib/mysql-files/20-Books/user_rating_0_to_1000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_0_to_1000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 51000 lines
     ignore 1 lines
    (@dummy, bookName, comment);

load data infile '/var/lib/mysql-files/20-Books/user_rating_1000_to_2000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_1000_to_2000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 42000 lines
     ignore 1 lines
    (@dummy, bookName, comment);

load data infile '/var/lib/mysql-files/20-Books/user_rating_2000_to_3000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_2000_to_3000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 29000 lines
     ignore 1 lines
    (@dummy, bookName, comment);

load data infile '/var/lib/mysql-files/20-Books/user_rating_3000_to_4000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_3000_to_4000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 46000 lines
     ignore 1 lines
    (@dummy, bookName, comment);

load data infile '/var/lib/mysql-files/20-Books/user_rating_4000_to_5000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_4000_to_5000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 46000 lines
     ignore 1 lines
    (@dummy, bookName, comment);

load data infile '/var/lib/mysql-files/20-Books/user_rating_5000_to_6000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_5000_to_6000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 14000 lines
     ignore 1 lines
    (@dummy, bookName, comment);

load data infile '/var/lib/mysql-files/20-Books/user_rating_6000_to_11000.csv' ignore into table GoodreadsRatings
# load data infile 'D:\\Downloads\\356\\GoodReads\\user_rating_6000_to_11000.csv' ignore into table GoodreadsRatings
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 126000 lines
     ignore 1 lines
    (@dummy, bookName, comment);


# Import Seattle libraries addresses
# ----------------------------------------

create table Library (
    shortName varchar(3) primary key,
    longName varchar(255) null,
    phone varchar(20) null,
    street varchar(255) null,
    city varchar (20) null,
    state varchar(2) null,
    zip varchar(10) null
);

load data infile '/var/lib/mysql-files/20-Books/Project30/Library_Addresses.csv' ignore into table Library # FILE IN REPO
# load data infile 'D:\\Downloads\\356\\Library_Addresses.csv' ignore into table Library
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
    ignore 1 lines
    (shortName, @longName, @phone, @street, @city, @state, @zip)
    set longName = nullif(@longName, ''),
        phone = if(char_length(@phone) >= 12, @phone, null),
        street = nullif(@street, ''),
        city = nullif(@city, ''),
        state = if(char_length(@state) = 2, @state, null),
        zip = if(char_length(@zip) = 5 or char_length(@zip) = 10, @zip, null);


# Import Seattle library books
# ----------------------------------------

create table LibraryCollection (
    isbn varchar(255) null,
    bibNum integer not null,
    subjects varchar(255) null,
    publisher varchar(255) null,
    name varchar(255) null,
    author varchar(255) null,
    itemLocation char(5) not null,
    itemCount integer not null,
    format varchar(255) null,
    check (char_length(isbn) > 0),
    check (char_length(itemLocation) > 0),
    primary key (bibNum, itemLocation)
);

load data infile '/var/lib/mysql-files/20-Books/Library_Collection_Inventory.csv' ignore into table LibraryCollection
# load data infile 'D:\\Downloads\\356\\Library\\Library_Collection_Inventory.csv' ignore into table LibraryCollection
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 2670000 lines
     ignore 1 lines
     (@bibNum, @name, @author, isbn, @dummy, @publisher, @subjects, @format, @dummy, @dummy, @itemLocation, @dummy, @itemCount)
      set publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, ''),
          bibNum = nullif(@bibNum, ''),
          subjects = nullif(@subjects, ''),
          itemLocation = if(@itemLocation in (select shortName from Library), @itemLocation, null),
          format = nullif(@format, ''),
          itemCount = if(@itemCount < 0 or @itemCount = '', 1, @itemCount);


# Isolate Seattle library unique books
# ----------------------------------------

create table LibraryCollectionUniqueISBN (
    isbn varchar(255) primary key,
    bibNum integer null,
    subjects varchar(255) null,
    publisher varchar(255) null,
    name varchar(255) null,
    author varchar(255) null,
    itemCount integer null,
    format varchar(255) null,
    check (char_length(isbn) > 0)
);

# insert into LibraryCollectionUniqueISBN
#     select isbn, bibNum, subjects, publisher, name, author, itemCount, format
#     from LibraryCollection
#     group by isbn;

load data infile '/var/lib/mysql-files/20-Books/Library_Collection_Inventory.csv' ignore into table LibraryCollectionUniqueISBN
# load data infile 'D:\\Downloads\\356\\Library\\Library_Collection_Inventory.csv' ignore into table LibraryCollectionUniqueISBN
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 2670000 lines
     ignore 1 lines
     (@bibNum, @name, @author, isbn, @dummy, @publisher, @subjects, @format, @dummy, @dummy, @itemLocation, @dummy, @itemCount)
      set publisher = nullif(@publisher, ''),
          author = nullif(@author, ''),
          name = nullif(@name, ''),
          bibNum = nullif(@bibNum, ''),
          subjects = nullif(@subjects, ''),
          format = nullif(@format, ''),
          itemCount = if(@itemCount < 0 or @itemCount = '', 1, @itemCount);


# Match Seattle library books on isbn with Goodreads books
# Python processing creates the new file
# ----------------------------------------

create table LibraryCollectionUniqueMatchedISBN (
    isbn varchar(13) primary key,
    bibNum integer null,
    name varchar(255) null,
    publisher varchar(255) null,
    author varchar(255) null,
    l_publisher varchar(255) null,
    l_author varchar(255) null,
    l_name varchar(255) null,
    language char (3) null,
    numPages integer null,
    numRatings integer null,
    publishYear decimal(4) null,
    subjects varchar(255) null,
    check (char_length(isbn) = 10 or char_length(isbn) = 13),
    index matched_bibnum_idx (bibNum)
);

load data infile '/var/lib/mysql-files/20-Books/Project30/matched_isbn_full.csv' ignore into table LibraryCollectionUniqueMatchedISBN # FILE IN REPO
# load data infile 'D:\\Downloads\\356\\Library\\matched_isbn_full.csv' ignore into table LibraryCollectionUniqueMatchedISBN
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (isbn, @name, @publisher, @author, @language, @dummy, @numPages, @numRatings, @publishYear, @dummy, @bibnum, @dummy, @subjects, @l_publisher, @l_name, @l_author, @dummy)
      set publisher = if(@publisher = '', if(@l_publisher = '', null, @l_publisher), @publisher),
          author = if(@author = '', if(@l_author = '', null, @l_author), @author),
          name = if(@name = '', if(@l_name = '', null, @l_name), @name),
          l_publisher = nullif(@l_publisher, ''),
          l_author = nullif(@l_author, ''),
          l_name = nullif(@l_name, ''),
          publishYear = nullif(@publishYear, ''),
          language = nullif(@language, ''),
          numPages = nullif(@numPages, ''),
          numRatings = nullif(@numRatings, ''),
          bibNum = nullif(@bibNum, ''),
          subjects = nullif(@subjects, '');

alter table LibraryCollectionUniqueMatchedISBN add column rating decimal (5, 2) null;
update LibraryCollectionUniqueMatchedISBN l inner join GoodreadsBooks g using (isbn) set l.rating = g.rating;


# Import Seattle library printed books codes
# ----------------------------------------

create table LibraryItemClassifications (
    itemType varchar(255) primary key,
    format varchar(255) null,
    check (format = 'Book')
);

load data infile '/var/lib/mysql-files/20-Books/Integrated_Library_System__ILS__Data_Dictionary.csv' ignore into table LibraryItemClassifications
# load data infile 'D:\\Downloads\\356\\Library\\Integrated_Library_System__ILS__Data_Dictionary.csv' ignore into table LibraryItemClassifications
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
     ignore 1 lines
     (@itemType, @dummy, @dummy, @dummy, format, @dummy, @dummy)
      set itemType = nullif(@itemType, '');


# Import Seattle library checkouts
# ----------------------------------------

create table LibraryCheckouts (
    bibNum integer not null,
    itemType varchar(255) not null,
    checkoutDate datetime not null,
    check (bibNum != ''),
    check (itemType != ''),
    check (checkoutDate <= sysdate() and checkoutDate >= cast('2005-00-00 00:00:00' as datetime)),
    index loadcheckouts_bibnum_idx (bibNum)
);

load data infile '/var/lib/mysql-files/20-Books/Checkouts_By_Title_Data_Lens_2015.csv' ignore into table LibraryCheckouts
# load data infile 'D:\\Downloads\\356\\Library\\Checkouts_By_Title_Data_Lens_2015.csv' ignore into table LibraryCheckouts
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 6870000 lines # 6871627
     ignore 1 lines
     (bibNum, @dummy, @itemType, @dummy, @dummy, @checkoutDate)
      set itemType = if(@itemType in (select itemType from LibraryItemClassifications), @itemType, null),
          checkoutDate = if(@checkoutDate = '', null, str_to_date(@checkoutDate, '%m/%d/%Y %h:%i:%s %p'));

load data infile '/var/lib/mysql-files/20-Books/Checkouts_By_Title_Data_Lens_2016.csv' ignore into table LibraryCheckouts
# load data infile 'D:\\Downloads\\356\\Library\\Checkouts_By_Title_Data_Lens_2016.csv' ignore into table LibraryCheckouts
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 6402000 lines # 6404831
     ignore 1 lines
     (bibNum, @dummy, @itemType, @dummy, @dummy, @checkoutDate)
      set itemType = if(@itemType in (select itemType from LibraryItemClassifications), @itemType, null),
          checkoutDate = if(@checkoutDate = '', null, str_to_date(@checkoutDate, '%m/%d/%Y %h:%i:%s %p'));

load data infile '/var/lib/mysql-files/20-Books/Checkouts_By_Title_Data_Lens_2017.csv' ignore into table LibraryCheckouts
# load data infile 'D:\\Downloads\\356\\Library\\Checkouts_By_Title_Data_Lens_2017.csv' ignore into table LibraryCheckouts
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
#      ignore 5032000 lines # 5034543
     ignore 1 lines
     (bibNum, @dummy, @itemType, @dummy, @dummy, @checkoutDate)
      set itemType = if(@itemType in (select itemType from LibraryItemClassifications), @itemType, null),
          checkoutDate = if(@checkoutDate = '', null, str_to_date(@checkoutDate, '%m/%d/%Y %h:%i:%s %p'));