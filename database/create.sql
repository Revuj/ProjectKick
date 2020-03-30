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
    name text NOT NULL,
    phone_number text UNIQUE,
    photo_path text,
    is_deleted bool DEFAULT false NOT NULL,
    is_admin bool DEFAULT false NOT NULL,
    country_id integer NOT NULL REFERENCES country  ON DELETE CASCADE
                                                     ON UPDATE CASCADE,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    is_banned bool DEFAULT false NOT NULL
);

CREATE TABLE project (
    id SERIAL PRIMARY KEY,
    name text NOT NULL,
    description text NOT NULL,
    creation_date timestamp with time zone DEFAULT now() NOT NULL,
    finish_date timestamp with time zone CHECK (finish_date > creation_date),
    author_id integer NOT NULL REFERENCES "user" ON DELETE CASCADE
                                                     ON UPDATE CASCADE
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
                                                     ON UPDATE CASCADE
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
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone CHECK (end_date > start_date)
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
                                                     ON UPDATE CASCADE
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
