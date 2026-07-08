-- =========================================
-- SCHEMA DW
-- =========================================
DROP SCHEMA IF EXISTS dw CASCADE;
CREATE SCHEMA dw;

SET search_path TO dw;

-- =========================================
-- DIM_DATA (SCD Tipo 0)
-- =========================================
CREATE TABLE dim_data (
    data_sk SERIAL PRIMARY KEY,
    data DATE NOT NULL UNIQUE,
    ano INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL,
    dia_semana VARCHAR(20) NOT NULL
);

-- =========================================
-- DIM_PASSAGEIRO (SCD Tipo 2)
-- =========================================
CREATE TABLE dim_passageiro (
    passageiro_sk SERIAL PRIMARY KEY,
    id_passageiro INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    categoria_fidelidade VARCHAR(50),

    data_inicio DATE NOT NULL,
    data_fim DATE,
    flag_ativo BOOLEAN NOT NULL
);

-- =========================================
-- DIM_VOO (SCD Tipo 1)
-- =========================================
CREATE TABLE dim_voo (
    voo_sk SERIAL PRIMARY KEY,
    cod_voo VARCHAR(20) NOT NULL,
    modelo_aeronave VARCHAR(100),
    fabricante VARCHAR(100)
);

-- =========================================
-- DIM_AEROPORTO (SCD Tipo 1)
-- =========================================
CREATE TABLE dim_aeroporto (
    aeroporto_sk SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

-- =========================================
-- DIM_CLASSE (SCD Tipo 1)
-- =========================================
CREATE TABLE dim_classe (
    classe_sk SERIAL PRIMARY KEY,
    nome_classe VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================
-- FATO_RESERVA
-- =========================================
CREATE TABLE fato_reserva (
    fato_id SERIAL PRIMARY KEY,

    passageiro_sk INT NOT NULL,
    data_sk INT NOT NULL,
    voo_sk INT NOT NULL,
    aeroporto_origem_sk INT NOT NULL,
    aeroporto_destino_sk INT NOT NULL,
    classe_sk INT NOT NULL,

    valor_pago DECIMAL(10,2) NOT NULL,
    milhas INT NOT NULL,
    quantidade_passageiro INT NOT NULL DEFAULT 1,

    -- FKs
    FOREIGN KEY (passageiro_sk) REFERENCES dim_passageiro(passageiro_sk),
    FOREIGN KEY (data_sk) REFERENCES dim_data(data_sk),
    FOREIGN KEY (voo_sk) REFERENCES dim_voo(voo_sk),
    FOREIGN KEY (aeroporto_origem_sk) REFERENCES dim_aeroporto(aeroporto_sk),
    FOREIGN KEY (aeroporto_destino_sk) REFERENCES dim_aeroporto(aeroporto_sk),
    FOREIGN KEY (classe_sk) REFERENCES dim_classe(classe_sk)
);