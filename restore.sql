--1.Show all customers whose last names start with T.Order them by first name from A-Z.
--select * from customer
--where first_name like 'T%';

--2.Show all rentals returned from 5/28/2005 to 6/1/2005
--select * from rental
--where return_date between '2005-01-01'and '2005-05-28';

--3.How would you determine which movies are rented the most?
/*select f.title,count(*)
from rental as r
inner join inventory as i
using (inventory_id)
inner join film as f
using (film_id)
group by f.title
order by count(*) desc;  */

--4.Show how much each customer spent on movies (for all time) . Order them from least to most.
/*select c.customer_id,c.first_name,c.last_name,sum(amount) as total_spend 
from payment as p
inner join customer as c
using (customer_id)
group by customer_id
order by total_spend ; */

--5.Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias
--the actor name and count as a more descriptive name. Order the results from most to least.
/*select a.actor_id,a.first_name,a.last_name,count(a.actor_id) as most_movies
from film as f
inner join film_actor as fa
using (film_id)
inner join actor as a
using (actor_id)
where release_year=2006
group by a.actor_id
order by count(a.actor_id) desc; */



--7.What is the average rental rate per genre?
/*select c.name ,round(avg(f.rental_rate),2) as avg_rental_rate
from category as c
inner join film_category as fc
using (category_id)
inner join film as f
using (film_id)
group by c.name;*/

--8.How many films were returned late? Early? On time?
--Films list by that were returned late,early,ontime,if not returned
/*SELECT fi.title,rental_id,rental_date,return_date,fi.rental_duration,DATE_PART('day',return_date-rental_date) as actual_duration,
	CASE WHEN re.return_date is null then 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 else 'ontime' END 
from film as fi
inner join inventory as inv using (film_id)
inner join rental as re using (inventory_id) */

--Films counts based on returned late,early,ontime
/*select 
	CASE WHEN re.return_date is null then 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 else 'ontime' END as return_category, count(*) as dvd_returns_count
from film as fi
inner join inventory as inv using (film_id)
inner join rental as re using (inventory_id)
group by return_category; */
	
--9.What categories are the most rented and what are their total sales?

/*select fcat.category_id, c.name,count(r.rental_id) as RentalCnt, sum(amount) as PayAmt
from rental r
inner join inventory inv on r.inventory_id=inv.inventory_id 
inner join film_category fcat on inv.film_id=fcat.film_id
inner join payment pmt on r.rental_id=pmt.rental_id
inner join category as c on c.category_id=fcat.category_id
group by fcat.category_id,c.name
order by RentalCnt desc; */

--10.Create a view for 8 and a view for 9. Be sure to name them appropriately. 
--view for question 8:
/*create view dvd_return_status as 
select 
	CASE WHEN re.return_date is null then 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 else 'ontime' END as return_category, count(*) as dvd_returns_count
from film as fi
inner join inventory as inv using (film_id)
inner join rental as re using (inventory_id)
group by return_category; */

--view for question 9
/*create view total_sales_rented as
select fcat.category_id, c.name,count(r.rental_id) as RentalCnt, sum(amount) as PayAmt
from rental r
inner join inventory inv on r.inventory_id=inv.inventory_id 
inner join film_category fcat on inv.film_id=fcat.film_id
inner join payment pmt on r.rental_id=pmt.rental_id
inner join category as c on c.category_id=fcat.category_id
group by fcat.category_id,c.name
order by RentalCnt desc; */


