use social_network;
alter table posts
add likes_count int default 0;

create table likes (
    like_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id),
    unique key unique_like (post_id, user_id)
);
select * from users;
select * from posts;

start transaction;
insert into likes (post_id, user_id) values (1, 1);
update posts set likes_count = likes_count + 1 where post_id = 1;
commit;
select * from likes;
select post_id, likes_count from posts;

start transaction;
insert into likes (post_id, user_id) values (1, 1);
update posts set likes_count = likes_count + 1 where post_id = 1;
rollback;
select * from likes;
select post_id, likes_count from posts;

