CREATE Database task1;
USE task1;

-- Academic Management System (1. Database creation)

CREATE TABLE StudentInfo (
STU_ID INT PRIMARY KEY AUTO_INCREMENT,
STU_NAME VARCHAR (50),
DOB DATE,
PHONE_NO VARCHAR (25) 
);

CREATE TABLE CoursesInfo (
COURSE_ID INT PRIMARY KEY ,
COURSE_NAME VARCHAR (25),
COURSE_INSTRUCTOR_NAME VARCHAR (50)
);

CREATE TABLE EnrollmentInfo (
ENROLLMENT_ID INT PRIMARY KEY AUTO_INCREMENT,
STU_ID INT,
COURSE_ID INT,
ENROLL_STATUS VARCHAR (15),
FOREIGN KEY (STU_ID) REFERENCES StudentInfo(STU_ID),
FOREIGN KEY (COURSE_ID) REFERENCES CoursesInfo(COURSE_ID)
);

-- Academic Management System (2. Data creation)

INSERT INTO StudentInfo (STU_NAME, DOB, PHONE_NO) VALUES 
('David', '1999-05-21', '9999988722'),
('Colin', '2000-05-28', '9080560036'),
('Charles', '1998-02-04', '9999406942'),
('Carlos', '2001-01-29', '9999982736')
;

INSERT INTO CoursesInfo (Course_ID, Course_NAME, COURSE_INSTRUCTOR_NAME) VALUES 
(101, 'Mathematics', 'Alan Walker'),
(102, 'Biology', 'Chris Martin'),
(103, 'Chemistry', 'Charlie Puth'),
(104, 'Physics', 'Guy Berryman')
;

INSERT INTO EnrollmentInfo (ENROLLMENT_ID, STU_ID, COURSE_ID, ENROLL_STATUS) VALUES
(1, 1, 101, 'Enrolled'),
(2, 1, 102, 'Enrolled'),
(3, 2, 102, 'Enrolled'),
(4, 2, 104, 'Enrolled'),
(5, 3, 102, 'Enrolled'),
(6, 3, 101, 'Not Enrolled'),
(7, 4, 103, 'Enrolled'),
(8, 4, 102, 'Not Enrolled');

-- Academic Management System (3. Retrieve Student Information - a. Query to Retrieve student details, such as student name, contact information and Enrollment Status)

Select s.STU_NAME, s.PHONE_NO, c.COURSE_NAME, e.ENROLL_STATUS
FROM StudentInfo s LEFT JOIN EnrollmentInfo e
ON s.STU_ID = e.STU_ID 
LEFT JOIN CoursesInfo c
ON e.COURSE_ID = c.COURSE_ID
ORDER BY s.STU_NAME, c.COURSE_NAME;

-- Academic Management System (3. Retrieve Student Information - b. List of courses in which a specific student is enrolled)

SELECT c.COURSE_NAME
FROM EnrollmentInfo e JOIN CoursesInfo c
ON e.COURSE_ID = c.COURSE_ID  
WHERE e.STU_ID = (
    SELECT STU_ID
    FROM StudentInfo
    WHERE STU_NAME = 'Charles' -- one can change the student name as per specific course
) AND e.ENROLL_STATUS = 'Enrolled';

-- Academic Management System (3. Retrieve Student Information - c. query to retrieve course Information, including course name, instructor information)

SELECT 
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME
FROM CoursesInfo c;

-- Academic Management System (3. Retrieve Student Information - d. query to retrieve course Information for a specific course)

SELECT 
    c.COURSE_ID,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME
FROM CoursesInfo c
WHERE c.COURSE_ID = 102; -- one can change the course ID as per specific course

-- Academic Management System (3. Retrieve Student Information - e. query to retrieve course Information of multiple courses)

SELECT 
    c.COURSE_ID,
    c.COURSE_NAME,
    c.COURSE_INSTRUCTOR_NAME
FROM CoursesInfo c
WHERE c.COURSE_ID IN (101, 102, 103, 104);

-- Academic Management System (4. Reporting and Analytics - a. query to retrieve the number of students enrolled in each course)

SELECT
	c.COURSE_NAME,
    COUNT(e.ENROLLMENT_ID) AS NUMBER_OF_STUDENTS
FROM CoursesInfo c LEFT JOIN EnrollmentInfo e
ON c.COURSE_ID = e.COURSE_ID
WHERE e.ENROLL_STATUS = 'Enrolled'
GROUP BY c.COURSE_NAME
ORDER BY NUMBER_OF_STUDENTS DESC;

-- Academic Management System (4. Reporting and Analytics - b. query to retrieve the list of students enrolled in a specific course)

SELECT 
    s.STU_NAME
FROM StudentInfo s JOIN EnrollmentInfo e
ON s.STU_ID = e.STU_ID
WHERE e.COURSE_ID = (
    SELECT COURSE_ID
    FROM CoursesInfo
    WHERE COURSE_NAME = 'Mathematics' -- one can change the course name as per specific course
) AND e.ENROLL_STATUS = 'Enrolled';

-- Academic Management System (4. Reporting and Analytics - c. query to retrieve the count of enrolled students for each instructor)

SELECT
    c.COURSE_INSTRUCTOR_NAME,
    COUNT(e.ENROLLMENT_ID) AS 'Number_of_Enrolled_Students'
FROM CoursesInfo c LEFT JOIN EnrollmentInfo e
ON c.COURSE_ID = e.COURSE_ID
WHERE e.ENROLL_STATUS = 'Enrolled'
GROUP BY c.COURSE_INSTRUCTOR_NAME
ORDER BY Number_of_Enrolled_Students DESC;

-- Academic Management System (4. Reporting and Analytics - d. query to retrieve list of students who are enrolled in multiple courses)

SELECT
    s.STU_NAME
FROM StudentInfo s
JOIN EnrollmentInfo e ON s.STU_ID = e.STU_ID
WHERE e.ENROLL_STATUS = 'Enrolled'
GROUP BY s.STU_ID
HAVING COUNT(e.COURSE_ID) > 1
ORDER BY s.STU_NAME;

-- Academic Management System (4. Reporting and Analytics - e. query to retrieve the courses that have the highest number of enrolled students(DESC))

SELECT
    c.COURSE_NAME,
    COUNT(e.ENROLLMENT_ID) AS 'Number_of_Enrolled_Students'
FROM CoursesInfo c 
JOIN EnrollmentInfo e ON c.COURSE_ID = e.COURSE_ID
WHERE e.ENROLL_STATUS = 'Enrolled'
GROUP BY COURSE_NAME
ORDER BY 'Number_of_Enrolled_Students' DESC;