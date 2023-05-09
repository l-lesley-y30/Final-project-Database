CREATE TABLE feeder (
  feeder_id INT PRIMARY KEY,
  feeder TEXT 
);

CREATE TABLE programs(
  program_id  INT PRIMARY KEY,
  program_code VARCHAR(50) NOT NULL,
  program_name TEXT NOT NULL,
  program_degree TEXT NOT NULL
);

CREATE TABLE student_info(
  student_id INT  PRIMARY KEY,
  DOB DATE,
  gender CHAR(1) NOT NULL,
  district TEXT ,
  city TEXT ,
  ethnicity TEXT NOT NULL,
  program_start VARCHAR(100) NOT NULL,
  programEnd DATE ,
  program_status VARCHAR(100) NOT NULL,
  grade_date DATE ,
  feeder_id INT,
  FOREIGN KEY(feeder_id)
  REFERENCES feeder(feeder_id)
); 

CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  course_code CHAR(50) NOT NULL,
  course_title TEXT NOT NULL,
  course_credits DECIMAL, 
  course_grade CHAR(2),
  course_gpa DECIMAL,
  course_points DECIMAL,
    CGPA DECIMAL,
  comments VARCHAR(50)
);

CREATE TABLE semester (
  semester_id INT PRIMARY KEY,
  student_id INT,
  semester VARCHAR(50),
  credits_earned DECIMAL ,
  credits_attempted DECIMAL,
  semester_points  DECIMAL,
  semester_gpa DECIMAL,
  FOREIGN KEY(student_id)
  REFERENCES student_info(student_id)
);

CREATE TABLE semester_courses(
  Crs_id INT PRIMARY KEY,
  semester_id INT NOT NULL,
  course_id INT NOT NULL,
  program_id INT,
  FOREIGN KEY(program_id)
  REFERENCES programs(program_id),
  FOREIGN KEY(course_id)
  REFERENCES courses(course_id),
  FOREIGN KEY(semester_id)
  REFERENCES semester(semester_id)
); 


COPY feeder
FROM '/home/lesley/Final-Project/feeder.csv'
DELIMITER ','
CSV HEADER;

COPY programs
FROM '/home/lesley/Final-Project/programs.csv'
DELIMITER ','
CSV HEADER;

COPY student_info
FROM '/home/lesley/Final-Project/student_info.csv'
DELIMITER ','
CSV HEADER; 


COPY courses
FROM '/home/lesley/Final-Project/courses.csv'
DELIMITER ','
CSV HEADER;

COPY semester
FROM '/home/lesley/Final-Project/semester.csv'
DELIMITER ','
CSV HEADER;

COPY semester_courses
FROM '/home/lesley/Final-Project/semester_courses.csv'
DELIMITER ','
CSV HEADER;

--Overall acceptance rate for the BINT /Aint program
SELECT COUNT(*) as admission_rate FROM student_info;

---cauculate gradation rate for BINT / Aint programs based on total student and program status
SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Student_info) AS graduation_rate
FROM Student_info
WHERE program_status = 'Graduated';

----rank feeder institutions by admission rates and grades.
SELECT Feeder.feeder, 
       COUNT(Student_info.student_id) AS admitted, 
       AVG(Courses.course_points) AS course_points
FROM Feeder
INNER JOIN Student_info ON Feeder.feeder_id = Student_info.feeder_id
INNER JOIN Semester ON Student_info.student_id = Semester.student_id
INNER JOIN Semester_Courses ON Semester.semester_id = Semester_Courses.semester_id
INNER JOIN Courses ON Semester_Courses.course_id = Courses.course_id
GROUP BY Feeder.feeder_id
ORDER BY  course_points DESC;
----rank feeder institutions by admission rates and grades(AINT).

SELECT Feeder.school_name, 
       COUNT(Student_information.student_id) AS admitted, 
       AVG(Grades.course_points) AS course_points
FROM Feeder
INNER JOIN Student_information ON Feeder.feeder_id = Student_information.feeder_id
INNER JOIN Grades ON Student_information.student_id = Grades.student_id
INNER JOIN Courses ON Grades.course_id = Courses.course_id
GROUP BY Feeder.feeder_id
ORDER BY course_points DESC;





