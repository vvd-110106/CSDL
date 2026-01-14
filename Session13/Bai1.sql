create database Session13;
use Session13;

-- Bài 1
create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);
create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter //
create trigger after_insert_posts after insert on posts
for each row
begin 
	update users 
    set post_count = post_count + 1 
    where user_id = new.user_id;
end//
delimiter ;

delimiter //
create trigger after_delete_posts after delete on posts
for each row
begin 
	update users 
    set post_count = post_count - 1 
    where user_id = old.user_id;
end//
delimiter ;
insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');
select * from users;
delete from posts where post_id = 2;
select * from users;