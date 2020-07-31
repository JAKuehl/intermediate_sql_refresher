-- LIME INTERMEDIATE ANALYTICS BOOTCAMP --

--II. KEYWORD REVIEW - Question - Page 3 of Word Document

/*The VP of Marketing at Lime wants to dig into customers who signed up for the customer marketing list at a recent musical festival. 
She’s particularly interested in examining customers who don’t own either a bike or a car.

Write a query that pulls the total count of customers and their average age, grouped by ethnicity. 
Order the results from highest count of customers to lowest. 
Hint* Use CUSTOMER_MARKETING_LIST table 

*/

SELECT

count(distinct rider_id) AS COUNT_OF_CUSTOMERS
,AVG(AGE)
,ethnicity

FROM public.customer_marketing_list

WHERE
has_own_bike = FALSE
AND
has_own_car = FALSE

GROUP BY
ethnicity

ORDER BY
1 DESC

--IV. JOIN Workshop -- Write the Code - Page 8 of Word Document

/*I want to see total trips grouped by bike ownership. 
Use TRIPS and CUSTOMER_MARKETING_LIST Table.

Note on tables:
TRIPS = Customers who have taken a ride.
CUSTOMER_MARKETING_LIST = Customers who have signed up for the marketing list.

Refer to Page 8 for walkthrough..

*/

SELECT

COUNT(DISTINCT A.TRIP_ID) AS TOTAL_TRIPS
,B.has_own_bike AS BIKE_OWNER

FROM public.trips AS A

LEFT JOIN
public.customer_marketing_list AS B
ON A.rider_id = B.rider_id

/* LEFT JOIN brings in customers who we don't know whether they own a bike or not*/
/* JOIN only brings in customers who we know own a bike or not */

GROUP BY
BIKE_OWNER

--IV. Match the JOINs to their business use cases. Page 10 of Word Document...

--Only customers who signed up the marketing list and have taken a ride. --> 2
--All Customers --> 6
--Only customers who haven’t completed both actions --> 7
--Only customers who have signed up for the marketing list and not taken a ride --> 5
--Only customers who have taken a ride and not signed up for the marketing list --> 4
--All Customers who have taken a ride --> 1
--All Customers who signed up for the marketing list --> 3


--VI. Case Statement Workshop -- OK, BOOMER

-- Exercise I
SELECT
 COUNT(DISTINCT RIDER_ID) AS TOTAL_CUSTOMERS
,CASE WHEN AGE > 75 then 'Silent'
   WHEN AGE BETWEEN 55 and 75 then 'Boomer'
   WHEN AGE BETWEEN 40 and 54 then 'Gen X'
   WHEN AGE BETWEEN 25 and 39 then 'Millenial'
   ELSE 'Gen Z' END AS GENERATION
,CASE WHEN HAS_OWN_CAR = FALSE AND HAS_OWN_BIKE = FALSE THEN 'TRUE'
      ELSE 'FALSE' END AS HAS_TRANSPORTATION
FROM CUSTOMER_MARKETING_LIST
GROUP BY
2, 3

-- Exercise 2
SELECT
 COUNT(DISTINCT A.RIDER_ID) AS TOTAL_CUSTOMERS
,CASE WHEN A.AGE > 75 then 'Silent'
   WHEN A.AGE BETWEEN 55 and 75 then 'Boomer'
   WHEN A.AGE BETWEEN 40 and 54 then 'Gen X'
   WHEN A.AGE BETWEEN 25 and 39 then 'Millenial'
   ELSE 'Gen Z' END AS GENERATION
FROM CUSTOMER_MARKETING_LIST AS A
LEFT JOIN TRIPS AS B
ON A.RIDER_ID = B.RIDER_ID
WHERE
B.RIDER_ID IS NULL
GROUP BY
2

--VII.  Ranking Data in SQL – Introduction to Window Functions

--1. Opening Question...

SELECT
 name
,networth_MM
,gender
,location
,RANK() OVER(ORDER BY networth_MM DESC) AS NETWORTH_RANK
,RANK() OVER(PARTITION BY LOCATION ORDER BY NETWORTH_MM DESC) AS NETWORTH_RANK_LOC

FROM PEOPLE_IN_LIMO

--

SELECT
LOCATION
,SUM(NETWORTH_MM) AS TOTAL_NETWORTH
,RANK() OVER(ORDER BY SUM(NETWORTH_MM) DESC) AS NETWORTH_RANK

FROM PEOPLE_IN_LIMO

GROUP BY
1 


--VIII.  Ranking Data Workshop…The “Best” Mechanic

--1.	Mechanics Ranked by Repair Count

SELECT
mechanic_id
,mechanic
,repair_count
,RANK() OVER (ORDER BY REPAIR_COUNT DESC) AS MECHANIC_RANK
FROM MECHANICS

--2.	Locations Ranked by Repair Count

SELECT
location
,sum(repair_count) AS TOTAL_REPAIR_COUNT
,RANK() OVER (ORDER BY SUM(REPAIR_COUNT) DESC) AS LOCATION_RANK
FROM MECHANICS
GROUP BY
1

--3.	Mechanics Ranked Within Location by Repair Count

SELECT
mechanic_id
,mechanic
,repair_count
,location
,is_manager
,RANK() OVER (PARTITION BY LOCATION ORDER BY REPAIR_COUNT DESC) AS MECHANIC_RANK_LOC
FROM mechanics

--4.	Managers/Non Managers Ranked Within Location by Repair Count

SELECT
 sum(repair_count)
,is_manager
,location
,RANK() OVER(PARTITION BY LOCATION ORDER BY SUM(REPAIR_COUNT) DESC) AS MECHANIC_RANK_MANAGER
FROM public.mechanics
GROUP BY
2, 3

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
WITH a AS
(SELECT
LOCATION
,sum(repair_count) AS TOTAL_REPAIRs
FROM PUBLIC.MECHANICS
GROUP BY
location)
SELECT
count(location)
FROM A
WHERE TOTAL_REPAIRS > 80

--2. Subquery
SELECT
COUNT(A.LOCATION) AS TOTAL_LOCATIONS
FROM
(SELECT
LOCATION
,sum(repair_count) AS TOTAL_REPAIRs
FROM PUBLIC.MECHANICS
GROUP BY
location) AS A
WHERE
total_repairs >= 80

--XI. Querying your own Query, Writing Subqueries and CTEs

-- Approach 1: Using a Subquery
SELECT
count(distinct a.vehicle_id) AS TOTAL_VEHICLES
,TOTAL_TRIPS
FROM
(SELECT
vehicle_id
,count(trip_id) AS TOTAL_TRIPS
FROM TRIPS
WHERE trip_status = 'completed'
GROUP BY
1) AS a
GROUP BY
TOTAL_TRIPS

-- Approach 2: CTEs

WITH A AS (SELECT
vehicle_id
,count(trip_id) AS TOTAL_TRIPS
FROM TRIPS
WHERE trip_status = 'completed'
GROUP BY
1)
SELECT
count(distinct a.vehicle_id) AS TOTAL_VEHICLES
,A.TOTAL_TRIPS
FROM A
GROUP BY
A.TOTAL_TRIPS

--XII. Putting it All Together - Arhictect the Final Query

WITH A AS (SELECT
 count(distinct A.trip_id) AS TOTAL_RIDES
,to_char(trip_date_start,'YYYY-MM') AS TRIP_YEAR_MONTH
,CASE WHEN trip_rating = 5 THEN 'EXCELLENT'
      WHEN trip_rating = 4 THEN 'GOOD'
      WHEN trip_rating = 3 THEN 'OK'
      WHEN trip_rating = 2 THEN 'POOR'
      WHEN trip_rating = 1 THEN 'VERY POOR'
      ELSE 'NO RATING' END AS TRIP_DESCRIPTION
      
FROM public.trips AS A

LEFT JOIN public.customer_marketing_list AS B
ON A.rider_id = B.rider_id

WHERE trip_status = 'completed'
AND
B.rider_id IS NULL
AND
vehicle_type ='scooter'

GROUP BY
2, 3

ORDER BY
2, 3 ASC)

SELECT
TOTAL_RIDES
,TRIP_YEAR_MONTH
,TRIP_DESCRIPTION
,RANK() OVER (PARTITION BY TRIP_YEAR_MONTH ORDER BY TOTAL_RIDES DESC)

FROM A
