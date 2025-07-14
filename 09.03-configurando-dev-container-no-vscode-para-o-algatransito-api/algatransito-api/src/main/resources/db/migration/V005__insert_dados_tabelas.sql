INSERT INTO proprietario (nome, email, fone) VALUES 
('Joao Silva', 'joao.silva@email.com', '11999887766');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Maria Santos', 'maria.santos@email.com', '11988776655');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Pedro Oliveira', 'pedro.oliveira@email.com', '11977665544');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Ana Costa', 'ana.costa@email.com', '11966554433');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Carlos Souza', 'carlos.souza@email.com', '11955443322');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Julia Lima', 'julia.lima@email.com', '11944332211');
INSERT INTO proprietario (nome, email, fone) VALUES
('Lucas Ferreira', 'lucas.ferreira@email.com', '11933221100');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Mariana Ribeiro', 'mariana.ribeiro@email.com', '11922110099');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Rafael Almeida', 'rafael.almeida@email.com', '11911009988');
INSERT INTO proprietario (nome, email, fone) VALUES 
('Beatriz Santos', 'beatriz.santos@email.com', '11900998877');


INSERT INTO veiculo (proprietario_id, marca, modelo, placa, status, data_cadastro, data_apreensao) 
VALUES (1, 'Toyota', 'Corolla', 'ABC1D23', 'REGULAR', '2023-01-15 10:00:00', null);

INSERT INTO veiculo (proprietario_id, marca, modelo, placa, status, data_cadastro, data_apreensao) 
VALUES (2, 'Honda', 'Civic', 'XYZ4E56', 'REGULAR', '2023-02-20 14:30:00', null);

INSERT INTO veiculo (proprietario_id, marca, modelo, placa, status, data_cadastro, data_apreensao) 
VALUES (3, 'Volkswagen', 'Golf', 'DEF7G89', 'APREENDIDO', '2023-03-10 09:15:00', '2023-06-15 16:45:00');

INSERT INTO veiculo (proprietario_id, marca, modelo, placa, status, data_cadastro, data_apreensao) 
VALUES (4, 'Ford', 'Focus', 'JKL5M23', 'REGULAR', '2023-04-05 11:20:00', null);

INSERT INTO veiculo (proprietario_id, marca, modelo, placa, status, data_cadastro, data_apreensao) 
VALUES (5, 'Chevrolet', 'Onix', 'MNO6P45', 'REGULAR', '2023-05-12 13:40:00', null);


INSERT INTO autuacao (veiculo_id, descricao, valor_multa, data_ocorrencia)
VALUES (1, 'Excesso de velocidade em via urbana', 293.47, '2023-07-01 14:30:00');

INSERT INTO autuacao (veiculo_id, descricao, valor_multa, data_ocorrencia)
VALUES (2, 'Estacionamento em local proibido', 195.23, '2023-07-02 09:15:00');

INSERT INTO autuacao (veiculo_id, descricao, valor_multa, data_ocorrencia)
VALUES (3, 'Avanco de sinal vermelho', 293.47, '2023-07-03 16:45:00');

INSERT INTO autuacao (veiculo_id, descricao, valor_multa, data_ocorrencia)
VALUES (1, 'Uso do celular durante a conducao', 293.47, '2023-07-04 11:20:00');

INSERT INTO autuacao (veiculo_id, descricao, valor_multa, data_ocorrencia)
VALUES (4, 'Nao uso do cinto de seguranca', 195.23, '2023-07-05 15:10:00');
