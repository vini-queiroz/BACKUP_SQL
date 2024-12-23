SELECT 
	YEAR(H6_DTAPONT) ANO,
	MONTH(H6_DTAPONT) MES,
	H6_OPERADO,
	H6_PRODUTO,
	CASE 
		WHEN H6_OP != '' OR H6_OP= NULL THEN SUM(CONVERT(INT, left(H6_TEMPO,3))+CONVERT(float, right(H6_TEMPO,2))/60) 
		ELSE '0'
	END AS TEMP_PROD,
	CASE
		WHEN H6_OP = '' OR H6_OP != NULL THEN SUM(CONVERT(INT, left(H6_TEMPO,3))+CONVERT(float, right(H6_TEMPO,2))/60)
		ELSE '0'
	END AS TEMP_PARADO
	FROM 
		SH6010
	WHERE
		--H6_OPERADO = 
		--H6_OPERADO IN ('000347'/*ZENOR*/, '054312'/*NANDO*/, '000741'/*VAGNER*/)
		SH6010.D_E_L_E_T_<>'*'
		AND (H6_DTAPONT LIKE '2024%')-- OR H6_DTAPONT LIKE '2023%')
		--AND H6_OP != ''
	GROUP BY 
		YEAR(H6_DTAPONT),
		MONTH(H6_DTAPONT),
		H6_OPERADO,
		H6_OP,
		H6_PRODUTO
	ORDER BY 
		YEAR(H6_DTAPONT),
		MONTH(H6_DTAPONT)



SELECT*
FROM SZ5010
