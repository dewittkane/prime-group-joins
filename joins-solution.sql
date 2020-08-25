-- Get all customers and their addresses.
SELECT * FROM "customers" JOIN "addresses" ON "customers".id = "addresses".customer_id;
-- Get all orders and their line items (orders, quantity and product).
SELECT * 
FROM "orders" 
JOIN "line_items" ON "orders".id = "line_items".order_id
JOIN products ON line_items.product_id = products.id;
-- Which warehouses have cheetos?
SELECT "warehouse".warehouse, "warehouse_product".on_hand, "products".description
FROM "warehouse"
JOIN "warehouse_product" ON "warehouse".id = "warehouse_product".warehouse_id
JOIN "products" ON "warehouse_product".product_id = "products".id
WHERE "products".description ILIKE 'cheetos';
-- Which warehouses have diet pepsi?
SELECT "warehouse".warehouse, "warehouse_product".on_hand, "products".description
FROM "warehouse"
JOIN "warehouse_product" ON "warehouse".id = "warehouse_product".warehouse_id
JOIN "products" ON "warehouse_product".product_id = "products".id
WHERE "products".description ILIKE 'diet pepsi';
-- Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "customers".*, COUNT(orders.id)
FROM customers
LEFT JOIN addresses ON customers.id = addresses.customer_id
LEFT JOIN orders ON addresses.id = orders.address_id
GROUP BY customers.id;
-- How many customers do we have?
SELECT COUNT(*) FROM customers;
-- How many products do we carry?
SELECT COUNT(*) FROM products;
-- What is the total available on-hand quantity of diet pepsi?
SELECT SUM(warehouse_product.on_hand)
FROM warehouse_product
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description ILIKE 'diet pepsi';
-- Stretch
-- How much was the total cost for each order?
SELECT orders.id, SUM(line_items.quantity * products.unit_price)
FROM orders
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON line_items.product_id = products.id
GROUP BY orders.id
ORDER BY orders.id;
-- How much has each customer spent in total?
SELECT customers.*, SUM(line_items.quantity * products.unit_price)
FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON addresses.id = orders.address_id
JOIN line_items ON orders.id = line_items.order_id
JOIN products ON line_items.product_id = products.id
GROUP BY customers.id;
-- How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.*, COALESCE(SUM(line_items.quantity * products.unit_price) ,0) AS total_sum
FROM customers
LEFT JOIN addresses ON customers.id = addresses.customer_id
LEFT JOIN orders ON addresses.id = orders.address_id
LEFT JOIN line_items ON orders.id = line_items.order_id
LEFT JOIN products ON line_items.product_id = products.id
GROUP BY customers.id;