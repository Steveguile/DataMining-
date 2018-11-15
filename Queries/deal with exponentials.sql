
GO 
BEGIN 

	DECLARE @SQL VARCHAR(8000)
	DECLARE @AttributeName VARCHAR(50)
	DECLARE @MissingCount INT
	DECLARE @ValidCount INT 

	IF OBJECT_ID('tempdb..#DecisionTable') IS NOT NULL
		DROP TABLE #DecisionTable
	IF OBJECT_ID('tempdb..#TempTrain') IS NOT NULL
		DROP TABLE #TempTrain

	SELECT * INTO #TempTrain
	FROM train 
	WHERE Flux NOT LIKE '%E+137%' -- irritating outlier that causes arithmetic overflow 
		
	SELECT AttributeNumber = ROW_NUMBER() OVER (PARTITION BY t.name ORDER BY t.name)
			,AttributeName = c.name
			,Exponential = 0  
			,MissingCount = NULL
			,ValidCount = NULL
			,RowNumber = NULL
	INTO #DecisionTable
	FROM sys.tables t JOIN sys.columns c ON c.object_id = t.object_id
	WHERE t.name = 'train'

	DECLARE @ROWCOUNT INT = @@ROWCOUNT
	DECLARE @i INT = 0

	WHILE @i < @ROWCOUNT
	BEGIN
		SET @i = @i + 1
		
		SELECT @AttributeName = AttributeName
		FROM #DecisionTable TT
		WHERE AttributeNumber = @i AND AttributeName NOT IN ('mix1_instrument', 'mix2_instrument')

		-- Get all attributes that have at least 1 attribute as an exponential 
		SELECT @SQL = '
			IF EXISTS ( SELECT TOP 1 ' + @AttributeName + ' FROM #TempTrain TT WHERE ' + @AttributeName + ' LIKE ''%E%'' )
				UPDATE DT 
				SET Exponential = 1
				FROM #DecisionTable DT
				WHERE AttributeName = ''' + @AttributeName + ''' 
		'

		EXEC(@SQL)
		
		-- Calculate exponential for all valid attributes, can filter outliers later
		SELECT @SQL = '

			DECLARE @AttributeName VARCHAR(50) = ''' + @AttributeName + '''
			
			IF EXISTS ( SELECT TOP 1 * FROM #DecisionTable WHERE AttributeName = ''' + @AttributeName + ''' AND Exponential = 1 ) 
				UPDATE TT 
				SET ' + @AttributeName + ' = EXP(TT.' + @AttributeName + ') 
				FROM #TempTrain TT JOIN #DecisionTable DT ON DT.AttributeName =  @AttributeName 
				WHERE DT.Exponential = 1 AND ' + @AttributeName + ' LIKE ''%[0-9]E%'' --I''ve found doing this to all values (not only those explicity with E functions) normalises data 
		'
		EXEC(@SQL)

	END 

	SELECT * FROM #TempTrain

END
GO

