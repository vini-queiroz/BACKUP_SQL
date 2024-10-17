
SELECT C1_NUM, C1_PRODUTO, C1_QUANT, C1_OBS, C1_DESCRI, *
	FROM SC1010
	INNER JOIN SG1010 ON C1_PRODUTO = G1_COMP
	WHERE C1_NUM = '284049'
		AND SG1010.D_E_L_E_T_= ''
	ORDER BY C1_ITEM


SELECT 
	A.G1_COD
	FROM(SELECT 
			C1_NUM, 
			C1_PRODUTO, 
			C1_QUANT, 
			C1_OBS,
			G1_COD,
			G1_COMP
			FROM 
				SC1010
			RIGHT JOIN SG1010 ON C1_PRODUTO = G1_COMP
			WHERE C1_NUM = '284049'
				AND SC1010.D_E_L_E_T_= ''
				AND SG1010.D_E_L_E_T_= '') A

----- FUNCIONANDO (NECESSÁRIO MELHORIAS)-----------------------------------

SELECT G1_COMP,  B2_QATU, G2_OPERAC
	FROM SG1010
	INNER JOIN SB2010 ON G1_COMP = B2_COD
	LEFT JOIN SG2010 ON G1_COMP = G2_PRODUTO AND SG2010.D_E_L_E_T_<>'*'
	WHERE G1_COD IN 
		(SELECT 
			A.G1_COD
			FROM(SELECT 
					C1_NUM, 
					C1_PRODUTO, 
					C1_QUANT, 
					C1_OBS,
					G1_COD,
					G1_COMP
					FROM 
						SC1010
						INNER JOIN SG1010 ON C1_PRODUTO = G1_COMP
					WHERE 
						C1_NUM = '284560' 
						AND SC1010.D_E_L_E_T_= ''
						AND SG1010.D_E_L_E_T_= '') A)
		AND G1_COMP NOT LIKE 'BF%'
		AND SG1010.D_E_L_E_T_ = '' 
		AND B2_LOCAL = '01'
		AND B2_FILIAL = '01'

-------------------------------------------------------------------------------------------