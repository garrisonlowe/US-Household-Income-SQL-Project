-- Active: 1712538144975@@localhost@3306@us_project


-- Exploratory Data Analysis Project

SELECT * FROM us_household_income;

SELECT * FROM us_household_income_statistics;

-- Top 10 States by Area of Water.
SELECT `State_Name`,
        SUM(`AWater`) total_water,
        RANK() OVER(ORDER BY SUM(`AWater`) DESC) total_water_rank
FROM us_household_income
GROUP BY `State_Name`
LIMIT 10
;

-- Top 10 States by Area of Land.
SELECT `State_Name`,
        SUM(`ALand`) total_land,
        RANK() OVER(ORDER BY SUM(`ALand`) DESC) total_land_rank
FROM us_household_income
GROUP BY `State_Name`
LIMIT 10
;


-- Joining the tables to gather usable data. 
SELECT *
FROM us_household_income u 
INNER JOIN us_household_income_statistics us 
    ON u.id = us.id
WHERE `Mean` <> 0;



-- Average Mean and Median per State ordered by lowest Average Income.
SELECT u.`State_Name`, 
        ROUND(AVG(`Mean`), 1) Avg_Income, 
        ROUND(AVG(`Median`), 1)
FROM us_household_income u 
INNER JOIN us_household_income_statistics us 
    ON u.id = us.id
WHERE `Mean` <> 0
GROUP BY u.`State_Name`
ORDER BY 2
;

-- Average Mean and Median per State ordered by highest Average Income.
SELECT u.`State_Name`, 
        ROUND(AVG(`Mean`), 1) Avg_Income, 
        ROUND(AVG(`Median`), 1)
FROM us_household_income u 
INNER JOIN us_household_income_statistics us 
    ON u.id = us.id
WHERE `Mean` <> 0
GROUP BY u.`State_Name` 
ORDER BY 2 DESC
;


-- Highest average income per Type of location.
SELECT Type,
        Count(`Type`),
        ROUND(AVG(`Mean`), 1) Avg_Income, 
        ROUND(AVG(`Median`), 1)
FROM us_household_income u 
INNER JOIN us_household_income_statistics us 
    ON u.id = us.id
WHERE `Mean` <> 0
GROUP BY `Type`
ORDER BY 3 DESC
;


-- Same query as above, but only where Count of Type is over 100 for usable data.
SELECT Type,
        Count(`Type`),
        ROUND(AVG(`Mean`), 1) Avg_Income, 
        ROUND(AVG(`Median`), 1)
FROM us_household_income u 
INNER JOIN us_household_income_statistics us 
    ON u.id = us.id
WHERE `Mean` <> 0
GROUP BY `Type`
HAVING COUNT(`Type`) > 100
ORDER BY 3 DESC
;


-- Average income per City ordered by City highest to lowest.
SELECT u.`State_Name`, `City`, ROUND(AVG(`Mean`),1)
FROM us_household_income u 
INNER JOIN us_household_income_statistics us 
    ON u.id = us.id
GROUP BY u.`State_Name`, `City`
ORDER BY 3 DESC
;