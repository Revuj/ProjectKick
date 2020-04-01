
--------- Dashboard ----------
select *
	from project
	where author_id = $author_id;
	
select "user".id, "user".username, "user".photo_path
	from "user", project, member_status
	where project.id = $project_id
	and member_status.project_id = project.id
	and "user".id = member_status.user_id
	and departure_date is null;
	
select COUNT(*) from issue_list, project, issue where issue_list.project_id = project.id and issue_list.id = issue.id and project.id = 1  GROUP by issue.is_completed ;


--------- My Work ----------
	
select issue.id, name, creation_date, due_date, count("comment") as comments_count
	from issue, assigned_user, "comment"
	where assigned_user.user_id = 1
	and issue.id = assigned_user.issue_id
	and is_completed = false
	and "comment".issue_id = issue.id
	group by issue.id;
	
select "user".id, "user".name, "user".photo_path
	from issue, assigned_user, "user"
	where assigned_user.user_id = 1
	and "user".id = 1
	and issue.id = assigned_user.issue_id;

--------- Calendar ----------
-- fazer para ambos (1 mes e 1 dia)
select event_meeting.event_id, event_meeting.project_id, title, start_date, end_date
	from member_status, event_meeting, "event"
	where member_status.user_id = 2
	and departure_date IS null
	and member_status.project_id = event_meeting.project_id
	and event_meeting.event_id = "event".id;

select event_personal.event_id, title, start_date, end_date
	from event_personal, "event"
	where event_personal.user_id = 2
	and event_personal.event_id = "event".id
	and EXTRACT(DAY from "event".start_date) = 27;


--------- PROJECT OVERVIEW ----------
SELECT * FROM project where id = 1; -- general info

select username from "user" where id = 3; -- creator

select name from channel where project_id = 1 limit 7; -- channel names

select issue.creation_date, issue.name, username from issue_list, issue, "user" where issue.author_id = "user".id and issue_list.project_id = $project_id and issue_list.id = issue.issue_list_id order by issue.creation_date desc limit 4; --last issues

-- fazer a razao
select COUNT(*) from issue_list, project, issue where issue_list.project_id = project.id and issue_list.id = issue.id and project.id = 1  GROUP by issue.is_completed ; 

-- project members em cima

--------- issue list -----
-- acrescentar o is_completed
select issue.id, issue.name, issue.creation_date, due_date, "user".username from issue_list, project, issue, "user" where issue_list.project_id = project.id and issue_list.id = issue.issue_list_id and project.id = 1 and "user".id = issue.author_id;

-- tendo a issue_id ir buscar as tags
select tag.name, color from tag, issue_tag, color, issue where issue.id = issue_tag.issue_id and tag.id = issue_tag.tag_id and issue.id = 2 and color.id = tag.color_id;

-- count the number of comments on each issue
select count(comment.id) from comment, issue where issue_id = 1;

-- select all the images path of all participants in the issue
select "user".photo_path from "user", assigned_user, issue where "user".id = assigned_user.user_id and issue.id = assigned_user.issue_id and issue.id = 1;

-- temos isto em cima x)

------------- issue ------------------------

-- tendo a issue_id ir buscar as tags
select tag.name, color from tag, issue_tag, color, issue where issue.id = issue_tag.issue_id and tag.id = issue_tag.tag_id and issue.id = 2 and color.id = tag.color_id;

select *  from issue where id = 1;

-- tendo a issue ver os comments
-- ir buscar a foto
select * from comment where issue_id = 48;

-- tendo o comentario respetivo ver os votos
select count(*) from vote, comment, "user" where vote.comment_id = comment.id and vote.user_id = "user".id and comment.id = 4 group by upvote ;

select "user".photo_path from "user", assigned_user, issue where "user".id = assigned_user.user_id and issue.id = assigned_user.issue_id and issue.id = 1;

-------	boards -------------

select * from issue_list where project_id = 1;

-- for each issue_list fetch the issues

select name, id from issue where issue_list_id = 1;

-- for each issue
select "user".photo_path from "user", assigned_user, issue where "user".id = assigned_user.user_id and issue.id = assigned_user.issue_id and issue.id = 1;

select tag.name, color from tag, issue_tag, color, issue where issue.id = issue_tag.issue_id and tag.id = issue_tag.tag_id and issue.id = 2 and color.id = tag.color_id;

com os filtros --> tsqueries

----------- channels -------------
-- select all the channels 
select * from channel where project_id = 1;

-- for the select channel
-- selecionar foto
-- limitar mensagens
select content, date, user_id as sender from message where channel_id = 1;

---------- activity ---------------
-- tendo o id do project
-- falta os counts das queries
select * from issue, issue_list, project 
where issue.issue_list_id = issue_list.id and 
issue_list.project_id = 3 and
issue.creation_date > current_date - 7;

select * from issue, issue_list, project 
where issue.issue_list_id = issue_list.id and 
issue_list.project_id = 3 and
issue.creation_date > current_date -  interval '1 month';

select * from issue, issue_list, project 
where issue.issue_list_id = issue_list.id and 
issue_list.project_id = 3 and
issue.creation_date >  current_date - 1;

select * from issue, issue_list, project 
where issue.issue_list_id = issue_list.id and 
issue_list.project_id = 3
order by issue.creation_date desc; -- se calhar order feito da parte do user

-- new entrances

select * from member_status
where member_status.project_id = 1 and
entrance_date > current_date - 1;

select * from member_status
where member_status.project_id = 1 and
entrance_date > current_date - 7;

select * from member_status
where member_status.project_id = 1 and
entrance_date > current_date - interval '1 month';

select * from member_status
where member_status.project_id = 1;

-- kicked out /left team ---

select * from member_status
where member_status.project_id = 1 and
departure_date > current_date - 1;

select * from member_status
where member_status.project_id = 1 and
departure_date > current_date - 7;

select * from member_status
where member_status.project_id = 1 and
departure_date > current_date - interval '1 month';

select * from member_status
where member_status.project_id = 1;


-- comment--
-- um bcd lenta ...
select c.content, c.creation_date, "user".username from comment as c, issue, issue_list, "user"
where issue_list.project_id = 1 and
issue.issue_list_id = issue_list.id and
c.user_id = "user".id and
c.creation_date > current_date - 1;

select c.content, c.creation_date, "user".username from comment as c, issue, issue_list, "user"
where issue_list.project_id = 1 and
issue.issue_list_id = issue_list.id and
c.user_id = "user".id and
c.creation_date > current_date - 7;

select c.content, c.creation_date, "user".username from comment as c, issue, issue_list, "user"
where issue_list.project_id = 1 and
issue.issue_list_id = issue_list.id and
c.user_id = "user".id and
c.creation_date > current_date - interval '1 month';

select c.content, c.creation_date, "user".username from comment as c, issue, issue_list, "user"
where issue_list.project_id = 1 and
issue.issue_list_id = issue_list.id and
c.user_id = "user".id;

-- fechar issues

-- create channels
-- admin
update user
	set is_banned = $banned,
	where id = $id;

select count(id) from project;

select count(id) from issue where is_completed = true;

select count(id) from "user" where is_admin = false;

select count(id) from report;

select count("user".id) from "user", country where "user".country_id = country.id group by country.id;

-- nr projetos criados nos ultimos 12 meses
select
    date_part('month', creation_date) as month,
    count(id)
	from project
	where
		DATE_PART('year', creation_date::date) - DATE_PART('year', current_date::date) < 3
	group by
    	date_part('month', creation_date)
	order by date_part('month', creation_date);

-- nr de users criados ultimos 12 meses
select
    date_part('month', creation_date) as month,
    count(id)
	from "user"
	where
		DATE_PART('year', creation_date::date) - DATE_PART('year', current_date::date) < 3
	group by
    	date_part('month', creation_date)
	order by date_part('month', creation_date);


-- range date queries
-- project number

-- tamanho das equipas
-- bans

	
select * from "user" order by creation_date desc limit 8;






	







