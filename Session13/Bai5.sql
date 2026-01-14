use Session13;
delimiter //
create procedure add_user( in p_username varchar(100), in p_email varchar(100), in p_created_at date)
begin
    insert into users(username, email, created_at)
    values (p_username, p_email, p_created_at);
end//
delimiter ;
drop trigger if exists before_insert_users;
delimiter //

create trigger before_insert_users before insert on users
for each row
begin
    if new.email not like '%@%' or new.email not like '%.%' then
        signal sqlstate '45000'
        set message_text = 'email không hợp lệ';
    end if;

    if new.username not regexp '^[a-zA-Z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'username không hợp lệ';
    end if;
end//
delimiter ;

call add_user('user_01', 'user01@example.com', '2025-01-01');
call add_user('user_02', 'user02example.com', '2025-01-02');
call add_user('user-03', 'user03@example.com', '2025-01-03');
select * from users;