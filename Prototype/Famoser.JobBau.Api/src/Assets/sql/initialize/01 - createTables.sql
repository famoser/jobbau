CREATE TABLE persons (
  id              INTEGER PRIMARY KEY,
  guid            TEXT,
  first_name      TEXT,
  last_name       TEXT,
  street_and_nr   TEXT,
  address_line_2  TEXT,
  plz             TEXT,
  place           TEXT,
  land            TEXT,
  email           TEXT,
  mobile          TEXT,
  birthday_date   INTEGER,
  picture_src     TEXT,
  looking_for_job TINYINT,
  comment         TEXT
);

CREATE TABLE person_meta_data (
  id              INTEGER PRIMARY KEY,
  person_id       INTEGER,
  comment_private TEXT,
  status_private  INTEGER
);

CREATE TABLE professions (
  id   INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE trainings (
  id            INTEGER PRIMARY KEY,
  profession_id INTEGER,
  name          TEXT
);

CREATE TABLE skills (
  id              INTEGER PRIMARY KEY,
  name            TEXT,
  type            INTEGER,
  additional_data TEXT
);

CREATE TABLE profession_info (
  id             INTEGER PRIMARY KEY,
  person_id      INTEGER,
  profession_id  INTEGER,
  other_beruf    TEXT,
  training_id    INTEGER,
  other_training TEXT,
  experience     INTEGER
);

CREATE TABLE skill_info (
  id        INTEGER PRIMARY KEY,
  person_id INTEGER,
  skill_id  INTEGER,
  value     INTEGER
);

CREATE TABLE availability (
  id         INTEGER PRIMARY KEY,
  person_id  INTEGER,
  start_date INTEGER,
  end_date   INTEGER
);