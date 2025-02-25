#DATABASE

CREATE DATABASE Book_Nest;
USE Book_Nest;

#Authors table

CREATE TABLE Authors(
author_id INT PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(100) NOT NULL, 
nationality VARCHAR(50), 
birth_year INT
);

#Books table

CREATE TABLE Books(
book_id INT PRIMARY KEY AUTO_INCREMENT, 
title VARCHAR(200) NOT NULL, 
author_id INT, 
genre VARCHAR(100), 
published_year INT,
FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);

#Members table

CREATE TABLE Members (
member_id INT PRIMARY KEY AUTO_INCREMENT, 
name VARCHAR(100) NOT NULL, 
email VARCHAR(100) UNIQUE, 
join_date DATE
);

#Borrowing table

CREATE TABLE Borrowings (
borrowing_id INT PRIMARY KEY AUTO_INCREMENT, 
book_id INT, 
member_id INT, 
borrow_date DATE, 
return_date DATE, 
FOREIGN KEY (book_id) REFERENCES Books(book_id), 
FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


#into Authors

INSERT INTO Authors (name, nationality, birth_year) VALUES 
('J.K. Rowling', 'British', 1965), 
('George Orwell', 'British', 1903), 
('Harper Lee', 'America', 1926), 
('F.Scott Fitzgerald', 'American', 1896), 
('Agatha Christie', 'British', 1890);

#into Books

INSERT INTO Books (title, author_id, genre, published_year) VALUES 
('Harry Potter and the Sorcerer''s Stone', 1, 'Fantasy', 1997), 
('1984', 2, 'Dystopian', 1949), 
('To Kill a Mockingbird', 3, 'Classic', 1960), 
('The Great Gatsby', 4, 'Classic', 1925), 
('Murder on the Orient Expess', 5, 'Mystery', 1934);

#into Members

INSERT INTO Members (name, email, join_date) VALUES 
('John Doe', 'john.doe@example.com', '2023-01-15'), 
('Jane Smith', 'jane.smith@example.com', '2023-02-10'), 
('Alice Johnson', 'alice.j@example.com', '2023-03-05');

#into Borrowings

INSERT INTO Borrowings (book_id, member_id, borrow_date, return_date) VALUES 
(1, 1, '2023-04-01', '2023-04-15'), 
(3, 2, '2023-04-05', NULL), 
(5, 3, '2023-04-10', '2023-04-25');

select * from Authors;
select * from Books;
select * from Borrowings;
select * from Members;

#retrieving all books with their authors

SELECT b.title, a.name AS author
FROM Books b
JOIN Authors a ON b.author_id = a.author_id;

#finding the books that are currently borrowed(not yet returned)

SELECT b.title, m.name AS member_name, br.borrow_date
FROM Borrowings br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL;

#finding the count of books borrowed by each member

SELECT  m.name, COUNT(br.borrowing_id) AS books_borrowed
FROM Members m
LEFT JOIN Borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id;

#books published after 1950

SELECT title, published_year
FROM Books
WHERE published_year > 1950;

#retrieving all books who's author is J.K. Rowling

SELECT b.title, b.genre, b.published_year
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
WHERE a.name = 'J.K. Rowling';

##STORED PROCEDURE TO BORROW A BOOK##

DELIMITER // 
CREATE PROCEDURE BorrowBook(IN book_id INT, IN member_id INT, IN borrow_date DATE)
BEGIN
	INSERT INTO Borrowings (book_id, member_id, borrow_date)
    VALUES (book_id, member_id, borrow_date);
END //
DELIMITER ;

CALL BorrowBook(2, 1, '2023-05-01')

##TRIGGER TO AUTOMATICALLY UPDATE THE RETURN DATE WHEN A BOOK IS RETURNED##

DELIMITER //
CREATE TRIGGER UpdateReturnDate
BEFORE UPDATE ON Borrowings
FOR EACH ROW
BEGIN
	IF NEW.return_date IS NOT NULL THEN 
		SET NEW.return_date = NOW();
	END IF;
END //
DELIMITER ;

##VIEW TO SHOW ALL BORROWED BOOKS WITH MEMBER AND BOOK DETAILS##

CREATE VIEW BorrowedBooksView AS
SELECT b.title, m.name AS member_name, br.borrow_date, br.return_date
FROM Borrowings br
JOIN Books b ON br.book_id = b.book_id
JOIN Members m ON br.member_id = m.member_id;

SELECT * FROM BorrowedBooksView;