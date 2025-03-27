WITH tb_cand AS (    
    SELECT
        SQ_CANDIDATO,
        SG_UF,
        DS_CARGO,
        SG_PARTIDO,
        NM_PARTIDO,
        DT_NASCIMENTO,
        DS_GENERO,
        DS_GRAU_INSTRUCAO,
        DS_ESTADO_CIVIL,
        DS_COR_RACA,
        DS_OCUPACAO
    FROM tb_candidaturas
),

tb_total_bens AS (
    SELECT
        SQ_CANDIDATO,
        SUM(CAST(REPLACE(VR_BEM_CANDIDATO, ',', '.') AS DECIMAL(15,2))) AS total_bens
    FROM tb_bens
    GROUP BY SQ_CANDIDATO
),

tb_info_completa_cand AS (
    SELECT
        t1.*,
        COALESCE(t2.total_bens, 0) AS total_bens
    FROM tb_cand AS t1
    LEFT JOIN tb_total_bens AS t2
    ON t1.SQ_CANDIDATO = t2.SQ_CANDIDATO
),
    
tb_group_uf AS (
    SELECT
        SG_PARTIDO,
        NM_PARTIDO,
        SG_UF,
        AVG(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS txGenFeminino,
        SUM(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS totalGenFeminino,
        AVG(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as txCorRacaPreta,
        SUM(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as totalCorRacaPreta,
        AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as txCorRacaNaoBranca,
        SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as totalCorRacaNaoBranca,
        COUNT(*) AS totalCandidaturas
    FROM tb_info_completa_cand

    GROUP BY 1, 2, 3
)

SELECT

    SG_PARTIDO,
    NM_PARTIDO,
    SUM(CASE WHEN SG_UF ='AC' THEN txGenFeminino ELSE 0 END) AS txGenFemininoAC,
    SUM(CASE WHEN SG_UF ='AL' THEN txGenFeminino ELSE 0 END) AS txGenFemininoAL,
    SUM(CASE WHEN SG_UF ='AM' THEN txGenFeminino ELSE 0 END) AS txGenFemininoAM,
    SUM(CASE WHEN SG_UF ='AP' THEN txGenFeminino ELSE 0 END) AS txGenFemininoAP,
    SUM(CASE WHEN SG_UF ='BA' THEN txGenFeminino ELSE 0 END) AS txGenFemininoBA,
    SUM(CASE WHEN SG_UF ='CE' THEN txGenFeminino ELSE 0 END) AS txGenFemininoCE,
    SUM(CASE WHEN SG_UF ='ES' THEN txGenFeminino ELSE 0 END) AS txGenFemininoES,
    SUM(CASE WHEN SG_UF ='GO' THEN txGenFeminino ELSE 0 END) AS txGenFemininoGO,
    SUM(CASE WHEN SG_UF ='MA' THEN txGenFeminino ELSE 0 END) AS txGenFemininoMA,
    SUM(CASE WHEN SG_UF ='MG' THEN txGenFeminino ELSE 0 END) AS txGenFemininoMG,
    SUM(CASE WHEN SG_UF ='MS' THEN txGenFeminino ELSE 0 END) AS txGenFemininoMS,
    SUM(CASE WHEN SG_UF ='MT' THEN txGenFeminino ELSE 0 END) AS txGenFemininoMT,
    SUM(CASE WHEN SG_UF ='PA' THEN txGenFeminino ELSE 0 END) AS txGenFemininoPA,
    SUM(CASE WHEN SG_UF ='PB' THEN txGenFeminino ELSE 0 END) AS txGenFemininoPB,
    SUM(CASE WHEN SG_UF ='PE' THEN txGenFeminino ELSE 0 END) AS txGenFemininoPE,
    SUM(CASE WHEN SG_UF ='PI' THEN txGenFeminino ELSE 0 END) AS txGenFemininoPI,
    SUM(CASE WHEN SG_UF ='PR' THEN txGenFeminino ELSE 0 END) AS txGenFemininoPR,
    SUM(CASE WHEN SG_UF ='RJ' THEN txGenFeminino ELSE 0 END) AS txGenFemininoRJ,
    SUM(CASE WHEN SG_UF ='RO' THEN txGenFeminino ELSE 0 END) AS txGenFemininoRO,
    SUM(CASE WHEN SG_UF ='RS' THEN txGenFeminino ELSE 0 END) AS txGenFemininoRS,
    SUM(CASE WHEN SG_UF ='SC' THEN txGenFeminino ELSE 0 END) AS txGenFemininoSC,
    SUM(CASE WHEN SG_UF ='SE' THEN txGenFeminino ELSE 0 END) AS txGenFemininoSE,
    SUM(CASE WHEN SG_UF ='SP' THEN txGenFeminino ELSE 0 END) AS txGenFemininoSP,
    SUM(CASE WHEN SG_UF ='TO' THEN txGenFeminino ELSE 0 END) AS txGenFemininoTO,
    SUM(CASE WHEN SG_UF ='RN' THEN txGenFeminino ELSE 0 END) AS txGenFemininoRN,
    SUM(CASE WHEN SG_UF ='RR' THEN txGenFeminino ELSE 0 END) AS txGenFemininoRR,
    1.0 * SUM(totalGenFeminino) / SUM(totalCandidaturas) AS totalGenFemininoBR,
    SUM(CASE WHEN SG_UF ='AC' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaAC,
    SUM(CASE WHEN SG_UF ='AL' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaAL,
    SUM(CASE WHEN SG_UF ='AM' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaAM,
    SUM(CASE WHEN SG_UF ='AP' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaAP,
    SUM(CASE WHEN SG_UF ='BA' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaBA,
    SUM(CASE WHEN SG_UF ='CE' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaCE,
    SUM(CASE WHEN SG_UF ='ES' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaES,
    SUM(CASE WHEN SG_UF ='GO' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaGO,
    SUM(CASE WHEN SG_UF ='MA' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaMA,
    SUM(CASE WHEN SG_UF ='MG' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaMG,
    SUM(CASE WHEN SG_UF ='MS' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaMS,
    SUM(CASE WHEN SG_UF ='MT' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaMT,
    SUM(CASE WHEN SG_UF ='PA' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaPA,
    SUM(CASE WHEN SG_UF ='PB' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaPB,
    SUM(CASE WHEN SG_UF ='PE' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaPE,
    SUM(CASE WHEN SG_UF ='PI' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaPI,
    SUM(CASE WHEN SG_UF ='PR' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaPR,
    SUM(CASE WHEN SG_UF ='RJ' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaRJ,
    SUM(CASE WHEN SG_UF ='RO' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaRO,
    SUM(CASE WHEN SG_UF ='RS' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaRS,
    SUM(CASE WHEN SG_UF ='SC' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaSC,
    SUM(CASE WHEN SG_UF ='SE' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaSE,
    SUM(CASE WHEN SG_UF ='SP' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaSP,
    SUM(CASE WHEN SG_UF ='TO' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaTO,
    SUM(CASE WHEN SG_UF ='RN' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaRN,
    SUM(CASE WHEN SG_UF ='RR' THEN txCorRacaPreta ELSE 0 END) as txCorRacaPretaRR,
    1.0 * SUM(totalCorRacaPreta) / SUM(totalCandidaturas) as totalCorRacaPretaBR
FROM tb_group_uf

GROUP BY 1
