CREATE DATABASE Session06;
-- Bài 1
USE Session06;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255)
);
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO customers (customer_id, full_name, city) VALUES 
(1, 'Trần Việt Anh', 'Hà Nội'),
(2, 'Đỗ Khắc Quyền', 'TP.HCM'),
(3, 'Phạm Thành Đạt', 'Đà Nẵng'),
(4, 'Lê Việt Trung', 'Cần Thơ'),
(5, 'Phạm Thái Sơn', 'Hải Phòng');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES 
(101, 1, '2023-10-01', 'completed'),
(102, 1, '2023-10-05', 'pending'),
(103, 2, '2023-10-10', 'completed'),
(104, 3, '2023-10-12', 'cancelled'),
(105, 4, '2023-10-15', 'completed'),
(106, 2, '2023-10-16', 'completed');

-- Hiển thị danh sách đơn hàng kèm tên khách hàng
SELECT o.order_id, c.full_name, o.order_date, o.status FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Hiển thị mỗi khách hàng đã đặt bao nhiêu đơn hàng
-- Sẽ hiển thị cả khách số 5 với kết quả là 0 đơn hàng
SELECT c.full_name, COUNT(o.order_id) AS so_luong_don_hang
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Chỉ hiển thị các khách hàng có ít nhất 1 đơn hàng
SELECT c.full_name, COUNT(o.order_id) AS so_luong_don_hang
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;

-- Sắp xếp khách hàng theo số lượng đơn hàng giảm dần
SELECT c.full_name, COUNT(o.order_id) AS so_luong_don_hang
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY so_luong_don_hang DESC;

-- Bài 2
USE Session06;
ALTER TABLE orders ADD COLUMN total_amount DECIMAL(10, 2);
UPDATE orders SET total_amount = 500.00 WHERE order_id = 101;
UPDATE orders SET total_amount = 300.50 WHERE order_id = 102;
UPDATE orders SET total_amount = 1500.00 WHERE order_id = 103;
UPDATE orders SET total_amount = 200.00 WHERE order_id = 104;
UPDATE orders SET total_amount = 750.00 WHERE order_id = 105;
UPDATE orders SET total_amount = 120.00 WHERE order_id = 106;

-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
SELECT c.full_name, SUM(o.total_amount) AS tong_chi_tieu
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Hiển thị giá trị đơn hàng cao nhất của từng khách
SELECT c.full_name, MAX(o.total_amount) AS don_hang_lon_nhat
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
SELECT c.full_name, SUM(o.total_amount) AS tong_chi_tieu
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY tong_chi_tieu DESC;

-- Hiển thị giá trị trung bình đơn hàng của toàn hệ thống
SELECT AVG(total_amount) AS trung_binh_don_hang FROM orders;

-- Bài 3
USE Session06;
SELECT order_date, SUM(total_amount) AS tong_doanh_thu, COUNT(order_id) AS so_luong_don
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

-- Chỉ hiển thị các ngày có doanh thu > 10.000.000
SELECT order_date, SUM(total_amount) AS tong_doanh_thu
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;

-- Bài 4
USE Session06;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO products (product_id, product_name, price) VALUES 
(1, 'iPhone 17', 20000000),
(2, 'Samsung S25 Ultra', 15000000),
(3, 'Ốp lưng', 200000),
(4, 'Sạc nhanh', 500000),
(5, 'Tai nghe Airpod', 4000000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES 
(101, 1, 1),
(102, 3, 5),
(103, 5, 2),
(104, 2, 1),
(105, 4, 3);
-- Hiển thị mỗi sản phẩm đã bán được bao nhiêu
SELECT p.product_name, SUM(oi.quantity) AS tong_so_luong_ban
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Tính doanh thu của từng sản phẩm
SELECT p.product_name, SUM(p.price * oi.quantity) AS doanh_thu_san_pham
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Chỉ hiển thị các sản phẩm có doanh thu > 5.000.000
SELECT p.product_name, SUM(p.price * oi.quantity) AS doanh_thu_san_pham
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING doanh_thu_san_pham > 5000000;

-- Bài 5
USE Session06;
SELECT c.full_name, COUNT(o.order_id) AS tong_so_don_hang, SUM(o.total_amount) AS tong_tien_chi, AVG(o.total_amount) AS gia_tri_don_trung_binh
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 3 
   AND SUM(o.total_amount) > 10000000
ORDER BY tong_tien_chi DESC;

-- Bài 6
USE Session06;
SELECT p.product_name, SUM(oi.quantity) AS tong_so_luong_ban, SUM(p.price * oi.quantity) AS tong_doanh_thu, AVG(p.price) AS gia_ban_trung_binh
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY tong_doanh_thu DESC
LIMIT 5 OFFSET 5;