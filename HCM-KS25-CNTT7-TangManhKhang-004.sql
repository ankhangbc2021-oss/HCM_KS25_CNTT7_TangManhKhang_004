CREATE DATABASE IF NOT EXISTS hackthon_db;
USE hackthon_db;

CREATE TABLE IF NOT EXISTS Customer (
	customer_id VARCHAR(5) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) UNIQUE,
    customer_phone VARCHAR(15) UNIQUE,
    customer_address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Product (
	product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(20) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id  VARCHAR(5),
    product_id  VARCHAR(5),
    order_date DATE DEFAULT (CURRENT_DATE),
    order_quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE IF NOT EXISTS Payment (
	payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE DEFAULT(CURRENT_DATE),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Customer(customer_id, customer_name, customer_email, customer_phone, customer_address) 
VALUES 
	('C001', 'Nguyen Anh Tu', 'tu.nguyen@exampie.com', '0987654321', 'Hanoi'),
	('C002', 'Tran Thi Mai', 'mai.tran@exampie.com', '0987654322', 'Ho Chi Minh'),
	('C003', 'Le Minh Hoang', 'hoang.le@exampie.com', '0987654323', 'Danang'),
	('C004', 'Pham Hoan Nam', 'nam.oham@exampie.com', '0987654324', 'Hue'),
	('C005', 'Vu Minh Thu', 'thu.vu@exampie.com', '0987654325', 'Hai Phong');

INSERT INTO Product(product_id, product_name, category, product_price, stock_quantity) 
VALUES
	('P001', 'Laptop Dell', 'Electronics', 15000, 10), 
	('P002', 'iPhone 15', 'Electronics', 20000, 5), 
	('P003', 'T-Shirt', 'Clothing', 200, 50), 
	('P004', 'Running Shoes', 'Footwear', 1500, 20), 
	('P005', 'Table Lamp', 'Fumiture', 500, 15);

INSERT INTO  Orders(order_id, customer_id, product_id, order_date, order_quantity, total_amount) 
VALUES
	(1, 'C001', 'P001', '2025-06-01', 1, 15000),
	(2, 'C002', 'P003', '2025-06-02', 2, 400),
	(3, 'C003', 'P002', '2025-06-03', 1, 20000),
	(4, 'C001', 'P004', '2025-06-03', 1, 1500),
	(5, 'C005', 'P001', '2025-06-04', 2, 30000);
    
INSERT INTO Payment(payment_id, order_id, payment_date, payment_method, payment_status)
VALUES
	(1, 1, '2025-06-01', 'Banking', 'Paid'),
    (2, 2, '2025-06-02', 'Cash', 'Paid'),
    (3, 3, '2025-06-03', 'Credit Carh', 'Paid'),
    (4, 4, '2025-06-04', 'Banking', 'Pending'),
    (5, 5, '2025-06-05', 'Credit Carh', 'Paid');
    
-- p2 
-- 3 
UPDATE Customer 
SET customer_phone = '0999888777'
WHERE customer_id = 'C001';

-- 4 
UPDATE Product
SET stock_quantity = stock_quantity + 50
WHERE product_id = 'P003';

UPDATE Product
SET product_price = product_price * 1.1 
WHERE product_id = 'P003';

-- 5 
DELETE FROM Payment 
WHERE payment_status = 'Pending' 
AND payment_method = 'Banking';

-- 6
SELECT product_id, product_name, product_price 
FROM Product 
WHERE category = 'Electronics' AND product_price > 10000;

-- 7
SELECT customer_name, customer_email, customer_address
FROM Customer
WHERE customer_name LIKE 'Nguyen%';

-- 8
SELECT order_id, order_date, total_amount
FROM Orders
ORDER BY total_amount DESC;

-- 9
SELECT payment_date 
FROM Payment
ORDER BY payment_date DESC LIMIT 3;

-- 10
SELECT product_id FROM Product ORDER BY product_id LIMIT 3 OFFSET 2;

SELECT product_id, product_name 
FROM Product 
GROUP BY product_id , product_name 
HAVING product_id <> (SELECT product_id FROM Product ORDER BY product_id LIMIT 2);

-- P3
-- 11
SELECT o.order_id, c.customer_name, p.product_name, o.total_amount
FROM Product p
JOIN Orders o ON p.product_id = o.product_id
JOIN Customer c ON o.customer_id = c.customer_id
WHERE o.total_amount > 1000;

-- 12 error
SELECT product_id FROM Product;
SELECT p.product_id, p.product_name, o.order_id
FROM Product p
JOIN Orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, o.order_id
HAVING o.product_id NOT LIKE (SELECT product_id FROM Product);

-- 13
SELECT p.category, SUM(o.total_amount) AS Total_Revenus
FROM Product p 
JOIN Orders o ON p.product_id = o.product_id
GROUP BY p.category
HAVING SUM(o.total_amount);

-- 14 
SELECT c.customer_name, COUNT(o.order_id) AS Order_Count 
FROM Customer c 
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) >= 2;

-- 15
SELECT o.order_id, c.customer_name, o.total_amount
FROM Customer c 
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > (SELECT AVG(total_amount) FROM Orders);
-- 16
SELECT c.customer_name, c.customer_phone
FROM Customer c 
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Product p ON o.product_id = p.product_id
WHERE p.category = 'Electronics';
-- 17 
SELECT o.order_id, c.customer_name, p.product_name, pay.payment_method, pay.payment_status
FROM Customer c 
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Product p ON o.product_id = p.product_id
JOIN Payment pay ON o.order_id = pay.order_id;

