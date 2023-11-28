-- --------------------------------------------------------------------------------------
-- Database creation
-- Use as default Database 
-- import dataset into database - table "hr"

CREATE DATABASE human_resource;

----- select database human_resource for default use
USE human_resource;

SELECT *
FROM hr;

-- Check Data type
DESCRIBE hr;

-- --------------------------------------------------------------------------------------
-- ---------------------------------- Data Cleaning -------------------------------------

-- Change table name

ALTER TABLE hr
CHANGE COLUMN ï»¿id employee_id VARCHAR(20) NULL;
 
-- --------------------------------------------------------------------------------------
-- Change Date format
 
 -- SET sql_safe_updates=0;
 -- SET sql_mode=' ';
 
 UPDATE hr
 SET birth_date =
	CASE 
		WHEN birth_date LIKE '%/%' THEN date_format(str_to_date(birth_date,'%m/%d/%Y'), '%Y-%m-%d')
		WHEN birth_date LIKE '%-%' THEN date_format(str_to_date(birth_date,'%m-%d-%Y'), '%Y-%m-%d')
		ELSE NULL
	END;
 
----- Change Data type
    
ALTER TABLE hr
MODIFY COLUMN birth_date DATE;

-- --------------------------------------------------------------------------------------
-- Change Date format
 
 UPDATE hr
 SET hire_date=
	CASE WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'), '%Y-%m-%d')
		 WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'), '%Y-%m-%d')
         ELSE NULL
	END;
    
----- Change Data type
    
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
 
-- --------------------------------------------------------------------------------------
-- Change Date format

UPDATE hr
SET term_date = IF(term_date IS NOT NULL AND term_date != '', date(str_to_date(term_date, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

-- SET sql_mode = 'ALLOW_INVALID_DATES';

-- Change Data type
    
ALTER TABLE hr
MODIFY COLUMN term_date DATE;
 
-- --------------------------------------------------------------------------------------
-- Add new column "age"

ALTER TABLE hr
ADD COLUMN age INT;
 
-- --------------------------------------------------------------------------------------
-- calculate the "age"

UPDATE hr
SET age = timestampdiff(YEAR, birth_date, CURDATE());

-- --------------------------------------------------------------------------------------

-- Few employees' age has been calculated as a negative value because some dates in "birth_date" were wrongly calculated like 2060 instead of 1960 is mentioned, which is totally wrong.
-- to subtract 100 years from "birth_date" I applied DATE_SUB function.

UPDATE hr
SET birth_date = DATE_SUB(birth_date, INTERVAL 100 YEAR)
WHERE birth_date >= '2060-01-01' AND birth_date < '2070-01-01';