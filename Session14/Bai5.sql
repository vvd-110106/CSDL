use social_network;
create table delete_log (
    log_id int auto_increment primary key,
    post_id int,
    deleted_by int,
    deleted_at datetime default current_timestamp
);
delimiter $$

create procedure sp_delete_post (
    in p_post_id int,
    in p_user_id int
)
proc: begin
    start transaction;
    -- kiểm tra bài viết tồn tại và đúng chủ bài viết
    if not exists (select 1 from posts where post_id = p_post_id and user_id = p_user_id) then
        rollback;
        leave proc;
    end if;
    -- xóa tất cả lượt thích của bài viết
    delete from likes
    where post_id = p_post_id;
    -- xóa tất cả bình luận của bài viết
    delete from comments
    where post_id = p_post_id;
    -- xóa bài viết
    delete from posts
    where post_id = p_post_id;
    -- cập nhật lại số lượng bài viết của người dùng
    update users
    set posts_count = posts_count - 1
    where user_id = p_user_id;
    -- ghi log xóa thành công
    insert into delete_log (post_id, deleted_by)
    values (p_post_id, p_user_id);
    commit;
end$$
delimiter ;

call sp_delete_post(1, 1);
call sp_delete_post(1, 2);
select * from posts;
select * from likes;
select * from comments;
select user_id, posts_count from users;
select * from delete_log;
