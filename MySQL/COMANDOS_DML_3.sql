CREATE TABLE t1 (
  c1 int(11) DEFAULT NULL,
  c2 int(11) DEFAULT NULL,
  c3 int(11) DEFAULT NULL,
  CONSTRAINT c1_nonzero CHECK ((c1 <> 0)),
  CONSTRAINT c2_positive CHECK ((c2 > 0)),
  CONSTRAINT t1_chk_1 CHECK ((c1 <> c2)),
  CONSTRAINT t1_chk_2 CHECK ((c1 > 10)),
  CONSTRAINT t1_chk_3 CHECK ((c3 < 100)),
  CONSTRAINT t1_chk_4 CHECK ((c1 > c3))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

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
