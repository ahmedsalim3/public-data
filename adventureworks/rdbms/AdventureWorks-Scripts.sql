/*
*********************************************************************
******************* Queries & Data Exploration **********************
*********************************************************************
**********************Adventure-works DATABASE***********************
*********************************************************************

*----------------------------------Name:----------------------------*

Ahmed Salim
*-------------------------------------------------------------------*

*********************************************************************
Name: MySQL Sample Database AdventureWorks
DATASET: https://www.kaggle.com/datasets/ukveteran/adventure-works
*********************************************************************
*/

/******************************************************************************************/
/*********************************** STATISTICAL QUERIES***********************************/
/******************************************************************************************/

-- 1/ COUNT all sales in each year
SELECT '2015' AS Year, COUNT(*) AS Total_Sales FROM sales_2015
UNION ALL
SELECT '2016' AS Year, COUNT(*) AS Total_Sales FROM sales_2016
UNION ALL
SELECT '2017' AS Year, COUNT(*) AS Total_Sales FROM sales_2017;

-- 2/ MAX return quantity in each year
SELECT '2015' AS Year, SUM(ReturnQuantity) AS Total_Returns FROM returns
WHERE ReturnDate BETWEEN '2015-01-01' AND '2015-12-31' 
UNION ALL
SELECT '2016' AS Year, SUM(ReturnQuantity) AS Total_Returns FROM returns
WHERE ReturnDate BETWEEN '2016-01-01' AND '2016-12-31' 
UNION ALL 
SELECT '2017' AS Year, SUM(ReturnQuantity) AS Total_Returns FROM returns
WHERE ReturnDate BETWEEN '2017-01-01' AND '2017-12-31';

-- 3/ Calculate the average age of all customers
SELECT AVG(EXTRACT( YEAR FROM DATE('2023-01-17')) - (EXTRACT(YEAR FROM BirthDate))) AS average_age
FROM customers;

-- 4/ Find minimum product profit
SELECT products.ProductName, ProductPrice - ProductCost as profit
FROM products
WHERE (ProductPrice - ProductCost) = (SELECT MIN(ProductPrice - ProductCost) FROM products);

/******************************************************************************************/
/***************************************SCENARIO QUERIES***********************************/
/******************************************************************************************/
/***************************************PRODUCTS QUERIES***********************************/
/******************************************************************************************/

/* 1. Find all the products and identify them by their unique key values in ascending order.*/
SELECT * FROM products ORDER BY ProductKey ASC;

/* 2. Find all the products profit and identify them by their names in ascending order.*/
SELECT ProductName, ProductCost, ProductPrice, 
ProductPrice-ProductCost AS Profit
FROM products ORDER BY profit DESC;

 /* 3.  Find the 10 most expensive products in descending order.*/
SELECT ProductName, ProductPrice FROM products
ORDER BY ProductPrice DESC LIMIT 10;

 /* 4.Find the 10 cheapest products in ascending order*/
 SELECT ProductName, ProductPrice FROM products
 ORDER BY ProductPrice ASC LIMIT 10;
 
 /* 5.Find the average price from products and products  greater than the average.*/
SELECT  ProductName, ProductPrice FROM products
HAVING ProductPrice >  (SELECT
 AVG(ProductPrice) FROM products)
ORDER BY ProductPrice ASC;

/* 6.List all products whose size is medium, red in color and the product cost less than 800*/
 SELECT ProductKey, ProductName,
 ProductSize,
 ProductColor, ProductCost
 FROM products
 WHERE ProductSize > 20 
 AND ProductColor='red' 
 AND ProductCost < 800;
 
 /* 7. List all products based on subcategories.*/
SELECT ProductKey, ProductName, subcategoryName
FROM products
JOIN product_subcategories 
ON products.ProductSubcategoryKey
=product_subcategories.ProductSubcategoryKey;

/******************************************************************************************/
/***************************************CUSTOMER QUERIES***********************************/
/******************************************************************************************/

/* 8.  List all customers who owns house by gender by DESC order of Annual Income.*/
SELECT gender, FirstName, LastName, 
AnnualIncome, HomeOwner
FROM customers
WHERE HomeOwner = 'Y'
ORDER BY AnnualIncome DESC;

/* 9. Find married customers that own a house and their occupation by ascending  order of birth date.*/
SELECT FirstName,BirthDate, MaritalStatus,
EducationLevel, Occupation
FROM customers 
WHERE MaritalStatus= 'm' 
AND HomeOwner ='Y'
ORDER BY BirthDate ASC;

/*10. Find customers that are single and whose annual income is greater than 50,000 in ascending order.*/
SELECT FirstName, LastName,
MaritalStatus, AnnualIncome 
FROM customers
WHERE MaritalStatus='s' AND
AnnualIncome > 50000 
ORDER BY AnnualIncome ASC;
 
 /* 11. Among the female customers who are married, find the ones that have houses and their annual income is greater than average income.*/
SELECT CustomerKey, FirstName,
LastName, MaritalStatus,gender, HomeOwner, AnnualIncome
FROM customers
WHERE MaritalStatus = 'M' 
AND gender = 'F' 
AND HomeOwner='Y'
AND AnnualIncome > (select avg(AnnualIncome)from customers)
ORDER BY AnnualIncome;

 /* 12.  List all the customers that their annual income is less than 20,000 and bought products in 2015.*/
SELECT  FirstName, LastName, 
AnnualIncome, ProductName,
YEAR(OrderDate) AS Year
FROM sales_2015
JOIN products ON sales_2015.ProductKey = products.ProductKey
JOIN customers ON sales_2015.CustomerKey = customers.CustomerKey
HAVING AnnualIncome < 20000;
/******************************************************************************************/
/***************************************SALES QUERIES**************************************/
/******************************************************************************************/

/*13. List all sales from 2015 in ascending order by order Number, product key and customer Key and in day/month/year format*/
SELECT OrderNumber,products.ProductKey, 
customers.CustomerKey,DAY(OrderDate) AS Day, 
MONTH(OrderDate) AS MONTH, YEAR(OrderDate) AS Year,
sales_2015.OrderQuantity * products.ProductPrice AS Sales
from sales_2015 join products 
ON sales_2015.ProductKey = products.ProductKey
JOIN customers ON
sales_2015.CustomerKey = customers.CustomerKey 
ORDER BY Sales ASC;

/*14.  List all sales from 2016 order by orderNumber and in day/month/year format. */
SELECT OrderNumber,products.ProductKey, 
customers.CustomerKey,DAY(OrderDate) AS Day, 
MONTH(OrderDate) AS MONTH, YEAR(OrderDate) AS Year,
sales_2016.OrderQuantity * products.ProductPrice AS Sales
from sales_2016 join products 
ON sales_2016.ProductKey = products.ProductKey
JOIN customers ON
sales_2016.CustomerKey = customers.CustomerKey 
ORDER BY Sales DESC;

/*15.  List all sales from 2017 order by orderNumber and in day/month/year format. */
SELECT OrderNumber,products.ProductKey, 
customers.CustomerKey,DAY(OrderDate) AS Day, 
MONTH(OrderDate) AS MONTH, YEAR(OrderDate) AS Year,
sales_2017.OrderQuantity * products.ProductPrice AS Sales
from sales_2017 join products 
ON sales_2017.ProductKey = products.ProductKey
JOIN customers ON
sales_2017.CustomerKey = customers.CustomerKey 
ORDER BY Sales DESC;

/*16. List all the customers that purchased the most sold products in the year that has higher sales 2017*/
SELECT customers.CustomerKey, 
FirstName, LastName, 
ProductName, OrderQuantity, OrderDate
FROM sales_2017
JOIN customers ON 
sales_2017.CustomerKey = customers.CustomerKey
JOIN products ON 
sales_2017.ProductKey = products.ProductKey
WHERE OrderQuantity > (SELECT AVG(OrderQuantity)
FROM sales_2017);

/*17. Count the products that purchased the same item in 2016.*/
SELECT count(*) as quantity_sold, ProductName
FROM sales_2016
JOIN customers ON sales_2016.CustomerKey = customers.CustomerKey
JOIN products ON sales_2016.ProductKey = products.ProductKey
GROUP BY ProductName
ORDER BY quantity_sold DESC;


/*18. List all products that have been returned based on continent, country and region and order by the return date*/
SELECT products.ProductKey,
ProductName,ReturnDate,
Continent, Country, Region
FROM returns
JOIN products ON 
returns.ProductKey = products.ProductKey
JOIN territories ON 
returns.TerritoryKey = territories.TerritoryKey
ORDER BY ReturnDate;

/*19. Count the returned products group by region.*/
SELECT count(*) AS Total_Return, Region
FROM returns
JOIN territories ON
returns.TerritoryKey = territories.TerritoryKey
GROUP BY region;

/*20. Find out the profit of the top 5 products for 2017.*/
SELECT products.ProductKey, ProductName,ProductCost,
ProductPrice, ProductPrice - ProductCost AS Profit, OrderDate
FROM sales_2017
JOIN products ON sales_2017.ProductKey = products.ProductKey
LIMIT 5;

/* 21. Find the average returns in each year. */
SELECT '2017' AS Year, AVG(ReturnQuantity) AS Average_returns FROM returns
WHERE ReturnDate BETWEEN '2017-01-01' AND '2017-12-31'
UNION ALL
SELECT '2016' AS Year, AVG(ReturnQuantity) AS Average_returns FROM returns
WHERE ReturnDate BETWEEN '2016-01-01' AND '2016-12-31'
UNION ALL
SELECT '2015' AS Year, AVG(ReturnQuantity) AS Average_returns FROM returns
WHERE ReturnDate BETWEEN '2015-01-01' AND '2015-12-31';


/*22. Find the total quantities orded in each year and at all times within each region. */
WITH cte2015 AS (
    SELECT Region, territories.TerritoryKey, territories.Country, SUM(OrderQuantity) as total_quantity
    FROM territories
    JOIN sales_2015
    ON territories.TerritoryKey = sales_2015.TerritoryKey
    GROUP BY Region, territories.Country, territories.TerritoryKey
), cte2016 AS (
    SELECT Region, territories.TerritoryKey, territories.Country, SUM(OrderQuantity) as total_quantity
    FROM territories
    JOIN sales_2016
    ON territories.TerritoryKey = sales_2016.TerritoryKey
    GROUP BY Region, territories.Country, territories.TerritoryKey
), cte2017 AS (
    SELECT Region, territories.TerritoryKey, territories.Country, SUM(OrderQuantity) as total_quantity
    FROM territories
    JOIN sales_2017
    ON territories.TerritoryKey = sales_2017.TerritoryKey
    GROUP BY Region, territories.Country, territories.TerritoryKey
), cte_all_times AS (
    SELECT Region, territories.TerritoryKey, territories.Country, SUM(OrderQuantity) as total_quantity
    FROM territories
    JOIN (SELECT * FROM sales_2015
    UNION ALL
    SELECT * FROM sales_2016
    UNION ALL
    SELECT * FROM sales_2017) s
    ON territories.TerritoryKey = s.TerritoryKey
    GROUP BY Region, territories.Country, territories.TerritoryKey
)
SELECT cte2015.Region, cte2015.TerritoryKey,
       MAX(cte2015.total_quantity) as total_quantities2015,
       MAX(cte2016.total_quantity) as total_quantities2016,
       MAX(cte2017.total_quantity) as total_quantities2017,
       MAX(cte_all_times.total_quantity) as total_quantities_all_times
FROM cte2015
JOIN cte2016
ON cte2015.Region = cte2016.Region and cte2015.TerritoryKey = cte2016.TerritoryKey
JOIN cte2017
ON cte2016.Region = cte2017.Region and cte2016.TerritoryKey = cte2017.TerritoryKey
JOIN cte_all_times
ON cte2017.Region = cte_all_times.Region and cte2017.TerritoryKey = cte_all_times.TerritoryKey
GROUP BY cte2015.Region, cte2015.TerritoryKey
ORDER BY total_quantities2015 DESC;


