-- Rating Logic Tables

CREATE TABLE encounters
(
    id                      INTEGER PRIMARY KEY NOT NULL,
    contact_identifier      TEXT,
    contact_initials        TEXT,
    contact_picture_path    TEXT,
    contact_avatar_color    INTEGER,
    contact_display_name    TEXT,
    contact_encounter_type  TEXT,
    encountered_at          INTEGER
);

CREATE TABLE contacts
(
    id                      INTEGER PRIMARY KEY NOT NULL,
    internal_identifier     INTEGER,
    initials                TEXT,
    picture_path            TEXT,
    avatar_color            INTEGER,
    display_name            TEXT,
    phone                   TEXT,
    firebase_uid            INTEGER,
    firebase_phone          TEXT,
    share_status            INTEGER DEFAULT 0,
    living_together         INTEGER DEFAULT 0
);
