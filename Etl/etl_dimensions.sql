-- =========================================
-- ETL DIMENSIONS - DW
-- Origem: aviacao
-- Destino: dw
-- =========================================

-- =========================================
-- 0. DUMMY ROWS (Tratamento de nulos)
-- =========================================

-- DIM_DATA
INSERT INTO dw.dim_data (data_sk, data, ano, mes, dia, dia_semana)
VALUES (-1, '1900-01-01', 1900, 1, 1, 'Nao Informado')
ON CONFLICT (data_sk) DO NOTHING;

-- DIM_PASSAGEIRO
INSERT INTO dw.dim_passageiro (
    passageiro_sk,
    id_passageiro,
    nome,
    cpf,
    categoria_fidelidade,
    data_inicio,
    data_fim,
    flag_ativo
)
VALUES (
    -1,
    -1,
    'Nao Informado',
    '00000000000',
    'Nao Informado',
    '1900-01-01',
    NULL,
    TRUE
)
ON CONFLICT (passageiro_sk) DO NOTHING;

-- DIM_VOO
INSERT INTO dw.dim_voo (
    voo_sk,
    cod_voo,
    modelo_aeronave,
    fabricante
)
VALUES (
    -1,
    'NA',
    'Nao Informado',
    'Nao Informado'
)
ON CONFLICT (voo_sk) DO NOTHING;

-- DIM_AEROPORTO
INSERT INTO dw.dim_aeroporto (
    aeroporto_sk,
    nome,
    cidade,
    estado,
    pais
)
VALUES (
    -1,
    'Nao Informado',
    'Nao Informado',
    'Nao Informado',
    'Nao Informado'
)
ON CONFLICT (aeroporto_sk) DO NOTHING;

-- DIM_CLASSE
INSERT INTO dw.dim_classe (
    classe_sk,
    nome_classe
)
VALUES (
    -1,
    'Nao Informado'
)
ON CONFLICT (classe_sk) DO NOTHING;


-- =========================================
-- 1. DIM_DATA (SCD Tipo 0)
-- Carga estática de datas
-- =========================================
INSERT INTO dw.dim_data (
    data,
    ano,
    mes,
    dia,
    dia_semana
)
SELECT
    d::date,
    EXTRACT(YEAR FROM d),
    EXTRACT(MONTH FROM d),
    EXTRACT(DAY FROM d),
    TO_CHAR(d, 'TMDay')
FROM generate_series(
    '2020-01-01'::date,
    '2030-12-31'::date,
    interval '1 day'
) d
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_data dd
    WHERE dd.data = d::date
);


-- =========================================
-- 2. DIM_AEROPORTO (SCD Tipo 1)
-- =========================================

-- Inserir novos
INSERT INTO dw.dim_aeroporto (
    nome,
    cidade,
    estado,
    pais
)
SELECT
    a.nome,
    a.cidade,
    a.estado,
    a.pais
FROM aviacao.aeroporto a
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_aeroporto da
    WHERE da.nome = a.nome
);

-- Atualizar existentes
UPDATE dw.dim_aeroporto da
SET
    cidade = a.cidade,
    estado = a.estado,
    pais = a.pais
FROM aviacao.aeroporto a
WHERE da.nome = a.nome;


-- =========================================
-- 3. DIM_CLASSE (SCD Tipo 1)
-- =========================================
INSERT INTO dw.dim_classe (
    nome_classe
)
SELECT
    c.nome_classe
FROM aviacao.classe_tarifaria c
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_classe dc
    WHERE dc.nome_classe = c.nome_classe
);


-- =========================================
-- 4. DIM_VOO (SCD Tipo 1)
-- =========================================

-- Inserir novos
INSERT INTO dw.dim_voo (
    cod_voo,
    modelo_aeronave,
    fabricante
)
SELECT DISTINCT
    v.cod_voo,
    a.modelo,
    a.fabricante
FROM aviacao.voos v
JOIN aviacao.aeronave a
    ON v.id_aeronave = a.id_aeronave
WHERE NOT EXISTS (
    SELECT 1
    FROM dw.dim_voo dv
    WHERE dv.cod_voo = v.cod_voo
);

-- Atualizar existentes
UPDATE dw.dim_voo dv
SET
    modelo_aeronave = a.modelo,
    fabricante = a.fabricante
FROM aviacao.voos v
JOIN aviacao.aeronave a
    ON v.id_aeronave = a.id_aeronave
WHERE dv.cod_voo = v.cod_voo;


-- =========================================
-- 5. DIM_PASSAGEIRO (SCD Tipo 2)
-- =========================================

-- 5.1 Fechar versão antiga se categoria mudou
UPDATE dw.dim_passageiro d
SET
    data_fim = CURRENT_DATE,
    flag_ativo = FALSE
FROM aviacao.programa_fidelidade pf
WHERE d.id_passageiro = pf.id_passageiro
  AND d.flag_ativo = TRUE
  AND COALESCE(d.categoria_fidelidade, '') <> COALESCE(pf.categoria, '');

-- 5.2 Inserir novos passageiros ou nova versão
INSERT INTO dw.dim_passageiro (
    id_passageiro,
    nome,
    cpf,
    categoria_fidelidade,
    data_inicio,
    data_fim,
    flag_ativo
)
SELECT
    p.id_passageiro,
    p.nome,
    p.cpf,
    pf.categoria,

    -- carga histórica inicial correta
    CASE
        WHEN NOT EXISTS (
            SELECT 1
            FROM dw.dim_passageiro d2
            WHERE d2.id_passageiro = p.id_passageiro
        )
        THEN DATE '1900-01-01'
        ELSE CURRENT_DATE
    END AS data_inicio,

    NULL,
    TRUE

FROM aviacao.passageiro p

LEFT JOIN aviacao.programa_fidelidade pf
    ON p.id_passageiro = pf.id_passageiro

LEFT JOIN dw.dim_passageiro d
    ON p.id_passageiro = d.id_passageiro
   AND d.flag_ativo = TRUE

WHERE d.id_passageiro IS NULL
   OR COALESCE(d.categoria_fidelidade, '') <> COALESCE(pf.categoria, '');