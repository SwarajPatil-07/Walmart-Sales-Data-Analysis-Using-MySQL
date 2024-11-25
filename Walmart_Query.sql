CREATE DATABASE Walmart_Database;
USE Walmart_Database;
CREATE TABLE IF NOT EXISTS Sales(
		Invoice_ID VARCHAR(30) NOT NULL PRIMARY KEY,
        Branch VARCHAR(10) NOT NULL,
        City VARCHAR(30) NOT NULL,
        Customer_Type VARCHAR(30) NOT NULL,
        Gender Varchar(20) NOT NULL,
        Product_Line VARCHAR(100) NOT NULL,
        Uite_Price DECIMAL(10,2) NOT NULL,
        Quantity INT NOT NULL,
        Tax_pct FLOAT(6,4) NOT NULL,
        Totle DECIMAL(12,4) NOT NULL,
        Purchase_Date DATE NOT NULL,
        Purchase_Time TIME NOT NULL,
        Payment_Type VARCHAR(20) NOT NULL,
        Cogs DECIMAL(10,2) NOT NULL,
        Gross_Margin_pct FLOAT(11,9),
        Gross_Income DECIMAL(12,4),
        Rating FLOAT(2,1)
        );
-- Data Cleaning 
SELECT * FROM Sales;

-- Add Time_of_day Column 
SELECT Purchase_Time,
	(CASE 
		WHEN 'Purchase_Time' BETWEEN '00:00:00' AND '12:00:00' THEN "Morning"
        WHEN 'Purchase_Time' BETWEEN '12:01:00' AND '16:00:00' THEN "Afternoon"
        ELSE "Evening"
        END) AS Time_of_Day
FROM Sales;

ALTER TABLE Sales ADD COLUMN Time_of_Day VARCHAR(30);

UPDATE Sales
	SET Time_of_Day = (
    CASE 
		WHEN 'Purchase_Time' BETWEEN '00:00:00' AND '12:00:00' THEN "Morning"
        WHEN 'Purchase_Time' BETWEEN '12:01:00' AND '16:00:00' THEN "Afternoon"
        ELSE "Evening"
        END);

-- Add Day_name Column

SELECT Purchase_Date,
	dayname(Purchase_Date)
FROM Sales;

ALTER TABLE Sales ADD COLUMN Day_Name Varchar(20);

UPDATE Sales
	SET Day_Name = dayname(Purchase_Date);
SELECT * FROM Sales;

-- Add Month_Name Column

SELECT Purchase_Date,
	monthname(Purchase_Date)
FROM Sales;

ALTER TABLE Sales ADD COLUMN Month_Name VARCHAR(20);

UPDATE Sales
	SET Month_Name = monthname(Purchase_Date);
    
-- ----------------------------------
-- ---- -- Generic Quations:---------
-- ----------------------------------

-- 1. How many unique cities does the data have?
SELECT DISTINCT City
FROM Sales;

-- 2. In which city is each branch?
SELECT DISTINCT City,
	Branch
FROM Sales;

-- ---------------------------------------------------------
-- ----------------- Buisness Quations ----------------------
-- ---------------------------------------------------------

-- 1. How many unique product lines does the data have?
SELECT DISTINCT Product_Line
FROM Sales;

-- 2. What is the most selling product line

SELECT SUM(Quantity) as qty, Product_Line from Sales GROUP BY Product_Line ORDER BY qty desc;

-- 3. What is the most common payment method?

select Payment_Type from Sales GROUP BY Payment_Type;

-- 4. What is the total revenue by month?
SELECT Month_Name, Sum(Total) as Revenue  from Sales GROUP BY Month_Name;

-- 5. What month had the largest COGS?

Select Sum(Cogs) as cogs , Month_Name FROM Sales GROUP BY Month_Name ORDER BY Cogs DESC Limit 1;

-- 6. What product line had the largest revenue?

Select Sum(Total) as Revenue, Product_Line from Sales GROUP BY Product_Line ORDER BY Revenue DESC Limit 1;

-- 7. What is the city with the largest revenue?
Select Sum(Total) as Revenue, Branch, City from Sales GROUP BY  City, Branch ORDER BY Revenue DESC Limit 1;

-- 8. What product line had the largest VAT(tax)?
SELECT Avg(Tax_pct) as Vat , Product_Line from Sales Group By Product_Line ORDER BY Vat DESC Limit 1;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

Select Avg(Quantity) as Avg_Sales from Sales;
SELECT Product_Line,
	CASE 
		WHEN  AVG(Quantity) > 5.5 Then "Good"
        ELSE "Bad"
        END AS Remark
        FROM Sales GROUP BY Product_Line;

	
-- 10. Which branch sold more products than average product sold?
SELECT Branch, Sum(Quantity) as Qty FROM Sales Group BY Branch HAVING Sum(Quantity) >( Select Avg(Quantity) From Sales);

-- 11. What is the most common product line by gender?
Select Gender, Product_Line, Count(Gender) as Gender_Count From Sales GROUP BY Gender, Product_Line ORDER BY Gender_Count Desc;
 
-- 12. What is the average rating of each product line?
Select Product_Line, Avg(rating) as Avg_Rating from Sales GROUP BY Product_Line;

-- 13. Number of sales made in each time of the day per weekday

Select Day_Name, Time_of_Day,  Sum(Quantity) as sales from Sales GROUP BY Day_Name, Time_of_Day;

-- 14. Which of the customer types brings the most revenue?
Select Customer_Type, Sum(Total) as revenue from Sales Group By Customer_Type Order By revenue desc;

-- 15. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
Select City, Max(Tax_pct) as VAT from Sales GROUP BY City ORDER BY VAT Desc LIMIT 1;

-- 16. Which customer type pays the most in VAT?
Select Customer_Type, Max(Tax_pct) as VAT from Sales GROUP BY Customer_Type ORDER BY VAT Desc LIMIT 2;

-- 17. How many unique customer types does the data have?
Select Distinct Customer_Type From Sales;

-- 18. How many unique payment methods does the data have?
Select Distinct Payment_Type from Sales;

-- 19. What is the most common customer type?
Select Customer_Type, Count(Customer_Type) as count from Sales GROUP BY Customer_type ORDER BY count desc;

-- 20. Which customer type buys the most?
Select Customer_Type, COUNT(*) from Sales GROUP BY Customer_type;

-- 21. What is the gender of most of the customers?
SELECT Distinct Gender, Count(Gender) as count from Sales GROUP BY Gender ORDER BY count Desc;

-- 22. What is the gender distribution per branch

select Branch , Gender, COUNT(Gender) as count from Sales GROUP BY Branch, Gender ORDER BY branch ;
-- select Gender, Count(*) as count from Sales where Branch = 'C' GROUP BY Gender ORDER BY count desc;

-- 23. Which time of the day do customers give most ratings?
select Time_of_Day, avg(rating) as avg_rating from Sales GROUP BY Time_of_Day ORDER BY avg_rating desc;

-- 24. Which time of the day do customers give most ratings per branch?
select Branch, Time_of_Day, avg(rating) as avg_rating from Sales GROUP BY Branch, Time_of_Day ORDER BY Branch;
-- select Time_of_Day, avg(Rating) as avg_rating from Sales Where Branch = 'A' GROUP BY Time_of_Day order By avg_rating desc;

-- 25. Which day fo the week has the best avg ratings?
select Day_Name, avg(Rating) as rating from Sales GROUP BY Day_Name ORDER BY rating desc LIMIT 1;

-- 26. Which day of the week has the best average ratings per branch?
select Branch, Day_Name, avg(Rating) as rating from Sales GROUP BY Branch, Day_Name ORDER BY rating desc Limit 3;


