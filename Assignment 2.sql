CREATE DATABASE school; 
USE school; 

-- Create Tables 

CREATE TABLE student (
	student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    date_of_birth DATE NOT NULL
) ENGINE = InnoDB; 

CREATE TABLE instructor (
	instructor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    date_of_birth DATE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE course (
	course_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL, 
    start_date DATE,
    end_date DATE, 
    description VARCHAR(100)
) ENGINE = InnoDB;

CREATE TABLE course_instructor (
	course_instructor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    frn_course_id INT NOT NULL,
    frn_instructor_id INT NOT NULL,
    CONSTRAINT frn_course_instructor_course_id_idx
		FOREIGN KEY (frn_course_id) REFERENCES course(course_id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT,
	CONSTRAINT frn_course_instructor_instructor_id_idx
		FOREIGN KEY (frn_instructor_id) REFERENCES instructor(instructor_id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE course_student (
	course_student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    frn_course_id INT NOT NULL,
    frn_student_id INT NOT NULL,
	CONSTRAINT frn_course_student_course_id_idx
        FOREIGN KEY (frn_course_id) REFERENCES course(course_id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT,
	CONSTRAINT frn_course_student_student_id_idx
		FOREIGN KEY (frn_student_id) REFERENCES student(student_id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE grade (
	grade_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    frn_course_id INT NOT NULL,
    frn_student_id INT NOT NULL,
    grade_percent DECIMAL(5,2) NOT NULL,
	CONSTRAINT frn_grade_course_id_idx
		FOREIGN KEY (frn_course_id) REFERENCES course(course_id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT,
	CONSTRAINT frn_grade_student_id_idx
		FOREIGN KEY (frn_student_id) REFERENCES student(student_id)
		ON UPDATE RESTRICT
		ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Insert Data 

INSERT INTO student (first_name, last_name, date_of_birth) 
VALUES 
("Ally", "Brannon", "1997-05-06"),
("Evangelica", "Cruz", "1998-04-21"),
("Ema", "Kimberly", "2000-01-18"),
("Zed", "Notaro", "1999-10-01"),
("Tulio", "Steffen", "1998-08-08");

INSERT INTO instructor (first_name, last_name, date_of_birth) 
VALUES 
("Collyn", "Kistner", "1985-07-24"),
("Linnea", "Nosek", "1975-12-30"),
("Jayson", "Phelps", "1976-12-17"),
("Duston", "Bunschoten", "1981-08-11"),
("Chen", "Esparza", "1982-02-02");

INSERT INTO course (course_code, start_date, end_date, description) 
VALUES 
("BIO 111", "2018-01-05", "2018-04-15", "Introduction to Animal Biology"),
("BIO 112", "2018-01-05 ", "2018-04-15", "Introduction to Plant Biology"),
("CHEM 121", "2018-01-05", "2018-04-15", "Organic Chemistry"),
("MATH 152", "2018-01-05", "2018-04-15", "Calculus 1"),
("MATH 155", "2018-01-05", "2018-04-15", "Calculus 2"); 

INSERT INTO course_instructor (frn_course_id, frn_instructor_id)
VALUES 
(1, 2),
(2, 2),
(3, 5),
(3, 3),
(4, 4),
(5, 1); 

INSERT INTO course_student (frn_course_id, frn_student_id)
VALUES 
(1, 1),
(1, 2),
(2, 1), 
(3, 2),
(3, 4),
(4, 4),
(5, 5),
(3, 5),
(2, 3),
(3, 3),
(4, 3); 

INSERT INTO grade (frn_course_id, frn_student_id, grade_percent)
VALUES 
(1, 1, 95.10),
(1, 2, 88.30),
(2, 1, 92.00),
(3, 2, 78.90),
(3, 4, 75.30),
(4, 4, 82.30),
(5, 5, 74.10),
(3, 5, 90.80),
(2, 3, 82.60),
(3, 3, 79.10),
(4, 3, 85.00); 

-- SELECT * FROM student; 
-- SELECT * FROM instructor; 
-- SElECT * FROM course; 
-- SELECT * FROM course_instructor; 
-- SELECT * FROM course_student; 
-- SELECT * FROM grade;

-- MySQL Accounts 

CREATE USER 'Ally'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Evangelica'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Ema'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Zed'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Tulio'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Collyn'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Linnea'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Jayson'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Duston'@'%' IDENTIFIED BY 'password'; 
CREATE USER 'Chen'@'%' IDENTIFIED BY 'password'; 

-- Create Roles 

CREATE ROLE 'student'; 
CREATE ROLE 'instructor';

-- Grant Roles

GRANT 'student' TO 'Ally'@'%', 'Evangelica'@'%', 'Ema'@'%', 'Zed'@'%', 'Tulio'@'%'; 
GRANT 'instructor' TO 'Collyn'@'%', 'Linnea'@'%', 'Jayson'@'%', 'Duston'@'%', 'Chen'@'%'; 

-- Activate Roles 

SET DEFAULT ROLE ALL TO 'Ally', 'Evangelica', 'Ema', 'Zed', 'Tulio', 'Collyn', 'Linnea', 'Jayson', 'Duston', 'Chen';

-- Grant Permission

GRANT SELECT,INSERT,UPDATE,DELETE ON school.* TO 'instructor';

-- Create Views 
CREATE VIEW my_grades AS SELECT 
student.first_name, student.last_name, course.course_code, grade.grade_percent
FROM student
JOIN grade ON student.student_id = grade.frn_student_id
JOIN course ON course.course_id = grade.frn_course_id
WHERE student.first_name = SUBSTRING_INDEX(USER(), "@", 1);

GRANT SELECT ON school.my_grades TO 'student';

--

CREATE VIEW student_schedule AS SELECT 
student.first_name, student.last_name, course.course_code, course.start_date, course.end_date
FROM student 
JOIN course_student ON student.student_id = course_student.frn_student_id
JOIN course ON course_student.frn_course_id = course.course_id
WHERE student.first_name = SUBSTRING_INDEX(USER(), "@", 1);

GRANT SELECT ON school.student_schedule TO 'student';

--

CREATE VIEW instructor_schedule AS SELECT 
instructor.first_name, instructor.last_name, course.course_code, course.start_date, course.end_date
FROM instructor 
JOIN course_instructor ON instructor.instructor_id = course_instructor.frn_instructor_id 
JOIN course ON course_instructor.frn_course_id = course.course_id
WHERE instructor.first_name = SUBSTRING_INDEX(USER(), "@", 1);

GRANT SELECT ON school.instructor_schedule TO 'instructor';

-- Create Stored Procedure 

DELIMITER $$

CREATE PROCEDURE `check_grade`(IN grade_percent DECIMAL(5,2))
BEGIN
 DECLARE _messageText varchar(250);
 IF grade_percent < 0 THEN
	BEGIN
	SELECT CONCAT('Check constraint on grade.grade_percent failed – grade_percent ', grade_percent,' must be greater than 0%.')
	INTO _messageText;
	SIGNAL SQLSTATE '45001'
	SET MESSAGE_TEXT = _messageText;
	END;
 ELSEIF grade_percent > 100 THEN
	BEGIN
	SELECT CONCAT('Check constraint on grade.grade_percent failed - grade_percent ', grade_percent,' must not be larger than 100%.')
	INTO _messageText;
	SIGNAL SQLSTATE '45002'
	SET MESSAGE_TEXT = _messageText;
	END;
 END IF;
END$$

DELIMITER ;

-- Create Triggers 

DELIMITER $$
CREATE TRIGGER `grade_before_insert` BEFORE INSERT ON `grade`
FOR EACH ROW
BEGIN
 CALL check_grade(new.grade_percent);
END$$ 
DELIMITER ;

DELIMITER $$
CREATE TRIGGER `grade_before_update` BEFORE UPDATE ON `grade`
FOR EACH ROW
BEGIN
 CALL check_grade(new.grade_percent);
END$$ 
DELIMITER ;








