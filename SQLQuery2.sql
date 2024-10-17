WITH MEDIA_BLOCOS(PRODUTO, OPERAC, TEMPO, PRODUCAO, TEMP_POR_PC) AS (
	SELECT 
		H6_PRODUTO
		, H6_OPERAC
		, SUM((CONVERT(INT, left(h6_tempo,3))+CONVERT(float, right(h6_tempo,2))/60)) TEMPO
		, SUM(H6_QTDPROD) PRODUCAO
		, CASE
			WHEN SUM(H6_QTDPROD) <> 0 THEN SUM((CONVERT(INT, left(h6_tempo,3))+CONVERT(FLOAT, RIGHT(h6_tempo,2))/60))/SUM(H6_QTDPROD)
			ELSE '0'
		END AS TEMPO_POR_PE�A
		FROM SH6010
		WHERE 
			H6_DTAPONT > '20220101'
			AND H6_OPERADO = '000869'
			AND SH6010.D_E_L_E_T_<>'*'
			AND H6_PRODUTO<>''
			AND H6_PRODUTO NOT LIKE('MOD%')
		GROUP BY
			 H6_PRODUTO
			, H6_OPERAC
)
SELECT PRODUTO
	, OPERAC
	, G2_DESCRI
	, B1_DESC
	, ROUND(SUM(TEMP_POR_PC),3) AS TMP_PC
	FROM 
		MEDIA_BLOCOS
		INNER JOIN SB1010 ON PRODUTO = B1_COD
		INNER JOIN SG2010 ON PRODUTO + OPERAC = G2_PRODUTO + G2_OPERAC
	GROUP BY
		PRODUTO
		, B1_DESC
		, OPERAC
		, G2_DESCRI

	SELECT
		H6_PRODUTO
		, H6_OPERAC
		, SUM(A.PRODUCAO) as producao
		, SUM(TEMPO) as tempo
		
	
		FROM(SELECT 
			H6_PRODUTO
			, H6_OPERAC
			, SUM((CONVERT(INT, left(h6_tempo,3))+CONVERT(float, right(h6_tempo,2))/60)) TEMPO
			, SUM(H6_QTDPROD) PRODUCAO
			, CASE
				WHEN SUM(H6_QTDPROD) <> 0 THEN SUM((CONVERT(INT, left(h6_tempo,3))+CONVERT(FLOAT, RIGHT(h6_tempo,2))/60))/SUM(H6_QTDPROD)
				ELSE '0'
			END AS TEMPO_POR_PE�A
			FROM SH6010
			WHERE 
				H6_DTAPONT > '20220101'
				AND H6_OPERADO = '000869'
				AND SH6010.D_E_L_E_T_<>'*'
				AND H6_OP != ''
				--AND H6_MOTIVO <> ''
				AND H6_PRODUTO<>''
				AND H6_PRODUTO NOT LIKE('MOD%')
			GROUP BY
				 H6_PRODUTO
				, H6_OPERAC
			) A
			GROUP BY
				 H6_PRODUTO
				, H6_OPERAC
			
			
SELECT *
	FROM SG2010
	