-- =========================
-- SCHEMA
-- =========================
DROP SCHEMA IF EXISTS aviacao CASCADE;
CREATE SCHEMA IF NOT EXISTS aviacao;

SET search_path TO aviacao;
-- =========================
-- PASSAGEIRO
-- =========================
CREATE TABLE passageiro (
    id_passageiro SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    dt_nascimento DATE NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(150) NOT NULL,
    passaporte VARCHAR(50)
);

-- =========================
-- AEROPORTO
-- =========================
CREATE TABLE aeroporto (
    id_aeroporto SERIAL PRIMARY KEY,
    cod_aeroporto VARCHAR(10) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL
);

-- =========================
-- ROTA
-- =========================
CREATE TABLE rota (
    id_rota SERIAL PRIMARY KEY,
    desc_rota VARCHAR(200) NOT NULL,
    id_aeroporto_origem INT NOT NULL,
    id_aeroporto_destino INT NOT NULL,
    km_distancia INT NOT NULL CHECK (km_distancia > 0),
    FOREIGN KEY (id_aeroporto_origem) REFERENCES aeroporto(id_aeroporto),
    FOREIGN KEY (id_aeroporto_destino) REFERENCES aeroporto(id_aeroporto)
);

-- =========================
-- AERONAVE
-- =========================
CREATE TABLE aeronave (
    id_aeronave SERIAL PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    prefixo VARCHAR(20) NOT NULL UNIQUE,
    dt_fabricacao DATE NOT NULL,
    fabricante VARCHAR(100) NOT NULL,
    capacidade_total INT NOT NULL CHECK (capacidade_total > 0),
    capacidade_economica INT NOT NULL,
    capacidade_executiva INT NOT NULL
);

-- =========================
-- TRIPULACAO
-- =========================
CREATE TABLE tripulacao (
    id_tripulante SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    horas_trabalhadas INT NOT NULL DEFAULT 0 CHECK (horas_trabalhadas >= 0)
);

-- =========================
-- CERTIFICACAO
-- =========================
CREATE TABLE certificacao (
    id_certificacao SERIAL PRIMARY KEY,
    id_tripulante INT NOT NULL,
    id_aeronave INT NOT NULL,
    data_certificacao DATE NOT NULL,
    data_validade DATE NOT NULL,
    FOREIGN KEY (id_tripulante) REFERENCES tripulacao(id_tripulante),
    FOREIGN KEY (id_aeronave) REFERENCES aeronave(id_aeronave)
);

-- =========================
-- CLASSE TARIFARIA
-- =========================
CREATE TABLE classe_tarifaria (
    id_classe SERIAL PRIMARY KEY,
    nome_classe VARCHAR(50) NOT NULL UNIQUE
);

-- =========================
-- REGRA PRECO
-- =========================
CREATE TABLE regra_preco (
    id_regra SERIAL PRIMARY KEY,
    id_rota INT NOT NULL,
    id_classe INT NOT NULL,
    dias_antecedencia INT NOT NULL CHECK (dias_antecedencia >= 0),
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    classe_tarifaria VARCHAR(50), -- (ideal remover futuramente)
    FOREIGN KEY (id_rota) REFERENCES rota(id_rota),
    FOREIGN KEY (id_classe) REFERENCES classe_tarifaria(id_classe)
);

-- =========================
-- RESERVA
-- =========================
CREATE TABLE reserva (
    id_reserva SERIAL PRIMARY KEY,
    id_regra INT NOT NULL,
    status_pgto VARCHAR(50) NOT NULL,
    preco_pago DECIMAL(10,2) NOT NULL CHECK (preco_pago > 0),
    forma_pgto VARCHAR(50) NOT NULL,
    dt_reserva TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_regra) REFERENCES regra_preco(id_regra)
);

-- =========================
-- RESERVA_PASSAGEIRO
-- =========================
CREATE TABLE reserva_passageiro (
    id_passageiro_reserva SERIAL PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_passageiro INT NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_passageiro) REFERENCES passageiro(id_passageiro),
    UNIQUE (id_reserva, id_passageiro)
);

-- =========================
-- PROGRAMA FIDELIDADE
-- =========================
CREATE TABLE programa_fidelidade (
    id_fidelidade SERIAL PRIMARY KEY,
    id_passageiro INT NOT NULL UNIQUE,
    numero_cartao VARCHAR(50) NOT NULL UNIQUE,
    saldo_milhas INT NOT NULL DEFAULT 0 CHECK (saldo_milhas >= 0),
    categoria VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_passageiro) REFERENCES passageiro(id_passageiro)
);

-- =========================
-- VOOS
-- =========================
CREATE TABLE voos (
    id_voo SERIAL PRIMARY KEY,
    id_aeronave INT NOT NULL,
    id_rota INT NOT NULL,
    id_tripulante INT NOT NULL,
    cod_voo VARCHAR(20) NOT NULL,
    dt_voo DATE NOT NULL,
    hr_partida TIME NOT NULL,
    hr_chegada TIME NOT NULL,
    FOREIGN KEY (id_aeronave) REFERENCES aeronave(id_aeronave),
    FOREIGN KEY (id_rota) REFERENCES rota(id_rota),
    FOREIGN KEY (id_tripulante) REFERENCES tripulacao(id_tripulante)
);

-- =========================
-- ASSENTO
-- =========================
CREATE TABLE assento (
    id_assento SERIAL PRIMARY KEY,
    id_aeronave INT NOT NULL,
    numero_assento VARCHAR(10) NOT NULL,
    classe_assento VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_aeronave) REFERENCES aeronave(id_aeronave),
    UNIQUE (id_aeronave, numero_assento)
);

-- =========================
-- TRECHO_RESERVA
-- =========================
CREATE TABLE trecho_reserva (
    id_trecho_reserva SERIAL PRIMARY KEY,
    id_reserva INT NOT NULL,
    id_voo INT NOT NULL,
    id_passageiro_reserva INT NOT NULL,
    id_assento INT NOT NULL,
    desc_trecho VARCHAR(200),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (id_voo) REFERENCES voos(id_voo),
    FOREIGN KEY (id_passageiro_reserva) REFERENCES reserva_passageiro(id_passageiro_reserva),
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento),
    UNIQUE (id_voo, id_assento)
);

-- =========================
-- HISTORICO MILHAS
-- =========================
CREATE TABLE historico_milhas (
    id_historico SERIAL PRIMARY KEY,
    id_fidelidade INT NOT NULL,
    id_trecho_reserva INT NOT NULL,
    data_lancamento DATE NOT NULL DEFAULT CURRENT_DATE,
    quantidade_milhas INT NOT NULL CHECK (quantidade_milhas > 0),
    tipo_operacao VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_fidelidade) REFERENCES programa_fidelidade(id_fidelidade),
    FOREIGN KEY (id_trecho_reserva) REFERENCES trecho_reserva(id_trecho_reserva)
);