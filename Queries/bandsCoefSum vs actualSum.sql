		;WITH Sub AS (
			SELECT realSum = bandsCoef1+bandsCoef2+bandsCoef3+bandsCoef4+bandsCoef5+bandsCoef6+bandsCoef7+bandsCoef8+bandsCoef9+bandsCoef10+bandsCoef11+bandsCoef12+bandsCoef13+bandsCoef14+bandsCoef15+bandsCoef16+bandsCoef17+bandsCoef18+bandsCoef19+bandsCoef20+bandsCoef21+bandsCoef22+bandsCoef23+bandsCoef24+bandsCoef25+bandsCoef26+bandsCoef27+bandsCoef28+bandsCoef29+bandsCoef30+bandsCoef31+bandsCoef32+bandsCoef33+bandsCoefSum
					,bandsCoefSum
					,mix1_instrument
					,mix2_instrument 
			FROM train 
		)
		SELECT realSum, bandsCoefSum, diff = ABS(realSum - bandsCoefSum), mix1_instrument, mix2_instrument
		FROM Sub 
		ORDER BY mix1_instrument