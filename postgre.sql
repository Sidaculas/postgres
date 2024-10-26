-- Active: 1729961740920@@127.0.0.1@5432@university_db
-- This command is used to create a database.
-- first give the create command
-- for database give database command
-- then give the name of the database
CREATE DATABASE university_db


-- I have choses the university database from active connection with mouse. \c university_db was not working.


-- creating tables with constraints
-- student_id with be in serial and primary key.
-- name cannot be null
-- age must be more than 10 years old. in context of learning full stack technologies. 
-- there is no age barrier. I just wanted to try that constraint.
-- email should be unique and not null.
-- both backend and frontend mark should not be negative and more than 100.
CREATE Table students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age INTEGER check(age > 10),
    email VARCHAR(50) UNIQUE NOT NULL,
    frontend_mark INTEGER check(frontend_mark >= 0 AND frontend_mark <=100),
    backend_mark INTEGER check(backend_mark >= 0 AND backend_mark <=100),
    status VARCHAR(20)
)



-- course_id the primary key and It will increment serially
-- course name cannot be null
-- credits must be grater than zero.

CREATE TABLE courses(
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits INTEGER check(credits > 0)
)


--enrollment_id is the primary key
-- Both student_id and course_id is foreign key and if one or many occurrences gets deleted in their respective table
-- those occurrences will also get deleted on enrollment table.

CREATE TABLE enrollment(
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE
)


-- inserting data into students table

INSERT INTO students(student_id, student_name, age, email, frontend_mark, backend_mark, status)
VALUES
(1, 'Sameer', 21, 'sammer@example.com', 48, 60, NULL ),
(2, 'Zoya', 23, 'zoya@example.com', 52, 58, NULL ),
(3, 'Nabil', 22, 'nabil@example.com', 37, 46, NULL ),
(4, 'Rafi', 24, 'rafi@example.com', 41, 40, NULL ),
(5, 'Sofia', 22, 'sofia@example.com', 50, 52, NULL ),
(6, 'Hasan', 23, 'hasan@example.com', 43, 39, NULL );


-- seeing the table
SELECT * FROM students;


-- inserting data into courses table
INSERT INTO courses(course_id, course_name, credits)
VALUES
(1, 'Next.js', 3),
(2, 'React.js', 4),
(3, 'Database', 3),
(4, 'Prisma', 3);


-- viewing the courses table
SELECT * FROM courses;


-- inserting data into enrollment table
INSERT INTO enrollment(enrollment_id, student_id, course_id)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 3, 2);


-- viewing the enrollment table
SELECT * FROM enrollment;


--//! query 1

SELECT max(student_id) FROM students;
-- 6

INSERT INTO students
VALUES
(7, 'Shafaat', 24, 'shafaat.siddhi19@gmail.com', 30, 40, NULL);


SELECT * FROM students;


-- //! Query 2

-- the following query first selects students_name from students. 
-- i used alias to keep it short.
-- then the first join operation joins both student and enrollment based on student id. 
-- then the second join operation joins course_id on both courses and enrollment.
-- then fetches only the result that matches to next.js.

SELECT student_name FROM students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Next.js';



--//! Query 3
-- based on highest frontend mark this query will update the status to 'Awarded
-- the subquery will find the highest total mark
UPDATE students
SET status = 'Awarded'
WHERE (frontend_mark + backend_mark) = (
    SELECT max(frontend_mark + backend_mark) FROM students
)

-- this following query verifies the result of the previous query
SELECT student_name, max(frontend_mark + backend_mark)
FROM students
GROUP BY student_name
LIMIT 1

-- viewing the students table
SELECT * FROM students
ORDER BY student_id ASC



--//! Query 4
-- the sub query returns distinct values of course_id from enrollment so that we can know which course_id are present in --enrollment
-- then we can safely delete all other courses from the courses table. As those have no students enrolled.
-- in this case that is prisma and database course.

DELETE FROM courses
WHERE course_id NOT in (
    SELECT DISTINCT course_id FROM enrollment
);


--//! Query 5
-- offset 2 means skipping 2 rows. limit 2 means result will show only 2 rows.
SELECT student_name
FROM students
ORDER BY student_id
LIMIT 2 OFFSET 2;


--//! Query 6
-- first I joined student and enrollment with student_id as the enrollment table contains course id
-- the with course_id i joined enrollment and courses, so now I have access to courses.
-- then I grouped by course name and counted the student_ids in each group.
SELECT c.course_name, count(s.student_id) as "students_enrolled"  from students s
JOIN enrollment e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name;


--//! Query 7
-- used avg function and alias 'average_age'
SELECT avg(age) as "average_age" FROM students;


--//! Query 8
-- like matches the given string in database. % before or after means any character can be before or after.
-- but somewhere in the text there my be example.com. 
-- as this is email. in our case it will be after @
SELECT student_name
FROM students
WHERE email LIKE '%example.com%';