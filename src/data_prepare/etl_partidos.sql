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
        COALESCE(t2.total_bens, 0) AS total_bens,
        COALESCE(DATE('now') - DATE(
        SUBSTR(DT_NASCIMENTO, 7, 4) || '-'  ||
        SUBSTR(DT_NASCIMENTO, 4, 2) || '-'  ||
        SUBSTR(DT_NASCIMENTO, 1, 2)
        ),0) AS NR_IDADE
    FROM tb_cand AS t1
    LEFT JOIN tb_total_bens AS t2
    ON t1.SQ_CANDIDATO = t2.SQ_CANDIDATO
),
    
tb_group_uf AS (
    SELECT
        SG_PARTIDO,
        NM_PARTIDO,
        'GERAL' AS DS_CARGO,
        SG_UF,
        AVG(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS txGenFeminino,
        SUM(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS totalGenFeminino,
        AVG(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as txCorRacaPreta,
        SUM(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as totalCorRacaPreta,
        AVG(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as txCorRacaPretaParda,
        SUM(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as totalCorRacaPretaParda,
        AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as txCorRacaNaoBranca,
        SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as totalCorRacaNaoBranca,
        SUM(total_bens) AS totalBens,
        AVG(total_bens) AS avgBens,
        COALESCE(AVG(CASE WHEN total_bens > 1 THEN total_bens END), 0) AS avgBensNotZero,
        1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'CASADO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilCasado,
        1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'SOLTEIRO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSolteiro,
        1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL IN ('DIVORCIADO(A)', 'SEPARADO(A) JUDICIALMENTE') THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSeparadoDivorciado,
        AVG(NR_IDADE) AS avgIdade,
        COUNT(*) AS totalCandidaturas
    FROM tb_info_completa_cand

    GROUP BY 1, 2, 3, 4
),

tb_group_br AS (

    SELECT
        SG_PARTIDO,
        NM_PARTIDO,
        'GERAL' AS DS_CARGO,
        'BR' AS SG_UF,
        AVG(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS txGenFeminino,
        SUM(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS totalGenFeminino,
        AVG(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as txCorRacaPreta,
        SUM(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as totalCorRacaPreta,
        AVG(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as txCorRacaPretaParda,
        SUM(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as totalCorRacaPretaParda,
        AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as txCorRacaNaoBranca,
        SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as totalCorRacaNaoBranca,
        SUM(total_bens) AS totalBens,
        AVG(total_bens) AS avgBens,
        COALESCE(AVG(CASE WHEN total_bens > 1 THEN total_bens END), 0) AS avgBensNotZero,
        1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'CASADO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilCasado,
        1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'SOLTEIRO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSolteiro,
        1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL IN ('DIVORCIADO(A)', 'SEPARADO(A) JUDICIALMENTE') THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSeparadoDivorciado,
        AVG(NR_IDADE) AS avgIdade,
        COUNT(*) AS totalCandidaturas
    FROM tb_info_completa_cand

    GROUP BY 1, 2, 3, 4
),

tb_group_cargo_uf AS (

    SELECT
            SG_PARTIDO,
            NM_PARTIDO,
            DS_CARGO,
            SG_UF,
            AVG(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS txGenFeminino,
            SUM(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS totalGenFeminino,
            AVG(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as txCorRacaPreta,
            SUM(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as totalCorRacaPreta,
            AVG(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as txCorRacaPretaParda,
            SUM(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as totalCorRacaPretaParda,
            AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as txCorRacaNaoBranca,
            SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as totalCorRacaNaoBranca,
            SUM(total_bens) AS totalBens,
            AVG(total_bens) AS avgBens,
            COALESCE(AVG(CASE WHEN total_bens > 1 THEN total_bens END), 0) AS avgBensNotZero,
            1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'CASADO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilCasado,
            1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'SOLTEIRO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSolteiro,
            1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL IN ('DIVORCIADO(A)', 'SEPARADO(A) JUDICIALMENTE') THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSeparadoDivorciado,
            AVG(NR_IDADE) AS avgIdade,
            COUNT(*) AS totalCandidaturas
        FROM tb_info_completa_cand

        GROUP BY 1, 2, 3, 4

),

tb_group_cargo_br AS (

    SELECT
            SG_PARTIDO,
            NM_PARTIDO,
            DS_CARGO,
            'BR' AS SG_UF,
            AVG(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS txGenFeminino,
            SUM(CASE WHEN DS_GENERO = 'FEMININO' THEN 1 ELSE 0 END) AS totalGenFeminino,
            AVG(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as txCorRacaPreta,
            SUM(CASE WHEN DS_COR_RACA = 'PRETA' THEN 1 ELSE 0 END) as totalCorRacaPreta,
            AVG(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as txCorRacaPretaParda,
            SUM(CASE WHEN DS_COR_RACA IN ('PRETA', 'PARDA') THEN 1 ELSE 0 END) as totalCorRacaPretaParda,
            AVG(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as txCorRacaNaoBranca,
            SUM(CASE WHEN DS_COR_RACA <> 'BRANCA' THEN 1 ELSE 0 END) as totalCorRacaNaoBranca,
            SUM(total_bens) AS totalBens,
            AVG(total_bens) AS avgBens,
            COALESCE(AVG(CASE WHEN total_bens > 1 THEN total_bens END), 0) AS avgBensNotZero,
            1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'CASADO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilCasado,
            1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL = 'SOLTEIRO(A)' THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSolteiro,
            1.0 * SUM(CASE WHEN DS_ESTADO_CIVIL IN ('DIVORCIADO(A)', 'SEPARADO(A) JUDICIALMENTE') THEN 1 ELSE 0 END) / COUNT(*) AS txEstadoCivilSeparadoDivorciado,
            AVG(NR_IDADE) AS avgIdade,
            COUNT(*) AS totalCandidaturas
        FROM tb_info_completa_cand

        GROUP BY 1, 2, 3, 4

),

tb_union_all AS (
    SELECT * FROM tb_group_br

    UNION ALL

    SELECT * FROM tb_group_uf

    UNION ALL

    SELECT * FROM tb_group_cargo_br

    UNION ALL

    SELECT * FROM tb_group_cargo_uf
)

SELECT *

FROM tb_union_all



