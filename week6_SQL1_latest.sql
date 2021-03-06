--1.Show all customers whose last names start with T.Order them by first name from A-Z.
/* In order to get the customers last names i used customer table and used where to fill the last names
starting with 'T'. ordered the result of the query by first_name. */

select * from customer
where last_name like 'T%'
order by first_name;


--2.Show all rentals returned from 5/28/2005 to 6/1/2005
/* To access the rental information, rental table is used. Between is used in where is used to filter
rentals for that duration.*/

select * from rental
where return_date between '2005-01-01'and '2005-05-28';


--3.How would you determine which movies are rented the most?
/* To get required results by looking at the data model three tables were chosen and connected as follows:
film --(film_id)--> inventory --(inventory_id)-->rental
used film_id and inventory_id columns to connect between tables. To get the most rented movies used group by
title on the results. Ordered the groupby results using count. */

select f.title,count(*) as count_rented
from film as f
inner join inventory as i
on f.film_id=i.film_id
inner join rental as r
on r.inventory_id=i.inventory_id
group by f.title
order by count(*) desc;  


--4.Show how much each customer spent on movies (for all time) . Order them from least to most.
/* Customer and Payment tables are joined to achieve required results.
customer --(customer_id)--> payment
from the results after join, results are grouped using customer_id and ordered results on sum of all payments
by using a aggeregrate funtion sum on the payment column.
*/

select c.customer_id,c.first_name,c.last_name,sum(amount) as total_spend 
from payment as p
inner join customer as c
using (customer_id)
group by customer_id
order by total_spend ; 


--5.Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias
--the actor name and count as a more descriptive name. Order the results from most to least.
/* connected tables using relation:
film --(film_id)--> film_actor --(actor_id)--> actor
filtered results using where and grouped them using actor_id as we want find the actor with most movies.
finally ordered based on max of count values from grouping.
*/

select a.actor_id,a.first_name as actor_first ,a.last_name as actor_last,count(a.actor_id) as most_movies
from film as f
inner join film_actor as fa
using (film_id)
inner join actor as a
using (actor_id)
where release_year=2006
group by a.actor_id
order by count(a.actor_id) desc; 

--6.Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. 

/*In general EXPALIN plan for postgresql explains step by step process of how a given query is executed. 
This includes type of scan used (sequential scan/index scan),tables involved and also join alogirithm
used to run the query. The results will mainly include the start cost generally zero at start of the query
and at the end this will include the total cost by the end of the query. It also includes the no of rows
and width at start and end of the query including step wise counts. 
Out will be in descending order which means we have work from bottom to top to understand the query
from start to end.
If EXPALIN ANALYZE used then analyze will include include the actual time, total time including the time
as each node.
These are generally used while performance tuning of queries*/

--Expain plan for question 4
/*
EXPLAIN select c.customer_id,c.first_name,c.last_name,sum(amount) as total_spend 
from payment as p
inner join customer as c
using (customer_id)
group by customer_id
order by total_spend ;
*/

/*OUTPUT FOR THE EXPLAIN QUERY IS AS FOLLOWS:
"Sort  (cost=423.12..424.62 rows=599 width=53)"
"  Sort Key: (sum(p.amount))"
"  ->  HashAggregate  (cost=388.00..395.49 rows=599 width=53)"
"        Group Key: c.customer_id"
"        ->  Hash Join  (cost=22.48..315.02 rows=14596 width=23)"
"              Hash Cond: (p.customer_id = c.customer_id)"
"              ->  Seq Scan on payment p  (cost=0.00..253.96 rows=14596 width=8)"
"              ->  Hash  (cost=14.99..14.99 rows=599 width=17)"
"                    ->  Seq Scan on customer c  (cost=0.00..14.99 rows=599 width=17)" 
*/

/* Reading output: Working from bottom to top.
1. Started with sequence scan (query reads records sequentially from first row to the last row) in customer table.
2.It hashes the values from table customer.
3.another sequential scan performed on table payment
4.using a Hash condition, a hash join in perfomed. At first the customer table converted to a hash table 
in the memory after payment table is explored for the matches of each row which created a hash join node.
5.then hash aggregrate algorithm will organise the the hash table based on some internal chosen hash funtion.
6.sorted values based onthe sort key and it also shows the disk space needed to perform sort. */

--Explain plan for question 5:
/*
EXPLAIN select a.actor_id,a.first_name,a.last_name,count(a.actor_id) as most_movies
from film as f
inner join film_actor as fa
using (film_id)
inner join actor as a
using (actor_id)
where release_year=2006
group by a.actor_id
order by count(a.actor_id) desc;
*/

/*OUTPUT FOR THE EXPLAIN QUERY IS AS FOLLOWS:
"Sort  (cost=236.11..236.61 rows=200 width=25)"
"  Sort Key: (count(a.actor_id)) DESC"
"  ->  HashAggregate  (cost=226.46..228.46 rows=200 width=25)"
"        Group Key: a.actor_id"
"        ->  Hash Join  (cost=85.50..199.15 rows=5462 width=17)"
"              Hash Cond: (fa.actor_id = a.actor_id)"
"              ->  Hash Join  (cost=79.00..178.01 rows=5462 width=2)"
"                    Hash Cond: (fa.film_id = f.film_id)"
"                    ->  Seq Scan on film_actor fa  (cost=0.00..84.62 rows=5462 width=4)"
"                    ->  Hash  (cost=66.50..66.50 rows=1000 width=4)"
"                          ->  Seq Scan on film f  (cost=0.00..66.50 rows=1000 width=4)"
"                                Filter: ((release_year)::integer = 2006)"
"              ->  Hash  (cost=4.00..4.00 rows=200 width=17)"
"                    ->  Seq Scan on actor a  (cost=0.00..4.00 rows=200 width=17)" 
*/

--7.What is the average rental rate per genre?
/*  to find the average rental rate:
category --(category_id)--> film_category --(film_id)--> film
grouped results on the category. for avg rental rate aggregrate funcation avg is used and applied round
funcation to 2 deciaml place results.
*/
select c.name ,round(avg(f.rental_rate),2) as avg_rental_rate
from category as c
inner join film_category as fc
using (category_id)
inner join film as f
using (film_id)
group by c.name;


--8.How many films were returned late? Early? On time?
/*Films counts based on returned late,early,ontime. Tables are joined using condition as shown.
film --(film_id)--> inventory --(inventory_id)-->rental
case is used to filter results appropriately and created a new column named return_category based on the 
case reults. To get the count of the films based on the return, grouped all by the return_category column.
*/
select 
	CASE WHEN re.return_date is null then 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 else 'ontime' END as return_category, count(*) as dvd_returns_count
from film as fi
inner join inventory as inv using (film_id)
inner join rental as re using (inventory_id)
group by return_category; 

	
--9.What categories are the most rented and what are their total sales?
/* Joined the following table to achieve desired results:
category --(category_id)--> film_category --(film_id)--> inventory --(inventory_id)-
		--> rental --(rental_id)--> payment*/
		
select fcat.category_id, c.name,count(r.rental_id) as RentalCnt, sum(amount) as PayAmt
from category c
inner join film_category as fcat on c.category_id=fcat.category_id
inner join inventory inv on fcat.film_id=inv.film_id
inner join rental as r on r.inventory_id=inv.inventory_id
inner join payment pmt on r.rental_id=pmt.rental_id
group by fcat.category_id,c.name
order by RentalCnt desc; 


--10.Create a view for 8 and a view for 9. Be sure to name them appropriately. 
--'Create View <sql query>' is used to create a view based on the results from that 
--query. View is like a virtual table which can be used to perform all calculations like we do on table.
-- views wont alter any values from original table. Every time query is executed the view will get the 
--updated results from the table.
--view for question 8: 
create view dvd_return_status as 
select 
	CASE WHEN re.return_date is null then 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 else 'ontime' END as return_category, count(*) as dvd_returns_count
from film as fi
inner join inventory as inv using (film_id)
inner join rental as re using (inventory_id)
group by return_category; 

--view for question 9

create view total_sales_rented as
select fcat.category_id, c.name,count(r.rental_id) as RentalCnt, sum(amount) as PayAmt
from rental r
inner join inventory inv on r.inventory_id=inv.inventory_id 
inner join film_category fcat on inv.film_id=fcat.film_id
inner join payment pmt on r.rental_id=pmt.rental_id
inner join category as c on c.category_id=fcat.category_id
group by fcat.category_id,c.name
order by RentalCnt desc; 


--Bonus:
--Write a query that shows how many films were rented each month. Group them by category and month. 
/*
rental --(inventory_id)--> inventory --(film_id)---> film_category --(category_id)--> category
*/

select fm.category_id,c.name, DATE_part('month',rental_date) AS month_rented, count(*) as films_cate_renMonth 
from rental
inner join inventory using (inventory_id)
inner join film_category as fm using (film_id)
inner join category as c using (category_id)
group by fm.category_id,c.name,DATE_part('month',rental_date)
order by fm.category_id;



