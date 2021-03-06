-- •	Cohort based monthly retention for Retail product line
--Retention for Retail Store:

with cohort_retail as (
	select user_id, first_purchase_date, date_trunc('month',first_purchase_date)::date as cohort_month
	--(extract(year from first_purchase_date::date) ||'-' ||extract(month from first_purchase_date::date) as cohort_month
	from first_purchases
	where product_line ilike 'retail%'
	order by 2
), purchases_retail as (
	select p.user_id, first_purchase_date, purchase_date,
	(DATE_PART('year', p.purchase_date) - DATE_PART('year', cr.first_purchase_date)) * 12 +
              (DATE_PART('month', p.purchase_date) - DATE_PART('month', cr.first_purchase_date)) as month_number
	from purchases p right join cohort_retail cr on p.user_id = cr.user_id
	where product_line ilike 'retail%'
	group by 1,2,3,4
), cohort_size as (
  select cohort_month, count(user_id) as num_users
  from cohort_retail
  group by 1
  order by 1
),retention as (
  select
    C.cohort_month,
    A.month_number,
    count(1) as num_users
  from purchases_retail A
  left join cohort_retail C ON A.user_id = C.user_id
  group by 1, 2
)
select
B.cohort_month,
S.num_users as total_users,
B.num_users,
B.month_number,
(B.num_users::float * 100 / S.num_users::float)::numeric(10,2) as percentage
from retention B
left join cohort_size S ON B.cohort_month = S.cohort_month
where B.cohort_month IS NOT NULL
order by 1, 4



-- •	Cohort based monthly retention for Restaurant product line
-- Retention for Restaurant

with cohort_restaurant as (
	select user_id, first_purchase_date, date_trunc('month',first_purchase_date)::date as cohort_month
	--(extract(year from first_purchase_date::date) ||'-' ||extract(month from first_purchase_date::date) as cohort_month
	from first_purchases
	where product_line ilike 'restaurant%'
	order by 2
), purchases_restaurant as (
	select p.user_id, first_purchase_date, purchase_date,
	(DATE_PART('year', p.purchase_date) - DATE_PART('year', cr.first_purchase_date)) * 12 +
              (DATE_PART('month', p.purchase_date) - DATE_PART('month', cr.first_purchase_date)) as month_number
	from purchases p right join cohort_restaurant cr on p.user_id = cr.user_id
	where product_line ilike 'restaurant%'
	group by 1,2,3,4
), cohort_size as (
  select cohort_month, count(user_id) as num_users
  from cohort_restaurant
  group by 1
  order by 1
),retention as (
  select
    C.cohort_month,
    A.month_number,
    count(1) as num_users
  from purchases_restaurant A
  left join cohort_restaurant C ON A.user_id = C.user_id
  group by 1, 2
)
select
B.cohort_month,
S.num_users as total_users,
B.num_users,
B.month_number,
(B.num_users::float * 100 / S.num_users::float)::numeric(10,2) as percentage
from retention B
left join cohort_size S ON B.cohort_month = S.cohort_month
where B.cohort_month IS NOT NULL
order by 1, 4










