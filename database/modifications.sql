--------- Dashboard ----------
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, $name, $description, $creation_date, $finish_date, $author_id);

--------- My Work ----------
insert into issue (id, name, description, creation_date, due_date, is_completed, issue_list_id, author_id, complete_id) values ($id, $name, $description, $creation_date, $due_date, $is_completed, $issue_list_id, $author_id, $complete_id);

--------- Calendar ----------
insert into event_personal (event_id, user_id) values ($event_id, $user_id);
insert into event_meeting (event_id, project_id) values ($event_id, $project_id);
insert into "event" (id, title, start_date, end_date) values ($id, $title, $start_date, $end_date);

delete from "event"
  where id = $id;

-- issue page
-- add tags e members
update issue
	set name = $name
	set description = $description
	set due_date = $due_date
	where id = $id;

update issue
	set is_completed = $is_completed
	where id = $id;

update vote
	set upvote = $vote
	where user_id = $user_id
	and comment_id = $comment_id;

insert into vote values ($user_id, $comment_id, $upvote);

insert into "comment" (content, issue_id, user_id) values ($content, $issue_id, $user_id);

-- channel
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, $content, $date, $channel_id, $user_id);
insert into channel values (DEFAULT, $name, $description, $project_id);

update channel
	set name = $name
	set description = $description
	where id = $id;

delete from channel 
	where id = $id;


-- profile
update user
	set email = $email,
	set username = $username,
	set name = $name,
	set phone_number = $phone_number,
	set country_id = $country_id,
	where id = $id;

update user
	set is_deleted = true
	where id = $id;

update user
  set password = $password
	where id = $id;

delete from user_tag
	where user_id = $user_id
	and tag_id = $tag_id;

insert into tag values (DEFAULT, $name, $color_id);
insert into user_tag values ($user_id, $tag_id);



---------------------- UPDATES ----------------------
-- edit project overview

--entrar da equipa
-- entrar na equipa com id = 1, o user com id = 1
insert into member_status(id, role, entrance_date, departure_date, user_id, project_id) 
values(DEFAULT, DEFAULT, CURRENT_DATE, NULL, 1, 1);

--sair da equipa
UPDATE member_status
SET departure_date = DEFAULT
FROM member_status, 
WHERE departure_date IS NULL and
member_status.user_id = 1 and
member_status.project_id = 1;

--promover para coordenador
UPDATE member_status
SET role = 'coordinator'
FROM member_status, 
WHERE departure_date IS NULL and
member_status.user_id = 1 and
member_status.project_id = 1;

--despromover de coordenador
UPDATE member_status
SET role = DEFAULT
FROM member_status, 
WHERE departure_date IS NULL and
member_status.user_id = 1 and
member_status.project_id = 1;

-- criar uma nova issue_list para project.id = 1
insert into issue_list(id, name, project_id) 
values(DEFAULT, 'sexy issuelist', 1);

-- adicionar issue da list
-- sendo o proprio user q assinalda e acrescentando numa issue
insert into issue(id, name, description, creation_date, due_date, is_complete, issue_list_id, author_id, complete_id) 
values(DEFAULT, 'sexy issue', 'lorem ipsum oyoy', DEFAULT, NULL, DEFAULT, 1 , 2, NULL);

-- remover issue da list
delete from issue where issue_id = 1;

-- add person to the issue

-- escolhendo o username adicionar esse user à issue
-- query::identify($username)->getIdentificador
insert into assigned_user(user_id, issue_id)
values(1, 3);

-- having the user to remove and the current issue selected
deleted from assigned_user where "user".id = 1 and issue.id = 1;

-- adicionar due UPDATE link
SET last_update = DEFAULT
WHERE
   last_update IS NULL;


-- onde esta current date e na verdade a date selecionada.
UPDATE issue
SET due_date = CURRENT_DATE
WHERE
   id = 1;

-- remover a due_date
UPDATE issue
SET due_date = NULL
WHERE
   id = 1;


-- criar tags
insert into tag(id, name, color_id)
values(DEFAULT, "name from form", 1);

-- eliminar tags
DELETE FROM tag
WHERE tag.id = 1;

