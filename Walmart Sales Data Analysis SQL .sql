
	--- WALMART SALES DATA ANALYSIS:

	--- IMPORTING OF THE DATASET IS BEEN DONE
	--- A DATABASE IS CREATED NAMED WALMARTDATABASE FOR ANALYSIS
	--- A TABLE NAME IS CREATED NAMED WALMARTSALESDATA

	--- USING THE WALMARTDATABASE FOR ANALYSIS

	use walmartdatabase;

	--- GETTING TO KNOW THE ENTIRE COLUMNS PRESENT IN THIS DATASET FOR ANALYSIS

	select * from walmartsalesdata;


	-- FEATURE ENGINEERING

	-- 1)ADDING TIME

	ALTER TABLE walmartsalesdata add time_of_day VARCHAR(30);

	select time,
		CASE
			WHEN TIME BETWEEN '00:00:00' and '12:00:00' THEN 'Morning'
			WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
		END AS time_of_day
	from walmartsalesdata;

	UPDATE walmartsalesdata
	SET time_of_day=(CASE 
			WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	ENd);

	select DATENAME(DY,DATE) 'DATE OF YEAR'
	from walmartsalesdata;

	select DATENAME(DW,DATE) 'DATE OF WEEK'
	from walmartsalesdata;

	select DATENAME(DD,DATE) 'DATE OF DATE'
	from walmartsalesdata;

	select DATENAME(DAYOFYEAR,DATE) 'DATE OF YEAR'
	from walmartsalesdata;

	-- 2)ADDING DATE

	ALTER TABLE walmartsalesdata ADD date_name VARCHAR(14);

	UPDATE walmartsalesdata
	SET date_name=DATENAME(DW,DATE);

	-- 3)ADDING MONTH

	ALTER TABLE walmartsalesdata ADD month_name VARCHAR(20);

	UPDATE walmartsalesdata
	SET month_name=DATENAME(MONTH, DATE);

	select * FROM walmartsalesdata;

	--- GENERIC QUESTION

	--- 1) How many unique cities does the data have?

	SELECT
		COUNT(DISTINCT City) from walmartsalesdata;

	/* There are 3 unique cities present in this data.*/

	--- 2)Unique cities in each branch?

	SELECT
		distinct city,
		branch
	from 
		walmartsalesdata;

	/* INFERENCES: There are 3 unique cities present in 3 different branches.*/

	----Product Analysis:

	----1. How many unique product lines does the data have?
	SELECT 
		DISTINCT Product_line , 
		COUNT( DISTINCT Product_line) as 'COUNT OF UNIQUE PRODUCT LINE' from walmartsalesdata
	GROUP BY 
		PRODUCT_LINE;

	--- INFERENCES:

	-- There are 6 unique product lines present in this data

	----2. What is the most common payment method?

	SELECT
		MAX(Payment) 'common payment method'
	FROM 
		walmartsalesdata;

	select 
		payment,COUNT(*) 'Count of all Payments'
	from 
		walmartsalesdata
	group by 
		payment
	order by 
		COUNT(*) desc;

	/*INFERENCES: The most common payment methods are extinguishively -3 
				  They are: Cash,Credit Card, and Ewallet Methods
				  In which- Ewallet payment has been used predominantly*/
 
	----3. What is the most selling product line?

	select 
		sum(quantity) 'Total quantity',product_line from walmartsalesdata
	group by 
		product_line
	order by 
		sum(quantity);

	/* INFERENCES: Here the most selling product line is HEALTH AND BEAUTY */ 

	----4. What is the total revenue by month?

	select 
		round(sum(Total),2)'Total revenue',month_name 'Month'
	from 
		walmartsalesdata
	group by 
		month_name
	order by 
		round(sum(total),2) DESC;

	/*INFERENCES: "JANUARY" month generated highest total revenue than any other months*/

	----5. What month had the largest COGS?

	select 
		month_name 'MONTH',round(sum(cogs),2)'COGS'
	from 
		walmartsalesdata
	group by 
		month_name
	order by 
		round(sum(cogs),2) desc;

	/* INFERENCES:"JANUARY" month generated highest "COGS" than any other months */

	----6. What product line had the largest revenue?

	select 
		product_line,
		round(sum(total),2)'Largest revenue'
	from 
		walmartsalesdata
	group by 
		product_line
	order by 
		round(sum(total),2) desc;

	/* INFERENCES: "FOOD AND BEVERAGES" has the largest revenue when compared to other product lines present in this data */

	----7. What is the city with the largest revenue?

	select 
		branch,city,round(sum(total),2) 'Total revenue'
	from 
		walmartsalesdata
	group by 
		branch,city
	order by 
		round(sum(total),2) desc;

	/* INFERENCES: "Branch-C and City of Naypyitaw" has the largest revenue than any other city*/

	----8. What product line had the largest VAT?

	select 
		top 1 product_line,round(avg(tax_5),2) 'Largest tax' 
	from 
		walmartsalesdata
	group by 
		product_line
	order by 
		round(avg(tax_5),2) DESC;

	/* INFERENCES: "HOME AND LIFESTYLE" product line has the largest VAT */

	----9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.

	--- INITIALLY GETTING TO KNOW THE AVERAGE OF THE SALES

	select 
		avg(total) 'Average'  
	from 
		walmartsalesdata

	select 
		product_line,
		case
			when avg(total) > 323 then 'Good'
			else 'Bad'
		End as Remark
	from 
		walmartsalesdata
	group by 
		product_line
	order by 
		avg(total) desc ;

	/* INFERENCES: From 6 unique product lines "HOME AND LIFESTYLE","SPORTS AND TRAVEL","HEALTH AND BEAUTY" shows "GOOD" remark.*/ 
			   
	----10. Which branch sold more products than average product sold?

	select 
		Branch,
		sum(quantity)'Average Quantity'
	from 
		walmartsalesdata
	group by 
		branch
	Having 
		sum(quantity) > (select avg(quantity) from walmartsalesdata);

	/* INFERENCES: "BRANCH A" sold more products than the average quantities of other branches.*/

	----11. What is the most common product line by gender?

	SELECT 
		gender, 
		product_line, 
		COUNT(*) AS Product_line_count_gender_wise
	FROM 
		walmartsalesdata
	GROUP BY 
		gender, 
		product_line
	ORDER BY 
		gender, 
		Product_line_count_gender_wise DESC;

	/* INFERENCES: The most common product line is "FASHION ACCESSORIES" which is mostly utilized by "FEMALES".*/

	----12. What is the average rating of each product line?

	SELECT
		product_line,ROUND(AVG(rating),3) 'Average rating of each product line'
	FROM 
		walmartsalesdata
	GROUP BY
		product_line
	ORDER BY 
		ROUND(AVG(rating),3) DESC;

	/* INFERENCES: The average rating of each product line is mentioned below:
				  1. Food and beverages	7.113
				  2. Fashion accessories	7.029
				  3. Health and beauty	7.003
				  4. Electronic accessories	6.925
				  5. Sports and travel	6.916
				  6. Home and lifestyle	6.838
	*/

	 --Customer Analysis

	 --1. How many unique customer types does the data have? 
	 SELECT 
		COUNT(DISTINCT customer_type) AS unique_customer_types
	FROM 
		walmartsalesdata;

	--- INFERENCES: There are 2 unique customer types present in this data

	---2.How many uniquepayment methods does the data have?

	SELECT 
		COUNT(DISTINCT payment) AS unique_payment_methods
	FROM 
		walmartsalesdata;

	--- INFERENCES: There are 3 unique payment methods present in this data

	---3.Which customer type buys the most?

	 SELECT 
		customer_type,
		COUNT(*) AS total_purchases
	FROM 
		walmartsalesdata
	GROUP BY 
		customer_type
	ORDER BY 
		total_purchases DESC;

	--- INFERENCES: Customer type "MEMBER" buys the most of the things when compared to other type of customers.

	 --4. What is the gender of most of the customers?

	SELECT 
		gender,
		COUNT(*) AS customer_count
	FROM 
		walmartsalesdata
	GROUP BY 
		gender
	ORDER BY 
		customer_count DESC;

	--- INFERENCES: "FEMALE" customers are more in customers

	 --5. What is the gender distribution per branch?

	 SELECT 
		branch,
		gender,
		COUNT(*) AS customer_count
	FROM 
		walmartsalesdata
	GROUP BY 
		branch, gender
	ORDER BY 
		branch, gender;

	--- INFERENCES: In "Branch A and B Male distribution" is more but in "Branch C female - distribution" is more in numbers

	 --6. Which time of the day do customers give most ratings?
 
	select 
		time_of_day,
		round(avg(rating),4) as Average_rating
	from 
		walmartsalesdata
	group by 
		time_of_day
	order by 
		Average_rating desc;

	--- INFERENCES: During "Afternoon" session Customers give more ratings.Then followed by "Morning" session as there is only slight differences between these three sessions.


	 --7. Which time of the day do customers give most ratings per branch?
 
	select 
		branch,
		time_of_day,
		round(avg(rating),4) as Average_rating
	from 
		walmartsalesdata
	group by 
		branch, 
		time_of_day
	order by 
		branch,
		Average_rating desc;

	/** INFERENCES: 1. For Branch A , the most ratings are given during "Afternoon" Session.
					2. For Branch B , the most ratings are given during "Morning" Session.
					3. For Branch C , the most ratings are given during "Evening" Session.**/

	 --8. Which day for the week has the best avg ratings?

	select 
		date_name,
		round(avg(rating),4) as Average_rating
	from 
		walmartsalesdata
	group by 
		branch, 
		date_name
	order by 
		branch,
		Average_rating desc;

	--- INFERENCES: "Friday" has the ebst average ratings when compared to other days in a week.

	 --9. Which day of the week has the best average ratings per branch?

	select 
		branch,date_name,
		round(avg(rating),4) as Average_rating
	from 
		walmartsalesdata
	group by 
		branch, 
		date_name
	order by 
		branch,
		Average_rating desc;

	/** INFERENCES: 1.Best ratings in a week for Branch A is on "Friday".
					2.Best ratings in a week for Branch B is on "Saturday".
					3.Best ratings in a week for Branch c is on "Friday".
					4.Both Branch A and Branch B share the best ratings on the same day in a week.**/

	 ---- Sales Analysis

	 ----1. Number of sales made in each time of the day per weekday 

	select 
		time_of_day,
		count(quantity)'sales per day'
	from 
		walmartsalesdata
	group by 
		time_of_day
	order by 
		count(quantity);

	/** INFERENCES: sales made in each time of the day per weekday
					1.During "Morning" session the total sales is 191.
					2.During "Afternoon" session the total sales is 377.
					3.During "Evening" session the total sales is 432.**/

	 ----2.Which of the customer types brings the most revenue?

	 select 
		customer_type,
		round(avg(total),3) 'Most revenue' 
	from 
		walmartsalesdata
	 group by 
		customer_type
	 order by 
		round(avg(total),3) desc;

	--- INFERENCES: The "Member" Customer brings the most revenue.

	----3.Which city has the largest tax percent/ VAT (**Value Added Tax**)?
 
	 select 
		city,
		round(avg(tax_5),3) as 'Tax percent'
	 from 
		walmartsalesdata
	 group by 
		city
	 order by 
		round(avg(total),3) desc;

	--- INFERENCES: The city "Naypyitaw" has the largest tax percentage.

	 ----4. Which customer type pays the most in VAT

	 select 
		customer_type,
		round(avg(tax_5),3) 'Customer max tax'
	 from 
		walmartsalesdata
	 group by 
		customer_type
	 order by 
		round(avg(total),3) desc;

	--- INFERENCES: The "Member" customer pays the most in VAT.

 