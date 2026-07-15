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

