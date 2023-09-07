-- Step 1: The students table

-- Create a students table
CREATE TABLE students (
    github VARCHAR(30) PRIMARY KEY, 
    first_name VARCHAR(30), 
    last_name VARCHAR(30));

-- Insert students into the database
INSERT INTO students (github, first_name, last_name)
    VALUES ('jhacks', 'Jane', 'Hacker');

INSERT INTO students (github, first_name, last_name)
    VALUES ('sdevelops', 'Sarah', 'Developer');

-- shows all students within the table
SELECT * FROM students;

-- deletes all information within the table
DROP TABLE students;

-- Step 2: 

-- Show only the last name of all students
SELECT last_name 
FROM students;

-- Show only the github username and first name of all students
SELECT github, first_name
FROM students;

-- Show all columns for students whose first name is Sarah
SELECT first_name
FROM students
WHERE first_name = 'Sarah';

-- Show all columns for students whose GitHub username is sdevelops
SELECT github
FROM students
WHERE github = 'sdevelops';

-- Show only the first name and last name of students whose GitHub username is jhacks
SELECT first_name, last_name
FROM students
WHERE github = 'jhacks';

-- Step 3: the projects table

-- Create the projects table
CREATE TABLE projects (
    title VARCHAR(30) PRIMARY KEY,
    description TEXT,
    max_grade INTEGER);

-- Insert Markov and Blockly into projects table
INSERT INTO projects (title, description, max_grade)
VALUES ('Markov', 'Tweets generated from Markov Chains', 50),
('Blockly', 'Programmatic Logic Puzzle Game', 100);

-- create 3 addditional projects and insert them into projects table
INSERT INTO projects (title, description, max_grade)
VALUES ('Italy', 'Intro to Italian', 75),
('Spain', 'Intro to Spanish', 80 ),
('France', 'Intro to Franch', 60);

-- Step 4: dump/restore postgresql database
-- enter the following into a new terminal to create a sql file inorder to upload to Github and are able to copy the db onto other machines.
pg_dump project-tracker > project-tracker.sql

-- Step 5: advanced querying

-- Select the title and max_grade for all projects with max_grade > 50.
SELECT title, max_grade
FROM projects
WHERE max_grade > 50;

-- Select the title and max_grade for all projects where the max_grade is between 10 and 60.
SELECT title, max_grade
FROM projects
WHERE max_grade BETWEEN 10 AND 60;

-- Select the title and max_grade for all projects where the max_grade is less than 25 or greater than 75.
SELECT title, max_grade
FROM projects
WHERE max_grade <= 25 OR max_grade >= 75;

-- Select all projects ordered by max_grade.
SELECT *
FROM projects
ORDER BY max_grade;

-- Step 6: Linking the tables together

-- Construct the CREATE TABLE statement for grades, making sure of the following:
-- id should be an auto-incrementing (serial) primary key
-- student_github should be a foreign key to the students table, and should be the same type and size as the github column in students
-- project_title should be a foreign key to the projects table, and should be the same type and size as the title column in projects
-- grade should be an integer.
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    student_github VARCHAR (30) REFERENCES students,
    project_title VARCHAR (30) REFERENCES projects,
    grade INTEGER
);

-- The data above shows that the student with the GitHub account jhacks has completed the project 
-- with the title Markov for a total grade of 10. She has also completed the project entitled 
-- Blockly for a measly two points.
-- The student with the GitHub account sdevelops, on the other hand, 
-- is doing much better with her projects, scoring 50 and 100 on each
INSERT INTO grades (student_github, project_title, grade)
VALUES ('jhacks', 'Markov', 10), ('jhacks', 'Blockly', 2),
('sdevelops', 'Markov', 50), ('sdevelops', 'Blockly', 50);

-- Select all the information from the table to display all the unique ids
SELECT *
FROM grades;

-- Step 7: getting Jane's project grades 

-- first, let’s build a SELECT statement for first_name and last_name from the students table. Think of this as Query 1:
SELECT first_name, last_name
FROM students
WHERE github = 'jhacks';

-- Next, let’s select the grade and project_title for a student with a particular student_github value from the grades table. Think of this as Query 2:
SELECT project_title, grade
FROM grades
WHERE student_github = 'jhacks';

-- Now we need to select the title and max_grade from the projects table. Think of this as Query 3:
SELECT title, max_grade
FROM projects;

-- Joining the students and grades tables 
SELECT *
FROM students
    JOIN grades ON (students.github = grades.student_github);

-- Next, you’ll want to limit the columns. 
-- Try writing a query similar to the one above, but which limits the columns to the 
-- first and last name from the students table and the project title and grade from 
-- the grades table. This new query is like combining Query 1 and Query 2 from above, 
-- and the output should look like this:
SELECT students.first_name,
       students.last_name,
       grades.project_title,
       grades.grade
FROM students
JOIN grades ON (students.github = grades.student_github);

-- select everything to make sure it all lines up:
SELECT *
FROM students
  JOIN grades ON (students.github = grades.student_github)
  JOIN projects ON (grades.project_title = projects.title);

-- filtering for Jane's information using where and 'jhacks'
SELECT *
FROM students
  JOIN grades ON (students.github = grades.student_github)
  JOIN projects ON (grades.project_title = projects.title)
WHERE github = 'jhacks';



