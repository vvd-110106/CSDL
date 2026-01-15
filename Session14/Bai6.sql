use social_network;
create table friend_requests (
    request_id int auto_increment primary key,
    from_user_id int,
    to_user_id int,
    status enum('pending','accepted','rejected') default 'pending'
);
create table friends (
    user_id int,
    friend_id int,
    primary key (user_id, friend_id)
);
alter table users
add friends_count int default 0;

delimiter $$
create procedure sp_accept_friend_request (
    in p_request_id int,
    in p_to_user_id int
)
proc: begin
    declare v_from_user_id int;
    -- thiết lập mức cô lập
    set transaction isolation level repeatable read;
    start transaction;
    -- kiểm tra lời mời tồn tại và hợp lệ
    select from_user_id
    into v_from_user_id
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id
      and status = 'pending';
    if v_from_user_id is null then
        rollback;
        leave proc;
    end if;
    -- kiểm tra đã là bạn chưa
    if exists ( select 1 from friends where user_id = v_from_user_id and friend_id = p_to_user_id) then
        rollback;
        leave proc;
    end if;
    -- thêm bạn hai chiều
    insert into friends (user_id, friend_id)
    values (v_from_user_id, p_to_user_id);
    insert into friends (user_id, friend_id)
    values (p_to_user_id, v_from_user_id);
    -- cập nhật số lượng bạn bè
    update users
    set friends_count = friends_count + 1
    where user_id in (v_from_user_id, p_to_user_id);
    -- cập nhật trạng thái lời mời
    update friend_requests
    set status = 'accepted'
    where request_id = p_request_id;
    commit;
end$$
delimiter ;

insert into friend_requests (from_user_id, to_user_id)
values (1, 2);
call sp_accept_friend_request(1, 2);
call sp_accept_friend_request(1, 2);
select * from friends;
select user_id, friends_count from users;
select * from friend_requests;
