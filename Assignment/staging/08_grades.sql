CREATE TABLE grades (
    grades_id       INTEGER
        GENERATED BY DEFAULT AS IDENTITY START WITH 1000,
    min             FLOAT,
    max             FLOAT,
    received_mark   FLOAT,
    representation  VARCHAR2(5 CHAR),
    passing_grade   FLOAT,
    person_id       INTEGER,
    course_id       INTEGER
);

DROP TABLE grades;

SELECT
    *
FROM
    grades;

DESC person_role_faculty_course;

DESC grades;

COMMIT;

ALTER TABLE grades ADD CONSTRAINT grades_pk PRIMARY KEY ( grades_id );
--------
INSERT INTO grades (
    min,
    max,
    received_mark,
    representation,
    passing_grade,
    person_id,
    course_id
)
    SELECT
        minn,
        maxx,
        received_mark,
        CASE received_mark
            WHEN 2  THEN
                'F'
            WHEN 3  THEN
                'C'
            WHEN 4  THEN
                'B'
            WHEN 5  THEN
                'A'
            ELSE
                'X'
        END representation,
        passing_grade,
        person_id,
        course_id
    FROM
        (
            SELECT
                2                                        minn,
                5                                        maxx,
                trunc(dbms_random.value(2, 6))           received_mark,
                3                                        passing_grade,
                prf.person_id                            person_id,
                c.course_id                              course_id,
                c.course_title                           course_title
            FROM
                     course c
                JOIN person_role_faculty_course  prfc ON prfc.course_id = c.course_id
                JOIN person_role_faculty         prf ON prf.person_role_faculty_id = prfc.person_role_faculty_id
                JOIN role                        r ON r.role_id = prf.role_id
            WHERE
                r.role_name = 'STUDENT'
            ORDER BY
                prf.person_id,
                c.course_id,
                c.course_id,
                c.course_title
        );
--------

INSERT INTO grades (
    min,
    max,
    received_mark,
    representation,
    passing_grade,
    person_person_id
)
    SELECT
        minn,
        maxx,
        received_mark,
        CASE received_mark
            WHEN 2  THEN
                'F'
            WHEN 3  THEN
                'C'
            WHEN 4  THEN
                'B'
            WHEN 5  THEN
                'A'
            ELSE
                'X'
        END representation,
        3,
        z.person_id
    FROM
        (
            SELECT
                2                                        minn,
                5                                        maxx,
                trunc(dbms_random.value(2, 6))           received_mark,
                3                                        passing_grade,
                p.person_id
            FROM
                     person p
                JOIN course c ON ( p.person_id = c.person_person_id )
        ) z;

COMMIT;