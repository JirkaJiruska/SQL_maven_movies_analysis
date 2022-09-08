use mavenmovies;

/*
1.) number of payments and total earnings per month for 06/2005 - 08/2005
*/

SELECT 
	COUNT(payment_id) AS pyament_count,
    SUM(amount) AS total_payment,
	DATE_FORMAT(payment_date, '%Y-%m') as months
FROM payment
	WHERE DATE_FORMAT(payment_date, '%Y-%m') BETWEEN '2005-06' AND '2005-08'
GROUP BY months
ORDER BY months
;

/*
2.) number of payments and total earnings per month for every month
*/

SELECT 
	COUNT(payment_id) AS pyament_count,
    SUM(amount) AS total_payment,
	DATE_FORMAT(payment_date, '%Y-%m') as months
FROM payment
GROUP BY months
ORDER BY months
;


/*
3.) number of rentals in each days of the week
*/

SELECT 
	COUNT(payment_id) AS pyament_count,
	COUNT(rental_id) AS rental_count,
    SUM(amount) AS total_payment,
	DATE_FORMAT(payment_date, '%a') as days
FROM payment
GROUP BY days
ORDER BY 
	CASE
		WHEN days = 'Mon' THEN 1
		WHEN days = 'Tue' THEN 2
		WHEN days = 'Wed' THEN 3
		WHEN days = 'Thu' THEN 4
		WHEN days = 'Fri' THEN 5
		WHEN days = 'Sat' THEN 6
		WHEN days = 'Sun' THEN 7
    END
;

/*
4.) top 10 customers based on payments, store they visit, number of rentals
*/

SELECT
	concat(customer.first_name, ' ',customer.last_name, ' (', country.country, ')') AS customers_name,
	COUNT(payment.rental_id) AS total_rentals,
    SUM(payment.amount) AS total_spending,
    customer.store_id
FROM payment
LEFT JOIN customer ON payment.customer_id = customer.customer_id
LEFT JOIN address ON address.address_id = customer.address_id
LEFT JOIN city ON city.city_id = address.city_id
LEFT JOIN country ON country.country_id = city.country_id

GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 10;
;

SELECT
	'Total average',
	COUNT(DISTINCT payment.rental_id) / COUNT(DISTINCT payment.customer_id) AS avg_rentals_per_customer,
    SUM(payment.amount) / COUNT(DISTINCT payment.customer_id) AS avg_payment_per_customer, 
    '-'
FROM payment
;

/*
5.) most profitable countries
*/

SELECT
	SUM(payment.amount) AS total_payments,			-- common - payment_id
    country.country,
    customer.store_id
FROM payment
	LEFT JOIN customer ON customer.customer_id = payment.customer_id
    LEFT JOIN address ON address.address_id = customer.address_id
    LEFT JOIN city ON city.city_id = address.city_id
    LEFT JOIN country ON country.country_id = city.country_id
GROUP BY country.country
ORDER BY total_payments DESC
LIMIT 10
;

/*
6.) each store analysis
*/

SELECT 
    SUM(payment.amount) AS total_payments,
    COUNT(payment.rental_id) AS total_rentals,
    COUNT(rental.inventory_id) AS inventory_items,
    SUM(payment.amount) / COUNT(payment.rental_id) AS avg_rental_rate, 
    COUNT(CASE WHEN active = 1 THEN customer.customer_id END) AS active_customers,
    COUNT(CASE WHEN active = 0 THEN customer.customer_id END) AS inactive_customers,
	customer.store_id
FROM payment
	LEFT JOIN customer ON customer.customer_id = payment.customer_id
	LEFT JOIN rental ON rental.rental_id = payment.rental_id
GROUP BY customer.store_id
ORDER BY total_payments
;

/*SELECT 
	COUNT(payment_id) AS pyament_count,
    SUM(amount) AS total_payment,
	CASE
        WHEN payment_date LIKE '2005-06-%' THEN '2005-06'
        WHEN payment_date LIKE '2005-07-%' THEN '2005-07'
        WHEN payment_date LIKE '2005-08-%' THEN '2005-08'
	END AS months
FROM payment

GROUP BY months
	HAVING months IS NOT null
ORDER BY months
;*/
