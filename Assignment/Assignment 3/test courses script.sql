create table course_master as 
select 1 as course_title, 5 as credits, TO_CHAR(SYSDATE, 'MM-DD-YYYY') as start_date,TO_CHAR(SYSDATE, 'MM-DD-YYYY') as end_date  from dual union
select 2 as  course_title, 5 as credits, TO_CHAR(SYSDATE, 'MM-DD-YYYY') as start_date,TO_CHAR(SYSDATE, 'MM-DD-YYYY') as end_date  from dual union
select 3 as  course_title, 5 as credits, TO_CHAR(SYSDATE, 'MM-DD-YYYY') as start_date,TO_CHAR(SYSDATE, 'MM-DD-YYYY') as end_date  from dual

create table t as 
select course_master.*,faculty_test.university_id  from course_master cross join 
faculty_test --where faculty_test.name = 'Faculty of Microsystem Electronics and Photonics'
--and faculty_test.university_id = 1474


