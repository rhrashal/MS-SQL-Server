/***********************Medical test billing System************************************/ 

/******create  Database for Medical test and billing system AS 'MedicalTestDB'---------*/
Go
Use master;
GO

--IF DB_ID ('VesselsDB') IS NOT NULL DROP DATABASE VesselsDB;

DROP DATABASE  IF EXISTS MedicalTestDB;

GO

CREATE DATABASE MedicalTestDB
ON(
		NAME		= MedicalTestDB_data,
		FILENAME	='C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\MedicalTestDB_data.mdf',
		SIZE		= 10MB,
		MAXSIZE		= 50MB,
		FILEGROWTH	= 5MB
)
LOG ON (
		NAME		= MedicalTestDB_log,
		FILENAME	='C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\MedicalTestDB_log.ldf',
		SIZE		= 5MB,
		MAXSIZE		= 25MB,
		FILEGROWTH	= 2MB
);
GO
USE MedicalTestDB;

/******************Create Religion Table************************************************/
GO
CREATE TABLE Religion(
						ReligionID 		INT IDENTITY PRIMARY KEY,
						ReligionName 	VARCHAR(20)
						);
/***********************Gender Table***********************/
GO
CREATE TABLE Gender(
						GenderID 	INT IDENTITY PRIMARY KEY,
						GenderName 	VARCHAR(25)
						);
/***********************Country Table***********************/
GO
CREATE TABLE Country (
						CountryID 		INT IDENTITY PRIMARY KEY,
						CountryName 	VARCHAR(30)
						);
/***********************District Table***********************/
GO
CREATE TABLE District(
						DistrictID 		INT IDENTITY PRIMARY KEY,
						CountryID 		INT REFERENCES Country(CountryID),
						DistrictName 	VARCHAR(30)
						);
/***********************Area Table***********************/
GO
CREATE TABLE Area(
						AreaID 		INT IDENTITY PRIMARY KEY,
						DistrictID 	INT REFERENCES District(DistrictID),
						AreaName 	VARCHAR(40),
						ZipCode 	INT
						);
/***********************Department Table***********************/
GO
CREATE TABLE Department(
						DepartmentID 	INT IDENTITY PRIMARY KEY,
						DepartmentName 	VARCHAR(40)
						);
/***********************Doctor Table***********************/
GO
CREATE TABLE Doctor(
						DoctorID 		INT IDENTITY PRIMARY KEY,
						DoctorFName 	VARCHAR(30),
						DoctorLName 	VARCHAR(30),
						DepartmentID 	INT REFERENCES Department(DepartmentID),
						drMobile 		VARCHAR(11)
						);
/***********************Patient Table***********************/
GO
CREATE TABLE Patient(
						PatientID 		INT IDENTITY PRIMARY KEY,
						FirstName 		VARCHAR(30),
						LastName 		VARCHAR(30),
						Age 			INT DEFAULT 1,
						DoctorID 		INT REFERENCES Doctor(DoctorID) ON DELETE NO ACTION,
						GenderID 		INT REFERENCES Gender(GenderID) ON DELETE NO ACTION,
						ReligionID 		INT REFERENCES Religion(ReligionID) ON DELETE NO ACTION,
						AreaID 			INT REFERENCES Area(AreaID) ON DELETE NO ACTION,
						MobileNumber	VARCHAR(11),
						CabinNumber 	INT DEFAULT NULL,
						OrderDate 		DATETIME2 DEFAULT GETDATE(),
						DelevaryDate 	DATETIME2 NULL
						);
/***********************Particular Table***********************/
GO
CREATE TABLE Particular(
						ParticularID 	INT IDENTITY PRIMARY KEY,
						ParticularName 	VARCHAR(200),
						Rate 			MONEY DEFAULT 50
						);
/***********************Service Table***********************/
CREATE TABLE Service(
						PatientID 		INT REFERENCES Patient(PatientID),
						ParticularID 	INT REFERENCES Particular(ParticularID),
						Quntity 		INT DEFAULT 1,
						PRIMARY KEY (PatientID, ParticularID)
						);
/***********************Insert into Religion Table***********************/
GO
INSERT INTO Religion VALUES('Islam'), ('Hinduism'), ('Christianity'), ('Buddhism');

/***********************Insert into Gender Table***********************/
GO
INSERT INTO Gender VALUES('Male'), ('Female'), ('Custom');

/***********************Insert into Country Table***********************/
GO
INSERT INTO Country VALUES('Bangladesh'), ('India'), ('Nepal'), ('Srilanka'), ('USA'), ('Pakistan');

/***********************Insert into District Table***********************/
GO
INSERT INTO District VALUES (1, 'Cumilla'), (1, 'Feni'), (1, 'Chittagong'), (1, 'Dhaka'), (1, 'Barguna'),
							(1, 'Barisal'), (1, 'Bhola'), (1, 'Sirajgong'), (1, 'Satkhira'), (1, 'khulna');

/***********************Insert into Area Table***********************/
GO
INSERT INTO Area VALUES (1, 'Nangalkot', 3582), (1, 'Burora', 3581), 
						(1, 'Cumilla Sadar', 3583), (1, 'Lalmai', 3584), 
						(1, 'Laksam', 3585),(4, 'Keranigong', 3589),
						(4, 'Savar', 3580), (4, 'Tejgion', 3588), 
						(4, 'Nawabgong', 3587), (4, 'Dhamrai', 3500),
						(3, 'Anowara', 3590), (3, 'Bashkhali', 3591), 
						(3, 'Bowalkhali', 3592), (3, 'Hathazari', 3593),
						(3, 'Kornofully', 3594);

/***********************Insert into Department Table***********************/
GO
INSERT INTO Department VALUES ('Cardiology'), ('Burn'), ('Neurology'), 
								('Coronary'), ('Gynecology'), ('Haematology'),
								('Radiology');

/***********************Insert into Doctor Table***********************/
GO
INSERT INTO Doctor VALUES ('Abul', 'Haidar', 1, '01722363361'), ('Abdur', 'Roshid', 2, '01722363362'),
							('Dripty', 'Sarkar', 3, '01722363363'), ('Sohidul', 'Islam', 4, '01722363364'),
							('Anayet', 'Ullah', 5, '01722363365'), ('Selina', 'Akter', 6, '01722363366'),
							('kepayet', 'Hossain', 7, '01722363367'), ('Sorif', 'Ahmed', 1, '01686265442');

/***********************Insert into Patient Table***********************/
GO
INSERT INTO Patient (FirstName, LastName, Age, DoctorID, GenderID, ReligionID, AreaID, MobileNumber, CabinNumber, OrderDate)
				VALUES ('Kawsar', 'Hossain', 35, 1, 1, 1, 1, '01721454530', 1, DEFAULT),
						('Alauddin', 'Hossain', 26, 2, 1, 1, 2, '01721454531', 2, DEFAULT),
						('Mohib', 'Ullah', 28, 3, 1, 1, 3, '01721454533', 3, DEFAULT),
						('Masud', 'Hasan', 20, 4, 1, 1, 4, '01721454534', 4, DEFAULT),
						('Emran', 'Hosen', 25, 5, 1, 1, 5, '01721454535', 5, DEFAULT),
						('Sarmin', 'Akter', 23, 6, 2, 1, 6, '01721454536', 6, DEFAULT),
						('Benjir', 'Akter', 30, 7, 2, 1, 7, '01721454537', 7, DEFAULT),
						('Rokya', 'Akter', 19, 1, 2, 1, 8, '01721454538', 8, DEFAULT),
						('Alauddin', 'Jafor', 22, 2, 1, 1, 9, '01721454539', 9, DEFAULT),
						('Arif', 'Hossain', 26, 3, 1, 1, 10, '01721454540', 10, DEFAULT),
						('Sorif', 'Ahmed', 13, 4, 2, 1, 11, '01721454541', 11, DEFAULT),
						('Nila', 'Choydury', 19, 5, 2, 2, 12, '01721454542', 12, DEFAULT),
						('Henry', 'aliba', 31, 6, 2, 3, 13, '01721454543', 13, DEFAULT),
						('Rojario', 'Mithi', 45, 7, 2, 4, 14, '01721454544', 14, DEFAULT),
						('Arjit', 'Singh', 25, 1, 1, 2, 15, '01721454545', 15, DEFAULT),
						('Atik', 'Hossain', 35, 1, 1, 1, 1, '01721454551', 1, DEFAULT),
						('Saddam', 'Hossain', 26, 2, 1, 1, 2, '01721454552', 2, DEFAULT),
						('Razib', 'Ullah', 28, 3, 1, 1, 3, '01721454553', 3, DEFAULT),
						('feoze', 'Hasan', 20, 4, 1, 1, 4, '01721454554', 4, DEFAULT),
						('Shopon', 'Hosen', 25, 5, 1, 1, 5, '01721454556', 5, DEFAULT),
						('Khaleda', 'Akter', 23, 6, 2, 1, 6, '01721454557', 6, DEFAULT),
						('afia', 'Akter', 30, 7, 2, 1, 7, '01721454558', 7, DEFAULT),
						('Sefali', 'Akter', 19, 1, 2, 1, 8, '01721454559', 8, DEFAULT),
						('Md.', 'Jafor', 22, 2, 1, 1, 9, '01721454560', 9, DEFAULT),
						('soibal', 'Hossain', 26, 3, 1, 1, 10, '01721454561', 10, DEFAULT),
						('Kancon', 'Ahmed', 13, 4, 2, 1, 11, '01721454562', 11, DEFAULT),
						('Dipti', 'Choydury', 19, 5, 2, 2, 12, '01721454563', 12, DEFAULT),
						('arina', 'aliba', 31, 6, 2, 3, 13, '01721454564', 13, DEFAULT),
						('Alex', 'Mithi', 45, 7, 2, 4, 14, '01721454565', 14, DEFAULT),
						('Arun', 'Singh', 25, 1, 1, 2, 15, '01721454566', 15, DEFAULT);


/***********************Insert into Particular Table***********************/
GO
INSERT INTO Particular VALUES	('Computer Axial Tomography (CT)', 870), ('Magnetic Resonance Imaging (MRI)', 3600),
								('Complete Blood Count (CBC)', 500), ('Prothrombin Time (PT)', 300),
								('Electrocardiogram (EKG)', 120), ('Prostate Specific Antigen (PSA Test)', 1350);

/***********************Insert into Service Table***********************/
GO
INSERT INTO Service VALUES (1, 1, DEFAULT), (1, 2, 2), (1, 4, DEFAULT), (2, 4, DEFAULT), (2, 3, DEFAULT), 
							(3, 4, 3), (3, 3, DEFAULT), (3, 6, 1), (4, 6, DEFAULT), (4, 5, DEFAULT), 
							(5, 1, DEFAULT), (5, 3, 2), (5, 5, DEFAULT), (6, 2, 2), (6, 3, DEFAULT), (7, 6, DEFAULT), 
							(7, 4, 1), (8, 5, 1), (9, 2, 1), (9, 3, 1), (10, 4, 2), (10, 6, 2), (11, 3, DEFAULT), 
							(12, 1, DEFAULT), (12, 4, DEFAULT), (13, 5, 1), (14, 6, 1), (15, 4, 2), (15, 6, DEFAULT), 
							(16, 3, DEFAULT), (16, 1, DEFAULT), (17, 2, 3), (18, 3, 1), (19, 3, 2), (20, 4, 1), 
							(20, 6, 1), (21, 1, DEFAULT), (22, 3, 1), (23, 6, 3), (24, 5, 2),
							(25, 2, DEFAULT), (26, 1, 2), (26, 3, DEFAULT), (27, 2, 2), (28, 2, DEFAULT), 
							(29, 4, 3), (29, 6, 5), (30, 1, DEFAULT);


/***********************Copy A Table From another Table***********************/
GO
SELECT * INTO PatientCopy FROM Patient;

/*********************** Create PatientArchive Table***********************/
GO
CREATE TABLE  PatientArchive (PatientID INT ,
						FirstName VARCHAR(30),
						LastName VARCHAR(30),
						Age INT DEFAULT 1,
						MobileNumber VARCHAR(11),
						CabinNumber INT DEFAULT NULL,
						Capacity int
						);

GO
/***********************Alter A Table***********************/
ALTER TABLE PatientArchive DROP COLUMN Capacity;

GO
/***********************CREATE Non Clustred INDEX***********************/


GO
CREATE INDEX IX_Country ON Country(CountryName);
CREATE INDEX IX_Department ON Department(DepartmentName);
CREATE INDEX IX_Particular ON Particular(ParticularName);

/***********************Create Clustered Index***********************/

GO
CREATE CLUSTERED INDEX IX_PatientCopy_PatientID ON PatientCopy(PatientID ASC);

GO

/***********************1.Create view by including index information *******************************/
CREATE PROC sp_All_Index_Information
AS
SELECT 
     TableName = t.name,
     IndexName = ind.name,
     IndexId = ind.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
     ind.*,
     ic.*,
     col.* 
FROM 
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
WHERE 
	 t.is_ms_shipped = 0 
ORDER BY 
     t.name, ind.name, ind.index_id, ic.index_column_id;

GO

/***********************Create Sequence***********************/

CREATE SEQUENCE CabinNo
	AS INT 
			START WITH 1
			INCREMENT BY 1
			MINVALUE 1
			MAXVALUE 15
			CYCLE;

GO
/***********************2.Create view & Find Patient Details***********************/


CREATE VIEW vw_PatientDetails
WITH ENCRYPTION
AS
SELECT		CONCAT(FirstName, ' ', LastName) AS [Patient Name], 
			DoctorFName + ' ' + DoctorLName AS [Doctor Name], 
			DepartmentName, 
			Age, 
			AreaName, 
			DistrictName, 
			CountryName  
FROM Patient	JOIN Area		ON Patient.AreaID = Area.AreaID
				JOIN District	ON District.DistrictID = Area.DistrictID
				JOIN Country	ON Country.CountryID = District.CountryID
				JOIN Doctor		ON Patient.DoctorID = Doctor.DoctorID
				JOIN Department	ON Department.DepartmentID = Doctor.DepartmentID
WHERE Age >5;


GO
/************3.Create a view find the Quntity Of Particulars & 
	Using Aggregate Function With Group By And Having Cluse And Summarize data using WITH ROLLUP**/

CREATE VIEW vw_ParticularQuntaty
AS
SELECT		Particular.ParticularName, 
			Particular.Rate, 
			COUNT(Service.Quntity) AS TotalQuntity, 
			SUM(Particular.Rate) AS  TotalRate
	FROM Particular JOIN Service ON Particular.ParticularID = Service.ParticularID
		GROUP BY Particular.ParticularName, Particular.Rate --WITH ROLLUP
			HAVING MAX(Particular.Rate) >100;

GO
/****************4.Create A view Find out the Maximum Time tested Particular*********************/
CREATE VIEW vw_MaxParticular
AS
WITH CTE2 AS(

	SELECT ParticularName ,
	(SELECT COUNT(Quntity) FROM Service WHERE Service.ParticularID = Particular.ParticularID) AS [Maximum Test]
	FROM Particular)
SELECT CTE2.ParticularName , CTE2.[Maximum Test] FROM CTE2 WHERE [Maximum Test] = (SELECT MAX ([Maximum Test]) FROM CTE2); 
GO

/****************5.Create Stored Procedure & Find Out the All information Of Patient*****************************************/

CREATE PROC sp_PatientDetails
@PatientID INT = NULL
AS
SELECT		PatientID,
			CONCAT(FirstName, ' ', LastName) AS Name, 
			DoctorFName + ' ' + DoctorLName AS Doctor, 
			DepartmentName, 
			Age, 
			AreaName, 
			DistrictName, 
			CountryName  
FROM Patient	JOIN Area		ON Patient.AreaID = Area.AreaID
				JOIN District	ON District.DistrictID = Area.DistrictID
				JOIN Country	ON Country.CountryID = District.CountryID
				JOIN Doctor		ON Patient.DoctorID = Doctor.DoctorID
				JOIN Department	ON Department.DepartmentID = Doctor.DepartmentID
WHERE PatientID = @PatientID;
GO


/***************6.Create Stored Procedure & Update Patient Table*****************************/

CREATE PROC sp_UpdatePatient
@ID INT ,
@Fname VARCHAR(50),
@Lname VARCHAR(50)
AS
UPDATE Patient 
SET
		FirstName = @Fname, 
		LastName = @Lname 
WHERE PatientID = @ID ;
SELECT * FROM Patient WHERE PatientID = @ID ;

GO

/*******************7.Create User Defined Table Valued Function***************************/

CREATE FUNCTION fn_PaymentTotal 
(@id INT = 0)
RETURNS TABLE
RETURN (
		SELECT	P.PatientID,
			(FirstName + ' ' + LastName) AS Name, 
			ParticularName, 
			Rate ,
			Quntity, 
			(Rate * Quntity) AS Total 
From Patient AS P JOIN Service AS S ON P.PatientID = S.PatientID
			JOIN Particular AS F ON S.ParticularID = F.ParticularID
WHERE p.PatientID = @id);

GO

/**************8.Create User Defined Scalar Valued Function***************/

CREATE FUNCTION fn_MaxPrice 
(@id INT = 0)
RETURNS INT
AS
BEGIN
	RETURN (SELECT Rate FROM Particular
		WHERE ParticularID = @id);
END
GO

/***********************9.Create Tregger For DELETE & Insert into another Table**************************/

CREATE TRIGGER trPatientDetails
ON PatientCopy
AFTER DELETE 
AS 
INSERT INTO PatientArchive(	PatientID, 
							FirstName,
							LastName,
							Age,
							MobileNumber,
							CabinNumber)
		SELECT	PatientID,
				FirstName,
				LastName,
				Age,
				MobileNumber ,
				CabinNumber FROM deleted;


		
/********************10.CREATE view for Cheak Insead Trigger**************************/

GO
CREATE VIEW vw_Area
AS
SELECT Area.AreaID, Area.AreaName, District.DistrictName 
FROM Area 
			JOIN District ON Area.DistrictID = District.DistrictID;
GO

/*****************11.Instead Trigger on view****************/
CREATE TRIGGER tr_vw_Area
ON vw_Area
INSTEAD OF INSERT 
AS
	BEGIN 
			DECLARE @AreaID int
			SELECT @AreaID = DistrictID FROM District JOIN inserted ON District.DistrictName = inserted.DistrictName;

		IF (@AreaID is null) 
		
				THROW 50010, 'Sorry Trainee are not Stored This District In District Table ON MedicalTestDB DataBase', 1;
		Else	
	
		insert into Area (AreaName, DistrictID)
		Select AreaName, @AreaID FROM inserted
END;

GO

/**********************Create Store Procidure Where We Can Insert, Update & Delete On a Table*************************/
GO
SELECT * INTO ParticularCopy FROM Particular;
GO
CREATE PROC sp_insertUpdateDelete
@Work Varchar(10) ,
@ID int = NULL,
@Name Varchar(100) = NULL,
@Price INt OUT
AS
BEGIN
	IF @Work = 'INSERT'
		BEGIN
			INSERT INTO ParticularCopy (ParticularName) VALUES (@Name);
			SELECT  @Price = @@IDENTITY ;
		END
	IF @Work = 'UPDATE'
		BEGIN 
			UPDATE ParticularCopy SET ParticularName = @Name WHERE ParticularID = @ID;
			SELECT @Price = @@IDENTITY;
		END
	IF @Work = 'DELETE'
		BEGIN
			DELETE FROM ParticularCopy Where ParticularID = @ID;
			SELECT @Price = @@IDENTITY;
		END
END;

GO


/*---------------------------------------------------------------------------------*/
IF OBJECT_ID ('sp_insertUpdateDelete') IS NOT NULL
PRINT ('This Script Successfully Executed');

/*----------------------------------------------------*/
GO

/**********************1251184- Robiul Hossain************************************/