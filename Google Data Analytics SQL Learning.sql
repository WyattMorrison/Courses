-- Basic Functions Learned in Google Data Analytics Certificate
-- START 
-- WHERE, COUNT, ORDER BY

SELECT *
FROM movie_data.movies
WHERE Genre = "Comedy" AND
      Release_Date = '2013-12-31'

SELECT Movie_Title,
       Release_Date,
       Genre
FROM movie_data.movies
WHERE Genre = "Comedy" AND
      Release_Date = '2013-12-31'

SELECT COUNT(Genre)
FROM movie_data.movies
WHERE Genre = "Crime"


SELECT *
FROM movie_data.movies
ORDER BY Release_Date DESC


SELECT *
FROM movie_data.movies
WHERE Genre = "Comedy"
AND Revenue > 300000000
ORDER BY Release_Date DESC


-- CONCAT & JOIN

SELECT usertype,
       CONCAT(start_station_name, " to ", end_station_name) AS route
       COUNT(*) as num_trips
       ROUND(AVG(CAST(tripduration AS int)/60),2) AS duration
FROM new_york_citibike.citibike_trips
GROUP BY start_station_name, end_station_name, usertype
ORDER BY num_trips DESC
LIMIT 10


SELECT employees.name AS employee_name,
       employees.role AS employee_role,
       departments.name AS department_name
FROM employee_data.employees
INNER JOIN
	employee_data.departments on 
	employees.department_id = departments.department_id


SELECT employees.name AS employee_name,
       employees.role AS employee_role,
       departments.name AS department_name
FROM employee_data.employees
LEFT JOIN
	employee_data.departments ON 
	employees.department_id = departments.department_id


SELECT employees.name AS employee_name,
       employees.role AS employee_role,
       departments.name AS department_name
FROM employee_data.employees
RIGHT JOIN
	employee_data.departments ON 
	employees.department_id = departments.department_id


SELECT employees.name AS employee_name,
       employees.role AS employee_role,
       departments.name AS department_name
FROM employee_data.employees
OUTER JOIN
	employee_data.departments ON 
	employees.department_id = departments.department_id


-- COUNT and Union

SELECT warehouse.state AS state,
       COUNT(DISTINCT order_id) AS num_orders
FROM warehouse_orders.Orders orders
JOIN warehouse_orders.Warehouse warehouse ON orders.warehouse_id = warehouse.warehouse_id
GROUP BY warehouse.state


SELECT *
FROM bicycle-case-study-375818.1.12-2021
UNION ALL
FROM bicycle-case-study-375818.1.12-2022
UNION ALL
FROM bicycle-case-study-375818.1.12-2023


-- Sub Queries & Having

SELECT station_id,
       num_bikes_available,
	(SELECT AVG(num_bikes_available)
	FROM new_york_citibike.citibike_stations) AS avg_num_bikes_available
FROM new_york_citibike.citibike_stations


SELECT station_id,
       name,
       number_of_rides AS number_of_rides_starting_at_station
FROM
	(SELECT start_station_id,
		COUNT(*) number_of_rides
		FROM new_york_citibike.citibike_trips
		GROUP BY  start_station_id
	)
	AS station_num_trips
	INNER JOIN new_york_citibike.citibike_stations ON station_id = start_station_id
	ORDER BY number_of_rides DESC


SELECT station_id,
       name
FROM new_york_citibike.citibike_stations
WHERE station_id IN
	(
	SELECT start_station_id,
		FROM new_york_citibike.citibike_trips
		WHERE usertype = 'Subscriber'
	)


SELECT Warehouse.warehouse_id,
       CONCAT(state, ': ', Warehouse.warehouse_alias) AS warehouse_name,
       COUNT(Orders.order_id) AS number_of_orders,
	(
	SELECT COUNT(*)
	FROM warehouse_orders.Orders AS Orders)
	AS total_orders,
	CASE
		WHEN COUNT(Orders.order_id)/(SELECT COUNT(*) FROM warehouse_orders.Orders AS Orders) <= 0.20
		THEN "fulfilled 0-20% of orders"
		WHEN COUNT(Orders.order_id)/(SELECT COUNT(*) FROM warehouse_orders.Orders AS Orders) > 0.20
		AND COUNT(Orders.order_id)/(SELECT COUNT(*) FROM warehouse_orders.Orders AS Orders) <= 0.60
		THEN "fulfilled 21-60% of orders"
	ELSE "fulfilled more than 60% of orders"
	END AS fulfillment_summary
FROM warehouse_orders.Warehouse AS Warehouse
Left Join warehouse_orders.Orders AS Orders
	ON Orders.warehouse_id = warehouse.warehouse_id
GROUP BY warehouse.warehouse_id,
	 warehouse_name
HAVING COUNT (Orders.order_id) > 0


-- Calculations Using SQL

SELECT Date,
       Region,
       Small_Bags,
       Large_Bags,
       XLarge_Bags,
       Total_Bags,
       Small_Bags + Large_Bags, XLarge_Bags AS Total_Bags_Calc
FROM avacado_data.avacado_prices


SELECT Date,
       Region,
       Small_Bags,
       Large_Bags,
       XLarge_Bags,
       Total_Bags,
       (Small_Bags / Total_Bags)*100 AS Small_Bags_Percent
FROM avacado_data.avacado_prices
WHERE Total_Bags <> 0


SELECT Date,
       Region,
       Small_Bags,
       Large_Bags,
       XLarge_Bags,
       Total_Bags,
       SAFE_DIVIDE(Small_Bags, Total Bags)*100 AS Small_Bag_Precent
FROM avacado_data.avacado_prices


SELECT invoice_line_id,
       invoice_id,
       unit_price,
       quantity,
       unit_price + quantity AS line_total
FROM invoice_item
Limit 5


-- Extract 

SELECT EXTRACT(YEAR FROM STARTTIME) AS Year,
       COUNT(*) AS number_of_rides
FROM new_york_citibike.citibike_trips
GROUP BY Year
ORDER BY Year DESC


SELECT EXTRACT(Year FROM date) as Year,
       ROUND(SUM(UnitPrice * Quantity),2) AS Revenue
FROM sales.sales_info
GROUP BY Year
ORDER BY Year DESC


-- Temp Table

WITH trips_over_1_hr AS
	(SELECT *
	FROM new_york_citibike.citibike_trips
	WHERE tripduration >= 60
	)


SELECT COUNT(*) AS cnt
FROM trips_over_1_hr

-- END


-- CLEANING FUNCTIonS & FORMULas
-- START
-- Insert Into & Update

INSERT INTO customer_data.customer_address
	(customer_id, address, city, state, zipcode, Country)
VALUES
	(2645, '333 SQL Road', 'Jackson', 'MI', 49202, 'US')

UPDATE customer_data.customer_address
SET address = '123 New Address'
WHERE customer_id = 2645


-- Length, SUBSTRING, & Trim

SELECT LENGTH(Country) AS letters_in_Country
FROM customer_data.customer_address

SELECT Country
FROM customer_data.customer_address
WHERE LENGTH(Country) > 2

SELECT DISTINCT customer_id
FROM customer_data.customer_address
WHERE SUBSTRING(Country, 1, 2) = 'US'

SELECT DISTINCT customer_id
FROM customer_data.customer_address
WHERE TRIM(state) = 'OH'


-- CAST & BETWEEN

SELECT CAST(purchase_price AS FLOAT64)
FROM customer_data.customer_purchase
ORDER BY CAST(purchase_price AS FLOAT64) DESC

SELECT date,
       purchase_price
FROM customer_data.customer_purchase
WHERE date BETWEEN '2020-12-01' AND '2020-12-31'

SELECT CAST(date as date) AS date_only,
	purchase_price
FROM customer_data.customer_purchase
WHERE date BETWEEN '2020-12-01' AND '2020-12-31'


-- CONCAT & COALESCE

SELECT CONCAT(product_code, product_color) AS new_product_code
FROM customer_data.customer_purchase
WHERE product = 'couch'


SELECT CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name)
FROM student;


SELECT Movie_Title,
       Release_date,
       Genre,
       CONCAT(Director__1_, ": ", COALESCE(Director__2_, '')) as director_1_and_2
FROM movie_data.movies


-- CASE

SELECT customer_id,
	CASE WHEN first_name = 'Tnoy' THEN 'Tony'
	     ELSE first_name
	     END AS cleaned_name
FROM customer_data.customer_name


SELECT customer_id,
	CASE WHEN first_name = 'Tnoy' THEN 'Tony'
	     WHEN first_name = 'Tmo' THEN 'Tom'
	     WHEN first_name = 'Rachle' THEN 'Rachel'
	     ELSE first_name
	     END AS cleaned_name
FROM customer_data.customer_name


SELECT CASE WHEN name = 'Aav' THEN 'Ava'
	    WHEN name = 'Brooklyn' THEN 'Brook'
	    ELSE name
	    END AS cleaned_name,
	gender,
	COUNT
FROM babynames.names_2010
LIMIT 1000


SELECT *,
	CASE WHEN Director__2_ IS NULL THEN 1
	     ELSE 0
	     END
FROM movie_data.movies
ORDER BY Movie_Title


-- COALESCE & CasE

SELECT Movie_Title,
       Release_Date,
       Genre,
       Director__1_,
       COALESCE(Director__2_) AS Director_2
FROM movie_data.movies
ORDER BY
	CASE WHEN Director_2 IS NULL THEN 1
	ELSE 0
	END


-- String_AGG

SELECT STRING_AGG(Director__2_, ", ")
FROM movie_data.movies

-- END 