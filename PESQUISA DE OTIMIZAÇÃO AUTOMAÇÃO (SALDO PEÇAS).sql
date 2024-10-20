WITH EMP_01 AS (
SELECT D4_COD
	, D4_LOCAL
	, D4_OP
	,	D4_QUANT
	, B2_QATU
	FROM 
		SD4010 
		INNER JOIN SB2010 ON D4_COD = B2_COD AND  SB2010.D_E_L_E_T_<>'*'
	WHERE 
		SD4010.D_E_L_E_T_<>'*' 
		AND D4_OP LIKE 'A00ZYS%' 
		AND D4_QTDEORI = D4_QUANT 
		AND D4_QUANT != 0 
		AND D4_FILIAL = '01'
		AND B2_FILIAL = '01'
		AND D4_COD NOT LIKE 'MOD%'
		AND B2_LOCAL = '01'
		AND D4_LOCAL = '01'
),
EMP_77 AS (
SELECT D4_COD
	, D4_LOCAL
	, D4_OP
	,	D4_QUANT
	, SUM(D4_QUANT) OVER(PARTITION BY D4_COD ORDER BY D4_OP desc) AS SOMA_ACUM
	, B2_QATU
	
	FROM 
		SD4010 
		INNER JOIN SB2010 ON D4_COD = B2_COD 
			AND D4_LOCAL = B2_LOCAL	
			AND  SB2010.D_E_L_E_T_<>'*'
			AND B2_FILIAL = '01'
			AND B2_LOCAL = '77'

	WHERE 
		SD4010.D_E_L_E_T_<>'*' 
		AND D4_OP LIKE 'A00ZYS%' 
		AND D4_QTDEORI = D4_QUANT 
		AND D4_QUANT != 0 
		AND D4_FILIAL = '01'
		AND D4_COD NOT LIKE 'MOD%'
)

SELECT*
	FROM
	(
	SELECT *, 
		CASE 
			WHEN SOMA_ACUM < B2_QATU THEN 'NAO'
		ELSE 'SIM' END AS FALTA_SALDO

		FROM EMP_77) A

		WHERE FALTA_SALDO = 'SIM'

		ORDER BY
			D4_OP








-- QUARY QUE RETORNA TODAS AS OPS DISPONÍVEIS PARA APONTAMENTO---------------------------------------------------

WITH APONTAMENTO AS (

	SELECT
		
		D4_COD
		, D4_LOCAL
		, D4_OP
		,	D4_QUANT
		--, B2_QATU
		, CASE 
			WHEN D4_LOCAL = '01' THEN B2_QATU  --AND B2_LOCAL = '01'
			WHEN D4_LOCAL = '77' THEN B2_QATU  --AND B2_LOCAL = '77'
			END AS SALDOS
		--, CASE 
			--WHEN D4_QUANT <= B2_QATU THEN 'NAO'
			--ELSE 'SIM' END AS FALTA_SALDO

		FROM SD4010 
		INNER JOIN SB2010 
			ON D4_COD = B2_COD 
			AND D4_LOCAL = B2_LOCAL
			AND  SB2010.D_E_L_E_T_<>'*'
			AND B2_FILIAL = '01'
			AND (B2_LOCAL = '01' OR B2_LOCAL= '77')

		WHERE
			SD4010.D_E_L_E_T_<>'*' 
			AND (D4_OP LIKE 'A01184%') 
				--OR D4_OP LIKE 'A0117501216  %')
			AND D4_QTDEORI = D4_QUANT 
			AND D4_QUANT != 0 
			AND D4_FILIAL = '01'
			AND D4_COD NOT LIKE 'MOD%'
			)	
	SELECT DISTINCT D4_OP
		FROM APONTAMENTO
		WHERE D4_OP NOT IN (
			SELECT D4_OP
			FROM APONTAMENTO
			WHERE D4_QUANT > SALDOS
		)order by D4_OP desc;
















		




