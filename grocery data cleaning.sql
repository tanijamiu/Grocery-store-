/* Data Cleaning
Creating stagging tables
Check for and remove duplicates
Standardize the data,address inconsistencies and null values
Remove unnecessary rows and columns
*/

-- Categories
SELECT * FROM category_stagg;

CREATE TABLE category_stagg
LIKE categories;

INSERT INTO category_stagg
SELECT *
FROM categories;

-- standardizaton
SELECT
	CategoryName,
    TRIM(CategoryName)
FROM category_stagg;

UPDATE category_stagg
SET CategoryName = TRIM(LOWER(CategoryName));

-- cities
SELECT * FROM city_stagg;

CREATE TABLE city_stagg
LIKE cities;

INSERT INTO city_stagg
SELECT *
FROM cities;

-- standardization
UPDATE city_stagg
SET CityName = TRIM(LOWER(CityName));


-- Countries
SELECT * FROM country_stagg;

CREATE TABLE country_stagg
LIKE countries;

INSERT INTO country_stagg
SELECT *
FROM countries;

-- customers
SELECT * FROM customer_stagg;

CREATE TABLE customer_stagg
LIKE customers;

INSERT INTO customer_stagg
SELECT *
FROM customers;

-- standardization
UPDATE customer_stagg
SET FirstName = TRIM(FirstName);

UPDATE customer_stagg
SET MiddleInitial = TRIM(MiddleInitial);

UPDATE customer_stagg
SET LastName = TRIM(LastName);

UPDATE customer_stagg
SET Address = TRIM(Address);


-- employees
SELECT * FROM employees_stagg;

CREATE TABLE employees_stagg
LIKE employees;

INSERT INTO employees_stagg
SELECT *
FROM employees;

-- standardization
UPDATE employees_stagg
SET FirstName = TRIM(FirstName);

UPDATE employees_stagg
SET MiddleInitial = TRIM(MiddleInitial);

UPDATE employees_stagg
SET LastName = TRIM(LastName);

UPDATE employees_stagg
SET Gender = TRIM(Gender);

ALTER TABLE employees_stagg
MODIFY COLUMN BirthDate DATE;

ALTER TABLE employees_stagg
MODIFY COLUMN HireDate DATE;


-- Products
SELECT * FROM products_stagg;

CREATE TABLE products_stagg
LIKE products;

INSERT INTO products_stagg
SELECT *
FROM products;

-- standardization
UPDATE products_stagg
SET ProductName = TRIM(ProductName);

UPDATE products_stagg
SET Class = LOWER(TRIM(Class));

UPDATE products_stagg
SET Resistant = LOWER(TRIM(Resistant));

UPDATE products_stagg
SET IsAllergic = LOWER(TRIM(IsAllergic));

ALTER TABLE products_stagg
MODIFY COLUMN ModifyDate DATE;


-- Sales
SELECT * FROM sales_stagg;

CREATE TABLE sales_stagg
LIKE sales;

INSERT INTO sales_stagg
SELECT *
FROM sales; 

UPDATE sales_stagg
SET SalesDate = TRIM(SalesDate);

SELECT *
FROM sales_stagg
WHERE SalesDate = '';

DELETE FROM sales_stagg
WHERE SalesDate = '';

ALTER TABLE sales_stagg
MODIFY COLUMN SalesDate DATE;