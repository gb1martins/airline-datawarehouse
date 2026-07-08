SET search_path TO aviacao;

INSERT INTO aeroporto (cod_aeroporto, nome, cidade, estado, pais) VALUES
('GRU', 'Aeroporto Internacional de São Paulo', 'São Paulo', 'SP', 'Brasil'),
('GIG', 'Aeroporto Internacional do Rio de Janeiro', 'Rio de Janeiro', 'RJ', 'Brasil'),
('BSB', 'Aeroporto Internacional de Brasília', 'Brasília', 'DF', 'Brasil'),
('CNF', 'Aeroporto de Confins', 'Belo Horizonte', 'MG', 'Brasil');


INSERT INTO rota (desc_rota, id_aeroporto_origem, id_aeroporto_destino, km_distancia) VALUES
('São Paulo → Rio', 1, 2, 430),
('São Paulo → Brasília', 1, 3, 870),
('Rio → Belo Horizonte', 2, 4, 340);


INSERT INTO aeronave (modelo, prefixo, dt_fabricacao, fabricante, capacidade_total, capacidade_economica, capacidade_executiva) VALUES
('A320', 'PR-ABC', '2018-05-10', 'Airbus', 180, 150, 30),
('B737', 'PR-XYZ', '2016-03-15', 'Boeing', 160, 140, 20);

INSERT INTO tripulacao (nome, cargo, horas_trabalhadas) VALUES
('Carlos Silva', 'Piloto', 5000),
('Ana Souza', 'Comissário', 2000),
('João Lima', 'Piloto', 6000),
('Mariana Alves', 'Comissário', 1500);

INSERT INTO certificacao (id_tripulante, id_aeronave, data_certificacao, data_validade) VALUES
(1, 1, '2022-01-01', '2026-01-01'),
(2, 1, '2023-01-01', '2026-01-01'),
(3, 2, '2021-01-01', '2025-01-01'),
(4, 2, '2023-06-01', '2026-06-01');


INSERT INTO classe_tarifaria (nome_classe) VALUES
('Econômica'),
('Executiva');


INSERT INTO regra_preco (id_rota, id_classe, dias_antecedencia, preco, classe_tarifaria) VALUES
(1, 1, 30, 300.00, 'Econômica'),
(1, 2, 30, 800.00, 'Executiva'),
(2, 1, 20, 500.00, 'Econômica'),
(3, 1, 15, 250.00, 'Econômica');


INSERT INTO passageiro (nome, dt_nascimento, cpf, telefone, email, passaporte) VALUES
('Gabriel Martins', '1995-06-15', '123.456.789-00', '11999999999', 'gabriel@email.com', 'AB123456'),
('Lucas Pereira', '1990-03-10', '987.654.321-00', '11988888888', 'lucas@email.com', 'CD987654'),
('Juliana Costa', '1985-11-20', '111.222.333-44', '11977777777', 'juliana@email.com', 'EF456789'),
('Bruno Souza', '2000-01-01', '555.666.777-88', '11966666666', 'bruno@email.com', 'GH123987');


INSERT INTO programa_fidelidade (id_passageiro, numero_cartao, saldo_milhas, categoria) VALUES
(1, 'FID001', 10000, 'Gold'),
(2, 'FID002', 5000, 'Silver'),
(3, 'FID003', 2000, 'Bronze');


INSERT INTO voos (id_aeronave, id_rota, id_tripulante, cod_voo, dt_voo, hr_partida, hr_chegada) VALUES
(1, 1, 1, 'VOO100', '2026-04-01', '08:00', '09:00'),
(1, 2, 2, 'VOO200', '2026-04-02', '10:00', '11:30'),
(2, 3, 3, 'VOO300', '2026-04-03', '14:00', '15:00');


INSERT INTO assento (id_aeronave, numero_assento, classe_assento) VALUES
(1, '12A', 'Econômica'),
(1, '12B', 'Econômica'),
(1, '1A', 'Executiva'),
(2, '10A', 'Econômica'),
(2, '1B', 'Executiva');


INSERT INTO reserva (id_regra, status_pgto, preco_pago, forma_pgto, dt_reserva) VALUES
(1, 'Pago', 300.00, 'Cartão', NOW()),
(2, 'Pago', 800.00, 'Pix', NOW()),
(3, 'Pendente', 500.00, 'Boleto', NOW());


INSERT INTO reserva_passageiro (id_reserva, id_passageiro) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);


INSERT INTO trecho_reserva (id_reserva, id_voo, id_passageiro_reserva, id_assento, desc_trecho) VALUES
(1, 1, 1, 1, 'SP → RJ'),
(1, 1, 2, 2, 'SP → RJ'),
(2, 2, 3, 3, 'SP → BSB'),
(3, 3, 4, 4, 'RJ → BH');


INSERT INTO historico_milhas (id_fidelidade, id_trecho_reserva, data_lancamento, quantidade_milhas, tipo_operacao) VALUES
(1, 1, CURRENT_DATE, 430, 'ACUMULO'),
(2, 2, CURRENT_DATE, 430, 'ACUMULO'),
(3, 3, CURRENT_DATE, 870, 'ACUMULO');