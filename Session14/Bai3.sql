use social_network;
create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);
create table follow_log (
    log_id int auto_increment primary key,
    follower_id int,
    followed_id int,
    error_message varchar(255),
    created_at datetime default current_timestamp
);

alter table users
add following_count int default 0,
add followers_count int default 0;

delimiter $$
create procedure sp_follow_user (
    in p_follower_id int,
    in p_followed_id int
)
proc: begin
    start transaction;
    -- kiểm tra user tồn tại
    if not exists (select 1 from users where user_id = p_follower_id)
       or not exists (select 1 from users where user_id = p_followed_id) then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'user không tồn tại');
        rollback;
        leave proc;
    end if;
    -- không cho tự follow chính mình
    if p_follower_id = p_followed_id then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'không thể tự follow chính mình');
        rollback;
        leave proc;
    end if;
    -- kiểm tra đã follow trước đó chưa
    if exists (
        select 1 from followers
        where follower_id = p_follower_id
          and followed_id = p_followed_id
    ) then
        insert into follow_log(follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'đã follow trước đó');
        rollback;
        leave proc;
    end if;

    -- thêm quan hệ follow
    insert into followers(follower_id, followed_id)
    values (p_follower_id, p_followed_id);
    -- tăng following_count
    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;
    -- tăng followers_count
    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;
    commit;
end$$
delimiter ;

call sp_follow_user(1, 2);
call sp_follow_user(1, 2);
call sp_follow_user(1, 1);
call sp_follow_user(1, 999);
select * from followers;
select user_id, following_count, followers_count from users;
select * from follow_log;
