SELECT * FROM category_stagg;
SELECT * FROM city_stagg;
SELECT * FROM country_stagg;
SELECT * FROM customer_stagg;
SELECT * FROM employees_stagg;
SELECT * FROM products_stagg;
SELECT * FROM sales_stagg;

-- Task  Monthly sales performance
-- Question 1 (Calculate total sales for each month)
WITH monthly_sales AS
(
SELECT
	ps.ProductID,
    Price,
    SalesDate,
    Quantity
FROM products_stagg ps
JOIN sales_stagg ss 
ON ss.ProductID = ps.ProductID
),
sales_performance AS
(
SELECT 
	ss.ProductID,
	Quantity
FROM sales_stagg ss
)
SELECT
	DATE_FORMAT(SalesDate, '%M') months,
    ROUND(SUM(Price * Quantity), 2) total_sales
FROM monthly_sales
GROUP BY months
ORDER BY total_sales DESC, STR_TO_DATE(months, '%M');


-- Question 2 (Compare sales performance across different product categories each month)
SELECT * FROM sales_stagg;
SELECT * FROM category_stagg;
SELECT * FROM products_stagg;

WITH sales_performance AS
(
SELECT 
	ps.CategoryID,
    Price,
    Quantity,
    SalesDate,
    CategoryName
FROM sales_stagg ss
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
JOIN category_stagg cs ON cs.CategoryID = ps.CategoryID
),
product_category AS
(
SELECT 
    DATE_FORMAT(SalesDate, '%M') months,
    CategoryName,
    ROUND(SUM(Price * Quantity), 2) total_sales
FROM sales_performance
GROUP BY months, CategoryName
)
SELECT *,
	RANK() OVER(PARTITION BY months ORDER BY total_sales DESC) product_rank 
FROM product_category;


-- Task 2 (Top Products Identification)
-- Question 1 (Rank products based on total sales revenue.)
SELECT * FROM products_stagg;
SELECT * FROM sales_stagg;

WITH product_rank AS
(
SELECT 
    ps.ProductID,
    ProductName,
    ROUND(SUM(Price * Quantity), 2) total_sales
FROM products_stagg ps
JOIN sales_stagg ss
ON ps.ProductID = ss.ProductID
GROUP BY ps.ProductID, ProductName
),
top_products AS
(
SELECT *,
	RANK() OVER(ORDER BY total_sales DESC) ranking
FROM product_rank
)
SELECT *
FROM top_products
;


-- Question 2 (Analyze sales quantity and revenue to identify high-demand products.)
SELECT
	ProductName,
    SUM(Quantity) No_of_transaction,
    ROUND(SUM(Quantity * Price), 2) total_revenue
FROM sales_stagg ss
JOIN products_stagg ps 
ON ss.ProductID = ps.ProductID
GROUP BY ProductName
ORDER BY total_revenue DESC
;


-- Question 3 (Examine the impact of product classifications on sales performance.)
SELECT
	CategoryName,
    COUNT(SalesID) total_transactions,
    ROUND(SUM(Price * Quantity), 2) total_revenue,
    SUM(Quantity) total_unit_sold,
    ROUND(SUM(Price * Quantity) / COUNT(SalesID), 2) avg_order_value
FROM sales_stagg ss
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
JOIN category_stagg cs ON ps.CategoryID = cs.CategoryID
GROUP BY CategoryName
ORDER BY total_revenue DESC
;


-- Task 3 Customer Purchase Behavior
-- Question 1 (Segment customers based on their purchase frequency and total spend)
SELECT * FROM customer_stagg;
SELECT * FROM sales_stagg;
SELECT * FROM products_stagg;

SELECT 
    CONCAT(FirstName, ' ', LastName) fullname,
    COUNT(DISTINCT ss.CustomerID) purchase_frequency,
    ROUND(SUM(Quantity * Price), 2) total_spend
FROM customer_stagg cs
JOIN sales_stagg ss ON cs.CustomerID = ss.CustomerID
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
GROUP BY fullname
ORDER BY purchase_frequency DESC, total_spend DESC
;

-- Question 3 (Analyze average order value and basket size)
SELECT 
    ROUND(SUM(Price * Quantity) / COUNT(SalesID), 2) avg_order_value,
    SUM(Quantity) / SUM(SalesID) basket_size
FROM products_stagg ps
JOIN sales_stagg ss ON ps.ProductID = ss.ProductID
JOIN category_stagg cs ON ps.CategoryID = cs.CategoryID
;


-- Task 4 Salesperson Effectiveness
SELECT * FROM employees_stagg;
SELECT * FROM sales_stagg;
SELECT * FROM products_stagg;

-- Question 1 (Calculate total sales attributed to each salesperson.)
WITH salesperson AS
(
SELECT
	CONCAT(FirstName, ' ', LastName) Fullname,
    ROUND(SUM(Quantity * Price), 2) total_sales
FROM sales_stagg ss
JOIN employees_stagg es ON ss.EmployeeID = es.EmployeeID
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
GROUP BY Fullname
ORDER BY total_sales DESC
)
SELECT *,
	RANK() OVER(ORDER BY total_sales DESC) ranking
FROM salesperson
;

-- Question 2 (Identify top-performing and underperforming sales staff.)
WITH top_performing_staff AS
(
SELECT
	CONCAT(FirstName, ' ', LastName) Fullname,
    ROUND(SUM(Quantity * Price), 2) total_sales
FROM sales_stagg ss
JOIN employees_stagg es ON ss.EmployeeID = es.EmployeeID
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
GROUP BY Fullname
)
SELECT *,
RANK() OVER(ORDER BY total_sales DESC) ranks
FROM top_performing_staff
LIMIT 3;


WITH underperforming_staff AS
(
SELECT
	CONCAT(FirstName, ' ', LastName) Fullname,
    ROUND(SUM(Quantity * Price), 2) total_sales
FROM sales_stagg ss
JOIN employees_stagg es ON ss.EmployeeID = es.EmployeeID
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
GROUP BY Fullname
)
SELECT *,
RANK() OVER(ORDER BY total_sales ASC) ranks
FROM underperforming_staff
LIMIT 3;

-- Question 3 (Analyze sales trends based on individual salesperson contributions over time.)
SELECT
	CONCAT(FirstName, ' ', LastName) Fullname,
	DATE_FORMAT(SalesDate, '%M') months,
    ROUND(SUM(Quantity * Price), 2) total_sales
FROM sales_stagg ss
JOIN products_stagg ps 
ON ss.ProductID = ps.ProductID
JOIN employees_stagg es
ON es.EmployeeID = ss.EmployeeID
GROUP BY Fullname, months
ORDER BY months, total_sales DESC
;


-- Task 5 Geographical Sales Insights
SELECT * FROM category_stagg;
SELECT * FROM city_stagg;
SELECT * FROM country_stagg;
SELECT * FROM customer_stagg;
SELECT * FROM employees_stagg;
SELECT * FROM products_stagg;
SELECT * FROM sales_stagg;

-- Question 1 (Map sales data to specific cities and countries to identify high-performing regions.)
WITH high_performing AS
(
SELECT 
	CityID,
    ROUND(SUM(Quantity * Price), 2) Revenue
FROM customer_stagg cs
JOIN sales_stagg ss ON cs.CustomerID = ss.CustomerID
JOIN products_stagg ps ON ss.ProductID = ps.ProductID
GROUP BY CityID
)
SELECT 
	cit.CityID,
    CityName,
    Revenue
FROM high_performing hp
JOIN city_stagg cit ON hp.CityID = cit.CityID
ORDER BY Revenue DESC
;
