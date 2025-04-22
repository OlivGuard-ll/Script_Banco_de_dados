-- NOME DO PROJETO: OlivGuard;

CREATE DATABASE projetoPI;
USE projetoPI;

CREATE TABLE endereco (
    idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    cep CHAR(8) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL
);

CREATE TABLE usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(50) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    senha VARCHAR(20) NOT NULL,
    telefone CHAR(11),
    fkEndereco INT,
    
    CONSTRAINT fk_endereco FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco)
);

CREATE TABLE descSensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(40) NOT NULL,
    dataInstalacao DATETIME,
    localInstalacao VARCHAR(50),
    tipoLeitura VARCHAR(30) NOT NULL,
    numSerie VARCHAR(20) UNIQUE NOT NULL,
    fkUsuario INT,
    
    CONSTRAINT fk_usuario FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario)
);

CREATE TABLE dadosSensor (
    idDados INT AUTO_INCREMENT,
    dado FLOAT,
    statusSensor VARCHAR(15),
    dtDado DATETIME DEFAULT CURRENT_TIMESTAMP,
    fkSensor INT,
    
    CONSTRAINT fk_composta_dadosSensor PRIMARY KEY (idDados, fkSensor),
    CONSTRAINT fk_sensor FOREIGN KEY (fkSensor) REFERENCES descSensor(idSensor)
);


SHOW TABLES;

DESCRIBE endereco;
DESCRIBE usuario;
DESCRIBE descSensor;
DESCRIBE dadosSensor;

INSERT INTO endereco (cep, rua, numero, complemento, bairro, cidade, estado) VALUES
('01001000', 'Rua da Empresa 1', '123', 'Sala 5', 'Centro', 'São Paulo', 'SP'),
('20040030', 'Avenida da Empresa 2', '456', NULL, 'Copacabana', 'Rio de Janeiro', 'RJ');

-- Inserir usuários
INSERT INTO usuario (razaoSocial, cnpj, email, senha, telefone, fkEndereco) VALUES
('Empresa Aqua SP', '12345678000199', 'contato@aquasp.com', 'senha123', '11999999999', 1),
('Empresa RioTech', '98765432000188', 'rio@tecnologia.com', 'rio12345', '21988888888', 2);

-- Inserir sensores
INSERT INTO descSensor (modelo, dataInstalacao, localInstalacao, tipoLeitura, numSerie, fkUsuario) VALUES
('Umidade de Solo Capacitivo', '2024-01-10 10:00:00', 'Setor 1', 'Umidade de solo', 'SX001A', 1),
('Umidade de Solo Capacitivo', '2024-02-15 14:30:00', 'Setor 1', 'Umidade de solo', 'SY002B', 2);

-- Inserir dados de sensores
INSERT INTO dadosSensor (dado, statusSensor, dtDado, fkSensor) VALUES
(34.5, 'Ativo', DEFAULT, 1),
(28.2, 'Ativo', DEFAULT, 1),
(22.7, 'Ativo', DEFAULT, 2),
(40.3, 'Ativo', DEFAULT, 2);
	
    
    SELECT * FROM dadosSensor;
    SELECT * FROM usuario;
    SELECT * FROM descSensor;
    
SELECT u.razaoSocial AS "Razão social", s.modelo AS "Modelo", s.localInstalacao AS "Setor", d.dado AS "Leitura", d.statusSensor AS "Status", d.dtDado AS "Data"
FROM usuario u
JOIN descSensor s ON u.idUsuario = s.fkUsuario
JOIN dadosSensor d ON s.idSensor = d.fkSensor
WHERE u.idUsuario = 2;

-- 1:1
-- Pensando que cada usuário tenha apenas um sensor. Aqui vemos o nome da empresa e o modelo do sensor junto com o número de série.
SELECT u.razaoSocial AS "Razão social", u.email AS "Email", s.modelo AS "Modelo do sensor", 
s.numSerie AS "Número de série"
FROM usuario u
JOIN descSensor s ON u.idUsuario = s.fkUsuario;

-- 1:N
--  Lista todos os sensores de um usuário:
SELECT u.razaoSocial AS "Razão social", s.modelo AS "Modelo do sensor", 
s.localInstalacao AS " Local da instalação", s.dataInstalacao AS "Data da instalação"
FROM usuario u
JOIN descSensor s ON u.idUsuario = s.fkUsuario;


-- Listar todos os dados registrados por um sensor:
SELECT s.numSerie, d.dado, d.dtDado, d.statusSensor
FROM descSensor s
JOIN dadosSensor d ON s.idSensor = d.fkSensor
WHERE s.idSensor = 1;

-- Obter todos os dados com informações completas de sensor e do usuário:
SELECT 
    u.razaoSocial,
    s.modelo,
    s.localInstalacao,
    d.dado,
    d.statusSensor,
    d.dtDado
FROM usuario u
JOIN descSensor s ON u.idUsuario = s.fkUsuario
JOIN dadosSensor d ON s.idSensor = d.fkSensor
WHERE u.idUsuario = 2;

-- Mostrar todos os sensores, mesmo os que ainda não têm dados registrados. LEFT JOIN
SELECT 
    s.numSerie,
    s.localInstalacao,
    d.dado,
    d.dtDado
FROM descSensor s
LEFT JOIN dadosSensor d ON s.idSensor = d.fkSensor;

-- Mostrar os dados ordenados por data (do mais recente ao mais antigo)
SELECT 
    d.dado,
    d.dtDado,
    d.statusSensor
FROM dadosSensor d
ORDER BY d.dtDado DESC;

SELECT * from dadosSensor;
