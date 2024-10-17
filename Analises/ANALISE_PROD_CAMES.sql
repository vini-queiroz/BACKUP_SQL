-- Query produção de cames por periodo;
-- Tabelas: D3 - Mov. Internas, Z5 - Operadores e B1 - Descrição Genérica.
SELECT D3_TM, 
	D3_COD, 
	B1_DESC, 
	D3_UM, 
	D3_QUANT, 
	H6_OPERADO, 
	Z5_NOME, 
	D3_CF,
	D3_OP, 
	D3_DOC, 
	D3_EMISSAO, 
	B1_GRUPO, 
	D3_CC, 
	D3_TIPO, 
	D3_USUARIO
	FROM SD3010 
	INNER JOIN SB1010 ON B1_COD = D3_COD and SB1010.D_E_L_E_T_<>'*'
	LEFT JOIN SH6010 ON H6_IDENT = D3_IDENT and SH6010.D_E_L_E_T_<>'*'
	INNER JOIN SZ5010 ON Z5_COD = H6_OPERADO
	WHERE D3_EMISSAO like '202409%' and --BETWEEN '20240101' AND '20240425' AND
		D3_CF = 'PR0' AND
		B1_GRUPO LIKE '021N';

--------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM SD3010 WHERE D3_EMISSAO BETWEEN '20240430' AND '20240430' and D3_CF = 'PR0';

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Soma quantidade de cames entrada por mês

SELECT SUM (D1_QUANT) AS TOTAL FROM SD1010 WHERE D1_TES = '158' AND D1_FORNECE = '000984'  and SD1010.D_E_L_E_T_ <> '*'

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Consulta para ver a produção de (CAMES ACABADOS) aglutinada por periodo.

	SELECT 
	YEAR(D3_EMISSAO) AS ANO,
	MONTH(D3_EMISSAO) AS MES,
	DAY(D3_EMISSAO)AS DIA,
	B1_GRUPO as grupo,
	sum(D3_QUANT) as prod_diaria
FROM 
	SD3010 
INNER JOIN 
	SB1010
ON
	B1_COD = D3_COD 
WHERE 
	D3_EMISSAO >'20240101'  -- BETWEEN '20240501' AND '20240531' AND
	AND D3_CF = 'PR0' 
	AND B1_GRUPO = '021N'
GROUP BY
	YEAR(D3_EMISSAO),
	MONTH(D3_EMISSAO),
	DAY(D3_EMISSAO),
	B1_GRUPO
order by YEAR(D3_EMISSAO) DESC, MONTH(D3_EMISSAO) DESC, DAY(D3_EMISSAO) DESC

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Consulta produção de cames (SEMI-ACABADOS) por periodo;
-- Tabelas: D3 - Mov. Internas, Z5 - Operadores e B1 - Descrição Genérica.

SELECT 
	D3_TM, D3_COD, 
	B1_DESC, D3_UM, 
	D3_QUANT, H6_OPERADO, 
	Z5_NOME, D3_CF,
	D3_OP, D3_DOC, 
	D3_EMISSAO, B1_GRUPO, 
	D3_CC, D3_TIPO, 
	D3_USUARIO
FROM 
	SD3010 
INNER JOIN 
	SB1010
ON
	B1_COD = D3_COD 
LEFT JOIN 
	SH6010
ON	
	H6_IDENT = D3_IDENT
	INNER JOIN
	SZ5010
ON
	Z5_COD = H6_OPERADO
WHERE 
	D3_EMISSAO BETWEEN '20230101' AND '20240430' AND
	D3_CF = 'PR0' AND
	B1_GRUPO ='021'; 

--------------------------------------------------------------------------------------------------------------------------------------------------
--Movimentos de entrada de beneficiamentos vindos da Villares(Tabela: D1 - NF's de entrada), agrupados por dia, mês e ano.

SELECT 
	--YEAR(D1_EMISSAO) AS ANO,
	MONTH(D1_EMISSAO) AS MES,
	D1_COD,
	--DAY(D1_EMISSAO) AS DIA,
	SUM(D1_QUANT) AS TOTAL_PECAS
FROM SD1010 WHERE D1_FORNECE = '000984' AND D1_TES LIKE '158' and D1_EMISSAO like '2024%'
GROUP BY 
	--YEAR(D1_EMISSAO),
	MONTH(D1_EMISSAO),
	D1_COD
	--DAY(D1_EMISSAO);

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Cames na fase L que vão para tratamento. Está correto? sequencia correta -> L -> Z -> T -> N?

SELECT D1_COD, 
	B1_DESC, 
	G1_COD,
	sum(D1_QUANT) as Total_peças, 
	D1_TES, 
	B1_GRUPO, 
	D1_CC,
	D1_LOCAL 
	FROM SD1010 INNER JOIN SB1010 ON D1_COD = B1_COD 
		INNER JOIN SG1010 ON G1_COMP = D1_COD
	WHERE D1_FORNECE = '000984' AND 
		D1_TES = '158' AND 
		D1_COD LIKE '%L' AND
		G1_COD LIKE '%T'
	group by D1_COD,
		B1_DESC,
		G1_COD,
		D1_TES, 
		B1_GRUPO, 
		D1_CC,
		D1_LOCAL 


SELECT 
	MONTH(D3_EMISSAO) AS MES,
	B1_GRUPO as grupo,
	sum(D3_QUANT) as prod_diaria
FROM 
	SD3010 
INNER JOIN 
	SB1010
ON
	B1_COD = D3_COD 
WHERE 
	D3_EMISSAO /*='20240430' AND --*/ BETWEEN '20240101' AND '20241231' AND
	D3_CF = 'PR0' AND
	B1_GRUPO = '021N'
GROUP BY
	MONTH(D3_EMISSAO),
	B1_GRUPO
order by MONTH(D3_EMISSAO)


