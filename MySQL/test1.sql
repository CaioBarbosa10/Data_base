# Corrigindo querys do Problema 1
SELECT category_id FROM film_category;


SELECT payment_id, rental_id, amount, payment_date FROM payment;

SELECT * FROM address WHERE district in ('Georgia', 'Tete', 'Gois'); 

SELECT actor_id,first_name, last_name FROM actor WHERE first_name like 'J%';

# Problema 2
#a) Calcule os valores das multas das locações na tabela payment considerando que todos
#estão atrasados e aplicando um percentual de 20% para todos pelo atraso. 

SELECT amount, 
       amount * 1.20 AS multas_de_aluguel
FROM payment;

#b) Listar as cidades que contém parte do nome com a sequência de caracteres ana.
SELECT city
from city
where city like '%ana%';

#c) Listar os países que iniciam seus nomes com a letra R e que terminam com a letra A
#(desconsiderar maiúsculas e minúsculas).

SELECT country
from country
where country like 'R%' and 
country like'%a';

#d)Listar os nomes dos filmes que fazem alguma menção ao assunto feminismo.

SELECT description
from film
where description like '%feminist%';

#e) Listas as locações que foram feitas pelos clientes cadastrados entre os números 100 e
#300
SELECT r.*
FROM rental AS r
JOIN customer c ON r.customer_id = c.customer_id
where c.customer_id between 100 and 300;

# mostrando de acordo com as datas 
SELECT r.*
FROM rental AS r
JOIN customer AS c ON c.customer_id = r.customer_id
WHERE r.rental_date BETWEEN '2006-01-01' AND '2006-12-31';

# total de acordo com as datas
SELECT COUNT(r.rental_id) AS total_rentals
FROM rental AS r
JOIN customer AS c ON c.customer_id = r.customer_id
WHERE r.rental_date BETWEEN '2006-01-01' AND '2006-12-31';

# f) Listar os funcionários cujas senhas registradas para utilização dos sistemas são nulas ?? ***nao conseguir remover a linha de nulos 
SELECT *
FROM staff
WHERE password IS NULL AND first_name IS NOT NULL;

#Problema 3

create TABLE payment_copy as
SELECT *
FROM payment;

create TABLE film_actor_copy as
SELECT *
FROM film_actor;
# a) Alterar o valor dos aluguéis menores do que 1.99 para 19.99.

-- Desativar o modo de atualização segura
SET SQL_SAFE_UPDATES = 0;


UPDATE payment_copy
SET amount = 19.99
WHERE amount < 1.99;

-- Reativar o modo de atualização segura
SET SQL_SAFE_UPDATES = 1;
 select amount 
 from payment_copy;

#b) Listar os valores dos aluguéis que estão entre 6.00 e 10.00.
SELECT amount
FROM payment_copy
where amount between 6.00 and 10.00;

-- c) Listar os nomes dos filmes que contém o ator com id 36
#conferir 

