CREATE DATABASE Session05;

-- Bài 1
USE Session05;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    stock INT,
    status VARCHAR(20)
);

INSERT INTO products (product_id, product_name, price, stock, status) VALUES
(1, 'Laptop Dell', 15000000.00, 5, 'active'),
(2, 'Chuot Logitech', 500000.00, 20, 'active'),
(3, 'Ban phim cu', 200000.00, 0, 'inactive'),
(4, 'Man hinh ASUS', 3500000.00, 7, 'active'),
(5, 'Loa Bluetooth', 1200000.00, 10, 'active');

SELECT * FROM products;
-- Lấy danh sách sản phẩm đang bán (status = 'active')
SELECT * FROM products 
WHERE status = 'active';
-- Lấy các sản phẩm có giá lớn hơn 1.000.000
SELECT * FROM products 
WHERE price > 1000000;
-- Hiển thị danh sách sản phẩm đang bán, sắp xếp theo giá tăng dần
SELECT * FROM products 
WHERE status = 'active' 
ORDER BY price ASC;

-- Bài 2
USE Session05;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status VARCHAR(20)
);

INSERT INTO customers (customer_id, full_name, email, city, status) VALUES
(1, 'Nguyen Van A', 'vana@gmail.com', 'TP.HCM', 'active'),
(2, 'Tran Thi B', 'thib@gmail.com', 'Hà Nội', 'active'),
(3, 'Le Van C', 'vanc@gmail.com', 'TP.HCM', 'inactive'),
(4, 'Pham Minh D', 'minhd@gmail.com', 'Hà Nội', 'inactive'),
(5, 'Hoang Lan E', 'lane@gmail.com', 'Đà Nẵng', 'active'),
(6, 'Bui Quang F', 'quangf@gmail.com', 'Hà Nội', 'active');

-- Lấy danh sách tất cả khách hàng
SELECT * FROM customers;
-- Lấy khách hàng ở TP.HCM
SELECT * FROM customers 
WHERE city = 'TP.HCM';
-- Lấy khách hàng đang hoạt động và ở Hà Nội
SELECT * FROM customers 
WHERE status = 'active' AND city = 'Hà Nội';
-- Sắp xếp danh sách khách hàng theo tên (A -> Z)
SELECT * FROM customers 
ORDER BY full_name ASC;

-- Bài 3
USE Session05;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20) -- 'pending', 'completed', 'cancelled'
);

INSERT INTO orders (order_id, customer_id, total_amount, order_date, status) VALUES
(1, 101, 6000000.00, '2025-01-01', 'completed'),
(2, 102, 2000000.00, '2025-01-02', 'pending'),
(3, 103, 7500000.00, '2025-01-03', 'completed'),
(4, 104, 1500000.00, '2025-01-04', 'cancelled'),
(5, 105, 5500000.00, '2025-01-05', 'completed'),
(6, 106, 3000000.00, '2025-01-06', 'completed'),
(7, 107, 9000000.00, '2025-01-07', 'pending');

-- Lấy danh sách đơn hàng đã hoàn thành
SELECT * FROM orders
WHERE status = 'completed';

-- Lấy các đơn hàng có tổng tiền > 5.000.000
SELECT * FROM orders
WHERE total_amount > 5000000;

-- Hiển thị 5 đơn hàng mới nhất
-- Sắp xếp ngày giảm dần (DESC) để ngày gần đây nhất lên đầu
SELECT * FROM orders
ORDER BY order_date DESC
LIMIT 5;

-- Hiển thị các đơn hàng đã hoàn thành, sắp xếp theo tổng tiền giảm dần
SELECT * FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;

-- Bài 4
USE Session05;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    stock INT,
    sold_quantity INT, -- Số lượng đã bán
    status VARCHAR(20)
);

INSERT INTO products (product_id, product_name, price, stock, sold_quantity, status) VALUES
(1, 'Tai nghe A', 500000.00, 100, 150, 'active'),
(2, 'Chuot B', 300000.00, 50, 200, 'active'),
(3, 'Ban phim C', 1200000.00, 30, 80, 'active'),
(4, 'Sac du phong D', 450000.00, 80, 300, 'active'),
(5, 'Op lung E', 100000.00, 200, 500, 'active'),
(6, 'Loa Bluetooth F', 1500000.00, 20, 45, 'active'),
(7, 'Cap sac G', 150000.00, 150, 250, 'active'),
(8, 'Quat mini H', 200000.00, 40, 120, 'active'),
(9, 'Den hoc I', 350000.00, 25, 60, 'active'),
(10, 'Tui chong soc J', 250000.00, 60, 95, 'active'),
(11, 'Mieng dan K', 50000.00, 300, 1000, 'active'),
(12, 'Gia do L', 120000.00, 70, 40, 'active'),
(13, 'Balo M', 500000.00, 15, 75, 'active'),
(14, 'Lot chuot N', 100000.00, 100, 110, 'active'),
(15, 'Gậy selfie O', 180000.00, 40, 30, 'active');

-- Lấy 10 sản phẩm bán chạy nhất
-- Sắp xếp số lượng bán giảm dần
SELECT * FROM products
ORDER BY sold_quantity DESC
LIMIT 10;

-- Lấy 5 sản phẩm bán chạy tiếp theo (bỏ qua 10 sản phẩm đầu)
SELECT * FROM products
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

-- Hiển thị danh sách sản phẩm giá < 2.000.000, sắp xếp theo số lượng bán giảm dần
SELECT * FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;

-- Bài 5
-- Lấy danh sách đơn hàng chưa bị hủy (status <> 'cancelled')
-- Trang 1: hiển thị 5 đơn hàng mới nhất (Sắp xếp ngày giảm dần, lấy 5 dòng đầu)
SELECT * FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

-- Trang 2: hiển thị 5 đơn hàng tiếp theo
SELECT * FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

-- Trang 3: hiển thị 5 đơn hàng tiếp theo
SELECT * FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;

-- Bài 6
-- Lấy sản phẩm đang bán, giá từ 1.000.000 đến 3.000.000, sắp xếp giá tăng dần
-- Trang 1: Hiển thị 10 sản phẩm đầu tiên
SELECT * FROM products
WHERE status = 'active' 
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;

-- Trang 2: Hiển thị 10 sản phẩm tiếp theo
SELECT * FROM products
WHERE status = 'active' 
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;