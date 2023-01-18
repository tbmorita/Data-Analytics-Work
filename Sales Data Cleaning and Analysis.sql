
/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: view all table contents, note there are incomplete records (null) and records
with improper data (data = the column header)
*/	


SELECT
	*
FROM
	Sales_January_2019
Order BY
	Product	

/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: find the improper data in the records, 42 records)
*/	

SELECT
	*
FROM
	Sales_January_2019
WHERE
 Product = 'Product' or OrderID is NULL
Order BY
	Product	
	
/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: Determine how many times a product was ordered and the quantity ordered, remove
 Null and Product having Product values
*/	

SELECT
	Product, count(*) as [Product Orders], sum(QuantityOrdered) as [Product Quantity Ordered]
FROM
	Sales_January_2019
WHERE
	OrderID is not NULL -- remove null data
GROUP BY
	Product
HAVING
	[Product Quantity Ordered] > 0  -- quantity must be greater than zero if a product is ordered

	
	
/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: Calculate sales for each OrderID line from January 2019 sales data
*/	

SELECT
	Product, sum(QuantityOrdered) as [Quantity Ordered], sum((QuantityOrdered * PriceEach)) as [Total Sales]
FROM
	Sales_January_2019
WHERE
	OrderID is not Null -- remove null data
Group BY
	Product
HAVING
	[Quantity Ordered] > 0  -- quantity must be greater than zero if a product is ordered

	
/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: Determine total sales for Monitor Products
*/	

SELECT
	Product, sum(QuantityOrdered) as [Quantity Ordered], sum((QuantityOrdered * PriceEach)) as [Total Sales]
FROM
	Sales_January_2019
WHERE
	Product Like '%Monitor'
Group BY
	Product
HAVING
	[Quantity Ordered] > 0  -- quantity must be greater than zero if a product is ordered



/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: Determine total sales in the month
*/	

SELECT
	round(sum(QuantityOrdered * PriceEach),2) as [Total Monthly Sales]
FROM
	Sales_January_2019	

/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: Determine the Day of the week (number) and the hour of the day the invoice was initiated
*/
Create View V_Sales_Jan_2019_wDayHours AS
SELECT
	*, STRFTIME('%w', OrderDate) as [DayNumber], STRFTIME('%H', OrderDate) as [Hour of the Day]
FROM
	Sales_January_2019
WHERE
 Product <> 'Product' or OrderID is NULL
Order By
	OrderDate DESC

/*
CREATED BY: TODD MORITA
CREATED ON: 1/17/23
DESCRIPTION: Add the day name for the date of sale using
the View V_Dales_Jan_2019_wDayHours
*/
SELECT
	round(sum(QuantityOrdered * PriceEach),0) as TotalMonthSales,
	CASE -- Assign day names based on the day number
	When DayNumber = '0' Then 'Sunday'
	When DayNumber = '1' Then 'Monday'
	When DayNumber = '2' Then 'Tuesday'
	When DayNumber = '3' Then 'Wednesday'
	When DayNumber = '4' Then 'Thursday'
	When DayNumber = '5' Then 'Friday'
	Else 'Saturday'
	End As Day
FROM
	V_Sales_Jan_2019_wDayHours
WHERE
 Product <> 'Product' or OrderID is NULL -- exclude Nulls and improper data
Group By
	Day
Order By
	TotalMonthSales Desc -- Results will show total sales by day in descending order
