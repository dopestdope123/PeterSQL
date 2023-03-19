CREATE DATABASE Students1;
USE Students1;
CREATE TABLE StudentsInfo(
StudentID int, 
StudentName varchar(8000),
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000),
City varchar(8000),
Country varchar(8000)
);

DROP TABLE StudentsInfo;
DROP DATABASE Students;

ALTER TABLE StudentsInfo ADD BloodGroup varchar(8000);

ALTER TABLE StudentsInfo DROP COLUMN BloodGroup;

ALTER TABLE StudentsInfo ADD DOB DATE;

ALTER TABLE StudentsInfo ALTER COLUMN DOB datetime;
ALTER TABLE StudentsInfo DROP COLUMN DOB;

INSERT INTO StudentsInfo VALUES('07','James', 'Jackson','4381239231', '100 St Catherine', 'Montreal', 'Canada');

truncate table StudentsInfo;

sp_rename 'StudentsInfo', 'InfoStudents';

INSERT INTO InfoStudents VALUES('07','James', 'Jackson','4381239231', '100 St Catherine', 'Montreal', 'Canada')\

CREATE TABLE StudentsInfo(
StudentID int, 
StudentName varchar(8000),
ParentName varchar(8000),
PhoneNumber bigint,
AddressofStudent varchar(8000),
City varchar(8000),
Country varchar(8000),
CONSTRAINT UC_StudentsInfo UNIQUE(StudentID, PhoneNumber)
);

ALTER TABLE StudentsInfo ADD CONSTRAINT UC_StudentsInfo UNIQUE(StudentID, PhoneNumber);

ALTER TABLE StudentsInfo DROP CONSTRAINT UC_StudentsInfo;

DROP TABLE InfoStudents

ALTER TABLE StudentsInfo
ADD CONSTRAINT default_city
DEFAULT 'tor' FOR City;

CREATE INDEX idex_studentname
ON StudentsInfo(StudentName);

DROP INDEX StudentsInfo.idex_studentname;

INSERT INTO StudentsInfo VALUES('07','James', 'Jackson','4381239231', '100 St Catherine', 'Montreal', 'Canada');

SELECT* FROM StudentsInfo;

INSERT INTO StudentsInfo VALUES('01','Peter', 'Jackson','4381239231', '100 St Catherine', 'Montreal', 'Canada');


UPDATE StudentsInfo SET StudentName = 'John', City= 'Ottawa'
WHERE StudentID = 1;

SELECT* FROM StudentsInfo;

CREATE TABLE SampleSourceTable (StudentID int, StudentName varchar(8000), Grades int);
CREATE TABLE SampleTargetTable (StudentID int, StudentName varchar(8000), Grades int);

INSERT INTO SampleSourceTable VALUES (1, 'Peter', '90');
INSERT INTO SampleSourceTable VALUES (2 ,'Jack', '82');
INSERT INTO SampleSourceTable VALUES (3, 'Joe', '99');
INSERT INTO SampleTargetTable VALUES (1, 'Peter', '90');
INSERT INTO SampleTargetTable VALUES (2 ,'Jack', '82');
INSERT INTO SampleTargetTable VALUES (3, 'Joe', '99');

MERGE SampleTargetTable TARGET USING SampleSourceTable SOURCE ON(TARGET.StudentID=SOURCE.StudentID)
WHEN MATCHED AND TARGET.StudentName <> Source.StudentName OR TARGET.Grades <> Source.Grades
THEN 
UPDATE SET TARGET.StudentName = SOURCE.StudentName, TARGET.Grades=SOURCE.Grades
WHEN NOT MATCHED BY TARGET THEN
INSERT (StudentID, StudentName, Grades) VALUES (SOURCE.StudentID, SOURCE.StudentName, SOURCE.Grades)
WHEN NOT MATCHED BY SOURCE THEN
DELETE;

SELECT * FROM SampleSourceTable;
SELECT TOP 3 * FROM SampleSourceTable;
SELECT * FROM StudentsInfo ORDER BY ParentName, StudentName;

SELECT * FROM StudentsInfo ORDER BY ParentName ASC, StudentName DESC;

SELECT COUNT(StudentID), City FROM StudentsInfo GROUP BY City;

SELECT COUNT(StudentID), City FROM StudentsInfo GROUP BY 
GROUPING SETS((StudentID, StudentName, City),(StudentID),(StudentName),(City));

SELECT COUNT(StudentID), City FROM StudentsInfo GROUP BY City HAVING COUNT(StudentID)=1
ORDER BY COUNT(StudentID) DESC;

SELECT * INTO StudentsBackup FROM StudentsInfo;

SELECT * INTO StudentOttawa FROM StudentsInfo WHERE City ='Ottawa';

SELECT StudentID, Count(City) FROM StudentsInfo GROUP BY CUBE (StudentID) ORDER BY (StudentID);

SELECT StudentID, Count(City) FROM StudentsInfo GROUP BY Rollup (StudentID);

CREATE TABLE OffsetMarks (Grades int);
INSERT INTO OffsetMarks VALUES (60);
INSERT INTO OffsetMarks VALUES (61);
INSERT INTO OffsetMarks VALUES (62);
INSERT INTO OffsetMarks VALUES (63);

SELECT * FROM OffsetMarks ORDER BY Grades OFFSET 1 ROWS;
SELECT * FROM OffsetMarks ORDER BY Grades OFFSET 3 ROWS FETCH NEXT 2 ROWS ONLY;

CREATE TABLE SupplierTable
(
SupplierID int NOT NULL,
DayofManufacture int,
Cost int,
CustomerID int,
PurchaseID varchar(4000)
);

INSERT INTO SupplierTable VALUES ('1','12','123','1234','A1');
INSERT INTO SupplierTable VALUES ('2','13','124','1134','A2');
INSERT INTO SupplierTable VALUES ('3','14','125','1244','A3');
INSERT INTO SupplierTable VALUES ('4','15','127','1264','A4');
INSERT INTO SupplierTable VALUES ('5','16','128','1294','A5');
INSERT INTO SupplierTable VALUES ('6','17','130','1334','A6');
INSERT INTO SupplierTable VALUES ('6','17','130','1234','A7');

SELECT CustomerID, AVG(Cost) as AverageCostOfCustomer From SupplierTable GROUP BY CustomerID;

SELECT 'AverageCostForCustomer' AS Cost_According_To_Customers, [1234], [1134], [1334]
FROM (
SELECT CustomerID, Cost FROM SupplierTable) AS SourceTable
PIVOT
(
AVG(COST) FOR CustomerID IN ([1234], [1134], [1334])) AS PivotTable;

CREATE TABLE SampleTable(SupplierID int, AAA int, BBB int, CCC int)
GO 
INSERT INTO SampleTable VALUES(1,3,5,6)
INSERT INTO SampleTable VALUES(2,4,6,8)
INSERT INTO SampleTable VALUES(3,5,7,9)
GO
 
SELECT * FROM SampleTable;

SELECT SupplierID, Customers, Products
FROM 
(SELECT SupplierID, AAA, BBB, CCC FROM SampleTable) p
UNPIVOT
(Products FOR Customers IN(AAA,BBB,CCC)) AS Example;
GO

SELECT 40 + 60;

SELECT * FROM OffsetMarks WHERE Grades >=62;

DECLARE @var1 int = 30;
SET @var1 /= 16;
SELECT @var1 AS Example;

SELECT * FROM OffsetMarks WHERE Grades = 63 or Grades < 62;

SELECT * FROM StudentsInfo WHERE StudentName LIKE 'J%n';

DECLARE @exid hierarchyid;
SELECT @exid = hierarchyid::GetRoot();
PRINT @exid.ToString();

SELECT (StudentName+','+ParentName) AS Name FROM StudentsInfo;

SELECT AVG(Grades) FROM OffsetMarks;

CREATE TABLE Subjects(SubjectID int, StudentID int, SubjectName varchar(8000));
INSERT INTO Subjects VALUES (10,10,'Maths');
INSERT INTO Subjects VALUES (2,11,'Physics');
INSERT INTO Subjects VALUES (3,12,'Chemistry');
INSERT INTO Subjects VALUES (4,01,'Chinese');
INSERT INTO Subjects VALUES (5,02,'French');
SELECT Subjects.SubjectID, StudentsInfo.StudentName 
From Subjects
INNER JOIN
StudentsInfo ON
Subjects.StudentID=StudentsInfo.StudentID

SELECT Subjects.SubjectID, StudentsInfo.StudentName 
From StudentsInfo
FULL OUTER JOIN
Subjects ON
StudentsInfo.StudentID=Subjects.StudentID
ORDER BY StudentsInfo.StudentName

CREATE PROCEDURE Students_City @SCity varchar(8000)
AS
SELECT * FROM StudentsInfo
WHERE City = @SCity
GO 
SELECT * FROM StudentsInfo
EXEC Students_City @SCity = 'Ottawa'

CREATE LOGIN SAMPLE1 WITH PASSWORD = 'peter'

CREATE USER PETER FOR LOGIN SAMPLE1

REVOKE SELECT ON StudentsInfo TO PETER

CREATE TABLE TCLSample (StudentID int, StudentName varchar(8000), Grades int);

INSERT INTO TCLSample VALUES (01, 'Peter', 90);

BEGIN TRY
BEGIN TRANSACTION
INSERT INTO TCLSample VALUES (02 ,'Jack', 82);
UPDATE TCLSample SET StudentName = 'John' WHERE StudentID = 02;
UPDATE TCLSample SET Grades = 90 WHERE StudentID = 02;
COMMIT TRANSACTION
PRINT 'Complete'
END TRY 
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'NOT SUCCESSFUL'
END CATCH