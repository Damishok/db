create table classroom
	(building		varchar(15),
	 room_number		varchar(7),
	 capacity		numeric(4,0),
	 primary key (building, room_number)
	);

create table department
	(dept_name		varchar(20),
	 building		varchar(15),
	 budget		        numeric(12,2) check (budget > 0),
	 primary key (dept_name)
	);

create table course
	(course_id		varchar(8),
	 title			varchar(50),
	 dept_name		varchar(20),
	 credits		numeric(2,0) check (credits > 0),
	 primary key (course_id),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table instructor
	(ID			varchar(5),
	 name			varchar(20) not null,
	 dept_name		varchar(20),
	 salary			numeric(8,2) check (salary > 29000),
	 primary key (ID),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table section
	(course_id		varchar(8),
         sec_id			varchar(8),
	 semester		varchar(6)
		check (semester in ('Fall', 'Winter', 'Spring', 'Summer')),
	 year			numeric(4,0) check (year > 1701 and year < 2100),
	 building		varchar(15),
	 room_number		varchar(7),
	 time_slot_id		varchar(4),
	 primary key (course_id, sec_id, semester, year),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (building, room_number) references classroom (building, room_number)
		on delete set null
	);

create table teaches
	(ID			varchar(5),
	 course_id		varchar(8),
	 sec_id			varchar(8),
	 semester		varchar(6),
	 year			numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id, sec_id, semester, year) references section (course_id, sec_id, semester, year)
		on delete cascade,
	 foreign key (ID) references instructor (ID)
		on delete cascade
	);

create table student
	(ID			varchar(5),
	 name			varchar(20) not null,
	 dept_name		varchar(20),
	 tot_cred		numeric(3,0) check (tot_cred >= 0),
	 primary key (ID),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table takes
	(ID			varchar(5),
	 course_id		varchar(8),
	 sec_id			varchar(8),
	 semester		varchar(6),
	 year			numeric(4,0),
	 grade		        varchar(2),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id, sec_id, semester, year) references section (course_id, sec_id, semester, year)
		on delete cascade,
	 foreign key (ID) references student (ID)
		on delete cascade
	);

create table advisor
	(s_ID			varchar(5),
	 i_ID			varchar(5),
	 primary key (s_ID),
	 foreign key (i_ID) references instructor (ID)
		on delete set null,
	 foreign key (s_ID) references student (ID)
		on delete cascade
	);

create table time_slot
	(time_slot_id		varchar(4),
	 day			varchar(1),
	 start_hr		numeric(2) check (start_hr >= 0 and start_hr < 24),
	 start_min		numeric(2) check (start_min >= 0 and start_min < 60),
	 end_hr			numeric(2) check (end_hr >= 0 and end_hr < 24),
	 end_min		numeric(2) check (end_min >= 0 and end_min < 60),
	 primary key (time_slot_id, day, start_hr, start_min)
	);

create table prereq
	(course_id		varchar(8),
	 prereq_id		varchar(8),
	 primary key (course_id, prereq_id),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (prereq_id) references course (course_id)
	);

select title from course where credits >= 3;

select room_number from classroom where (building = 'Packard' or building = 'Watson');

select title from course where dept_name = 'Comp. Sci.';

select title from course c, teaches t where t.semester = 'Fall' and c.course_id = t.course_id;

select name from student where tot_cred between 45 and 90;

select name from student where name~*'[aewiuoy]$';

select title from course c, prereq q where c.course_id = q.course_id and q.prereq_id = 'CS-101';

select dept_name, avg(salary) AS avg_salary from instructor
group by dept_name
ORDER BY avg_salary;

SELECT d.building,count(1) FROM department d, course c
WHERE d.dept_name = c.dept_name
GROUP BY d.building
HAVING count(1) = (SELECT MAX(second.number) FROM
(SELECT count(1) as number FROM department, course
WHERE department.dept_name = course.dept_name
Group by department.building) as second);

select d.dept_name, count(1) from department d, course c
where d.dept_name = c.dept_name
having count(1) = (select min(second.number) from
(select count(1) as number from department d, course c
Group by d.dept_name) as second);

SELECT DISTINCT s.id,s.name FROM student s
WHERE s.id IN (SELECT third.id FROM
(SELECT student.id, count(1) as number
FROM student, takes, course
WHERE student.id=takes.id and takes.course_id=course.course_id
and course.dept_name='Comp. Sci.' group by student.id) as third
WHERE third.number>3);

select name from instructor
where dept_name = 'Packard' or dept_name = 'Music' or dept_name =
'Biology';

select distinct i.id, i.name from instructor I, teaches t
where i.id = t.id and t.year = 2018 and
           t.id not in (select i.id from instructor I, teaches t
                           where i.id = t.id and t.year = 2017);

SELECT distinct name
from student as s, takes as t
WHERE dept_name = 'Comp. Sci.' AND (t.id = s.id AND grade LIKE 'A%')
ORDER BY name;

SELECT distinct name
FROM takes, advisor, instructor
WHERE takes.id = advisor.s_id and advisor.i_id = instructor.id
AND ((takes.grade != 'A'
            AND takes.grade != 'A-'
            AND takes.grade != 'B+'
            AND takes.grade != 'B')
           OR (takes.grade is NULL));

SELECT DISTINCT course.dept_name
FROM course, takes
WHERE takes.course_id = course.course_id
  AND course.dept_name not in (
    SELECT dept_name FROM course WHERE course_id in (
        SELECT course_id FROM takes WHERE grade = 'F' OR grade = 'C'));

select id, name from instructor
where id not in (select i.id from instructor i, advisor a, takes t
       where i.id = a.i_id and a.s_id = t.id and t.grade = 'A');
     select if, name from instructor
where id not in (select i.id from instructor I, teaches t, takes ta
       where i.id = t.id and t.course_id = ta.course_id and ta/grade = 'A');

SELECT DISTINCT time_slot.time_slot_id, title
FROM time_slot, section, course
WHERE end_hr < 13
  AND section.time_slot_id = time_slot.time_slot_id
  AND course.course_id = section.course_id
ORDER BY time_slot.time_slot_id;