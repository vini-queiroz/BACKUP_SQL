-- Apontamentos realizados em 2024 no recurso FD-02

SELECT 
    YEAR(H6_DTPROD) AS ANO, 
    MONTH(H6_DTPROD) AS MES, 
    H6_OPERADO,
    SUM(H6_QTDPROD) AS producao,
    -- Soma os tempos após conversão de VARCHAR no formato 'hhh:mm' para minutos totais
    CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) / 60 AS VARCHAR) + ':' +
        RIGHT('0' + CAST(
        (SUM(
            CAST(SUBSTRING(H6_TEMPO, 1, CHARINDEX(':', H6_TEMPO) - 1) AS INT) * 60 + 
            CAST(SUBSTRING(H6_TEMPO, CHARINDEX(':', H6_TEMPO) + 1, LEN(H6_TEMPO)) AS INT)
        )) % 60 AS VARCHAR), 2) AS total_horas
FROM SH6010
WHERE H6_OPERADO ='000869' and
	H6_DATAINI BETWEEN '20240101' AND '20241001'/*'20240101'*/ and
	SH6010.D_E_L_E_T_ <> '*' AND
	--H6_RECURSO LIKE 'F%'AND 
	H6_TEMPO <> ''AND
	H6_OPERADO <> ''

GROUP BY 
    MONTH(H6_DTPROD),
	YEAR(H6_DTPROD),
    H6_OPERADO;


	/*H6_RECURSO = 'FD-02'
    AND H6_DATAINI BETWEEN '20220101' AND '20250101' AND 
	D_E_L_E_T_ <> '*' AND 
	H6_TEMPO <> '' AND
	H6_OPERADO <>''
	--H6_OP <> ''*/






	SELECT H6_OP, H6_PRODUTO,
	H6_OPERAC, H6_RECURSO,
	H6_QTDPROD, H6_IDENT,
	H6_TEMPO, H6_OPERADO, H6_DTPROD,
	YEAR(H6_DTPROD)AS ANO, MONTH(H6_DTPROD) AS MES, DAY(H6_DTPROD) AS DIA  
FROM SH6010
WHERE H6_OPERADO = '000859'AND
	H6_DATAINI > '20240701' AND
	D_E_L_E_T_ <> '*' AND
	H6_TEMPO <> '' AND
	H6_OP <>''


select*
FROM SH6010
INNER JOIN SB1010 ON H6_PRODUTO = B1_COD
WHERE --H6_OPERADO = '000859'AND
	H6_DATAINI > '20240624' AND
	SH6010.D_E_L_E_T_ <> '*' AND
	H6_TEMPO <> '' AND
	H6_OP <>'' AND
	H6_RECURSO LIKE 'RF%' AND 
	B1_GRUPO = '021' AND 
	H6_OPERADO <> '57091' AND
	H6_OP NOT LIKE '%1'


--------------------------------------------------------------------------------
SELECT 
	YEAR(H6_DATAFIN)AS ANO, 
	MONTH(H6_DATAFIN) AS MES, 
	DAY(H6_DATAFIN) AS DIA,  
	sum(H6_QTDPROD) as prod_diaria
FROM SH6010
INNER JOIN SB1010 ON H6_PRODUTO = B1_COD
WHERE --H6_OPERADO = '000859'AND
	H6_DATAINI > '20240601' AND
	SH6010.D_E_L_E_T_ <> '*' AND
	H6_TEMPO <> '' AND
	H6_OP <>'' AND
	H6_RECURSO LIKE 'RF%' AND 
	B1_GRUPO = '021' AND 
	H6_OPERADO <> '57091' AND
	H6_OP NOT LIKE '%1'
GROUP BY
	YEAR(H6_DATAFIN),
	MONTH(H6_DATAFIN), 
	DAY(H6_DATAFIN)


---------------------------------------------------------------------------------------

-- Todos os produtos e operações apontados por operadores.

SELECT  H6_RECURSO, H6_OPERAC
FROM SH6010
WHERE H6_OPERADO ='000869' and
	H6_DATAINI > '20240101' and
	D_E_L_E_T_ <> '*' --AND
	--H6_RECURSO LIKE 'R%'
group by
	H6_OPERAC,
	H6_RECURSO
order by
	H6_RECURSO

---------------------------------------------------------------------------------------

-- Tabela de produtos e operações dos produtos cadastrados no roteiro do recurso FD-02

SELECT G2_OPERAC, G2_PRODUTO, B1_DESC, 
	G2_DESCRI, G2_LINHAPR, 
	G2_OPE_OBR, B1_TIPO, 
	B1_GRUPO
FROM SG2010 INNER JOIN SB1010
ON G2_PRODUTO = B1_COD
WHERE G2_DESCRI LIKE 'FRESAR%' AND 
	G2_DESCRI LIKE '%DENTES%' AND
	G2_RECURSO = 'FD-02'