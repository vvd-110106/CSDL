create database social_network;
use social_network;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null,
    posts_count int default 0
);
create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);
insert into users (username, posts_count)values 
('nguyễn văn an', 0),
('trần thị bình', 0);

start transaction;
insert into posts (user_id, content)values
(1, 'đây là bài viết đầu tiên của tôi');
update users  set posts_count = posts_count + 1 where user_id = 1;
commit;
select * from posts;
select * from users;

start transaction;
insert into posts (user_id, content)values
(999, 'bài viết này sẽ bị lỗi');
update users set posts_count = posts_count + 1 where user_id = 999; 
rollback;
select * from posts;
select * from users;
