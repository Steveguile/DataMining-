GO
 -- Tables only to be used when not preprocessing
IF EXISTS( SELECT TOP 1 * FROM sys.tables t WHERE T.name = 'train_preprocess' )
	DROP TABLE dbo.train_preprocess
IF EXISTS( SELECT TOP 1 * FROM sys.tables t WHERE T.name = 'test_preprocess' )
	DROP TABLE dbo.test_preprocess

IF NOT EXISTS( SELECT TOP 1 * FROM sys.tables t WHERE T.name = 'train_preprocess' ) AND 
   NOT EXISTS( SELECT TOP 1 * FROM sys.tables t WHERE T.name = 'test_preprocess' )
BEGIN

	IF OBJECT_ID('tempdb..#TempTrain') IS NOT NULL
		DROP TABLE #TempTrain 
	IF OBJECT_ID('tempdb..#ProcessTest') IS NOT NULL
		DROP TABLE #ProcessTest
	IF OBJECT_ID('tempdb..#TempTest') IS NOT NULL
		DROP TABLE #TempTest  
	IF OBJECT_ID('tempdb..#DistinctLabels') IS NOT NULL
		DROP TABLE #DistinctLabels
	IF OBJECT_ID('tempdb..#DecisionTable') IS NOT NULL
		DROP TABLE #DecisionTable

	DECLARE @AttributeName VARCHAR(50)
	DECLARE @SQL VARCHAR(8000) = ''
	DECLARE @ColumnSelect VARCHAR(8000) = ''

	/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Training Set~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	;WITH mix1_instrument AS (
		SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff
				,bandsCoefSum = bandsCoef1+bandsCoef2+bandsCoef3+bandsCoef4+bandsCoef5+bandsCoef6+bandsCoef7+bandsCoef8+bandsCoef9+bandsCoef10+bandsCoef11+bandsCoef12+bandsCoef13+bandsCoef14+bandsCoef15+bandsCoef16+bandsCoef17+bandsCoef18+bandsCoef19+bandsCoef20+bandsCoef21+bandsCoef22+bandsCoef23+bandsCoef24+bandsCoef25+bandsCoef26+bandsCoef27+bandsCoef28+bandsCoef29+bandsCoef30+bandsCoef31+bandsCoef32+bandsCoef33+bandsCoefSum
				,prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk19, HamoPk27 
				,mix1_instrument
		FROM train 
	), mix2_instrument AS (
		SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff
				,bandsCoefSum = bandsCoef1+bandsCoef2+bandsCoef3+bandsCoef4+bandsCoef5+bandsCoef6+bandsCoef7+bandsCoef8+bandsCoef9+bandsCoef10+bandsCoef11+bandsCoef12+bandsCoef13+bandsCoef14+bandsCoef15+bandsCoef16+bandsCoef17+bandsCoef18+bandsCoef19+bandsCoef20+bandsCoef21+bandsCoef22+bandsCoef23+bandsCoef24+bandsCoef25+bandsCoef26+bandsCoef27+bandsCoef28+bandsCoef29+bandsCoef30+bandsCoef31+bandsCoef32+bandsCoef33+bandsCoefSum
				,prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk19, HamoPk27
				,mix2_instrument
		FROM train t 
		WHERE t.mix2_instrument <> '?'
	), Matrix AS (
		SELECT class2 = 'aero_side'		  , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Flute'					UNION ALL
		SELECT class2 = 'aero_side'		  , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Piccolo'				UNION ALL  
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'B-FlatTrumpet'		UNION ALL 
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'CTrumpet'				UNION ALL
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'DTrumpet'				UNION ALL
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Tuba'					UNION ALL 
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'FrenchHorn'			UNION ALL 
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'TenorTrombone'		UNION ALL 
		SELECT class2 = 'aero_single-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'BassSaxophone'		UNION ALL 
		SELECT class2 = 'aero_single-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'TenorSaxophone'		UNION ALL 
		SELECT class2 = 'aero_single-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'BaritoneSaxophone'	UNION ALL  
		SELECT class2 = 'aero_single-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'AltoSaxophone'		UNION ALL
		SELECT class2 = 'aero_single-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'SopranoSaxophone'	UNION ALL
		SELECT class2 = 'aero_single-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'B-flatclarinet'		UNION ALL 
		SELECT class2 = 'aero_double-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Oboe'					UNION ALL
		SELECT class2 = 'aero_double-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'EnglishHorn'			UNION ALL  
		SELECT class2 = 'aero_double-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Bassoon'				UNION ALL 
		SELECT class2 = 'aero_free-reed'	  , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Accordian'				UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'Piano'					UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'SynthBass'				UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'Marimba'				UNION ALL -- 0 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'Vibraphone'			UNION ALL -- 0
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'DoubleBass'			UNION ALL 
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'ElectricGuitar'		UNION ALL -- 0
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'AcousticBass'			UNION ALL -- 0  
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'Cello'					UNION ALL 
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'Viola'					UNION ALL 
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'Violin'
	), LazyUnion AS (
		SELECT * FROM mix1_instrument mi LEFT JOIN Matrix M ON M.label = mi.mix1_instrument
		UNION ALL
		SELECT * FROM mix2_instrument mi LEFT JOIN Matrix M ON M.label = mi.mix2_instrument
	)
	SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
			,MFCC1, MFCC2
			,ZeroCrossings, SpecCentroid, SpecSpread, Rolloff
			,bandsCoefSum
			,prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
			,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk19
			,playmethod, class1, class2
			,label = CASE WHEN label = 'AcousticBass' THEN 'DoubleBass'
							  WHEN label = 'Marimba' AND LogAttackTime BETWEEN -0.65555745	AND -0.70990645 THEN 'Piano'
							  WHEN label = 'Marimba' AND LogAttackTime NOT BETWEEN -0.65555745 AND -0.70990645 THEN 'Vibraphone'
							  WHEN label = 'Marimba' AND LogAttackTime NOT BETWEEN -0.65555745 AND -0.70990645 THEN 'Vibraphone'
							  WHEN label = 'ElectricGuitar' AND temporalCentroid BETWEEN 0.9820233 AND 1.46164 THEN 'Cello'
							  WHEN label = 'ElectricGuitar' AND temporalCentroid > 1.46164 THEN 'Viola'
							  WHEN label = 'ElectricGuitar' AND temporalCentroid < 0.9820233 THEN 'Violin'
							  WHEN label LIKE '%trombone%' AND HamoPK27 = '?' THEN 'Frenchhorn'
							  ELSE label END 
	INTO #TempTrain 
	FROM LazyUnion


	SELECT DISTINCT label 
	INTO #DistinctLabels 
	FROM #TempTrain
	
	SELECT AttributeNumber = C.colorder
			,AttributeName = C.name
			,Exponential = 0  
			,ClassAverage = NULL
			,MissingCount = NULL
			,ValidCount = NULL
			,RowNumber = NULL
	INTO #DecisionTable
	FROM tempdb.sys.objects O JOIN tempdb.dbo.syscolumns C ON C.id = O.object_id
	WHERE O.name LIKE '#TempTrain%'

		
	DECLARE @ROWCOUNT INT = @@ROWCOUNT
	DECLARE @i INT = 0

	WHILE @i < @ROWCOUNT
	BEGIN
		SET @i = @i + 1
		
		SELECT @AttributeName = AttributeName
		FROM #DecisionTable TT
		WHERE AttributeNumber = @i AND AttributeName <> 'label'

		-- Input missing and valid totals for each attribute and insert attributes from test into temp test
		SELECT @SQL = '
			WITH MissingAndValid AS (
				SELECT MissingCount = SUM(IIF(CAST(' + @AttributeName + ' AS VARCHAR(50)) = ''?'', 1, 0))
						,ValidCount = SUM(IIF(CAST(' + @AttributeName + ' AS VARCHAR(50)) <> ''?'', 1, 0))
						,AttributeName = ''' + @AttributeName + '''
				FROM #TempTrain T 
			)
			UPDATE TT
			SET MissingCount = MAV.MissingCount
				,ValidCount = MAV.ValidCount
			FROM #DecisionTable TT JOIN MissingAndValid MAV ON MAV.AttributeName = TT.AttributeName

		'

		EXEC(@SQL)

		/* Missing attribute replacement makes it worse 			
		IF EXISTS( SELECT TOP 1 * FROM #DecisionTable WHERE AttributeName = @AttributeName AND MissingCount > 0)
		BEGIN
			
			SELECT @SQL = '
				
				DECLARE @AttributeName VARCHAR(50) = ''' + @AttributeName + '''

				;WITH AverageValue AS ( 
					SELECT ' + @AttributeName + ' = SUM(CAST(' + @AttributeName + ' AS DECIMAL(18,6)))/ COUNT(label)
							,label 
					FROM #TempTrain 
					WHERE ' + @AttributeName + ' <> ''?''
					GROUP BY label
				)
				UPDATE TT 
				SET ' + @AttributeName + ' = AV.' + @AttributeName + '
				FROM #TempTrain TT JOIN AverageValue AV ON AV.label = TT.label
				WHERE TT.' + @AttributeName + ' = ''?''
			'

			EXEC(@SQL)
		END
		*/
	END 


	SELECT * 
	INTO dbo.train_preprocess
	FROM #TempTrain

	SELECT * FROM train_preprocess


	/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Test Set~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	
	--~~~~~~~~~~~~~Standardise test data to preprocessed training data 
	SELECT t.* 
	INTO #ProcessTest 
	FROM test t 
	ORDER BY t.Id ASC 

	-- replace bandsCoefSum with actual value 
	UPDATE PT
	SET bandsCoefSum = bandsCoef1+bandsCoef2+bandsCoef3+bandsCoef4+bandsCoef5+bandsCoef6+bandsCoef7+bandsCoef8+bandsCoef9+bandsCoef10+bandsCoef11+bandsCoef12+bandsCoef13+bandsCoef14+bandsCoef15+bandsCoef16+bandsCoef17+bandsCoef18+bandsCoef19+bandsCoef20+bandsCoef21+bandsCoef22+bandsCoef23+bandsCoef24+bandsCoef25+bandsCoef26+bandsCoef27+bandsCoef28+bandsCoef29+bandsCoef30+bandsCoef31+bandsCoef32+bandsCoef33+bandsCoefSum
	FROM #ProcessTest PT

	--~~~~~~~~~~~~~Test attribute selection 
	SELECT TOP 0 * 
	INTO #TempTest
	FROM #TempTrain

	ALTER TABLE #TempTest ADD CONSTRAINT DF_target DEFAULT N'?' FOR label
	ALTER TABLE #TempTest ADD Id INT NULL -- Not actual identity type

	SELECT @ROWCOUNT = COUNT(*) FROM #DecisionTable

	--reset varaibles
	SELECT @i = 0
	
	WHILE @i < @ROWCOUNT -1 -- skip label loop or will duplicate last attribute 
	BEGIN
		SET @i = @i + 1

		SELECT @AttributeName = AttributeName
		FROM #DecisionTable TT
		WHERE AttributeNumber = @i AND AttributeName <> 'label'

		SELECT @ColumnSelect = @ColumnSelect + ', ' + @AttributeName + CHAR(10)

	END 
	
	SELECT @ColumnSelect = RIGHT(@ColumnSelect, LEN(@ColumnSelect) - 2) -- remove starting comma 

	SELECT @SQL = '
		INSERT INTO #TempTest (' + @ColumnSelect + ', Id) 
		SELECT ' + @ColumnSelect + ', PT.Id
		FROM #ProcessTest PT
		ORDER BY Id ASC  
	
		SELECT ' + @ColumnSelect + ', label
		FROM #TempTest
		ORDER BY Id 
	'

	EXEC(@SQL)

END
GO