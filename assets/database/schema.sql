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
