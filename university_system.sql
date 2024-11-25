-- Problem 1: University Course Enrollment System

-- Step 1: Create Tables
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    school_enrollment_date DATE NOT NULL
);

CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT,
    professor_id INT REFERENCES professors(id) ON DELETE CASCADE
);

CREATE TABLE enrollments (
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id)
);

-- Step 2: Insert Data
INSERT INTO students (first_name, last_name, email, school_enrollment_date)
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', '2023-09-01'),
('Bob', 'Smith', 'bob.smith@example.com', '2023-09-01'),
('Charlie', 'Brown', 'charlie.brown@example.com', '2023-09-01'),
('Diana', 'Prince', 'diana.prince@example.com', '2023-09-01'),
('Eve', 'Adams', 'eve.adams@example.com', '2023-09-01');

INSERT INTO professors (first_name, last_name, department)
VALUES
('John', 'Doe', 'Mathematics'),
('Jane', 'Smith', 'Physics'),
('Michael', 'Clark', 'Computer Science'),
('Emily', 'Davis', 'Chemistry');

INSERT INTO courses (course_name, course_description, professor_id)
VALUES
('Physics 101', 'Introduction to Physics', 2),
('Computer Science 101', 'Basics of Programming', 3),
('Chemistry 101', 'Basic Chemistry Principles', 4);

INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2023-09-05'),
(2, 1, '2023-09-05'),
(3, 2, '2023-09-06'),
(4, 3, '2023-09-06'),
(5, 1, '2023-09-07');

-- Step 3: SQL Queries
-- 3.1 Retrieve Full Names of Students Enrolled in "Physics 101"
SELECT CONCAT(students.first_name, ' ', students.last_name) AS full_name
FROM students
JOIN enrollments ON students.id = enrollments.student_id
JOIN courses ON enrollments.course_id = courses.id
WHERE courses.course_name = 'Physics 101';

-- 3.2 Retrieve All Courses Along with the Professor's Full Name
SELECT courses.course_name, CONCAT(professors.first_name, ' ', professors.last_name) AS professor_name
FROM courses
JOIN professors ON courses.professor_id = professors.id;

-- 3.3 Retrieve All Courses That Have Students Enrolled in Them
SELECT DISTINCT courses.course_name
FROM courses
JOIN enrollments ON courses.id = enrollments.course_id;

-- Step 4: Update Data
-- Update One Student’s Email
UPDATE students
SET email = 'updated.email@example.com'
WHERE id = 1;

-- Step 5: Delete Data
-- Remove a Student from One of Their Courses
DELETE FROM enrollments
WHERE student_id = 1 AND course_id = 1;
