SELECT SUM(CAST(NULLIF(HamoPk15, '?') AS DECIMAL(18,6))) / COUNT(NULLIF(HamoPk15, '?'))
FROM train 
