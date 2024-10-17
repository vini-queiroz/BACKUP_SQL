select	
	B1_DESC
	, *
	from 
		SD3010
		inner join SB1010 on d3_cod = B1_COD
	where 
		D3_TM = '220'
		and D3_USUARIO = 'PCP4'
		and (D3_EMISSAO = '20240807'
				or D3_EMISSAO = '20240809')
	ORDER BY
		D3_DOC


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
	, B1_GRUPO

	FROM 
		SH6010	
		--INNER JOIN SC2010 ON H6_OP = C2_OP
		LEFT JOIN SG2010 ON H6_PRODUTO + H6_OPERAC = G2_PRODUTO + G2_OPERAC
		INNER JOIN SB1010 ON H6_PRODUTO = B1_COD

	WHERE 
		H6_DTAPONT BETWEEN '20240701' AND '20240801'
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



-- APONTAMENTOS PRODU��O

SELECT H6_FILIAL, H6_OP, RTRIM(H6_PRODUTO) PRODUTO,G2_CODIGO, H6_OPERAC, G2_DESCRI, G2_MAOOBRA,

H6_RECURSO, H1_DESCRI, H6_DATAINI, H6_HORAINI, H6_DATAFIN,

H6_HORAFIN, H6_QTDPROD, H6_QTDPERD, H6_PT, H6_DTAPONT, H6_DESDOBR, H6_IDENT, H6_TEMPO,

H6_MOTIVO, CYN_CDSP, H6_OBSERVA, H6_TIPO, H6_OPERADO, Z5_NOME, H6_DTPROD, H6_LOCAL,

RTRIM(B1_DESC) DESC_SB1, RTRIM(B1_GRUPO) GRP_SB1, left(h6_dtprod,6) AnoMes,

B1_SETOR,         B1_X_LOCA,      B1_MSBLQL, RTRIM(B1_GRUPO) GRUPO,

G2_SETUP, G2_LOTEPAD, G2_TEMPAD

FROM SH6010 with (nolock)

left JOIN SH1010 with (nolock) ON H6_RECURSO = H1_CODIGO AND SH1010.D_E_L_E_T_ <> '*' AND H1_FILIAL = '01'

left JOIN SB1010 with (nolock) ON H6_PRODUTO = B1_COD AND SB1010.D_E_L_E_T_ <> '*'

LEFT JOIN SC2010 WITH (NOLOCK) ON H6_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND SC2010.D_E_L_E_T_ <> '*'

left JOIN SZ5010 with (nolock) ON H6_OPERADO = Z5_COD AND SZ5010.D_E_L_E_T_ <> '*' AND Z5_FILIAL = ''

LEFT JOIN SG2010 with (nolock) ON H6_PRODUTO+C2_ROTEIRO = G2_PRODUTO+G2_CODIGO AND H6_OPERAC = G2_OPERAC AND SG2010.D_E_L_E_T_ <> '*' AND SG2010.G2_FILIAL = '01'

LEFT JOIN CYN010 with (nolock) ON H6_MOTIVO = CYN_CDSP AND CYN010.D_E_L_E_T_ <> '*'

WHERE SH6010.D_E_L_E_T_ <> '*'

AND H6_DTAPONT LIKE '202407%'

--AND H6_DTAPONT > '20230500'

--AND H6_OPERADO = '054312'

--AND C2_ROTEIRO = G2_CODIGO

--and h6_motivo <> ''

SELECT * FROM SZ5010