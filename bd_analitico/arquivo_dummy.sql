-- ============================================================
-- 0. REGISTROS DUMMY (SK = -1)
-- ============================================================

INSERT INTO Dim_data (data_sk, data, ano, mes, dia, dia_semana)
SELECT -1, NULL, -1, -1, -1, 'Desconhecido'
WHERE NOT EXISTS (SELECT 1 FROM Dim_data WHERE data_sk = -1);

INSERT INTO Dim_passageiro (
    passageiro_sk, id_passageiro, nome, cpf,
    categoria_fidelidade, data_inicio, data_fim, flag_ativo
)
SELECT -1, -1, 'Não Informado', '000.000.000-00',
       'Desconhecido', '1900-01-01', NULL, FALSE
WHERE NOT EXISTS (SELECT 1 FROM Dim_passageiro WHERE passageiro_sk = -1);

INSERT INTO Dim_voo (
    voo_sk, cod_voo, modelo_aeronave, fabricante,
    aeroporto_origem_sk, aeroporto_destino_sk, classe_sk
)
SELECT -1, 'N/A', 'Não Informado', 'Não Informado', -1, -1, -1
WHERE NOT EXISTS (SELECT 1 FROM Dim_voo WHERE voo_sk = -1);

INSERT INTO Dim_aeroporto (aeroporto_sk, nome, cidade, estado, pais)
SELECT -1, 'Não Informado', 'Não Informado', 'Não Informado', 'Não Informado'
WHERE NOT EXISTS (SELECT 1 FROM Dim_aeroporto WHERE aeroporto_sk = -1);

INSERT INTO Dim_classe (classe_sk, nome_classe)
SELECT -1, 'Não Informado'
WHERE NOT EXISTS (SELECT 1 FROM Dim_classe WHERE classe_sk = -1);
