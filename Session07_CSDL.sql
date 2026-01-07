CREATE DATABASE Session07;
-- Bài 1
USE Session07;
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);
INSERT INTO customers (id, name, email) VALUES
(1, 'Nguyễn Văn Ánh', 'anv@gmail.com'),
(2, 'Trần Thị Bình', 'btt@gmail.com'),
(3, 'Lê Văn Công', 'cle@gmail.com'),
(4, 'Phạm Thành Dũng', 'dpt@gmail.com'),
(5, 'Hoàng Lan Em', 'ehlan@gmail.com'),
(6, 'Phạm Thành Đạt', 'ptd09@gmail.com'),
(7, 'Trần Việt Anh', 'tva@gmail.com');
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(101, 1, '2023-10-01', 500.00),
(102, 1, '2023-10-05', 200.00),
(103, 2, '2023-10-10', 150.00),
(104, 4, '2023-10-12', 1200.00),
(105, 4, '2023-10-15', 300.00),
(106, 6, '2023-10-20', 450.00),
(107, 2, '2023-10-22', 100.00);
-- Lấy danh sách khách hàng đã từng đặt đơn hàng
SELECT * FROM customers 
WHERE id IN (SELECT customer_id FROM orders);

-- Bài 2
USE Session07;
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2)
);
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
INSERT INTO products (id, name, price) VALUES
(1, 'iPhone 17 Promax', 20000000),
(2, 'Samsung S25 Ultra', 18000000),
(3, 'Macbook Air', 25000000),
(4, 'iPad Pro', 22000000),
(5, 'Sony WH-1000XM5', 8000000),
(6, 'Apple Watch 9', 10000000),
(7, 'Logitech Mouse', 1500000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1001, 1, 1),
(1001, 2, 2),
(1002, 4, 1),
(1003, 1, 1),
(1004, 5, 3),
(1005, 7, 1),
(1006, 2, 1);
SELECT * FROM products 
WHERE id IN (SELECT product_id FROM order_items);

-- Bài 3
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(201, 1, '2023-11-11', 100.00),
(202, 2, '2023-11-15', 250.00),
(203, 3, '2023-11-18', 1500.00),
(204, 4, '2023-11-21', 300.00),
(205, 5, '2023-11-10', 800.00),
(206, 1, '2023-11-09', 50.00),
(207, 2, '2023-11-03', 2000.00);
SELECT * FROM orders 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- Bài 4
USE Session07;
INSERT INTO customers (id, name, email) VALUES
(10, 'Anh Tuấn', 'tuan@gmail.com'),
(11, 'Phạm Hằng', 'hang@gmail.com'),
(12, 'Quốc Bảo', 'bao@gmail.com'),
(13, 'Phương Thảo', 'thao@gmail.com'),
(14, 'Đức Duy', 'duy@gmail.com');
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(301, 10, '2023-12-12', 500.00),
(302, 10, '2023-12-05', 150.00),
(303, 11, '2023-12-08', 200.00),
(304, 13, '2023-12-02', 1000.00),
(305, 10, '2023-12-03', 300.00),
(306, 11, '2023-12-06', 450.00);
SELECT name, (SELECT COUNT(*) FROM orders WHERE orders.customer_id = customers.id) AS order_count FROM customers;

-- Bài 5
USE Session07;
INSERT INTO customers (id, name, email) VALUES
(31, 'Nguyễn Văn Xuân', 'xuan@gmail.com'),
(32, 'Trần Hải Yến', 'yen@gmail.com'),
(33, 'Lê Trung Đông', 'ltd@gmail.com'),
(34, 'Hoàng Phi Hùng', 'hung@gmail.com'),
(35, 'Phạm Văn Khánh', 'khánh@gmail.com');

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(501, 31, '2024-02-01', 100),
(502, 32, '2024-02-02', 5000),
(503, 33, '2024-02-03', 200),
(504, 34, '2024-02-04', 300),
(505, 31, '2024-02-05', 400);

SELECT * FROM customers 
WHERE id = ( SELECT customer_id FROM orders GROUP BY customer_id HAVING SUM(total_amount) = (
        SELECT MAX(total_per_user) FROM (SELECT SUM(total_amount) AS total_per_user FROM orders GROUP BY customer_id) AS result
    )
);

-- Bài 6
USE Session07;
INSERT INTO customers (id, name, email) VALUES
(101, 'Phạm Hồng Nhung', 'phn@gmail.com'),
(102, 'Quàng Văn Minh', 'minh@gmail.com'),
(103, 'Nguyễn Xuân Phương', 'phuong@gmail.com'),
(104, 'Lê Mạnh Dũng', 'dũng@gmail.com'),
(105, 'Nghiêm Văn Ý', 'nvy@gmail.com');
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(601, 101, '2024-03-01', 200.00),
(602, 102, '2024-03-02', 1500.00),
(603, 103, '2024-03-03', 300.00),
(604, 101, '2024-03-04', 800.00),
(605, 104, '2024-03-05', 50.00),
(606, 102, '2024-03-06', 1000.00),
(607, 105, '2024-03-07', 400.00);
-- KHÁCH HÀNG CÓ TỔNG CHI TIÊU > TRUNG BÌNH CHUNG
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (SELECT AVG(customer_total)
    FROM (SELECT SUM(total_amount) AS customer_total FROM orders GROUP BY customer_id) AS sub_table
);