# Task-8-Stored-Procedures-and-Functions# Task 8 – Stored Procedures and Functions

**Objective**  
Learn how to create **reusable SQL blocks** using stored procedures and functions to modularize SQL logic.

**Tools**  
- DB Browser for SQLite / MySQL Workbench

---

## ✅ Description

In this task, we create:

1. **Stored Procedures** – encapsulate a set of SQL statements that can be executed with parameters.
2. **Stored Functions** – return a single value and can be used in queries, with logic that may include conditions and calculations.

This helps in:
- Reusability of SQL logic  
- Modularizing complex queries  
- Simplifying repetitive tasks  
- Adding conditional or dynamic logic  

---

## 🧭 Hints / Mini Guide

| Hint | Description |
|------|-----------------------------|
| 1    | Use `CREATE PROCEDURE` and `CREATE FUNCTION` |
| 2    | Use parameters and conditional logic inside procedures/functions |

---

## 🛠️ Stored Procedure Example

**Get currently borrowed books by a specific borrower**

```sql
-- Drop procedure if already exists
DROP PROCEDURE IF EXISTS GetCurrentLoansByBorrower;

DELIMITER //

CREATE PROCEDURE GetCurrentLoansByBorrower (
    IN p_BorrowerID INT
)
BEGIN
    SELECT b.Title,
           l.LoanDate
    FROM Loans l
    JOIN Books b     ON l.BookID = b.BookID
    WHERE l.BorrowerID = p_BorrowerID  -- Replace with actual column name if different
      AND l.ReturnDate IS NULL;
END //
