# ref: https://dev.mysql.com/doc/refman/5.7/en/sql-syntax.html

SELECT expression [, expression, ...]
FROM table
[... additional clauses ...] ;

# -----------1. Projection------------
# Projection is when you ask for only some of the columns of a table

SELECT DISTINCT Facility
FROM Admissions;

# Use “*” as an abbreviation for listing all columns

SELECT *
FROM Admissions;

# use regular expression

SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiou]+'

# LEFT, RIGHT, SUBSTR
SELECT DISTINCT CITY 
FROM STATION 
WHERE RIGHT(CITY,1) IN ('a','e','i','o','u');

# CASE expression
CASE WHEN [condition] THEN result [WHEN [condition] THEN result ...] [ELSE result] END

SELECT sex,
    SUM(CASE WHEN class = "<=50K" THEN 1 ELSE 0 END)/
    SUM(CASE WHEN class = ">50K" THEN 1 ELSE 0 END) AS ratio
FROM adult
GROUP BY sex;

# find the whole data for the row with some max value in a column per some group identifier
SELECT a.id, a.rev, a.contents
FROM YourTable a
INNER JOIN (
    SELECT id, MAX(rev) rev
    FROM YourTable
    GROUP BY id
) b ON a.id = b.id AND a.rev = b.rev

# --------------2. Function application---------------

SELECT UPPER(Facility),
       Lengthofstay * IllnessCode
FROM Admissions;

SELECT Facility,
       Lengthofstay * 24 AS stayinhours
FROM Admissions;

# -----------------3. Filtering---------------------

SELECT Facility, Lengthofstay
FROM Admissions
WHERE Lengthofstay > 2 AND 
      Lengthofstay < 6;

# ------------------4. Grouping--------------------

SELECT Facility,
       MIN(Lengthofstay),
       MAX(Lengthofstay),
       AVG(Lengthofstay)
FROM Admissions
GROUP BY Facility;

# Aggregate functions: MIN, MAX, SUM, AVG, STDEV, COUNT. can also be used to find overall values, i.e. without a GROUP BY clause

SELECT COUNT(*) FROM Admissions;

# Grouping and filtering

SELECT Facility,
       MIN(Lengthofstay)
FROM Admissions
WHERE Lengthofstay > 4
GROUP BY Facility;

# Filtering happens before grouping. This query gives us the minimum
# length of all stays greater than 4 days, for each facility. Syntactically, the 
# WHERE clause must precede the GROUP BY clause.

# Filtering on aggregate values

SELECT Facility,
       MIN(Lengthofstay)
FROM Admissions
GROUP BY Facility
HAVING MIN(Lengthofstay) > 4;

# Getting sorted output

SELECT Facility, Lengthofstay
FROM Admissions
ORDER BY Facility, Lengthofstay;

# -----------------5. Joins--------------------

SELECT * 
FROM Admissions JOIN Illnesses
ON Admissions.IllnessCode = Illnesses.Code;

/*
INNER JOIN
LEFT OUTER JOIN
RIGHT OUTER JOIN

*/

/* for full outer join */
SELECT * FROM Admissions LEFT OUTER JOIN Illnesses
ON Admissions.IllnessCode = Illnesses.Code
UNION
SELECT * FROM Admissions RIGHT OUTER JOIN Illnesses
ON Admissions.IllnessCode = Illnesses.Code;

SELECT Facility, IllnessCode
FROM Admissions
LIMIT 2;

/* -----------------Subqueries--------------------*/
SELECT select-statement2 FROM (SELECT select-statement1) AS name
/* joins using subqueries */
SELECT expression, ...
FROM (SELECT ...) name1 INNER JOIN (SELECT ...) name2 
ON condition involving name1 and name2;

SELECT * 
FROM hospital
INNER JOIN (
    SELECT MAX(Lengthofstay) AS maxstay 
    FROM hospital
    ) AS maxstaytable
ON Lengthofstay = maxstaytable.maxstay;
/* ************************************************  */
/* ------------------MySQL database management------------------------ */

CREATE DATABASE database-name;
DROP DATABASE database-name;
SHOW DATABASES;
USE database-name;

SHOW TABLES;
DESCRIBE table-name;

/* Creating tables */
CREATE TABLE table-name ( schema );
CREATE TABLE diagcodes (code int(3), descr char(30));

/* remove a table */
DROP TABLE table-name;

/* delete the data of a table but leave the table(as a schema) */
TRUNCATE TABLE table-name;

/* delete rows of a table that satisfy a WHERE clause */
DELETE FROM table-name
WHERE condition; 

/* Populating tables */
INSERT INTO
LOAD DATA
UPDATE

CREATE TABLE iris (
   SepalLength float,
   SepalWidth float,
   PetalLength float,
   PetalWidth float,
   Species char(255));

LOAD DATA LOCAL INFILE 'iris.csv'
INTO TABLE iris
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines;

INSERT INTO iris
VALUES (5.8, 3.0, 5.7, 2.0, 'carolinica'),
       (5.3, 3.2, 5.6, 2.3, 'marylandica');
       
UPDATE iris
SET PetalWidth = 0.3,
    PetalLength = 1.7
WHERE Species = 'marylandica';

/* Creating a table from a query */
CREATE TABLE longstays
AS SELECT facility, MAX(lengthofstay)
   FROM hospital
   GROUP BY facility;


