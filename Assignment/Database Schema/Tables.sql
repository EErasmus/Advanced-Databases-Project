-- Tables Schema
CREATE TABLE address (
    addr1                                   VARCHAR2(200)
    ,
    addr2                                   VARCHAR2(200)
    ,
    postal_code                             VARCHAR2(20)
    ,
    city                                    VARCHAR2(50)
    ,
    state                                   VARCHAR2(50)
    ,
    alternate_form                          VARCHAR2(100)
    ,
    address_id                              INTEGER NOT NULL,
    name                                    VARCHAR2(100)
    ,
    faculty_faculty_id                      INTEGER NULL,
    university_university_id                INTEGER NULL,
    person_to_address_id  		    NUMBER NULL
);

-- CREATE UNIQUE INDEX address__idx ON
--    address (
--        person_to_address_person_to_address_id
--    ASC );

--CREATE UNIQUE INDEX address__idxv1 ON
--    address (
--        faculty_faculty_id
--    ASC );

--CREATE UNIQUE INDEX address__idxv2 ON
--    address (
--        university_university_id
--    ASC );


ALTER TABLE address ADD CONSTRAINT address_pk PRIMARY KEY ( address_id );


CREATE TABLE course (
    course_title                            VARCHAR2(50)      NOT NULL,
    course_type                             VARCHAR2(50)      NOT NULL,
    meeting_day_1                           INTEGER,
    meeting_time                            BLOB,
    credits                                 INTEGER,
    course_id                               INTEGER NOT NULL,
    course_level                            INTEGER NOT NULL,
    person_person_id1                       INTEGER,
    faculty_faculty_id                      INTEGER,
    start_date                              DATE,
    end_date                                DATE,
    course_to_faculty_id  		    NUMBER,
    faculty_faculty_id1                     INTEGER
);

--CREATE UNIQUE INDEX course__idx ON
--    course (
--        course_to_faculty_course_to_faculty_id
--    ASC );

ALTER TABLE course ADD CONSTRAINT course_pk PRIMARY KEY ( course_id );

CREATE TABLE faculty (
    name                                    VARCHAR2(100)    ,
    year_founded                            DATE,
    building                                VARCHAR2(25)    ,
    stem                                    CHAR(1),
    professional                            CHAR(1),
    faculty_id                              INTEGER NOT NULL,
    university_university_id                INTEGER,
    address_address_id                      INTEGER, 
--    course_to_faculty_course_to_faculty_id  NUMBER
);

--CREATE UNIQUE INDEX faculty__idx ON
--    faculty (
--        address_address_id
--    ASC );

--CREATE UNIQUE INDEX faculty__idx ON
--    faculty (
--        course_to_faculty_course_to_faculty_id
--    ASC );

ALTER TABLE faculty ADD CONSTRAINT faculty_pk PRIMARY KEY ( faculty_id );

CREATE TABLE grades (
    min                FLOAT,
    max                FLOAT,
    received_mark      FLOAT,
    representation     VARCHAR2(200),
    passing_grade      FLOAT,
    grades_id          INTEGER,
    person_person_id1  INTEGER
);

ALTER TABLE grades ADD CONSTRAINT grades_pk PRIMARY KEY ( grades_id );

CREATE TABLE meeting (
    meeting_id        INTEGER,
    meeting_time      TIMESTAMP,
    duration_minutes  INTEGER,
    meeting_type      VARCHAR2(15),
    priority          VARCHAR2(10),
    notes             VARCHAR2(150),
    location_note     VARCHAR2(20),
    meeting_day       INTEGER,
    course_course_id  INTEGER
);

--COMMENT ON COLUMN meeting.meeting_type IS
--    'in person, remote, in person and remote';

--COMMENT ON COLUMN meeting.location_note IS
--    'room number, zoom url, etc';

ALTER TABLE meeting ADD CONSTRAINT meeting_pk PRIMARY KEY ( meeting_id );

CREATE TABLE person (
    lastname        VARCHAR2(50),
    firstname       VARCHAR2(50) ,
    middlename      VARCHAR2(50),
    fullname        VARCHAR2(150),
    dob             DATE,
    highest_degree  VARCHAR2(100),
    suffix          VARCHAR2(50),
    title           VARCHAR2(25),
    gender          VARCHAR2(15),
    person_id       NUMBER NOT NULL,
--    person_id2      INTEGER
);

--ALTER TABLE person ADD CONSTRAINT person_pkv2 UNIQUE ( person_id2 );

ALTER TABLE person ADD CONSTRAINT person_pk PRIMARY KEY( person_id );

CREATE TABLE person_to_address (
    address_eff_date      DATE,
    person_person_id1     INTEGER,
    address_address_id    INTEGER NOT NULL,
    person_to_address_id  NUMBER NOT NULL
);

--CREATE UNIQUE INDEX person_to_address__idx ON
--    person_to_address (
--        address_address_id
--    ASC );

ALTER TABLE person_to_address ADD CONSTRAINT person_to_address_pk PRIMARY KEY ( person_to_address_id );

CREATE TABLE role (
    rolename             VARCHAR2(100),
    role_level           INTEGER,
    privileged           CHAR(1),
    role_type            VARCHAR2(25)     NOT NULL,
    new_role             CHAR(1),
    person_person_id1    INTEGER,
    faculty_faculty_id   INTEGER,
    faculty_faculty_id2  INTEGER,
    active               CHAR(1),
    eff_date             DATE
);

--CREATE UNIQUE INDEX role__idx ON
--    role (
--        faculty_faculty_id
--    ASC );

ALTER TABLE role ADD CONSTRAINT role_pk PRIMARY KEY ( role_type );

CREATE TABLE university (
    name                VARCHAR2(150),
    country             VARCHAR2(50),
    year_founded        DATE,
    "public"            CHAR(1),
    tuition             INTEGER,
    university_id       INTEGER NOT NULL,
    address_address_id  INTEGER
);

--CREATE UNIQUE INDEX university__idx ON
--    university (
--        address_address_id
--    ASC );

ALTER TABLE university ADD CONSTRAINT university_pk PRIMARY KEY ( university_id );

-- =============== FORIEGN KEYS ================

ALTER TABLE address
    ADD CONSTRAINT address_faculty_fk FOREIGN KEY ( faculty_faculty_id )
        REFERENCES faculty ( faculty_id );

ALTER TABLE address
    ADD CONSTRAINT address_university_fk FOREIGN KEY ( university_university_id )
        REFERENCES university ( university_id );

ALTER TABLE course
    ADD CONSTRAINT course_faculty_fk FOREIGN KEY ( faculty_faculty_id1 )
        REFERENCES faculty ( faculty_id );

ALTER TABLE course
    ADD CONSTRAINT course_person_fk FOREIGN KEY ( person_person_id1 )
        REFERENCES person ( person_id );

ALTER TABLE faculty
    ADD CONSTRAINT faculty_university_fk FOREIGN KEY ( university_university_id )
        REFERENCES university ( university_id );

ALTER TABLE grades
    ADD CONSTRAINT grades_person_fk FOREIGN KEY ( person_person_id1 )
        REFERENCES person ( person_id );

ALTER TABLE meeting
    ADD CONSTRAINT meeting_course_fk FOREIGN KEY ( course_course_id )
        REFERENCES course ( course_id );

ALTER TABLE person_to_address
    ADD CONSTRAINT person_to_address_address_fk FOREIGN KEY ( address_address_id )
        REFERENCES address ( address_id );

ALTER TABLE person_to_address
    ADD CONSTRAINT person_to_address_person_fk FOREIGN KEY ( person_person_id1 )
        REFERENCES person ( person_id );

ALTER TABLE role
    ADD CONSTRAINT role_faculty_fk FOREIGN KEY ( faculty_faculty_id2 )
        REFERENCES faculty ( faculty_id );

ALTER TABLE role
    ADD CONSTRAINT role_person_fk FOREIGN KEY ( person_person_id1 )
        REFERENCES person ( person_id );

