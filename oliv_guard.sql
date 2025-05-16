-- NOME DO PROJETO: OlivGuard
drop database projetopi;
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

CREATE TABLE Empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(50) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    codigo_ativacao VARCHAR(50) UNIQUE NOT NULL,
    fkEndereco INT,
    
    CONSTRAINT fk_endereco FOREIGN KEY (fkEndereco) REFERENCES endereco(idEndereco)
);

CREATE TABLE Usuario(
    idUsuario INT AUTO_INCREMENT,
    nome VARCHAR(20) NOT NULL,
    sobrenome VARCHAR(20) NOT NULL, 
    email VARCHAR(30) UNIQUE NOT NULL,
    senha VARCHAR(20) NOT NULL,
    fkEmpresa INT,
    
    CONSTRAINT fk_CompostaUserEmpresa PRIMARY KEY (idUsuario,fkEmpresa),
    CONSTRAINT fk_empresaUser FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa)
);


CREATE TABLE Sensor (
    idSensor INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(40) NOT NULL,
    dataInstalacao DATETIME,
    localInstalacao VARCHAR(50) NOT NULL,
    tipoLeitura VARCHAR(30) NOT NULL,
    numSerie VARCHAR(20) UNIQUE NOT NULL,
    fkEmpresa INT,
    
    CONSTRAINT fk_empresa FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa)
);


CREATE TABLE Usuario_Sensor (
	idUsuarioSensor INT AUTO_INCREMENT,
    fkUsuario INT,
    fkSensor INT,
    dataAssociacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_usuario_sensor PRIMARY KEY (idUsuarioSensor, fkUsuario, fkSensor),
    CONSTRAINT fk_usuario FOREIGN KEY (fkUsuario) REFERENCES Usuario(idUsuario),
    CONSTRAINT fk_sensor_usuario FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor)
);


CREATE TABLE Leitura (
    idLeitura INT AUTO_INCREMENT,
    leitura FLOAT,
    unidadeDeMedida CHAR(1),
    maximo CHAR (3),
    minimo CHAR (3),
    statusSensor VARCHAR(15),
    dtLeitura DATETIME DEFAULT CURRENT_TIMESTAMP,
    fkSensor INT,
    
    CONSTRAINT fk_composta_LeituraSensor PRIMARY KEY (idLeitura, fkSensor),
    CONSTRAINT fk_sensor FOREIGN KEY (fkSensor) REFERENCES Sensor(idSensor)
);


SHOW TABLES;


DESCRIBE endereco;
DESCRIBE Usuario;
DESCRIBE Sensor;
DESCRIBE Leitura;


INSERT INTO endereco (cep, rua, numero, complemento, bairro, cidade, estado) VALUES
('01001000', 'Rua da Empresa 1', '123', 'Sala 5', 'Centro', 'São Paulo', 'SP'),
('20040030', 'Avenida da Empresa 2', '456', NULL, 'Copacabana', 'Rio de Janeiro', 'RJ');

INSERT INTO Empresa (razaoSocial, cnpj, codigo_ativacao, fkEndereco) VALUES
('Empresa Aqua SP', '12345678000199', 'AQUA123', 1),
('Empresa RioTech', '98765432000188', 'RIOTECH456', 2);

INSERT INTO Usuario (nome, sobrenome, email, senha, fkEmpresa) VALUES
('João', 'Silva', 'joao.silva@aquasp.com', 'senhaJoao', 1),
('Maria', 'Oliveira', 'maria.oliveira@riotech.com', 'senhaMaria', 2);

INSERT INTO Sensor (modelo, dataInstalacao, localInstalacao, tipoLeitura, numSerie, fkEmpresa) VALUES
('Umidade de Solo Capacitivo', '2024-01-10 10:00:00', 'Setor 1', 'Umidade de solo', 'SX001A', 1),
('Umidade de Solo Capacitivo', '2024-02-15 14:30:00', 'Setor 1', 'Umidade de solo', 'SY002B', 2);

INSERT INTO Leitura (leitura, unidadeDeMedida, maximo, minimo, statusSensor, fkSensor) VALUES
(34.5, '%', '80%', '50%', 'Ativo', 1),
(28.2, '%', '80%', '50%', 'Ativo', 1),
(22.7, '%', '80%', '50%', 'Ativo', 2),
(40.3, '%', '80%', '50%', 'Ativo', 2);
	
    SELECT * FROM Leitura;
    SELECT * FROM usuario;
    SELECT * FROM Sensor;
   
   
   
   
   
SELECT e.razaoSocial AS "Razão social", s.modelo AS "Modelo", s.localInstalacao AS "Setor", d.leitura AS "Leitura", d.statusSensor AS "Status", d.dtLeitura AS "Data"
FROM empresa e
JOIN Sensor s ON e.idEmpresa = s.fkEmpresa
JOIN Leitura d ON s.idSensor = d.fkSensor
WHERE e.idEmpresa = 2;





-- 1:1
-- Pensando que cada usuário tenha apenas um sensor. Aqui vemos o nome da empresa e o modelo do sensor junto com o número de série.
SELECT e.razaoSocial AS "Razão social", s.modelo AS "Modelo do sensor", 
s.numSerie AS "Número de série"
FROM empresa e
JOIN Sensor s ON e.idEmpresa = s.fkEmpresa;

-- 1:N
--  Lista todos os sensores de um usuário:
SELECT e.razaoSocial AS "Razão social", s.modelo AS "Modelo do sensor", 
s.localInstalacao AS " Local da instalação", s.dataInstalacao AS "Data da instalação"
FROM empresa e
JOIN Sensor s ON e.idEmpresa = s.fkEmpresa;


-- Listar todos os Leitura registrados por um sensor:
SELECT s.numSerie, d.leitura, d.dtLeitura, d.statusSensor
FROM Sensor s
JOIN Leitura d ON s.idSensor = d.fkSensor
WHERE s.idSensor = 1;

-- Obter todos os Leitura com informações completas de sensor e do usuário:
SELECT 
    e.razaoSocial,
    s.modelo,
    s.localInstalacao,
    d.leitura,
    d.statusSensor,
    d.dtLeitura
FROM empresa e
JOIN Sensor s ON e.idEmpresa = s.fkEmpresa
JOIN Leitura d ON s.idSensor = d.fkSensor
WHERE e.idEmpresa = 2;

-- Mostrar todos os sensores, mesmo os que ainda não têm Leitura registrados. LEFT JOIN
SELECT 
    s.numSerie,
    s.localInstalacao,
    d.leitura,
    d.dtLeitura
FROM Sensor s
LEFT JOIN Leitura d ON s.idSensor = d.fkSensor;

-- Mostrar os Leitura ordenados por data (do mais recente ao mais antigo)
SELECT 
    d.leitura,
    d.dtleitura,
    d.statusSensor
FROM Leitura d
ORDER BY d.dtLeitura DESC;

SELECT * from Leitura;
