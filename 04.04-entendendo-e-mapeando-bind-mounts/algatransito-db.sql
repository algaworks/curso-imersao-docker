CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO user (name, email, password) 
VALUES 
('John Doe', 'john.doe@example.com', 'hashed_password_1'),
('Jane Smith', 'jane.smith@example.com', 'hashed_password_2'),
('Alice Johnson', 'alice.johnson@example.com', 'hashed_password_3'),
('Bob Brown', 'bob.brown@example.com', 'hashed_password_4'),
('Charlie Davis', 'charlie.davis@example.com', 'hashed_password_5'),
('Diana Evans', 'diana.evans@example.com', 'hashed_password_6');


