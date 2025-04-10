
-- Use the Sakila database
USE sakila;
-- Show all tables in the database
SHOW TABLES;


-- 1.Select customer details where the customer is active
SELECT first_name, last_name, email
FROM customer
WHERE active = 1
ORDER BY last_name; -- Sort alphabetically by last name

-- 2. Create a view of top customers based on total payment
CREATE VIEW top_customers AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- 3.Get names of customers and the films they rented
SELECT c.first_name, c.last_name, f.title, r.rental_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY r.rental_date DESC
LIMIT 10; -- Show the latest 10 rentals

-- 4.Find top revenue-generating films
SELECT f.title, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 5;

-- 5.Find customers who spent more than the average customer
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > (
    -- Subquery to calculate average total spent by customers
    SELECT AVG(total_amt)
    FROM (
        SELECT customer_id, SUM(amount) AS total_amt
        FROM payment
        GROUP BY customer_id
    ) AS avg_table
);

-- 6. Create a reusable view to store top customer spenders
CREATE VIEW top_customers AS
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

-- View top 5 spenders from that view
SELECT * FROM top_customers LIMIT 5;



