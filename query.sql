/* SECOND HIGHEST SALARY  
https://leetcode.com/problems/secONd-highest-salary*/

SELECT max(secONdHighestSalary) AS secONdHighestSalary FROM (
SELECT  SALARY AS secONdHighestSalary,
dense_rank()  Over( ORDER BY salary DESC) AS rank FROM Employee
) AS t
WHERE rank=2;
--------------------------------------------------------------------------------
/* https://leetcode.com/problems/customers-who-never-order/ */
/* Write your T-SQL query statement below */
SELECT 
name AS Customers 
FROM Customers c
LEFT JOIN Orders o
ON c.id = o.customerId
WHERE o.customerId IS NULL ;
-----------------------------------------------------------------------------------------
/* https://leetcode.com/problems/department-highest-salary/descriptiON/ */
/* Write your T-SQL query statement below */
SELECT * FROM (
SELECT d.name AS Department, e.name AS  Employee,Salary,
dense_rank() over (partitiON by d.name order by Salary desc)  AS rank FROM
Employee e
JOIN Department d
ON e.departmentId=d.id) RESULT
WHERE RANK =1 ; --ORDER BY EMPLOYEE,SALARY DESC
------------------------------------------------------------------------------------------
/* https://leetcode.com/problems/department-top-three-salaries/descriptiON/ */
/* Write your T-SQL query statement below */
SELECT  Department ,Employee , Salary  FROM (
SELECT e.name AS Employee ,e.id sort,
salary,
d.name AS Department,
dense_rank() over( partitiON by d.name order by salary desc) AS rank 

 FROM Employee e
left JOIN Department d ON e.departmentId=d.id) RESULT
WHERE rank <=3 order by  sort ASc ;
-----------------------------------------------------------------------------------------
/* https://leetcode.com/problems/rising-temperature/descriptiON/ */
/* Write your T-SQL query statement below */
SELECT id
FROM(
SELECT id, recordDate,temperature,
LAG(temperature) OVER(ORDER BY recordDate  ASC) AS PREVIOUS FROM Weather) t
WHERE  temperature > previous ;
-------------------------------------------------------------------------------------------
/* https://leetcode.com/problems/human-traffic-of-stadium/descriptiON/ */
/* Write your T-SQL query statement below */
WITH FilteredRows AS (
    -- Step 1: ONly keep rows with 100+ people
    SELECT id, visit_date, people
    FROM stadium
    WHERE people >= 100
),
IslandGroups AS (
    -- Step 2: CONtinuous sequence vs ID sequence math
    SELECT 
        id, 
        visit_date, 
        people,
        (id - ROW_NUMBER() OVER (ORDER BY id)) AS GroupID
    FROM FilteredRows
),
StreakCounts AS (
    -- Step 3: Count how lONg each streak group is
    SELECT 
        id, 
        visit_date, 
        people,
        COUNT(*) OVER (PARTITION BY GroupID) AS StreakLength
    FROM IslandGroups
)
-- Step 4: ONly pull rows WHERE the streak length is 3 or more
SELECT id, visit_date, people
FROM StreakCounts
WHERE StreakLength >= 3
ORDER BY visit_date;
----------------------------------------------------------------------------------------------------
/* https://leetcode.com/problems/trips-and-users/descriptiON/ */
/* Write your T-SQL query statement below */
WITH cte AS (
SELECT client_id,users_id,banned,request_at,status
FROM Trips t
JOIN  Users u
ON  t.client_id= u.users_id    
WHERE banned <> 'Yes')
SELECT request_at AS Day ,
ROUND(CAST(SUM( CASE WHEN status <>'completed' THEN 1 ELSE 0  END) AS FLOAT)/ count(*),2) AS [CancellatiON Rate]
FROM cte
GROUP BY request_at  

--------------------------------------------------------------------------------
-- Question 1: Find the Origin and Final Destination for each Customer (cid)
-- Description: Traces multi-leg journeys or 2-leg connections to find 
--              the absolute starting origin and ending destination per cid.
--------------------------------------------------------------------------------

-- 1. Setup Sample Schema & Data
CREATE TABLE flights (
    cid INT,
    fid VARCHAR(10),
    origin VARCHAR(50),
    Destination VARCHAR(50)
);

INSERT INTO flights VALUES (1, 'f1', 'Del', 'Hyd');
INSERT INTO flights VALUES (1, 'f2', 'Hyd', 'Blr');
INSERT INTO flights VALUES (2, 'f3', 'Mum', 'Agra');
INSERT INTO flights VALUES (2, 'f4', 'Agra', 'Kol');

-- 2. Query Solution (Robust Set-Based / Anti-Join Approach for any number of legs)
WITH start_points AS (
    SELECT cid, origin 
    FROM flights
    EXCEPT
    SELECT cid, Destination AS origin 
    FROM flights
),
end_points AS (
    SELECT cid, Destination 
    FROM flights
    EXCEPT
    SELECT cid, origin AS Destination 
    FROM flights
)
SELECT 
    s.cid, 
    s.origin, 
    e.Destination
FROM start_points s
JOIN end_points e ON s.cid = e.cid;
-- approach 2 ,
--If the interview data is guaranteed to only have 2 legs per customer (as shown in the sample input), 
--a simple INNER JOIN where the first flight's destination matches the second flight's origin works:
SELECT 
    f1.cid, 
    f1.origin, 
    f2.Destination
FROM survey_log f1
JOIN survey_log f2 
  ON f1.cid = f2.cid 
  AND f1.Destination = f2.origin;

--------------------------------------------------------------------------------
-- Question 2: Find the Count of New Customers Added in Each Month
-- Description: Cohort analysis query that identifies the earliest month a 
--              customer transacted to count unique new acquisitions per month.
--------------------------------------------------------------------------------

-- 1. Setup Sample Schema & Data
CREATE TABLE customer_sales (
    Month VARCHAR(20),
    Customer VARCHAR(10),
    QTY INT
);

INSERT INTO customer_sales VALUES ('Jan-21', 'C1', 20);
INSERT INTO customer_sales VALUES ('Jan-21', 'C2', 30);
INSERT INTO customer_sales VALUES ('Feb-21', 'C1', 10);
INSERT INTO customer_sales VALUES ('Feb-21', 'C3', 15);
INSERT INTO customer_sales VALUES ('Mar-21', 'C5', 19);
INSERT INTO customer_sales VALUES ('Mar-21', 'C4', 10);
INSERT INTO customer_sales VALUES ('Apr-21', 'C3', 13);
INSERT INTO customer_sales VALUES ('Apr-21', 'C5', 15);
INSERT INTO customer_sales VALUES ('Apr-21', 'C6', 10);

-- 2. Query Solution
WITH first_seen AS (
    SELECT 
        Customer, 
        MIN(Month) AS first_month
    FROM customer_sales
    GROUP BY Customer
)
SELECT 
    first_month AS Month,
    COUNT(Customer) AS New_Customer_count
FROM first_seen
GROUP BY first_month
ORDER BY first_month;
-- approach 2
WITH ranked_sales AS (
    SELECT 
        Customer,
        Month,
        ROW_NUMBER() OVER (PARTITION BY Customer ORDER BY Month) AS rnk
    FROM customer_sales
)
SELECT 
    Month,
    COUNT(Customer) AS New_Customer_count
FROM ranked_sales
WHERE rnk = 1
GROUP BY Month
ORDER BY Month;
--approach 3
WITH first_seen AS (
    SELECT DISTINCT
        Customer,
        FIRST_VALUE(Month) OVER (PARTITION BY Customer ORDER BY Month) AS first_month
    FROM customer_sales
)
SELECT 
    first_month AS Month,
    COUNT(Customer) AS New_Customer_count
FROM first_seen
GROUP BY first_month
ORDER BY first_month;


