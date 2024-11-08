#EMPLOYEES DATABASE
#1 – Quantidade de empregados alocados por setor em cada um dos anos, separando em dois
#comandos diferentes, que podem ser views, funcionários ativos e inativos conforme o modelo.

CREATE VIEW active_employees_per_dept_year AS
SELECT 
    d.dept_name,
    YEAR(de.from_date) AS year,
    COUNT(e.emp_no) AS active_employees
FROM 
    employees e
JOIN 
    dept_emp de ON e.emp_no = de.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no
WHERE 
    de.to_date = '9999-01-01' 
GROUP BY 
    d.dept_name, YEAR(de.from_date);
    
    
CREATE VIEW inactive_employees_per_dept_year AS
SELECT 
    d.dept_name,
    YEAR(de.from_date) AS year,
    COUNT(e.emp_no) AS inactive_employees
FROM 
    employees e
JOIN 
    dept_emp de ON e.emp_no = de.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no
WHERE 
    de.to_date != '9999-01-01' 
GROUP BY 
    d.dept_name, YEAR(de.from_date);
#2 – Quantidade de cargos ocupada por cada funcionário no histórico de prestação de serviços
#de cada um deles na empresa.

SELECT e.emp_no, e.first_name, e.last_name, COUNT(t.title) AS quantidade_cargos
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name
ORDER BY quantidade_cargos DESC;


#3– Média de cargos ocupada por cada funcionário e geral da empresa demonstrado, em
#comandos separados, que podem ser views, quais deles ficaram abaixo da média geral de cargos
#e quais ficaram acima da média geral de cargos.

CREATE VIEW employee_titles_count AS
SELECT e.emp_no, e.first_name, e.last_name, COUNT(t.title) AS quantidade_cargos
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
GROUP BY e.emp_no, e.first_name, e.last_name;

CREATE VIEW employee_average_titles AS
SELECT emp_no, first_name, last_name, quantidade_cargos,
       AVG(quantidade_cargos) OVER () AS media_geral
FROM employee_titles_count;

CREATE VIEW below_average_titles AS
SELECT emp_no, first_name, last_name, quantidade_cargos
FROM employee_average_titles
WHERE quantidade_cargos < media_geral;


CREATE VIEW above_average_titles AS
SELECT emp_no, first_name, last_name, quantidade_cargos
FROM employee_average_titles
WHERE quantidade_cargos > media_geral;

#4 – Qual a média de salários de cada departamento e a média geral da empresa demonstrando
#em comandos separados, que podem ser views, quais focaram acima e abaixo da média por
#ano.
CREATE VIEW department_avg_salary AS
SELECT d.dept_no, d.dept_name, YEAR(s.from_date) AS ano, AVG(s.salary) AS media_salario
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_no, d.dept_name, YEAR(s.from_date);


CREATE VIEW company_avg_salary AS
SELECT YEAR(s.from_date) AS ano, AVG(s.salary) AS media_geral
FROM salaries s
GROUP BY YEAR(s.from_date);

CREATE VIEW department_vs_company_avg AS
SELECT das.dept_no, das.dept_name, das.ano, das.media_salario, cas.media_geral
FROM department_avg_salary das
JOIN company_avg_salary cas ON das.ano = cas.ano;

CREATE VIEW below_avg_departments AS
SELECT dept_no, dept_name, ano, media_salario, media_geral
FROM department_vs_company_avg
WHERE media_salario < media_geral;

CREATE VIEW above_avg_departments AS
SELECT dept_no, dept_name, ano, media_salario, media_geral
FROM department_vs_company_avg
WHERE media_salario > media_geral;

#SAKILA DATABASE

-- 1- Quantidade de filmes locados por categoria em cada um dos anos, separando em dois
-- comandos diferentes, que podem ser views, a lista de filmes e a lista de filmes com seus
-- respectivos atores. 

CREATE VIEW filmes_por_categoria AS
SELECT c.name AS categoria, COUNT(f.film_id) AS quantidade_filmes
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

CREATE VIEW filmes_por_ano AS
SELECT YEAR(r.rental_date) AS ano, COUNT(f.film_id) AS quantidade_filmes
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY YEAR(r.rental_date);

#2– Quantidade de filmes por categoria e os valores totais de locação de cada filme, separando
#em dois comandos diferentes, que podem ser views, valores por filme e valores por categoria.

CREATE VIEW valores_por_filme AS
SELECT f.film_id, f.title, SUM(p.amount) AS total_locacao
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title;

CREATE VIEW valores_por_categoria AS
SELECT c.name AS categoria, COUNT(f.film_id) AS quantidade_filmes, SUM(p.amount) AS total_locacao
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name;

#3 – Média de atuação de cada ator em filmes geral do inventário de filmes, em comandos
#separados, que podem ser views, quais deles ficaram abaixo da média geral de atuações e quais
#ficaram acima da média geral de atuações. 

CREATE VIEW media_por_ator AS
SELECT ac.actor_id, ac.first_name, ac.last_name, COUNT(f.film_id) AS quantidade_filmes
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor ac ON fa.actor_id = ac.actor_id
GROUP BY ac.actor_id, ac.first_name, ac.last_name;

CREATE VIEW media_geral AS
SELECT AVG(quantidade_filmes) AS media_geral
FROM media_por_ator;

CREATE VIEW atores_abaixo_da_media AS
SELECT mpa.actor_id, mpa.first_name, mpa.last_name, mpa.quantidade_filmes
FROM media_por_ator mpa
JOIN media_geral mg
ON mpa.quantidade_filmes < mg.media_geral;

CREATE VIEW atores_acima_da_media AS
SELECT mpa.actor_id, mpa.first_name, mpa.last_name, mpa.quantidade_filmes
FROM media_por_ator mpa
JOIN media_geral mg
ON mpa.quantidade_filmes >= mg.media_geral;

#4-Qual o valor médio de locações de cada categoria e a média geral da empresa demonstrando
#em comandos separados, que podem ser views, quais filmes ficaram acima e abaixo da média
#da categoria por ano.


CREATE VIEW media_locacao_por_categoria AS
SELECT c.name AS categoria, AVG(p.amount) AS media_locacao
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

CREATE VIEW media_geral_locacao AS
SELECT AVG(p.amount) AS media_geral;



## WORD SCHEMA

# 1 – Top 3 continentes em quantidade populacional registrados na base de dados. 
SELECT continent, SUM(population) AS total_population
FROM country
GROUP BY continent
ORDER BY total_population DESC
LIMIT 3;

#2 – Expectativa de vida média por país e geral do planeta, de acordo com os dados registrados
#em comandos separados, que podem ser views, quais deles ficaram abaixo e quais ficaram acima
#da média geral da expectativa de vida.


CREATE OR REPLACE VIEW global_life_expectancy_avg AS
SELECT AVG(LifeExpectancy) AS avg_life_expectancy
FROM country;

CREATE OR REPLACE VIEW country_life_expectancy AS
SELECT name, LifeExpectancy
FROM country;

CREATE OR REPLACE VIEW life_expectancy_comparison AS
SELECT 
    c.name,
    c.LifeExpectancy,
    CASE
        WHEN c.LifeExpectancy >= g.avg_life_expectancy THEN 'Acima'
        ELSE 'Abaixo'
    END AS comparison
FROM 
    country_life_expectancy AS c
JOIN 
    global_life_expectancy_avg AS g;

SELECT * FROM life_expectancy_comparison;

#3 – Média de quantidade populacional de cada país por continente, em comandos separados,
#que podem ser views, quais deles ficaram abaixo da média geral de atuações e quais ficaram
#acima da média geral da população levando em consideração o agrupamento dos continentes. 

CREATE OR REPLACE VIEW global_population_avg AS
SELECT AVG(population) AS avg_population_global
FROM country;

CREATE OR REPLACE VIEW continent_population_avg AS
SELECT 
    continent, 
    AVG(population) AS avg_population_continent
FROM 
    country
GROUP BY 
    continent;
    
    CREATE OR REPLACE VIEW continent_population_comparison AS
SELECT 
    c.continent,
    c.avg_population_continent,
    CASE
        WHEN c.avg_population_continent >= g.avg_population_global THEN 'Acima'
        ELSE 'Abaixo'
    END AS comparison
FROM 
    continent_population_avg AS c
JOIN 
    global_population_avg AS g;

SELECT * FROM continent_population_comparison;