CREATE OR REPLACE VIEW Rel_Sal_Mensal AS
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
GROUP BY d.dept_name, t.title  WITH ROLLUP;

SELECT * FROM Rel_Sal_Mensal;

use world;

CREATE OR REPLACE VIEW Paises_do_Caribe AS 
SELECT Code, Name, Population, Capital
FROM 
country
WHERE region = "Caribbean";


SELECT *
FROM country 
WHERE Code = 'ABW';

SELECT * FROM Paises_do_Caribe;

UPDATE Paises_do_Caribe
SET Name = 'Aruba4'
WHERE Code = 'ABW';


use employees;

SELECT e.last_name, vil.dept_no, vil.maxsal
FROM employees e, dept_emp de,
								(SELECT dept_no, max(salary) maxsal
                                 FROM salaries INNER JOIN dept_emp USING (emp_no)
								 GROUP BY dept_no) vil, salaries sal
WHERE e.emp_no = de.emp_no
AND vil. dept_no = de.dept_no
AND sal.emp_no= e.emp_no
AND sal.salary = vil.maxsal;

