-- -------------------------------------------------------------------------------------------
-- ---------------------------------- Business Questions -------------------------------------

-- 1. What is the gender breakdown of employees in the company?

SELECT gender, count(gender) AS gender_count
FROM hr
GROUP BY gender;

-- --------------------------------------------------------------------------------------
-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT race, count(race) AS race_identity
FROM hr
GROUP BY race
ORDER BY race_identity DESC;

-- --------------------------------------------------------------------------------------
-- 3. What is the age distribution of employees in the company?

SELECT
	MAX(age) AS Oldest,
	MIN(age) AS Youngest
FROM hr;

-- ------------------------------------------------------------
-- Count age by age group

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(age) AS emp_in_each_group
FROM hr
GROUP BY age_group
ORDER BY age_group;

-- ------------------------------------------------------------
-- Count age by age group and gender

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(age) AS emp_in_each_group
FROM hr
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- --------------------------------------------------------------------------------------
-- 4. How many employees work at headquarters versus remote locations?

SELECT location, count(location) AS emp_in_each_location
FROM hr
GROUP BY location;

-- --------------------------------------------------------------------------------------
-- 5. What is the average length of employment for employees who have been terminated?

SELECT ROUND(AVG(DATEDIFF(term_date, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE term_date <= CURDATE();

-- --------------------------------------------------------------------------------------
-- 6. How does the gender distribution vary across departments and job titles?

SELECT department, job_title, gender, COUNT(gender) as gender_count
FROM hr
GROUP BY department, gender
ORDER BY department;

-- --------------------------------------------------------------------------------------
-- 7. What is the distribution of job titles across the company?

SELECT job_title, COUNT(job_title) AS job_title_count
FROM hr
GROUP BY job_title
ORDER BY job_title;

-- --------------------------------------------------------------------------------------
-- 8. Which department has the highest employee turnover rate (termination rate)?

/-- -- USE 'CASE statement' to calculate

SELECT department, COUNT(*) as total_empolyee, 
    SUM(CASE WHEN term_date <= CURDATE() AND term_date <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_employee, 
    SUM(CASE WHEN term_date = '0000-00-00' THEN 1 ELSE 0 END) as active_employee,
	ROUND((SUM(CASE WHEN term_date <= CURDATE() THEN 1 ELSE 0 END) / COUNT(term_date))*100,2) AS termination_rate
FROM hr
GROUP BY department
ORDER BY termination_rate DESC;

-- Alternative way --------------------------------------------
/-- -- USE 'subquery' to calculate



-- --------------------------------------------------------------------------------------
-- 9. What is the distribution of employees across locations by city and state?

-- employees across locations by city

SELECT location_city , COUNT(location_city) AS employee_count_by_city
FROM hr
GROUP BY location_city
ORDER BY COUNT(location_city) DESC;

-- employees across locations by state

SELECT location_state, COUNT(location_state) AS employee_count_by_state
FROM hr
GROUP BY location_state
ORDER BY COUNT(location_state) DESC;

-- ------------------------------------------------------------------------------------------------
-- 10. How has the company's employee count changed over time based on hire and term dates?

-- In this query hire_date is consider as "Year" and count the hire_date to calculate the "no_of_hires". 
-- and then calculate the "no_of_terminations", and net change (the difference between "no_of_hires" and "no_of_terminations") for each year. 
-- The results are sorted by year in ascending order.

/-- -- USE 'CASE statement' to calculate

SELECT 
    YEAR(hire_date) AS year, 
    COUNT(hire_date) AS no_of_hires, 
    SUM(CASE WHEN term_date <> '0000-00-00' AND term_date <= CURDATE() THEN 1 ELSE 0 END) AS no_of_terminations, 
    COUNT(*) - SUM(CASE WHEN term_date <> '0000-00-00' AND term_date <= CURDATE() THEN 1 ELSE 0 END) AS employees_net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN term_date <> '0000-00-00' AND term_date <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM hr
GROUP BY year
ORDER BY year ASC;

-- Alternative way --------------------------------------------

-- USE 'subquery' to calculate

SELECT 
    year, no_of_hires, no_of_terminations,
    (no_of_hires - no_of_terminations) AS employees_net_change,
    ROUND(((no_of_hires - no_of_terminations) / no_of_hires * 100), 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year, 
        COUNT(hire_date) AS no_of_hires,
        SUM(CASE WHEN term_date <> '0000-00-00' AND term_date <= CURDATE() THEN 1 ELSE 0 END) AS no_of_terminations
    FROM hr
    GROUP BY year)  AS subquery
ORDER BY year ASC;

-- --------------------------------------------------------------------------------------
-- 11. What is the tenure distribution for each department?

SELECT 
	 department, ROUND(AVG(DATEDIFF(CURDATE(), term_date)/365),0) as avg_tenure
FROM hr
WHERE term_date <= CURDATE() AND term_date <> '0000-00-00' 
GROUP BY department
ORDER BY avg_tenure DESC;

-- -------------------------------------------------- ######## -----------------------------------------------------------

