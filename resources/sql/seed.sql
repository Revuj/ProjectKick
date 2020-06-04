-- Tables
DROP VIEW IF EXISTS issue_search_fields;
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
DROP TABLE IF EXISTS password_resets;


-- Types
DROP TYPE IF EXISTS country_name;
DROP TYPE IF EXISTS project_role;

CREATE TYPE country_name AS ENUM ('AF','AL','DZ','AS','AD','AO','AI','AQ','AG','AR','AM','AW','AU','AT','AZ','BS','BH','BD','BB','BY','BE','BZ','BJ','BM','BT','BO','BA','BW','BR','IO','VG','BN','BG','BF','BI','KH','CM','CA','CV','KY','CF','TD','CL','CN','CX','CC','CO','KM','CK','CR','HR','CU','CW','CY','CZ','CD','DK','DJ','DM','DO','TL','EC','EG','SV','GQ','ER','EE','ET','FK','FO','FJ','FI','FR','PF','GA','GM','GE','DE','GH','GI','GR','GL','GD','GU','GT','GG','GN','GW','GY','HT','HN','HK','HU','IS','IN','ID','IR','IQ','IE','IM','IL','IT','CI','JM','JP','JE','JO','KZ','KE','KI','XK','KW','KG','LA','LV','LB','LS','LR','LY','LI','LT','LU','MO','MK','MG','MW','MY','MV','ML','MT','MH','MR','MU','YT','MX','FM','MD','MC','MN','ME','MS','MA','MZ','MM','NA','NR','NP','NL','AN','NC','NZ','NI','NE','NG','NU','KP','MP','NO','OM','PK','PW','PS','PA','PG','PY','PE','PH','PN','PL','PT','PR','QA','CG','RE','RO','RU','RW','BL','SH','KN','LC','MF','PM','VC','WS','SM','ST','SA','SN','RS','SC','SL','SG','SX','SK','SI','SB','SO','ZA','KR','SS','ES','LK','SD','SR','SJ','SZ','SE','CH','SY','TW','TJ','TZ','TH','TG','TK','TO','TT','TN','TR','TM','TC','TV','VI','UG','UA','AE','GB','US','UY','UZ','VU','VA','VE','VN','WF','EH','YE','ZM','ZW');
CREATE TYPE project_role AS ENUM ('coordinator', 'developer');

CREATE TABLE password_resets(
    id SERIAL PRIMARY KEY,
    email text UNIQUE CHECK (email LIKE '%@%.%_') NOT NULL,
    token text,
    created_at timestamp
);

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
    photo_path text DEFAULT 'profile',
    description text DEFAULT null,
    deleted_at timestamp DEFAULT null,
    is_admin bool DEFAULT false NOT NULL,
    country_id integer REFERENCES country  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    is_banned bool DEFAULT false NOT NULL,
    remember_token VARCHAR, -- Necessary for Laravel session remembering
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
    start_date date DEFAULT now() NOT NULL
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
    "date" timestamp with time zone DEFAULT CURRENT_DATE NOT NULL,
    receiver_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    sender_id integer NOT NULL REFERENCES "user"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE
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

CREATE TABLE vote (
    user_id integer NOT NULL REFERENCES "user"  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    comment_id integer  NOT NULL REFERENCES comment ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    upvote smallint NOT NULL,

    PRIMARY KEY (
        user_id,
        comment_id
    )
);

CREATE INDEX project_fk ON project USING btree (author_id);

CREATE INDEX issue_list_fk ON issue_list USING btree (project_id);

CREATE INDEX issue_list_id_fk ON issue USING btree (issue_list_id);

CREATE INDEX author_fk ON issue USING btree (author_id);

CREATE INDEX member_status_fk ON member_status USING btree (user_id, project_id);

CREATE INDEX departure_date_not_null ON member_status USING btree (departure_date)
WHERE departure_date is NULL;

CREATE INDEX comment_fk ON "comment" USING btree (issue_id, user_id);

CREATE INDEX comment_creation_fk ON "comment" USING btree (creation_date);

CREATE INDEX channel_fk ON channel USING btree (project_id);

CREATE INDEX channel_creation_fk ON channel USING btree (creation_date);

CREATE INDEX message_fk ON message USING btree (channel_id, user_id);

CREATE INDEX message_creation_fk ON message USING btree ("date");

CREATE INDEX users_search_index ON "user" USING gin(search);

CREATE INDEX project_search_index ON project USING gin(search);

CREATE INDEX issues_search_index ON issue USING gist(search);

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
IF NEW.start_date < CURRENT_DATE THEN
    RAISE EXCEPTION 'Event start date cannot be in the past';
END IF;
RETURN NEW;
END;
$BODY$
language plpgsql;

CREATE OR REPLACE FUNCTION time_comment()
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

CREATE OR REPLACE FUNCTION time_message()
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

CREATE VIEW issue_search_fields
AS
SELECT issue.id, issue.author_id AS author_id, setweight(to_tsvector(coalesce(issue.name,'')), 'A') AS name, 
setweight(to_tsvector(coalesce(issue.description, '')), 'C') AS description, 
setweight(to_tsvector(coalesce(STRING_AGG (tag.name, ' '), '')), 'B') AS tags
from issue
LEFT OUTER JOIN issue_tag
ON issue.id = issue_tag.issue_id
LEFT OUTER JOIN tag
ON issue_tag.tag_id = tag.id
group by issue.id
order by issue.id;


CREATE OR REPLACE FUNCTION issue_search_update() RETURNS TRIGGER AS $$
BEGIN

    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (OLD.name <> NEW.name OR OLD.description <> NEW.description )) THEN
        UPDATE issue
        SET search = (SELECT result_search FROM 
            (SELECT name || description || tags
            AS result_search 
            FROM issue_search_fields WHERE id = NEW.id)
        AS subquery)
        WHERE id = NEW.id;
    END IF;

  RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

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
DROP TRIGGER IF EXISTS insert_issue_search ON issue;
DROP TRIGGER IF EXISTS update_issue_search ON issue;


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

CREATE TRIGGER insert_issue_search 
    AFTER INSERT ON issue
    FOR EACH ROW 
    EXECUTE PROCEDURE issue_search_update();

CREATE TRIGGER update_issue_search 
    AFTER UPDATE ON issue
    FOR EACH ROW 
    EXECUTE PROCEDURE issue_search_update();

insert into country (id, name) values (DEFAULT, 'AF');
insert into country (id, name) values (DEFAULT, 'AL');
insert into country (id, name) values (DEFAULT, 'DZ');
insert into country (id, name) values (DEFAULT, 'AS');
insert into country (id, name) values (DEFAULT, 'AD');
insert into country (id, name) values (DEFAULT, 'AO');
insert into country (id, name) values (DEFAULT, 'AI');
insert into country (id, name) values (DEFAULT, 'AQ');
insert into country (id, name) values (DEFAULT, 'AG');
insert into country (id, name) values (DEFAULT, 'AR');
insert into country (id, name) values (DEFAULT, 'AM');
insert into country (id, name) values (DEFAULT, 'AW');
insert into country (id, name) values (DEFAULT, 'AU');
insert into country (id, name) values (DEFAULT, 'AT');
insert into country (id, name) values (DEFAULT, 'AZ');
insert into country (id, name) values (DEFAULT, 'BS');
insert into country (id, name) values (DEFAULT, 'BH');
insert into country (id, name) values (DEFAULT, 'BD');
insert into country (id, name) values (DEFAULT, 'BB');
insert into country (id, name) values (DEFAULT, 'BY');
insert into country (id, name) values (DEFAULT, 'BE');
insert into country (id, name) values (DEFAULT, 'BZ');
insert into country (id, name) values (DEFAULT, 'BJ');
insert into country (id, name) values (DEFAULT, 'BM');
insert into country (id, name) values (DEFAULT, 'BT');
insert into country (id, name) values (DEFAULT, 'BO');
insert into country (id, name) values (DEFAULT, 'BA');
insert into country (id, name) values (DEFAULT, 'BW');
insert into country (id, name) values (DEFAULT, 'BR');
insert into country (id, name) values (DEFAULT, 'IO');
insert into country (id, name) values (DEFAULT, 'VG');
insert into country (id, name) values (DEFAULT, 'BN');
insert into country (id, name) values (DEFAULT, 'BG');
insert into country (id, name) values (DEFAULT, 'BF');
insert into country (id, name) values (DEFAULT, 'BI');
insert into country (id, name) values (DEFAULT, 'KH');
insert into country (id, name) values (DEFAULT, 'CM');
insert into country (id, name) values (DEFAULT, 'CA');
insert into country (id, name) values (DEFAULT, 'CV');
insert into country (id, name) values (DEFAULT, 'KY');
insert into country (id, name) values (DEFAULT, 'CF');
insert into country (id, name) values (DEFAULT, 'TD');
insert into country (id, name) values (DEFAULT, 'CL');
insert into country (id, name) values (DEFAULT, 'CN');
insert into country (id, name) values (DEFAULT, 'CX');
insert into country (id, name) values (DEFAULT, 'CC');
insert into country (id, name) values (DEFAULT, 'CO');
insert into country (id, name) values (DEFAULT, 'KM');
insert into country (id, name) values (DEFAULT, 'CK');
insert into country (id, name) values (DEFAULT, 'CR');
insert into country (id, name) values (DEFAULT, 'HR');
insert into country (id, name) values (DEFAULT, 'CU');
insert into country (id, name) values (DEFAULT, 'CW');
insert into country (id, name) values (DEFAULT, 'CY');
insert into country (id, name) values (DEFAULT, 'CZ');
insert into country (id, name) values (DEFAULT, 'CD');
insert into country (id, name) values (DEFAULT, 'DK');
insert into country (id, name) values (DEFAULT, 'DJ');
insert into country (id, name) values (DEFAULT, 'DM');
insert into country (id, name) values (DEFAULT, 'DO');
insert into country (id, name) values (DEFAULT, 'TL');
insert into country (id, name) values (DEFAULT, 'EC');
insert into country (id, name) values (DEFAULT, 'EG');
insert into country (id, name) values (DEFAULT, 'SV');
insert into country (id, name) values (DEFAULT, 'GQ');
insert into country (id, name) values (DEFAULT, 'ER');
insert into country (id, name) values (DEFAULT, 'EE');
insert into country (id, name) values (DEFAULT, 'ET');
insert into country (id, name) values (DEFAULT, 'FK');
insert into country (id, name) values (DEFAULT, 'FO');
insert into country (id, name) values (DEFAULT, 'FJ');
insert into country (id, name) values (DEFAULT, 'FI');
insert into country (id, name) values (DEFAULT, 'FR');
insert into country (id, name) values (DEFAULT, 'PF');
insert into country (id, name) values (DEFAULT, 'GA');
insert into country (id, name) values (DEFAULT, 'GM');
insert into country (id, name) values (DEFAULT, 'GE');
insert into country (id, name) values (DEFAULT, 'DE');
insert into country (id, name) values (DEFAULT, 'GH');
insert into country (id, name) values (DEFAULT, 'GI');
insert into country (id, name) values (DEFAULT, 'GR');
insert into country (id, name) values (DEFAULT, 'GL');
insert into country (id, name) values (DEFAULT, 'GD');
insert into country (id, name) values (DEFAULT, 'GU');
insert into country (id, name) values (DEFAULT, 'GT');
insert into country (id, name) values (DEFAULT, 'GG');
insert into country (id, name) values (DEFAULT, 'GN');
insert into country (id, name) values (DEFAULT, 'GW');
insert into country (id, name) values (DEFAULT, 'GY');
insert into country (id, name) values (DEFAULT, 'HT');
insert into country (id, name) values (DEFAULT, 'HN');
insert into country (id, name) values (DEFAULT, 'HK');
insert into country (id, name) values (DEFAULT, 'HU');
insert into country (id, name) values (DEFAULT, 'IS');
insert into country (id, name) values (DEFAULT, 'IN');
insert into country (id, name) values (DEFAULT, 'ID');
insert into country (id, name) values (DEFAULT, 'IR');
insert into country (id, name) values (DEFAULT, 'IQ');
insert into country (id, name) values (DEFAULT, 'IE');
insert into country (id, name) values (DEFAULT, 'IM');
insert into country (id, name) values (DEFAULT, 'IL');
insert into country (id, name) values (DEFAULT, 'IT');
insert into country (id, name) values (DEFAULT, 'CI');
insert into country (id, name) values (DEFAULT, 'JM');
insert into country (id, name) values (DEFAULT, 'JP');
insert into country (id, name) values (DEFAULT, 'JE');
insert into country (id, name) values (DEFAULT, 'JO');
insert into country (id, name) values (DEFAULT, 'KZ');
insert into country (id, name) values (DEFAULT, 'KE');
insert into country (id, name) values (DEFAULT, 'KI');
insert into country (id, name) values (DEFAULT, 'XK');
insert into country (id, name) values (DEFAULT, 'KW');
insert into country (id, name) values (DEFAULT, 'KG');
insert into country (id, name) values (DEFAULT, 'LA');
insert into country (id, name) values (DEFAULT, 'LV');
insert into country (id, name) values (DEFAULT, 'LB');
insert into country (id, name) values (DEFAULT, 'LS');
insert into country (id, name) values (DEFAULT, 'LR');
insert into country (id, name) values (DEFAULT, 'LY');
insert into country (id, name) values (DEFAULT, 'LI');
insert into country (id, name) values (DEFAULT, 'LT');
insert into country (id, name) values (DEFAULT, 'LU');
insert into country (id, name) values (DEFAULT, 'MO');
insert into country (id, name) values (DEFAULT, 'MK');
insert into country (id, name) values (DEFAULT, 'MG');
insert into country (id, name) values (DEFAULT, 'MW');
insert into country (id, name) values (DEFAULT, 'MY');
insert into country (id, name) values (DEFAULT, 'MV');
insert into country (id, name) values (DEFAULT, 'ML');
insert into country (id, name) values (DEFAULT, 'MT');
insert into country (id, name) values (DEFAULT, 'MH');
insert into country (id, name) values (DEFAULT, 'MR');
insert into country (id, name) values (DEFAULT, 'MU');
insert into country (id, name) values (DEFAULT, 'YT');
insert into country (id, name) values (DEFAULT, 'MX');
insert into country (id, name) values (DEFAULT, 'FM');
insert into country (id, name) values (DEFAULT, 'MD');
insert into country (id, name) values (DEFAULT, 'MC');
insert into country (id, name) values (DEFAULT, 'MN');
insert into country (id, name) values (DEFAULT, 'ME');
insert into country (id, name) values (DEFAULT, 'MS');
insert into country (id, name) values (DEFAULT, 'MA');
insert into country (id, name) values (DEFAULT, 'MZ');
insert into country (id, name) values (DEFAULT, 'MM');
insert into country (id, name) values (DEFAULT, 'NA');
insert into country (id, name) values (DEFAULT, 'NR');
insert into country (id, name) values (DEFAULT, 'NP');
insert into country (id, name) values (DEFAULT, 'NL');
insert into country (id, name) values (DEFAULT, 'AN');
insert into country (id, name) values (DEFAULT, 'NC');
insert into country (id, name) values (DEFAULT, 'NZ');
insert into country (id, name) values (DEFAULT, 'NI');
insert into country (id, name) values (DEFAULT, 'NE');
insert into country (id, name) values (DEFAULT, 'NG');
insert into country (id, name) values (DEFAULT, 'NU');
insert into country (id, name) values (DEFAULT, 'KP');
insert into country (id, name) values (DEFAULT, 'MP');
insert into country (id, name) values (DEFAULT, 'NO');
insert into country (id, name) values (DEFAULT, 'OM');
insert into country (id, name) values (DEFAULT, 'PK');
insert into country (id, name) values (DEFAULT, 'PW');
insert into country (id, name) values (DEFAULT, 'PS');
insert into country (id, name) values (DEFAULT, 'PA');
insert into country (id, name) values (DEFAULT, 'PG');
insert into country (id, name) values (DEFAULT, 'PY');
insert into country (id, name) values (DEFAULT, 'PE');
insert into country (id, name) values (DEFAULT, 'PH');
insert into country (id, name) values (DEFAULT, 'PN');
insert into country (id, name) values (DEFAULT, 'PL');
insert into country (id, name) values (DEFAULT, 'PT');
insert into country (id, name) values (DEFAULT, 'PR');
insert into country (id, name) values (DEFAULT, 'QA');
insert into country (id, name) values (DEFAULT, 'CG');
insert into country (id, name) values (DEFAULT, 'RE');
insert into country (id, name) values (DEFAULT, 'RO');
insert into country (id, name) values (DEFAULT, 'RU');
insert into country (id, name) values (DEFAULT, 'RW');
insert into country (id, name) values (DEFAULT, 'BL');
insert into country (id, name) values (DEFAULT, 'SH');
insert into country (id, name) values (DEFAULT, 'KN');
insert into country (id, name) values (DEFAULT, 'LC');
insert into country (id, name) values (DEFAULT, 'MF');
insert into country (id, name) values (DEFAULT, 'PM');
insert into country (id, name) values (DEFAULT, 'VC');
insert into country (id, name) values (DEFAULT, 'WS');
insert into country (id, name) values (DEFAULT, 'SM');
insert into country (id, name) values (DEFAULT, 'ST');
insert into country (id, name) values (DEFAULT, 'SA');
insert into country (id, name) values (DEFAULT, 'SN');
insert into country (id, name) values (DEFAULT, 'RS');
insert into country (id, name) values (DEFAULT, 'SC');
insert into country (id, name) values (DEFAULT, 'SL');
insert into country (id, name) values (DEFAULT, 'SG');
insert into country (id, name) values (DEFAULT, 'SX');
insert into country (id, name) values (DEFAULT, 'SK');
insert into country (id, name) values (DEFAULT, 'SI');
insert into country (id, name) values (DEFAULT, 'SB');
insert into country (id, name) values (DEFAULT, 'SO');
insert into country (id, name) values (DEFAULT, 'ZA');
insert into country (id, name) values (DEFAULT, 'KR');
insert into country (id, name) values (DEFAULT, 'SS');
insert into country (id, name) values (DEFAULT, 'ES');
insert into country (id, name) values (DEFAULT, 'LK');
insert into country (id, name) values (DEFAULT, 'SD');
insert into country (id, name) values (DEFAULT, 'SR');
insert into country (id, name) values (DEFAULT, 'SJ');
insert into country (id, name) values (DEFAULT, 'SZ');
insert into country (id, name) values (DEFAULT, 'SE');
insert into country (id, name) values (DEFAULT, 'CH');
insert into country (id, name) values (DEFAULT, 'SY');
insert into country (id, name) values (DEFAULT, 'TW');
insert into country (id, name) values (DEFAULT, 'TJ');
insert into country (id, name) values (DEFAULT, 'TZ');
insert into country (id, name) values (DEFAULT, 'TH');
insert into country (id, name) values (DEFAULT, 'TG');
insert into country (id, name) values (DEFAULT, 'TK');
insert into country (id, name) values (DEFAULT, 'TO');
insert into country (id, name) values (DEFAULT, 'TT');
insert into country (id, name) values (DEFAULT, 'TN');
insert into country (id, name) values (DEFAULT, 'TR');
insert into country (id, name) values (DEFAULT, 'TM');
insert into country (id, name) values (DEFAULT, 'TC');
insert into country (id, name) values (DEFAULT, 'TV');
insert into country (id, name) values (DEFAULT, 'VI');
insert into country (id, name) values (DEFAULT, 'UG');
insert into country (id, name) values (DEFAULT, 'UA');
insert into country (id, name) values (DEFAULT, 'AE');
insert into country (id, name) values (DEFAULT, 'GB');
insert into country (id, name) values (DEFAULT, 'US');
insert into country (id, name) values (DEFAULT, 'UY');
insert into country (id, name) values (DEFAULT, 'UZ');
insert into country (id, name) values (DEFAULT, 'VU');
insert into country (id, name) values (DEFAULT, 'VA');
insert into country (id, name) values (DEFAULT, 'VE');
insert into country (id, name) values (DEFAULT, 'VN');
insert into country (id, name) values (DEFAULT, 'WF');
insert into country (id, name) values (DEFAULT, 'EH');
insert into country (id, name) values (DEFAULT, 'YE');
insert into country (id, name) values (DEFAULT, 'ZM');
insert into country (id, name) values (DEFAULT, 'ZW');

insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'cjanacek0@bingcjanacek0@.com', 'admin', '$2y$10$HfzIhGCCaxqyaIdGgjARSuOKAcm1Uy82YfLuNaajn6JrjLWy9Sj/W', 'admin', '920-704-7512', DEFAULT, true, 75, '2018-12-01 02:22:06', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'bajean1@mozilla.org', 'bajean1', '$2y$10$HfzIhGCCaxqyaIdGgjARSuOKAcm1Uy82YfLuNaajn6JrjLWy9Sj/W', 'Brade Ajean', '734-576-9520', DEFAULT, false, 60, '2019-02-02 17:14:42', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'ybray2@earthlink.net', 'ybray2', '2XuE25Gafxa', 'Yolanda Bray', '638-996-8661', DEFAULT, false, 40, '2018-11-12 21:21:20', true);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'bharvison3@uiuc.edu', 'bharvison3', 'pGp4RW0', 'Britt Harvison', '180-499-5004', DEFAULT, false, 93, '2019-04-09 13:32:41', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'cbruniges4@jiathis.com', 'cbruniges4', 'ZIH7E6SEREvJ', 'Calla Bruniges', '464-114-7385', DEFAULT, false, 222, '2018-09-16 16:19:50', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'mmathieu5@nifty.com', 'mmathieu5', 'UQ70rvEmHi', 'Modestine Mathieu', '384-960-7318', DEFAULT, false, 34, '2019-11-29 16:08:30', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'fdanilchev6@pagesperso-orange.fr', 'fdanilchev6', 'JLBxq7z7d', 'Fabien Danilchev', '656-548-8908', DEFAULT, false, 77, '2019-06-18 18:43:40', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'vpeatt7@odnoklassniki.ru', 'vpeatt7', 'uYn7Xjy', 'Vanda Peatt', '307-130-5905', DEFAULT, false, 118, '2019-11-08 12:28:21', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'ckeal8@surveymonkey.com', 'ckeal8', 'AXuPR6c', 'Carlyn Keal', '445-403-0853', DEFAULT, false, 38, '2018-09-13 21:19:00', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'bhurworth9@phoca.cz', 'bhurworth9', 's33B38gqf', 'Barron Hurworth', '796-976-1153', DEFAULT, false, 127, '2018-05-13 01:58:43', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'podroughta@github.io', 'podroughta', 'gqcwIDruUWy', 'Paulie O''Drought', '159-608-4307', DEFAULT, false, 161, '2018-05-19 18:28:23', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'bbrunnb@smugmug.com', 'bbrunnb', '9jBc91cEk', 'Bernardo Brunn', '164-381-6602', DEFAULT, false, 15, '2019-10-14 10:02:09', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'aduckerinc@nifty.com', 'aduckerinc', 'BC4mZVeDg', 'Allison Duckerin', '879-655-7575', DEFAULT, false, 127, '2018-07-09 23:39:30', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'cschroterd@whitehouse.gov', 'cschroterd', 'y0O5ryj', 'Corri Schroter', '680-736-9944', DEFAULT, false, 153, '2018-11-09 00:24:23', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'mstillmanne@youtu.be', 'mstillmanne', 'ZxGgRsn4CUVG', 'Margaretta Stillmann', '133-517-6943', DEFAULT, false, 89, '2018-06-28 03:06:49', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'isurfleetf@amazon.com', 'isurfleetf', 'r8mSdeOV', 'Isabelita Surfleet', '474-473-9720', DEFAULT, false, 143, '2018-10-26 08:54:53', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'fmacveyg@examiner.com', 'fmacveyg', 'WuthY8Syn', 'Freddie Macvey', '810-410-7324', DEFAULT, false, 35, '2019-10-31 08:50:19', true);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'dbartoszinskih@ocn.ne.jp', 'dbartoszinskih', 'w8Bdwdhuy', 'Dalli Bartoszinski', '959-721-7690', DEFAULT, false, 26, '2019-05-12 09:37:03', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'kmenicombi@mashable.com', 'kmenicombi', 'LdnfWhTiK', 'Kare Menicomb', '447-677-3090', DEFAULT, false, 31, '2018-08-02 01:56:11', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'lcumberlandj@list-manage.com', 'lcumberlandj', '6E6QiHr', 'Leeland Cumberland', '319-206-5908', DEFAULT, false, 172, '2020-01-01 23:06:20', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'sravilusk@oracle.com', 'sravilusk', 'RKGbTPXZrA4', 'Storm Ravilus', '220-721-2455', DEFAULT, false, 167, '2018-08-08 15:34:44', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'qlawlandl@disqus.com', 'qlawlandl', 'gRZv8Vdwr', 'Quintilla Lawland', '744-648-8494', DEFAULT, false, 119, '2020-01-12 17:22:52', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'czuppam@jigsy.com', 'czuppam', 'k2ss7Z5h', 'Cornelia Zuppa', '934-357-5573', DEFAULT, false, 38, '2019-11-30 19:40:13', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'kocannovanen@nasa.gov', 'kocannovanen', 'mXQuFNgytY', 'Karita O''Cannovane', '238-503-0644', DEFAULT, false, 174, '2018-05-22 20:35:06', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'blabbeto@nps.gov', 'blabbeto', 'yFszcJ7j', 'Ban Labbet', '403-867-6918', DEFAULT, false, 195, '2019-08-25 04:46:52', true);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'rburdp@dailymail.co.uk', 'rburdp', 'q3S8apqjdIbP', 'Royce Burd', '317-585-1242', DEFAULT, false, 168, '2018-09-11 11:36:25', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'hizkoviciq@hatena.ne.jp', 'hizkoviciq', 'DGTFxMjls3RM', 'Herve Izkovici', '516-346-5758', DEFAULT, false, 103, '2018-08-04 20:18:21', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'vbrambellr@lulu.com', 'vbrambellr', '1hJOs5FT', 'Vinita Brambell', '970-150-6223', DEFAULT, false, 22, '2018-07-03 21:34:44', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'kbrentnalls@t-online.de', 'kbrentnalls', 'uUVRoDsV', 'Kelli Brentnall', '700-992-1174', DEFAULT, false, 116, '2019-03-20 05:19:49', false);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'lchmielt@webmd.com', 'lchmielt', 'qNLdSGv', 'Lucille Chmiel', '436-184-2954', DEFAULT, false, 4, '2019-10-13 09:24:01', true);
insert into "user" (id, email, username, password, name, phone_number, photo_path, is_admin, country_id, creation_date, is_banned) values (DEFAULT, 'abelha@gmail.com', 'abelha', '$2y$10$HfzIhGCCaxqyaIdGgjARSuOKAcm1Uy82YfLuNaajn6JrjLWy9Sj/W'
, 'Lucille Chmiel', '436-184', DEFAULT, false, 4, '2019-10-13 09:24:01', false);

insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Zaam-Dox', 'Fusce consequat. Nulla nisl. Nunc nisl.', '2019-01-08 06:33:51', '2019-06-02 17:39:06', 3);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Voyatouch', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2022-09-26 23:24:23', null, 11);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Fintone', 'In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2022-10-07 15:30:19', '2023-11-23 04:19:41', 14);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Mat Lam Tam', '', '2022-07-15 19:38:26', null, 13);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Stronghold', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2022-06-09 14:50:13', null, 29);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Greenlam', '', '2021-12-23 11:29:24', null, 14);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Stringtough', '', '2022-09-13 23:39:09', null, 11);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Treeflex', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', '2021-04-17 17:16:04', '2024-06-23 04:06:38', 15);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Home Ing', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', '2022-05-14 04:31:31', '2023-03-29 14:57:14', 6);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Konklux', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '2021-04-13 02:32:27', '2023-12-25 03:34:24', 5);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Trippledex', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '2022-07-04 12:01:08', null, 14);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Cookley', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', '2023-02-26 00:34:34', '2023-08-20 12:35:09', 30);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Bigtax', '', '2021-08-16 01:43:15', null, 3);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Lotlux', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2022-10-20 15:07:03', '2024-05-11 18:49:41', 16);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Gembucket', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2021-06-08 10:26:46', '2023-05-25 08:27:46', 23);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Biodex', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', '2021-09-27 14:49:52', '2024-01-10 00:25:29', 10);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Prodder', '', '2022-01-13 11:57:11', null, 4);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Stringtough', '', '2023-02-19 11:44:23', '2023-12-09 19:53:12', 26);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Zoolab', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2021-11-02 10:40:52', null, 12);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Y-Solowarm', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '2022-02-04 23:38:30', '2025-02-15 20:58:34', 14);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Bitchip', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2021-08-21 19:34:28', null, 6);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Gembucket', '', '2021-06-01 10:57:07', '2025-02-13 14:04:46', 10);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Bamity', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '2021-05-29 18:51:22', '2023-09-29 17:08:10', 29);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Fixflex', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2022-01-14 08:28:30', null, 13);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Tresom', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', '2022-08-16 19:02:43', '2024-05-10 03:20:08', 11);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Veribet', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2022-07-29 10:48:46', '2023-05-09 20:21:43', 19);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Opela', '', '2022-01-09 03:49:02', null, 5);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Konklux', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', '2021-12-29 18:51:41', null, 10);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'It', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '2021-06-18 21:14:40', null, 26);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Mat Lam Tam', 'In congue. Etiam justo. Etiam pretium iaculis justo.', '2022-05-06 20:12:09', null, 2);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Tres-Zap', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2023-03-02 14:59:35', null, 5);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Daltfresh', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', '2022-07-17 05:37:27', '2023-06-17 13:36:46', 4);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Solarbreeze', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2022-03-14 00:04:33', null, 29);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Voltsillam', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', '2022-05-21 19:25:52', null, 19);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Latlux', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', '2021-12-12 07:37:42', '2024-10-07 00:31:26', 4);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Namfix', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2022-02-01 22:31:25', '2024-01-16 07:52:26', 20);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Zathin', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.

Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', '2022-05-06 16:11:32', null, 26);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Gembucket', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2021-12-27 21:52:21', '2024-04-21 18:09:28', 21);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Tin', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', '2022-10-09 22:41:25', null, 3);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Gembucket', '', '2022-12-10 07:20:09', null, 7);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Quo Lux', '', '2022-02-05 11:55:24', '2024-05-01 10:57:06', 26);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Home Ing', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', '2022-07-21 11:00:51', null, 20);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Toughjoyfax', '', '2021-12-05 17:12:21', null, 28);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Andalax', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', '2022-07-23 06:30:39', '2025-01-06 20:33:33', 7);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Bitwolf', '', '2021-05-16 16:49:08', null, 3);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Tampflex', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', '2022-11-19 09:32:36', '2023-05-22 07:52:01', 30);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Tempsoft', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', '2022-04-02 13:01:16', null, 5);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Hatity', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2023-03-16 04:07:43', '2023-10-11 11:25:41', 27);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Voyatouch', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2023-01-30 06:12:36', '2023-12-22 02:52:28', 24);
insert into project (id, name, description, creation_date, finish_date, author_id) values (DEFAULT, 'Flexidy', '', '2022-03-07 10:31:20', '2025-01-07 13:32:16', 20);




insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-09 02:07:46', null, 8, 7);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-27 21:23:32', null, 4, 7);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-27 09:27:06', '2021-06-23 14:02:50', 11, 28);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-16 18:28:37', null, 6, 26);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-27 00:31:54', '2020-04-12 10:41:06', 5, 41);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-07 13:35:27', null, 24, 36);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2020-01-16 03:03:34', null, 14, 44);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-25 21:09:21', null, 4, 24);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-09-22 03:48:15', null, 30, 40);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-10 13:50:27', null, 11, 24);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-25 13:35:26', null, 5, 22);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-01 18:03:47', null, 22, 18);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-16 04:18:32', null, 19, 11);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-08 15:12:06', null, 14, 49);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-12-29 20:27:55', null, 26, 40);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-27 21:50:53', null, 12, 45);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-29 20:52:09', null, 30, 16);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-29 22:57:02', null, 23, 9);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-15 08:28:40', null, 22, 7);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-05-13 07:18:54', null, 27, 41);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-26 19:39:18', '2020-12-03 23:05:54', 22, 13);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-22 11:05:33', null, 8, 9);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2020-03-06 03:46:03', null, 16, 3);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-04 22:00:03', null, 29, 14);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-12-07 18:05:34', null, 6, 5);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-04-23 09:12:42', '2021-06-23 07:06:44', 28, 26);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-11 04:08:45', null, 3, 33);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-02-14 05:03:28', null, 5, 12);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-09-07 15:26:49', null, 16, 4);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-14 10:10:24', '2020-06-30 20:48:39', 28, 33);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2020-01-17 19:04:50', '2020-11-29 05:55:55', 22, 43);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-01 18:02:35', null, 16, 25);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-27 10:49:16', null, 5, 41);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-11-25 14:22:37', null, 25, 17);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-30 15:16:13', null, 23, 2);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-11 01:21:07', '2020-06-11 07:40:13', 28, 12);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-26 15:45:32', null, 22, 5);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-05-02 09:23:17', '2022-02-19 04:47:44', 28, 18);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-02 02:01:20', null, 26, 23);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-08-23 07:27:30', null, 18, 46);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-24 23:04:41', null, 3, 30);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-10-19 20:26:31', null, 2, 7);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-06 08:07:11', null, 8, 42);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-28 06:41:24', null, 15, 49);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-03-18 08:15:57', '2022-06-21 22:16:26', 3, 48);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-05-09 03:23:22', null, 11, 15);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-03-19 04:19:34', null, 2, 44);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-02-08 11:30:11', null, 6, 22);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-26 23:10:15', null, 25, 45);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-02-09 16:05:33', null, 29, 44);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-09-15 10:18:49', null, 24, 45);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-18 16:24:07', null, 19, 29);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2020-01-27 02:12:22', null, 25, 26);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-01 14:19:11', '2022-11-24 05:59:16', 13, 42);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-24 23:14:08', null, 6, 7);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-07-29 16:44:19', null, 7, 25);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-05-08 02:48:03', '2020-09-07 21:41:37', 2, 28);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-17 10:14:29', null, 20, 43);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-28 18:21:19', null, 23, 13);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-09 17:11:36', null, 8, 44);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-09-25 05:47:03', null, 15, 17);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-03-24 02:31:14', null, 10, 29);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-02 23:14:12', null, 12, 28);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-08-25 03:07:23', '2022-08-13 16:51:54', 30, 35);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-01 22:51:31', null, 10, 49);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-08-23 06:32:10', null, 13, 23);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-25 00:41:31', null, 3, 45);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-13 14:27:57', null, 29, 22);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2020-01-15 20:35:14', null, 18, 41);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-03-26 06:19:52', null, 9, 5);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-01 04:52:07', null, 25, 34);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-02-17 14:06:43', null, 17, 33);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-31 16:18:32', '2023-01-08 01:06:00', 29, 23);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-01 16:15:42', null, 25, 14);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-12 19:52:52', null, 9, 26);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-11-11 01:30:27', null, 3, 41);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-08-02 09:46:26', null, 29, 10);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-05-05 12:30:04', null, 24, 21);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-20 08:05:54', null, 3, 32);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-01 23:58:39', null, 4, 8);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-07-22 12:48:42', null, 11, 24);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-06-17 22:16:28', null, 27, 15);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-12-28 08:12:20', null, 16, 25);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-05 01:09:07', '2022-01-22 07:11:08', 22, 13);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'coordinator', '2019-07-02 13:01:15', '2023-01-05 03:13:36', 8, 33);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-02-16 05:23:04', null, 17, 29);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-05 08:08:18', null, 11, 46);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-05-07 01:49:05', null, 3, 22);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-27 01:36:03', null, 14, 35);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-28 07:30:06', null, 6, 28);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-10-06 03:27:48', null, 26, 26);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-05 21:26:57', '2021-04-17 07:40:50', 2, 15);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-03-29 11:44:51', null, 21, 32);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-05-28 16:37:12', null, 28, 32);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-23 07:49:20', null, 26, 4);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-04-09 16:05:51', null, 3, 36);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-03-23 04:06:21', '2021-03-04 22:23:53', 19, 13);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2019-09-08 05:16:50', null, 18, 18);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-02-09 17:41:26', null, 11, 6);
insert into member_status (id, role, entrance_date, departure_date, user_id, project_id) values (DEFAULT, 'developer', '2020-01-06 17:07:35', null, 28, 25);

insert into issue_list (id, name, project_id) values (DEFAULT, 'quis turpis sed', 39);
insert into issue_list (id, name, project_id) values (DEFAULT, 'nulla mollis', 23);
insert into issue_list (id, name, project_id) values (DEFAULT, 'quisque', 47);
insert into issue_list (id, name, project_id) values (DEFAULT, 'blandit lacinia erat', 46);
insert into issue_list (id, name, project_id) values (DEFAULT, 'morbi vestibulum velit', 44);
insert into issue_list (id, name, project_id) values (DEFAULT, 'integer', 23);
insert into issue_list (id, name, project_id) values (DEFAULT, 'in', 38);
insert into issue_list (id, name, project_id) values (DEFAULT, 'eu', 49);
insert into issue_list (id, name, project_id) values (DEFAULT, 'parturient montes', 37);
insert into issue_list (id, name, project_id) values (DEFAULT, 'rhoncus mauris enim', 5);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sapien non mi', 33);
insert into issue_list (id, name, project_id) values (DEFAULT, 'tortor risus dapibus', 35);
insert into issue_list (id, name, project_id) values (DEFAULT, 'purus', 10);
insert into issue_list (id, name, project_id) values (DEFAULT, 'a', 47);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ut nunc vestibulum', 18);
insert into issue_list (id, name, project_id) values (DEFAULT, 'viverra', 5);
insert into issue_list (id, name, project_id) values (DEFAULT, 'leo', 36);
insert into issue_list (id, name, project_id) values (DEFAULT, 'convallis', 6);
insert into issue_list (id, name, project_id) values (DEFAULT, 'porttitor', 40);
insert into issue_list (id, name, project_id) values (DEFAULT, 'quam sollicitudin vitae', 17);
insert into issue_list (id, name, project_id) values (DEFAULT, 'lobortis ligula sit', 17);
insert into issue_list (id, name, project_id) values (DEFAULT, 'dolor', 6);
insert into issue_list (id, name, project_id) values (DEFAULT, 'risus dapibus augue', 28);
insert into issue_list (id, name, project_id) values (DEFAULT, 'in sapien iaculis', 48);
insert into issue_list (id, name, project_id) values (DEFAULT, 'enim leo rhoncus', 37);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ut erat id', 1);
insert into issue_list (id, name, project_id) values (DEFAULT, 'est donec', 48);
insert into issue_list (id, name, project_id) values (DEFAULT, 'fusce posuere felis', 41);
insert into issue_list (id, name, project_id) values (DEFAULT, 'justo', 20);
insert into issue_list (id, name, project_id) values (DEFAULT, 'eget nunc donec', 13);
insert into issue_list (id, name, project_id) values (DEFAULT, 'orci', 2);
insert into issue_list (id, name, project_id) values (DEFAULT, 'massa id', 4);
insert into issue_list (id, name, project_id) values (DEFAULT, 'etiam faucibus', 22);
insert into issue_list (id, name, project_id) values (DEFAULT, 'pede', 19);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sit', 37);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ut at', 49);
insert into issue_list (id, name, project_id) values (DEFAULT, 'et', 17);
insert into issue_list (id, name, project_id) values (DEFAULT, 'magna vestibulum', 9);
insert into issue_list (id, name, project_id) values (DEFAULT, 'metus aenean fermentum', 7);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sed', 28);
insert into issue_list (id, name, project_id) values (DEFAULT, 'blandit', 20);
insert into issue_list (id, name, project_id) values (DEFAULT, 'lectus vestibulum', 20);
insert into issue_list (id, name, project_id) values (DEFAULT, 'neque', 35);
insert into issue_list (id, name, project_id) values (DEFAULT, 'eu magna vulputate', 38);
insert into issue_list (id, name, project_id) values (DEFAULT, 'blandit', 39);
insert into issue_list (id, name, project_id) values (DEFAULT, 'vestibulum', 44);
insert into issue_list (id, name, project_id) values (DEFAULT, 'amet consectetuer', 35);
insert into issue_list (id, name, project_id) values (DEFAULT, 'lorem integer', 38);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ut', 34);
insert into issue_list (id, name, project_id) values (DEFAULT, 'diam erat fermentum', 19);
insert into issue_list (id, name, project_id) values (DEFAULT, 'in hac', 50);
insert into issue_list (id, name, project_id) values (DEFAULT, 'donec pharetra', 39);
insert into issue_list (id, name, project_id) values (DEFAULT, 'convallis nunc proin', 1);
insert into issue_list (id, name, project_id) values (DEFAULT, 'et', 19);
insert into issue_list (id, name, project_id) values (DEFAULT, 'luctus et', 4);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ridiculus mus', 15);
insert into issue_list (id, name, project_id) values (DEFAULT, 'et magnis', 50);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ipsum', 28);
insert into issue_list (id, name, project_id) values (DEFAULT, 'vestibulum', 37);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sed lacus morbi', 50);
insert into issue_list (id, name, project_id) values (DEFAULT, 'proin', 21);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ac', 10);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sagittis', 1);
insert into issue_list (id, name, project_id) values (DEFAULT, 'natoque penatibus', 2);
insert into issue_list (id, name, project_id) values (DEFAULT, 'rutrum rutrum', 5);
insert into issue_list (id, name, project_id) values (DEFAULT, 'consequat', 15);
insert into issue_list (id, name, project_id) values (DEFAULT, 'vitae nisl aenean', 47);
insert into issue_list (id, name, project_id) values (DEFAULT, 'nibh in hac', 44);
insert into issue_list (id, name, project_id) values (DEFAULT, 'hac habitasse platea', 24);
insert into issue_list (id, name, project_id) values (DEFAULT, 'curae nulla dapibus', 39);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ligula sit', 26);
insert into issue_list (id, name, project_id) values (DEFAULT, 'condimentum id', 46);
insert into issue_list (id, name, project_id) values (DEFAULT, 'eleifend', 9);
insert into issue_list (id, name, project_id) values (DEFAULT, 'amet', 3);
insert into issue_list (id, name, project_id) values (DEFAULT, 'vestibulum proin eu', 46);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sed justo', 2);
insert into issue_list (id, name, project_id) values (DEFAULT, 'mattis odio', 16);
insert into issue_list (id, name, project_id) values (DEFAULT, 'nulla', 48);
insert into issue_list (id, name, project_id) values (DEFAULT, 'in', 26);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sed', 2);
insert into issue_list (id, name, project_id) values (DEFAULT, 'sapien cursus', 7);
insert into issue_list (id, name, project_id) values (DEFAULT, 'venenatis non sodales', 30);
insert into issue_list (id, name, project_id) values (DEFAULT, 'dolor', 39);
insert into issue_list (id, name, project_id) values (DEFAULT, 'quis turpis', 28);
insert into issue_list (id, name, project_id) values (DEFAULT, 'curabitur', 45);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ut nunc vestibulum', 6);
insert into issue_list (id, name, project_id) values (DEFAULT, 'dis', 50);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ipsum praesent', 29);
insert into issue_list (id, name, project_id) values (DEFAULT, 'donec', 5);
insert into issue_list (id, name, project_id) values (DEFAULT, 'montes nascetur ridiculus', 24);
insert into issue_list (id, name, project_id) values (DEFAULT, 'ut', 23);
insert into issue_list (id, name, project_id) values (DEFAULT, 'adipiscing', 12);
insert into issue_list (id, name, project_id) values (DEFAULT, 'vestibulum ac', 19);
insert into issue_list (id, name, project_id) values (DEFAULT, 'eu magna', 44);
insert into issue_list (id, name, project_id) values (DEFAULT, 'orci luctus et', 48);
insert into issue_list (id, name, project_id) values (DEFAULT, 'enim lorem ipsum', 14);
insert into issue_list (id, name, project_id) values (DEFAULT, 'varius integer ac', 1);
insert into issue_list (id, name, project_id) values (DEFAULT, 'nibh in', 50);
insert into issue_list (id, name, project_id) values (DEFAULT, 'in faucibus orci', 15);
insert into issue_list (id, name, project_id) values (DEFAULT, 'facilisi cras non', 41);

insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'faucibus orci', 'duis bibendum felis sed interdum venenatis', '2019-08-03 02:30:33', null, true, '2021-01-04 08:14:05', 81, 1, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'iaculis diam erat', 'diam cras pellentesque volutpat', '2019-11-11 14:52:08', null, true, null, 3, 12, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed justo', 'amet nulla quisque arcu libero rutrum ac', '2020-01-07 04:55:33', null, false, null, 45, 5, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magnis dis', 'sit amet diam', '2020-02-28 11:24:21', null, true, null, 48, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vulputate luctus', 'consectetuer adipiscing elit proin risus praesent lectus vestibulum', '2019-10-22 09:06:55', null, true, '2021-04-17 17:27:09', 89, 1, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eget congue eget', 'nulla sed accumsan felis ut', '2019-09-30 07:30:37', null, true, null, 25, 11, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla', 'justo etiam pretium iaculis justo in', '2019-08-11 06:58:39', null, true, null, 6, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tincidunt eget tempus', 'dictumst aliquam augue quam sollicitudin vitae consectetuer', '2020-01-17 00:19:42', null, true, null, 29, 2, 4);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut rhoncus aliquet', 'erat fermentum justo', '2019-06-06 08:14:58', null, true, null, 13, 7, 13);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eu est congue', 'suscipit nulla elit ac nulla', '2019-10-24 13:16:31', '2020-05-19 10:12:27', false, null, 32, 15, 18);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vivamus', 'ut erat id mauris vulputate elementum nullam', '2019-07-15 20:52:05', null, false, null, 17, 23, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'arcu', 'lectus pellentesque eget nunc donec quis orci', '2019-05-18 14:47:00', null, false, null, 94, 29, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dapibus', 'mauris ullamcorper purus sit amet nulla quisque arcu', '2019-11-11 09:42:54', null, true, '2021-03-14 01:08:34', 56, 28, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'justo', 'risus semper porta volutpat', '2019-08-13 03:53:37', null, true, null, 72, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisl duis', 'at velit eu est congue', '2019-06-25 19:37:35', '2022-01-07 19:39:45', true, null, 61, 23, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum', 'nisi vulputate nonummy maecenas tincidunt lacus', '2019-04-14 01:43:13', null, true, '2020-12-04 02:19:00', 45, 21, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'neque', 'massa id lobortis convallis tortor risus', '2020-01-04 04:42:07', '2021-06-15 14:34:56', true, null, 82, 19, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'cubilia', 'nam ultrices libero non mattis pulvinar nulla pede', '2019-06-27 05:30:59', null, true, null, 47, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'placerat ante', 'elementum ligula vehicula consequat morbi', '2019-06-30 12:10:40', null, false, null, 96, 14, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ante', 'eget eleifend', '2020-02-03 14:01:07', '2022-01-14 08:52:21', false, null, 61, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'erat', 'et ultrices posuere cubilia curae duis faucibus', '2019-08-13 20:15:52', '2022-03-11 12:17:13', false, null, 54, 20, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'duis consequat dui', 'nisl ut volutpat sapien arcu sed augue aliquam', '2019-05-21 12:07:24', '2022-11-03 17:00:22', true, null, 64, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit', 'velit vivamus vel nulla eget eros', '2020-03-14 13:33:53', null, true, null, 34, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'posuere cubilia curae', 'libero rutrum ac', '2019-05-09 11:19:16', '2023-03-18 00:58:07', true, null, 80, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'accumsan tellus', 'mauris ullamcorper purus sit amet nulla', '2020-02-27 13:14:31', null, false, null, 30, 14, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'aliquam convallis', 'purus phasellus', '2019-09-11 08:19:24', null, true, null, 13, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consequat in consequat', 'pellentesque quisque porta', '2019-07-14 09:26:44', null, false, '2022-05-12 13:53:50', 27, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisl ut volutpat', 'luctus et ultrices posuere cubilia curae mauris viverra', '2019-11-01 06:23:47', null, true, null, 56, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempus', 'nec euismod scelerisque quam turpis adipiscing', '2019-09-24 19:49:33', null, false, null, 73, 11, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nunc commodo', 'felis donec semper sapien a libero', '2020-03-27 12:02:48', '2021-05-07 12:49:38', false, null, 68, 10, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consequat', 'in consequat ut', '2020-01-07 15:53:56', null, false, null, 64, 8, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dui vel nisl', 'praesent blandit lacinia erat vestibulum sed magna', '2019-07-25 22:01:55', null, false, '2020-11-03 01:54:23', 39, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nam ultrices libero', 'nulla sed', '2019-12-19 20:37:37', '2022-10-08 07:51:23', true, null, 10, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel enim', 'ultricies eu nibh quisque id justo sit', '2019-08-23 18:48:54', null, true, null, 40, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id', 'condimentum curabitur in', '2019-05-15 03:09:52', null, true, '2022-03-27 21:45:28', 89, 9, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dapibus nulla', 'pharetra magna vestibulum', '2019-11-25 07:10:44', null, false, '2022-07-22 09:29:21', 71, 10, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pretium iaculis', 'maecenas tristique est', '2019-11-06 10:18:04', null, true, null, 5, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id', 'id lobortis convallis tortor', '2019-08-21 22:38:16', '2022-08-02 06:32:16', false, null, 96, 17, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in', 'dapibus duis', '2020-03-13 07:14:29', null, true, null, 47, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'integer a nibh', 'eget eros elementum pellentesque', '2019-10-06 11:40:10', null, false, '2022-02-20 18:47:21', 98, 23, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'maecenas', 'arcu sed augue aliquam erat volutpat', '2019-09-07 22:40:21', '2020-08-20 07:50:55', true, null, 97, 16, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'cubilia curae', 'imperdiet sapien urna pretium nisl ut volutpat sapien', '2020-03-10 00:25:42', null, false, null, 15, 14, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit amet consectetuer', 'ut massa volutpat convallis morbi odio', '2019-07-19 13:49:04', null, true, null, 20, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'porttitor lorem id', 'euismod scelerisque quam', '2019-11-18 18:47:56', null, false, null, 51, 22, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi porttitor lorem', 'at turpis donec posuere metus vitae ipsum aliquam', '2020-01-08 21:21:22', null, false, null, 29, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quis orci nullam', 'porta volutpat', '2019-06-22 08:09:04', '2021-06-22 04:46:34', false, null, 76, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec', 'luctus tincidunt nulla mollis molestie lorem', '2019-10-10 17:54:26', null, false, '2022-09-26 08:05:30', 63, 26, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel nisl duis', 'eget tincidunt eget tempus vel', '2020-01-21 16:59:49', null, true, '2022-08-19 22:41:36', 12, 23, 27);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'adipiscing elit proin', 'metus arcu adipiscing molestie hendrerit', '2020-01-26 19:41:18', null, true, '2021-09-24 11:31:35', 70, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'curabitur', 'volutpat erat quisque erat eros', '2019-04-08 18:55:10', null, false, null, 77, 4, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in hac habitasse', 'sit amet consectetuer adipiscing elit proin interdum mauris', '2019-12-21 07:52:06', null, false, null, 24, 10, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'platea', 'montes nascetur ridiculus mus etiam vel', '2020-01-28 00:57:36', null, true, '2021-11-02 18:45:40', 85, 10, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lobortis vel dapibus', 'sapien ut nunc vestibulum ante ipsum primis', '2020-03-08 03:14:17', null, false, '2021-01-01 06:15:28', 63, 16, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'faucibus', 'rhoncus sed vestibulum sit amet cursus id turpis', '2020-01-10 15:01:00', null, true, null, 100, 9, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien cum sociis', 'libero ut', '2019-11-05 06:17:09', null, false, null, 49, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ac diam cras', 'lectus pellentesque eget nunc donec quis', '2019-05-27 02:56:58', '2022-03-08 17:54:24', false, null, 51, 12, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisi', 'sit amet nunc viverra dapibus nulla suscipit ligula', '2019-08-08 19:21:25', null, true, null, 81, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'donec', 'lobortis convallis tortor risus dapibus augue vel accumsan', '2019-05-20 08:23:23', null, false, '2020-09-25 06:09:09', 99, 2, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nunc viverra dapibus', 'vitae ipsum aliquam non mauris morbi', '2019-04-25 04:21:55', null, true, null, 87, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pellentesque at nulla', 'integer aliquet massa id lobortis', '2019-05-01 11:14:34', '2021-10-31 23:43:53', false, null, 16, 13, 15);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'venenatis', 'vitae nisl aenean lectus', '2019-07-27 22:51:52', '2020-12-31 20:37:29', false, null, 90, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus phasellus', 'tortor eu pede', '2019-08-29 01:08:08', null, false, '2022-10-05 03:14:32', 64, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisl', 'justo morbi ut odio', '2019-04-08 09:19:53', null, true, null, 98, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'et ultrices', 'ante vel ipsum', '2019-11-10 15:53:32', null, true, '2022-09-14 00:49:29', 49, 2, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempus', 'orci luctus', '2019-04-06 14:51:19', null, true, null, 90, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in est risus', 'volutpat convallis morbi odio', '2020-02-05 13:26:00', '2021-12-16 00:57:51', false, null, 59, 28, 16);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eu felis fusce', 'dui luctus rutrum nulla tellus', '2019-09-30 05:12:57', null, true, null, 86, 11, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ultrices vel', 'ipsum primis', '2019-08-02 20:30:38', null, false, null, 19, 7, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tortor eu', 'sed nisl nunc rhoncus dui', '2019-10-29 22:05:33', null, false, null, 37, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'orci nullam', 'augue vestibulum rutrum rutrum neque', '2019-09-12 20:31:49', '2022-08-11 14:59:29', false, '2022-06-05 15:20:13', 69, 5, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ultrices', 'metus aenean fermentum donec ut mauris', '2020-01-20 15:04:26', null, true, null, 34, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'praesent lectus', 'amet cursus id turpis', '2019-04-23 08:32:10', null, false, null, 32, 17, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien', 'posuere metus vitae ipsum', '2019-12-08 13:52:39', null, true, null, 46, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi', 'tempus vel pede morbi', '2019-12-24 13:28:30', null, true, null, 69, 1, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum ac tellus', 'elementum in', '2019-10-08 11:42:26', '2020-11-11 20:17:11', false, null, 2, 26, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'suscipit ligula', 'ultrices enim lorem ipsum dolor sit amet', '2019-08-20 14:26:38', null, false, null, 50, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consequat varius integer', 'morbi porttitor', '2019-06-29 10:10:10', '2021-10-10 19:21:31', false, null, 87, 25, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'enim', 'turpis nec', '2019-05-23 21:20:13', null, false, null, 61, 26, 16);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eu est congue', 'odio cras mi pede malesuada in imperdiet et', '2020-01-24 07:55:11', null, true, '2020-04-15 00:50:17', 44, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'massa id', 'ante nulla justo aliquam quis turpis', '2019-12-16 16:19:29', null, true, null, 50, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magna', 'risus auctor', '2020-02-20 17:34:48', null, false, null, 87, 22, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lacus', 'id turpis integer aliquet massa id', '2020-02-06 17:44:27', null, false, null, 75, 11, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nibh', 'sagittis dui vel nisl duis', '2019-08-01 18:08:57', '2020-06-09 03:07:40', false, null, 12, 7, 27);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ligula nec', 'sit amet justo morbi ut odio', '2019-11-22 18:15:16', null, false, null, 9, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi ut', 'ante ipsum primis in faucibus orci', '2019-11-12 01:42:43', null, true, null, 30, 27, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'viverra pede', 'congue elementum in hac habitasse platea', '2019-12-06 21:15:04', null, true, null, 21, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede ac', 'sem praesent id massa', '2020-03-17 08:39:16', null, false, null, 12, 29, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi', 'morbi odio odio elementum eu interdum eu', '2019-08-29 13:56:54', null, true, null, 90, 25, 26);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non', 'turpis a', '2019-04-29 15:53:29', null, false, null, 81, 15, 18);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eget vulputate', 'vel pede morbi porttitor', '2020-01-03 23:42:15', null, true, null, 32, 5, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla', 'eleifend quam a', '2019-04-04 23:56:49', null, false, null, 87, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vitae nisl aenean', 'ac tellus semper', '2019-09-01 05:23:28', null, false, null, 78, 8, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pretium quis lectus', 'ultrices enim', '2019-08-28 17:54:24', null, false, null, 78, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dictumst', 'aliquam non mauris morbi non lectus aliquam sit', '2019-03-31 15:43:02', null, true, null, 28, 7, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at diam nam', 'natoque penatibus et magnis dis parturient', '2019-05-24 09:32:12', null, true, null, 51, 17, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'viverra dapibus nulla', 'justo pellentesque viverra pede', '2020-01-31 20:49:47', null, false, null, 12, 7, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ornare consequat lectus', 'in faucibus', '2019-09-03 17:53:04', null, false, null, 68, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'convallis nunc proin', 'id nisl venenatis lacinia aenean', '2019-05-01 12:01:09', null, true, '2022-01-14 10:23:56', 11, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nullam orci pede', 'vestibulum aliquet ultrices erat', '2019-05-08 04:09:06', null, true, '2020-12-13 06:07:47', 30, 22, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'turpis enim', 'potenti nullam porttitor lacus at turpis donec', '2019-12-09 02:50:19', null, false, '2021-03-07 15:38:28', 19, 20, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'erat volutpat', 'montes nascetur ridiculus mus etiam', '2020-02-12 19:28:49', null, false, null, 42, 2, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id massa id', 'fermentum justo nec', '2020-03-16 07:52:58', null, true, '2020-11-12 17:47:32', 40, 30, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'augue aliquam', 'pede morbi porttitor lorem id ligula suspendisse ornare', '2019-04-15 22:55:53', null, true, null, 67, 2, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tellus', 'cum sociis natoque penatibus et magnis', '2019-12-15 03:02:49', null, true, '2021-10-09 03:43:44', 65, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'faucibus orci', 'mattis odio', '2019-12-23 21:18:53', null, true, null, 63, 14, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nunc rhoncus', 'id nisl venenatis lacinia aenean', '2019-10-31 08:43:17', null, true, null, 98, 3, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus aliquet at', 'nisl nunc nisl duis bibendum felis sed interdum', '2020-03-11 18:46:52', null, true, null, 2, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'aliquet at feugiat', 'rutrum at lorem integer tincidunt ante', '2019-08-10 08:53:53', null, true, '2020-11-26 13:51:43', 74, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'fusce', 'commodo vulputate justo in blandit ultrices', '2020-02-04 03:15:33', null, true, null, 15, 2, 12);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'praesent', 'nisi nam ultrices libero non', '2019-07-31 05:46:08', null, false, null, 50, 23, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede', 'nulla justo aliquam quis', '2019-08-27 11:13:47', null, true, '2020-04-08 10:03:54', 34, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id', 'ut odio cras mi pede malesuada', '2019-08-03 04:41:46', null, true, null, 50, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel', 'vel augue vestibulum ante ipsum primis', '2019-07-14 23:26:47', null, true, null, 41, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'primis in', 'mattis egestas', '2020-01-12 01:44:58', '2022-05-05 16:04:57', true, null, 97, 23, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien sapien non', 'nunc nisl duis bibendum felis sed', '2019-12-02 14:06:54', null, false, null, 24, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien', 'duis at velit eu', '2020-03-18 11:42:03', '2021-05-15 05:23:29', true, '2022-02-11 00:08:31', 70, 15, 2);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nibh', 'at velit eu est congue elementum in hac', '2019-04-18 12:26:42', null, true, null, 77, 18, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'arcu sed augue', 'sed ante vivamus tortor', '2019-04-17 11:22:41', null, true, null, 83, 24, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nibh quisque', 'mattis pulvinar nulla pede ullamcorper augue a suscipit', '2020-02-19 14:17:15', null, false, '2021-06-19 04:55:42', 80, 18, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ultrices mattis odio', 'id lobortis convallis', '2019-12-17 03:43:58', null, false, null, 39, 29, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut', 'lacinia erat vestibulum sed magna at nunc', '2019-07-26 14:08:45', '2023-01-24 13:56:35', true, null, 37, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'odio curabitur', 'natoque penatibus et magnis dis parturient montes', '2019-09-26 01:36:46', null, false, null, 69, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed', 'tincidunt ante vel ipsum', '2019-09-20 15:41:55', null, true, null, 1, 27, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consequat metus', 'sollicitudin mi sit', '2020-01-28 22:32:07', null, false, null, 87, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'fermentum justo nec', 'libero quis orci nullam molestie nibh', '2019-06-12 07:23:25', '2021-06-20 15:50:26', false, '2022-07-17 01:39:20', 99, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede', 'lacus morbi sem mauris laoreet ut rhoncus aliquet', '2019-09-15 03:14:01', null, false, null, 79, 14, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non ligula pellentesque', 'adipiscing molestie', '2019-11-17 09:04:13', null, true, null, 98, 10, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id', 'ut tellus nulla ut erat id mauris', '2019-07-05 05:32:42', null, true, '2021-08-30 12:08:14', 4, 23, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla quisque', 'eu felis fusce posuere', '2019-06-16 21:50:01', null, true, null, 42, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vivamus vestibulum', 'ornare consequat lectus in est risus auctor', '2019-07-10 07:31:35', null, true, null, 35, 13, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'aenean fermentum', 'luctus rutrum nulla tellus in sagittis dui vel', '2020-01-08 10:18:45', null, false, '2021-12-29 02:02:22', 29, 28, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at vulputate vitae', 'sem praesent id massa id nisl venenatis lacinia', '2019-08-18 23:39:00', null, true, '2022-02-03 08:13:00', 24, 25, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum ante ipsum', 'nec nisi volutpat', '2019-10-26 16:12:03', '2021-11-14 23:12:35', false, null, 85, 30, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mauris', 'donec odio', '2020-02-21 07:28:44', null, true, '2022-04-02 21:11:35', 44, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede lobortis', 'habitasse platea dictumst etiam faucibus cursus urna ut', '2020-02-29 03:12:01', null, false, null, 21, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'amet turpis elementum', 'in quis justo maecenas rhoncus aliquam lacus', '2019-06-09 09:53:37', null, true, '2020-06-30 15:59:00', 94, 30, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede', 'in sagittis dui vel nisl duis ac nibh', '2019-11-07 23:55:36', null, true, '2021-08-20 18:14:12', 46, 3, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'metus sapien ut', 'posuere metus vitae ipsum aliquam', '2020-01-01 21:51:18', null, false, null, 55, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sagittis dui vel', 'eget tincidunt eget tempus vel pede morbi', '2019-10-06 01:05:32', null, false, null, 66, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien', 'luctus cum sociis natoque penatibus et magnis', '2019-10-12 09:51:53', null, false, null, 2, 4, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'habitasse', 'accumsan tellus nisi eu orci', '2020-01-18 02:26:08', '2022-01-10 12:43:52', false, null, 72, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'orci', 'in blandit ultrices enim lorem ipsum dolor sit', '2019-06-14 16:10:13', '2021-10-03 04:32:30', true, null, 38, 2, 26);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id', 'amet lobortis sapien', '2019-09-07 07:51:12', null, true, '2020-06-01 15:35:52', 94, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut', 'quam fringilla rhoncus mauris enim leo rhoncus', '2019-12-10 06:54:48', null, false, null, 74, 13, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien placerat ante', 'massa volutpat convallis morbi odio odio elementum', '2019-08-25 15:10:52', null, false, null, 62, 23, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magna', 'consectetuer eget rutrum', '2020-03-17 18:08:51', null, true, null, 17, 8, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit amet consectetuer', 'donec semper', '2019-12-12 23:07:54', null, true, null, 66, 4, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eget tincidunt eget', 'vehicula consequat morbi a ipsum integer a', '2019-10-15 07:19:37', '2021-07-13 11:34:11', true, null, 35, 13, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien', 'imperdiet nullam orci pede venenatis', '2019-05-04 10:07:52', '2022-09-18 11:27:23', true, '2020-08-06 05:51:27', 2, 8, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consequat', 'dui nec nisi volutpat eleifend', '2019-08-14 17:19:11', null, false, null, 28, 22, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id turpis', 'libero convallis eget', '2019-11-27 01:31:02', null, false, '2022-01-06 12:00:55', 6, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quisque', 'lobortis est phasellus sit amet erat', '2019-06-14 14:31:58', null, true, null, 3, 9, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'convallis nunc', 'quam nec dui', '2019-06-06 09:42:06', '2023-01-05 10:24:41', true, '2021-10-30 19:00:00', 30, 14, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in faucibus orci', 'amet sem', '2019-11-23 12:32:16', '2021-03-31 16:30:25', true, null, 37, 8, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisl', 'purus sit amet nulla', '2020-01-08 02:03:49', null, true, '2021-01-14 00:06:51', 98, 27, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus aliquet', 'diam erat fermentum', '2019-07-20 06:29:30', null, false, null, 94, 5, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non pretium quis', 'ante vel', '2020-03-07 17:43:19', null, true, null, 59, 11, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien ut', 'vestibulum ac est lacinia nisi venenatis tristique', '2019-04-17 02:10:14', null, true, null, 28, 13, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'turpis', 'morbi non lectus aliquam sit amet diam in', '2019-11-03 14:11:41', null, true, null, 44, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quis', 'etiam justo etiam pretium iaculis justo', '2020-03-05 22:19:04', null, false, null, 55, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eget vulputate', 'imperdiet sapien urna pretium nisl ut volutpat', '2019-10-01 03:36:17', null, true, '2020-11-13 11:33:57', 98, 14, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tincidunt', 'duis aliquam convallis nunc', '2019-04-22 04:34:20', null, true, '2022-09-30 15:14:39', 29, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed', 'vestibulum aliquet ultrices erat tortor sollicitudin mi sit', '2019-12-02 17:24:00', '2022-07-15 04:46:49', false, null, 50, 28, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'phasellus', 'nullam molestie', '2020-01-03 22:30:24', '2020-10-10 15:25:26', false, null, 6, 11, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sociis natoque', 'quisque arcu libero rutrum ac lobortis vel dapibus', '2020-02-29 15:21:03', null, true, null, 29, 13, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nibh ligula', 'vel augue vestibulum rutrum rutrum neque', '2019-05-26 09:57:28', null, false, null, 7, 27, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'condimentum id', 'nunc rhoncus dui vel sem sed', '2019-10-21 09:39:15', null, false, null, 52, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla', 'eu tincidunt', '2019-05-16 07:51:35', null, false, '2022-06-23 22:33:56', 21, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pharetra magna ac', 'metus vitae ipsum aliquam non mauris', '2019-07-15 16:03:06', null, true, null, 21, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'justo etiam', 'odio consequat varius integer ac leo', '2019-11-03 15:49:01', '2021-12-18 21:35:38', true, null, 82, 29, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tincidunt lacus', 'porttitor pede', '2019-06-11 16:31:54', '2020-08-30 20:54:45', false, null, 33, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'elementum ligula', 'ut suscipit a feugiat et', '2019-05-08 12:47:34', null, true, null, 5, 15, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'felis sed', 'magnis dis parturient montes nascetur ridiculus mus', '2019-09-01 21:51:11', null, false, '2023-03-12 07:11:11', 92, 18, 15);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'augue', 'ipsum primis in faucibus orci luctus', '2019-05-31 17:28:41', '2022-10-13 22:44:45', false, null, 24, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eu magna', 'sed sagittis nam congue risus semper porta', '2019-10-30 20:44:20', null, true, null, 79, 9, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at diam nam', 'cubilia curae mauris viverra', '2019-05-24 11:10:04', '2021-10-17 08:23:26', true, null, 42, 17, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien placerat', 'massa donec dapibus duis at velit eu', '2020-01-20 12:13:06', null, false, null, 26, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in hac habitasse', 'sed justo pellentesque viverra pede ac', '2020-01-05 09:11:28', null, true, null, 39, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'suspendisse potenti', 'eros viverra', '2019-11-15 07:40:28', null, true, '2021-06-03 03:54:00', 52, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quis', 'quis augue luctus', '2019-08-31 01:37:32', null, true, null, 58, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quis libero', 'cras mi', '2019-06-08 07:38:01', null, false, null, 48, 20, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dictumst aliquam', 'nisi vulputate nonummy maecenas tincidunt', '2019-06-04 05:25:28', '2022-12-04 04:09:20', true, '2022-03-02 17:15:25', 79, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'accumsan tellus', 'nisi venenatis tristique fusce congue diam', '2019-12-14 21:16:05', null, true, null, 92, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'odio', 'primis in faucibus orci luctus et ultrices posuere', '2020-02-17 13:24:39', '2023-02-18 05:18:02', false, null, 45, 26, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut odio cras', 'etiam faucibus cursus', '2019-11-22 22:31:59', null, true, '2022-05-02 11:51:44', 65, 9, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec', 'etiam pretium iaculis justo in hac habitasse platea', '2019-09-03 20:08:46', null, false, null, 40, 6, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at', 'nulla elit ac nulla sed', '2019-06-04 07:51:54', null, true, '2021-08-13 11:08:37', 13, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'donec', 'nulla ut erat id mauris vulputate elementum', '2020-03-03 03:15:14', null, true, null, 58, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eu mi', 'convallis morbi odio odio elementum eu', '2019-06-05 05:45:59', null, false, null, 1, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'a pede posuere', 'interdum in ante vestibulum ante ipsum', '2020-03-10 19:51:29', null, false, null, 11, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'potenti in', 'ante ipsum primis in faucibus', '2020-03-13 06:50:43', null, false, null, 10, 3, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum ante ipsum', 'nam nulla integer pede justo lacinia eget tincidunt', '2019-04-16 11:40:05', null, false, null, 87, 11, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nullam molestie', 'arcu adipiscing molestie hendrerit at', '2020-03-02 13:12:52', null, false, null, 39, 20, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut dolor', 'id massa id nisl venenatis lacinia aenean sit', '2019-12-22 01:51:38', null, true, '2020-09-11 11:27:13', 87, 1, 16);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in libero', 'orci mauris lacinia sapien', '2019-07-19 10:08:16', null, false, null, 13, 23, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla justo', 'quam nec dui luctus rutrum nulla tellus in', '2019-07-24 16:46:18', null, true, null, 17, 1, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'leo odio condimentum', 'nisl nunc', '2019-07-18 13:31:07', null, false, null, 54, 2, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'habitasse', 'adipiscing molestie', '2020-03-17 06:50:39', null, true, '2023-03-11 08:04:25', 34, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit', 'nulla dapibus dolor', '2019-09-02 02:46:56', null, false, null, 81, 11, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magna vulputate luctus', 'lacus purus aliquet at feugiat non pretium quis', '2019-10-06 02:32:45', null, true, '2021-10-26 03:32:51', 55, 25, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'libero', 'nulla eget eros elementum pellentesque', '2019-05-19 13:53:28', '2022-04-24 23:54:12', true, null, 66, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'blandit ultrices enim', 'nec dui luctus rutrum nulla', '2019-06-25 01:26:39', null, true, '2021-11-08 00:51:33', 53, 22, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'malesuada', 'nisl duis ac nibh fusce lacus purus aliquet', '2019-11-08 14:43:29', null, true, null, 31, 4, 4);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit', 'duis aliquam convallis nunc', '2019-06-20 03:23:29', null, true, null, 11, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel lectus in', 'ac lobortis vel dapibus at diam', '2019-11-17 05:32:12', null, false, null, 44, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'massa', 'libero non mattis pulvinar nulla', '2019-07-27 00:13:10', '2020-11-23 17:59:30', false, '2020-12-21 17:35:33', 16, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dolor sit', 'orci nullam molestie', '2019-08-17 22:30:33', null, true, null, 41, 9, 27);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede ullamcorper augue', 'nec sem duis aliquam convallis nunc', '2019-12-31 19:10:03', '2021-09-28 15:47:15', false, null, 72, 27, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'potenti cras in', 'dolor sit amet consectetuer adipiscing elit proin interdum', '2019-11-04 17:33:37', null, true, '2020-06-29 11:20:22', 76, 9, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit amet consectetuer', 'nam dui proin leo', '2019-05-24 02:56:52', '2020-07-18 13:21:33', true, null, 47, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'amet sem', 'blandit nam nulla integer pede justo lacinia', '2019-05-24 07:57:19', '2021-01-04 10:24:27', true, null, 7, 4, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magna vestibulum aliquet', 'ut massa volutpat convallis', '2020-02-05 05:10:37', '2020-06-08 23:30:15', true, null, 84, 18, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'libero', 'amet eros suspendisse accumsan tortor quis turpis sed', '2019-07-13 09:35:29', '2021-11-11 13:38:24', true, null, 63, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'diam nam tristique', 'mus vivamus vestibulum sagittis sapien', '2019-12-10 15:51:16', null, false, null, 97, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus', 'leo odio', '2019-05-20 05:10:53', null, true, null, 61, 15, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'et ultrices', 'ultrices vel augue vestibulum ante ipsum primis in', '2019-06-13 05:32:06', '2020-05-01 01:54:54', false, null, 31, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ultrices', 'vel ipsum praesent blandit lacinia erat', '2019-07-07 21:06:30', null, false, null, 80, 28, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pellentesque', 'risus praesent lectus vestibulum quam sapien varius ut', '2019-05-04 06:25:53', '2022-11-02 06:53:24', true, null, 5, 30, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'proin eu mi', 'lectus aliquam sit amet diam in magna', '2019-08-04 10:41:18', null, true, '2020-09-19 14:25:46', 49, 10, 15);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi', 'sollicitudin ut', '2019-07-11 10:37:17', null, true, null, 41, 29, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lacus morbi', 'consequat morbi a', '2020-03-13 22:54:34', '2020-08-19 19:20:53', false, null, 8, 1, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed justo', 'faucibus accumsan odio curabitur convallis duis consequat', '2019-06-26 12:17:55', null, true, null, 87, 15, 12);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dictumst aliquam', 'eget congue eget semper rutrum nulla nunc', '2019-11-12 14:51:29', null, true, null, 16, 13, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum', 'nisi vulputate nonummy maecenas tincidunt lacus at', '2019-12-01 23:03:20', null, false, null, 64, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'luctus', 'vivamus vel', '2019-12-23 02:39:38', null, false, '2020-06-11 19:39:18', 31, 20, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'libero non', 'eleifend luctus ultricies eu nibh', '2020-01-08 18:30:14', '2020-09-14 23:14:11', true, '2021-04-14 11:21:36', 5, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sagittis dui vel', 'proin interdum mauris non ligula pellentesque ultrices phasellus', '2019-12-10 13:54:14', null, false, null, 10, 11, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisl nunc nisl', 'accumsan odio curabitur convallis', '2019-12-22 11:25:28', null, false, null, 24, 21, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'amet sapien', 'erat vestibulum sed', '2019-05-06 16:58:58', '2021-10-02 09:37:13', true, null, 49, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lectus in', 'cras mi', '2020-01-05 19:05:20', null, true, null, 67, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'erat nulla tempus', 'odio odio elementum', '2020-02-16 16:38:27', '2021-02-09 01:58:28', true, null, 80, 24, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lectus pellentesque eget', 'ut at dolor quis odio', '2019-04-29 13:41:23', null, true, null, 26, 24, 26);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'a odio', 'integer pede justo lacinia eget tincidunt', '2019-12-28 19:35:25', null, true, '2020-11-24 11:34:48', 7, 20, 13);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'fusce congue', 'ac nibh fusce lacus purus aliquet at feugiat', '2019-08-19 03:33:44', null, true, null, 13, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus', 'nam dui proin leo odio', '2019-06-15 12:53:15', null, false, null, 64, 27, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'metus', 'platea dictumst etiam faucibus cursus', '2019-07-05 00:18:41', null, false, '2020-05-09 15:04:12', 5, 6, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'turpis enim', 'in ante vestibulum ante ipsum primis in faucibus', '2019-04-18 14:31:22', null, true, null, 82, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dapibus duis', 'laoreet ut rhoncus', '2019-06-30 08:24:56', null, true, null, 80, 1, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum primis in', 'at velit vivamus vel nulla eget eros', '2019-06-23 15:54:55', '2020-12-10 00:25:00', true, null, 26, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'diam vitae quam', 'dapibus at diam nam tristique tortor', '2020-01-21 18:59:35', '2022-09-13 01:27:17', true, null, 48, 29, 15);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempus semper est', 'tortor sollicitudin', '2019-09-16 00:40:44', null, false, null, 1, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mi in porttitor', 'nisi at nibh in hac habitasse', '2020-02-04 22:07:17', null, true, null, 56, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'venenatis tristique', 'elit proin interdum mauris non', '2019-07-01 14:28:01', null, true, null, 34, 26, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisl', 'quis odio consequat varius', '2019-06-06 12:21:36', null, true, null, 87, 2, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'faucibus cursus', 'nisl venenatis lacinia aenean sit amet', '2019-07-11 21:59:07', null, false, null, 58, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dui', 'pellentesque viverra pede ac diam cras pellentesque volutpat', '2019-08-07 01:18:09', null, true, '2020-04-23 22:23:31', 1, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel', 'sed interdum venenatis turpis enim blandit mi in', '2019-11-12 23:08:10', '2021-11-29 00:37:15', false, null, 31, 9, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pede justo', 'ipsum praesent blandit lacinia erat vestibulum sed', '2019-08-16 09:50:12', null, true, null, 78, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'varius ut', 'lacus at turpis donec', '2020-03-28 16:56:08', null, true, null, 35, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec nisi', 'sed tincidunt eu felis fusce posuere', '2019-05-28 19:23:15', '2021-04-05 00:34:13', true, null, 33, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'justo pellentesque', 'cubilia curae donec pharetra', '2020-03-21 18:20:44', null, true, '2022-04-23 22:29:34', 23, 20, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'est lacinia nisi', 'erat id mauris vulputate', '2020-01-04 23:36:20', null, true, null, 56, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'penatibus et', 'ut rhoncus aliquet pulvinar sed nisl', '2020-03-18 07:28:57', null, false, '2022-05-02 07:22:27', 65, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit amet nulla', 'curabitur in libero ut massa volutpat', '2019-08-12 09:08:10', null, false, '2022-11-18 05:56:11', 1, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum', 'eleifend pede libero quis orci', '2019-07-30 10:20:11', null, false, null, 46, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quam', 'dictumst maecenas ut massa quis augue luctus', '2019-07-18 01:25:04', null, true, '2022-03-03 09:07:59', 100, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum aliquet', 'metus vitae ipsum', '2019-09-27 08:01:23', null, true, null, 24, 19, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'interdum eu', 'at dolor', '2019-05-22 14:44:38', '2022-08-21 16:50:00', true, null, 21, 22, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum aliquet', 'sed accumsan felis ut at dolor quis odio', '2019-12-23 22:13:17', null, true, '2021-12-06 08:42:21', 4, 28, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed', 'ante vestibulum ante ipsum primis in', '2019-11-10 11:32:19', null, false, null, 7, 21, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at', 'turpis eget elit sodales scelerisque mauris sit', '2019-07-19 14:01:45', null, false, null, 8, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lacinia nisi venenatis', 'accumsan odio curabitur convallis duis consequat', '2019-05-19 06:28:32', null, false, '2021-06-25 13:43:37', 82, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla quisque arcu', 'at nibh in hac habitasse platea', '2020-03-25 10:18:11', null, false, null, 39, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dictumst', 'sapien a libero nam dui proin leo', '2019-09-11 06:24:26', null, true, '2022-05-15 08:02:24', 22, 24, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'posuere cubilia curae', 'nisi volutpat eleifend donec ut dolor', '2019-07-07 09:32:01', null, false, null, 11, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'maecenas pulvinar', 'proin at turpis a pede posuere nonummy', '2020-02-19 06:28:27', null, false, '2022-05-07 15:35:25', 18, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magna vestibulum aliquet', 'lacus morbi quis tortor id nulla ultrices', '2019-09-02 13:10:52', '2022-01-02 07:05:26', true, null, 97, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'placerat praesent', 'tincidunt ante vel ipsum praesent blandit lacinia', '2019-05-03 04:45:07', null, true, null, 12, 20, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lobortis', 'vel augue', '2019-04-18 12:52:09', null, false, '2020-06-17 19:18:19', 12, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nam dui proin', 'pretium iaculis justo in hac habitasse', '2019-06-27 01:17:27', null, false, null, 14, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec', 'odio cras mi pede malesuada in imperdiet et', '2019-11-08 21:36:05', null, false, null, 100, 24, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed tristique', 'non velit donec diam neque vestibulum eget', '2019-04-11 07:29:32', null, true, null, 2, 29, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tristique', 'ante ipsum primis in faucibus orci luctus', '2019-07-17 21:30:28', '2020-09-17 06:57:09', false, null, 32, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ante vivamus tortor', 'nisl venenatis lacinia aenean', '2020-02-21 01:10:13', '2021-02-09 00:19:44', false, null, 19, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ante ipsum', 'ultrices aliquet', '2019-09-05 05:41:17', null, true, '2022-11-28 18:30:44', 87, 13, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sit', 'curae mauris viverra diam vitae quam', '2019-04-25 08:07:58', '2022-07-09 11:19:33', false, null, 88, 9, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut ultrices vel', 'ac tellus semper interdum mauris', '2019-12-12 19:20:02', null, false, '2020-11-18 01:16:28', 34, 23, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'enim', 'eget massa tempor convallis nulla neque libero convallis', '2019-04-09 03:01:20', null, false, null, 61, 3, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'et', 'dapibus nulla suscipit', '2019-05-10 15:55:16', null, true, null, 36, 23, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dolor sit', 'duis ac nibh fusce', '2019-09-14 15:01:10', '2022-03-26 07:24:23', false, '2022-08-07 08:05:25', 9, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non mattis pulvinar', 'sapien varius ut blandit', '2019-10-27 06:36:20', null, false, '2020-06-29 20:19:29', 73, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'quisque', 'eros suspendisse accumsan tortor quis turpis', '2019-04-26 01:10:45', '2021-05-30 17:33:52', false, null, 94, 20, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consectetuer adipiscing', 'pellentesque ultrices mattis odio donec vitae nisi nam', '2019-05-28 11:09:32', null, true, '2020-06-26 18:12:55', 52, 25, 2);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eget massa tempor', 'in imperdiet et commodo vulputate justo in blandit', '2019-09-03 07:34:02', '2022-12-16 23:56:38', false, '2021-03-08 08:22:35', 77, 6, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum', 'sapien cum sociis natoque penatibus et magnis dis', '2020-02-12 22:54:26', null, false, '2020-12-19 23:50:50', 66, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'blandit nam nulla', 'erat curabitur gravida nisi at nibh in', '2020-01-25 00:58:58', null, true, null, 11, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'molestie lorem quisque', 'fermentum donec ut mauris eget', '2020-03-01 17:42:23', null, false, null, 88, 13, 16);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'porttitor pede', 'sapien a libero', '2019-06-26 03:24:50', null, false, null, 98, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'erat fermentum justo', 'faucibus orci luctus et ultrices posuere cubilia', '2019-04-11 05:42:51', null, false, null, 17, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'urna pretium nisl', 'nisi vulputate nonummy maecenas tincidunt lacus', '2019-08-15 18:20:28', null, false, null, 88, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tincidunt eu felis', 'gravida nisi at', '2019-09-15 14:55:21', null, true, null, 75, 3, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'arcu', 'penatibus et magnis dis parturient', '2019-04-24 22:26:39', '2020-10-12 11:58:45', false, null, 34, 19, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'condimentum id luctus', 'donec odio justo sollicitudin', '2019-05-15 03:07:39', null, false, null, 57, 2, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisi vulputate', 'aliquet ultrices erat tortor sollicitudin mi', '2019-10-05 17:43:20', null, true, '2020-08-20 23:36:02', 84, 27, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'fermentum donec ut', 'cubilia curae nulla', '2020-01-08 07:56:46', null, false, null, 49, 23, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ante ipsum', 'quisque arcu libero rutrum ac lobortis vel', '2019-11-30 20:25:14', null, false, null, 37, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'accumsan tellus nisi', 'elit proin risus praesent lectus vestibulum quam', '2019-05-08 11:19:09', '2020-08-08 00:35:47', false, null, 85, 4, 25);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tortor eu', 'pede venenatis non sodales sed tincidunt eu felis', '2020-03-21 15:57:59', null, true, null, 17, 7, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dolor', 'est phasellus sit amet erat', '2019-07-01 03:16:28', null, true, null, 5, 27, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec dui luctus', 'ante nulla', '2019-09-24 21:32:44', null, false, null, 65, 22, 16);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tellus in', 'dignissim vestibulum vestibulum ante ipsum', '2019-07-25 11:14:14', null, true, null, 56, 6, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in ante', 'id consequat in consequat ut nulla sed', '2019-11-25 13:57:13', null, false, null, 77, 24, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus', 'venenatis tristique fusce congue diam id ornare imperdiet', '2019-08-08 09:53:06', null, true, null, 100, 27, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id', 'turpis nec euismod scelerisque quam', '2019-04-05 07:46:32', '2022-03-28 02:53:57', true, '2020-12-28 16:39:23', 5, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lacinia aenean', 'aliquam augue quam sollicitudin vitae', '2020-03-03 04:35:40', null, true, null, 54, 20, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'justo', 'ut suscipit a feugiat et', '2020-03-12 15:43:01', null, false, '2021-05-16 06:39:55', 23, 10, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel', 'elit sodales scelerisque mauris sit amet eros', '2020-01-01 17:21:27', '2021-07-14 15:11:57', true, null, 49, 18, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in hac habitasse', 'risus praesent lectus', '2020-02-17 02:29:52', null, false, '2021-03-13 09:06:36', 10, 9, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum', 'posuere metus vitae', '2020-02-29 23:26:26', '2020-12-03 05:38:41', false, null, 23, 5, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in', 'est et tempus semper est quam pharetra magna', '2019-11-05 12:20:38', null, true, null, 77, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mauris ullamcorper purus', 'volutpat eleifend donec ut', '2020-02-11 02:07:38', null, false, null, 49, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed', 'semper est quam pharetra magna ac consequat', '2019-09-01 21:20:13', null, false, null, 77, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'integer non', 'nisl duis ac nibh fusce', '2019-06-27 05:49:19', null, true, '2022-06-10 12:07:36', 87, 7, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'cursus', 'sed justo pellentesque viverra pede ac', '2020-03-24 11:21:17', null, true, null, 59, 30, 15);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'fusce posuere', 'vestibulum ante ipsum primis in faucibus orci luctus', '2019-12-19 12:43:11', null, false, null, 84, 29, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'eu sapien cursus', 'nascetur ridiculus mus etiam vel', '2019-08-28 04:23:31', null, false, null, 62, 27, 26);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mus vivamus', 'viverra dapibus', '2020-03-20 22:13:15', null, false, null, 75, 23, 2);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ante nulla justo', 'amet nunc viverra dapibus nulla suscipit ligula', '2019-06-02 06:50:19', null, true, '2021-10-09 01:50:06', 15, 5, 16);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'rhoncus dui vel', 'in quam fringilla rhoncus mauris enim leo', '2020-01-30 15:07:45', null, true, null, 43, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'donec posuere metus', 'sapien non mi integer ac neque duis', '2020-02-09 02:45:35', '2022-05-06 15:06:48', true, null, 39, 26, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non', 'nisl ut volutpat sapien arcu', '2019-10-27 20:11:01', '2023-03-26 15:01:56', false, null, 8, 29, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dui luctus', 'quis lectus suspendisse potenti in', '2020-01-14 00:47:08', '2021-07-24 19:41:44', false, null, 33, 22, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'a ipsum', 'faucibus orci luctus', '2019-09-02 18:55:40', '2023-02-18 21:17:05', true, '2021-06-27 22:30:00', 62, 15, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'auctor gravida sem', 'tellus nulla ut', '2019-09-03 20:57:00', null, false, null, 13, 27, 14);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'elementum eu interdum', 'lectus in est risus auctor sed tristique in', '2019-05-19 12:33:38', null, false, null, 61, 23, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sagittis nam congue', 'fermentum donec', '2020-03-15 10:34:57', null, false, '2022-12-01 15:13:21', 49, 20, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'congue', 'iaculis diam erat fermentum justo', '2019-07-26 14:07:07', null, true, null, 88, 29, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'massa donec', 'diam id ornare', '2019-06-13 03:57:55', null, true, null, 6, 28, 4);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'justo', 'posuere cubilia', '2020-01-09 13:14:22', '2022-09-13 13:57:06', false, null, 53, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lectus', 'at dolor quis odio consequat varius integer ac', '2019-07-04 22:31:22', '2022-06-13 21:04:08', true, null, 79, 20, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'imperdiet et', 'amet consectetuer adipiscing elit proin risus praesent', '2019-06-16 18:47:36', null, false, '2020-09-30 21:05:17', 96, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'maecenas', 'pede lobortis ligula', '2019-05-07 04:07:20', null, false, '2022-12-18 20:03:40', 49, 6, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tortor eu pede', 'lectus pellentesque', '2019-04-10 09:40:48', null, false, null, 8, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'maecenas', 'dui luctus rutrum nulla tellus in sagittis', '2019-08-27 09:57:59', null, true, null, 14, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'urna pretium', 'integer ac neque duis bibendum morbi', '2019-06-09 00:16:59', null, true, '2020-06-11 13:53:04', 76, 11, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien', 'vel nisl', '2019-06-20 10:13:23', null, true, null, 34, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel', 'semper sapien a libero', '2019-04-05 20:54:46', '2021-08-22 02:05:04', true, null, 96, 13, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'diam vitae', 'quam pede lobortis ligula sit', '2019-10-01 10:20:22', null, true, null, 13, 23, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mi', 'rutrum neque aenean auctor gravida sem', '2020-01-12 18:28:39', null, true, null, 34, 27, 13);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vivamus in felis', 'platea dictumst aliquam augue quam', '2019-08-14 00:18:00', '2020-10-20 08:44:30', true, '2023-03-25 06:28:17', 41, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut suscipit', 'enim in tempor turpis nec', '2019-11-15 03:47:43', null, false, '2021-12-15 13:01:10', 33, 25, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lectus', 'nam ultrices libero non mattis pulvinar nulla', '2019-05-30 18:59:56', null, true, '2022-04-21 02:47:59', 90, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'molestie', 'arcu adipiscing molestie', '2019-05-17 03:42:19', null, true, null, 84, 15, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempor', 'tincidunt nulla mollis molestie lorem quisque', '2019-12-29 05:04:05', null, false, null, 60, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'congue elementum', 'nulla ut erat id mauris vulputate elementum', '2019-05-09 15:32:31', null, false, null, 97, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien varius ut', 'accumsan odio', '2019-11-02 09:29:41', null, false, '2023-03-29 14:45:32', 51, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'a ipsum', 'vulputate justo', '2020-01-25 01:51:26', null, false, '2022-10-24 21:11:25', 94, 18, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'facilisi cras non', 'mus etiam vel', '2019-06-29 15:22:23', null, false, null, 52, 4, 15);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum ante', 'tristique est et tempus semper est quam pharetra', '2019-11-20 18:50:28', null, false, '2021-10-13 09:44:33', 71, 15, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'et eros vestibulum', 'aliquam convallis', '2020-03-13 11:57:23', '2021-03-31 13:07:01', true, null, 59, 28, 2);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed interdum venenatis', 'ipsum integer a nibh in quis justo maecenas', '2020-01-03 12:40:38', null, true, null, 14, 13, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla ut erat', 'elit proin risus praesent lectus', '2020-01-08 19:59:29', null, false, '2020-07-31 05:34:10', 100, 27, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'augue', 'lorem id ligula suspendisse ornare consequat lectus in', '2019-07-10 01:51:35', '2023-01-05 12:38:34', false, null, 17, 12, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tincidunt nulla', 'mus etiam vel augue vestibulum rutrum rutrum neque', '2019-03-30 08:49:56', null, false, null, 66, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'viverra eget', 'mi integer ac neque duis bibendum morbi', '2019-10-07 08:16:18', null, true, null, 86, 1, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'convallis duis consequat', 'sed ante vivamus', '2019-10-20 13:17:12', null, false, null, 88, 23, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'massa id nisl', 'pharetra magna ac', '2019-10-01 15:26:38', null, false, '2020-06-23 20:26:18', 31, 19, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dapibus nulla suscipit', 'ante vestibulum ante ipsum primis in', '2019-09-12 13:39:34', '2022-09-25 08:55:09', false, null, 63, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'potenti in', 'erat quisque erat', '2019-08-10 14:42:25', null, false, null, 53, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'aenean sit amet', 'justo in hac habitasse', '2019-06-30 01:12:01', null, false, null, 81, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec', 'vivamus vel nulla eget eros elementum pellentesque', '2019-06-19 10:35:46', null, true, null, 70, 17, 4);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'posuere cubilia curae', 'accumsan tortor quis turpis sed ante', '2019-11-10 11:51:05', null, false, null, 43, 13, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'erat id mauris', 'quis lectus suspendisse potenti in eleifend quam', '2019-06-22 01:28:39', null, false, null, 26, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'rhoncus aliquet pulvinar', 'nulla mollis molestie lorem quisque', '2020-03-02 14:50:14', null, true, null, 19, 14, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempus vel pede', 'eget rutrum', '2020-02-09 14:14:56', null, true, null, 91, 23, 13);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'congue etiam justo', 'erat fermentum justo nec condimentum', '2019-05-25 00:07:30', null, false, null, 26, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'erat tortor sollicitudin', 'nunc commodo placerat praesent blandit nam nulla', '2019-06-10 00:36:07', '2022-01-06 14:39:03', false, null, 75, 13, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'habitasse platea', 'consequat varius integer', '2019-06-24 16:24:50', null, true, '2021-03-10 01:08:11', 9, 6, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'curabitur gravida', 'non velit', '2020-03-14 03:32:19', null, false, null, 59, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien', 'vel accumsan', '2019-08-09 23:50:03', null, false, null, 11, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tincidunt', 'sociis natoque', '2019-09-09 19:40:42', null, true, null, 90, 24, 12);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'aliquet', 'amet justo morbi ut odio', '2019-03-30 18:00:19', null, false, '2022-09-27 18:04:14', 91, 6, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'elit proin', 'molestie sed justo pellentesque', '2019-12-18 20:33:16', null, true, null, 87, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut dolor', 'sed vestibulum sit amet cursus id turpis', '2019-10-26 23:52:00', null, true, null, 95, 6, 18);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'molestie sed justo', 'est lacinia nisi venenatis tristique fusce congue', '2019-08-10 14:58:13', null, false, null, 40, 22, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'amet', 'platea dictumst etiam faucibus cursus urna ut', '2020-03-25 16:52:40', null, true, null, 69, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'platea dictumst aliquam', 'in hac habitasse', '2020-02-01 18:32:43', null, false, '2022-07-06 04:19:36', 75, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nullam molestie nibh', 'luctus cum sociis natoque penatibus', '2019-11-07 07:28:13', '2020-12-08 21:26:58', true, '2022-02-03 00:07:58', 33, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'risus dapibus', 'etiam vel augue vestibulum rutrum rutrum', '2019-10-29 00:40:37', null, true, null, 61, 17, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'semper rutrum nulla', 'faucibus orci luctus et', '2019-10-20 16:01:48', null, false, '2020-10-02 14:02:21', 13, 27, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'integer', 'tortor id nulla ultrices aliquet maecenas leo odio', '2019-08-01 11:03:09', null, true, null, 16, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non mattis pulvinar', 'sed vel', '2020-01-12 03:26:00', '2021-04-22 02:38:07', false, '2021-09-08 16:29:31', 76, 23, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'faucibus', 'augue luctus tincidunt nulla', '2019-12-01 07:54:00', null, false, null, 62, 1, 12);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi porttitor lorem', 'luctus et ultrices posuere cubilia', '2019-06-28 00:19:59', '2021-07-15 01:00:17', false, '2022-03-20 14:27:15', 16, 13, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vel', 'elit sodales scelerisque mauris sit amet eros suspendisse', '2019-07-21 04:51:50', null, true, null, 17, 13, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'velit vivamus vel', 'erat fermentum justo nec', '2019-08-28 23:06:33', '2021-02-16 23:05:11', false, null, 59, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ante', 'integer non velit', '2019-04-28 18:50:06', null, false, null, 50, 23, 18);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lorem ipsum', 'eget elit sodales', '2019-08-10 05:51:59', null, false, null, 34, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'etiam pretium', 'ut erat', '2019-08-20 20:40:37', '2020-09-09 18:21:21', true, null, 93, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vulputate ut ultrices', 'donec pharetra magna vestibulum aliquet ultrices erat tortor', '2019-12-22 20:08:10', '2021-06-23 19:45:04', false, null, 65, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'hendrerit at', 'non pretium quis lectus suspendisse', '2019-11-18 21:02:16', null, true, null, 79, 13, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'penatibus', 'pellentesque at nulla suspendisse potenti', '2019-04-27 16:55:10', null, false, '2020-04-20 20:04:26', 30, 20, 2);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'integer non', 'elit proin', '2019-10-01 10:01:16', null, true, null, 13, 23, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'turpis a', 'id lobortis convallis tortor risus dapibus', '2020-01-25 07:19:32', null, true, null, 33, 29, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ut massa volutpat', 'aliquam convallis nunc', '2019-12-17 15:00:54', null, false, '2020-07-26 23:03:07', 19, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at lorem', 'amet erat nulla tempus vivamus', '2019-04-16 20:24:13', null, true, '2022-01-08 20:14:47', 83, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mauris non ligula', 'feugiat non pretium quis lectus suspendisse potenti in', '2019-08-04 22:58:18', null, true, null, 20, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'phasellus id sapien', 'justo in blandit ultrices enim lorem ipsum', '2019-05-08 19:31:07', '2022-10-26 15:32:06', true, '2020-11-12 16:57:35', 63, 28, 4);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla nisl nunc', 'nonummy maecenas tincidunt lacus at', '2019-10-23 06:28:05', null, true, null, 22, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi quis', 'quis augue luctus tincidunt', '2019-06-11 11:27:27', null, true, null, 59, 5, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'iaculis justo', 'odio cras mi pede', '2020-01-04 21:42:25', null, true, null, 41, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'duis', 'ac leo pellentesque ultrices mattis odio donec vitae', '2020-03-15 09:28:56', null, false, null, 75, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lacinia erat', 'nibh in', '2020-03-18 05:10:34', null, false, null, 51, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'parturient', 'dignissim vestibulum vestibulum ante', '2019-08-16 06:52:52', null, true, null, 55, 4, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'justo sollicitudin ut', 'sociis natoque penatibus', '2019-06-02 18:19:36', null, false, null, 1, 9, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nisi at nibh', 'nisl nunc rhoncus dui', '2019-05-18 00:08:22', null, false, null, 56, 9, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non velit', 'curabitur in libero ut massa', '2019-10-08 08:40:05', '2022-11-04 09:31:08', true, null, 13, 30, 27);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sollicitudin', 'consequat in consequat ut nulla', '2019-11-09 04:42:23', null, false, null, 91, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'proin', 'metus sapien ut nunc vestibulum ante', '2019-06-14 03:28:57', null, true, null, 92, 27, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tortor duis', 'curabitur convallis duis consequat dui', '2019-08-24 00:06:48', null, true, '2020-08-11 05:34:37', 38, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'suspendisse', 'sapien iaculis', '2019-08-08 20:21:55', null, false, null, 33, 25, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vehicula condimentum', 'aliquet ultrices erat', '2020-03-26 19:24:50', null, true, null, 78, 27, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'egestas metus aenean', 'malesuada in imperdiet et commodo', '2020-02-11 16:54:49', null, false, '2021-06-28 05:48:36', 6, 26, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vehicula consequat', 'fusce consequat nulla nisl nunc nisl duis', '2019-05-19 13:01:53', null, true, null, 87, 29, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pellentesque ultrices phasellus', 'ultrices aliquet', '2019-08-11 21:47:27', null, false, null, 41, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'suspendisse potenti', 'primis in faucibus', '2019-08-09 12:03:08', null, false, null, 24, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'cubilia curae', 'ac nulla sed vel enim sit amet nunc', '2019-10-28 17:36:59', null, false, null, 100, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'metus sapien', 'neque duis bibendum morbi', '2019-08-03 07:09:10', null, true, null, 20, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in', 'quam pharetra magna ac consequat metus', '2019-07-25 11:31:12', null, false, null, 93, 16, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'duis', 'lectus vestibulum quam', '2020-02-28 08:06:38', '2021-03-13 22:57:10', false, '2020-07-26 14:49:08', 21, 24, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pulvinar', 'sapien varius ut blandit non interdum in ante', '2019-08-23 04:01:16', null, false, null, 48, 15, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'duis faucibus accumsan', 'erat fermentum justo nec condimentum', '2019-06-15 10:16:22', null, true, null, 35, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'suscipit nulla elit', 'elit proin risus', '2019-06-19 08:52:26', null, true, null, 18, 26, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'donec', 'amet erat nulla tempus', '2019-04-02 12:44:43', null, false, null, 98, 4, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec', 'nullam sit amet', '2019-05-21 16:45:56', null, true, null, 27, 13, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum primis in', 'orci vehicula', '2019-06-13 08:20:57', null, false, '2021-05-01 10:12:52', 30, 8, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ipsum', 'sapien cursus vestibulum', '2019-07-03 04:23:31', '2022-04-21 20:46:43', true, null, 12, 22, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in', 'risus semper porta volutpat', '2020-02-06 20:26:33', null, false, null, 70, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tortor id', 'diam vitae quam', '2019-12-30 16:19:11', '2022-09-09 19:37:30', false, null, 44, 12, 13);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'proin', 'lobortis est phasellus', '2019-05-15 01:08:57', '2021-03-27 22:33:20', true, null, 27, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'potenti in', 'massa quis augue luctus tincidunt nulla mollis molestie', '2019-06-29 20:10:57', '2022-07-30 12:43:37', false, null, 27, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mauris ullamcorper', 'odio consequat varius integer ac', '2019-11-29 16:55:55', '2020-11-21 04:30:24', true, null, 91, 18, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'libero nam dui', 'tortor risus', '2019-09-27 14:23:27', null, true, '2022-06-19 12:31:47', 63, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sapien arcu sed', 'phasellus in', '2019-06-05 23:29:19', '2022-06-10 18:38:45', false, null, 55, 27, 5);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'libero nam dui', 'et ultrices posuere cubilia curae mauris viverra diam', '2019-04-02 18:48:06', null, true, null, 91, 10, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'proin at turpis', 'quis tortor id nulla ultrices', '2019-08-29 00:34:27', '2023-02-02 01:05:10', false, null, 88, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla mollis', 'venenatis non sodales sed tincidunt', '2019-12-24 19:53:25', null, false, '2022-12-10 09:37:51', 47, 24, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla sed', 'sapien urna pretium nisl', '2019-11-03 00:25:52', '2020-09-22 18:11:18', true, '2020-12-14 17:08:09', 78, 23, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'non', 'lacinia erat vestibulum sed magna at nunc commodo', '2019-08-22 22:56:21', '2022-06-17 10:36:02', false, '2022-01-03 23:48:57', 32, 14, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempor', 'nam dui proin leo odio porttitor', '2019-08-27 09:02:12', null, true, null, 12, 19, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sollicitudin ut', 'urna ut tellus nulla ut', '2020-03-25 09:48:47', '2022-06-21 16:48:30', true, null, 95, 7, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vulputate ut ultrices', 'sapien in sapien iaculis congue vivamus', '2019-10-31 20:00:25', null, false, null, 2, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tortor', 'quis libero nullam sit amet turpis', '2019-03-31 11:13:34', null, true, null, 56, 29, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'iaculis', 'non interdum in ante vestibulum ante ipsum primis', '2019-07-19 21:09:07', null, false, null, 13, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'venenatis tristique', 'ligula suspendisse ornare consequat lectus in est risus', '2020-03-14 18:38:36', null, true, null, 28, 5, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'praesent', 'nulla justo aliquam quis turpis eget elit', '2019-10-05 03:39:26', null, false, '2020-09-14 15:05:29', 53, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in blandit', 'aliquet ultrices erat tortor sollicitudin mi sit', '2019-06-18 13:42:07', '2021-10-17 08:25:55', false, null, 6, 6, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in faucibus', 'ut massa volutpat convallis morbi', '2019-08-04 17:18:46', '2020-07-08 08:22:25', false, null, 14, 21, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'purus eu', 'a pede', '2019-10-06 15:41:26', null, false, null, 39, 28, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'consequat ut', 'magnis dis parturient montes nascetur ridiculus mus', '2019-07-05 06:19:02', null, true, null, 43, 27, 17);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'molestie lorem quisque', 'erat eros viverra eget congue eget semper', '2019-06-07 07:04:45', null, false, null, 32, 12, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec nisi vulputate', 'dictumst morbi vestibulum velit id pretium iaculis diam', '2019-06-02 01:48:47', null, true, null, 76, 2, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'ultrices enim', 'pede morbi porttitor lorem id ligula suspendisse', '2019-10-07 05:04:03', null, false, null, 83, 14, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lorem ipsum', 'justo morbi ut odio cras', '2020-03-13 16:47:39', '2022-01-05 14:12:08', false, null, 71, 2, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'amet', 'orci mauris', '2019-11-17 14:31:59', null, false, null, 93, 26, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sodales sed', 'consequat varius integer ac', '2019-09-08 22:21:59', null, true, null, 83, 27, 1);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'malesuada in imperdiet', 'odio in hac habitasse platea', '2019-12-12 22:26:51', null, true, null, 85, 1, 12);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vehicula', 'donec ut dolor morbi vel lectus in', '2019-06-04 03:02:59', null, true, null, 8, 10, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'massa', 'erat id mauris vulputate', '2020-01-25 12:19:38', null, true, null, 32, 4, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'vestibulum', 'nam dui proin leo odio', '2019-12-13 15:15:47', null, false, null, 89, 20, 8);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'at vulputate', 'sapien placerat ante nulla justo aliquam quis', '2019-12-10 19:56:59', null, true, null, 99, 7, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'bibendum imperdiet', 'odio cras mi pede', '2019-07-16 22:02:51', null, true, null, 45, 6, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'accumsan felis ut', 'consectetuer adipiscing elit proin risus praesent lectus', '2019-09-30 14:34:04', null, true, null, 46, 12, 29);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi sem mauris', 'blandit non interdum in ante vestibulum', '2019-12-05 08:17:01', null, true, '2021-06-05 19:30:17', 17, 27, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lobortis', 'hac habitasse platea dictumst', '2020-02-08 09:39:33', '2020-08-01 05:04:44', false, null, 21, 23, 21);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'risus dapibus', 'dictumst morbi vestibulum velit', '2019-12-21 14:48:05', null, false, '2020-07-14 07:16:00', 14, 30, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'libero non mattis', 'augue vel accumsan tellus nisi eu orci mauris', '2019-08-31 20:12:29', null, true, '2022-12-05 12:01:11', 24, 4, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla', 'curabitur convallis duis consequat dui', '2020-02-12 09:23:47', '2022-01-16 08:01:56', true, null, 81, 22, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dapibus', 'nulla suspendisse', '2019-04-18 10:42:02', null, false, null, 90, 4, 22);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'proin', 'dapibus duis at velit eu', '2019-05-31 22:28:55', null, false, null, 43, 4, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in blandit', 'lacinia nisi venenatis tristique fusce congue diam id', '2020-02-11 14:43:25', null, false, null, 84, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'viverra eget congue', 'ipsum primis in', '2019-07-05 00:05:08', null, false, '2023-02-25 07:55:51', 61, 18, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nunc donec', 'pede justo eu massa', '2019-07-15 18:10:52', '2021-02-08 04:18:17', true, null, 49, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'mauris', 'morbi sem', '2019-11-19 14:04:51', null, true, null, 94, 24, 23);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'a', 'ipsum primis', '2019-05-07 20:50:20', null, true, null, 84, 10, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id nisl', 'pede justo lacinia eget tincidunt eget', '2019-08-19 00:36:34', null, false, '2021-02-06 15:13:45', 2, 28, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nulla justo aliquam', 'vestibulum rutrum rutrum neque aenean auctor gravida', '2019-08-19 00:58:25', null, false, null, 46, 9, 10);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'lacinia', 'ut ultrices vel augue vestibulum ante ipsum', '2019-12-29 21:40:27', null, true, '2022-04-16 00:57:37', 40, 21, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nibh in quis', 'amet cursus id turpis integer aliquet massa', '2020-01-18 17:38:19', null, true, '2023-01-25 13:08:41', 78, 3, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'odio', 'habitasse platea', '2019-07-17 00:48:31', null, false, null, 13, 5, 28);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'aenean', 'eros vestibulum ac est lacinia', '2019-10-13 06:46:29', null, true, null, 60, 4, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tellus nisi eu', 'erat volutpat in congue etiam', '2020-01-13 14:10:04', null, false, '2020-10-24 12:52:57', 90, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi vel', 'sed tristique in', '2019-08-26 09:32:31', null, true, null, 88, 13, 24);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'dui luctus rutrum', 'velit eu est congue elementum in', '2019-11-12 20:16:03', null, false, null, 95, 15, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'in', 'nibh fusce lacus', '2019-05-30 18:37:53', null, true, null, 25, 20, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'etiam pretium', 'erat tortor sollicitudin mi sit amet lobortis', '2019-04-13 11:30:06', null, false, '2021-02-02 16:26:11', 28, 6, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'tempor turpis', 'erat quisque', '2019-05-20 09:19:34', null, true, null, 4, 17, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'arcu', 'ut blandit non interdum in', '2020-02-21 17:10:01', '2021-03-24 03:59:28', false, null, 37, 9, 26);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'magna ac', 'felis donec', '2019-09-08 04:12:45', null, false, null, 98, 16, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'pulvinar nulla pede', 'congue eget semper rutrum', '2020-01-28 00:17:35', null, true, null, 22, 4, 19);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nam dui proin', 'proin leo', '2020-02-06 02:25:17', '2022-04-17 16:40:20', true, '2021-11-27 13:27:03', 30, 29, 20);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nec molestie sed', 'elit proin interdum mauris non', '2019-10-29 07:34:55', '2022-02-26 14:12:58', true, null, 44, 15, 6);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'velit eu', 'interdum mauris', '2020-03-11 23:46:34', null, false, null, 99, 8, 7);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'sed vestibulum', 'ac nulla sed', '2019-12-01 21:56:45', null, false, null, 62, 29, 9);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'morbi porttitor lorem', 'convallis nunc proin at turpis a pede posuere', '2019-10-10 13:38:16', null, true, null, 63, 5, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'praesent blandit nam', 'luctus et ultrices posuere cubilia curae duis', '2019-12-21 06:52:27', null, true, null, 97, 4, 11);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'turpis', 'dapibus augue', '2020-01-10 14:04:26', null, true, '2022-02-22 23:43:13', 95, 26, 3);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'nascetur', 'sed accumsan felis ut at', '2020-02-19 12:21:03', null, true, null, 38, 9, null);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'amet sem', 'tortor eu pede', '2019-12-14 10:47:54', null, true, null, 50, 3, 30);
insert into issue (id, name, description, creation_date, due_date, is_completed, closed_date, issue_list_id, author_id, complete_id) values (DEFAULT, 'id luctus nec', 'sem mauris laoreet', '2020-03-06 13:28:37', null, true, null, 27, 25, null);

insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'congue eget semper rutrum nulla', '2019-04-01 14:22:36', 456, 12);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'etiam justo etiam', '2019-12-08 07:03:27', 456, 4);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi', '2019-10-22 02:40:57', 137, 1);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio', '2019-08-29 01:23:28', 170, 3);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'quam a odio in hac habitasse', '2020-02-13 01:07:48', 295, 2);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor', '2019-07-19 02:17:01', 77, 27);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'non sodales sed tincidunt eu felis fusce posuere', '2019-05-10 20:23:31', 125, 24);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus', '2019-04-28 12:28:09', 77, 21);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros', '2019-07-24 07:41:56', 94, 9);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent', '2019-11-08 13:07:44', 169, 11);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend', '2019-03-28 14:05:48', 102, 13);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', '2019-06-17 13:22:02', 268, 19);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla', '2019-10-31 02:46:43', 55, 20);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea', '2020-03-02 08:08:49', 451, 23);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'pretium nisl ut volutpat sapien arcu sed augue aliquam', '2019-05-16 07:23:09', 290, 2);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'duis mattis egestas metus aenean', '2020-03-17 06:57:57', 153, 25);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'aenean auctor gravida sem praesent id massa id', '2019-07-13 03:37:12', 213, 13);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque', '2019-08-15 22:44:56', 338, 5);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate', '2019-05-18 09:07:03', 360, 9);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus', '2019-12-27 00:12:54', 365, 24);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'dapibus nulla', '2020-01-16 04:16:27', 407, 12);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', '2020-03-14 23:11:17', 479, 10);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros', '2019-05-10 17:34:35', 16, 7);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh', '2019-08-28 10:59:29', 451, 2);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl', '2020-01-05 14:53:26', 239, 6);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus', '2019-12-25 09:37:57', 496, 14);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis', '2019-04-28 11:56:42', 165, 4);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo', '2019-11-29 14:49:39', 31, 8);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'in faucibus orci luctus et ultrices posuere', '2019-05-05 23:42:53', 481, 15);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem', '2020-03-11 12:23:41', 484, 14);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sit amet lobortis sapien sapien non mi integer ac neque duis', '2019-03-31 00:17:59', 384, 3);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum', '2019-09-17 17:41:35', 198, 12);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'erat id mauris vulputate elementum nullam varius nulla facilisi', '2019-08-15 08:34:34', 21, 26);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede', '2020-03-25 11:51:20', 411, 15);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'vel nulla eget eros elementum pellentesque quisque porta volutpat', '2019-04-25 06:52:39', 163, 18);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'porta volutpat erat quisque erat eros viverra eget congue eget', '2019-09-17 08:55:35', 264, 1);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla', '2020-01-02 05:12:13', 183, 12);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam', '2019-07-01 19:02:07', 33, 16);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate', '2019-07-22 05:28:42', 292, 30);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus', '2020-03-07 15:05:32', 258, 5);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'dolor vel est donec', '2019-04-25 18:07:16', 359, 13);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse', '2019-11-04 11:25:02', 409, 27);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'vestibulum vestibulum ante ipsum primis in faucibus orci', '2019-05-12 12:00:40', 352, 15);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi', '2020-02-20 10:51:25', 175, 22);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede', '2019-10-25 15:01:49', 385, 17);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero', '2019-10-21 02:35:50', 82, 18);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus', '2020-02-26 17:12:39', 64, 25);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis', '2019-04-09 04:46:23', 147, 29);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo', '2019-12-31 19:54:13', 493, 22);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'aliquet maecenas leo odio condimentum id', '2020-02-25 03:07:54', 423, 30);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'ligula in lacus', '2020-02-06 12:44:47', 211, 6);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus', '2019-11-12 18:17:39', 277, 24);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum', '2019-06-12 10:09:42', 230, 25);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis', '2019-06-17 22:43:04', 27, 2);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien', '2019-09-07 14:53:26', 263, 29);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare', '2019-08-22 12:46:29', 111, 14);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet', '2019-04-06 23:51:12', 323, 11);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et', '2019-09-08 01:10:36', 376, 5);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'et magnis dis parturient montes nascetur', '2019-06-23 15:17:44', 310, 28);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel', '2019-07-14 23:02:05', 416, 23);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam', '2019-11-24 07:07:45', 261, 19);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'est donec odio justo sollicitudin ut suscipit a feugiat et', '2019-08-23 03:59:42', 169, 25);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', '2019-11-14 00:04:10', 76, 1);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum', '2020-02-19 06:20:37', 215, 5);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'accumsan tellus nisi eu orci mauris lacinia sapien quis', '2019-06-20 00:23:47', 157, 22);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae mauris', '2019-10-20 08:58:47', 100, 12);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla', '2019-12-06 19:43:49', 243, 4);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida', '2019-06-22 23:54:03', 118, 8);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio', '2019-12-06 03:46:33', 446, 18);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'vulputate justo in blandit ultrices enim', '2019-10-13 10:00:24', 393, 21);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci', '2019-05-21 15:09:52', 369, 21);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas', '2019-04-20 00:27:08', 58, 6);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'elit proin', '2019-09-19 16:52:30', 69, 8);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero', '2020-01-17 11:48:10', 365, 9);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque', '2019-05-05 05:34:15', 481, 24);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non', '2019-07-06 01:18:12', 355, 13);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'non ligula', '2020-02-14 10:57:44', 400, 6);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc', '2019-04-26 04:22:02', 283, 19);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', '2019-10-24 22:43:38', 99, 9);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris', '2019-11-30 17:50:41', 417, 20);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque', '2019-07-22 12:28:10', 370, 14);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'posuere cubilia curae nulla dapibus dolor vel est donec odio', '2019-12-22 13:32:05', 482, 5);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', '2019-05-04 23:51:34', 137, 9);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit', '2019-12-11 08:05:11', 48, 16);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'at velit eu est congue elementum in hac habitasse platea', '2019-11-07 17:14:09', 450, 9);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer', '2020-02-19 18:13:40', 456, 30);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', '2019-05-09 15:22:12', 375, 2);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus', '2019-08-21 02:03:29', 486, 7);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'leo odio porttitor id consequat in consequat ut', '2019-10-29 20:40:44', 352, 2);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus', '2019-07-22 10:11:40', 118, 7);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien', '2019-06-18 07:34:57', 317, 11);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare', '2019-11-18 22:08:50', 349, 13);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris', '2019-11-07 14:04:40', 147, 28);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'imperdiet nullam orci pede venenatis non', '2019-04-13 04:51:16', 263, 6);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat', '2019-08-26 08:04:02', 160, 26);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio', '2019-04-05 02:56:46', 350, 28);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum', '2019-07-08 19:58:29', 296, 1);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'aliquam erat volutpat in congue etiam justo', '2019-10-23 19:53:56', 154, 10);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis', '2019-08-11 18:55:07', 344, 26);
insert into "comment" (id, content, creation_date, issue_id, user_id) values (DEFAULT, 'bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit', '2020-03-09 07:40:21', 377, 7);

insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ac consequat', 'penatibus et magnis dis parturient', '2019-05-21 23:12:13', 15);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'tristique tortor', 'at dolor quis odio consequat varius integer', '2019-08-18 12:22:06', 35);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'quisque ut erat', 'ipsum primis in faucibus orci', '2019-10-30 09:47:15', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ac', 'massa id lobortis convallis tortor risus', '2020-01-13 04:47:55', 1);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'curae nulla dapibus', 'diam id ornare imperdiet', '2019-11-08 15:36:01', 1);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ipsum', 'bibendum felis sed interdum venenatis', '2019-07-23 16:30:04', 2);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'lacus morbi sem', 'enim lorem ipsum dolor', '2020-02-02 17:21:28', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'mi integer', 'cubilia curae donec pharetra magna', '2019-05-23 00:28:18', 31);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'pretium', 'ante ipsum primis in', '2019-09-15 17:05:38', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'condimentum neque', 'et eros', '2019-09-28 16:13:59', 50);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'tortor', 'vestibulum proin eu mi nulla', '2019-04-01 23:10:09', 11);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'congue', 'augue vestibulum rutrum rutrum neque', '2019-09-06 15:17:51', 47);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'faucibus orci luctus', 'consequat in consequat', '2019-07-27 03:15:22', 22);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'quam pharetra magna', 'vestibulum vestibulum ante', '2019-09-14 13:26:45', 21);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'cursus id turpis', 'in magna bibendum imperdiet nullam orci', '2020-01-03 10:43:09', 23);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'aliquam lacus morbi', 'quisque porta', '2019-09-17 04:28:25', 11);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'hac habitasse', 'nulla tellus in sagittis dui', '2019-04-23 10:51:02', 40);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'a pede', 'feugiat non pretium quis lectus', '2019-05-27 20:05:10', 3);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'urna', 'proin interdum mauris non ligula pellentesque', '2019-07-31 18:18:03', 6);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'molestie', 'amet turpis elementum', '2019-07-16 15:42:39', 2);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'vel', 'consequat nulla nisl nunc', '2019-09-23 23:58:53', 47);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'massa quis', 'ridiculus mus vivamus vestibulum sagittis sapien cum', '2019-04-11 10:56:16', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'blandit mi in', 'adipiscing elit proin interdum', '2019-09-10 02:52:00', 33);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'augue luctus', 'vel pede morbi porttitor', '2019-07-14 15:40:05', 11);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'rhoncus sed vestibulum', 'iaculis congue vivamus metus', '2019-04-14 00:15:22', 5);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'blandit lacinia erat', 'ultrices vel augue vestibulum ante', '2019-10-19 12:41:00', 42);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'tristique', 'lacus morbi sem mauris laoreet ut', '2019-04-26 11:59:15', 26);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'quisque arcu libero', 'ut erat curabitur gravida', '2019-04-03 11:14:41', 20);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'rhoncus sed', 'tortor quis turpis sed', '2019-10-13 06:01:55', 5);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'suspendisse ornare', 'ut massa quis augue luctus tincidunt nulla', '2019-08-26 04:54:41', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ut erat', 'libero rutrum ac lobortis vel dapibus', '2019-12-12 08:32:25', 38);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'sapien placerat ante', 'integer a nibh in quis', '2020-01-05 21:30:21', 12);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'eleifend quam a', 'imperdiet nullam', '2020-03-11 11:55:17', 49);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'augue vestibulum rutrum', 'libero convallis eget eleifend luctus', '2020-03-11 11:52:47', 32);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'nullam varius', 'nisl venenatis lacinia aenean sit amet justo', '2020-03-29 13:56:33', 1);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'duis', 'ut suscipit a feugiat', '2019-08-17 16:14:49', 36);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'id mauris vulputate', 'suspendisse potenti cras', '2019-11-18 02:57:41', 24);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'sapien varius', 'fusce lacus', '2019-09-02 03:17:06', 21);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'vitae', 'cubilia curae nulla dapibus dolor vel est', '2020-01-19 11:53:51', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'metus sapien ut', 'cursus id turpis', '2019-06-01 15:52:46', 25);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'sit amet eleifend', 'id ligula suspendisse ornare consequat lectus in', '2019-10-05 07:43:54', 41);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'pulvinar sed', 'ante ipsum', '2019-05-25 13:50:04', 33);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ipsum integer', 'tellus nisi eu orci mauris lacinia', '2019-04-14 03:36:33', 40);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'nulla', 'congue eget semper rutrum nulla nunc purus', '2019-10-09 00:41:39', 35);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'mi', 'volutpat convallis morbi odio odio', '2019-09-06 16:13:44', 41);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'turpis', 'vitae mattis nibh', '2020-01-31 07:04:05', 5);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'convallis nulla neque', 'tellus in', '2020-02-27 16:10:53', 46);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ut tellus', 'malesuada in imperdiet et commodo vulputate justo', '2020-03-16 15:20:57', 2);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'in lacus curabitur', 'at velit eu est congue elementum in', '2020-01-02 08:32:35', 41);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'libero ut', 'velit eu', '2019-04-02 20:52:43', 15);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'diam', 'sapien dignissim', '2020-01-23 12:36:59', 24);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'interdum mauris ullamcorper', 'tristique fusce congue diam id ornare', '2020-02-09 16:12:22', 41);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'pede morbi', 'nam nulla integer pede justo lacinia', '2020-01-09 23:30:24', 12);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'neque sapien', 'viverra pede ac diam cras', '2020-01-28 16:57:16', 7);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'turpis nec euismod', 'suspendisse accumsan tortor quis', '2019-04-11 12:00:45', 12);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'mus', 'morbi odio', '2020-02-01 12:11:57', 12);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'id justo', 'tempor turpis nec euismod', '2019-12-26 12:29:06', 18);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'ipsum', 'lacinia aenean sit amet justo morbi ut', '2019-04-05 13:03:33', 23);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'enim', 'porttitor lacus at turpis donec posuere metus', '2019-05-30 21:43:32', 39);
insert into channel (id, name, description, creation_date, project_id) values (DEFAULT, 'pede posuere nonummy', 'porttitor lorem id ligula suspendisse', '2019-08-31 22:43:14', 47);

insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'phasellus in felis', '2017-10-06 07:01:19', 48, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus', '2018-01-21 09:52:46', 56, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante', '2017-10-22 06:01:41', 3, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla', '2017-04-18 05:00:27', 37, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante', '2017-05-15 21:42:32', 19, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet', '2020-01-21 02:19:14', 13, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat in consequat ut nulla sed', '2020-01-28 16:00:02', 19, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula', '2019-01-27 09:33:34', 14, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis', '2019-09-01 18:51:53', 32, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tempus semper est quam pharetra magna ac consequat', '2015-10-30 16:55:08', 25, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam', '2018-11-22 06:05:52', 16, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet', '2017-12-05 18:22:43', 48, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam', '2018-07-03 08:46:02', 29, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquam', '2019-04-09 01:11:33', 43, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus', '2020-03-26 17:19:16', 8, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id', '2019-05-16 15:16:57', 26, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices', '2020-02-25 09:42:10', 29, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus', '2018-11-07 14:55:23', 45, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo', '2018-05-07 22:33:09', 54, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed', '2020-01-26 16:50:05', 45, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien placerat ante nulla justo aliquam quis turpis eget elit', '2017-05-09 23:22:40', 15, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec', '2017-02-09 14:41:33', 53, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lobortis ligula sit amet eleifend pede libero quis', '2018-10-19 00:12:33', 36, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sollicitudin mi sit amet', '2017-05-13 03:16:08', 29, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras', '2019-08-04 02:52:15', 36, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id', '2019-09-18 04:26:37', 33, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci pede venenatis non sodales sed tincidunt eu felis fusce', '2020-03-28 04:14:14', 25, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'curabitur in', '2019-09-11 10:02:40', 38, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mi nulla ac enim in tempor turpis nec euismod scelerisque', '2018-07-22 06:12:00', 12, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac', '2019-05-01 06:25:09', 20, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec', '2018-10-01 08:47:13', 34, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante', '2017-01-17 00:39:47', 44, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat', '2020-03-11 23:27:10', 56, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo', '2019-03-23 10:10:38', 20, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'venenatis turpis enim blandit mi in porttitor pede justo eu massa', '2018-09-14 03:24:08', 40, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'purus eu magna vulputate luctus cum sociis natoque penatibus', '2018-03-15 21:56:25', 41, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim', '2018-05-31 13:40:34', 12, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eleifend donec ut dolor morbi', '2018-06-07 18:00:39', 35, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut mauris', '2019-10-03 20:53:18', 28, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper', '2019-02-13 19:05:25', 4, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh', '2019-05-27 19:56:41', 44, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus ultricies eu nibh quisque id justo sit amet sapien dignissim', '2020-03-13 03:08:10', 40, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis sed interdum venenatis turpis enim blandit mi in porttitor pede', '2019-10-02 04:14:48', 4, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus', '2018-12-12 00:28:30', 39, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus', '2019-12-26 12:20:41', 56, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in', '2019-10-26 16:43:12', 27, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', '2017-12-04 10:53:50', 28, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus et ultrices posuere cubilia curae mauris viverra diam', '2020-01-08 07:42:26', 8, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat', '2015-07-28 11:00:38', 49, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac', '2016-10-29 01:14:33', 58, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede', '2017-01-19 22:30:34', 58, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in porttitor pede justo eu massa', '2018-04-15 13:23:54', 57, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio', '2019-08-31 05:30:01', 57, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquam quis turpis eget elit sodales scelerisque', '2020-03-04 22:17:44', 18, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'maecenas rhoncus', '2018-10-06 04:36:02', 25, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet justo morbi ut odio', '2017-02-24 22:10:45', 14, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit ac nulla sed', '2018-10-08 21:43:47', 20, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum', '2019-12-01 01:27:55', 22, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst', '2019-09-19 15:21:59', 18, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suspendisse ornare consequat lectus in est risus auctor sed', '2018-04-09 20:15:35', 28, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rhoncus', '2017-12-30 23:48:06', 2, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', '2018-03-12 05:39:17', 17, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat', '2019-05-25 06:07:18', 49, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo aliquam quis', '2020-02-10 03:37:54', 40, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis', '2019-10-15 19:39:52', 32, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis sed', '2018-06-25 06:49:25', 47, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris viverra diam vitae quam suspendisse', '2017-05-25 09:45:56', 14, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu', '2017-12-26 20:12:22', 50, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est', '2015-10-07 21:13:35', 58, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est', '2016-12-29 02:25:15', 38, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc donec quis orci eget orci vehicula condimentum', '2016-07-04 09:12:43', 24, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper', '2020-01-08 06:28:23', 13, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper', '2020-01-26 05:23:11', 15, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio', '2020-01-13 20:25:18', 56, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cum sociis natoque penatibus et magnis dis parturient montes nascetur', '2015-06-27 07:28:47', 37, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum', '2019-09-20 08:28:17', 19, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'risus praesent lectus vestibulum quam', '2019-09-04 02:45:43', 23, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'neque', '2019-08-10 06:14:53', 42, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suspendisse potenti in eleifend quam a odio in', '2020-01-15 10:40:01', 24, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula', '2020-01-04 11:18:40', 45, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id', '2019-10-28 04:22:53', 10, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non ligula pellentesque ultrices', '2018-05-30 16:34:44', 53, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh in hac habitasse platea', '2018-12-08 14:10:07', 48, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cras non', '2018-08-02 22:50:22', 4, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'praesent id massa id nisl', '2019-10-01 13:14:13', 47, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan', '2018-11-13 23:26:17', 45, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem', '2017-01-02 12:22:29', 44, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dolor vel est donec odio justo sollicitudin', '2018-10-27 09:58:21', 54, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'placerat', '2020-03-17 09:50:44', 12, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum', '2020-03-30 19:29:47', 29, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh', '2020-01-16 00:53:25', 5, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in sagittis dui vel', '2020-01-19 08:22:01', 14, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla', '2019-01-22 04:45:14', 2, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque ultrices mattis', '2020-03-20 23:01:04', 49, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum primis in faucibus orci luctus et ultrices posuere', '2020-02-25 05:06:55', 9, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac', '2018-06-09 12:57:59', 45, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus', '2017-08-05 00:40:53', 9, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'risus semper porta volutpat quam pede lobortis', '2019-05-02 00:55:01', 30, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'leo rhoncus sed vestibulum sit amet cursus id turpis integer', '2019-10-15 23:08:57', 35, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis turpis sed ante vivamus tortor duis mattis', '2019-06-15 17:59:13', 8, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'primis in faucibus orci luctus et ultrices posuere', '2017-04-12 13:04:59', 45, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'laoreet ut rhoncus', '2018-09-10 05:53:44', 29, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc donec quis orci eget orci vehicula', '2018-08-06 04:50:52', 2, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at', '2020-03-24 04:44:26', 20, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum', '2019-05-09 03:18:01', 32, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem', '2018-01-09 14:45:52', 27, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed', '2020-01-09 20:16:47', 59, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin', '2020-01-09 05:38:32', 59, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel', '2019-12-25 13:51:24', 20, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', '2019-01-31 00:24:11', 44, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum', '2018-12-02 04:16:05', 11, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices', '2019-05-09 00:20:23', 9, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat', '2018-08-18 21:05:53', 56, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus', '2017-05-26 17:20:26', 55, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce', '2017-01-17 23:59:02', 28, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus', '2018-03-30 12:04:36', 28, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a pede posuere nonummy', '2017-11-18 01:39:52', 15, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rhoncus mauris enim', '2018-02-17 11:49:06', 27, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien varius ut blandit non interdum in ante', '2016-03-19 18:19:12', 32, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit sodales scelerisque mauris sit amet eros suspendisse', '2015-03-20 00:24:54', 58, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec', '2015-01-05 08:26:08', 48, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'porttitor pede justo eu massa', '2015-05-21 06:30:22', 40, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet', '2018-01-26 08:24:37', 57, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien non mi integer ac neque duis bibendum morbi non quam', '2017-08-29 18:18:16', 49, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisi venenatis tristique fusce congue', '2018-02-14 21:11:26', 48, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam', '2020-01-18 20:13:25', 18, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo', '2017-12-27 12:08:33', 57, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut', '2020-03-15 02:41:45', 2, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', '2020-01-01 02:20:16', 23, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc', '2017-04-13 05:04:08', 42, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien', '2017-05-23 19:33:07', 45, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus', '2017-01-09 02:01:05', 58, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio', '2019-05-27 19:21:09', 17, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus', '2019-11-29 18:47:57', 38, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent', '2019-10-17 10:25:35', 3, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla mollis molestie lorem quisque ut erat curabitur gravida nisi', '2017-12-15 21:45:21', 32, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus', '2020-03-06 13:10:16', 41, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquet massa id', '2017-01-13 02:32:59', 46, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus', '2019-08-04 13:38:22', 57, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam', '2017-03-16 13:05:21', 14, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum', '2019-06-05 03:46:21', 19, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque', '2019-06-21 12:29:58', 11, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'bibendum felis sed interdum venenatis turpis enim', '2019-07-21 11:55:30', 46, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh', '2018-03-08 16:32:58', 30, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id luctus nec', '2020-03-28 07:05:10', 31, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum primis in faucibus orci luctus', '2017-02-18 13:01:10', 42, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula', '2020-01-21 17:08:15', 25, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa', '2020-01-05 21:44:20', 10, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam', '2017-10-22 12:25:00', 24, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate', '2019-08-25 12:00:56', 15, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'faucibus accumsan odio curabitur convallis', '2019-07-13 02:20:20', 43, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc commodo placerat praesent blandit nam nulla integer pede', '2017-03-18 08:48:53', 26, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi', '2019-08-18 11:23:34', 28, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in', '2020-03-25 22:47:07', 17, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in faucibus orci luctus', '2018-02-07 22:31:51', 44, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'congue etiam justo etiam pretium iaculis justo in hac', '2018-02-21 12:35:57', 53, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suspendisse', '2019-11-28 04:18:46', 42, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum', '2017-02-07 02:28:53', 11, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra', '2019-11-03 18:22:41', 16, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'massa', '2017-03-17 16:25:41', 53, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suspendisse ornare consequat lectus in est risus auctor sed', '2020-01-16 10:54:07', 15, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt', '2019-12-17 17:26:20', 22, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus', '2019-04-17 00:56:17', 23, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', '2020-03-27 12:34:46', 4, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'commodo placerat praesent blandit nam nulla integer', '2019-02-12 19:14:40', 31, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget congue eget semper', '2020-03-14 21:55:34', 57, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh', '2019-02-22 22:42:18', 17, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget', '2019-01-24 04:59:05', 57, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed', '2019-02-16 00:53:36', 15, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis donec semper sapien a libero nam dui', '2019-04-27 16:52:00', 50, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dapibus dolor vel est donec odio', '2019-10-25 11:22:41', 46, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tempus semper est quam pharetra magna ac consequat metus', '2020-03-26 00:47:37', 25, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum', '2017-07-25 05:48:17', 55, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dui vel sem sed sagittis nam congue', '2017-09-28 08:51:16', 38, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'auctor sed tristique in tempus sit amet sem', '2020-01-17 07:20:24', 42, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis', '2019-06-15 02:23:21', 2, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat', '2019-08-16 09:21:24', 17, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel', '2019-12-15 13:28:03', 43, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis', '2019-01-05 12:09:18', 50, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue', '2020-03-24 15:06:26', 24, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci', '2020-03-09 12:09:56', 22, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rutrum neque aenean auctor', '2017-01-30 10:21:59', 18, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus', '2019-06-06 11:55:55', 46, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non ligula pellentesque ultrices phasellus', '2020-01-05 08:18:01', 7, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis', '2020-01-26 14:11:35', 38, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', '2019-06-24 00:08:56', 37, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', '2018-09-10 15:28:58', 42, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vivamus in felis', '2018-09-08 04:48:20', 30, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum', '2017-02-06 02:53:50', 56, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet nulla', '2020-01-30 20:55:42', 57, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'egestas metus', '2017-07-21 03:08:04', 35, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et ultrices posuere cubilia curae nulla dapibus dolor', '2020-01-24 15:42:22', 31, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et ultrices posuere cubilia curae', '2019-03-02 05:18:42', 50, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur', '2017-07-11 15:14:50', 25, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui', '2018-11-30 13:43:39', 43, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non', '2019-02-15 22:41:54', 22, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper', '2020-01-13 23:37:41', 17, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a', '2017-12-04 18:14:48', 11, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non interdum', '2019-06-07 07:10:57', 14, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque quisque porta volutpat erat quisque erat', '2019-04-14 09:25:34', 35, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla', '2018-04-08 17:08:50', 5, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tortor duis mattis egestas metus aenean fermentum donec ut mauris', '2019-01-28 03:56:37', 30, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum primis in faucibus orci luctus et ultrices posuere', '2019-07-06 13:32:00', 21, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus', '2018-10-01 04:37:32', 6, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac', '2018-10-09 09:58:24', 24, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat', '2019-02-22 14:31:46', 16, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'accumsan felis ut at dolor quis odio consequat varius integer ac', '2020-03-13 13:11:49', 17, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc', '2018-07-21 11:26:59', 6, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur', '2019-11-28 10:38:30', 15, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis sed lacus morbi sem', '2018-11-12 14:23:39', 36, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sagittis sapien cum sociis', '2018-03-07 05:31:45', 15, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac', '2019-08-18 19:10:30', 16, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'integer', '2020-01-04 15:04:53', 7, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean', '2019-11-21 16:30:14', 55, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis', '2020-01-07 23:20:51', 11, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio', '2018-03-10 20:50:14', 30, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa', '2020-01-23 07:12:01', 37, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'hac habitasse platea dictumst morbi vestibulum', '2019-01-17 23:40:59', 44, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur', '2019-06-05 23:52:08', 15, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar', '2019-07-16 21:57:06', 17, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis', '2020-03-25 11:37:07', 11, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'varius nulla facilisi cras', '2019-08-06 07:02:45', 26, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel', '2018-09-13 09:15:01', 45, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio', '2020-01-06 11:54:06', 23, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate', '2018-09-27 05:17:44', 30, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus', '2019-03-10 14:07:37', 58, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus', '2018-08-22 16:56:05', 37, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget tincidunt eget', '2018-04-19 01:19:43', 5, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'neque duis bibendum morbi non', '2019-10-05 04:25:02', 55, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tempor convallis', '2019-02-12 19:29:45', 11, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non', '2019-04-30 12:27:39', 50, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus', '2018-11-25 15:33:33', 7, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci', '2018-03-15 21:22:54', 47, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'habitasse', '2020-03-19 14:01:58', 37, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna', '2019-03-05 19:25:18', 45, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'commodo placerat praesent blandit', '2019-01-20 21:22:25', 53, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', '2020-01-05 04:50:00', 32, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum', '2018-07-09 06:32:07', 49, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla', '2018-11-11 03:22:43', 33, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pretium iaculis', '2019-09-18 19:17:51', 1, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut nunc', '2019-08-16 10:57:35', 59, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget orci vehicula condimentum curabitur in libero ut massa', '2018-01-16 00:11:44', 6, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit', '2018-10-25 16:43:34', 47, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo aliquam quis turpis eget elit', '2019-02-21 06:40:59', 27, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet', '2018-03-27 19:21:03', 52, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum integer a nibh in', '2018-07-22 16:24:45', 25, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam', '2020-01-07 21:17:49', 8, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis parturient montes', '2018-02-23 03:06:17', 43, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'est phasellus sit amet erat nulla tempus vivamus', '2020-03-12 19:57:39', 59, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mus etiam vel augue vestibulum rutrum rutrum neque', '2019-04-27 09:45:15', 52, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quisque ut erat', '2018-07-30 15:21:27', 47, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mi in porttitor', '2020-01-03 18:14:09', 16, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla justo aliquam quis turpis', '2019-11-17 15:35:58', 17, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at', '2019-07-05 15:02:21', 16, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at', '2019-01-17 15:46:38', 47, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo', '2020-03-08 19:33:59', 34, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in hac habitasse platea dictumst', '2019-08-24 17:27:08', 16, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in', '2018-04-06 07:02:23', 16, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at', '2020-03-02 02:01:43', 30, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque', '2019-06-09 06:07:52', 59, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh', '2020-03-04 03:41:00', 29, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea', '2019-08-19 22:27:27', 13, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet', '2018-04-11 21:19:42', 1, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', '2020-03-17 20:43:19', 41, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet', '2019-11-02 09:00:07', 57, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis', '2019-02-13 14:00:35', 47, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'posuere cubilia curae', '2019-07-28 22:19:12', 29, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque', '2018-06-06 14:52:23', 17, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vestibulum velit', '2019-09-18 08:48:17', 44, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce', '2018-02-28 01:36:35', 32, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus', '2020-03-01 09:57:36', 42, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac', '2018-11-20 15:43:43', 25, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'purus phasellus', '2018-04-21 23:24:58', 4, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae', '2019-08-22 07:15:15', 19, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a', '2019-03-15 03:49:03', 20, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat', '2019-11-19 14:12:53', 21, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', '2020-03-15 18:12:44', 32, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus', '2019-11-09 14:11:37', 9, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'interdum in ante vestibulum', '2018-09-11 01:43:55', 30, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vulputate vitae nisl aenean lectus pellentesque', '2018-10-18 04:19:21', 49, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum', '2018-08-25 04:16:36', 10, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dolor', '2020-03-13 00:06:57', 40, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eros viverra eget congue', '2020-03-15 05:42:31', 9, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse', '2019-03-17 03:12:58', 53, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat', '2019-01-24 00:51:43', 36, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem', '2020-03-10 19:42:43', 40, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc viverra dapibus nulla', '2018-07-04 11:08:00', 56, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper', '2018-03-15 19:11:14', 20, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan', '2019-06-13 09:35:23', 55, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus', '2020-03-07 20:26:03', 51, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus', '2018-11-27 15:52:10', 60, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed', '2018-09-23 07:34:44', 12, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam', '2018-06-05 10:42:40', 22, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lacinia eget tincidunt eget tempus vel pede morbi porttitor', '2020-03-01 12:09:36', 20, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'hac habitasse platea dictumst etiam faucibus cursus urna', '2019-03-17 02:20:18', 56, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget', '2018-08-10 11:59:35', 54, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vulputate justo in blandit ultrices enim lorem', '2018-07-23 20:58:09', 18, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla', '2019-08-07 19:44:13', 33, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in', '2019-04-30 14:58:27', 3, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin', '2019-07-10 06:11:34', 36, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum', '2019-12-14 16:22:13', 17, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit', '2019-08-07 08:26:25', 46, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non', '2020-03-16 12:14:01', 5, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vel est donec odio justo sollicitudin ut suscipit a', '2018-03-13 00:07:19', 30, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi sem mauris laoreet ut rhoncus aliquet pulvinar', '2018-07-21 10:15:30', 49, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id massa', '2018-08-28 02:45:15', 28, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean', '2019-03-28 11:25:32', 37, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis justo maecenas rhoncus aliquam lacus', '2018-11-16 16:54:06', 54, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent', '2019-02-07 06:21:27', 28, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lobortis est', '2019-08-12 04:02:36', 57, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis', '2020-03-23 01:55:27', 51, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'semper est quam', '2018-12-01 05:49:02', 6, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', '2020-03-27 20:02:57', 44, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec', '2020-01-28 08:14:35', 54, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'est congue elementum in hac habitasse platea dictumst morbi vestibulum velit', '2018-02-15 11:18:54', 60, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate', '2019-06-20 17:06:11', 2, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in leo maecenas pulvinar lobortis est phasellus', '2019-11-07 13:11:24', 14, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vulputate vitae nisl aenean lectus pellentesque eget nunc', '2018-12-10 12:52:46', 7, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis', '2019-03-10 12:29:06', 12, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida', '2018-11-20 04:59:57', 37, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'integer aliquet massa id lobortis convallis tortor', '2020-01-07 02:18:30', 37, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', '2018-11-09 22:58:43', 30, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', '2020-01-01 15:43:05', 40, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eu massa donec', '2017-04-12 05:54:50', 3, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis', '2017-04-13 12:09:35', 38, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'aenean fermentum donec ut mauris eget', '2017-10-24 21:22:21', 15, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tempus sit amet sem fusce consequat nulla nisl', '2019-03-17 09:46:54', 42, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lacus at velit vivamus vel nulla eget eros elementum', '2019-05-02 05:33:21', 34, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit', '2017-05-28 09:10:24', 49, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque', '2019-03-21 08:54:24', 10, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat', '2019-03-02 05:07:18', 6, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis', '2017-08-11 10:47:33', 34, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quisque porta', '2020-03-03 01:26:23', 45, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', '2017-01-10 13:01:43', 18, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'maecenas pulvinar lobortis est phasellus sit amet erat nulla', '2017-06-06 07:33:35', 56, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi', '2020-03-12 12:33:54', 17, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget vulputate ut ultrices', '2019-07-15 12:14:36', 34, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris enim leo rhoncus sed vestibulum sit amet cursus', '2019-04-05 00:15:44', 39, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit', '2017-11-15 19:16:58', 58, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim', '2020-01-15 05:57:15', 26, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id', '2019-10-12 12:32:05', 5, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque', '2019-12-31 11:10:45', 5, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque eget nunc donec quis orci eget orci', '2017-03-11 06:57:40', 27, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum', '2020-03-11 15:05:30', 13, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem', '2019-02-23 06:45:24', 46, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', '2019-09-22 01:14:22', 6, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et', '2019-09-01 02:01:22', 9, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget', '2019-07-13 23:08:21', 47, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo', '2019-07-10 09:08:54', 17, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula', '2017-10-06 19:35:37', 19, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget', '2017-01-01 04:49:04', 21, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'volutpat dui maecenas', '2017-03-01 15:36:54', 26, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius', '2019-06-13 23:30:45', 16, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci eget orci vehicula condimentum curabitur in libero', '2017-10-18 00:26:41', 27, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet justo', '2017-02-11 08:30:46', 27, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue', '2017-08-12 15:44:26', 49, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede', '2017-02-21 00:03:13', 58, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede lobortis ligula sit amet', '2017-12-02 13:50:16', 54, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis', '2017-10-01 14:46:36', 25, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in congue etiam justo etiam pretium iaculis justo in hac habitasse', '2017-09-05 11:55:04', 7, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id ornare imperdiet sapien urna', '2017-02-16 16:22:52', 10, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in', '2017-09-26 18:22:17', 8, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat lectus in est risus auctor sed tristique in tempus', '2017-06-12 13:33:28', 52, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet', '2017-04-16 09:13:31', 1, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque ultrices phasellus', '2020-03-13 01:32:59', 9, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in hac habitasse platea dictumst morbi vestibulum velit', '2020-03-25 01:48:39', 13, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'venenatis turpis enim blandit mi in porttitor', '2017-10-29 20:47:41', 41, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet eros suspendisse accumsan tortor quis', '2017-11-11 14:02:21', 5, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget nunc donec quis orci eget', '2019-01-17 18:57:10', 2, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum', '2019-03-11 03:24:35', 41, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in', '2017-10-22 19:05:19', 37, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien', '2020-01-26 03:57:21', 36, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vehicula consequat morbi', '2017-05-31 08:43:11', 8, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis', '2019-03-01 15:05:08', 18, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet eros suspendisse accumsan tortor quis turpis', '2017-01-27 23:50:47', 25, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra', '2020-03-02 17:55:35', 37, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ultrices erat tortor sollicitudin mi sit', '2020-03-23 09:37:26', 21, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'habitasse', '2020-01-14 05:40:35', 49, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sem praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada', '2017-08-28 03:59:50', 15, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus ultricies eu nibh quisque id', '2017-07-22 08:02:15', 48, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'neque vestibulum eget vulputate ut', '2020-01-16 01:51:07', 39, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in', '2019-10-25 12:44:14', 11, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique', '2017-12-16 09:16:09', 10, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', '2017-09-27 07:16:11', 23, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'potenti in eleifend quam a odio in hac habitasse', '2017-11-21 20:46:44', 8, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis', '2019-04-09 05:06:12', 34, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis augue luctus tincidunt nulla mollis molestie lorem quisque ut', '2019-12-30 05:36:51', 55, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac', '2019-03-31 20:50:36', 15, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis donec semper sapien a libero nam dui proin leo odio', '2017-09-18 09:58:51', 26, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi', '2019-02-04 00:44:34', 27, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat', '2020-03-13 06:26:23', 23, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'volutpat eleifend donec ut dolor morbi vel lectus in', '2020-03-11 09:06:26', 33, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla tempus vivamus in felis', '2017-09-16 12:57:05', 29, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', '2019-02-02 12:56:24', 41, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'odio porttitor id consequat in consequat ut', '2019-01-23 10:39:45', 2, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat', '2019-02-06 23:31:35', 19, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'velit donec diam', '2019-10-30 01:10:13', 38, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam', '2020-03-09 03:54:54', 58, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in consequat ut nulla sed accumsan', '2017-08-11 22:14:37', 28, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ac neque duis', '2019-01-18 18:20:24', 4, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus', '2017-05-06 04:54:20', 19, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'velit donec diam neque vestibulum eget vulputate', '2017-10-23 06:04:57', 13, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci', '2020-01-03 06:53:19', 58, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est', '2019-04-18 00:20:30', 8, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla', '2017-06-24 02:24:38', 54, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean', '2019-08-05 14:30:00', 39, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo lacinia eget tincidunt', '2017-10-14 18:14:48', 25, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vivamus vel nulla eget eros', '2017-07-23 15:07:07', 59, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel', '2017-05-01 14:55:21', 7, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse', '2020-01-21 23:43:17', 31, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dictumst maecenas ut', '2020-01-14 06:18:33', 13, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue', '2019-04-30 09:22:37', 59, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dolor quis odio consequat varius integer ac leo pellentesque', '2017-08-12 02:27:07', 50, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eros suspendisse accumsan', '2017-01-21 00:14:33', 27, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat', '2017-09-25 17:31:47', 7, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at', '2020-01-06 16:42:55', 33, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus', '2017-03-17 07:37:18', 47, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est', '2020-01-17 11:45:47', 36, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus', '2017-11-30 08:02:49', 24, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia', '2017-02-22 22:51:16', 54, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl', '2017-06-04 04:02:10', 13, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis', '2017-03-15 03:57:42', 1, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero', '2017-03-10 04:28:31', 22, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis', '2019-04-08 23:43:23', 28, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices', '2019-08-12 09:14:24', 48, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vestibulum ante ipsum primis in faucibus orci luctus et', '2017-10-21 09:15:13', 33, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in', '2020-03-29 04:23:28', 53, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi', '2017-08-02 18:48:14', 31, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu', '2017-01-04 06:59:10', 10, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede morbi porttitor lorem id ligula', '2019-06-11 02:01:59', 21, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar sed nisl nunc rhoncus dui vel sem', '2017-06-24 15:24:51', 58, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis', '2020-01-02 03:14:49', 21, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in', '2019-07-07 19:49:41', 15, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dui luctus rutrum nulla tellus', '2019-03-18 00:45:38', 39, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'habitasse platea dictumst maecenas ut massa quis augue', '2019-07-05 12:22:53', 32, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget', '2017-06-09 06:43:35', 43, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vestibulum ante', '2020-03-11 18:54:46', 15, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac', '2018-04-23 00:10:36', 10, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia', '2019-07-30 13:36:25', 20, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis', '2018-03-14 06:33:14', 54, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis', '2018-02-19 16:32:47', 29, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dis parturient montes nascetur ridiculus mus vivamus vestibulum', '2018-09-27 22:23:17', 44, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum', '2019-08-11 09:34:32', 21, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nullam porttitor lacus at turpis donec posuere metus vitae', '2019-03-31 19:43:03', 58, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eleifend luctus ultricies eu nibh quisque id justo sit amet sapien', '2019-02-24 20:22:42', 50, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius', '2018-06-20 00:46:23', 2, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque', '2019-04-06 03:58:54', 59, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit', '2018-06-14 17:32:20', 3, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac', '2018-09-02 14:51:26', 44, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla sed vel', '2018-07-04 02:08:46', 50, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'penatibus et magnis dis parturient montes nascetur ridiculus', '2020-01-16 13:02:18', 9, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede', '2020-03-08 11:53:32', 50, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', '2018-08-26 23:41:53', 11, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet', '2020-03-20 19:58:52', 1, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci eget orci vehicula condimentum curabitur in libero ut', '2018-01-20 01:37:47', 17, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus', '2018-05-01 05:49:52', 45, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu', '2020-03-18 20:11:37', 40, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque', '2018-07-02 22:01:36', 56, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nam tristique tortor eu pede', '2019-10-14 17:52:17', 15, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat metus sapien ut nunc', '2019-01-16 10:27:07', 37, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et', '2018-12-07 19:16:26', 37, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in', '2020-03-19 01:54:29', 10, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et', '2018-08-01 12:11:58', 43, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu', '2018-01-09 02:24:17', 18, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'velit vivamus vel nulla eget eros elementum pellentesque', '2020-03-16 21:06:17', 6, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum dolor sit amet consectetuer adipiscing elit proin', '2018-10-01 10:08:37', 35, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae', '2019-02-18 13:31:02', 3, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui', '2020-01-04 02:28:23', 6, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit', '2020-01-03 01:56:33', 10, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in quam fringilla rhoncus', '2020-03-02 16:53:44', 50, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', '2019-02-27 14:03:17', 46, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'platea dictumst etiam faucibus cursus urna', '2020-03-02 16:38:44', 47, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quisque erat eros viverra eget congue eget semper', '2020-01-22 04:33:35', 36, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque', '2019-08-23 23:22:52', 46, 24);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis', '2019-12-01 08:58:40', 24, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus', '2018-01-19 21:28:53', 5, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui', '2020-03-22 13:18:13', 6, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quam turpis adipiscing lorem vitae', '2019-02-20 18:50:21', 13, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'id lobortis convallis tortor risus dapibus', '2018-06-07 20:26:07', 1, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eget rutrum at lorem', '2019-02-17 03:12:46', 37, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis', '2019-11-11 05:34:47', 56, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat', '2019-07-15 22:49:35', 38, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero', '2018-03-31 01:16:52', 27, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut', '2019-10-13 06:05:16', 46, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar lobortis est phasellus sit amet erat nulla', '2018-07-02 23:22:23', 48, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum', '2018-05-17 02:25:34', 1, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna', '2018-03-18 15:34:35', 18, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in', '2018-11-23 12:55:52', 45, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'integer ac', '2018-08-09 19:14:52', 11, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eleifend donec ut dolor morbi vel lectus in', '2018-04-12 00:17:13', 13, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer', '2020-03-22 17:21:28', 20, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sem duis aliquam convallis nunc proin at turpis a pede', '2018-10-29 07:54:54', 34, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'phasellus in felis donec semper sapien a libero nam dui proin leo odio', '2018-12-13 07:21:29', 34, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer', '2019-02-25 20:45:45', 18, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue', '2018-06-08 11:38:23', 58, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra', '2018-08-09 16:19:45', 57, 17);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor', '2020-01-03 09:02:17', 18, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'felis eu sapien cursus vestibulum proin eu', '2019-08-10 14:44:00', 55, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer', '2020-01-30 10:55:13', 21, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet', '2020-03-02 04:42:34', 38, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'blandit lacinia erat vestibulum sed magna', '2018-01-29 19:17:02', 44, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus', '2019-04-09 04:38:20', 43, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque', '2020-01-17 15:09:20', 46, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar', '2019-12-05 21:27:45', 38, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque', '2018-02-24 09:35:07', 32, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id', '2019-03-11 19:15:52', 14, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida', '2018-05-04 06:55:28', 14, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'suspendisse potenti in eleifend quam a odio in hac habitasse platea', '2019-06-06 03:53:34', 53, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'varius ut blandit non', '2018-02-24 16:24:10', 45, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate', '2018-03-18 16:51:08', 44, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', '2018-05-20 03:53:00', 7, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'erat id mauris vulputate elementum nullam varius nulla facilisi cras', '2019-12-12 13:08:25', 24, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien non mi integer ac neque', '2018-01-22 02:06:18', 6, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'morbi non quam nec dui luctus', '2018-07-10 13:19:26', 22, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'faucibus cursus urna', '2019-11-24 12:38:03', 43, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'augue vel accumsan tellus nisi', '2018-06-17 02:51:57', 15, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'at dolor quis odio consequat varius integer', '2020-01-11 03:48:21', 5, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla facilisi', '2018-02-16 04:40:54', 36, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem', '2018-09-04 06:53:42', 26, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisi nam ultrices libero', '2018-11-03 04:06:01', 39, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet sapien dignissim vestibulum vestibulum ante', '2020-03-19 10:03:56', 35, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis', '2020-01-13 20:44:05', 23, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet diam in magna bibendum imperdiet nullam orci pede venenatis', '2018-10-13 16:19:10', 27, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna', '2020-01-30 16:46:20', 24, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea', '2019-05-04 18:20:13', 2, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam', '2019-02-19 19:12:12', 11, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in quis justo maecenas rhoncus aliquam lacus', '2019-10-16 01:33:12', 10, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque', '2019-06-20 20:46:24', 16, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in', '2018-02-26 05:02:07', 54, 23);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nibh in lectus pellentesque at', '2019-10-19 05:03:06', 5, 12);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cursus vestibulum proin eu mi nulla ac enim in tempor', '2019-02-12 17:55:33', 3, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede', '2018-09-11 05:09:39', 27, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla ut erat', '2019-03-04 01:10:18', 17, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin', '2018-05-13 12:47:00', 13, 6);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis', '2019-07-13 05:37:35', 13, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', '2019-12-04 04:16:19', 46, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur', '2020-03-31 05:37:30', 7, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat dui nec nisi volutpat eleifend donec ut', '2018-04-26 02:37:23', 3, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at', '2018-09-19 23:09:58', 7, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis', '2019-01-11 11:11:14', 25, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rutrum neque aenean auctor gravida sem', '2020-03-07 21:45:36', 53, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar lobortis est phasellus sit', '2018-07-16 02:45:04', 2, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla', '2018-02-10 19:15:58', 41, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus', '2019-03-31 22:34:06', 7, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam', '2018-07-22 12:22:14', 3, 11);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a', '2018-07-23 20:58:32', 47, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum', '2020-01-14 10:57:00', 58, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper', '2019-01-22 16:53:21', 42, 8);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula', '2018-02-03 22:46:57', 24, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in', '2019-09-30 08:08:55', 20, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla', '2018-09-26 01:30:15', 20, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'interdum', '2019-12-28 01:49:01', 49, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi', '2020-01-08 15:11:06', 49, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu', '2020-03-05 20:36:36', 57, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a feugiat', '2019-04-09 13:44:14', 43, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices', '2019-10-09 06:21:06', 12, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae', '2018-11-05 23:10:26', 15, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu', '2020-01-25 03:22:30', 13, 13);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a', '2019-11-21 17:33:12', 48, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'amet nunc viverra dapibus nulla suscipit', '2020-03-17 21:42:41', 11, 20);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum', '2018-07-12 17:54:47', 32, 9);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt lacus at velit', '2018-09-20 00:40:07', 14, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt', '2018-07-06 20:05:11', 7, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi', '2018-05-20 00:46:47', 60, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla', '2020-03-11 16:57:26', 4, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices', '2018-03-20 15:22:48', 5, 14);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dolor quis', '2018-01-27 09:46:47', 4, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin', '2019-05-29 16:07:27', 25, 7);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis parturient montes nascetur', '2018-10-22 05:57:46', 59, 4);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed', '2019-03-15 14:06:20', 14, 5);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id', '2020-03-12 09:50:52', 47, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam', '2019-03-26 22:03:03', 60, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sociis natoque penatibus et', '2020-03-05 07:24:23', 30, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sed lacus morbi sem mauris', '2018-02-12 02:56:52', 37, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper', '2018-03-16 03:30:30', 43, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu', '2019-08-04 13:19:41', 39, 1);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'duis mattis egestas metus aenean', '2020-01-28 19:43:24', 51, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat', '2020-01-02 10:48:38', 34, 25);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ullamcorper augue a suscipit nulla elit ac nulla sed vel enim', '2018-02-16 09:44:59', 32, 15);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', '2019-08-24 22:42:25', 42, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus', '2020-03-09 01:40:21', 3, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus', '2018-02-08 03:00:38', 40, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec', '2018-01-08 14:01:08', 19, 27);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'mauris eget massa tempor convallis nulla neque libero', '2018-06-02 18:09:46', 27, 21);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc', '2018-12-17 09:36:39', 43, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo', '2020-01-29 02:54:49', 47, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient', '2019-04-19 18:05:02', 37, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius', '2019-04-16 00:25:43', 8, 19);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'a pede posuere nonummy integer', '2018-09-05 16:11:19', 19, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique', '2019-12-28 03:00:10', 20, 18);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'pulvinar lobortis est', '2020-01-31 04:19:03', 28, 2);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'ante ipsum primis in faucibus orci luctus et ultrices posuere', '2018-10-27 06:29:32', 54, 16);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi', '2019-02-26 19:18:42', 39, 29);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a', '2020-03-28 15:28:39', 28, 28);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero', '2018-02-04 07:45:56', 15, 3);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'orci vehicula condimentum curabitur in', '2018-06-20 19:26:43', 25, 26);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id', '2020-01-01 18:26:59', 16, 10);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'justo pellentesque viverra pede ac diam cras pellentesque', '2019-06-02 17:43:33', 9, 30);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac', '2019-02-17 20:29:05', 34, 22);
insert into message (id, content, "date", channel_id, user_id) values (DEFAULT, 'rutrum nulla tellus in', '2017-05-21 21:04:14', 29, 30);

insert into color (id, rgb_code) values (DEFAULT, 'FDFFFCEF');
insert into color (id, rgb_code) values (DEFAULT, 'FFCFFFFD');
insert into color (id, rgb_code) values (DEFAULT, 'FFCFFEFD');
insert into color (id, rgb_code) values (DEFAULT, '1EFFDFFD');
insert into color (id, rgb_code) values (DEFAULT, 'EFBF2BFF');
insert into color (id, rgb_code) values (DEFAULT, 'FFFDFB7F');
insert into color (id, rgb_code) values (DEFAULT, 'FEEECFEB');
insert into color (id, rgb_code) values (DEFAULT, 'FFEFCFAC');
insert into color (id, rgb_code) values (DEFAULT, 'FFDFFEEF');
insert into color (id, rgb_code) values (DEFAULT, 'EFFFEEAF');
insert into color (id, rgb_code) values (DEFAULT, 'DFFDFCFF');
insert into color (id, rgb_code) values (DEFAULT, 'FEFFFFFF');
insert into color (id, rgb_code) values (DEFAULT, 'BFFFFFCE');
insert into color (id, rgb_code) values (DEFAULT, 'EEFECFEF');
insert into color (id, rgb_code) values (DEFAULT, 'FFEDFFFC');
insert into color (id, rgb_code) values (DEFAULT, 'EFFFDFEB');
insert into color (id, rgb_code) values (DEFAULT, 'AEBBEDFF');
insert into color (id, rgb_code) values (DEFAULT, 'FDFCFFFE');
insert into color (id, rgb_code) values (DEFAULT, 'EEFFFEFF');
insert into color (id, rgb_code) values (DEFAULT, 'EFFFDF9F');
insert into color (id, rgb_code) values (DEFAULT, 'EFDCDFFE');
insert into color (id, rgb_code) values (DEFAULT, 'FFFFFEEC');
insert into color (id, rgb_code) values (DEFAULT, 'EFFCFFEF');
insert into color (id, rgb_code) values (DEFAULT, 'FDEFFFFE');
insert into color (id, rgb_code) values (DEFAULT, 'CFDDFFCF');
insert into color (id, rgb_code) values (DEFAULT, 'FDFEFDDC');
insert into color (id, rgb_code) values (DEFAULT, 'FFFFEFFF');
insert into color (id, rgb_code) values (DEFAULT, 'EECFEFBD');
insert into color (id, rgb_code) values (DEFAULT, 'DFFFDD3E');
insert into color (id, rgb_code) values (DEFAULT, 'FFDFFFFD');


insert into report (id, description, reports_id, reported_id) values (DEFAULT, 'eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus', 18, 20);
insert into report (id, description, reports_id, reported_id) values (DEFAULT, 'dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam', 1, 24);
insert into report (id, description, reports_id, reported_id) values (DEFAULT, 'blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan', 12, 28);
insert into report (id, description, reports_id, reported_id) values (DEFAULT, 'volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis', 19, 12);
insert into report (id, description, reports_id, reported_id) values (DEFAULT, 'felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo', 6, 7);

insert into tag (id, name, color_id) values (DEFAULT, 'eu felis', 8);
insert into tag (id, name, color_id) values (DEFAULT, 'lectus', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'non', 2);
insert into tag (id, name, color_id) values (DEFAULT, 'ullamcorper purus', 27);
insert into tag (id, name, color_id) values (DEFAULT, 'risus', 27);
insert into tag (id, name, color_id) values (DEFAULT, 'lorem', 28);
insert into tag (id, name, color_id) values (DEFAULT, 'dolor morbi', 1);
insert into tag (id, name, color_id) values (DEFAULT, 'leo', 5);
insert into tag (id, name, color_id) values (DEFAULT, 'quam a', 14);
insert into tag (id, name, color_id) values (DEFAULT, 'diam', 23);
insert into tag (id, name, color_id) values (DEFAULT, 'justo', 15);
insert into tag (id, name, color_id) values (DEFAULT, 'lobortis', 11);
insert into tag (id, name, color_id) values (DEFAULT, 'sit', 18);
insert into tag (id, name, color_id) values (DEFAULT, 'in quam', 16);
insert into tag (id, name, color_id) values (DEFAULT, 'ligula pellentesque', 25);
insert into tag (id, name, color_id) values (DEFAULT, 'cras', 25);
insert into tag (id, name, color_id) values (DEFAULT, 'nulla', 6);
insert into tag (id, name, color_id) values (DEFAULT, 'quis turpis', 28);
insert into tag (id, name, color_id) values (DEFAULT, 'duis bibendum', 17);
insert into tag (id, name, color_id) values (DEFAULT, 'odio', 1);
insert into tag (id, name, color_id) values (DEFAULT, 'augue a', 9);
insert into tag (id, name, color_id) values (DEFAULT, 'ante', 11);
insert into tag (id, name, color_id) values (DEFAULT, 'sapien placerat', 7);
insert into tag (id, name, color_id) values (DEFAULT, 'nulla ultrices', 27);
insert into tag (id, name, color_id) values (DEFAULT, 'vestibulum', 10);
insert into tag (id, name, color_id) values (DEFAULT, 'metus vitae', 27);
insert into tag (id, name, color_id) values (DEFAULT, 'sed', 13);
insert into tag (id, name, color_id) values (DEFAULT, 'hac', 22);
insert into tag (id, name, color_id) values (DEFAULT, 'luctus', 12);
insert into tag (id, name, color_id) values (DEFAULT, 'consequat in', 18);
insert into tag (id, name, color_id) values (DEFAULT, 'nibh', 13);
insert into tag (id, name, color_id) values (DEFAULT, 'luctus rutrum', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'risus dapibus', 21);
insert into tag (id, name, color_id) values (DEFAULT, 'ante vel', 24);
insert into tag (id, name, color_id) values (DEFAULT, 'enim lorem', 8);
insert into tag (id, name, color_id) values (DEFAULT, 'mauris non', 21);
insert into tag (id, name, color_id) values (DEFAULT, 'sapien dignissim', 1);
insert into tag (id, name, color_id) values (DEFAULT, 'odio', 10);
insert into tag (id, name, color_id) values (DEFAULT, 'nec', 21);
insert into tag (id, name, color_id) values (DEFAULT, 'erat', 21);
insert into tag (id, name, color_id) values (DEFAULT, 'aliquam', 15);
insert into tag (id, name, color_id) values (DEFAULT, 'ut massa', 26);
insert into tag (id, name, color_id) values (DEFAULT, 'vestibulum', 16);
insert into tag (id, name, color_id) values (DEFAULT, 'penatibus', 28);
insert into tag (id, name, color_id) values (DEFAULT, 'aliquam augue', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'amet', 14);
insert into tag (id, name, color_id) values (DEFAULT, 'mi sit', 2);
insert into tag (id, name, color_id) values (DEFAULT, 'mattis', 4);
insert into tag (id, name, color_id) values (DEFAULT, 'vestibulum', 24);
insert into tag (id, name, color_id) values (DEFAULT, 'aliquam lacus', 18);
insert into tag (id, name, color_id) values (DEFAULT, 'semper est', 14);
insert into tag (id, name, color_id) values (DEFAULT, 'congue', 24);
insert into tag (id, name, color_id) values (DEFAULT, 'lectus', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'non ligula', 11);
insert into tag (id, name, color_id) values (DEFAULT, 'sed', 1);
insert into tag (id, name, color_id) values (DEFAULT, 'cras', 14);
insert into tag (id, name, color_id) values (DEFAULT, 'non velit', 25);
insert into tag (id, name, color_id) values (DEFAULT, 'orci', 17);
insert into tag (id, name, color_id) values (DEFAULT, 'dictumst', 21);
insert into tag (id, name, color_id) values (DEFAULT, 'in', 2);
insert into tag (id, name, color_id) values (DEFAULT, 'velit vivamus', 10);
insert into tag (id, name, color_id) values (DEFAULT, 'sed', 2);
insert into tag (id, name, color_id) values (DEFAULT, 'odio condimentum', 25);
insert into tag (id, name, color_id) values (DEFAULT, 'id', 20);
insert into tag (id, name, color_id) values (DEFAULT, 'a', 7);
insert into tag (id, name, color_id) values (DEFAULT, 'morbi sem', 7);
insert into tag (id, name, color_id) values (DEFAULT, 'ornare', 3);
insert into tag (id, name, color_id) values (DEFAULT, 'vehicula', 5);
insert into tag (id, name, color_id) values (DEFAULT, 'leo rhoncus', 3);
insert into tag (id, name, color_id) values (DEFAULT, 'nunc purus', 13);
insert into tag (id, name, color_id) values (DEFAULT, 'quam', 16);
insert into tag (id, name, color_id) values (DEFAULT, 'nam', 24);
insert into tag (id, name, color_id) values (DEFAULT, 'faucibus', 18);
insert into tag (id, name, color_id) values (DEFAULT, 'ut blandit', 21);
insert into tag (id, name, color_id) values (DEFAULT, 'pellentesque at', 10);
insert into tag (id, name, color_id) values (DEFAULT, 'ut nunc', 22);
insert into tag (id, name, color_id) values (DEFAULT, 'nulla suspendisse', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'morbi a', 10);
insert into tag (id, name, color_id) values (DEFAULT, 'faucibus cursus', 27);
insert into tag (id, name, color_id) values (DEFAULT, 'quam pharetra', 12);
insert into tag (id, name, color_id) values (DEFAULT, 'consequat', 26);
insert into tag (id, name, color_id) values (DEFAULT, 'mi pede', 16);
insert into tag (id, name, color_id) values (DEFAULT, 'libero', 15);
insert into tag (id, name, color_id) values (DEFAULT, 'cum sociis', 25);
insert into tag (id, name, color_id) values (DEFAULT, 'faucibus orci', 26);
insert into tag (id, name, color_id) values (DEFAULT, 'placerat ante', 28);
insert into tag (id, name, color_id) values (DEFAULT, 'in', 27);
insert into tag (id, name, color_id) values (DEFAULT, 'lectus vestibulum', 3);
insert into tag (id, name, color_id) values (DEFAULT, 'quam', 28);
insert into tag (id, name, color_id) values (DEFAULT, 'fusce', 17);
insert into tag (id, name, color_id) values (DEFAULT, 'faucibus orci', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'nec', 12);
insert into tag (id, name, color_id) values (DEFAULT, 'duis', 14);
insert into tag (id, name, color_id) values (DEFAULT, 'viverra', 5);
insert into tag (id, name, color_id) values (DEFAULT, 'nulla', 13);
insert into tag (id, name, color_id) values (DEFAULT, 'et', 29);
insert into tag (id, name, color_id) values (DEFAULT, 'vivamus vestibulum', 12);
insert into tag (id, name, color_id) values (DEFAULT, 'nam tristique', 2);
insert into tag (id, name, color_id) values (DEFAULT, 'morbi', 18);
insert into tag (id, name, color_id) values (DEFAULT, 'duis', 16);


insert into user_tag (user_id, tag_id) values (17, 1);
insert into user_tag (user_id, tag_id) values (5, 2);
insert into user_tag (user_id, tag_id) values (29, 3);
insert into user_tag (user_id, tag_id) values (7, 4);
insert into user_tag (user_id, tag_id) values (20, 5);
insert into user_tag (user_id, tag_id) values (9, 6);
insert into user_tag (user_id, tag_id) values (21, 7);
insert into user_tag (user_id, tag_id) values (4, 8);
insert into user_tag (user_id, tag_id) values (11, 9);
insert into user_tag (user_id, tag_id) values (29, 10);
insert into user_tag (user_id, tag_id) values (23, 11);
insert into user_tag (user_id, tag_id) values (18, 12);
insert into user_tag (user_id, tag_id) values (23, 13);
insert into user_tag (user_id, tag_id) values (4, 14);
insert into user_tag (user_id, tag_id) values (21, 15);
insert into user_tag (user_id, tag_id) values (19, 16);
insert into user_tag (user_id, tag_id) values (1, 17);
insert into user_tag (user_id, tag_id) values (27, 18);
insert into user_tag (user_id, tag_id) values (16, 19);
insert into user_tag (user_id, tag_id) values (18, 20);
insert into user_tag (user_id, tag_id) values (12, 21);
insert into user_tag (user_id, tag_id) values (29, 22);
insert into user_tag (user_id, tag_id) values (24, 23);
insert into user_tag (user_id, tag_id) values (10, 24);
insert into user_tag (user_id, tag_id) values (30, 25);
insert into user_tag (user_id, tag_id) values (21, 26);
insert into user_tag (user_id, tag_id) values (6, 27);
insert into user_tag (user_id, tag_id) values (17, 28);
insert into user_tag (user_id, tag_id) values (5, 29);
insert into user_tag (user_id, tag_id) values (4, 30);

insert into issue_tag (issue_id, tag_id) values (27, 31);
insert into issue_tag (issue_id, tag_id) values (10, 32);
insert into issue_tag (issue_id, tag_id) values (12, 33);
insert into issue_tag (issue_id, tag_id) values (22, 34);
insert into issue_tag (issue_id, tag_id) values (19, 35);
insert into issue_tag (issue_id, tag_id) values (27, 36);
insert into issue_tag (issue_id, tag_id) values (3, 37);
insert into issue_tag (issue_id, tag_id) values (4, 38);
insert into issue_tag (issue_id, tag_id) values (6, 39);
insert into issue_tag (issue_id, tag_id) values (29, 40);
insert into issue_tag (issue_id, tag_id) values (26, 41);
insert into issue_tag (issue_id, tag_id) values (10, 42);
insert into issue_tag (issue_id, tag_id) values (17, 43);
insert into issue_tag (issue_id, tag_id) values (2, 44);
insert into issue_tag (issue_id, tag_id) values (14, 45);
insert into issue_tag (issue_id, tag_id) values (4, 46);
insert into issue_tag (issue_id, tag_id) values (23, 47);
insert into issue_tag (issue_id, tag_id) values (20, 48);
insert into issue_tag (issue_id, tag_id) values (24, 49);
insert into issue_tag (issue_id, tag_id) values (11, 50);
insert into issue_tag (issue_id, tag_id) values (23, 51);
insert into issue_tag (issue_id, tag_id) values (12, 52);
insert into issue_tag (issue_id, tag_id) values (26, 53);
insert into issue_tag (issue_id, tag_id) values (23, 54);
insert into issue_tag (issue_id, tag_id) values (29, 55);
insert into issue_tag (issue_id, tag_id) values (11, 56);
insert into issue_tag (issue_id, tag_id) values (16, 57);
insert into issue_tag (issue_id, tag_id) values (19, 58);
insert into issue_tag (issue_id, tag_id) values (14, 59);
insert into issue_tag (issue_id, tag_id) values (15, 60);
insert into issue_tag (issue_id, tag_id) values (30, 61);
insert into issue_tag (issue_id, tag_id) values (11, 62);
insert into issue_tag (issue_id, tag_id) values (27, 63);
insert into issue_tag (issue_id, tag_id) values (23, 64);
insert into issue_tag (issue_id, tag_id) values (7, 65);
insert into issue_tag (issue_id, tag_id) values (2, 66);
insert into issue_tag (issue_id, tag_id) values (7, 67);
insert into issue_tag (issue_id, tag_id) values (19, 68);
insert into issue_tag (issue_id, tag_id) values (19, 69);
insert into issue_tag (issue_id, tag_id) values (15, 70);
insert into issue_tag (issue_id, tag_id) values (8, 71);
insert into issue_tag (issue_id, tag_id) values (3, 72);
insert into issue_tag (issue_id, tag_id) values (18, 73);
insert into issue_tag (issue_id, tag_id) values (21, 74);
insert into issue_tag (issue_id, tag_id) values (25, 75);
insert into issue_tag (issue_id, tag_id) values (17, 76);
insert into issue_tag (issue_id, tag_id) values (13, 77);
insert into issue_tag (issue_id, tag_id) values (8, 78);
insert into issue_tag (issue_id, tag_id) values (24, 79);
insert into issue_tag (issue_id, tag_id) values (24, 80);
insert into issue_tag (issue_id, tag_id) values (26, 81);
insert into issue_tag (issue_id, tag_id) values (15, 82);
insert into issue_tag (issue_id, tag_id) values (16, 83);
insert into issue_tag (issue_id, tag_id) values (3, 84);
insert into issue_tag (issue_id, tag_id) values (26, 85);
insert into issue_tag (issue_id, tag_id) values (24, 86);
insert into issue_tag (issue_id, tag_id) values (17, 87);
insert into issue_tag (issue_id, tag_id) values (26, 88);
insert into issue_tag (issue_id, tag_id) values (7, 89);
insert into issue_tag (issue_id, tag_id) values (15, 90);
insert into issue_tag (issue_id, tag_id) values (6, 91);
insert into issue_tag (issue_id, tag_id) values (26, 92);
insert into issue_tag (issue_id, tag_id) values (21, 93);
insert into issue_tag (issue_id, tag_id) values (28, 94);
insert into issue_tag (issue_id, tag_id) values (9, 95);
insert into issue_tag (issue_id, tag_id) values (193, 96);
insert into issue_tag (issue_id, tag_id) values (178, 97);
insert into issue_tag (issue_id, tag_id) values (120, 98);
insert into issue_tag (issue_id, tag_id) values (32, 99);
insert into issue_tag (issue_id, tag_id) values (32, 100);

insert into assigned_user (user_id, issue_id) values (3, 295);
insert into assigned_user (user_id, issue_id) values (10, 174);
insert into assigned_user (user_id, issue_id) values (4, 161);
insert into assigned_user (user_id, issue_id) values (26, 353);
insert into assigned_user (user_id, issue_id) values (4, 5);
insert into assigned_user (user_id, issue_id) values (13, 5);
insert into assigned_user (user_id, issue_id) values (7, 231);
insert into assigned_user (user_id, issue_id) values (25, 294);
insert into assigned_user (user_id, issue_id) values (24, 476);
insert into assigned_user (user_id, issue_id) values (3, 127);
insert into assigned_user (user_id, issue_id) values (7, 363);
insert into assigned_user (user_id, issue_id) values (28, 287);
insert into assigned_user (user_id, issue_id) values (6, 495);
insert into assigned_user (user_id, issue_id) values (21, 190);
insert into assigned_user (user_id, issue_id) values (10, 21);
insert into assigned_user (user_id, issue_id) values (21, 45);
insert into assigned_user (user_id, issue_id) values (7, 264);
insert into assigned_user (user_id, issue_id) values (5, 214);
insert into assigned_user (user_id, issue_id) values (19, 235);
insert into assigned_user (user_id, issue_id) values (1, 349);
insert into assigned_user (user_id, issue_id) values (21, 268);
insert into assigned_user (user_id, issue_id) values (13, 351);
insert into assigned_user (user_id, issue_id) values (16, 316);
insert into assigned_user (user_id, issue_id) values (2, 477);
insert into assigned_user (user_id, issue_id) values (9, 329);
insert into assigned_user (user_id, issue_id) values (29, 450);
insert into assigned_user (user_id, issue_id) values (2, 227);
insert into assigned_user (user_id, issue_id) values (10, 10);
insert into assigned_user (user_id, issue_id) values (13, 153);
insert into assigned_user (user_id, issue_id) values (11, 471);
insert into assigned_user (user_id, issue_id) values (29, 211);
insert into assigned_user (user_id, issue_id) values (3, 226);
insert into assigned_user (user_id, issue_id) values (3, 212);
insert into assigned_user (user_id, issue_id) values (29, 440);
insert into assigned_user (user_id, issue_id) values (22, 63);
insert into assigned_user (user_id, issue_id) values (22, 286);
insert into assigned_user (user_id, issue_id) values (3, 129);
insert into assigned_user (user_id, issue_id) values (19, 305);
insert into assigned_user (user_id, issue_id) values (16, 16);
insert into assigned_user (user_id, issue_id) values (6, 60);
insert into assigned_user (user_id, issue_id) values (28, 462);
insert into assigned_user (user_id, issue_id) values (20, 493);
insert into assigned_user (user_id, issue_id) values (12, 462);
insert into assigned_user (user_id, issue_id) values (15, 320);
insert into assigned_user (user_id, issue_id) values (30, 449);
insert into assigned_user (user_id, issue_id) values (3, 412);
insert into assigned_user (user_id, issue_id) values (13, 14);
insert into assigned_user (user_id, issue_id) values (9, 444);
insert into assigned_user (user_id, issue_id) values (3, 355);
insert into assigned_user (user_id, issue_id) values (1, 401);
insert into assigned_user (user_id, issue_id) values (30, 409);
insert into assigned_user (user_id, issue_id) values (9, 491);
insert into assigned_user (user_id, issue_id) values (4, 162);
insert into assigned_user (user_id, issue_id) values (7, 375);
insert into assigned_user (user_id, issue_id) values (6, 178);
insert into assigned_user (user_id, issue_id) values (17, 461);
insert into assigned_user (user_id, issue_id) values (24, 423);
insert into assigned_user (user_id, issue_id) values (16, 317);
insert into assigned_user (user_id, issue_id) values (18, 286);
insert into assigned_user (user_id, issue_id) values (23, 489);
insert into assigned_user (user_id, issue_id) values (19, 362);
insert into assigned_user (user_id, issue_id) values (4, 97);
insert into assigned_user (user_id, issue_id) values (27, 26);
insert into assigned_user (user_id, issue_id) values (20, 41);
insert into assigned_user (user_id, issue_id) values (14, 75);
insert into assigned_user (user_id, issue_id) values (4, 290);
insert into assigned_user (user_id, issue_id) values (21, 92);
insert into assigned_user (user_id, issue_id) values (23, 126);
insert into assigned_user (user_id, issue_id) values (22, 230);
insert into assigned_user (user_id, issue_id) values (18, 253);
insert into assigned_user (user_id, issue_id) values (28, 491);
insert into assigned_user (user_id, issue_id) values (1, 466);
insert into assigned_user (user_id, issue_id) values (8, 120);
insert into assigned_user (user_id, issue_id) values (17, 483);
insert into assigned_user (user_id, issue_id) values (21, 374);
insert into assigned_user (user_id, issue_id) values (20, 339);
insert into assigned_user (user_id, issue_id) values (3, 188);
insert into assigned_user (user_id, issue_id) values (2, 336);
insert into assigned_user (user_id, issue_id) values (16, 328);
insert into assigned_user (user_id, issue_id) values (11, 303);
insert into assigned_user (user_id, issue_id) values (30, 457);
insert into assigned_user (user_id, issue_id) values (20, 148);
insert into assigned_user (user_id, issue_id) values (1, 482);
insert into assigned_user (user_id, issue_id) values (21, 473);
insert into assigned_user (user_id, issue_id) values (6, 140);
insert into assigned_user (user_id, issue_id) values (4, 427);
insert into assigned_user (user_id, issue_id) values (25, 123);
insert into assigned_user (user_id, issue_id) values (5, 37);
insert into assigned_user (user_id, issue_id) values (23, 94);
insert into assigned_user (user_id, issue_id) values (16, 136);
insert into assigned_user (user_id, issue_id) values (22, 242);
insert into assigned_user (user_id, issue_id) values (28, 27);
insert into assigned_user (user_id, issue_id) values (3, 248);
insert into assigned_user (user_id, issue_id) values (28, 369);
insert into assigned_user (user_id, issue_id) values (11, 311);
insert into assigned_user (user_id, issue_id) values (16, 420);
insert into assigned_user (user_id, issue_id) values (30, 304);
insert into assigned_user (user_id, issue_id) values (6, 209);
insert into assigned_user (user_id, issue_id) values (15, 491);
insert into assigned_user (user_id, issue_id) values (3, 290);
insert into assigned_user (user_id, issue_id) values (26, 435);
insert into assigned_user (user_id, issue_id) values (7, 378);
insert into assigned_user (user_id, issue_id) values (5, 142);
insert into assigned_user (user_id, issue_id) values (23, 411);
insert into assigned_user (user_id, issue_id) values (22, 65);
insert into assigned_user (user_id, issue_id) values (1, 234);
insert into assigned_user (user_id, issue_id) values (16, 464);
insert into assigned_user (user_id, issue_id) values (18, 224);
insert into assigned_user (user_id, issue_id) values (12, 449);
insert into assigned_user (user_id, issue_id) values (4, 16);
insert into assigned_user (user_id, issue_id) values (12, 132);
insert into assigned_user (user_id, issue_id) values (27, 158);
insert into assigned_user (user_id, issue_id) values (9, 485);
insert into assigned_user (user_id, issue_id) values (24, 73);
insert into assigned_user (user_id, issue_id) values (3, 349);
insert into assigned_user (user_id, issue_id) values (17, 236);
insert into assigned_user (user_id, issue_id) values (18, 204);
insert into assigned_user (user_id, issue_id) values (25, 77);
insert into assigned_user (user_id, issue_id) values (20, 63);
insert into assigned_user (user_id, issue_id) values (8, 331);
insert into assigned_user (user_id, issue_id) values (22, 61);
insert into assigned_user (user_id, issue_id) values (16, 308);
insert into assigned_user (user_id, issue_id) values (5, 487);
insert into assigned_user (user_id, issue_id) values (21, 102);
insert into assigned_user (user_id, issue_id) values (7, 7);
insert into assigned_user (user_id, issue_id) values (3, 210);
insert into assigned_user (user_id, issue_id) values (18, 41);
insert into assigned_user (user_id, issue_id) values (4, 469);
insert into assigned_user (user_id, issue_id) values (29, 280);
insert into assigned_user (user_id, issue_id) values (2, 171);
insert into assigned_user (user_id, issue_id) values (8, 71);
insert into assigned_user (user_id, issue_id) values (4, 85);
insert into assigned_user (user_id, issue_id) values (6, 10);
insert into assigned_user (user_id, issue_id) values (24, 102);
insert into assigned_user (user_id, issue_id) values (16, 340);
insert into assigned_user (user_id, issue_id) values (10, 27);
insert into assigned_user (user_id, issue_id) values (18, 208);
insert into assigned_user (user_id, issue_id) values (20, 147);
insert into assigned_user (user_id, issue_id) values (4, 4);
insert into assigned_user (user_id, issue_id) values (21, 262);
insert into assigned_user (user_id, issue_id) values (10, 193);
insert into assigned_user (user_id, issue_id) values (26, 50);
insert into assigned_user (user_id, issue_id) values (28, 110);
insert into assigned_user (user_id, issue_id) values (6, 112);
insert into assigned_user (user_id, issue_id) values (4, 159);
insert into assigned_user (user_id, issue_id) values (11, 314);
insert into assigned_user (user_id, issue_id) values (23, 116);
insert into assigned_user (user_id, issue_id) values (29, 12);
insert into assigned_user (user_id, issue_id) values (11, 461);
insert into assigned_user (user_id, issue_id) values (13, 241);
insert into assigned_user (user_id, issue_id) values (6, 224);
insert into assigned_user (user_id, issue_id) values (30, 174);
insert into assigned_user (user_id, issue_id) values (7, 63);
insert into assigned_user (user_id, issue_id) values (30, 431);
insert into assigned_user (user_id, issue_id) values (18, 402);
insert into assigned_user (user_id, issue_id) values (27, 412);
insert into assigned_user (user_id, issue_id) values (22, 318);
insert into assigned_user (user_id, issue_id) values (19, 443);
insert into assigned_user (user_id, issue_id) values (13, 18);
insert into assigned_user (user_id, issue_id) values (10, 200);
insert into assigned_user (user_id, issue_id) values (5, 356);
insert into assigned_user (user_id, issue_id) values (19, 180);
insert into assigned_user (user_id, issue_id) values (30, 376);
insert into assigned_user (user_id, issue_id) values (5, 210);
insert into assigned_user (user_id, issue_id) values (25, 22);
insert into assigned_user (user_id, issue_id) values (29, 36);
insert into assigned_user (user_id, issue_id) values (3, 432);
insert into assigned_user (user_id, issue_id) values (29, 244);
insert into assigned_user (user_id, issue_id) values (14, 453);
insert into assigned_user (user_id, issue_id) values (20, 468);
insert into assigned_user (user_id, issue_id) values (8, 358);
insert into assigned_user (user_id, issue_id) values (15, 475);
insert into assigned_user (user_id, issue_id) values (26, 364);
insert into assigned_user (user_id, issue_id) values (8, 113);
insert into assigned_user (user_id, issue_id) values (5, 493);
insert into assigned_user (user_id, issue_id) values (23, 255);
insert into assigned_user (user_id, issue_id) values (16, 422);
insert into assigned_user (user_id, issue_id) values (15, 326);
insert into assigned_user (user_id, issue_id) values (12, 268);
insert into assigned_user (user_id, issue_id) values (2, 322);
insert into assigned_user (user_id, issue_id) values (15, 402);
insert into assigned_user (user_id, issue_id) values (30, 139);
insert into assigned_user (user_id, issue_id) values (30, 31);
insert into assigned_user (user_id, issue_id) values (13, 411);
insert into assigned_user (user_id, issue_id) values (3, 238);
insert into assigned_user (user_id, issue_id) values (9, 294);
insert into assigned_user (user_id, issue_id) values (22, 393);
insert into assigned_user (user_id, issue_id) values (15, 232);
insert into assigned_user (user_id, issue_id) values (7, 474);
insert into assigned_user (user_id, issue_id) values (29, 318);
insert into assigned_user (user_id, issue_id) values (20, 380);
insert into assigned_user (user_id, issue_id) values (12, 322);
insert into assigned_user (user_id, issue_id) values (5, 221);
insert into assigned_user (user_id, issue_id) values (27, 326);
insert into assigned_user (user_id, issue_id) values (24, 105);
insert into assigned_user (user_id, issue_id) values (20, 419);
insert into assigned_user (user_id, issue_id) values (21, 392);
insert into assigned_user (user_id, issue_id) values (5, 269);
insert into assigned_user (user_id, issue_id) values (27, 399);
insert into assigned_user (user_id, issue_id) values (18, 255);
insert into assigned_user (user_id, issue_id) values (21, 117);
insert into assigned_user (user_id, issue_id) values (13, 122);
insert into assigned_user (user_id, issue_id) values (17, 414);
insert into assigned_user (user_id, issue_id) values (13, 384);
insert into assigned_user (user_id, issue_id) values (9, 179);
insert into assigned_user (user_id, issue_id) values (1, 347);
insert into assigned_user (user_id, issue_id) values (28, 192);
insert into assigned_user (user_id, issue_id) values (7, 232);
insert into assigned_user (user_id, issue_id) values (10, 488);
insert into assigned_user (user_id, issue_id) values (28, 496);
insert into assigned_user (user_id, issue_id) values (18, 75);
insert into assigned_user (user_id, issue_id) values (13, 498);
insert into assigned_user (user_id, issue_id) values (18, 149);
insert into assigned_user (user_id, issue_id) values (4, 189);
insert into assigned_user (user_id, issue_id) values (12, 485);
insert into assigned_user (user_id, issue_id) values (29, 189);
insert into assigned_user (user_id, issue_id) values (30, 333);
insert into assigned_user (user_id, issue_id) values (15, 13);
insert into assigned_user (user_id, issue_id) values (10, 290);
insert into assigned_user (user_id, issue_id) values (15, 335);
insert into assigned_user (user_id, issue_id) values (24, 277);
insert into assigned_user (user_id, issue_id) values (16, 478);
insert into assigned_user (user_id, issue_id) values (8, 12);
insert into assigned_user (user_id, issue_id) values (27, 483);
insert into assigned_user (user_id, issue_id) values (24, 381);
insert into assigned_user (user_id, issue_id) values (15, 225);
insert into assigned_user (user_id, issue_id) values (9, 261);
insert into assigned_user (user_id, issue_id) values (14, 47);
insert into assigned_user (user_id, issue_id) values (25, 256);
insert into assigned_user (user_id, issue_id) values (3, 171);
insert into assigned_user (user_id, issue_id) values (21, 497);
insert into assigned_user (user_id, issue_id) values (14, 133);
insert into assigned_user (user_id, issue_id) values (27, 100);
insert into assigned_user (user_id, issue_id) values (14, 331);
insert into assigned_user (user_id, issue_id) values (10, 306);
insert into assigned_user (user_id, issue_id) values (25, 151);
insert into assigned_user (user_id, issue_id) values (25, 462);
insert into assigned_user (user_id, issue_id) values (5, 103);
insert into assigned_user (user_id, issue_id) values (1, 123);
insert into assigned_user (user_id, issue_id) values (11, 354);
insert into assigned_user (user_id, issue_id) values (21, 373);
insert into assigned_user (user_id, issue_id) values (11, 191);
insert into assigned_user (user_id, issue_id) values (24, 228);
insert into assigned_user (user_id, issue_id) values (2, 151);
insert into assigned_user (user_id, issue_id) values (25, 66);
insert into assigned_user (user_id, issue_id) values (29, 463);
insert into assigned_user (user_id, issue_id) values (2, 348);
insert into assigned_user (user_id, issue_id) values (14, 470);
insert into assigned_user (user_id, issue_id) values (3, 362);
insert into assigned_user (user_id, issue_id) values (29, 49);
insert into assigned_user (user_id, issue_id) values (26, 302);
insert into assigned_user (user_id, issue_id) values (13, 112);
insert into assigned_user (user_id, issue_id) values (11, 149);
insert into assigned_user (user_id, issue_id) values (20, 447);
insert into assigned_user (user_id, issue_id) values (8, 99);
insert into assigned_user (user_id, issue_id) values (17, 322);
insert into assigned_user (user_id, issue_id) values (13, 29);
insert into assigned_user (user_id, issue_id) values (30, 473);
insert into assigned_user (user_id, issue_id) values (27, 394);
insert into assigned_user (user_id, issue_id) values (1, 294);
insert into assigned_user (user_id, issue_id) values (17, 4);
insert into assigned_user (user_id, issue_id) values (12, 451);
insert into assigned_user (user_id, issue_id) values (3, 152);
insert into assigned_user (user_id, issue_id) values (23, 439);
insert into assigned_user (user_id, issue_id) values (27, 161);
insert into assigned_user (user_id, issue_id) values (4, 246);
insert into assigned_user (user_id, issue_id) values (1, 168);
insert into assigned_user (user_id, issue_id) values (2, 142);
insert into assigned_user (user_id, issue_id) values (6, 496);
insert into assigned_user (user_id, issue_id) values (29, 260);
insert into assigned_user (user_id, issue_id) values (23, 147);
insert into assigned_user (user_id, issue_id) values (16, 125);
insert into assigned_user (user_id, issue_id) values (29, 283);
insert into assigned_user (user_id, issue_id) values (26, 174);
insert into assigned_user (user_id, issue_id) values (2, 95);
insert into assigned_user (user_id, issue_id) values (12, 297);
insert into assigned_user (user_id, issue_id) values (12, 172);
insert into assigned_user (user_id, issue_id) values (10, 167);
insert into assigned_user (user_id, issue_id) values (27, 402);
insert into assigned_user (user_id, issue_id) values (5, 32);
insert into assigned_user (user_id, issue_id) values (18, 313);
insert into assigned_user (user_id, issue_id) values (1, 202);
insert into assigned_user (user_id, issue_id) values (20, 371);
insert into assigned_user (user_id, issue_id) values (2, 379);
insert into assigned_user (user_id, issue_id) values (18, 142);
insert into assigned_user (user_id, issue_id) values (24, 74);
insert into assigned_user (user_id, issue_id) values (2, 366);
insert into assigned_user (user_id, issue_id) values (10, 455);
insert into assigned_user (user_id, issue_id) values (1, 290);
insert into assigned_user (user_id, issue_id) values (27, 425);
insert into assigned_user (user_id, issue_id) values (15, 369);
insert into assigned_user (user_id, issue_id) values (2, 154);
insert into assigned_user (user_id, issue_id) values (2, 333);
insert into assigned_user (user_id, issue_id) values (11, 307);
insert into assigned_user (user_id, issue_id) values (30, 313);
insert into assigned_user (user_id, issue_id) values (16, 295);
insert into assigned_user (user_id, issue_id) values (23, 1);
insert into assigned_user (user_id, issue_id) values (28, 321);
insert into assigned_user (user_id, issue_id) values (1, 475);
insert into assigned_user (user_id, issue_id) values (18, 258);
insert into assigned_user (user_id, issue_id) values (18, 131);
insert into assigned_user (user_id, issue_id) values (28, 36);
insert into assigned_user (user_id, issue_id) values (29, 81);
insert into assigned_user (user_id, issue_id) values (11, 228);
insert into assigned_user (user_id, issue_id) values (10, 161);
insert into assigned_user (user_id, issue_id) values (23, 304);
insert into assigned_user (user_id, issue_id) values (2, 140);
insert into assigned_user (user_id, issue_id) values (29, 419);
insert into assigned_user (user_id, issue_id) values (22, 317);
insert into assigned_user (user_id, issue_id) values (5, 258);
insert into assigned_user (user_id, issue_id) values (4, 179);
insert into assigned_user (user_id, issue_id) values (10, 150);
insert into assigned_user (user_id, issue_id) values (2, 338);
insert into assigned_user (user_id, issue_id) values (13, 431);
insert into assigned_user (user_id, issue_id) values (27, 298);
insert into assigned_user (user_id, issue_id) values (5, 285);
insert into assigned_user (user_id, issue_id) values (19, 137);
insert into assigned_user (user_id, issue_id) values (2, 421);
insert into assigned_user (user_id, issue_id) values (7, 113);
insert into assigned_user (user_id, issue_id) values (4, 372);
insert into assigned_user (user_id, issue_id) values (14, 138);
insert into assigned_user (user_id, issue_id) values (6, 235);
insert into assigned_user (user_id, issue_id) values (24, 67);
insert into assigned_user (user_id, issue_id) values (29, 481);
insert into assigned_user (user_id, issue_id) values (23, 108);
insert into assigned_user (user_id, issue_id) values (4, 24);
insert into assigned_user (user_id, issue_id) values (7, 149);
insert into assigned_user (user_id, issue_id) values (8, 473);
insert into assigned_user (user_id, issue_id) values (29, 258);
insert into assigned_user (user_id, issue_id) values (29, 38);
insert into assigned_user (user_id, issue_id) values (14, 472);
insert into assigned_user (user_id, issue_id) values (14, 357);
insert into assigned_user (user_id, issue_id) values (7, 329);
insert into assigned_user (user_id, issue_id) values (6, 170);
insert into assigned_user (user_id, issue_id) values (7, 217);
insert into assigned_user (user_id, issue_id) values (6, 2);
insert into assigned_user (user_id, issue_id) values (10, 274);
insert into assigned_user (user_id, issue_id) values (23, 465);
insert into assigned_user (user_id, issue_id) values (27, 362);
insert into assigned_user (user_id, issue_id) values (26, 51);
insert into assigned_user (user_id, issue_id) values (9, 138);
insert into assigned_user (user_id, issue_id) values (18, 354);
insert into assigned_user (user_id, issue_id) values (3, 10);
insert into assigned_user (user_id, issue_id) values (10, 442);
insert into assigned_user (user_id, issue_id) values (15, 210);
insert into assigned_user (user_id, issue_id) values (11, 63);
insert into assigned_user (user_id, issue_id) values (23, 313);
insert into assigned_user (user_id, issue_id) values (3, 221);
insert into assigned_user (user_id, issue_id) values (25, 278);
insert into assigned_user (user_id, issue_id) values (29, 156);
insert into assigned_user (user_id, issue_id) values (7, 52);
insert into assigned_user (user_id, issue_id) values (14, 96);
insert into assigned_user (user_id, issue_id) values (6, 471);
insert into assigned_user (user_id, issue_id) values (1, 122);
insert into assigned_user (user_id, issue_id) values (7, 382);
insert into assigned_user (user_id, issue_id) values (25, 13);
insert into assigned_user (user_id, issue_id) values (19, 348);
insert into assigned_user (user_id, issue_id) values (18, 225);
insert into assigned_user (user_id, issue_id) values (11, 378);
insert into assigned_user (user_id, issue_id) values (14, 168);
insert into assigned_user (user_id, issue_id) values (7, 325);
insert into assigned_user (user_id, issue_id) values (10, 359);
insert into assigned_user (user_id, issue_id) values (6, 477);
insert into assigned_user (user_id, issue_id) values (1, 220);
insert into assigned_user (user_id, issue_id) values (9, 101);
insert into assigned_user (user_id, issue_id) values (19, 415);
insert into assigned_user (user_id, issue_id) values (13, 399);
insert into assigned_user (user_id, issue_id) values (14, 2);
insert into assigned_user (user_id, issue_id) values (14, 407);
insert into assigned_user (user_id, issue_id) values (9, 413);
insert into assigned_user (user_id, issue_id) values (22, 205);
insert into assigned_user (user_id, issue_id) values (4, 78);
insert into assigned_user (user_id, issue_id) values (10, 117);
insert into assigned_user (user_id, issue_id) values (1, 150);
insert into assigned_user (user_id, issue_id) values (3, 401);
insert into assigned_user (user_id, issue_id) values (27, 223);
insert into assigned_user (user_id, issue_id) values (13, 139);
insert into assigned_user (user_id, issue_id) values (23, 463);
insert into assigned_user (user_id, issue_id) values (2, 500);
insert into assigned_user (user_id, issue_id) values (18, 320);
insert into assigned_user (user_id, issue_id) values (17, 401);
insert into assigned_user (user_id, issue_id) values (18, 154);
insert into assigned_user (user_id, issue_id) values (20, 365);
insert into assigned_user (user_id, issue_id) values (3, 324);
insert into assigned_user (user_id, issue_id) values (7, 462);
insert into assigned_user (user_id, issue_id) values (17, 159);
insert into assigned_user (user_id, issue_id) values (10, 88);
insert into assigned_user (user_id, issue_id) values (2, 416);
insert into assigned_user (user_id, issue_id) values (24, 85);
insert into assigned_user (user_id, issue_id) values (14, 24);
insert into assigned_user (user_id, issue_id) values (27, 337);
insert into assigned_user (user_id, issue_id) values (19, 178);
insert into assigned_user (user_id, issue_id) values (14, 160);
insert into assigned_user (user_id, issue_id) values (28, 464);
insert into assigned_user (user_id, issue_id) values (4, 6);
insert into assigned_user (user_id, issue_id) values (5, 126);
insert into assigned_user (user_id, issue_id) values (3, 445);
insert into assigned_user (user_id, issue_id) values (9, 253);
insert into assigned_user (user_id, issue_id) values (26, 406);
insert into assigned_user (user_id, issue_id) values (9, 487);
insert into assigned_user (user_id, issue_id) values (10, 5);
insert into assigned_user (user_id, issue_id) values (21, 205);
insert into assigned_user (user_id, issue_id) values (30, 57);
insert into assigned_user (user_id, issue_id) values (22, 228);
insert into assigned_user (user_id, issue_id) values (21, 447);
insert into assigned_user (user_id, issue_id) values (8, 224);
insert into assigned_user (user_id, issue_id) values (3, 112);
insert into assigned_user (user_id, issue_id) values (19, 216);
insert into assigned_user (user_id, issue_id) values (3, 451);
insert into assigned_user (user_id, issue_id) values (18, 240);
insert into assigned_user (user_id, issue_id) values (6, 466);
insert into assigned_user (user_id, issue_id) values (21, 202);
insert into assigned_user (user_id, issue_id) values (20, 139);
insert into assigned_user (user_id, issue_id) values (17, 351);
insert into assigned_user (user_id, issue_id) values (22, 415);
insert into assigned_user (user_id, issue_id) values (6, 478);
insert into assigned_user (user_id, issue_id) values (21, 109);
insert into assigned_user (user_id, issue_id) values (27, 39);
insert into assigned_user (user_id, issue_id) values (29, 157);
insert into assigned_user (user_id, issue_id) values (25, 471);
insert into assigned_user (user_id, issue_id) values (7, 73);
insert into assigned_user (user_id, issue_id) values (26, 393);
insert into assigned_user (user_id, issue_id) values (7, 427);
insert into assigned_user (user_id, issue_id) values (8, 185);
insert into assigned_user (user_id, issue_id) values (30, 497);
insert into assigned_user (user_id, issue_id) values (17, 74);
insert into assigned_user (user_id, issue_id) values (16, 137);
insert into assigned_user (user_id, issue_id) values (3, 31);
insert into assigned_user (user_id, issue_id) values (11, 309);
insert into assigned_user (user_id, issue_id) values (27, 108);
insert into assigned_user (user_id, issue_id) values (22, 149);
insert into assigned_user (user_id, issue_id) values (2, 465);
insert into assigned_user (user_id, issue_id) values (29, 96);
insert into assigned_user (user_id, issue_id) values (20, 437);
insert into assigned_user (user_id, issue_id) values (12, 187);
insert into assigned_user (user_id, issue_id) values (1, 79);
insert into assigned_user (user_id, issue_id) values (21, 241);
insert into assigned_user (user_id, issue_id) values (1, 382);
insert into assigned_user (user_id, issue_id) values (6, 276);
insert into assigned_user (user_id, issue_id) values (24, 367);
insert into assigned_user (user_id, issue_id) values (30, 436);
insert into assigned_user (user_id, issue_id) values (23, 74);
insert into assigned_user (user_id, issue_id) values (2, 306);
insert into assigned_user (user_id, issue_id) values (23, 456);
insert into assigned_user (user_id, issue_id) values (26, 167);
insert into assigned_user (user_id, issue_id) values (27, 368);
insert into assigned_user (user_id, issue_id) values (11, 199);
insert into assigned_user (user_id, issue_id) values (22, 330);
insert into assigned_user (user_id, issue_id) values (14, 379);
insert into assigned_user (user_id, issue_id) values (14, 347);
insert into assigned_user (user_id, issue_id) values (14, 322);
insert into assigned_user (user_id, issue_id) values (26, 350);
insert into assigned_user (user_id, issue_id) values (14, 433);
insert into assigned_user (user_id, issue_id) values (26, 447);
insert into assigned_user (user_id, issue_id) values (30, 202);
insert into assigned_user (user_id, issue_id) values (24, 306);
insert into assigned_user (user_id, issue_id) values (10, 239);
insert into assigned_user (user_id, issue_id) values (29, 359);
insert into assigned_user (user_id, issue_id) values (9, 29);
insert into assigned_user (user_id, issue_id) values (27, 72);
insert into assigned_user (user_id, issue_id) values (23, 311);
insert into assigned_user (user_id, issue_id) values (6, 446);
insert into assigned_user (user_id, issue_id) values (9, 99);
insert into assigned_user (user_id, issue_id) values (19, 278);
insert into assigned_user (user_id, issue_id) values (20, 51);
insert into assigned_user (user_id, issue_id) values (3, 98);
insert into assigned_user (user_id, issue_id) values (20, 435);
insert into assigned_user (user_id, issue_id) values (19, 495);
insert into assigned_user (user_id, issue_id) values (25, 304);
insert into assigned_user (user_id, issue_id) values (19, 215);
insert into assigned_user (user_id, issue_id) values (14, 439);
insert into assigned_user (user_id, issue_id) values (2, 365);
insert into assigned_user (user_id, issue_id) values (17, 476);
insert into assigned_user (user_id, issue_id) values (25, 60);
insert into assigned_user (user_id, issue_id) values (28, 176);
insert into assigned_user (user_id, issue_id) values (29, 188);
insert into assigned_user (user_id, issue_id) values (1, 127);
insert into assigned_user (user_id, issue_id) values (26, 473);
insert into assigned_user (user_id, issue_id) values (15, 347);
insert into assigned_user (user_id, issue_id) values (2, 434);
insert into assigned_user (user_id, issue_id) values (17, 142);
insert into assigned_user (user_id, issue_id) values (18, 163);
insert into assigned_user (user_id, issue_id) values (5, 387);
insert into assigned_user (user_id, issue_id) values (21, 44);
insert into assigned_user (user_id, issue_id) values (27, 31);
insert into assigned_user (user_id, issue_id) values (14, 431);
insert into assigned_user (user_id, issue_id) values (7, 388);
insert into assigned_user (user_id, issue_id) values (3, 482);
insert into assigned_user (user_id, issue_id) values (5, 310);
insert into assigned_user (user_id, issue_id) values (7, 181);
insert into assigned_user (user_id, issue_id) values (7, 248);
insert into assigned_user (user_id, issue_id) values (13, 287);

insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-06-03 07:30:55',  22, 15);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-07-19 12:12:39',  16, 27);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-03-01 05:54:01', 29, 2);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-08-08 07:34:08', 28, 29);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-03-29 06:27:16',  20, 6);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-06-25 19:27:09', 14, 10);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-09-12 11:04:17',  1, 9);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-02-25 22:43:31',  8, 16);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-10-13 14:54:58',  27, 4);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-02-18 12:56:27', 2, 18);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-01-08 11:51:47', 2, 1);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-02-20 09:43:37', 23, 21);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-03-10 10:55:33', 2, 29);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-08-21 23:37:47',  21, 12);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-06-29 13:41:34',  20, 7);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-09-12 00:33:25',  24, 21);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-08-07 05:27:17',  12, 16);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-08-25 18:08:17',  21, 7);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-12-13 18:20:13',  17, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-09-05 17:03:11',  13, 14);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-12-28 18:26:21', 7, 16);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-08-17 02:18:39',  15, 7);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-11-15 09:33:22',  4, 21);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-07-23 00:19:26',  25, 1);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-17 22:04:26', 19, 14);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-11-06 10:50:07',  21, 8);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-28 20:11:52',  19, 30);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-09-12 06:41:50', 11, 8);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-02-05 02:23:14',  24, 9);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-02-19 07:56:38',  25, 10);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-02-08 16:00:37',  19, 3);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-08 04:42:23',  28, 23);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-06-22 14:21:21',  2, 1);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-06-07 07:46:39', 21, 27);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-05-05 22:37:11',  30, 6);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-10-08 22:21:51',  21, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-22 09:58:56', 3, 8);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-01-19 12:59:13', 2, 23);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-08-08 15:11:52',  18, 4);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-11-06 08:32:40', 6, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-08-27 05:35:39',  16, 15);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-12-03 09:04:42', 13, 2);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-10-24 08:10:55', 17, 14);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-05-18 12:44:00',  3, 2);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-03-12 07:30:33', 26, 3);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-07-05 02:12:10', 17, 26);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-02-08 12:39:59',  11, 20);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-03-16 11:54:39', 4, 30);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-12 21:48:51', 18, 4);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-03 22:57:58', 26, 11);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-02-18 06:49:02',  11, 25);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-02-27 11:13:00',  14, 24);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-10-28 01:36:56', 7, 2);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-09-30 11:35:48',  3, 22);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-03-10 23:54:38', 5, 21);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-08-08 00:51:11',  7, 5);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-04-07 19:34:55', 17, 14);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-03-22 11:22:33',  15, 21);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-01-01 23:31:54',  2, 21);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-12-20 19:36:36', 30, 10);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-08-17 07:23:33',  4, 1);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-18 08:47:19',  19, 3);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-05-29 13:05:37', 6, 23);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-09-25 01:52:32', 12, 6);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-09-20 22:05:27', 17, 16);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-09-04 17:21:53', 18, 27);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2023-02-12 14:36:02', 7, 26);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-01-24 20:00:13', 29, 4);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-04-20 20:07:48',  20, 13);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-10-13 19:02:56',  14, 13);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-01 12:42:30',  22, 5);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-12-12 04:58:10',  21, 25);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-01-05 07:42:50', 4, 11);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-06-23 08:39:36',  27, 2);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-08-25 14:14:22',  14, 25);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-11-12 12:13:54',  11, 30);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-09-18 09:28:57', 12, 7);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2020-08-04 19:13:48', 25, 23);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2021-06-11 14:28:27',  12, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-14 06:31:57', 20, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-14 06:31:57', 31, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-13 06:31:57', 31, 28);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-17 06:31:57', 31, 25);
insert into notification (id, "date",  receiver_id, sender_id) values (DEFAULT, '2022-06-18 06:31:57', 31, 24);




insert into notification_kick (notification_id, project_id) values (1, 45);
insert into notification_kick (notification_id, project_id) values (2, 24);
insert into notification_kick (notification_id, project_id) values (3, 40);
insert into notification_kick (notification_id, project_id) values (4, 11);
insert into notification_kick (notification_id, project_id) values (5, 4);
insert into notification_kick (notification_id, project_id) values (6, 42);
insert into notification_kick (notification_id, project_id) values (7, 49);
insert into notification_kick (notification_id, project_id) values (8, 16);
insert into notification_kick (notification_id, project_id) values (9, 6);
insert into notification_kick (notification_id, project_id) values (10, 30);
insert into notification_kick (notification_id, project_id) values (11, 10);
insert into notification_kick (notification_id, project_id) values (12, 50);
insert into notification_kick (notification_id, project_id) values (13, 6);
insert into notification_kick (notification_id, project_id) values (14, 12);
insert into notification_kick (notification_id, project_id) values (15, 40);
insert into notification_kick (notification_id, project_id) values (16, 15);
insert into notification_kick (notification_id, project_id) values (17, 38);
insert into notification_kick (notification_id, project_id) values (18, 2);
insert into notification_kick (notification_id, project_id) values (19, 26);
insert into notification_kick (notification_id, project_id) values (20, 15);
insert into notification_kick (notification_id, project_id) values (81, 15);
insert into notification_kick (notification_id, project_id) values (83, 15);



insert into notification_invite (notification_id, project_id) values (21, 26);
insert into notification_invite (notification_id, project_id) values (22, 10);
insert into notification_invite (notification_id, project_id) values (23, 9);
insert into notification_invite (notification_id, project_id) values (24, 29);
insert into notification_invite (notification_id, project_id) values (25, 34);
insert into notification_invite (notification_id, project_id) values (26, 7);
insert into notification_invite (notification_id, project_id) values (27, 30);
insert into notification_invite (notification_id, project_id) values (28, 2);
insert into notification_invite (notification_id, project_id) values (29, 49);
insert into notification_invite (notification_id, project_id) values (30, 4);
insert into notification_invite (notification_id, project_id) values (31, 46);
insert into notification_invite (notification_id, project_id) values (32, 44);
insert into notification_invite (notification_id, project_id) values (33, 20);
insert into notification_invite (notification_id, project_id) values (34, 48);
insert into notification_invite (notification_id, project_id) values (35, 37);
insert into notification_invite (notification_id, project_id) values (36, 1);
insert into notification_invite (notification_id, project_id) values (37, 6);
insert into notification_invite (notification_id, project_id) values (38, 17);
insert into notification_invite (notification_id, project_id) values (39, 35);
insert into notification_invite (notification_id, project_id) values (40, 42);
insert into notification_invite (notification_id, project_id) values (82, 15);
insert into notification_invite (notification_id, project_id) values (84, 15);


insert into vote (user_id, comment_id, upvote) values (31, 1, -1);
insert into vote (user_id, comment_id, upvote) values (18, 1, 1);
insert into vote (user_id, comment_id, upvote) values (7, 36, -1);
insert into vote (user_id, comment_id, upvote) values (6, 78, 1);
insert into vote (user_id, comment_id, upvote) values (8, 9, -1);
insert into vote (user_id, comment_id, upvote) values (22, 83, -1);
insert into vote (user_id, comment_id, upvote) values (23, 81,-1);
insert into vote (user_id, comment_id, upvote) values (20, 8, -1);
insert into vote (user_id, comment_id, upvote) values (21, 86, -1);
insert into vote (user_id, comment_id, upvote) values (14, 7, 1);
insert into vote (user_id, comment_id, upvote) values (23, 52, -1);
insert into vote (user_id, comment_id, upvote) values (27, 50, 1);
insert into vote (user_id, comment_id, upvote) values (21, 27, -1);
insert into vote (user_id, comment_id, upvote) values (22, 97, 1);
insert into vote (user_id, comment_id, upvote) values (16, 57, -1);
insert into vote (user_id, comment_id, upvote) values (9, 12, 1);
insert into vote (user_id, comment_id, upvote) values (25, 90, -1);
insert into vote (user_id, comment_id, upvote) values (2, 38, 1);
insert into vote (user_id, comment_id, upvote) values (5, 55, -1);
insert into vote (user_id, comment_id, upvote) values (10, 64, -1);
insert into vote (user_id, comment_id, upvote) values (2, 83, -1);
insert into vote (user_id, comment_id, upvote) values (8, 60, -1);
insert into vote (user_id, comment_id, upvote) values (8, 69, -1);
insert into vote (user_id, comment_id, upvote) values (2, 63, 1);
insert into vote (user_id, comment_id, upvote) values (15, 33, 1);
insert into vote (user_id, comment_id, upvote) values (19, 100, 1);
insert into vote (user_id, comment_id, upvote) values (23, 38, -1);
insert into vote (user_id, comment_id, upvote) values (23, 25, -1);
insert into vote (user_id, comment_id, upvote) values (22, 36, 1);
insert into vote (user_id, comment_id, upvote) values (24, 50, 1);



