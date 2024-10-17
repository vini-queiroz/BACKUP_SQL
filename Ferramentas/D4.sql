SELECT 
	D4_COD AS Produto
	, B1.B1_DESC AS DESCRIÇÃO
	, D4_LOCAL AS Armazem
	, D4_OP AS Ord_Producao
	, D4_OP AS Ord_Producao2
	, D4_DATA AS DT_Empenho
	, D4_QTDEORI AS Qtd_Empenho
	, D4_QUANT AS Sal_Empenho
	, D4_PRODUTO AS Produto_Pai
	, B2.B1_DESC AS DESCRIÇÃO_PAI
	, B1.B1_GRUPO AS Grupo
	FROM 
		SD4010 D 
		INNER JOIN SC2010 ON D4_OP = C2_NUM + C2_ITEM + C2_SEQUEN 
			AND SC2010.D_E_L_E_T_ <> '*'
			AND C2_TPOP = 'F'
		INNER JOIN SB1010 B2 ON D4_PRODUTO = B2.B1_COD
		INNER JOIN SB1010 B1 ON	D4_COD = B1.B1_COD
			AND B1.D_E_L_E_T_ != '*' 
	WHERE 
		D4_QTDEORI = D4_QUANT  
		AND D4_QUANT != 0 
		AND D4_FILIAL = '01' 
		AND D4_COD NOT LIKE '%MOD%' 
		AND D.D_E_L_E_T_ != '*' 
		--AND D4_OP LIKE 'A00ZX%'
		--AND B1.B1_DESC LIKE '%PLATINA%'
		--AND D4_COD = '00416805'

	--ORDER BY 
		--D4_COD

----------------------------------------------------------------------------------------------------------------------------------------
-- Saldos do sistema ARM 77

SELECT 
	  B2_COD
	, B1_DESC
	, B2_QATU
	, B2_LOCAL
	FROM
		SB2010 
		INNER JOIN SB1010 ON B2_COD = B1_COD AND B2_LOCAL = '77' AND SB1010.D_E_L_E_T_ != '*'
	WHERE 
		B2_QATU > 0;

----------------------------------------------------------------------------------------------------------------------------------------
-- Saldos do sistema ARM 01

SELECT 
	B2_COD
	, B1_DESC
	, B2_QATU
	, B2_LOCAL
	, B1_GRUPO
	FROM 
		SB2010
		INNER JOIN SB1010 ON B2_COD = B1_COD AND B2_LOCAL = '01' AND SB1010.D_E_L_E_T_ != '*'
	WHERE 
		B2_QATU > 0 
		

--------------------------------------------------------------------------------------------------------------

select C2_PRODUTO, 
	C2_OBS, 
	SUM(C2_QUANT) AS TOTAL_MAQ 
from SC2010 
where C2_PRODUTO LIKE '00415787' AND 
	D_E_L_E_T_ <>'*' AND 
	C2_DATPRI >'20240201' 
GROUP BY C2_PRODUTO, C2_OBS


SELECT B1_COD, B1_DESC FROM SB1010 WHERE D_E_L_E_T_ <> '*' and B1_DESC like 'bloco%'


