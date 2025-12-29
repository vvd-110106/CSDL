CREATE DATABASE Session03;
-- Bài 1
-- https://app.xmind.com/share/90pqSgma?xid=S5pASSdS
-- Bài 2
USE Session03;
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);
INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(1, 'Do Khac Quyen', '2003-05-10', 'quyen@gmail.com'),
(2, 'Pham Thanh Dat', '2004-08-20', 'dat@gmail.com'),
(3, 'Tran Viet Anh', '2003-12-01', 'tva@gmail.com');

SELECT * FROM Student;
SELECT student_id, full_name FROM Student;

-- Bài 3
USE Session03;
UPDATE Student
SET email = 'newemail1@gmail.com'
WHERE student_id = 1;

-- Cap nhat email cho sinh vien co student_id = 3
UPDATE Student
SET email = 'newemail3@gmail.com'
WHERE student_id = 3;

-- Cap nhat ngay sinh cho mot sinh vien khac (vi du student_id = 2)
UPDATE Student
SET date_of_birth = '2004-09-15'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 5;

SELECT * FROM Student;

-- Bài 4
USE Session03;
CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100),
    credit INT CHECK (credit > 0)
);

-- Thêm dữ liệu bảng Subject
INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
(1, 'Cơ sở dữ liệu', 3),
(2, 'Lập trình C', 4),
(3, 'Lập trình Java', 3);

-- Cập nhật số tín chỉ cho 1 môn học (Vd sub_id = 2)
UPDATE Subject
SET credit = 5
WHERE subject_id = 2;

-- đổi tên 1 môn học (vd sub_id = 3)
UPDATE Subject
SET subject_name = 'Lập trình Java nâng cao'
WHERE subject_id = 3;
-- Kiem tra lại dữ liệu
SELECT * FROM Subject;

-- Bài 5
USE Session03;
CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE,

    -- Khóa chính kép: không cho đăng ký trùng môn cho cùng một sinh viên
    PRIMARY KEY (student_id, subject_id),

    -- Khóa ngoại liên kết với bảng Student
    FOREIGN KEY (student_id) REFERENCES Student(student_id),

    -- Khóa ngoại liên kết với bảng Subject
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- Thêm dữ liệu đăng ký môn học cho sinh viên
INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(1, 1, '2024-09-01'),
(1, 2, '2024-09-02'),
(2, 1, '2024-09-01'),
(2, 3, '2024-09-03');

-- Lấy ra tất cả các lượt đăng ký
SELECT * FROM Enrollment;

-- Lấy ra các lượt đăng ký của một sinh viên cụ thể (ví dụ student_id = 1)
SELECT *
FROM Enrollment
WHERE student_id = 1;

-- Bài 6
USE Session03;
CREATE TABLE Score (
    student_id INT,
    subject_id INT,
    mid_score FLOAT CHECK (mid_score BETWEEN 0 AND 10),
    final_score FLOAT CHECK (final_score BETWEEN 0 AND 10),

    -- Khóa chính kép: mỗi sinh viên chỉ có một bảng điểm cho mỗi môn
    PRIMARY KEY (student_id, subject_id),

    -- Khóa ngoại liên kết với bảng Student
    FOREIGN KEY (student_id) REFERENCES Student(student_id),

    -- Khóa ngoại liên kết với bảng Subject
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(1, 1, 7.5, 8.0),
(1, 2, 6.5, 7.0),
(2, 1, 8.0, 8.5),
(2, 3, 7.0, 9.0);

-- Cập nhật điểm cuối kỳ cho một sinh viên (ví dụ student_id = 1, subject_id = 2)
UPDATE Score
SET final_score = 8.5
WHERE student_id = 1 AND subject_id = 2;

-- Lấy ra toàn bộ bảng điểm
SELECT * FROM Score;
SELECT * FROM Score WHERE final_score >= 8;

-- Bài 7
USE Session03;
INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES (4, 'Nguyen Minh Hoang', '2004-03-15', 'hoang@gmail.com');

-- Đăng ký ít nhất 2 môn học cho sinh viên vừa thêm
INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(4, 1, '2024-09-05'),
(4, 2, '2024-09-05');

-- Thêm điểm cho sinh viên vừa thêm
INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(4, 1, 7.0, 8.0),
(4, 2, 6.5, 7.5);

-- Cập nhật điểm cuối kỳ cho sinh viên vừa thêm
UPDATE Score
SET final_score = 8.5
WHERE student_id = 4 AND subject_id = 2;

-- Xóa một lượt đăng ký không hợp lệ
DELETE FROM Enrollment
WHERE student_id = 4 AND subject_id = 1;

-- Lấy ra danh sách sinh viên và điểm số tương ứng
SELECT * FROM Student;
SELECT * FROM Score;