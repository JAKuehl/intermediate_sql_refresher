-- LIME INTERMEDIATE ANALYTICS BOOTCAMP --

--II. KEYWORD REVIEW - Question - Page 3 of Word Document

/*The VP of Marketing at Lime wants to dig into customers who signed up for the customer marketing list at a recent musical festival. 
She’s particularly interested in examining customers who don’t own either a bike or a car.

Write a query that pulls the total count of customers and their average age, grouped by ethnicity. 
Order the results from highest count of customers to lowest. 
Hint* Use CUSTOMER_MARKETING_LIST table 

*/


--IV. JOIN Workshop -- Write the Code - Page 8 of Word Document

/*I want to see total trips grouped by bike ownership. 
Use TRIPS and CUSTOMER_MARKETING_LIST Table.

Note on tables:
TRIPS = Customers who have taken a ride.
CUSTOMER_MARKETING_LIST = Customers who have signed up for the marketing list.

Refer to Page 8 for walkthrough..

*/


--IV. Match the JOINs to their business use cases. Page 10 of Word Document...

--Only customers who signed up the marketing list and have taken a ride.
--All Customers
--Only customers who haven’t completed both actions
--Only customers who have signed up for the marketing list and not taken a ride 
--Only customers who have taken a ride and not signed up for the marketing list
--All Customers who have taken a ride
--All Customers who signed up for the marketing list


--VI. Case Statement Workshop -- OK, BOOMER

-- Exercise I

-- Exercise 2

--VII.  Ranking Data in SQL – Introduction to Window Functions

--1. Opening Question...

SELECT
 name
,networth_MM
,gender
,location
,RANK() OVER(ORDER BY networth_MM DESC) AS NETWORTH_RANK
--,RANK() OVER(

FROM PEOPLE_IN_LIMO


--VIII.  Ranking Data Workshop…The “Best” Mechanic

--1.	Mechanics Ranked by Repair Count
--2.	Locations Ranked by Repair Count
--3.	Mechanics Ranked Within Location by Repair Count
--4.	Managers/Non Managers Ranked Within Location by Repair Count


--X. Querying Your Own Query --> Having, Subqueries and CTEs in SQL

--Approach 1: Using HAVING
SELECT
COUNT(DISTINCT TRIP_ID) AS TOTAL_TRIPS
,rider_id
,rider_name
FROM PUBLIC.TRIPS
GROUP BY
rider_id
,rider_name
HAVING
COUNT(DISTINCT TRIP_ID) >= 2
ORDER BY
TOTAL_TRIPS DESC

--Approach 2: Using a Subquery
SELECT
a.total_trips
,a.rider_id
,a.rider_name
FROM
(SELECT
COUNT(DISTINCT TRIP_ID) AS TOTAL_TRIPS
,rider_id
,rider_name
FROM PUBLIC.TRIPS
GROUP BY
rider_id
,rider_name
ORDER BY
TOTAL_TRIPS DESC) AS a
WHERE a.total_trips >= 2

--Approach 3: Using a CTE
WITH A AS (SELECT
COUNT(DISTINCT TRIP_ID) AS TOTAL_TRIPS
,rider_id
,rider_name
FROM PUBLIC.TRIPS
GROUP BY
rider_id
,rider_name
ORDER BY
TOTAL_TRIPS DESC)
SELECT
a.total_trips
,a.rider_id
,a.rider_name
FROM A
WHERE
A.TOTAL_TRIPS >= 2

-- Identify which of these queries is a subquery or a CTE

--1. CTE

--2. Subquery

--XI. Querying your own Query, Writing Subqueries and CTEs

-- Approach 1: Using a Subquery

-- Approach 2: CTEs

--XII. Putting it All Together - Arhictect the Final Query

