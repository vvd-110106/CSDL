-- bài 1 : 

-- 2.1 Viết câu lệnh tạo cơ sở dữ liệu tên quanlybanhang .
CREATE DATABASE quanlybanhang;
USE quanlybanhang;

-- 2.2 Viết câu lệnh tạo 5 bảng theo mô tả ở trên.
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(50) NOT NULL
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    revenue DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE orderdetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 3.1 Thêm cột email có kiểu dữ liệu varchar(100) not null unique vào bảng Customers
ALTER TABLE customers
ADD email VARCHAR(100) NOT NULL UNIQUE;

-- 3.2 Xóa cột ngày sinh ra khỏi bảng Employees
ALTER TABLE employees
DROP COLUMN birthday;

-- PHẦN 2: TRUY VẤN DỮ LIỆU

-- Câu 4 Viết câu lệnh chèn dữ liệu vào bảng (mỗi bảng ít nhất 5 bản ghi phù hợp)
INSERT INTO customers (customer_name, phone, address, email) VALUES
('nguyen a', '090000001', 'ha noi', 'a@gmail.com'),
('tran b', '090000002', 'hai phong', 'b@gmail.com'),
('le c', '090000003', 'da nang', 'c@gmail.com'),
('pham d', '090000004', 'hcm', 'd@gmail.com'),
('hoang e', '090000005', 'can tho', 'e@gmail.com');

INSERT INTO products (product_name, price, quantity, category) VALUES
('laptop hp', 500, 200, 'laptop'),
('chuot logitech', 20, 500, 'phu kien'),
('ban phim corsair', 50, 300, 'phu kien'),
('man hinh dell', 150, 150, 'man hinh'),
('tai nghe sony', 80, 250, 'am thanh');

INSERT INTO employees (employee_name, position, salary) VALUES
('nhan vien 1', 'ban hang', 500),
('nhan vien 2', 'ban hang', 550),
('nhan vien 3', 'quan ly', 1000),
('nhan vien 4', 'ke toan', 700),
('nhan vien 5', 'ban hang', 520);

INSERT INTO orders (customer_id, employee_id, total_amount) VALUES
(1, 1, 100),
(2, 2, 200),
(3, 3, 300),
(1, 2, 150),
(4, 1, 400);

INSERT INTO orderdetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 500),
(1, 2, 5, 20),
(2, 3, 3, 50),
(3, 4, 4, 150),
(4, 5, 6, 80);

-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách hàng, tên khách hàng, email, số điện thoại và địa chỉ
SELECT customer_id, customer_name, email, phone, address
FROM customers;

-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name= “Laptop Dell XPS” và price = 99.99
UPDATE products SET product_name = 'laptop dell xps', price = 99.99
WHERE product_id = 1;

-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt hàng.
SELECT o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id;

-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm :mã nhân viên, tên nhân viên, doanh thu
SELECT e.employee_id, e.employee_name, SUM(o.total_amount) AS revenue FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
WHERE YEAR(o.order_date) = YEAR(CURRENT_DATE)
GROUP BY e.employee_id, e.employee_name;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại.Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần
SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_quantity FROM orderdetails od
JOIN orders o ON od.order_id = o.order_id
JOIN products p ON od.product_id = p.product_id
WHERE MONTH(o.order_date) = MONTH(CURRENT_DATE) AND YEAR(o.order_date) = YEAR(CURRENT_DATE)
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) > 100
ORDER BY total_quantity DESC;

-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng
SELECT c.customer_id, c.customer_name FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(t.total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY customer_id
    ) t
);

-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự ngày đặt mới nhất
CREATE VIEW view_order_list AS
SELECT o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC;

-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp theo số lượng giảm dần
CREATE VIEW view_order_detail_product AS
SELECT od.order_detail_id, p.product_name, od.quantity, od.unit_price FROM orderdetails od
JOIN products p ON od.product_id = p.product_id
ORDER BY od.quantity DESC;

-- 9.1 Tạo thủ tục có tên proc_insert_employee ...
DELIMITER $$

CREATE PROCEDURE proc_insert_employee(
    IN p_name VARCHAR(100),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    OUT new_id INT
)
BEGIN
    INSERT INTO employees(employee_name, position, salary)
    VALUES (p_name, p_position, p_salary);

    SET new_id = LAST_INSERT_ID();
END$$

DELIMITER ;

-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo mã đặt hàng.
DELIMITER $$

CREATE PROCEDURE proc_get_orderdetails(IN p_order_id INT)
BEGIN
    SELECT *
    FROM orderdetails
    WHERE order_id = p_order_id;
END$$

DELIMITER ;

-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.
DELIMITER $$

CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT,
    OUT total_products INT
)
BEGIN
    SELECT COUNT(DISTINCT product_id)
    INTO total_products
    FROM orderdetails
    WHERE order_id = p_order_id;
END$$

DELIMITER ;

-- Câu 10 Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. Nếu số lượng trong kho không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy thao tác chèn.
DELIMITER $$

CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT quantity INTO current_stock
    FROM products
    WHERE product_id = NEW.product_id;

    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'so luong san pham trong kho khong du';
    ELSE
        UPDATE products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END$$

DELIMITER ;

-- Câu 11: Quản lý transaction
DELIMITER $$

CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE order_count INT;

    START TRANSACTION;

    SELECT COUNT(*) INTO order_count
    FROM orders
    WHERE order_id = p_order_id;

    IF order_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'khong ton tai ma hoa don';
        ROLLBACK;
    ELSE
        INSERT INTO orderdetails(order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);

        UPDATE orders
        SET total_amount = total_amount + (p_quantity * p_unit_price)
        WHERE order_id = p_order_id;

        COMMIT;
    END IF;
END$$

DELIMITER ;

