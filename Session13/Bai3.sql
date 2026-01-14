use Session13;
insert into posts (user_id, content, created_at)
values (2, 'another post by bob', '2025-01-13 10:00:00');

drop trigger if exists after_insert_likes;
drop trigger if exists after_delete_likes;

-- 3
delimiter //
create trigger before_insert_likes
before insert on likes
for each row
begin
    declare post_owner int;
    select user_id
    into post_owner
    from posts
    where post_id = new.post_id;
    if new.user_id = post_owner then
        signal sqlstate '45000'
        set message_text = 'user cannot like own post';
    end if;
end//
delimiter ;

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

delimiter //
create trigger after_update_likes after update on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;

    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end//
delimiter ;

-- 4
insert into likes (user_id, post_id, liked_at) values (1, 1, now());

insert into likes (user_id, post_id, liked_at) values (1, 3, now());
select post_id, like_count from posts where post_id = 3;

update likes set post_id = 4
where user_id = 1 and post_id = 3;
select post_id, like_count from posts where post_id in (3, 4);

delete from likes where user_id = 1 and post_id = 4;
select post_id, like_count from posts where post_id = 4;
-- 5
select * from posts;
select * from user_statistics;
