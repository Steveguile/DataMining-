
GO
BEGIN

	WITH mix1_instrument AS (
		SELECT temporalCentroid
			,LogSpecCentroid
			,LogSpecSpread
			,MFCC1
			,MFCC2
			,MFCC3
			,MFCC4
			,MFCC5
			,MFCC6
			,MFCC7
			,MFCC8
			,MFCC9
			,MFCC10
			,MFCC11
			,MFCC12
			,MFCC13
			,Energy
			,ZeroCrossings
			,SpecCentroid
			,SpecSpread
			,Rolloff
			,Flux
			,bandsCoef1
			,bandsCoef2
			,bandsCoef3
			,bandsCoef4
			,bandsCoef5
			,bandsCoef6
			,bandsCoef7
			,bandsCoef8
			,bandsCoef9
			,bandsCoef10
			,bandsCoef11
			,bandsCoef12
			,bandsCoef13
			,bandsCoef14
			,bandsCoef15
			,bandsCoef16
			,bandsCoef17
			,bandsCoef18
			,bandsCoef19
			,bandsCoef20
			,bandsCoef21
			,bandsCoef22
			,bandsCoef23
			,bandsCoef24
			,bandsCoef25
			,bandsCoef26
			,bandsCoef27
			,bandsCoef28
			,bandsCoef29
			,bandsCoef30
			,bandsCoef31
			,bandsCoef32
			,bandsCoef33
			,bandsCoefSum
			,prj1
			,prj2
			,prj3
			,prj4
			,prj5
			,prj6
			,prj7
			,prj8
			,prj9
			,prj10
			,prj11
			,prj12
			,prj13
			,prj14
			,prj15
			,prj16
			,prj17
			,prj18
			,prj19
			,prj20
			,prj21
			,prj22
			,prj23
			,prj24
			,prj25
			,prj26
			,prj27
			,prj28
			,prj29
			,prj30
			,prj31
			,prj32
			,prj33
			,prjmin
			,prjmax
			,prjsum
			,prjdis
			,prjstd
			,LogAttackTime
			,HamoPk1
			,HamoPk2
			,HamoPk3
			,HamoPk4
			,HamoPk5
			,HamoPk6
			,HamoPk7
			,HamoPk8
			,HamoPk9
			,HamoPk10
			,HamoPk11
			,HamoPk12
			,HamoPk13
			,HamoPk14
			,HamoPk15
			,HamoPk16
			,HamoPk17
			,HamoPk18
			,HamoPk19
			,HamoPk20
			,HamoPk21
			,HamoPk22
			,HamoPk23
			,HamoPk24
			,HamoPk25
			,HamoPk26
			,HamoPk27
			,HamoPk28
			,mix1_instrument
		FROM train t
	), mix2_instrument AS (
		SELECT temporalCentroid
			,LogSpecCentroid
			,LogSpecSpread
			,MFCC1
			,MFCC2
			,MFCC3
			,MFCC4
			,MFCC5
			,MFCC6
			,MFCC7
			,MFCC8
			,MFCC9
			,MFCC10
			,MFCC11
			,MFCC12
			,MFCC13
			,Energy
			,ZeroCrossings
			,SpecCentroid
			,SpecSpread
			,Rolloff
			,Flux
			,bandsCoef1
			,bandsCoef2
			,bandsCoef3
			,bandsCoef4
			,bandsCoef5
			,bandsCoef6
			,bandsCoef7
			,bandsCoef8
			,bandsCoef9
			,bandsCoef10
			,bandsCoef11
			,bandsCoef12
			,bandsCoef13
			,bandsCoef14
			,bandsCoef15
			,bandsCoef16
			,bandsCoef17
			,bandsCoef18
			,bandsCoef19
			,bandsCoef20
			,bandsCoef21
			,bandsCoef22
			,bandsCoef23
			,bandsCoef24
			,bandsCoef25
			,bandsCoef26
			,bandsCoef27
			,bandsCoef28
			,bandsCoef29
			,bandsCoef30
			,bandsCoef31
			,bandsCoef32
			,bandsCoef33
			,bandsCoefSum
			,prj1
			,prj2
			,prj3
			,prj4
			,prj5
			,prj6
			,prj7
			,prj8
			,prj9
			,prj10
			,prj11
			,prj12
			,prj13
			,prj14
			,prj15
			,prj16
			,prj17
			,prj18
			,prj19
			,prj20
			,prj21
			,prj22
			,prj23
			,prj24
			,prj25
			,prj26
			,prj27
			,prj28
			,prj29
			,prj30
			,prj31
			,prj32
			,prj33
			,prjmin
			,prjmax
			,prjsum
			,prjdis
			,prjstd
			,LogAttackTime
			,HamoPk1
			,HamoPk2
			,HamoPk3
			,HamoPk4
			,HamoPk5
			,HamoPk6
			,HamoPk7
			,HamoPk8
			,HamoPk9
			,HamoPk10
			,HamoPk11
			,HamoPk12
			,HamoPk13
			,HamoPk14
			,HamoPk15
			,HamoPk16
			,HamoPk17
			,HamoPk18
			,HamoPk19
			,HamoPk20
			,HamoPk21
			,HamoPk22
			,HamoPk23
			,HamoPk24
			,HamoPk25
			,HamoPk26
			,HamoPk27
			,HamoPk28
			,mix2_instrument
		FROM train t
		WHERE t.mix2_instrument <> '?'
	)
	SELECT * 
	FROM mix1_instrument
	UNION ALL 
	SELECT * 
	FROM mix2_instrument
	
END
GO