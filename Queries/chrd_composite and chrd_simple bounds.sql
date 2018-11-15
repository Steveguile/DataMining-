-- Piano has a distinct log attack time compared to Vibraphone, give 50% above and below when converting Marimba 
SELECT MaxLogAttackTime = MAX(LogAttackTime)
		,MinLogAttackTime = MIN(LogAttackTime)
		,DiffTime = MAX(LogAttackTime) - MIN(LogAttackTime)
		,FiftyPercent = ((MAX(LogAttackTime) - MIN(LogAttackTime)) / 100) * 50
		,MaxToUse = MAX(LogAttackTime) + (((MAX(LogAttackTime) - MIN(LogAttackTime)) / 100) * 50)
		,MinToUse = MIN(LogAttackTime) - (((MAX(LogAttackTime) - MIN(LogAttackTime)) / 100) * 50)
FROM train
WHERE mix1_instrument = 'Piano' OR mix2_instrument = 'Piano'

-- Convert AcousticBass and Electric guitar to one of Violin, DoubleBass, Cello, Viola based on observations
/* BandsCoef5 and 11 show distinct values for DoubleBass, anything above these values currently labeled as AcousticBass should be DoubleBass
	SELECT bandsCoef5 = MIN(bandsCoef5)
			,bandsCoef11 = MIN(bandsCoef11)
	FROM train 
	WHERE mix1_instrument = 'AcousticBass' OR mix2_instrument = 'AcousticBass'
	In Hindsight, just make AcousticBass = DoubleBass 
*/


--temporalCentroid shows groupings between Cello, Violin, and Viola and can be used to convert ElectricGuitar
SELECT Instrument = CASE WHEN mix1_instrument IN ('Viola', 'Violin', 'Cello') THEN mix1_instrument
								 ELSE mix2_instrument END
		,MinVal = MIN(temporalCentroid)
		,MaxVal = MAX(temporalCentroid)
FROM train 
WHERE (mix1_instrument = 'Viola' OR mix2_instrument = 'Viola')
	OR (mix1_instrument = 'Violin' OR mix2_instrument = 'Violin')
	OR (mix1_instrument = 'Cello' OR mix2_instrument = 'Cello')
GROUP BY CASE WHEN mix1_instrument IN ('Viola', 'Violin', 'Cello') THEN mix1_instrument
				  ELSE mix2_instrument END
ORDER BY MIN(temporalCentroid)

-- Trombone is Frenchhorn as this query gives 6.6454500 and kaggle probe of french horn is 0.06472
SELECT (COUNT(*) / 11000.0) * 100
FROM train 
WHERE mix1_instrument LIKE '%trombone%' OR mix2_instrument LIKE '%trombone%'
  AND HamoPK27 = '?'
