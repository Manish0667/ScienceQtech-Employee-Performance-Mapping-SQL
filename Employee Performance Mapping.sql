-- 1: Create the database --
----------------------------
CREATE DATABASE employee;
USE employee;

-- 2: Import CSV files --
-------------------------
-- Use MySQL Workbench → Table Data Import Wizard
-- Import each CSV into its matching table.

-- 3: Create ER diagram --
--------------------------
-- Create diagram using MySQL → Database → Reverse Engineer

-- 4: Fetch employee details --
-------------------------------
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table;

-- 5: Filter by EMP_RATING --
-----------------------------
-- Less than 2:
SELECT * FROM emp_record_table
WHERE EMP_RATING < 2;

-- Greater then 4:
SELECT * FROM emp_record_table
WHERE EMP_RATING > 4;

-- Between 2 and 4:
SELECT * FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;

-- 6: Concatenate names in Finance dept --
------------------------------------------
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'Finance';

-- 7: Employees with reporters --
---------------------------------
SELECT MANAGER_ID, COUNT(*) AS REPORTERS
FROM emp_record_table
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID;

-- 8: Union: Healthcare + Finance --
------------------------------------
SELECT * FROM emp_record_table WHERE DEPT = 'Healthcare'
UNION
SELECT * FROM emp_record_table WHERE DEPT = 'Finance';

-- 9: Group by department + rating --
-------------------------------------
SELECT DEPT, EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EMP_RATING,
       MAX(EMP_RATING) OVER(PARTITION BY DEPT) AS MAX_DEPT_RATING
FROM emp_record_table;

-- 10: Min & max salary by role --
----------------------------------
SELECT ROLE, MIN(SALARY), MAX(SALARY)
FROM emp_record_table
GROUP BY ROLE;

-- 11: Rank by experience --
----------------------------
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP,
	   RANK() OVER(ORDER BY EXP DESC) AS EXP_RANK
FROM emp_record_table;

-- 12: Create salary view --
----------------------------
CREATE VIEW high_salary_view AS
SELECT *
FROM emp_record_table
WHERE SALARY > 6000;

-- Use function:
SELECT * FROM high_salary_view;

-- 13: experience > 10 years (nested) --
---------------------------------------
SELECT *
FROM emp_record_table
WHERE EXP > (
    SELECT AVG(EXP)
    FROM emp_record_table
) + 5;

-- 14: Stored procedure --
----------------------
CREATE PROCEDURE exp_more_than_3()
BEGIN
    SELECT *
    FROM emp_record_table
    WHERE EXP > 3;
END

-- Use function:
CALL exp_more_than_3();

-- 15: Stored function for job standard check --
------------------------------------------------
CREATE FUNCTION job_level (exp INT)
RETURNS VARCHAR(40)
DETERMINISTIC
BEGIN
    RETURN
    CASE
        WHEN exp <= 2 THEN 'JUNIOR DATA SCIENTIST'
        WHEN exp <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
        WHEN exp <= 10 THEN 'SENIOR DATA SCIENTIST'
        WHEN exp <= 12 THEN 'LEAD DATA SCIENTIST'
        WHEN exp <= 16 THEN 'MANAGER'
    END;
END

-- Use function:
SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.EXP,
    e.ROLE AS ASSIGNED_JOB_PROFILE,
    job_level(e.EXP) AS STANDARD_JOB_PROFILE,
    CASE
        WHEN e.ROLE = job_level(e.EXP)
        THEN 'MATCHES STANDARD'
        ELSE 'DOES NOT MATCH'
    END AS PROFILE_STATUS
FROM data_science_team e;

-- 16: Create index for FIRST_NAME search --
CREATE INDEX idx_first_name
ON emp_record_table (FIRST_NAME(50));

-- Use function:
SELECT *
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

-- 17: Calculate bonus --
-------------------------
SELECT EMP_ID, FIRST_NAME, SALARY, EMP_RATING,
       (SALARY * 0.05 * EMP_RATING) AS BONUS
FROM emp_record_table;

-- 18: AVG salary by continent + country --
-------------------------------------------
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS AVG_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY;