SELECT * FROM customers;
# total revenue based on gender
select gender, sum(purchase_amount) as revenue
from customers
group by gender;

# which customers used discount but still spent more than the average purchase amount
select customer_id,purchase_amount
from customers
where discount_applied='Yes' and purchase_amount >= (select AVG(purchase_amount) from customers);

# which are the top 5 products with the highest average review rating
SELECT item_purchased, 
       ROUND(AVG(CAST(review_rating AS DECIMAL(10,2))), 2) AS average_product_rating
FROM customers
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

# compare average purchase amounts between standard and express shipping
select shipping_type,
ROUND(AVG (purchase_amount),2)
from customers 
where shipping_type in ('Standard','Express')
group by shipping_type;


# do subcribed customers spend more than the normal customers
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customers
group by subscription_status
order by total_revenue,avg_spend desc;

# which 5 products have highest purchases with discount applied

select item_purchased,
ROUND(SUM(CASE WHEN discount_applied ='Yes' THEN 1 ELSE 0 END)/COUNT(*) * 100,2) as discount_rate
from customers
group by item_purchased
order by discount_rate desc
limit 5;

# segment customers into new,returning and loyal based on their total number of 
# previous purchases and show the count of each segment

with  customer_type as (
select customer_id, previous_purchases,
CASE
    WHEN previous_purchases=1 THEN 'Returning'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
from customers
)
select customer_segment , count(*) as "Number of Customers"
from  customer_type
group by customer_segment;

# what are the 3 top products within the each catergory

with item_counts as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id) DESC ) as item_rank
from customers
group by category, item_purchased
)

select item_rank, category, item_purchased , total_orders
from item_counts
where item_rank<=3;

# are customer who repeat buying want to subscribe
select subscription_status,
count(customer_id) as repeat_buyers
from customers
where previous_purchases>5
group by subscription_status;

# what is the revenue by age group
select age_group,
sum(purchase_amount) as revenue
from customers
group by age_group
order by revenue desc;