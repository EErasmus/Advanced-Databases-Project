create or replace NONEDITIONABLE PROCEDURE query_1_student_count AS
    begin_time     TIMESTAMP := systimestamp;
    time_duration  INTERVAL DAY TO SECOND;
    data_size      INTEGER;
BEGIN
                                                                                                                                                  (
                    SELECT
                        u.university_id      university_id,
                        u.university_name    university_name,
                        f.faculty_id         faculty_id,
                        f.faculty_name       faculty_name,
                        c.course_id          course_id,
                        c.course_title       course_title,
                        COUNT(*)             students
                    FROM
                        university                  u
                        LEFT OUTER JOIN faculty                     f ON u.university_id = f.university_id
                        LEFT OUTER JOIN course                      c ON c.faculty_id = f.faculty_id
                        LEFT OUTER JOIN person_role_faculty_course  prfc ON prfc.course_id = c.course_id
                        LEFT OUTER JOIN person_role_faculty         prf ON prf.person_role_faculty_id = prfc.person_role_faculty_id
                        LEFT OUTER JOIN role                        r ON r.role_id = prf.role_id
                    WHERE
                        r.role_name = 'STUDENT'
                    GROUP BY
                        u.university_id,
                        u.university_name,
                        f.faculty_id,
                        f.faculty_name,
                        c.course_id,
                        c.course_title
                ;

    time_duration := systimestamp - begin_time;
    ROLLBACK;
    dbms_output.put_line('rows processed: ' || data_size);
    dbms_output.put_line('duration: ' || extract(SECOND FROM time_duration));
    add_result('query_1_student_count', extract(SECOND FROM time_duration), data_size);
    COMMIT;
END;
 

--variable cursor_output refcursor;
--EXECUTE university_faculty_courses_student_count;




CREATE OR REPLACE NONEDITIONABLE PROCEDURE query_2_normal_scores AS
    begin_time     TIMESTAMP := systimestamp;
    time_duration  INTERVAL DAY TO SECOND;
    data_size      INTEGER;
BEGIN
    SELECT
        cnt
    INTO data_size
    FROM
        (
            SELECT
                COUNT(*) cnt
            FROM
            -------------------------------------------
                                                                                                                                                                          (
                    SELECT
                        p.person_id,
                        p.fullname,
                        u.university_id,
                        u.university_name,
                        f.faculty_id,
                        f.faculty_name,
                        c.course_id,
                        c.course_title,
                        g.received_mark - ( AVG(g.received_mark)
                                            OVER(PARTITION BY c.course_id) ) / STDDEV(g.received_mark)
                                                                               OVER(PARTITION BY c.course_id) z_score
                    FROM
                             university u
                        JOIN faculty                     f ON u.university_id = f.university_id
                        JOIN course                      c ON c.faculty_id = f.faculty_id
                        JOIN person_role_faculty_course  prfc ON prfc.course_id = c.course_id
                        JOIN person_role_faculty         prf ON prf.person_role_faculty_id = prfc.person_role_faculty_id
                        JOIN person                      p ON prf.person_id = p.person_id
                        JOIN role                        r ON r.role_id = prf.role_id
                        JOIN grades                      g ON ( g.person_id = p.person_id
                                           AND g.course_id = c.course_id )
                    WHERE
                        r.role_name = 'STUDENT'
                    ORDER BY
                        u.university_id,
                        u.university_name,
                        f.faculty_id,
                        f.faculty_name,
                        c.course_id,
                        c.course_title,
                        p.fullname
                )
                -------------------------------------------
                            );

    time_duration := systimestamp - begin_time;
    ROLLBACK;
    dbms_output.put_line('rows processed: ' || data_size);
    dbms_output.put_line('duration: ' || extract(SECOND FROM time_duration));
    add_result('query_2_normal_scores', extract(SECOND FROM time_duration), data_size);
    COMMIT;
END;
 

--variable cursor_output refcursor;
--EXECUTE university_faculty_courses_student_count;




CREATE OR REPLACE PROCEDURE query_3_rank_avg AS
    begin_time     TIMESTAMP := systimestamp;
    time_duration  INTERVAL DAY TO SECOND;
    data_size      INTEGER;
BEGIN
    SELECT
        cnt
    INTO data_size
    FROM
        (
            SELECT
                COUNT(*) cnt
            FROM
            -------------------------------------------
                                                                                                                                                                                                  (
                    SELECT
                        university_id,
                        university_name,
                        faculty_id,
                        faculty_name,
                        course_id,
                        course_title,
                        average_grade,
                        RANK()
                        OVER(PARTITION BY university_id, faculty_id
                             ORDER BY average_grade
                        ) course_rank
                    FROM
                        (
                            SELECT
                                u.university_id,
                                u.university_name,
                                f.faculty_id,
                                f.faculty_name,
                                c.course_id,
                                c.course_title,
                                AVG(g.received_mark) average_grade
                            FROM
                                     university u
                                JOIN faculty                     f ON u.university_id = f.university_id
                                JOIN course                      c ON c.faculty_id = f.faculty_id
                                JOIN person_role_faculty_course  prfc ON prfc.course_id = c.course_id
                                JOIN person_role_faculty         prf ON prf.person_role_faculty_id = prfc.person_role_faculty_id
            --JOIN person                      p ON prf.person_id = p.person_id
                                                                    JOIN
                                role                        r ON r.role_id = prf.role_id
                                JOIN grades                      g ON ( g.person_id = prf.person_id
                                                   AND g.course_id = c.course_id )
                            WHERE
                                r.role_name = 'STUDENT'
                            GROUP BY
                                u.university_id,
                                u.university_name,
                                f.faculty_id,
                                f.faculty_name,
                                c.course_id,
                                c.course_title
                        )
                    ORDER BY
                        university_id,
                        faculty_id,
                        course_rank
                )
                -------------------------------------------
                                            );

    time_duration := systimestamp - begin_time;
    dbms_output.put_line('rows processed: ' || data_size);
    dbms_output.put_line('duration: ' || extract(SECOND FROM time_duration));
    add_result('query_3_rank_avg', extract(SECOND FROM time_duration), data_size);
    COMMIT;
END;
 

--variable cursor_output refcursor;
--EXECUTE university_faculty_courses_student_count;




CREATE OR REPLACE NONEDITIONABLE PROCEDURE trans_1_enroll_students AS
    begin_time     TIMESTAMP := systimestamp;
    time_duration  INTERVAL DAY TO SECOND;
    data_size      INTEGER;
BEGIN
    INSERT INTO person_role_faculty_course (
        person_role_faculty_id,
        course_id,
        effdt,
        active
    )
        SELECT
            p.person_role_faculty_id,
            c.course_id,
            '01-jan-2020'  effdt,
            'X'            active
        FROM
                 x_person_role_faculty_vw p
            JOIN course c ON ( p.faculty_id = c.faculty_id )
        WHERE
            p.highest_degree = c.course_level - 1;

    data_size := SQL%rowcount;
    rollback;
    time_duration := systimestamp - begin_time;
    dbms_output.put_line('rows processed: ' || data_size);
    dbms_output.put_line('duration: ' || extract(SECOND FROM time_duration));
    add_result('trans_1_enroll_students', extract(SECOND FROM time_duration), data_size);
    COMMIT;
END;



CREATE OR REPLACE NONEDITIONABLE PROCEDURE trans_2_unenroll_students AS
    begin_time     TIMESTAMP := systimestamp;
    time_duration  INTERVAL DAY TO SECOND;
    data_size      INTEGER;
BEGIN
            MERGE INTO person_role_faculty_course prfc
    USING (
              SELECT
                  p.person_role_faculty_id,
                  c.course_id,
                  '01-jan-2020'  effdt,
                  'X'            active
              FROM
                       x_person_role_faculty_vw p
                  JOIN course c ON ( p.faculty_id = c.faculty_id )
              WHERE
                  p.highest_degree = c.course_level - 1
          )
    new_courses ON ( new_courses.person_role_faculty_id = prfc.person_role_faculty_id
                     AND new_courses.course_id = prfc.course_id
                     AND prfc.effdt = new_courses.effdt )
    WHEN MATCHED THEN UPDATE
    SET prfc.active = 'X' DELETE
    WHERE
        1 = 1;

    data_size := SQL%rowcount;
    ROLLBACK;
    time_duration := systimestamp - begin_time;
    dbms_output.put_line('rows processed: ' || data_size);

    add_result('trans_2_unenroll_students', extract(MINUTE FROM time_duration) * 60 + extract(SECOND FROM time_duration),
              data_size);

    COMMIT;
END;



---------------------------------------------------------
-- test 1 --
ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_1_student_count;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_1_student_count;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_1_student_count;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_1_student_count;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_1_student_count;

-- test 2 --
ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;
--EXECUTE query_2_normal_scores;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;
--EXECUTE query_2_normal_scores;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;
--EXECUTE query_2_normal_scores;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;
--EXECUTE query_2_normal_scores;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;
--EXECUTE query_2_normal_scores;

-- test 3 --
ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_3_rank_avg;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_3_rank_avg;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_3_rank_avg;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_3_rank_avg;

ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE query_3_rank_avg;

-- test 4 --
ALTER SYSTEM FLUSH BUFFER_CACHE;

ALTER SYSTEM FLUSH SHARED_POOL;

EXECUTE trans_1_enroll_students;


-- test 5 --
ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;
EXECUTE trans_2_unenroll_students;



-- generate the results table --

SELECT
    trial_name,
    COUNT(*)                                                trial_runs,
    to_char(MIN(trial_time), '99999999.999')                      min_time,
    to_char(MAX(trial_time), '99999999.999')                      max_time,
    to_char(AVG(trial_time), '99999999.999')                      avg_time,
    to_char(AVG(trial_volume), '9999999999999.999')         average_volume
FROM
    result
GROUP BY
    trial_name
ORDER BY
    trial_name;
commit;

