-- Question 01 (Weather Observation Station):
-- Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) 
-- as both their first and last characters. Your result cannot contain duplicates.
SELECT DISTINCT(CITY) FROM STATION WHERE CITY REGEXP '^[AEIOUaeiou]' AND CITY REGEXP '[AEIOUaeiou]$';
-- Note: Learned about 'regexp' function.


-- Question 02 (Weather Observation Station): 
-- Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
select distinct(city) from station where 
city like "%a" or city like "%e" or city like "%i"
or city like "%o" or city like "%u";
-- Note: Learned that (like "%x") return fields  ending with "x".


-- Question 03 (Weather Observation Station): 
-- Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
select distinct(city) from station where city 
like "a%" or city like "e%" or city like "i%"
or city like "o%" or city like "u%";
-- Learned that (like "x%") return fields begining with "x".


-- Question 04 (Weather Observation Station):
-- Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
select distinct(city) from station where city not rlike '^[AEIOUaeiou].*$';
-- Note: Example of rlike.


-- Question 05 (Weather Observation Station):
-- Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station where city not regexp '[aeiou]$';
-- Note: Example of not regexp function.


-- Question 06 (Weather Observation Station):
-- Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
select distinct(city) from station where
city not regexp '^[aeiou].*' or 
city not regexp '[aeiou]$';


-- Question 07:
-- Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. 
-- (contd) If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
select name from students where marks > 75
order by substr(name, -3), id;
-- Used substr() function


-- Question 08:
-- Query the total population of all cities in CITY where District is California
select sum(population) from city where district like "%california%";


-- Question 09:
-- Query the average population for all cities in CITY, rounded down to the nearest integer.
select round(avg(population)) from city;
-- Note: Learned 'round()' with aggregate (avg) function.


-- Question 10 (The Blunder Challenge):
-- Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, 
-- (contd) but did not realize her keyboard's  key was broken until after completing the calculation. 
-- (contd) She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.
-- (contd) Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.
SELECT ceil(AVG(salary) - (AVG(REPLACE(salary, '0', '')))) AS avg_salary FROM employees;
-- Note: learned ceil function.


-- Question 11 (Top Earner Challenge):
-- We define an employee's total earnings to be their monthly salary x months worked, 
-- (contd) and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. 
-- (contd) Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. 
-- (contd) Then print these values as  space-separated integers.
select max(months*salary), count(months*salary) from employee
where (months*salary) = (select max(months*salary) from employee);


-- Question 12 (Triangle Challenge):
SELECT CASE 
WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle' 
WHEN A = B AND B = C THEN 'Equilateral' 
WHEN A = B OR B = C OR A = C THEN 'Isosceles' 
ELSE 'Scalene' 
END as case1
FROM TRIANGLES;
-- Note: Learned to use 'case' function


-- Question 13 (The PADS Challenge):
-- Sub 1:
-- Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession 
-- as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S)

-- Sub 2:
-- Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format
-- where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. 
-- If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.
(select concat(name, '(',left(OCCUPATION,1),')') from OCCUPATIONS) 
union 
(select concat('There are a total of', ' ', count(OCCUPATION), ' ',lower(occupation), 's.') from OCCUPATIONS group by OCCUPATION) order by 1;
-- Note: Learned to use 'union'.


-- Question 14 (Occupations - Pivot String):
-- Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. 
-- (contd) The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
-- (contd) Print NULL when there are no more names corresponding to an occupation.
SELECT 
MAX(CASE WHEN Occupation='Doctor' THEN Name ELSE NULL END) AS 'Doctor',
MAX(CASE WHEN Occupation='Professor' THEN Name ELSE NULL END) AS 'Professor',
MAX(CASE WHEN Occupation='Singer' THEN Name ELSE NULL END) AS 'Singer',
MAX(CASE WHEN Occupation='Actor' THEN Name ELSE NULL END) AS 'Actor' 
FROM ( SELECT * , ROW_NUMBER() OVER(PARTITION BY occupation ORDER BY name) AS rnumber 
FROM occupations ) a GROUP BY rnumber;
-- Note: Learned to use 'case' statement to create a 'pivot' with string values in MySQL.
   
   
-- Question 15 (Binary Tree Challenge):
-- You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.
-- (contd) Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following for each node:
-- (contd) Root: If node is root node. Leaf: If node is leaf node. Inner: If node is neither root nor leaf node.
select n,
case
when p is NULL then 'Root'
when n in (select distinct p from BST) then 'Inner'
else 'Leaf'
end as case1
from BST order by n;
-- Note: Another example of 'case' function.


-- Question 16 (New Companies Challenge): 
-- Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 
-- (contd) Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, 
-- (contd) total number of managers, and total number of employees. Order your output by ascending company_code.
select company.company_code, company.founder,
count(distinct(lead_manager.lead_manager_code)), 
count(distinct(senior_manager.senior_manager_code)),
count(distinct(manager.manager_code)),
count(distinct(employee.employee_code))
from company join lead_manager
on company.company_code = lead_manager.company_code
join senior_manager
on lead_manager.company_code = senior_manager.company_code
join manager
on senior_manager.company_code = manager.company_code
join employee
on manager.company_code = employee.company_code
group by company.company_code, company.founder;
-- Note: Learned to tackle Error 1055 by adding company.founder in group by as error 1055 appears when we group by using only company.company_code.
                    
                    
-- Question 17 (Rounding - Weather Observation Station):
-- Query The sum of all values in LAT_N and LONG_W rounded to a scale of 2 decimal places.
select round(sum(LAT_N), 2), round(sum(LONG_W), 2) from STATION;
-- Mote: Learned 'round' function.


-- Question 18 (Subquery with rounding - Weather Observation Station):
-- Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345 . Round your answer to 4 decimal places.
select round(max(long_w), 4) from station
where lat_n = (select max(lat_n) from station where lat_n < 137.2345);
-- A basic example of using subqueries. 


-- Question 19 (Manhatten Distance Challenge - Weather Observation Station): 
-- Consider p1(a,b) and p2(c,d) to be two points on a 2D plane.
-- (contd) a happens to equal the minimum value in Northern Latitude (LAT_N in STATION) ; b happens to equal the minimum value in Western Longitude (LONG_W in STATION)
-- (contd) c happens to equal the maximum value in Northern Latitude (LAT_N in STATION); d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
-- (contd) Query the Manhattan Distance between points p1 and p2 and round it to a scale of  decimal places.
select round((max(lat_n)-min(lat_n)) + (max(long_w)-min(long_w)), 4) from station;


-- Question 20 (Euclidean Distance - Weather Observation Station):
-- Condider P1(a,c) and P2(c,d) to be two points on a 2D plane where (a,b) are the respective minimum and maximum values of Northern Latitude (LAT_N)
-- and (c,d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
-- Query Euclidean distance between P1 and P2 with 4 decimal points.
select round(sqrt(power((max(lat_n)-min(lat_n)), 2) + power((max(long_w)-min(long_w)), 2)), 4) from station;
-- Note: Learned 'SQRT()', 'POWER()' functions along with concept of "Euclidean Distance".


-- Question 21 (Median - Weather Observation Station):
-- A median is defined as a number separating the higher half of a data set from the lower half. 
-- (contd) Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.
WITH row_n as (
SELECT lat_n, 
ROW_NUMBER() OVER(ORDER BY lat_n) as rn
FROM station
),
med as (
SELECT (COUNT(*) + 1) / 2 as cnt 
FROM row_n
)
SELECT ROUND(lat_n, 4)
FROM row_n, med
WHERE rn = cnt;
-- Note: Learned to find median value using 'row_number()', 'window function', and 'with' clause.
