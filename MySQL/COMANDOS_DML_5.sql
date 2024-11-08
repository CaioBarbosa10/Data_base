SELECT first_name, last_name
FROM employees
WHERE REGEXP_INSTR(first_name, '^Aug(u|uh)sto$');

SELECT first_name, REGEXP_REPLACE(first_name, '^A(a|e|i|o|u)', '**')
AS "Modificação no nome"
FROM employees;

USE world;

SELECT name, REGEXP_INSTR(name, '(ab)') AS "Contagem do Padrão 'ab'"
FROM country
WHERE REGEXP_INSTR(name, '(ab)')>0;