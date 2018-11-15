GO
BEGIN

	IF OBJECT_ID('tempdb..#InstrumentMatrix') IS NOT NULL
		DROP TABLE #InstrumentMatrix 
	IF OBJECT_ID('tempdb..#Classes') IS NOT NULL
		DROP TABLE #Classes
	IF OBJECT_ID('tempdb..#CurrentInstruments') IS NOT NULL
		DROP TABLE #CurrentInstruments
	
	DECLARE @ROWCOUNT INT 
	DECLARE @SQL VARCHAR(MAX) 
	DECLARE @ClassName VARCHAR(50) 

	;WITH InstrumentMatrix AS (
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
	)
	SELECT * 
	INTO #InstrumentMatrix
	FROM InstrumentMatrix

	SELECT TOP 0 * 
	INTO #CurrentInstruments
	FROM #InstrumentMatrix

	SELECT DISTINCT class2, Id = IDENTITY(INT)
	INTO #Classes 
	FROM #InstrumentMatrix

	SELECT @ROWCOUNT = @@ROWCOUNT 

	DECLARE @i INT = 0 
	WHILE @i < @ROWCOUNT
	BEGIN
		SELECT @i = @i + 1 

		SELECT @ClassName = C.class2 
		FROM #Classes C
		WHERE C.Id = @i 

		SELECT @SQL = '
			INSERT INTO #CurrentInstruments
			SELECT *
			FROM #InstrumentMatrix IM
			WHERE IM.class2 = ''' + @ClassName + '''
		'	
		EXEC(@SQL)
		
		;WITH mix1_instrument AS (
			SELECT temporalCentroid,LogSpecCentroid,LogSpecSpread
					,MFCC1,MFCC2,MFCC3,MFCC4,MFCC5,MFCC6,MFCC7,MFCC8,MFCC9,MFCC10,MFCC11,MFCC12,MFCC13
					,Energy,ZeroCrossings,SpecCentroid,SpecSpread,Rolloff,Flux
					,bandsCoef1,bandsCoef2,bandsCoef3,bandsCoef4,bandsCoef5,bandsCoef6,bandsCoef7,bandsCoef8,bandsCoef9,bandsCoef10,bandsCoef11,bandsCoef12,bandsCoef13,bandsCoef14,bandsCoef15,bandsCoef16,bandsCoef17,bandsCoef18,bandsCoef19,bandsCoef20,bandsCoef21,bandsCoef22,bandsCoef23,bandsCoef24,bandsCoef25,bandsCoef26,bandsCoef27,bandsCoef28,bandsCoef29,bandsCoef30,bandsCoef31,bandsCoef32,bandsCoef33
					,bandsCoefSum
					,prj1,prj2,prj3,prj4,prj5,prj6,prj7,prj8,prj9,prj10,prj11,prj12,prj13,prj14,prj15,prj16,prj17,prj18,prj19,prj20,prj21,prj22,prj23,prj24,prj25,prj26,prj27,prj28,prj29,prj30,prj31,prj32,prj33
					,prjmin,prjmax,prjsum,prjdis,prjstd
					,LogAttackTime
					,HamoPk1,HamoPk2,HamoPk3,HamoPk4,HamoPk5,HamoPk6,HamoPk7,HamoPk8,HamoPk9,HamoPk10,HamoPk11,HamoPk12,HamoPk13,HamoPk14,HamoPk15,HamoPk16,HamoPk17,HamoPk18,HamoPk19,HamoPk20,HamoPk21,HamoPk22,HamoPk23,HamoPk24,HamoPk25,HamoPk26,HamoPk27,HamoPk28
					,mix1_instrument
			FROM train 
		), mix2_instrument AS (
			SELECT temporalCentroid,LogSpecCentroid,LogSpecSpread
					,MFCC1,MFCC2,MFCC3,MFCC4,MFCC5,MFCC6,MFCC7,MFCC8,MFCC9,MFCC10,MFCC11,MFCC12,MFCC13
					,Energy,ZeroCrossings,SpecCentroid,SpecSpread,Rolloff,Flux
					,bandsCoef1,bandsCoef2,bandsCoef3,bandsCoef4,bandsCoef5,bandsCoef6,bandsCoef7,bandsCoef8,bandsCoef9,bandsCoef10,bandsCoef11,bandsCoef12,bandsCoef13,bandsCoef14,bandsCoef15,bandsCoef16,bandsCoef17,bandsCoef18,bandsCoef19,bandsCoef20,bandsCoef21,bandsCoef22,bandsCoef23,bandsCoef24,bandsCoef25,bandsCoef26,bandsCoef27,bandsCoef28,bandsCoef29,bandsCoef30,bandsCoef31,bandsCoef32,bandsCoef33
					,bandsCoefSum
					,prj1,prj2,prj3,prj4,prj5,prj6,prj7,prj8,prj9,prj10,prj11,prj12,prj13,prj14,prj15,prj16,prj17,prj18,prj19,prj20,prj21,prj22,prj23,prj24,prj25,prj26,prj27,prj28,prj29,prj30,prj31,prj32,prj33
					,prjmin,prjmax,prjsum,prjdis,prjstd
					,LogAttackTime
					,HamoPk1,HamoPk2,HamoPk3,HamoPk4,HamoPk5,HamoPk6,HamoPk7,HamoPk8,HamoPk9,HamoPk10,HamoPk11,HamoPk12,HamoPk13,HamoPk14,HamoPk15,HamoPk16,HamoPk17,HamoPk18,HamoPk19,HamoPk20,HamoPk21,HamoPk22,HamoPk23,HamoPk24,HamoPk25,HamoPk26,HamoPk27,HamoPk28
					,mix2_instrument
			FROM train t 
			WHERE t.mix2_instrument <> '?'
		), LazyUnion AS (
			SELECT * FROM mix1_instrument mi LEFT JOIN #InstrumentMatrix M ON M.label = mi.mix1_instrument
			UNION ALL
			SELECT * FROM mix2_instrument mi LEFT JOIN #InstrumentMatrix M ON M.label = mi.mix2_instrument
		)
		SELECT DISTINCT temporalCentroid,LogSpecCentroid,LogSpecSpread
				,MFCC1,MFCC2,MFCC3,MFCC4,MFCC5,MFCC6,MFCC7,MFCC8,MFCC9,MFCC10,MFCC11,MFCC12,MFCC13
				,Energy,ZeroCrossings,SpecCentroid,SpecSpread,Rolloff,CAST(Flux AS VARCHAR(50)) -- wont cast as float in test 
				,bandsCoef1,bandsCoef2,bandsCoef3,bandsCoef4,bandsCoef5,bandsCoef6,bandsCoef7,bandsCoef8,bandsCoef9,bandsCoef10,bandsCoef11,bandsCoef12,bandsCoef13,bandsCoef14,bandsCoef15,bandsCoef16,bandsCoef17,bandsCoef18,bandsCoef19,bandsCoef20,bandsCoef21,bandsCoef22,bandsCoef23,bandsCoef24,bandsCoef25,bandsCoef26,bandsCoef27,bandsCoef28,bandsCoef29,bandsCoef30,bandsCoef31,bandsCoef32,bandsCoef33
				,bandsCoefSum
				,prj1,prj2,prj3,prj4,prj5,prj6,prj7,prj8,prj9,prj10,prj11,prj12,prj13,prj14,prj15,prj16,prj17,prj18,prj19,prj20,prj21,prj22,prj23,prj24,prj25,prj26,prj27,prj28,prj29,prj30,prj31,prj32,prj33
				,prjmin,prjmax,prjsum,prjdis,prjstd
				,LogAttackTime
				,HamoPk1,HamoPk2,HamoPk3,HamoPk4,HamoPk5,HamoPk6,HamoPk7,HamoPk8,HamoPk9,HamoPk10,HamoPk11,HamoPk12,HamoPk13,HamoPk14,HamoPk15,HamoPk16,HamoPk17,HamoPk18,HamoPk19,HamoPk20,HamoPk21,HamoPk22,HamoPk23,HamoPk24,HamoPk25,HamoPk26,HamoPk27,HamoPk28
				,LU.playmethod, LU.class1, LU.class2
				,LU.label
		FROM LazyUnion LU JOIN #CurrentInstruments CU ON CU.class2 = LU.class2
		UNION ALL 
		SELECT DISTINCT temporalCentroid,LogSpecCentroid,LogSpecSpread
				,MFCC1,MFCC2,MFCC3,MFCC4,MFCC5,MFCC6,MFCC7,MFCC8,MFCC9,MFCC10,MFCC11,MFCC12,MFCC13
				,Energy,ZeroCrossings,SpecCentroid,SpecSpread,Rolloff,Flux
				,bandsCoef1,bandsCoef2,bandsCoef3,bandsCoef4,bandsCoef5,bandsCoef6,bandsCoef7,bandsCoef8,bandsCoef9,bandsCoef10,bandsCoef11,bandsCoef12,bandsCoef13,bandsCoef14,bandsCoef15,bandsCoef16,bandsCoef17,bandsCoef18,bandsCoef19,bandsCoef20,bandsCoef21,bandsCoef22,bandsCoef23,bandsCoef24,bandsCoef25,bandsCoef26,bandsCoef27,bandsCoef28,bandsCoef29,bandsCoef30,bandsCoef31,bandsCoef32,bandsCoef33
				,bandsCoefSum
				,prj1,prj2,prj3,prj4,prj5,prj6,prj7,prj8,prj9,prj10,prj11,prj12,prj13,prj14,prj15,prj16,prj17,prj18,prj19,prj20,prj21,prj22,prj23,prj24,prj25,prj26,prj27,prj28,prj29,prj30,prj31,prj32,prj33
				,prjmin,prjmax,prjsum,prjdis,prjstd
				,LogAttackTime
				,HamoPk1,HamoPk2,HamoPk3,HamoPk4,HamoPk5,HamoPk6,HamoPk7,HamoPk8,HamoPk9,HamoPk10,HamoPk11,HamoPk12,HamoPk13,HamoPk14,HamoPk15,HamoPk16,HamoPk17,HamoPk18,HamoPk19,HamoPk20,HamoPk21,HamoPk22,HamoPk23,HamoPk24,HamoPk25,HamoPk26,HamoPk27,HamoPk28
				,t.playmethod, t.class1, t.class2
				,label = '?' 
		FROM test t JOIN #CurrentInstruments CU ON CU.class2 = t.class2  

		TRUNCATE TABLE #CurrentInstruments
	END 

END
GO