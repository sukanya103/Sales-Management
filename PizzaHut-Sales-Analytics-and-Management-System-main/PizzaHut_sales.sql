create database pizzahut;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);

create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id varchar(50) not null,
quantity int not null,
primary key(order_id)
);

-- Retrive the total number of order placed 

SELECT count(order_id) as total_order FROM orders;

-- calculate the total revenue generated from the pizza sale
SELECT 
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest priced pizza

SELECT 
pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

-- identify the most common pizza size ordered 

select 
pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc
limit 1;

-- list the top 5 most odered pizza types along with their quantities.
select 
pizza_types.name,sum(order_details.quantity) as top_5
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id = pizzas.pizza_id
group by  pizza_types.name
order by top_5 desc
limit 5;


-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.

select 
pizza_types.category,sum(order_details.quantity) as total_quantity
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category
order by total_quantity desc;

-- Determine the distribution of orders by hour of the day. 

select hour(order_time),count(order_id) as total_count from orders
group by hour(order_time)
order by total_count desc;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(pizza_type_id) as pizza_category
from pizza_types
group by category
order by pizza_category desc;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(quantity) from
(select 
orders.order_date,sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by revenue desc
limit 3;
 
-- Calculate the percentage contribution of each pizza type to total revenue.
  
select pizza_types.category,
(sum(order_details.quantity*pizzas.price) /(select round(sum(order_details.quantity*pizzas.price),2) 
as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id)*100) as total_revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id= pizzas.pizza_type_id
group by pizza_types.category
order by total_revenue desc;

-- Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(SELECT orders.order_date,
round(sum(order_details.quantity*pizzas.price),2) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pizza_types.category,pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id= pizzas.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category,pizza_types.name
order by revenue desc
limit 3;