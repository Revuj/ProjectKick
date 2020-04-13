-- Tables
DROP TABLE IF EXISTS member_status;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS event_meeting;
DROP TABLE IF EXISTS event_personal;
DROP TABLE IF EXISTS notification_event;
DROP TABLE IF EXISTS "event";
DROP TABLE IF EXISTS vote;
DROP TABLE IF EXISTS report;
DROP TABLE IF EXISTS notification_kick;
DROP TABLE IF EXISTS notification_invite;
DROP TABLE IF EXISTS notification_assign;
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS issue_tag;
DROP TABLE IF EXISTS user_tag;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS color;
DROP TABLE IF EXISTS "comment";
DROP TABLE IF EXISTS channel;
DROP TABLE IF EXISTS assigned_user;
DROP TABLE IF EXISTS issue;
DROP TABLE IF EXISTS issue_list;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS "user";
DROP TABLE IF EXISTS country;

-- Types
DROP TYPE IF EXISTS country_name;
DROP TYPE IF EXISTS project_role;

CREATE TYPE country_name AS ENUM ('AF','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BA','BW','BR','IO','VG','BN','BG','BF','BI','KH','CM','CA','CV','KY','CF','TD','CL','CN','CX','CC','CO','KM','CK','CR','HR','CU','CW','CY','CZ','CD','DK','DJ','DM','DO','TL','EC','EG','SV','GQ','ER','EE','ET','FK','FO','FJ','FI','FR','PF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GU','GT','GG','GN','GW','GY','HT','HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','CI','JM','JP','JE','JO','KZ','KE','KI','XK','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU','MO','MK','MG','MW','MY','MV','ML','MT','MH','MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP','NL','AN','NC','NZ','NI','NE','NG','NU','KP','MP','NO','OM','PK','PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','CG','RE','RO','RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','KR','SS','ES','LK','SD','SR','SJ','SZ','SE','CH','SY','TW','TJ','TZ','TH','TG','TK','TO','TT','TN','TR','TM','TC','TV','VI','UG','UA','AE','GB','US','UY','UZ','VU','VA','VE','VN','WF','EH','YE','ZM','ZW');
CREATE TYPE project_role AS ENUM ('coordinator', 'developer');


CREATE TABLE country (
    id SERIAL PRIMARY KEY,
    name country_name NOT NULL
);

CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    email text UNIQUE CHECK (email LIKE '%@%.%_') NOT NULL,
    username text UNIQUE NOT NULL,
    password text NOT NULL CHECK (length(password) > 6),
    name text NOT NULL,
    phone_number text UNIQUE,
    photo_path text,
    is_deleted bool DEFAULT false NOT NULL,
    is_admin bool DEFAULT false NOT NULL,
    country_id integer NOT NULL REFERENCES country  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    is_banned bool DEFAULT false NOT NULL,
    search TSVECTOR
);

CREATE TABLE project (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    finish_date timestamp with time zone CHECK (finish_date > creation_date),
    author_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    search TSVECTOR
);

CREATE TABLE member_status (
    id SERIAL PRIMARY KEY,
    role project_role DEFAULT 'developer' NOT NULL,
    entrance_date timestamp with time zone DEFAULT now() NOT NULL,
    departure_date timestamp with time zone CHECK (departure_date > entrance_date),
    user_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    project_id integer NOT NULL REFERENCES project ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE issue_list (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    project_id integer NOT NULL REFERENCES project ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE issue (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    description text,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    due_date timestamp with time zone CHECK (due_date > creation_date),
    is_completed boolean DEFAULT false NOT NULL,
    closed_date timestamp with time zone CHECK (closed_date > creation_date),
    issue_list_id integer NOT NULL REFERENCES issue_list ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    author_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    complete_id integer REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    search TSVECTOR
);

CREATE TABLE "comment" (
    id SERIAL PRIMARY KEY,
    content text NOT NULL,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    issue_id integer NOT NULL REFERENCES issue ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    user_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE channel (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    description text,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    project_id integer NOT NULL REFERENCES project ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE message (
    id SERIAL PRIMARY KEY,
    content text NOT NULL,
    "date" timestamp with time zone DEFAULT now() NOT NULL,
    channel_id integer NOT NULL REFERENCES channel ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    user_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE "event" (
    id SERIAL PRIMARY KEY,
    title text NOT NULL,
    start_date timestamp with time zone NOT NULL
);

CREATE TABLE event_meeting (
    event_id integer  NOT NULL PRIMARY KEY REFERENCES "event"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    project_id integer NOT NULL REFERENCES project  ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE event_personal (
    event_id integer NOT NULL PRIMARY KEY REFERENCES "event"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    user_id integer  NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE notification (
    id SERIAL PRIMARY KEY,
    "date" timestamp with time zone DEFAULT now() NOT NULL,
    description text,
    receiver_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    sender_id integer NOT NULL REFERENCES "user"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE CHECK (sender_id <> receiver_id)
);

CREATE TABLE notification_kick (
    notification_id integer PRIMARY KEY REFERENCES notification  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    project_id integer NOT NULL REFERENCES project ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE notification_invite (
    notification_id integer PRIMARY KEY REFERENCES notification ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    project_id integer NOT NULL REFERENCES project ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE notification_assign (
    notification_id integer PRIMARY KEY REFERENCES notification ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    issue_id integer NOT NULL REFERENCES issue ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

CREATE TABLE notification_event (
    notification_id integer PRIMARY KEY REFERENCES notification ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    event_id integer NOT NULL REFERENCES "event" ON DELETE CASCADE
                                                     ON UPDATE CASCADE
);

create table color (
    id SERIAL PRIMARY KEY,
    rgb_code VARCHAR NOT NULL,
    CONSTRAINT CK_color CHECK (rgb_code ~ '^[a-fA-F0-9]{8}$')
);


CREATE TABLE vote (
    user_id integer NOT NULL REFERENCES "user"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    comment_id integer  NOT NULL REFERENCES comment ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    upvote boolean NOT NULL,

    PRIMARY KEY (
        user_id,
        comment_id
    )
);

CREATE TABLE report (
    id SERIAL PRIMARY KEY,
    description text NOT NULL,
    reports_id integer NOT NULL REFERENCES "user"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    reported_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE CHECK (reported_id <> reports_id)
);

CREATE TABLE tag (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    color_id integer NOT NULL REFERENCES color  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    search TSVECTOR
);

CREATE TABLE user_tag (
    user_id integer NOT NULL REFERENCES "user"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    tag_id integer  NOT NULL REFERENCES tag ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    PRIMARY KEY (
        user_id,
        tag_id
    )
);

CREATE TABLE issue_tag (
    issue_id integer NOT NULL REFERENCES issue  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    tag_id integer NOT NULL REFERENCES tag  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    PRIMARY KEY (
        issue_id,
        tag_id
    )
);

CREATE TABLE assigned_user (
    user_id integer  NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    issue_id integer  NOT NULL REFERENCES issue ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    PRIMARY KEY (
        user_id,
        issue_id
    )
);

CREATE INDEX project_fk ON project USING btree (author_id);

CREATE INDEX issue_list_fk ON issue_list USING btree (project_id);

CREATE INDEX issue_list_id_fk ON issue USING btree (issue_list_id);

CREATE INDEX author_fk ON issue USING btree (author_id);

CREATE INDEX member_status_fk ON member_status USING btree (user_id, project_id);

CREATE INDEX departure_date_not_null ON member_status USING btree (departure_date)
WHERE departure_date is NULL;

CREATE INDEX comment_fk ON “comment” USING btree (issue_id, user_id);

CREATE INDEX comment_creation_fk ON "comment" USING btree (creation_date);

CREATE INDEX channel_fk ON channel USING btree (project_id);

CREATE INDEX channel_creation_fk ON channel USING btree (creation_date);

CREATE INDEX message_fk ON message USING btree (channel_id, user_id);

CREATE INDEX message_creation_fk ON message USING btree ("date");

CREATE INDEX event_date_fk ON "event" USING btree (start_date);

CREATE INDEX event_meeting_fk ON event_meeting USING btree (project_id);

CREATE INDEX event_personal_fk ON event_personal USING btree (user_id);

CREATE INDEX users_search_index ON “user” USING gin(search);

CREATE INDEX project_search_index ON project USING gin(search);

CREATE INDEX issues_search_index ON issue USING gist(search);

CREATE FUNCTION vote_ownComment()
RETURNS TRIGGER AS
$BODY$

BEGIN
     IF NEW.user_id = (SELECT "user".ID FROM "comment" INNER JOIN "user" ON "comment".user_id = "user".ID
        WHERE "comment".ID = NEW.comment_id) THEN
        RAISE EXCEPTION "You cannot vote your own comment"
    END IF;
    RETURN NEW;
END

$BODY$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION add_project_creator() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO member_status(id, role, entrance_date, departure_date, user_id, project_id)
    VALUES(DEFAULT, 'coordinator', CURRENT_DATE, NULL, New.author_id, New.id);
    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION only_coordinator()
RETURNS TRIGGER AS
$BODY$
BEGIN
    IF (SELECT COUNT(*) FROM(SELECT user_id FROM member_status WHERE project_id = NEW.project_id AND role = 'coordinator') AS id) = 0 THEN
        RAISE EXCEPTION 'Cannot remove only coordinator';
    END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION user_remove_assigns()
RETURNS TRIGGER AS
$BODY$
BEGIN
IF NEW.departure_date != NULL THEN
    DELETE FROM assigned_user
    WHERE user_id = NEW.user_id
    AND issue_id IN (
    SELECT issue_id FROM issue, issue_list WHERE issue_list_id = issue_list.id And issue_list.project_id = NEW.project_id
    );
END IF;
RETURN NEW;
END;
$BODY$
language plpgsql;

CREATE OR REPLACE FUNCTION not_admin()
RETURNS TRIGGER AS
$BODY$
BEGIN
IF NEW.user_id IN (
    SELECT id FROM "user" WHERE is_admin = true) THEN
    RAISE EXCEPTION 'Admins cannot participate in projects';
END IF;
RETURN NEW;
END;
$BODY$
language plpgsql;

CREATE OR REPLACE FUNCTION not_admin_project()
RETURNS TRIGGER AS
$BODY$
BEGIN
IF NEW.author_id IN (
    SELECT id FROM "user" WHERE is_admin = true) THEN
    RAISE EXCEPTION 'Admins cannot create projects';
END IF;
RETURN NEW;
END;
$BODY$
language plpgsql;

CREATE OR REPLACE FUNCTION event_start_date()
RETURNS TRIGGER AS
$BODY$
BEGIN
IF NEW.start_date < Now() THEN
    RAISE EXCEPTION 'Event start date cannot be in the past';
END IF;
RETURN NEW;
END;
$BODY$
language plpgsql;

CREATE FUNCTION time_comment()
RETURNS TRIGGER AS
$BODY$
BEGIN
IF NEW.creation_date > Now() THEN
    RAISE EXCEPTION 'Comment creation time is greater than current time';
END IF;
RETURN NEW;
END;
$BODY$
language 'plpgsql';

CREATE FUNCTION time_message()
RETURNS TRIGGER AS
$BODY$
BEGIN
IF NEW."date" > Now() THEN
    RAISE EXCEPTION 'Message date is greater than current time';
END IF;
RETURN NEW;
END;
$BODY$
language 'plpgsql';

CREATE OR REPLACE FUNCTION user_search_update() RETURNS TRIGGER AS $$
BEGIN

    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (OLD.name <> NEW.name OR OLD.email <> NEW.email OR OLD.username <> NEW.username)) THEN
        UPDATE "user"
        SET search = (SELECT setweight(to_tsvector(username), 'A') || setweight(to_tsvector(email), 'B') || setweight(to_tsvector(name), 'C')
        FROM "user" WHERE id = NEW.id)
        WHERE id = NEW.id;
    END IF;

  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION project_search_update() RETURNS TRIGGER AS $$
    BEGIN
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (OLD.name <> NEW.name)) THEN
        UPDATE project
        SET search = to_tsvector(name || ' ');
    END IF;
    RETURN NEW;
    END
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS vote_ownComment ON vote;
DROP TRIGGER IF EXISTS add_project_creator ON project;
DROP TRIGGER IF EXISTS only_coordinator ON member_status;
DROP TRIGGER IF EXISTS user_remove_assigns ON member_status;
DROP TRIGGER IF EXISTS not_admin ON member_status;
DROP TRIGGER IF EXISTS not_admin_project ON project;
DROP TRIGGER IF EXISTS event_start_date ON "event";
DROP TRIGGER IF EXISTS time_comment ON "comment";
DROP TRIGGER IF EXISTS time_message ON message;
DROP TRIGGER IF EXISTS insert_user_search ON "user";
DROP TRIGGER IF EXISTS update_user_search ON "user";
DROP TRIGGER IF EXISTS insert_project_search ON project;
DROP TRIGGER IF EXISTS update_project_search ON project;

CREATE TRIGGER vote_ownComment
    BEFORE INSERT OR UPDATE OF user_id, comment_id ON vote
    FOR EACH ROW
        EXECUTE PROCEDURE vote_ownComment();

CREATE TRIGGER add_project_creator
    AFTER INSERT ON project
    FOR EACH ROW
    EXECUTE PROCEDURE add_project_creator();

CREATE TRIGGER only_coordinator
    BEFORE UPDATE OF departure_date ON member_status
    FOR EACH ROW
    EXECUTE PROCEDURE only_coordinator();

CREATE TRIGGER user_remove_assigns
    AFTER UPDATE OF departure_date ON member_status
    FOR EACH ROW
    EXECUTE PROCEDURE user_remove_assigns();

CREATE TRIGGER not_admin
    BEFORE INSERT ON member_status
    FOR EACH ROW
    EXECUTE PROCEDURE not_admin();

CREATE TRIGGER not_admin_project
    BEFORE INSERT ON project
    FOR EACH ROW
    EXECUTE PROCEDURE not_admin_project();

CREATE TRIGGER event_start_date
    BEFORE INSERT OR UPDATE ON "event"
    FOR EACH ROW
    EXECUTE PROCEDURE event_start_date();

CREATE TRIGGER time_comment
    BEFORE INSERT OR UPDATE ON "comment"
    FOR EACH ROW
    EXECUTE PROCEDURE time_comment();

CREATE TRIGGER time_message
    BEFORE INSERT OR UPDATE ON message
    FOR EACH ROW
    EXECUTE PROCEDURE time_message();

CREATE TRIGGER insert_user_search
    AFTER INSERT ON "user"
    FOR EACH ROW
    EXECUTE PROCEDURE user_search_update();

CREATE TRIGGER update_user_search
    AFTER UPDATE ON "user"
    FOR EACH ROW
    EXECUTE PROCEDURE user_search_update();

CREATE TRIGGER insert_project_search
    AFTER INSERT ON project
    FOR EACH ROW
    EXECUTE PROCEDURE project_search_update();

CREATE TRIGGER update_project_search
    AFTER UPDATE ON project
    FOR EACH ROW
    EXECUTE PROCEDURE project_search_update();