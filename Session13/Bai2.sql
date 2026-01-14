use Session13;
create table likes (
    like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime default now(),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

delimiter //
create trigger after_insert_likes after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end//
delimiter ;

delimiter //
create trigger after_delete_likes after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end//
delimiter ;

create view user_statistics as
select 
	users.user_id,
    users.username,
    users.post_count, 
    sum(posts.like_count) as total_likes
from users left join posts on users.user_id = posts.user_id
group by users.user_id, users.username, users.post_count;

insert into likes (user_id, post_id, liked_at) values (2, 4, now());
select * from posts where post_id = 4;
select * from user_statistics;

delete from likes where user_id = 2 and post_id = 4;
select * from user_statistics;