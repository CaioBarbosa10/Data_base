use world;

SELECT MIN(Percentage) as "menor percentual em que se tem a lingua Inglesa"
FROM countrylanguage
WHERE Language = 'English'
AND IsOfficial = 'T'
AND Percentage > 0;

SELECT MIN(LifeExpectancy) as "País com a menor expextativa de vida"
FROM country;

SELECT MIN(Name)
FROM country;

SELECT name
FROM country
ORDER BY name;


SELECT MAX(Percentage)
FROM countrylanguage
WHERE Language = 'English'
AND IsOfficial = 'T'
AND Percentage >0;

SELECT MAX(LifeExpectancy)
FROM country;

SELECT MAX(Name)
FROM country;

SELECT name
FROM country
ORDER BY name DESC;

SELECT SUM(SurfaceArea) as "Área da Superfície Total do Caribe"
FROM country
WHERE Region = 'Caribbean';


USE employees;

SELECT ROUND((SUM(salary)/12),2)
FROM salaries s INNER JOIN employees e   ON (s.emp_no=e.emp_no)
                INNER JOIN dept_emp de   ON (e.emp_no=de.emp_no)
                INNER JOIN departments d ON (de.dept_no= d.dept_no)
 WHERE d.dept_name = 'Marketing'
 AND de.to_date ='9999-01-01'
 AND e.hire_date > '1999-01-01';
 
SELECT ROUND(AVG(salary),2) as "Media de Salário Anual do departamento"
FROM salaries s INNER JOIN employees e   ON (s.emp_no=e.emp_no)
                INNER JOIN dept_emp de   ON (e.emp_no=de.emp_no)
                INNER JOIN departments d ON (de.dept_no= d.dept_no)
 WHERE d.dept_name = 'Marketing'
 AND de.to_date ='9999-01-01'
 AND e.hire_date > '1999-01-01';
 
SELECT ROUND((AVG(salary)/12),2) as "Media de Salário Mensal do departamento"
FROM salaries s INNER JOIN employees e   ON (s.emp_no=e.emp_no)
                INNER JOIN dept_emp de   ON (e.emp_no=de.emp_no)
                INNER JOIN departments d ON (de.dept_no= d.dept_no)
 WHERE d.dept_name = 'Marketing'
 AND de.to_date ='9999-01-01'
 AND e.hire_date < '1999-01-01';
 
use world;
 
SELECT ROUND(VARIANCE(LifeExpectancy),4)
FROM country;
 
SELECT ROUND(STDDEV(LifeExpectancy),1)
FROM country;

SELECT MIN(LifeExpectancy)  as "Expectativa de vida mínima", MAX(LifeExpectancy) as "Expectativa de vida máxima", 
       AVG (LifeExpectancy) as "Expectativa de média"
FROM country;

use employees;

SELECT COUNT(*)
FROM employees
WHERE hire_date < '1999-01-01';

use world;

select * from country;

SELECT DISTINCT(Continent) 
FROM country
ORDER BY Continent;

SELECT COUNT(DISTINCT(Continent)) 
FROM country;

use employees;

SELECT DISTINCT emp_no, dept_no
FROM dept_emp
WHERE to_date = '9999-01-01'
AND dept_no = 'd007'
ORDER BY emp_no;

SELECT de.dept_no, d.dept_name, COUNT(emp_no)
FROM departments d LEFT OUTER JOIN  dept_emp de USING(dept_no)
WHERE de.to_date = '9999-01-01'
GROUP BY de.dept_no
ORDER BY de.dept_no;

use world;

SELECT Continent,SUM(SurfaceArea) as "Área Total do Continente"
FROM country 
GROUP BY Continent
ORDER BY Continent;

SELECT ct.Name , c.District, SUM(c.Population)
FROM city c INNER JOIN country ct ON (c.CountryCode=ct.Code)
GROUP BY c.CountryCode, c.District;
 
SELECT ct.Name as "Nome do País", c.District as "Nome do Estado", AVG(c.Population)
FROM city c INNER JOIN country ct ON (c.CountryCode=ct.Code)
GROUP BY c.CountryCode,c.District
ORDER BY ct.Name;
 
SELECT ct.Name , c.District, SUM(c.Population)
FROM city c INNER JOIN country ct ON (c.CountryCode=ct.Code)
GROUP BY c.CountryCode, c.District
HAVING COUNT(c.District) > 2
ORDER BY ct.Name,c.District;

use employees;

SELECT d.dept_name, ROUND(MAX(salary),2), AVG(salary)
FROM dept_emp de INNER JOIN employees e   ON (de.emp_no=e.emp_no)
                 INNER JOIN departments d ON (de.dept_no=d.dept_no)
                 INNER JOIN salaries    s ON (s.emp_no=e.emp_no)
WHERE de.to_date = '9999-01-01'
AND    s.to_date = '9999-01-01'
GROUP BY d.dept_no
HAVING AVG(salary) > 70000
ORDER BY d.dept_no;

use world;

SELECT ct.Name , c.District, ROUND(AVG(c.Population),2)
FROM city c INNER JOIN country ct ON (c.CountryCode=ct.Code)
GROUP BY ct.Name,c.District WITH ROLLUP;

SELECT ct.Continent, ct.Region , c.Name, AVG(c.Population)
FROM city c INNER JOIN country ct ON (c.CountryCode=ct.Code)
GROUP BY ct.Continent,ct.Region,c.Name WITH ROLLUP;

SELECT ct.Region , c.Name, c.District, AVG(c.Population)
FROM city c INNER JOIN country ct ON (c.CountryCode=ct.Code)
GROUP BY ct.Region,c.Name, c.District WITH ROLLUP;

use employees;

SELECT d.dept_name, ROUND((AVG(salary)/12),2) as "Média de salário mensal"
FROM dept_emp de INNER JOIN employees e   ON (de.emp_no=e.emp_no)
                 INNER JOIN departments d ON (de.dept_no=d.dept_no)
                 INNER JOIN salaries    s ON (s.emp_no=e.emp_no)
WHERE de.to_date = '9999-01-01'
AND    s.to_date = '9999-01-01'
GROUP BY d.dept_name WITH ROLLUP;

SELECT d.dept_name, t.title as "Cargo", count(de.emp_no) as "Qtde de funcionários com este cargo", 
       ROUND((AVG(salary)/12),2) as "Média de salário mensal", 
       ROUND((MAX(salary)/12),2) as "Maior salário mensal do departamento",
       ROUND((MIN(salary)/12),2) as "Menor salário mensal do departamento"
FROM dept_emp de INNER JOIN employees e   ON (de.emp_no=e.emp_no)
                 INNER JOIN departments d ON (de.dept_no=d.dept_no)
                 INNER JOIN salaries    s ON (s.emp_no=e.emp_no)
                 INNER JOIN titles      t ON (e.emp_no=t.emp_no)
WHERE de.to_date = '9999-01-01'
AND    s.to_date = '9999-01-01'
GROUP BY d.dept_name, t.title  WITH ROLLUP
ORDER BY d.dept_name ;

SELECT IF(GROUPING(d.dept_name),"Geral da empresa",d.dept_name) as "Departamentos",
       IF(GROUPING(t.title),"Geral do departamento",t.title) as "Cargos", 
       count(de.emp_no) as "Qtde de funcionários com este cargo", 
       ROUND((AVG(salary)/12),2) as "Média de salário mensal", 
       ROUND((MAX(salary)/12),2) as "Maior salário mensal do departamento",
       ROUND((MIN(salary)/12),2) as "Menor salário mensal do departamento"
FROM dept_emp de INNER JOIN employees e   ON (de.emp_no=e.emp_no)
                 INNER JOIN departments d ON (de.dept_no=d.dept_no)
                 INNER JOIN salaries    s ON (s.emp_no=e.emp_no)
                 INNER JOIN titles      t ON (e.emp_no=t.emp_no)
WHERE de.to_date = '9999-01-01'
AND    s.to_date = '9999-01-01'
GROUP BY d.dept_name, t.title  WITH ROLLUP
ORDER BY d.dept_name, Cargos;


SELECT emp_no
FROM employees e 
UNION ALL
SELECT emp_no
FROM dept_emp;


SELECT emp_no
FROM employees e 
UNION 
SELECT emp_no
FROM dept_emp;


