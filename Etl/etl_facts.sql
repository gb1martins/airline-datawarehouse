-- =========================================
-- ETL FATO_RESERVA
-- =========================================

INSERT INTO dw.fato_reserva (
    passageiro_sk,
    data_sk,
    voo_sk,
    aeroporto_origem_sk,
    aeroporto_destino_sk,
    classe_sk,
    valor_pago,
    milhas,
    quantidade_passageiro
)
SELECT
    dp.passageiro_sk,
    dd.data_sk,
    dv.voo_sk,
    dao.aeroporto_sk AS aeroporto_origem_sk,
    dad.aeroporto_sk AS aeroporto_destino_sk,
    dc.classe_sk,

    r.preco_pago AS valor_pago,
    COALESCE(hm.quantidade_milhas, rt.km_distancia) AS milhas,
    1 AS quantidade_passageiro

FROM aviacao.trecho_reserva tr
JOIN aviacao.reserva r
    ON tr.id_reserva = r.id_reserva
JOIN aviacao.reserva_passageiro rp
    ON tr.id_passageiro_reserva = rp.id_passageiro_reserva
JOIN aviacao.passageiro p
    ON rp.id_passageiro = p.id_passageiro
JOIN aviacao.voos v
    ON tr.id_voo = v.id_voo
JOIN aviacao.rota rt
    ON v.id_rota = rt.id_rota
JOIN aviacao.aeroporto ao
    ON rt.id_aeroporto_origem = ao.id_aeroporto
JOIN aviacao.aeroporto ad
    ON rt.id_aeroporto_destino = ad.id_aeroporto
LEFT JOIN aviacao.historico_milhas hm
    ON hm.id_trecho_reserva = tr.id_trecho_reserva
JOIN aviacao.regra_preco rp2
    ON r.id_regra = rp2.id_regra
JOIN aviacao.classe_tarifaria ct
    ON rp2.id_classe = ct.id_classe

-- LOOKUP DAS SKs
JOIN dw.dim_passageiro dp
    ON dp.id_passageiro = p.id_passageiro
   AND v.dt_voo BETWEEN dp.data_inicio AND COALESCE(dp.data_fim, '9999-12-31')

JOIN dw.dim_data dd
    ON dd.data = v.dt_voo

JOIN dw.dim_voo dv
    ON dv.cod_voo = v.cod_voo

JOIN dw.dim_aeroporto dao
    ON dao.nome = ao.nome

JOIN dw.dim_aeroporto dad
    ON dad.nome = ad.nome

JOIN dw.dim_classe dc
    ON dc.nome_classe = ct.nome_classe

WHERE NOT EXISTS (
    SELECT 1
    FROM dw.fato_reserva f
    WHERE f.passageiro_sk = dp.passageiro_sk
      AND f.data_sk = dd.data_sk
      AND f.voo_sk = dv.voo_sk
);