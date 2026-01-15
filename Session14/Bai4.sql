use social_network;
create table comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);
alter table posts add comments_count int default 0;

delimiter $$
create procedure sp_post_comment (
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
proc: begin
    start transaction;
    -- thêm bình luận
    insert into comments (post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);
    -- tạo savepoint
    savepoint after_insert;
    -- cập nhật số lượng bình luận
    update posts
    set comments_count = comments_count + 1
    where post_id = p_post_id;
    commit;
end$$
delimiter ;

delimiter $$
create procedure sp_post_comment_test_error (
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
proc: begin
    start transaction;
    insert into comments (post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);
    savepoint after_insert;
    -- gây lỗi cố ý (post_id không tồn tại)
    update posts
    set comments_count = comments_count + 1
    where post_id = -1;
    rollback to after_insert;
    commit;
end$$
delimiter ;

call sp_post_comment(1, 1, 'bình luận đầu tiên');
call sp_post_comment_test_error(1, 1, 'bình luận bị rollback phần update');
select * from comments;
select post_id, comments_count from posts;
