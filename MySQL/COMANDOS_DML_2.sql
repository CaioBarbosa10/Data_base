SELECT t.title, d.dept_name, e.first_name,e.last_name, (s1.salary/12), de.from_date, de.to_date
FROM titles t INNER JOIN employees e USING (emp_no)
              INNER JOIN dept_emp de ON (e.emp_no=de.emp_no)
              INNER JOIN departments d ON (de.dept_no=d.dept_no)
              INNER JOIN salaries s1 ON(e.emp_no=s1.emp_no)
WHERE (s1.salary/12) > (SELECT ROUND((MAX(s2.salary)/12),2) as "Salário Máximo Mensal"
						FROM employees e2 INNER JOIN dept_manager dm ON (e2.emp_no=dm.emp_no)
                                          INNER JOIN salaries s2     ON (s2.emp_no=e2.emp_no)
                        WHERE dm.to_date = '9999-01-01')
AND d.dept_name = 'Marketing' 
AND de.to_date ='9999-01-01'
AND t.to_date = '9999-01-01'
AND s1.to_date = '9999-01-01'
ORDER BY e.first_name,e.last_name;   

SELECT t.title, d.dept_name, e.first_name,e.last_name, (s1.salary/12), de.from_date, de.to_date
FROM titles t INNER JOIN employees e USING (emp_no)
              INNER JOIN dept_emp de ON (e.emp_no=de.emp_no)
              INNER JOIN departments d ON (de.dept_no=d.dept_no)
              INNER JOIN salaries s1 ON(e.emp_no=s1.emp_no)
WHERE (s1.salary/12) > (SELECT ROUND((AVG(s2.salary)/12),2) as "Media Mensal do Salário"
						FROM employees e2 INNER JOIN dept_manager dm ON (e2.emp_no=dm.emp_no)
                                          INNER JOIN salaries s2     ON (s2.emp_no=e2.emp_no)
                        WHERE dm.to_date = '9999-01-01' AND s2.salary is not NULL)
AND d.dept_name = 'Marketing' 
AND de.to_date ='9999-01-01'
AND t.to_date = '9999-01-01'
AND s1.to_date = '9999-01-01'
ORDER BY e.first_name,e.last_name;   

USE world;

SELECT c.ID, c.Name
FROM city c 
WHERE c.CountryCode = (SELECT Code
                       FROM country
                       WHERE Name = 'Brazil');
			
SELECT format(SUM(c.Population),2) as "SOMA DA POPULAÇÃO DO PAÍS" 
FROM city c 
WHERE c.CountryCode = (SELECT Code
                       FROM country
                       WHERE Name = 'Argentina');

use employees;
                       
SELECT d.dept_name, MIN(s1.salary)
FROM titles t INNER JOIN employees e USING (emp_no)
              INNER JOIN dept_emp de ON (e.emp_no=de.emp_no)
              INNER JOIN departments d ON (de.dept_no=d.dept_no)
              INNER JOIN salaries s1 ON(e.emp_no=s1.emp_no)
WHERE 
de.to_date ='9999-01-01'
AND t.to_date = '9999-01-01'
AND s1.to_date = '9999-01-01'
GROUP BY  d.dept_name
HAVING MIN(s1.salary) > (SELECT ROUND((AVG(s2.salary)/12),2)
			       FROM employees e2 INNER JOIN dept_manager dm ON (e2.emp_no=dm.emp_no)
                                     INNER JOIN salaries s2     ON (s2.emp_no=e2.emp_no)
                WHERE dm.to_date = '9999-01-01')
ORDER BY d.dept_name;   

SELECT * 
FROM employees e
WHERE YEAR(e.hire_date) IN ( SELECT YEAR(t.from_date)
                             FROM titles t
							 WHERE t.title = 'Senior Staff'
                             AND t.to_date = '9999-01-01');

SELECT * 
FROM employees e
WHERE YEAR(e.hire_date) > ANY ( SELECT DISTINCT(YEAR(t.from_date))
                                FROM titles t
							    WHERE t.title = 'Staff'
                                AND t.to_date = '9999-01-01');                 

SELECT * 
FROM employees e
WHERE YEAR(e.hire_date) < ALL ( SELECT DISTINCT(YEAR(dm.from_date))
                                FROM dept_manager dm
							    WHERE 
								dm.to_date = '9999-01-01');
                                                          
SELECT *
FROM employees
WHERE (emp_no,hire_date) IN (SELECT emp_no, from_date
                             FROM dept_emp 
                             WHERE dept_no = 'd003')
 AND gender = 'F';                    

SELECT first_name, last_name, birth_date
FROM employees
WHERE birth_date IN ( SELECT from_date
					  FROM   dept_emp);                    

SELECT d.dept_name, MIN(s1.salary/12)
FROM titles t INNER JOIN employees e USING (emp_no)
              INNER JOIN dept_emp de ON (e.emp_no=de.emp_no)
              INNER JOIN departments d ON (de.dept_no=d.dept_no)
              INNER JOIN salaries s1 ON(e.emp_no=s1.emp_no)
WHERE 
de.to_date ='9999-01-01'
AND t.to_date = '9999-01-01'
AND s1.to_date = '9999-01-01'
GROUP BY  d.dept_name
HAVING MIN(s1.salary/12) > ANY (SELECT ((s2.salary)/12)
			       FROM employees e2 INNER JOIN dept_manager dm ON (e2.emp_no=dm.emp_no)
                                     INNER JOIN salaries s2     ON (s2.emp_no=e2.emp_no)
                WHERE dm.to_date = '9999-01-01'
                AND dm.dept_no = 'd003')
ORDER BY d.dept_name;   

use sakila;

SELECT p.customer_id, p.rental_id, p.amount
FROM payment p
WHERE p.amount > (SELECT AVG(p1.amount)
					   FROM payment p1
                       WHERE p1.customer_id= p.customer_id);

use employees;

SELECT first_name, last_name
FROM employees e
WHERE NOT EXISTS (SELECT *
                  FROM dept_manager dm
                  WHERE dm.emp_no=e.emp_no);

SELECT e.first_name, e.last_name
FROM employees e
WHERE NOT EXISTS (SELECT *
                  FROM titles t
                  WHERE t.emp_no=e.emp_no
                  AND title = 'Staff')
AND e.emp_no BETWEEN 10000 AND 12000



