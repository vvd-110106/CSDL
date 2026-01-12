-- Bài 1
use social_network_pro;

delimiter $$
create procedure sp_get_user_posts(in p_user_id int)
begin select post_id, content, created_at from posts where user_id = p_user_id;
end $$
delimiter ;

call sp_get_user_posts(1);
drop procedure sp_get_user_posts;


-- Bài 2
use social_network_pro;

delimiter $$
create procedure CalculatePostLikes( in p_post_id int, out total_likes int)
begin select count(*) into total_likes from likes where post_id = p_post_id;
end $$
delimiter ;

call CalculatePostLikes(1, @total_likes);
select @total_likes as total_likes;

drop procedure CalculatePostLikes;

-- Bài 3
use social_network_pro;
delimiter $$
create procedure CalculateBonusPoints(
    in p_user_id int,
    inout p_bonus_points int
)
begin declare post_count int;
-- đếm số bài viết của user
select count(*) into post_count from posts where user_id = p_user_id;

-- cộng điểm theo số bài viết
if post_count >= 20 then
	set p_bonus_points = p_bonus_points + 100;
elseif post_count >= 10 then
	set p_bonus_points = p_bonus_points + 50;
end if;
end $$
delimiter ;

set @bonus_points = 100;
call CalculateBonusPoints(1, @bonus_points);

select @bonus_points as bonus_points;
drop procedure CalculateBonusPoints;

-- Bài 4:
delimiter $$
create procedure CreatePostWithValidation( in p_user_id int, in p_content text, out result_message varchar(255))
begin
if char_length(p_content) < 5 then
	set result_message = 'Nội dung quá ngắn';
else
	insert into posts(user_id, content, created_at)
	values (p_user_id, p_content, now());
	set result_message = 'Thêm bài viết thành công';
end if;
end $$
delimiter ;

call CreatePostWithValidation(1, 'ab', @result); select @result;
call CreatePostWithValidation(1, 'Nội dung của bài viết ', @result); select @result;

select post_id, user_id, content from posts order by post_id desc;
drop procedure CreatePostWithValidation;

-- Bài 5:
delimiter $$
create procedure CalculateUserActivityScore(in p_user_id int, out activity_score int, out activity_level varchar(50))
begin declare total_posts int; declare total_comments int; declare total_likes int;

-- đếm số bài viết
select count(*) into total_posts from posts where user_id = p_user_id;

-- đếm số comment
select count(*) into total_comments from comments where user_id = p_user_id;

-- đếm số like nhận được trên bài viết
select count(*) into total_likes from likes join posts on likes.post_id = posts.post_id where posts.user_id = p_user_id;

-- tính tổng điểm
set activity_score =total_posts * 10 + total_comments * 5 + total_likes * 3;

-- phân loại mức độ hoạt động
if activity_score > 500 then
	set activity_level = 'Rất tích cực';
elseif activity_score >= 200 then
	set activity_level = 'Tích cực';
else
	set activity_level = 'Bình thường';
end if;
end $$
delimiter ;

call CalculateUserActivityScore(1, @score, @level);
select @score as activity_score, @level as activity_level;

drop procedure CalculateUserActivityScore;

-- Bài 6
delimiter $$
create procedure NotifyFriendsOnNewPost( in p_user_id int, in p_content text)
begin declare done int default 0; declare v_friend_id int; declare v_full_name varchar(255);
declare cur cursor for
	select friend_id from friends
	where user_id = p_user_id and status = 'accepted'
	union
	select user_id from friends
	where friend_id = p_user_id and status = 'accepted';

declare continue handler for not found set done = 1;
    select full_name into v_full_name
    from users where user_id = p_user_id;

    insert into posts(user_id, content, created_at)
    values (p_user_id, p_content, now());

    open cur;
    loop_read: loop
        fetch cur into v_friend_id;
        if done = 1 then leave loop_read; end if;

        insert into notifications(user_id, type, content, created_at)
        values (
            v_friend_id,
            'new_post',
            concat(v_full_name, ' da dang bai viet moi'),
            now()
        );
    end loop;
    close cur;
end $$
delimiter ;

call NotifyFriendsOnNewPost(1, 'bai viet moi');
select * from notifications order by notification_id desc;
drop procedure NotifyFriendsOnNewPost;