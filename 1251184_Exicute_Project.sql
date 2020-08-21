USE master;
GO
/******************************************************/
GO
USE MedicalTestDB;
/******************************************************/
GO
SELECT * FROM Religion;
SELECT * FROM Gender;
SELECT * FROM Country;
SELECT * FROM District;
SELECT * FROM Area;
SELECT * FROM Department;
SELECT * FROM Doctor;
SELECT * FROM Patient;
SELECT * FROM Particular;
SELECT * FROM Service;
GO
/**********************Execute Store Procidure Where We Can Insert, Update & Delete On a Table*************************/
DECLARE @Result INT ;
EXEC sp_insertUpdateDelete  @Work = 'INSERT', @Name = 'New bgParticular11', @Price = @Result OUT;
PRINT CAST (@Result AS VARCHAR(40));
------------------------------------------------------------
DECLARE @Result INT ;
EXEC sp_insertUpdateDelete  @Work = 'UPDATE', @Name = 'New Particular', @ID = 3, @Price = @Result OUT;
PRINT CAST (@Result AS VARCHAR(40));
------------------------------------------------------------
DECLARE @Result INT ;
EXEC sp_insertUpdateDelete  @Work = 'DELETE', @ID = 3, @Price = @Result OUT;
PRINT CAST (@Result AS VARCHAR(40));

SELECT * FROM ParticularCopy;

GO

/***********************1.All  index information  Of This Database*******************************/
EXEC sp_All_Index_Information;

GO
/***********************2. view & Find Patient Details***********************/


SELECT * FROM vw_PatientDetails;

GO

/************3. a view find the Quntity Of Particulars & 
	Using Aggregate Function With Group By And Having Cluse And Summarize data using WITH ROLLUP**/

SELECT * FROM vw_ParticularQuntaty;

GO

/****************4.A view Find out the Maximum Time tested Particular*********************/
SELECT * FROM vw_MaxParticular;

GO

/****************5.Stored Procedure & Find Out the All information Of Patient*****************************************/

EXEC sp_PatientDetails 1;


GO


/***************6. Stored Procedure & Update Patient Table*****************************/

EXEC sp_UpdatePatient 1, 'Kawsar', 'Hossain';

GO

/*******************7. User Defined Table Valued Function***************************/

SELECT * FROM dbo.fn_PaymentTotal(1);

GO
/**************8. User Defined Scalar Valued Function Find the Max Prise***************/

PRINT dbo.fn_MaxPrice(1);

GO

/***********************8.A Tregger For DELETE & Insert into another Table**************************/

DELETE FROM PatientCopy 
WHERE PatientID =8;

SELECT * FROM PatientArchive;
GO

/********************9.view for Cheak Insead Trigger **************************/

SELECT * FROM vw_Area;
GO

/******************11.Insert into View And returen Excepted Number ****************************************************/

INSERT INTO		vw_Area VALUES (20, 'MIRPUR', 'Noakhali');
GO

SELECT * FROM vw_Area;
GO
--Update statement-------------------------------------------------
/******************************************************/

UPDATE Patient 
	SET DelevaryDate = GETDATE() + 3
	WHERE PatientID = 1;

/***Update Statement***************************************************/

UPDATE Particular
	SET Rate = Rate -100
	WHERE Rate > 1000;

GO
/*****.DELETE Statement*************************************************/

DELETE FROM Country 
WHERE CountryID =3;


GO
/*****System Stored Procedure For cheak created sp*************************************************/

EXEC sp_HelpText fn_PaymentTotal;
EXEC sp_HelpText tr_vw_Area;


GO

/*****Use Try-Catch and Begain-End---(Age = 'kk' Error rise)--(Age = 23 Successfully insert)*************************************************/

BEGIN TRY
    INSERT Patient(FirstName, Age, LastName)
    VALUES ('Ajmol', '20', 'Khondokar');
    PRINT 'SUCCESS: Record was inserted.';
END TRY
BEGIN CATCH
    PRINT 'FAILURE: Record was not inserted.';
    PRINT 'Error ' + CONVERT(varchar, ERROR_NUMBER(), 1) 
        + ': ' + ERROR_MESSAGE();
END CATCH;
GO


/**Join All Table From (MedicalTestDB)****************************************************/

SELECT		CONCAT(FirstName, ' ', LastName) AS Name, 
			DoctorFName + ' ' + DoctorLName AS Doctor, 
			DepartmentName,
			ParticularName,
			Age,
			GenderName,
			ReligionName,
			AreaName, 
			DistrictName, 
			CountryName 
FROM Patient	JOIN Area		ON Patient.AreaID = Area.AreaID
				JOIN District	ON District.DistrictID = Area.DistrictID
				JOIN Country	ON Country.CountryID = District.CountryID
				JOIN Doctor		ON Patient.DoctorID = Doctor.DoctorID
				JOIN Department	ON Department.DepartmentID = Doctor.DepartmentID
				JOIN Service	ON Service.PatientID = Patient.PatientID
				JOIN Particular	ON Particular.ParticularID = Service.ParticularID
				JOIN Gender		ON Gender.GenderID = Patient.GenderID
				JOIN Religion	ON Religion.ReligionID = Patient.ReligionID
WHERE Particular.ParticularID = 1;

/******String Expression And Arithmatic Expression With Join**********************************************/


SELECT	(FirstName + ' ' + LastName) AS Name, 
		ParticularName, 
		Rate ,
		Quntity, 
		(Rate * Quntity) AS Total 
From Patient JOIN Service ON Patient.PatientID = Service.PatientID
			JOIN Particular ON Service.ParticularID = Particular.ParticularID;
GO

/******USE the Left & Right Function****************************************************/


SELECT FirstName, LastName, 
		LEFT(FirstName, 1) + RIGHT(LastName, 1) AS Short
FROM Patient;


GO

/**********.Use Top cluse And Logical Operator****************************************************/

SELECT TOP 5 Particular.ParticularName, Rate 
	FROM Particular
	WHERE Rate >200 AND Rate <1000
	ORDER BY Rate DESC;

GO

/********.Use Between Operator****************************************************/

SELECT TOP 5 Particular.ParticularName, Rate 
FROM Particular
WHERE Rate BETWEEN 200 AND 1000;

GO

/******** Use Like Operator*************************************************/

SELECT * FROM Patient
WHERE FirstName LIKE 'A%';



GO

/*********Join With Correlation Name****************************************************/

SELECT		(FirstName + ' ' + LastName) AS Name, 
			ParticularName, 
			Rate ,
			Quntity, 
			(Rate * Quntity) AS Total 
From Patient AS P JOIN Service AS S ON P.PatientID = S.PatientID
			JOIN Particular AS F ON S.ParticularID = F.ParticularID;


GO

/********* Cross Join Exaample*************************************************/

SELECT District.DistrictName, Country.CountryName
FROM Country CROSS JOIN District;

GO

/*********Find the title From Doctor & Patieon Using Union****************************************************/

	SELECT FirstName + ' ' + LastName AS Name,'Patient:' AS Titel
	FROM Patient
UNION
	SELECT  DoctorFName + ' ' + DoctorLName AS Doctor, 'Doctor:' AS Title
	FROM Doctor;


GO
/********* Disimilarity OF the Doctors &  The Patient Name Using EXCEPT***************************************************/

SELECT FirstName + ' ' + LastName AS Name
	FROM Patient
EXCEPT
	SELECT  DoctorFName + ' ' + DoctorLName AS Doctor
	FROM Doctor;

--
GO
/********* Similarity OF the Doctors &  The Patient Name Using Intersect***************************************************/

SELECT FirstName + ' ' + LastName AS Name
	FROM Patient
INTERSECT
	SELECT  DoctorFName + ' ' + DoctorLName AS Doctor
	FROM Doctor;


/********Patient List Who Test Particular 1 By Using SubQuery****************************************************/

SELECT FirstName + ' ' + LastName AS Name, Age, MobileNumber 
	FROM Patient
	WHERE PatientID IN 
					(SELECT PatientID FROM Service WHERE ParticularID = 1);


/*********Find out the Particulars thats are abalavile in Medical By USE Correlated SubQueries**************************************************/


SELECT ParticularID, ParticularName, Rate 
FROM Particular AS P1
WHERE Rate <= 
			(SELECT AVG(Rate) 
			FROM Particular AS P2
			WHERE P1.ParticularID =P2.ParticularID)
ORDER BY ParticularID, ParticularName;

GO
/************Common Table Expression (CTE)*****************************/


WITH Tb1 AS (
			SELECT	(FirstName + ' ' + LastName) AS Name, 
			ParticularName, 
			Rate ,
			Quntity, 
			(Rate * Quntity) AS Total 
From Patient JOIN Service ON Patient.PatientID = Service.PatientID
			JOIN Particular ON Service.ParticularID = Particular.ParticularID
			),

Tb2 AS (
			SELECT Tb1.Name, SUM(Tb1.Total) AS [Net Total] 
			FROM Tb1 GROUP BY Tb1.Name
			)
SELECT Tb2.Name, Tb2.[Net Total] FROM Tb2 Where Tb2.[Net Total] < 1000;

GO
/**********USE The CAST & CONVERT Function********************************************/

SELECT	FirstName,
		LastName, 
		CONVERT(DATE, OrderDate) AS Date, 
		CAST(OrderDate AS TIME) AS Time
	FROM Patient;


GO
/******Use The CASE Functun************************************************/

SELECT	Particular.ParticularName,
		Particular.Rate,
		CASE 
			WHEN Particular.Rate < 400 THEN 'Lowest Cost'
			WHEN Particular.Rate < 700 THEN 'Medium Cost'
			WHEN Particular.Rate < 1000 THEN 'Highest Cost'
			ELSE 'Over Cost'
			END AS Remark
	FROM Particular;

GO
/*****Ranking the Particulars On the Price*************************************************/

SELECT	Particular.ParticularName, 
		Particular.Rate,
		ROUND(Particular.Rate, -2) AS [Round by 100],
		RANK() OVER (ORDER BY Rate DESC) AS Rank
		FROM Particular;
GO
/********************Transection**********************************/


BEGIN TRAN;

	DELETE ParticularCopy
	WHERE Rate > 500;

IF @@ROWCOUNT > 1
    BEGIN
        ROLLBACK TRAN;
        PRINT 'More then one Particular than affected. SO Delete  rolled back.';
    END;
ELSE
    BEGIN
        COMMIT TRAN;
        PRINT 'Deleted a row committed to the database.';
    END;



/**********************1251184- Robiul Hossain************************************/