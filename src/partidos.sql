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
        AVG(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as txCorRacaPretaParda,
        SUM(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as totalCorRacaPretaParda,
        AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as txCorRacaNaoBranca,
        SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as totalCorRacaNaoBranca,
        COUNT(*) AS totalCandidaturas
    FROM tb_info_completa_cand

    GROUP BY 1, 2, 3
),

tb_all AS(

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
        1.0 * SUM(totalGenFeminino) / SUM(totalCandidaturas) AS txGenFemininoBR,
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
        1.0 * SUM(totalCorRacaPreta) / SUM(totalCandidaturas) as txCorRacaPretaBR,
        SUM(CASE WHEN SG_UF ='AC' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaAC,
        SUM(CASE WHEN SG_UF ='AL' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaAL,
        SUM(CASE WHEN SG_UF ='AM' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaAM,
        SUM(CASE WHEN SG_UF ='AP' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaAP,
        SUM(CASE WHEN SG_UF ='BA' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaBA,
        SUM(CASE WHEN SG_UF ='CE' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaCE,
        SUM(CASE WHEN SG_UF ='ES' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaES,
        SUM(CASE WHEN SG_UF ='GO' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaGO,
        SUM(CASE WHEN SG_UF ='MA' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaMA,
        SUM(CASE WHEN SG_UF ='MG' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaMG,
        SUM(CASE WHEN SG_UF ='MS' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaMS,
        SUM(CASE WHEN SG_UF ='MT' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaMT,
        SUM(CASE WHEN SG_UF ='PA' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaPA,
        SUM(CASE WHEN SG_UF ='PB' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaPB,
        SUM(CASE WHEN SG_UF ='PE' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaPE,
        SUM(CASE WHEN SG_UF ='PI' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaPI,
        SUM(CASE WHEN SG_UF ='PR' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaPR,
        SUM(CASE WHEN SG_UF ='RJ' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaRJ,
        SUM(CASE WHEN SG_UF ='RO' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaRO,
        SUM(CASE WHEN SG_UF ='RS' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaRS,
        SUM(CASE WHEN SG_UF ='SC' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaSC,
        SUM(CASE WHEN SG_UF ='SE' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaSE,
        SUM(CASE WHEN SG_UF ='SP' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaSP,
        SUM(CASE WHEN SG_UF ='TO' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaTO,
        SUM(CASE WHEN SG_UF ='RN' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaRN,
        SUM(CASE WHEN SG_UF ='RR' THEN txCorRacaNaoBranca ELSE 0 END) as txCorRacaNaoBrancaRR,
        1.0 * SUM(totalCorRacaNaoBranca) / SUM(totalCandidaturas) as txCorRacaNaoBrancaBR,
        SUM(CASE WHEN SG_UF ='AC' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaAC,
        SUM(CASE WHEN SG_UF ='AL' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaAL,
        SUM(CASE WHEN SG_UF ='AM' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaAM,
        SUM(CASE WHEN SG_UF ='AP' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaAP,
        SUM(CASE WHEN SG_UF ='BA' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaBA,
        SUM(CASE WHEN SG_UF ='CE' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaCE,
        SUM(CASE WHEN SG_UF ='ES' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaES,
        SUM(CASE WHEN SG_UF ='GO' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaGO,
        SUM(CASE WHEN SG_UF ='MA' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaMA,
        SUM(CASE WHEN SG_UF ='MG' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaMG,
        SUM(CASE WHEN SG_UF ='MS' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaMS,
        SUM(CASE WHEN SG_UF ='MT' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaMT,
        SUM(CASE WHEN SG_UF ='PA' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaPA,
        SUM(CASE WHEN SG_UF ='PB' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaPB,
        SUM(CASE WHEN SG_UF ='PE' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaPE,
        SUM(CASE WHEN SG_UF ='PI' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaPI,
        SUM(CASE WHEN SG_UF ='PR' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaPR,
        SUM(CASE WHEN SG_UF ='RJ' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaRJ,
        SUM(CASE WHEN SG_UF ='RO' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaRO,
        SUM(CASE WHEN SG_UF ='RS' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaRS,
        SUM(CASE WHEN SG_UF ='SC' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaSC,
        SUM(CASE WHEN SG_UF ='SE' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaSE,
        SUM(CASE WHEN SG_UF ='SP' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaSP,
        SUM(CASE WHEN SG_UF ='TO' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaTO,
        SUM(CASE WHEN SG_UF ='RN' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaRN,
        SUM(CASE WHEN SG_UF ='RR' THEN txCorRacaPretaParda ELSE 0 END) as txCorRacaPretaPardaRR,
        1.0 * SUM(totalCorRacaPretaParda) / SUM(totalCandidaturas) as txCorRacaPretaPardaBR,
        SUM(totalGenFeminino) AS totalGenFeminino,
        SUM(totalCorRacaPreta) AS totalCorRacaPreta,
        SUM(totalCorRacaNaoBranca) AS totalCorRacaNaoBranca,
        SUM(totalCorRacaPretaParda) AS totalCorRacaPretaParda,
        SUM(totalCandidaturas) AS totalCandidaturas
    FROM tb_group_uf

    GROUP BY 1, 2
)

SELECT * FROM tb_all
