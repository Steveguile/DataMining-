SELECT LogAttackTime, Rolloff
FROM train 
WHERE mix1_instrument = 'ElectricGuitar'
ORDER BY Rolloff DESC 