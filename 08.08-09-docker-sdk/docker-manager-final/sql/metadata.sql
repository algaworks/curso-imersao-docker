-- Criar tabela de veículos (PostgreSQL)
CREATE TABLE IF NOT EXISTS veiculos (
    id BIGSERIAL PRIMARY KEY,
    placa VARCHAR(8) NOT NULL UNIQUE,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INTEGER NOT NULL,
    cor VARCHAR(30),
    proprietario VARCHAR(100) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- Inserir dados de exemplo
INSERT INTO veiculos (placa, marca, modelo, ano, cor, proprietario) VALUES
('ABC1234', 'Toyota', 'Corolla', 2022, 'Branco', 'João Silva'),
('DEF5678', 'Honda', 'Civic', 2021, 'Preto', 'Maria Santos'),
('GHI9012', 'Volkswagen', 'Golf', 2020, 'Azul', 'Pedro Oliveira'),
('JKL3456', 'Ford', 'Focus', 2023, 'Vermelho', 'Ana Costa'),
('MNO7890', 'Chevrolet', 'Onix', 2022, 'Prata', 'Carlos Pereira'),
('PQR1357', 'Nissan', 'Sentra', 2021, 'Branco', 'Lucia Ferreira'),
('STU2468', 'Hyundai', 'HB20', 2020, 'Azul', 'Roberto Lima'),
('VWX9753', 'Fiat', 'Argo', 2023, 'Preto', 'Fernanda Rocha'),
('YZA1470', 'Renault', 'Sandero', 2022, 'Cinza', 'Marcos Alves'),
('BCD8520', 'Peugeot', '208', 2021, 'Verde', 'Patricia Souza');

-- Verificar quantos registros foram inseridos
SELECT COUNT(*) as total_veiculos FROM veiculos;

-- Mostrar todos os registros inseridos
SELECT * FROM veiculos ORDER BY data_cadastro;
