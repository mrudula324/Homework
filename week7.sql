--1.Create a new column called “status” in the rental table that uses a case statement to indicate 
--if a film was returned late, early, or on time. 
/* 3 tables as shown are connected using join condition.
film --(film_id)--> inventory --(inventory_id)--> rental
for comparision of return date and rental date the date_part is used and day is extracted.
To create a column with the status of the return "case" is used.
*/

SELECT fi.title,rental_id,rental_date,return_date,fi.rental_duration,
	DATE_PART('day',return_date-rental_date) as actual_duration,
	CASE WHEN re.return_date is null then 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 else 'ontime' END as status
from film as fi
inner join inventory as inv using (film_id)
inner join rental as re using (inventory_id);


--2.Show the total payment amounts for people who live in Kansas City or Saint Louis.
--payment ,customer,address,city
/* To get requrired results tables are joined as shown:
payment --(customer_id)--> customer --(address_id)--> address --(city_id)--> city
grouped by city to get the sum of payment by city and used aggregrate function sum on amount column.
where condition is used along with in to get results from Kansas City or Saint Louis.
*/

select ci.city,sum(pay.amount) as total_pay
from payment as pay
inner join customer as cu on pay.customer_id= cu.customer_id
inner join address as ad on cu.address_id= ad.address_id
inner join city as ci on ci.city_id=ad.city_id
where ci.city in ('Saint Louis','Kansas City')
group by ci.city;

--3.How many film categories are in each category? Why do you think there is a table for
--category and a table for film category?
--There are 16 film categories. We can reach to this solution using any of the 2 queries below.

select category_id,count(*) as film_count from film_category
group by category_id
order by category_id;
--or
select category_id,c.name, count(film_id) as film_count from film_category
inner join category as c using (category_id)
group by category_id,c.name
order by category_id;

/* Good database design should follow normalization rules. 
If film and category tables are connected with out a junction table film_category then:
1. data can be redundant, which is aganist normalization.
category table should have columns "category_id,category_name,last_update" along with "film_id" to reference 
the film table. Then for each film there will be a category associated with the film in the category table,
Which will return 1000 rows as we have in film table. Most of the information is redundant and hence 
creating a table film_category is highly benifical as category name dont need to be repeated as many times as
the films. Creating a junction table "film_category" which is created using two foreign keys (which are
primary keys from film and category tables) gets the database to be in normalized form. 

2. If in case there is any change in the category name say from "scifi" to "science_fiction" the abscence of
film_category table will let you change that information though out the 1000 rows.This is more prone for 
mistakes and can result in inconsistent data. Presence of film_category table makes our work easier as 
changing a single cell is enough.
*/

--4.Show a roster for the staff that includes their email, address, city, and country (not ids)
--staff,address, city,country
/* Query is written by connecting tables:
staff --(address_id)--> address --(city_id)--> city --(country_id)--> country
concatnated the first and last names for better readibility. Approprite colums are pulled.
*/

select first_name || ' ' || last_name as full_name, s.email,ad.address,ci.city,cu.country
from staff as s
inner join address as ad on s.address_id=ad.address_id
inner join city as ci on ci.city_id=ad.city_id
inner join country as cu on cu.country_id=ci.country_id;


--5.Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005
/*
Subquery is written to get the results.
For inner query tables rental,inventory are connected using inventory_id. Also, where clause with dates
is used.
Outer query film table is used and in where film_id is compared with the results from the inner query and 
the results were returned.
*/
--List of distinct movies rented between '2005-05-15'and '2005-05-31'.

select f.film_id,f.title,f.length
from film as f
where film_id in (select  i.film_id from rental as r
					inner join inventory as i on i.inventory_id=r.inventory_id
					where return_date between'2005-05-15 00:00:00'and '2005-05-31 23:59:59');

-- using cast for date:
select f.film_id,f.title,f.length
from film as f
where film_id in (select  i.film_id from rental as r
					inner join inventory as i on i.inventory_id=r.inventory_id
					where cast(return_date as date) between'2005-05-15'and '2005-05-31');

--Some films are rented more than once. List of movies returned between  '2005-05-15'and '2005-05-31' and 
--the count of number of times each movie is rented is shown:

select f.film_id,f.title,f.length,count(*)
from film as f
inner join inventory as i using (film_id)
inner join rental as r using (inventory_id)
where cast(return_date as date) between '2005-05-15'and '2005-05-31'
group by f.film_id,f.title,f.length;

--list of movies rented including the multiple rentals of same movie in that period:

select f.film_id,f.title,f.length,return_date
from film as f
inner join inventory as i using (film_id)
inner join rental as r using (inventory_id)
where cast(return_date as date) between '2005-05-15'and '2005-05-31';


--6.Write a subquery to show which movies are rented below the average price for all movies. 
/*
In the inner query the avg of amount from payment table is calculated.
Outer query 3 tables are connected:
film --(film_id)--> inventory --(inventory_id)--> rental
For the output the inner query results are compared in the where condition.
Same movie has been rented one or more times hence used distinct on the result set. 
*/

SELECT distinct f.film_id,f.title,f.rental_rate
from film f
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id
where f.rental_rate < (select avg(rental_rate) from film)
order by f.film_id,f.rental_rate desc;

--7.Write a join statement to show which moves are rented below the average price for all movies.
/*
select query has been return in the join condition instead of select to achieve the desired result.
*/

select distinct f.film_id,f.title,f.rental_rate
from film f
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id
join (SELECT avg(rental_rate) avg_price FROM film) as flm
ON rental_rate < flm.avg_price;
--or
/* query has been tried using window function as shown. A column with boolean value has been returned. True
for if less than avg rental and false if greater than average rental.
*/

select fi.film_id, fi.title,fi.rental_rate,avg(fi.rental_rate) over() as mean_val,
		fi.rental_rate <avg(fi.rental_rate) over() as result_col
from film fi
inner join inventory inv on fi.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id;

--8.Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.
--Expalin plan for question6:

EXPLAIN select distinct f.film_id,f.title,f.rental_rate
from film f
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id
where f.rental_rate < (select avg(rental_rate) from film)
order by f.film_id,f.rental_rate desc;
-- The total cost for the query is: (cost=720.48..721.31 rows=333 width=25)
-- (actual time=13.038..13.063 rows=326 loops=1)

--Expalin plan for question7:
EXPLAIN  select distinct f.film_id,f.title,f.rental_rate
from film f
inner join inventory inv on f.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id
join (SELECT avg(rental_rate) avg_price FROM film) as flm
ON rental_rate < flm.avg_price;
-- Total cost for the query is: (cost=733.71..743.71 rows=1000 width=25)
-- (actual time=14.317..14.384 rows=326 loops=1)
--Though the subquery is used in the select took compratively less time and cost than with the subquery
--used in the join condition.


--Explain for query using window function for question 7:

EXPLAIN select fi.film_id, fi.title,fi.rental_rate,avg(fi.rental_rate) over() as mean_val,
		fi.rental_rate <avg(fi.rental_rate) over() as result_col
from film fi
inner join inventory inv on fi.film_id = inv.film_id
inner join rental r on inv.inventory_id = r.inventory_id

/*
Total cost for the query using window function:
WindowAgg  (cost=204.57..840.13 rows=16044 width=58)
When comparted to onces using subquery the cost and time took is far less for query with window function.
Though the output processed is much more rows than a subquery does.
*/

--9.With a window function, write a query that shows the film, its duration, and what percentile 
--the duration fits into. 

select f.title,f.length as duration,
	percent_rank() over(order by f.length)
from film as f
inner join film_category as fi using (film_id)
order by percent_rank desc;

--10.In under 100 words, explain what the difference is between set-based and procedural 
--programming. Be sure to specify which sql and python are. 
/*
Procedural programming is an approach that involves giving step by step instructions along with the 
how to perform a task.
Set bsaed approach involves what to do. It does not require instructions on how to do the task. Example
we tell the database to perform a join condition or insert command. The database engine will choose the
best algorithm to finish the task.
Sql is considered as the set based, user defined funcations,pl/sql,tsql follow procedural approach.
Python is considered as the object oriented programming rather than procedural language.
*/

--Bonus:
--Find the relationship that is wrong in the data model. Explain why its wrong. 
/*
1.In general the relation between address and store is as shown:
  address --(1/1)-------------------(0/1)---store
A address can have 0 or 1 store
A store can have one and only one address.
But in the ER diagram it mentioned that a store can have multiple address which is impossible. But to 
check the correctness the database has been queried as follows. Query resulted in zero rows. Which means 
there is no need for zero to many relationship between address and store.
*/
select address_id, count(*) from store
group by address_id
having count(*)>1

/*
2. Inventory and rental tables:
inventory --(1/1)-------------------(1/more)---rental
A inventory can carry one or more rentals.
A rental can be in one and only one inventory.
When queried database as shown the inventory_id for 1st record has 3 rentals. Hence a inventory can have
zero or more rentals.
*/
select * from rental where inventory_id=1





