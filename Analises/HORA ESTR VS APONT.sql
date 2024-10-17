--OPs QUE TIVERAM APONTAMENTOS EM JULHO/2024 -----------------------------------------------------------------------------------------------------

SELECT *
	FROM 
		SH6010
	WHERE 
		H6_DTAPONT BETWEEN '20240701' AND '20240801'
		AND H6_OP <>''




--(DAS OPs APONT. EM JUL/24) SOMA DAS HORAS APONTADAS PELA PRODU��O + QUANTIDADE PRODUZIDA POR OPERA��O + QUANTIDADE PREVISTA---------------------------------------------




SELECT 
	  H6_OP 
	, C2_QUANT AS QNT_ORIGINAL
	, H6_PRODUTO
	, H6_OPERAC
	, SUM(H6_QTDPROD) AS QNT_PRODUZIDA
	, CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) / 60 AS VARCHAR) + ':' +
        RIGHT('0' + CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) % 60 AS VARCHAR), 2) AS HORAS_APONTADAS

	FROM 
		SH6010	
		INNER JOIN SC2010 ON H6_OP = C2_OP 

	WHERE 
		H6_DTAPONT BETWEEN '20240701' AND '20240801'
		AND H6_OP <>''
		AND SH6010.D_E_L_E_T_ <>'*'

	GROUP BY 
		  H6_OP
		, C2_QUANT
		, H6_PRODUTO
		, H6_OPERAC




-- (DAS OPs APONT. EM JUL/24) FOI INCLUIDO A TAB G2(OPERA��ES) E CALCULADO O TEMPO PADR�O POR PE�A, PARA SER USADO PARA CAL. O TEMPO DOS APONTAMENTOS-------------- 


DECLARE @PROD VARCHAR (10)
SET @PROD = '0'

SELECT 
	DISTINCT(H6_PRODUTO)
	, G2_OPERAC
	, SUM(H6_QTDPROD)
	FROM(
		SELECT 
			--H6_OP
			 H6_PRODUTO
			, H6_OPERAC
			, G2_LOTEPAD
			, H6_QTDPROD
			, G2_TEMPAD
			, G2_TEMPAD / G2_LOTEPAD AS TEMPO_POR_PECA 

			FROM 
				SH6010
				LEFT JOIN SG2010 ON H6_PRODUTO + H6_OPERAC = G2_PRODUTO + G2_OPERAC

			WHERE 
				H6_DTAPONT BETWEEN '20240701' AND '20240801'
				--AND H6_OP <>''
				AND SG2010.D_E_L_E_T_ <>'*'
				AND SH6010.D_E_L_E_T_ <>'*'
				--AND H6_PRODUTO = @PROD
				)A
		LEFT JOIN SG2010 ON A.H6_PRODUTO = G2_PRODUTO
		GROUP BY --H6_OP
			H6_PRODUTO	
			, G2_OPERAC
			--, G2_LOTEPAD
			--, G2_TEMPAD;      
		

SELECT *
	FROM SG2010
	WHERE SG2010.D_E_L_E_T_ <> '*'


-- FORAM UNIDAS AS �LTIMAS DUAS CONSULTAS, COM AS INFORMA��ES DAS PE�AS PRODUZIDA + O TEMPO PADR�O POR PE�A, PODEMOS CALCULAR O TEMPO PREVISTO E COMPARAR COM O TEMPO APONTADO -----




SELECT 
	H6_OP
	--, C2_QUANT AS QNT_ORIGINAL
	, H6_PRODUTO
	, H6_OPERAC
	, SUM(H6_QTDPROD) AS QNT_PRODUZIDA
	, CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) / 60 AS VARCHAR) + ':' +
        RIGHT('0' + CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) % 60 AS VARCHAR), 2) AS HORAS_APONTADAS
	--, G2_LOTEPAD
	--, G2_TEMPAD
	, G2_TEMPAD / G2_LOTEPAD AS TEMPO_POR_PECA 
	, G2_MAOOBRA

	, (G2_TEMPAD / G2_LOTEPAD) * SUM(H6_QTDPROD) AS TEMP_TOTAL_PREVISTO

	, CAST(FLOOR((G2_TEMPAD / G2_LOTEPAD) * SUM(H6_QTDPROD)) AS VARCHAR(10)) + ':' +
		RIGHT('0' + CAST(
		CAST(FLOOR(((G2_TEMPAD / G2_LOTEPAD) * SUM(H6_QTDPROD) * 60))AS INT) % 60 AS VARCHAR(2)), 2) AS TEMP_SIS
	, B1_GRUPO

	FROM 
		SH6010	
		--INNER JOIN SC2010 ON H6_OP = C2_OP
		INNER JOIN SG2010 ON H6_PRODUTO + H6_OPERAC = G2_PRODUTO + G2_OPERAC and SG2010.D_E_L_E_T_ <> '' AND SG2010.G2_FILIAL = '01'
		INNER JOIN SB1010 ON H6_PRODUTO = B1_COD AND SB1010.D_E_L_E_T_ <> '*'

	WHERE 
		H6_DTAPONT like '202407%'
		--H6_DTAPONT BETWEEN '20240701' AND '20240801'
		AND H6_OP <>''
		AND SH6010.D_E_L_E_T_ <>'*'

	GROUP BY 
		H6_OP
		--, C2_QUANT
		, H6_PRODUTO
		, H6_OPERAC
		, B1_GRUPO
		, G2_MAOOBRA
		, G2_LOTEPAD
		, G2_TEMPAD;



--------------------------------------------------------------------------------------------------------------



SELECT 
	H6_OP
	--, C2_QUANT AS QNT_ORIGINAL
	, H6_PRODUTO
	, H6_OPERAC
	, SUM(H6_QTDPROD) AS QNT_PRODUZIDA
	, CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) / 60 AS VARCHAR) + ':' +
        RIGHT('0' + CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) % 60 AS VARCHAR), 2) AS HORAS_APONTADAS
	--, G2_LOTEPAD
	--, G2_TEMPAD
	, G2_TEMPAD / G2_LOTEPAD AS TEMPO_POR_PECA 
	, G2_MAOOBRA

	, (G2_TEMPAD / G2_LOTEPAD) * SUM(H6_QTDPROD) AS TEMP_TOTAL_PREVISTO

	, CAST(FLOOR((G2_TEMPAD / G2_LOTEPAD) * SUM(H6_QTDPROD)) AS VARCHAR(10)) + ':' +
		RIGHT('0' + CAST(
		CAST(FLOOR(((G2_TEMPAD / G2_LOTEPAD) * SUM(H6_QTDPROD) * 60))AS INT) % 60 AS VARCHAR(2)), 2) AS TEMP_SIS
	, B1_GRUPO

	FROM 
		SH6010	
		--INNER JOIN SC2010 ON H6_OP = C2_OP
		INNER JOIN SG2010 ON H6_PRODUTO + H6_OPERAC = G2_PRODUTO + G2_OPERAC and SG2010.D_E_L_E_T_ <> '' AND SG2010.G2_FILIAL = '01'
		INNER JOIN SB1010 ON H6_PRODUTO = B1_COD AND SB1010.D_E_L_E_T_ <> '*'

	WHERE 
		H6_DTAPONT like '202407%'
		--H6_DTAPONT BETWEEN '20240701' AND '20240801'
		AND H6_OP <>''
		AND SH6010.D_E_L_E_T_ <>'*'

	GROUP BY 
		H6_OP
		--, C2_QUANT
		, H6_PRODUTO
		, H6_OPERAC
		, B1_GRUPO
		, G2_MAOOBRA
		, G2_LOTEPAD
		, G2_TEMPAD;







