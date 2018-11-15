/**
SELECT MissingCount = SUM(IIF(HamoPk21 = '?', 1, 0))
		,ValidCount = SUM(IIF(HamoPk21 <> '?', 1, 0))
FROM train T 
**/

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
	
	SELECT *
	INTO #TempTrain 
	FROM train
		
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

		-- Input missing and valid totals for each attribute
		SELECT @SQL = '
			WITH MissingAndValid AS (
				SELECT MissingCount = SUM(IIF(CAST(' + @AttributeName + ' AS VARCHAR(50)) = ''?'', 1, 0))
						,ValidCount = SUM(IIF(CAST(' + @AttributeName + ' AS VARCHAR(50)) <> ''?'', 1, 0))
						,AttributeName = ''' + @AttributeName + '''
				FROM train T 
			)
			UPDATE TT
			SET MissingCount = MAV.MissingCount
				,ValidCount = MAV.ValidCount
			FROM #DecisionTable TT JOIN MissingAndValid MAV ON MAV.AttributeName = TT.AttributeName
		'

		EXEC(@SQL)

		-- Input averages for missing values (exluding those columns to be removed)
		SELECT @SQL = '
			IF EXISTS ( SELECT TOP 1 * FROM #DecisionTable DT WHERE DT.AttributeName = ''' + @AttributeName + ''' AND ( MissingCount > 0 AND MissingCount < ValidCount ) )
			BEGIN
				DECLARE @Average DECIMAL(18,6)
				
				SELECT @Average = SUM(IIF(' + @AttributeName + ' <> ''?'', CAST(' + @AttributeName + ' AS DECIMAL(18,6)), 0)) / SUM (IIF(' + @AttributeName + ' <> ''?'', 1, 0))
				FROM #TempTrain TT 

				UPDATE TT
				SET ' + @AttributeName + ' = @Average
				FROM #TempTrain TT 
				WHERE TT.' + @AttributeName + ' = ''?''

			END
		'

		EXEC(@SQL)

	END 
	
	-- Do missing value > 50% attribute removal 
	DELETE FROM #DecisionTable
	WHERE MissingCount <= ValidCount OR AttributeName IN ('mix1_instrument', 'mix2_instrument')

	;WITH RowNumbers AS (
		SELECT DT.AttributeNumber
				,RowNumber = ROW_NUMBER() OVER (PARTITION BY RowNumber ORDER BY RowNumber)
		FROM #DecisionTable DT
	)
	UPDATE DT
	SET RowNumber = RN.RowNumber
	FROM #DecisionTable DT JOIN RowNumbers RN ON RN.AttributeNumber = DT.AttributeNumber
	SELECT @ROWCOUNT = @@ROWCOUNT

	SET @i = 0
	WHILE @i < @ROWCOUNT
	BEGIN
		SET @i = @i + 1
		
		SELECT @AttributeName = DT.AttributeName
		FROM #DecisionTable DT
		WHERE DT.RowNumber = @i

		SELECT @SQL = '
			ALTER TABLE #TempTrain
			DROP COLUMN ' + @AttributeName + ' 
		'

		EXEC(@SQL)

	END

	SELECT * FROM #TempTrain

END
GO