SELECT SUM(IIF(HamoPk15 <> '?', CAST(HamoPk15 AS DECIMAL(18,6)), 0)) / SUM (IIF(HamoPk15 <> '?', 1, 0))
FROM train 