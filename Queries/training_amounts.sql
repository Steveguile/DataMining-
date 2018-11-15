-- Individual occurences
GO
BEGIN

	WITH IndividualOccurences AS (
		SELECT DISTINCT attribute = 'mix1_instrment', Instrument = mix1_instrument, Count = COUNT(*)
		FROM train
		GROUP BY mix1_instrument
		UNION ALL 
		SELECT DISTINCT attribute = 'mix2_instrment', Instrument = mix2_instrument, Count = COUNT(*)
		FROM train
		GROUP BY mix2_instrument
	)
	SELECT O.Instrument, Occurences = SUM(O.Count)
	FROM IndividualOccurences O
	GROUP BY O.Instrument
	ORDER BY O.Instrument  

	-- mix1 occurs with
	SELECT mix1_instrument, mix2_instrument, Count = COUNT(*)
	FROM train
	GROUP BY mix1_instrument, mix2_instrument
	ORDER BY mix1_instrument

	-- mix2 occurs with
	SELECT mix2_instrument, mix1_instrument, Count = COUNT(*)
	FROM train
	GROUP BY mix1_instrument, mix2_instrument
	ORDER BY mix2_instrument

END
GO

