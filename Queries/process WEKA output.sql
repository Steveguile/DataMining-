GO
BEGIN 

	DECLARE @SQL VARCHAR(8000)

	DECLARE @FilePath VARCHAR(256) = 'E:\Steve_Files\Work\University\Year 4\Data Mining\Assignment\Run\'
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
	DECLARE @RunNumber VARCHAR(50) = '33\'
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
	DECLARE @InName VARCHAR(50) = '33_pre_parsed'
	DECLARE @OutName VARCHAR(50) = '25_parsed'
	DECLARE @FileExtension VARCHAR(4) = '.csv'
	DECLARE @ROWCOUNT INT 

	IF OBJECT_ID('tempdb..#Original') IS NOT NULL 
		DROP TABLE #Original
	IF OBJECT_ID('tempdb..#OutTable') IS NOT NULL 
		DROP TABLE #OutTable

	CREATE TABLE #Original (
		 Id INT 
		,Actual VARCHAR(50)
		,Predicted VARCHAR(50)
		,Error VARCHAR(50)
		,Prediction VARCHAR(50)
	)

	SELECT @SQL = '
		BULK INSERT tempdb..#Original FROM ''' + @FilePath + @RunNumber + @InName + @FileExtension + ''' WITH (FORMAT = ''CSV'');
	'
	
	EXEC(@SQL)

	SELECT * FROM #Original

	;WITH Sub AS (
		SELECT Id = O.Id
				,Instrument = SUBSTRING(O.Predicted, CHARINDEX(':', O.Predicted) + 1, LEN(O.Predicted))
		FROM #Original O
	)
	SELECT S.Id
			,Instrument = CASE WHEN FAM.Instrument IS NOT NULL THEN FAM.Instrument
									 WHEN S.Instrument LIKE '%Trombone' THEN 'Trombone'
									 WHEN S.Instrument LIKE '%Trumpet' THEN 'Trumpet' 
									 WHEN S.Instrument LIKE '%Clarinet' THEN 'Clarinet'
									 WHEN S.Instrument LIKE '%Saxophone' THEN 'Saxophone'
									 ELSE S.Instrument END 
	INTO #OutTable  
	FROM Sub S LEFT JOIN flute_accordian_matrix FAM ON FAM.Id = S.Id

	SELECT @ROWCOUNT = @@ROWCOUNT
	
	SELECT Instrument 
			,TotalCount = @ROWCOUNT
			,InstrumentCount = COUNT(*)
			,PercentageTotal = LEFT(( COUNT(*) / CAST(@ROWCOUNT AS DECIMAL(10,4)) ) * 100 , 4)
	FROM #OutTable
	GROUP BY Instrument

	SELECT * 
	FROM #OutTable ORDER BY Id

	--EXEC master..xp_cmdshell 'SQLCMD -S DESKTOP-6A5SJV7\DATAMINING -E -s, -W -Q "SELECT * FROM #OutTable" > ExcelTest.csv'

END
GO
