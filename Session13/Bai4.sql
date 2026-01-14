use Session13;
create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);
drop trigger if exists before_update_posts_history;
drop trigger if exists after_delete_posts_history;

delimiter //
create trigger before_update_posts_history before update on posts
for each row
begin
    if old.content <> new.content then
		insert into post_history( post_id, old_content, new_content, changed_at, changed_by_user_id)
		values( old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end//
delimiter ;

delimiter //
create trigger before_update_posts_history before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        values (old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end//
delimiter ;

update posts
set content = 'nội dung bài viết đã được chỉnh sửa lần 1'
where post_id = 1;
update posts
set content = 'nội dung bài viết đã được chỉnh sửa lần 2'
where post_id = 1;
select * from post_history;

select post_id, like_count
from posts;

