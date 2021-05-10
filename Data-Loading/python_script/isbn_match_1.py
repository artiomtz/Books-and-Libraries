import csv

with open('/Users/doragoczi/Desktop/ECE356-Project/isbn_matching/BooksProjectFullData_GoodreadsBooks-1.csv', 'r') as t1, open('/Users/doragoczi/Desktop/ECE356-Project/isbn_matching/BooksProjectFullData_LibraryCollectionUniqueISBN.csv', 'r') as t2, open('/Users/doragoczi/Desktop/ECE356-Project/isbn_matching/result1.csv', 'w') as result:
    goodreads = list(csv.reader(t1, delimiter=',', quotechar='"'))
    library = list(csv.reader(t2, delimiter=',', quotechar='"'))

    goodreads_row_count = sum(1 for row in goodreads)

    fieldnames = ['g_isbn', 'g_name', 'g_publisher', 'g_author', 'g_publishYear', 'g_language', 'g_numPages', 'g_numRatings', 'g_rating', 'l_name', 'l_bibNum', 'l_isbn', 'l_subjects', 'l_publisher', 'l_author', 'l_itemLocation', 'l_itemCount']
    writer = csv.DictWriter(result, fieldnames=fieldnames)
    writer.writeheader()

    for g in goodreads:
        goodreads_row_count -= 1
        for l in library:
            if g[0] in l[1]:
                line = f'{g[0]}, {l[1]}'
                print(f'{line} and {goodreads_row_count} more rows to cover')
                writer.writerow(
                    {'g_isbn': g[0], 'g_name': g[1], 'g_publisher': g[2], 'g_author': g[3], 'g_publishYear': g[4], 'g_numPages': g[5], 'g_numRatings': g[6], 'g_rating': g[7],
                     'l_bibNum': l[0], 'l_isbn': l[1], 'l_subjects': l[2], 'l_publisher': l[3], 'l_author': l[4], 'l_itemLocation': l[5], 'l_itemCount': l[6]}
                )
