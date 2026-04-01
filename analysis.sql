CREATE DATABASE cafe_db;
USE cafe_db;

CREATE TABLE sales (
    transaction_id INT,
    item VARCHAR(100),
    quantity INT,
    price_per_unit FLOAT,
    total_spent FLOAT,
    payment_method VARCHAR(50),
    location VARCHAR(50),
    transaction_date DATE
);

SELECT COUNT(*) FROM sales;

DROP TABLE sales;

SELECT COUNT(*) FROM sales;

SELECT SUM(`Total Spent`) AS total_revenue     #total revenue
FROM sales;

DESCRIBE sales;

SELECT Item, SUM(Quantity) AS total_sold     #Top 5 selling items
FROM sales
GROUP BY Item
ORDER BY total_sold DESC
LIMIT 5;

#REVENUE BY LOCATION
SELECT Location, SUM(`Total Spent`) AS revenue FROM sales
GROUP BY Location
ORDER BY revenue desc;

#Which payment method generates the most revenue?
SELECT `Payment Method`, SUM(`Total Spent`) AS revenue FROM sales
GROUP BY `Payment Method`
ORDER BY revenue DESC;

#How does revenue change over time (daily)?
SELECT `Transaction Date`, SUM(`Total Spent`) AS daily_revenue
FROM sales
GROUP BY `Transaction Date`
ORDER BY `Transaction Date`;

SELECT * FROM sales;

#Which items generate highest revenue?
SELECT Item,
       SUM(`Total Spent`) AS revenue,
       RANK() OVER (ORDER BY SUM(`Total Spent`) DESC) AS rank_
FROM sales
GROUP BY Item;

#How does cumulative revenue grow over time?
SELECT `Transaction Date`,
       SUM(`Total Spent`) AS daily_revenue,
       SUM(SUM(`Total Spent`)) OVER (ORDER BY `Transaction Date`) AS running_total
FROM sales
GROUP BY `Transaction Date`;

#Which days had highest revenue?
WITH daily_sales AS (
    SELECT `Transaction Date`,
           SUM(`Total Spent`) AS revenue
    FROM sales
    GROUP BY `Transaction Date`
)
SELECT *
FROM daily_sales
ORDER BY revenue DESC
LIMIT 3;

SELECT * FROM sales;

#How much each item contributes to total revenue?
SELECT Item, SUM(`Total Spent`) AS revenue, 
ROUND(SUM(`Total Spent`) * 100.0 / SUM(SUM(`Total Spent`)) OVER (), 2) AS contribution_percent
FROM sales
GROUP BY Item;

#Did sales increase or decrease vs previous day?
SELECT `Transaction Date`,
       SUM(`Total Spent`) AS revenue,
       LAG(SUM(`Total Spent`)) OVER (ORDER BY `Transaction Date`) AS prev_day,
       SUM(`Total Spent`) - LAG(SUM(`Total Spent`)) OVER (ORDER BY `Transaction Date`) AS diff,
       CASE 
           WHEN SUM(`Total Spent`) - LAG(SUM(`Total Spent`)) OVER (ORDER BY `Transaction Date`) > 0 THEN 'Increase'
           WHEN SUM(`Total Spent`) - LAG(SUM(`Total Spent`)) OVER (ORDER BY `Transaction Date`) < 0 THEN 'Decrease'
           ELSE 'No Change'
       END AS trend
FROM sales
GROUP BY `Transaction Date`;