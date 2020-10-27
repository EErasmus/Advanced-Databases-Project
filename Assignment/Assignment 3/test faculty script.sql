-- name, year_founded, building, stem  , professional, faculty_id, university_university_id 
-- create table address_test as

create table faculty_test as
select TO_CHAR(floor(DBMS_RANDOM.value (1,13))) as name,'2020' as year_founded,dbms_random.string ('U', 1) || floor(DBMS_RANDOM.value (1,7)) as building,
0 as stem,
0 as professional,
rownum as faculty_id,
floor(DBMS_RANDOM.value (1,3000)) as university_id
from dual
connect by level <= 20000


UPDATE faculty_test   
SET name =   CASE  
 WHEN (name = 1)  THEN 'Faculty of Architecture'  
WHEN (name = 2) Then 'Faculty of Civil Engineering'
WHEN (name = 3) Then 'Faculty of Chemistry'
WHEN (name = 4) Then 'Faculty of Electronics'
WHEN (name = 5) Then 'Faculty of Electrical Engineering'
WHEN (name = 6) Then 'Faculty of Geoengineering, Mining and Geology'
WHEN (name = 7) Then 'Faculty of Environmental Engineering'
WHEN (name = 8) Then 'Faculty of Computer Science and Management'
WHEN (name = 9) Then 'Faculty of Mechanical and Power Engineering'
WHEN (name = 10) Then 'Faculty of Mechanical Engineering'
WHEN (name = 11) Then 'Faculty of Fundamental Problems of Technology'
WHEN (name = 12) Then 'Faculty of Microsystem Electronics and Photonics'
WHEN (name = 13) Then 'Faculty of Pure and Applied Mathematics'                         
END 

-- bachelor, master, phd
select * from faculty_test