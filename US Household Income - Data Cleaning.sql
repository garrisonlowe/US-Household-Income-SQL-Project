-- Active: 1712538144975@@localhost@3306@us_project

SELECT *
FROM us_household_income;

SELECT * 
FROM us_household_income_statistics;

-- Fixing weird ID column name.
ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`
;


-- Getting counts for both tables.
SELECT COUNT(id) 
FROM us_household_income
;

SELECT COUNT(id)
FROM us_household_income_statistics
;


-- Identifying duplicates based on ID for US Household Income table.
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;


-- Finding the Row ID's for all of the duplicates
SELECT *
FROM (
    SELECT row_id, id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
    FROM us_household_income
     ) duplicates
WHERE row_num > 1
;


-- Deleting the duplicates using a subquery
DELETE FROM us_household_income
WHERE row_id IN 
(
    SELECT row_id
    FROM (
        SELECT row_id, id,
        ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
        FROM us_household_income
         ) duplicates
WHERE row_num > 1
)
;


-- Checking for duplicates in the Household Statistics table. There were none
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;


-- Checking for inaccurate state names.
SELECT DISTINCT `State_Name`, COUNT(`State_Name`)
FROM us_household_income
GROUP BY `State_Name`
;


-- Changing wrong spelling of Georgia on one row, found in query above.
UPDATE us_household_income
SET `State_Name` = 'Georgia'
WHERE `State_Name` = 'georia'
;


-- Found many 'alabama' rows in the data, changing to capitalized.
UPDATE us_household_income
SET `State_Name` = 'Alabama'
WHERE `State_Name` = 'alabama'
;


-- Checking for inaccurate State Abbreviations.
SELECT DISTINCT `State_ab`
FROM us_household_income
GROUP BY `State_ab`
;


-- Checking for blank place values.
SELECT *
FROM us_household_income
WHERE `Place` = ''
;


-- Setting one blank row to Autaugaville.
UPDATE us_household_income
SET `Place` = 'Autaugaville'
WHERE `County` = 'Autauga County' 
AND `City` = 'Vinemont'
;


-- Checking for Type inaccuracies.
SELECT `Type`, COUNT(`Type`)
FROM us_household_income
GROUP BY `Type`
;


-- Updating wrong 'Borough' type row.
UPDATE us_household_income
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs' 
;


--Checking for zero, blank, or null AWater values.
SELECT `ALand`, `AWater`
FROM us_household_income
WHERE `AWater` = 0 OR `AWater` = '' OR `AWater` IS NULL
;


--Checking for zero, blank, or null ALand values.
SELECT `ALand`, `AWater`
FROM us_household_income
WHERE `ALand` = 0 OR `ALand` = '' OR `ALand` IS NULL
;

