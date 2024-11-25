-- Problem 2: Online Store Inventory and Orders System

-- Step 1: Create Tables
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

-- Step 2: Insert Data
-- Insert Products
INSERT INTO products (product_name, price, stock_quantity)
VALUES
('Laptop', 1200.00, 10),
('Smartphone', 800.00, 20),
('Headphones', 150.00, 50),
('Keyboard', 100.00, 30),
('Mouse', 50.00, 40);

-- Insert Customers
INSERT INTO customers (first_name, last_name, email)
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com'),
('Bob', 'Smith', 'bob.smith@example.com'),
('Charlie', 'Brown', 'charlie.brown@example.com'),
('Diana', 'Prince', 'diana.prince@example.com');

-- Insert Orders
INSERT INTO orders (customer_id, order_date)
VALUES
(1, '2023-09-01'),
(2, '2023-09-02'),
(3, '2023-09-03'),
(4, '2023-09-04'),
(1, '2023-09-05');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity)
VALUES
(1, 1, 1), -- Alice ordered 1 Laptop
(1, 3, 2), -- Alice ordered 2 Headphones
(2, 2, 1), -- Bob ordered 1 Smartphone
(3, 4, 3), -- Charlie ordered 3 Keyboards
(4, 5, 2), -- Diana ordered 2 Mice
(5, 1, 1), -- Alice ordered another Laptop
(5, 5, 1); -- Alice ordered a Mouse

-- Step 3: SQL Queries
-- 3.1 Retrieve Names and Stock Quantities of All Products
SELECT product_name, stock_quantity
FROM products;

-- 3.2 Retrieve Product Names and Quantities for One of the Orders
SELECT products.product_name, order_items.quantity
FROM order_items
JOIN products ON order_items.product_id = products.id
WHERE order_items.order_id = 1;

-- 3.3 Retrieve All Orders Placed by a Specific Customer (Including Products and Quantities)
SELECT orders.id AS order_id, products.product_name, order_items.quantity
FROM orders
JOIN order_items ON orders.id = order_items.order_id
JOIN products ON order_items.product_id = products.id
WHERE orders.customer_id = 1;

-- Step 4: Update Data
-- Simulate Stock Reduction for an Order
UPDATE products
SET stock_quantity = stock_quantity - (
    SELECT SUM(order_items.quantity)
    FROM order_items
    WHERE order_items.product_id = products.id AND order_items.order_id = 1
)
WHERE products.id IN (
    SELECT product_id
    FROM order_items
    WHERE order_items.order_id = 1
);

-- Step 5: Delete Data
-- Remove an Order and All Associated Items
DELETE FROM orders
WHERE id = 1;
