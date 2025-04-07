
-- Nome Projeto: OlivGuard

CREATE DATABASE projetoPI;

USE projetoPI;


CREATE TABLE usuario(
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(50) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    email VARCHAR(30) UNIQUE NOT NULL,
    senha VARCHAR(20) NOT NULL,
    cep CHAR(8) NOT NULL,
    telefone CHAR(11)
);

CREATE TABLE descSensor(
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(40),
    dataInstalacao DATETIME,
    localInstalacao VARCHAR(50),
    tipoLeitura VARCHAR(30),
    numSerie VARCHAR(20) UNIQUE,
    fkUsuario int,
    
    constraint fk_usuario foreign key (fkUsuario) references usuario(idUsuario)
);

CREATE TABLE dadosSensor(
	idDados INT PRIMARY KEY AUTO_INCREMENT ,
    dado FLOAT,
    statusSensor VARCHAR(15),
	dtDado DATETIME DEFAULT CURRENT_TIMESTAMP,
    fkSensor int,
    fkUsuario int,
    
    constraint fk_sensor foreign key (fkSensor) references descSensor(idSensor),
    constraint fk_usuario1 foreign key (fkUsuario) references usuario(idUsuario)
);


SHOW TABLES;

DESCRIBE dadossensor;
DESCRIBE descsensor;
DESCRIBE usuario;

insert into usuario(razaoSocial,cnpj,email,senha,cep,telefone) values
	('Oqliveira Master','12145678000199','oleveiramaster@gmail.com','11345','00001000','21993204456');

insert into descSensor(modelo,dataInstalacao,localInstalacao,tipoLeitura,numSerie,fkUsuario) values
	('Umiwdade de Solo Capac	tivo', '2024-03-01 10:30:00', 'Setor Npte', 'pmidade dSolo', 'OP12345678',3);
    
insert into dadosSensor (dado,statusSensor,dtDado,fkSensor,fkUsuario) values
	(34.5, 'Ativo','2024-03-01 08:30:00',1,1),
	(28.2, 'Ativo','2024-03-01 08:30:30',1,1),
	(22.7, 'Inativo','2024-03-01 08:31:00',1,1),
	(40.3, 'Ativo','2024-03-01 08:31:30',1,1),
	(19.8, 'Inativo','2024-03-01 08:32:00',1,1);
    
    SELECT * FROM dadosSensor;
    SELECT * FROM usuario;
    SELECT * FROM descSensor;
-- EXEMPLO 1:1
-- Pensando que cada usuário tenha apenas um sensor. Aqui vemos o nome da empresa
-- e o modelo do sensor junto com o número de série.
SELECT u.razaoSocial AS "Razão social", u.email AS "Email", s.modelo AS "Modelo do sensor", 
s.numSerie AS "Número de série"
FROM usuario u
JOIN descSensor s ON u.idUsuario = s.fkUsuario;

-- RELAÇÃO 1:N
--  Listar todos os sensores de um usuário:
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
WHERE u.idUsuario = 3;

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
