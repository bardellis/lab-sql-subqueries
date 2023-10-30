
-- Welcome to the SQL Subqueries lab!
-- In this lab, you will be working with the Sakila database on movie rentals. 
-- Specifically, you will be practicing how to perform subqueries, which are queries embedded within other queries.
-- Subqueries allow you to retrieve data from one or more tables and use that data in a separate query to retrieve more specific information.

-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:
			Use sakila;

-- 1.Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
            -- solution with join 
			select count(*) 
			from inventory
			join film on film.film_id=inventory.film_id
			where film.title = "Hunchback Impossible";

			-- solution with subquery
			SELECT COUNT(*)
			FROM (
				SELECT inventory_id
				FROM inventory
				JOIN film ON film.film_id = inventory.film_id
				WHERE film.title = 'Hunchback Impossible'
			) AS subquery_alias;

-- 2.List all films whose length is longer than the average length of all the films in the Sakila database.
			SELECT film_id, title, length  
			FROM film
			WHERE length > (SELECT AVG(length)
						FROM film)
						order by length desc;


-- 3.Use a subquery to display all actors who appear in the film "Alone Trip".
            SELECT first_name, last_name, film_id from film_actor
            join actor on film_actor.actor_id=actor.actor_id
            where film_id = (select film_id from film where film.title = "Alone Trip");

-- Bonus:
-- 4.Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
			select film.title AS film_title,category.name AS category_name
			FROM film
			JOIN film_category ON film.film_id = film_category.film_id
			JOIN category ON film_category.category_id = category.category_id
			WHERE category.name = 'Family';

-- 5.Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
			select first_name, last_name, email, co.country from customer as cu
			join address as a on cu.address_id=a.address_id
			join city as c on a.city_id=c.city_id
			join country as co on c.country_id=co.country_id where co.country='canada';

-- 6.Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
			SELECT a.first_name, a.last_name, f.film_id, f.title
			FROM film_actor as fa
			JOIN film as f ON fa.film_id = f.film_id
			JOIN actor as a ON fa.actor_id = a.actor_id
			WHERE fa.actor_id IN (
				SELECT fa2.actor_id
				FROM (
					SELECT actor_id, COUNT(film_id) AS films
					FROM film_actor
					GROUP BY actor_id
					ORDER BY films DESC
					LIMIT 1
				) AS fa2
			);

-- 7.Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
-- 8.Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.