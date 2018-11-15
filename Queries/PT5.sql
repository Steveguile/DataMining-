GO
BEGIN

	;WITH mix1_instrument AS (
		SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2, MFCC3, MFCC4, MFCC5, MFCC6, MFCC7, MFCC8, MFCC9, MFCC10, MFCC11, MFCC12, MFCC13
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff, Flux
				,bandsCoef1, bandsCoef2, bandsCoef3, bandsCoef4, bandsCoef5, bandsCoef6, bandsCoef7, bandsCoef8, bandsCoef9, bandsCoef10, bandsCoef11, bandsCoef12, bandsCoef13, bandsCoef14, bandsCoef15, bandsCoef16, bandsCoef17, bandsCoef18, bandsCoef19, bandsCoef20, bandsCoef21, bandsCoef22, bandsCoef23, bandsCoef24, bandsCoef25, bandsCoef26, bandsCoef27, bandsCoef28, bandsCoef29, bandsCoef30, bandsCoef31, bandsCoef32, bandsCoef33, bandsCoefSum
				,prj1, prj2, prj3, prj4, prj5, prj6, prj7, prj8, prj9, prj10, prj11, prj12, prj13, prj14, prj15, prj16, prj17, prj18, prj19, prj20, prj21, prj22, prj23, prj24, prj25, prj26, prj27, prj28, prj29, prj30, prj31, prj32, prj33, prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk18, HamoPk19, HamoPk20, HamoPk21, HamoPk22, HamoPk23, HamoPk24, HamoPk25, HamoPk26, HamoPk27, HamoPk28 
				,mix1_instrument
		FROM train 
	), mix2_instrument AS (
		SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2, MFCC3, MFCC4, MFCC5, MFCC6, MFCC7, MFCC8, MFCC9, MFCC10, MFCC11, MFCC12, MFCC13
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff, Flux
				,bandsCoef1, bandsCoef2, bandsCoef3, bandsCoef4, bandsCoef5, bandsCoef6, bandsCoef7, bandsCoef8, bandsCoef9, bandsCoef10, bandsCoef11, bandsCoef12, bandsCoef13, bandsCoef14, bandsCoef15, bandsCoef16, bandsCoef17, bandsCoef18, bandsCoef19, bandsCoef20, bandsCoef21, bandsCoef22, bandsCoef23, bandsCoef24, bandsCoef25, bandsCoef26, bandsCoef27, bandsCoef28, bandsCoef29, bandsCoef30, bandsCoef31, bandsCoef32, bandsCoef33, bandsCoefSum
				,prj1, prj2, prj3, prj4, prj5, prj6, prj7, prj8, prj9, prj10, prj11, prj12, prj13, prj14, prj15, prj16, prj17, prj18, prj19, prj20, prj21, prj22, prj23, prj24, prj25, prj26, prj27, prj28, prj29, prj30, prj31, prj32, prj33, prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk18, HamoPk19, HamoPk20, HamoPk21, HamoPk22, HamoPk23, HamoPk24, HamoPk25, HamoPk26, HamoPk27, HamoPk28 
				,mix2_instrument
		FROM train t 
		WHERE t.mix2_instrument <> '?'
	), Matrix AS (
		SELECT class2 = 'aero_side'			, label = 'Flute'					UNION ALL
		SELECT class2 = 'aero_side'			, label = 'Piccolo'				UNION ALL  
		SELECT class2 = 'aero_lip-vibrated'	, label = 'B-FlatTrumpet'		UNION ALL 
		SELECT class2 = 'aero_lip-vibrated'	, label = 'CTrumpet'				UNION ALL
		SELECT class2 = 'aero_lip-vibrated'	, label = 'DTrumpet'				UNION ALL
		SELECT class2 = 'aero_lip-vibrated'	, label = 'EnglishHorn'			UNION ALL 
		SELECT class2 = 'aero_lip-vibrated'	, label = 'Tuba'					UNION ALL 
		SELECT class2 = 'aero_lip-vibrated'	, label = 'FrenchHorn'			UNION ALL 
		SELECT class2 = 'aero_lip-vibrated'	, label = 'TenorTrombone'		UNION ALL 
		SELECT class2 = 'aero_single-reed'	, label = 'BassSaxophone'		UNION ALL 
		SELECT class2 = 'aero_single-reed'	, label = 'TenorSaxophone'		UNION ALL 
		SELECT class2 = 'aero_single-reed'	, label = 'BaritoneSaxophone'	UNION ALL  
		SELECT class2 = 'aero_single-reed'	, label = 'AltoSaxophone'		UNION ALL
		SELECT class2 = 'aero_single-reed'	, label = 'SopranoSaxophone'	UNION ALL
		SELECT class2 = 'aero_single-reed'	, label = 'B-flatclarinet'		UNION ALL 
		SELECT class2 = 'aero_double-reed'	, label = 'Oboe'					UNION ALL 
		SELECT class2 = 'aero_double-reed'	, label = 'Bassoon'				UNION ALL 
		SELECT class2 = 'aero_free-reed'		, label = 'Accordian'			UNION ALL 
		SELECT class2 = 'chrd_simple'			, label = 'Piano'					UNION ALL 
		SELECT class2 = 'chrd_simple'			, label = 'SynthBass'			UNION ALL 
		SELECT class2 = 'chrd_simple'			, label = 'Marimba'				UNION ALL 
		SELECT class2 = 'chrd_simple'			, label = 'Vibraphone'			UNION ALL 
		SELECT class2 = 'chrd_composite'		, label = 'DoubleBass'			UNION ALL 
		SELECT class2 = 'chrd_composite'		, label = 'ElectricGuitar'		UNION ALL 
		SELECT class2 = 'chrd_composite'		, label = 'AcousticBass'		UNION ALL 
		SELECT class2 = 'chrd_composite'		, label = 'Cello'					UNION ALL 
		SELECT class2 = 'chrd_composite'		, label = 'Viola'					UNION ALL 
		SELECT class2 = 'chrd_composite'		, label = 'Violin'
	), LazyUnion AS (
		SELECT * FROM mix1_instrument mi LEFT JOIN Matrix M ON M.label = mi.mix1_instrument
		UNION ALL
		SELECT * FROM mix2_instrument mi LEFT JOIN Matrix M ON M.label = mi.mix2_instrument
	)
	SELECT temporalCentroid, LogSpecCentroid, LogSpecSpread
				,MFCC1, MFCC2, MFCC3, MFCC4, MFCC5, MFCC6, MFCC7, MFCC8, MFCC9, MFCC10, MFCC11, MFCC12, MFCC13
				,Energy, ZeroCrossings, SpecCentroid, SpecSpread, Rolloff, Flux
				,bandsCoef1, bandsCoef2, bandsCoef3, bandsCoef4, bandsCoef5, bandsCoef6, bandsCoef7, bandsCoef8, bandsCoef9, bandsCoef10, bandsCoef11, bandsCoef12, bandsCoef13, bandsCoef14, bandsCoef15, bandsCoef16, bandsCoef17, bandsCoef18, bandsCoef19, bandsCoef20, bandsCoef21, bandsCoef22, bandsCoef23, bandsCoef24, bandsCoef25, bandsCoef26, bandsCoef27, bandsCoef28, bandsCoef29, bandsCoef30, bandsCoef31, bandsCoef32, bandsCoef33, bandsCoefSum
				,prj1, prj2, prj3, prj4, prj5, prj6, prj7, prj8, prj9, prj10, prj11, prj12, prj13, prj14, prj15, prj16, prj17, prj18, prj19, prj20, prj21, prj22, prj23, prj24, prj25, prj26, prj27, prj28, prj29, prj30, prj31, prj32, prj33, prjmin, prjmax, prjsum, prjdis, prjstd, LogAttackTime
				,HamoPk1, HamoPk2, HamoPk3, HamoPk4, HamoPk5, HamoPk6, HamoPk7, HamoPk8, HamoPk9, HamoPk10, HamoPk11, HamoPk12, HamoPk13, HamoPk14, HamoPk15, HamoPk16, HamoPk17, HamoPk18, HamoPk19, HamoPk20, HamoPk21, HamoPk22, HamoPk23, HamoPk24, HamoPk25, HamoPk26, HamoPk27, HamoPk28 
				,class2, label
	FROM LazyUnion

END
GO