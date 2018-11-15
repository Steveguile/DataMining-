	;WITH mix1_instrument AS (
		SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff
				,bandsCoefSum
				,prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk19 
				,mix1_instrument
		FROM train 
	), mix2_instrument AS (
		SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff
				,bandsCoefSum
				,prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk19
				,mix2_instrument
		FROM train t 
		WHERE t.mix2_instrument <> '?'
	), Matrix AS (
		SELECT class2 = 'aero_side'		  , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Flute'					UNION ALL
		SELECT class2 = 'aero_side'		  , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Piccolo'				UNION ALL  
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'B-FlatTrumpet'		UNION ALL 
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'CTrumpet'				UNION ALL
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'DTrumpet'				UNION ALL
		SELECT class2 = 'aero_lip-vibrated', class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'EnglishHorn'			UNION ALL 
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
		SELECT class2 = 'aero_double-reed' , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Bassoon'				UNION ALL 
		SELECT class2 = 'aero_free-reed'	  , class1 = 'aerophone'  , playmethod = 'blown'	  , label = 'Accordian'				UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'Piano'					UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'SynthBass'				UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'Marimba'				UNION ALL 
		SELECT class2 = 'chrd_simple'		  , class1 = 'chordophone', playmethod = 'struck_Hrm', label = 'Vibraphone'			UNION ALL 
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'DoubleBass'			UNION ALL 
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'ElectricGuitar'		UNION ALL 
		SELECT class2 = 'chrd_composite'	  , class1 = 'chordophone', playmethod = 'string'	  , label = 'AcousticBass'			UNION ALL 
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
			,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff
			,bandsCoefSum
			,prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
			,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk19
			,playmethod, class1, class2
			,label = CASE WHEN label = 'ElectricGuitar' AND HamoPk9 <> '?' THEN 'Violin' --subject to change, based on confusion matrix incorrect classifications
							  WHEN label = 'ElectricGuitar' AND HamoPk8 <> '?' AND HamoPk9 = '?' THEN 'Viola'  
							  WHEN label = 'ElectricGuitar' AND HamoPk4 <> '?' THEN 'Violin' 
							  WHEN label = 'Marimba' AND HamoPk9 <> '?' THEN 'Vibraphone' --subject to change, based on confusion matrix incorrect classifications
							  WHEN label = 'Marimba' AND HamoPk4 <> '?' THEN 'Piano' 
							  ELSE label END 
	FROM LazyUnion

