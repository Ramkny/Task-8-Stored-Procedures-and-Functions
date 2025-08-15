CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100),
    AuthorID INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);


-- 1. INNER JOIN
SELECT 
    Books.BookID,
    Books.Title,
    Authors.Name AS AuthorName
FROM Books
INNER JOIN Authors
    ON Books.AuthorID = Authors.AuthorID;

-- 2. LEFT JOIN

SELECT 
    Books.BookID,
    Books.Title,
    Authors.Name AS AuthorName
FROM Books
LEFT JOIN Authors
    ON Books.AuthorID = Authors.AuthorID;


-- 3. RIGHT JOIN

SELECT 
    Books.BookID,
    Books.Title,
    Authors.Name AS AuthorName
FROM Books
RIGHT JOIN Authors
    ON Books.AuthorID = Authors.AuthorID;


SELECT 
    Books.BookID,
    Books.Title,
    Authors.Name AS AuthorName
FROM Books
LEFT JOIN Authors
    ON Books.AuthorID = Authors.AuthorID
UNION
SELECT 
    Books.BookID,
    Books.Title,
    Authors.Name AS AuthorName
FROM Books
RIGHT JOIN Authors
    ON Books.AuthorID = Authors.AuthorID;


-- Task 6 Task 6:Subqueries and Nested Queries
-- 1. Scalar Subquery in SELECT
SELECT 
    Title,
    (SELECT COUNT(*) FROM Books) AS TotalBooks
FROM Books;

-- 2. Subquery in WHERE with IN
SELECT Name 
FROM Authors
WHERE AuthorID IN (
    SELECT AuthorID 
    FROM Books
    WHERE Title LIKE '%Java%'
);

-- 3. Subquery in WHERE with =
SELECT * 
FROM Books
WHERE BookID = (
    SELECT MAX(BookID) FROM Books
);

-- 4. Correlated Subquery
SELECT Name,
       (SELECT COUNT(*) 
        FROM Books 
        WHERE Books.AuthorID = Authors.AuthorID) AS BookCount
FROM Authors;


-- 5. EXISTS Subquery


SELECT Name
FROM Authors a
WHERE EXISTS (
    SELECT 1
    FROM Books b
    WHERE b.AuthorID = a.AuthorID
);


/*  Task 7:Creating Views   
 1️⃣ View – BooksWithAuthors
Shows each book along with its author name.

*/
DESCRIBE Authors;

CREATE VIEW BooksWithAuthors AS
SELECT b.BookID,
       b.Title,
       a.AuthorName,
       b.PublishedYear
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID;

/* View – CurrentLoans
Lists all books that are currently borrowed (ReturnDate is NULL).
*/
CREATE VIEW CurrentLoans AS
SELECT l.LoanID,
       b.Title,
       br.BorrowerName,
       l.LoanDate
FROM Loans l
JOIN Books b       ON l.BookID = b.BookID
JOIN Borrowers br  ON l.BorrowerID = br.BorrowerID
WHERE l.ReturnDate IS NULL;


/*  View – BorrowerLoanHistory
Full loan history of each borrower (including returned books).
*/
CREATE VIEW BorrowerLoanHistory AS
SELECT br.BorrowerID,
       br.BorrowerName,
       b.Title,
       l.LoanDate,
       l.ReturnDate
FROM Borrowers br
JOIN Loans l  ON br.BorrowerID = l.BorrowerID
JOIN Books b  ON l.BookID = b.BookID;

CREATE VIEW BooksWithAuthors AS
SELECT b.BookID,
       b.Title,
       a.Name AS AuthorName,
       b.PublishedYear
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID;

-- Task 8: Stored Procedures and Functions

DELIMITER //

CREATE PROCEDURE GetCurrentLoansByBorrower (
    IN p_BorrowerID INT
)
DESCRIBE Loans;

BEGIN
    SELECT b.Title,
           l.LoanDate
    FROM Loans l
    JOIN Books b     ON l.BookID = b.BookID
    WHERE l.BorrowerID = p_BorrowerID
      AND l.ReturnDate IS NULL;
END //

DELIMITER ;
CALL GetCurrentLoansByBorrower(5);
DELIMITER //

CREATE PROCEDURE GetCurrentLoansByBorrower_v2 (
    IN p_BorrowerID INT
)
BEGIN
    SELECT b.Title,
           l.LoanDate
    FROM Loans l
    JOIN Books b     ON l.BookID = b.BookID
    WHERE l.BorrowerID = p_BorrowerID
      AND l.ReturnDate IS NULL;
END //

DELIMITER ;
