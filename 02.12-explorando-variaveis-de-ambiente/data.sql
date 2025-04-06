## CRIAR o banco postgres
## docker run -d --name database -p 5432:5432 -e POSTGRES_PASSWORD=teste123 -e POSTGRES_DB=docker -e POSTGRES_USER=docker postgres:17

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    cpf VARCHAR(11)
);


INSERT INTO users (nome, idade, cpf) VALUES ('Alice', 30, '12345678901');
INSERT INTO users (nome, idade, cpf) VALUES ('Bob', 25, '09876543210');


SELECT * FROM users;