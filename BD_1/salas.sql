CREATE DATABASE salas_bd;
use salas_bd;

--TABLES

--DEPARTAMENTO {IDDepartamento(PK), Nome, Sigla}
CREATE TABLE DEPARTAMENTOS (
	IDDepartamento INTEGER PRIMARY KEY auto_increment,
	Nome VARCHAR(200),
	Sigla VARCHAR(6)
);

--CURSO {IDCurso(PK), Nome, Sigla, CargaHoraria, IDDepartamento(FK)}
CREATE TABLE CURSOS (
	IDCurso INTEGER PRIMARY KEY auto_increment,
	Nome VARCHAR(200),
	Sigla VARCHAR(6),
	CargaHoraria DECIMAL(6,2),
	IDDepartamento INTEGER,
	FOREIGN KEY (IDDepartamento) REFERENCES DEPARTAMENTOS(IDDepartamento) ON UPDATE CASCADE ON DELETE RESTRICT
);

--EQUIPAMENTO {IDEquipamento(PK), Nome, QuantExistente}
CREATE TABLE EQUIPAMENTOS (
	IDEquipamento INTEGER PRIMARY KEY auto_increment,
	Nome VARCHAR(200), 
	QuantExistente SMALLINT
);

--SALA {IDSala(PK), Sigla, TipoSala, Capacidade, IDDepartamento}
	--TipoSala = “Teórica”, “Laboratório”, “Auditório”, “Gabinete Professor”
CREATE TABLE SALAS (
	IDSala INTEGER PRIMARY KEY auto_increment,
	Sigla VARCHAR(6),
	TipoSala VARCHAR(18),
	Capacidade SMALLINT,
	IDDepartamento INTEGER,
	FOREIGN KEY (IDDepartamento) REFERENCES DEPARTAMENTOS(IDDepartamento) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT ChecktipoSala CHECK (
		TipoSala IN ('Teórica', 'Laboratório', 'Auditório', 'Gabinete Professor')
	)
);
--ENDERECO {IDEndereco(PK), UF, Cidade, Bairro, Rua, CEP}
CREATE TABLE ENDERECOS (
	IDEndereco INTEGER PRIMARY KEY auto_increment,
	UF CHAR(2),
	Cidade VARCHAR(50),
	Bairro VARCHAR (50),
	Rua VARCHAR(50),
	CEP CHAR(9)
);

--EVENTO {IDEvento(PK), Nome, Descricao, Sigla}
CREATE TABLE EVENTOS (
	IDEvento INTEGER PRIMARY KEY auto_increment,
	Nome VARCHAR(200),
	Descricao TEXT,
	Sigla VARCHAR(6)
);

--SALAEQUIPAMENTO {IDSala, IDEquipamento(PK), QuantAlocada}
CREATE TABLE SALAEQUIPAMENTO (
	IDSala INTEGER NOT NULL,
	IDEquipamento INTEGER NOT NULL,
	QuantAlocada SMALLINT,
	PRIMARY KEY (IDSala, IDEquipamento),
	FOREIGN KEY (IDSala) REFERENCES SALAS(IDSala) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (IDEquipamento) REFERENCES EQUIPAMENTOS(IDEquipamento) ON UPDATE RESTRICT ON DELETE RESTRICT
);

--FUNCIONARIO {IDFuncionario, Nome, CPF, Email, DataAdmissao, DataDemissao, Salario, IDEndereco(FK), IDDepartamento(FK)}
CREATE TABLE FUNCIONARIOS (
	IDFuncionario INTEGER PRIMARY KEY auto_increment,
	Nome VARCHAR(200),
	CPF CHAR(11),
	Email VARCHAR(50),
	DataAdmissao DATE,
	DataDemissao DATE,
	Salario DECIMAL(8,2),
	IDEndereco INTEGER,
	IDDepartamento INTEGER,
	FOREIGN KEY (IDEndereco) REFERENCES ENDERECOS(IDEndereco) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (IDDepartamento) REFERENCES DEPARTAMENTOS(IDDepartamento) ON UPDATE RESTRICT ON DELETE RESTRICT
);

--ALOCACAO {IDAlocacao, IDEvento, IDSala(PK), DataAlocacao, DataInicioReserva, DataTerminoReserva, HoraInicioReserva, HoraTerminoReserva, DiaSemana, IDFuncionario(FK)}
	--DiaSemana = “Segunda”, “Terça”, “Quarta”, “Quinta”, “Sexta”, “Sábado”
CREATE TABLE ALOCACOES (
	IDAlocacao INTEGER,
	IDEvento INTEGER,
	IDSala INTEGER,
	DataAlocacao DATE,
	DataInicioReserva DATE,
	DataTerminoReserva DATE,
	HoraInicioReserva TIME,
	HoraTerminoReserva TIME,
	DiaSemana varchar(7),
	IDFuncionario INTEGER,
	PRIMARY KEY (IDAlocacao, IDEvento, IDSala),
	FOREIGN KEY (IDEvento) REFERENCES EVENTOS(IDEvento) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (IDSala) REFERENCES SALAS(IDSala) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (IDFuncionario) REFERENCES FUNCIONARIOS(IDFuncionario) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT Checkdiasemana CHECK (
		DiaSemana IN ('Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado')
	)
);

--INSERT
INSERT INTO DEPARTAMENTOS (Nome, Sigla) VALUES
('Departamento de Ciência da Computação', 'DCC'),
('Departamento de Engenharia Elétrica', 'DEE'),
('Departamento de Ciências Humanas', 'DCH'),
('Departamento de Administração', 'DAD'),
('Departamento de Medicina', 'MED');

INSERT INTO ENDERECOS (UF, Cidade, Bairro, Rua, CEP) VALUES
('PR', 'Curitiba', 'Centro', 'Rua das Flores', '80000-001'),
('SP', 'São Paulo', 'Vila Mariana', 'Av. Paulista, 1000', '01310-100'),
('MG', 'Belo Horizonte', 'Savassi', 'Rua da Tecnologia, 50', '30110-010'),
('RJ', 'Rio de Janeiro', 'Copacabana', 'Rua Principal', '22010-020'),
('PR', 'Ponta Grossa', 'Uvaranas', 'Rua dos Campos', '84030-000'),
('SC', 'Florianópolis', 'Lagoa', 'Rua da Praia', '88050-001'),
('RS', 'Porto Alegre', 'Petrópolis', 'Av. Central', '90450-000'),
('BA', 'Salvador', 'Pituba', 'Rua da Bahia', '41830-000'),
('PE', 'Recife', 'Boa Viagem', 'Rua do Sol', '51010-001');

INSERT INTO EQUIPAMENTOS (Nome, QuantExistente) VALUES
('Projetor HD', 20),
('Quadro Interativo', 10),
('Computador Desktop i7', 150),
('Sistema de Som 5.1', 5),
('Microscópio Óptico', 30),
('Câmera de Documentos', 15),
('Webcam Conferência', 50),
('Impressora 3D', 4),
('Scanner Profissional', 8),
('Ar Condicionado Split', 30),
('Kit Robótica Educacional', 25),
('Painel Solar Didático', 12),
('Software de Simulação CAD', 50),
('Mesa Digitalizadora', 18),
('Lousa Branca Grande', 45),
('Kit Primeiros Socorros', 20),
('Extintor de Incêndio PQS', 50),
('Cadeira Ergonômica', 200),
('Mesa de Reunião Grande', 10),
('Televisão 60 polegadas', 15),
('Flip Chart', 25),
('Tablet de Apoio', 35),
('Kit Multimídia Básico', 40),
('Medidor de Frequência', 10),
('Fonte de Alimentação Lab', 15),
('Kit Eletrônica Analógica', 22),
('Gerador de Funções', 8),
('Bancada Anti-Estática', 14),
('Kit Biologia Celular', 10),
('Modelo Anatômico', 5);

INSERT INTO SALAS (Sigla, TipoSala, Capacidade, IDDepartamento) VALUES
('S-101', 'Teórica', 40, 1), -- DCC
('S-102', 'Teórica', 30, 1), -- DCC
('S-201', 'Teórica', 50, 2), -- DEE
('S-202', 'Teórica', 45, 2), -- DEE
('S-301', 'Teórica', 35, 3), -- DCH
('S-302', 'Auditório', 120, 3), -- DCH
('LAB-C01', 'Laboratório', 25, 1), -- DCC
('LAB-C02', 'Laboratório', 20, 1), -- DCC
('LAB-E01', 'Laboratório', 30, 2), -- DEE
('LAB-M01', 'Laboratório', 22, 5), -- MED
('AUD-PR', 'Auditório', 200, 4), -- DAD
('AUD-ME', 'Auditório', 80, 5), -- MED
('GAB-A1', 'Gabinete Professor', 2, 1), -- DCC
('GAB-A2', 'Gabinete Professor', 2, 2), -- DEE
('GAB-B1', 'Gabinete Professor', 2, 3); -- DCH

INSERT INTO FUNCIONARIOS (Nome, CPF, Email, DataAdmissao, Salario, IDEndereco, IDDepartamento) VALUES
('Alice Silva', '12345678901', 'alice@universidade.br', '2018-05-15', 5500.00, 1, 1),
('Bruno Santos', '23456789012', 'bruno@universidade.br', '2019-10-20', 6200.50, 2, 2),
('Carla Oliveira', '34567890123', 'carla@universidade.br', '2017-01-01', 4800.00, 3, 3),
('Daniel Mendes', '45678901234', 'daniel@universidade.br', '2020-07-25', 7000.00, 4, 4),
('Eduarda Lima', '56789012345', 'eduarda@universidade.br', '2022-03-10', 5100.00, 5, 5),
('Felipe Gomes', '67890123456', 'felipe@universidade.br', '2021-08-05', 5950.00, 6, 1),
('Gabriela Rocha', '78901234567', 'gabriela@universidade.br', '2023-01-20', 4500.00, 7, 2),
('Hugo Costa', '89012345678', 'hugo@universidade.br', '2019-04-12', 6800.00, 8, 3),
('Isabela Viana', '90123456789', 'isabela@universidade.br', '2022-11-30', 5300.00, 9, 4),
('Jonas Ferreira', '01234567890', 'jonas@universidade.br', '2018-03-01', 7500.00, 1, 5),
('Karen Melo', '10987654321', 'karen@universidade.br', '2023-09-18', 4900.00, 2, 1);

INSERT INTO SALAEQUIPAMENTO (IDSala, IDEquipamento, QuantAlocada) VALUES
-- Salas Teóricas (1, 2, 3, 4, 5, 6)
(1, 1, 1), (1, 15, 1), (1, 18, 40), -- S-101: Projetor, Lousa, Cadeiras
(2, 1, 1), (2, 15, 1), (2, 18, 30), -- S-102
(3, 1, 1), (3, 2, 1), (3, 18, 50), -- S-201: Projetor, Quadro, Cadeiras
(4, 1, 1), (4, 15, 1), (4, 18, 45), -- S-202

-- Laboratórios (7, 8, 9, 10)
(7, 3, 25), (7, 6, 1), (7, 13, 25), (7, 26, 10), -- LAB-C01: Computadores, Câmera Doc, Software, Kits
(8, 3, 20), (8, 7, 20), (8, 14, 10), (8, 27, 5), -- LAB-C02: Computadores, Webcam, Mesa Digit., Gerador Func.
(9, 3, 30), (9, 11, 15), (9, 12, 5), (9, 25, 10), -- LAB-E01: Computadores, Robótica, Painel Solar, Fonte Ali.
(10, 5, 10), (10, 29, 5), (10, 30, 2), (10, 16, 1), -- LAB-M01: Microscópio, Kit Biologia, Modelo Anatômico, Kit PS

-- Auditórios (6, 11, 12)
(6, 1, 2), (6, 4, 1), (6, 20, 1), -- S-302: 2 Projetores, Som, TV
(11, 1, 3), (11, 4, 1), (11, 20, 2), -- AUD-PR
(12, 1, 1), (12, 4, 1), (12, 20, 1), -- AUD-ME

-- Gabinetes (13, 14, 15)
(13, 3, 1), (13, 18, 2), -- GAB-A1: 1 Computador
(14, 3, 1), (14, 18, 2), -- GAB-A2
(15, 3, 1), (15, 18, 2); -- GAB-B1

-- *Para garantir que todos os 30 equipamentos foram alocados, vamos alocar o restante nos laboratórios:*
INSERT INTO SALAEQUIPAMENTO (IDSala, IDEquipamento, QuantAlocada) VALUES
(7, 9, 1), (7, 10, 1), (7, 17, 2), -- Equipamentos 9, 10, 17 no LAB-C01
(9, 19, 1), (9, 21, 1), (9, 22, 5), -- Equipamentos 19, 21, 22 no LAB-E01
(10, 23, 1), (10, 24, 1), (10, 28, 1); -- Equipamentos 23, 24, 28 no LAB-M01

INSERT INTO EVENTOS (IDEvento, Nome, Descricao, Sigla) VALUES
(1, 'Semana Acadêmica de TI - Dia 1', 'Palestras de Abertura', 'SATI-01'),
(2, 'Semana Acadêmica de TI - Dia 2', 'Workshops e Minicurso 1', 'SATI-02'),
(3, 'Semana Acadêmica de TI - Dia 3', 'Apresentação de Artigos', 'SATI-03'),
(4, 'Congresso de Eletricidade - Sessão Potência', 'Sessão 1', 'CE-P1'),
(5, 'Congresso de Eletricidade - Sessão Controle', 'Sessão 2', 'CE-C2'),
(6, 'Congresso de Eletricidade - Sessão Telecom', 'Sessão 3', 'CE-T3'),
(7, 'Defesa de Tese - Aluno 1', 'Tese sobre I.A.', 'TD-IA'),
(8, 'Defesa de Tese - Aluno 2', 'Tese sobre Robótica', 'TD-ROBO'),
(9, 'Defesa de Tese - Aluno 3', 'Tese sobre Finanças', 'TD-FIN'),
(10, 'Reunião de Coordenação - CC', 'Mensal DCC', 'R-CC'),
(11, 'Reunião de Coordenação - EE', 'Mensal DEE', 'R-EE'),
(12, 'Reunião de Coordenação - CH', 'Mensal DCH', 'R-CH'),
(13, 'Workshop de Banco de Dados Avançado', 'Prática SQL', 'WDB-ADV'),
(14, 'Workshop de Redes Neurais', 'Prática IA', 'WIA-RN'),
(15, 'Seminário de Ética em Pesquisa', 'Regras', 'SEMIN-E'),
(16, 'Palestra de Recrutamento Tech', 'Carreiras', 'P-TECH'),
(17, 'Treinamento de Primeiros Socorros', 'Equipe Médica', 'T-PS'),
(18, 'Reunião de P&D', 'Novos Projetos', 'R-PD'),
(19, 'Simpósio de Humanidades - Sessão 1', 'Sessão 1', 'SIM-H1'),
(20, 'Simpósio de Humanidades - Sessão 2', 'Sessão 2', 'SIM-H2'),
(21, 'Aula Magna Especial - Tema 21', 'Aula de alto nível 21', 'AME21'),
(22, 'Aula Magna Especial - Tema 22', 'Aula de alto nível 22', 'AME22'),
(23, 'Aula Magna Especial - Tema 23', 'Aula de alto nível 23', 'AME23'),
(24, 'Aula Magna Especial - Tema 24', 'Aula de alto nível 24', 'AME24'),
(25, 'Aula Magna Especial - Tema 25', 'Aula de alto nível 25', 'AME25'),
(26, 'Aula Magna Especial - Tema 26', 'Aula de alto nível 26', 'AME26'),
(27, 'Aula Magna Especial - Tema 27', 'Aula de alto nível 27', 'AME27'),
(28, 'Aula Magna Especial - Tema 28', 'Aula de alto nível 28', 'AME28'),
(29, 'Aula Magna Especial - Tema 29', 'Aula de alto nível 29', 'AME29'),
(30, 'Aula Magna Especial - Tema 30', 'Aula de alto nível 30', 'AME30'),
(31, 'Aula Magna Especial - Tema 31', 'Aula de alto nível 31', 'AME31'),
(32, 'Aula Magna Especial - Tema 32', 'Aula de alto nível 32', 'AME32'),
(33, 'Aula Magna Especial - Tema 33', 'Aula de alto nível 33', 'AME33'),
(34, 'Aula Magna Especial - Tema 34', 'Aula de alto nível 34', 'AME34'),
(35, 'Aula Magna Especial - Tema 35', 'Aula de alto nível 35', 'AME35'),
(36, 'Aula Magna Especial - Tema 36', 'Aula de alto nível 36', 'AME36'),
(37, 'Aula Magna Especial - Tema 37', 'Aula de alto nível 37', 'AME37'),
(38, 'Aula Magna Especial - Tema 38', 'Aula de alto nível 38', 'AME38'),
(39, 'Aula Magna Especial - Tema 39', 'Aula de alto nível 39', 'AME39'),
(40, 'Aula Magna Especial - Tema 40', 'Aula de alto nível 40', 'AME40'),
(41, 'Aula Magna Especial - Tema 41', 'Aula de alto nível 41', 'AME41'),
(42, 'Aula Magna Especial - Tema 42', 'Aula de alto nível 42', 'AME42'),
(43, 'Aula Magna Especial - Tema 43', 'Aula de alto nível 43', 'AME43'),
(44, 'Aula Magna Especial - Tema 44', 'Aula de alto nível 44', 'AME44'),
(45, 'Aula Magna Especial - Tema 45', 'Aula de alto nível 45', 'AME45'),
(46, 'Aula Magna Especial - Tema 46', 'Aula de alto nível 46', 'AME46'),
(47, 'Aula Magna Especial - Tema 47', 'Aula de alto nível 47', 'AME47'),
(48, 'Aula Magna Especial - Tema 48', 'Aula de alto nível 48', 'AME48'),
(49, 'Aula Magna Especial - Tema 49', 'Aula de alto nível 49', 'AME49'),
(50, 'Aula Magna Especial - Tema 50', 'Aula de alto nível 50', 'AME50'),
(51, 'Aula Magna Especial - Tema 51', 'Aula de alto nível 51', 'AME51'),
(52, 'Aula Magna Especial - Tema 52', 'Aula de alto nível 52', 'AME52'),
(53, 'Aula Magna Especial - Tema 53', 'Aula de alto nível 53', 'AME53'),
(54, 'Aula Magna Especial - Tema 54', 'Aula de alto nível 54', 'AME54'),
(55, 'Aula Magna Especial - Tema 55', 'Aula de alto nível 55', 'AME55'),
(56, 'Aula Magna Especial - Tema 56', 'Aula de alto nível 56', 'AME56'),
(57, 'Aula Magna Especial - Tema 57', 'Aula de alto nível 57', 'AME57'),
(58, 'Aula Magna Especial - Tema 58', 'Aula de alto nível 58', 'AME58'),
(59, 'Aula Magna Especial - Tema 59', 'Aula de alto nível 59', 'AME59'),
(60, 'Aula Magna Especial - Tema 60', 'Aula de alto nível 60', 'AME60'),
(61, 'Aula Magna Especial - Tema 61', 'Aula de alto nível 61', 'AME61'),
(62, 'Aula Magna Especial - Tema 62', 'Aula de alto nível 62', 'AME62'),
(63, 'Aula Magna Especial - Tema 63', 'Aula de alto nível 63', 'AME63'),
(64, 'Aula Magna Especial - Tema 64', 'Aula de alto nível 64', 'AME64'),
(65, 'Aula Magna Especial - Tema 65', 'Aula de alto nível 65', 'AME65'),
(66, 'Aula Magna Especial - Tema 66', 'Aula de alto nível 66', 'AME66'),
(67, 'Aula Magna Especial - Tema 67', 'Aula de alto nível 67', 'AME67'),
(68, 'Aula Magna Especial - Tema 68', 'Aula de alto nível 68', 'AME68'),
(69, 'Aula Magna Especial - Tema 69', 'Aula de alto nível 69', 'AME69'),
(70, 'Aula Magna Especial - Tema 70', 'Aula de alto nível 70', 'AME70'),
(71, 'Aula Magna Especial - Tema 71', 'Aula de alto nível 71', 'AME71'),
(72, 'Aula Magna Especial - Tema 72', 'Aula de alto nível 72', 'AME72'),
(73, 'Aula Magna Especial - Tema 73', 'Aula de alto nível 73', 'AME73'),
(74, 'Aula Magna Especial - Tema 74', 'Aula de alto nível 74', 'AME74'),
(75, 'Aula Magna Especial - Tema 75', 'Aula de alto nível 75', 'AME75'),
(76, 'Aula Magna Especial - Tema 76', 'Aula de alto nível 76', 'AME76'),
(77, 'Aula Magna Especial - Tema 77', 'Aula de alto nível 77', 'AME77'),
(78, 'Aula Magna Especial - Tema 78', 'Aula de alto nível 78', 'AME78'),
(79, 'Aula Magna Especial - Tema 79', 'Aula de alto nível 79', 'AME79'),
(80, 'Aula Magna Especial - Tema 80', 'Aula de alto nível 80', 'AME80'),
(81, 'Aula Magna Especial - Tema 81', 'Aula de alto nível 81', 'AME81'),
(82, 'Aula Magna Especial - Tema 82', 'Aula de alto nível 82', 'AME82'),
(83, 'Aula Magna Especial - Tema 83', 'Aula de alto nível 83', 'AME83'),
(84, 'Aula Magna Especial - Tema 84', 'Aula de alto nível 84', 'AME84'),
(85, 'Aula Magna Especial - Tema 85', 'Aula de alto nível 85', 'AME85'),
(86, 'Aula Magna Especial - Tema 86', 'Aula de alto nível 86', 'AME86'),
(87, 'Aula Magna Especial - Tema 87', 'Aula de alto nível 87', 'AME87'),
(88, 'Aula Magna Especial - Tema 88', 'Aula de alto nível 88', 'AME88'),
(89, 'Aula Magna Especial - Tema 89', 'Aula de alto nível 89', 'AME89'),
(90, 'Aula Magna Especial - Tema 90', 'Aula de alto nível 90', 'AME90'),
(91, 'Aula Magna Especial - Tema 91', 'Aula de alto nível 91', 'AME91'),
(92, 'Aula Magna Especial - Tema 92', 'Aula de alto nível 92', 'AME92'),
(93, 'Aula Magna Especial - Tema 93', 'Aula de alto nível 93', 'AME93'),
(94, 'Aula Magna Especial - Tema 94', 'Aula de alto nível 94', 'AME94'),
(95, 'Aula Magna Especial - Tema 95', 'Aula de alto nível 95', 'AME95'),
(96, 'Aula Magna Especial - Tema 96', 'Aula de alto nível 96', 'AME96'),
(97, 'Aula Magna Especial - Tema 97', 'Aula de alto nível 97', 'AME97'),
(98, 'Aula Magna Especial - Tema 98', 'Aula de alto nível 98', 'AME98'),
(99, 'Aula Magna Especial - Tema 99', 'Aula de alto nível 99', 'AME99'),
(100, 'Aula Magna Especial - Tema 100', 'Aula de alto nível 100', 'AME100');

INSERT INTO ALOCACOES (IDAlocacao, IDEvento, IDSala, DataAlocacao, DataInicioReserva, DataTerminoReserva, HoraInicioReserva, HoraTerminoReserva, DiaSemana, IDFuncionario) VALUES

-- ---------------------------------------------------------------------------------------
-- Eventos que reservam Salas 1 a 14 (DataTermino: 2025-11-15 -> OCUPADAS hoje)
-- ---------------------------------------------------------------------------------------
-- Evento 1 (Salas 1-5)
(1, 1, 1, '2025-10-01', '2025-10-01', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 1),
(2, 1, 2, '2025-10-01', '2025-10-01', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 2),
(3, 1, 3, '2025-10-01', '2025-10-01', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 3),
(4, 1, 4, '2025-10-01', '2025-10-01', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 4),
(5, 1, 5, '2025-10-01', '2025-10-01', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 5),

-- Evento 2 (Salas 6-10)
(6, 2, 6, '2025-10-02', '2025-10-02', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 6),
(7, 2, 7, '2025-10-02', '2025-10-02', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 7),
(8, 2, 8, '2025-10-02', '2025-10-02', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 8),
(9, 2, 9, '2025-10-02', '2025-10-02', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 9),
(10, 2, 10, '2025-10-02', '2025-10-02', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 10),

-- Evento 3 (Salas 11-14)
(11, 3, 11, '2025-10-03', '2025-10-03', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 11),
(12, 3, 12, '2025-10-03', '2025-10-03', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 1),
(13, 3, 13, '2025-10-03', '2025-10-03', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 2),
(14, 3, 14, '2025-10-03', '2025-10-03', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 3),

-- ------------------------------------------------------------------------------------------------
-- Sala 15: DataTermino = 2025-10-25 (Permite DISPONIBILIDADE em 2025-11-02)
-- ------------------------------------------------------------------------------------------------
(15, 3, 15, '2025-10-03', '2025-10-03', '2025-10-25', '18:00:00', '22:00:00', 'Sexta', 4), 

-- Evento 4 (Salas 1-5)
(16, 4, 1, '2025-10-04', '2025-10-04', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 9),
(17, 4, 2, '2025-10-04', '2025-10-04', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 10),
(18, 4, 3, '2025-10-04', '2025-10-04', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 11),
(19, 4, 4, '2025-10-04', '2025-10-04', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 1),
(20, 4, 5, '2025-10-04', '2025-10-04', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 2),

-- Evento 5 (Salas 6-10)
(21, 5, 6, '2025-10-06', '2025-10-06', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 3),
(22, 5, 7, '2025-10-06', '2025-10-06', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 4),
(23, 5, 8, '2025-10-06', '2025-10-06', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 5),
(24, 5, 9, '2025-10-06', '2025-10-06', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 6),
(25, 5, 10, '2025-10-06', '2025-10-06', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 7),

-- Evento 6 (Salas 11-14 e Sala 15)
(26, 6, 11, '2025-10-07', '2025-10-07', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 8),
(27, 6, 12, '2025-10-07', '2025-10-07', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 9),
(28, 6, 13, '2025-10-07', '2025-10-07', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 10),
(29, 6, 14, '2025-10-07', '2025-10-07', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 11),
(30, 6, 15, '2025-10-07', '2025-10-07', '2025-10-25', '18:00:00', '22:00:00', 'Terça', 1), -- **Sala 15: Disponível**

-- Evento 7 (Salas 1-5)
(31, 7, 1, '2025-10-08', '2025-10-08', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 6),
(32, 7, 2, '2025-10-08', '2025-10-08', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 7),
(33, 7, 3, '2025-10-08', '2025-10-08', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 8),
(34, 7, 4, '2025-10-08', '2025-10-08', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 9),
(35, 7, 5, '2025-10-08', '2025-10-08', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 10),

-- Evento 8 (Salas 6-10)
(36, 8, 6, '2025-10-09', '2025-10-09', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 11),
(37, 8, 7, '2025-10-09', '2025-10-09', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 1),
(38, 8, 8, '2025-10-09', '2025-10-09', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 2),
(39, 8, 9, '2025-10-09', '2025-10-09', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 3),
(40, 8, 10, '2025-10-09', '2025-10-09', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 4),

-- Evento 9 (Salas 11-14 e Sala 15)
(41, 9, 11, '2025-10-10', '2025-10-10', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 5),
(42, 9, 12, '2025-10-10', '2025-10-10', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 6),
(43, 9, 13, '2025-10-10', '2025-10-10', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 7),
(44, 9, 14, '2025-10-10', '2025-10-10', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 8),
(45, 9, 15, '2025-10-10', '2025-10-10', '2025-10-25', '18:00:00', '22:00:00', 'Sexta', 9), -- **Sala 15: Disponível**

-- Evento 10 (Salas 1-5)
(46, 10, 1, '2025-10-11', '2025-10-11', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 1),
(47, 10, 2, '2025-10-11', '2025-10-11', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 2),
(48, 10, 3, '2025-10-11', '2025-10-11', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 3),
(49, 10, 4, '2025-10-11', '2025-10-11', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 4),
(50, 10, 5, '2025-10-11', '2025-10-11', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 5),

-- Evento 11 (Salas 6-10)
(51, 11, 6, '2025-10-13', '2025-10-13', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 8),
(52, 11, 7, '2025-10-13', '2025-10-13', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 9),
(53, 11, 8, '2025-10-13', '2025-10-13', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 10),
(54, 11, 9, '2025-10-13', '2025-10-13', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 11),
(55, 11, 10, '2025-10-13', '2025-10-13', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 1),

-- Evento 12 (Salas 11-14 e Sala 15)
(56, 12, 11, '2025-10-14', '2025-10-14', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 3),
(57, 12, 12, '2025-10-14', '2025-10-14', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 4),
(58, 12, 13, '2025-10-14', '2025-10-14', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 5),
(59, 12, 14, '2025-10-14', '2025-10-14', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 6),
(60, 12, 15, '2025-10-14', '2025-10-14', '2025-10-25', '18:00:00', '22:00:00', 'Terça', 7), -- **Sala 15: Disponível**

-- Evento 13 (Salas 1-5)
(61, 13, 1, '2025-10-15', '2025-10-15', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 9),
(62, 13, 2, '2025-10-15', '2025-10-15', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 10),
(63, 13, 3, '2025-10-15', '2025-10-15', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 11),
(64, 13, 4, '2025-10-15', '2025-10-15', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 1),
(65, 13, 5, '2025-10-15', '2025-10-15', '2025-11-15', '08:00:00', '12:00:00', 'Quarta', 2),

-- Evento 14 (Salas 6-10)
(66, 14, 6, '2025-10-16', '2025-10-16', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 5),
(67, 14, 7, '2025-10-16', '2025-10-16', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 6),
(68, 14, 8, '2025-10-16', '2025-10-16', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 7),
(69, 14, 9, '2025-10-16', '2025-10-16', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 8),
(70, 14, 10, '2025-10-16', '2025-10-16', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 9),

-- Evento 15 (Salas 11-14 e Sala 15)
(71, 15, 11, '2025-10-17', '2025-10-17', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 11),
(72, 15, 12, '2025-10-17', '2025-10-17', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 1),
(73, 15, 13, '2025-10-17', '2025-10-17', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 2),
(74, 15, 14, '2025-10-17', '2025-10-17', '2025-11-15', '18:00:00', '22:00:00', 'Sexta', 3),
(75, 15, 15, '2025-10-17', '2025-10-17', '2025-10-25', '18:00:00', '22:00:00', 'Sexta', 4), -- **Sala 15: Disponível**

-- Evento 16 (Salas 1-5)
(76, 16, 1, '2025-10-18', '2025-10-18', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 6),
(77, 16, 2, '2025-10-18', '2025-10-18', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 7),
(78, 16, 3, '2025-10-18', '2025-10-18', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 8),
(79, 16, 4, '2025-10-18', '2025-10-18', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 9),
(80, 16, 5, '2025-10-18', '2025-10-18', '2025-11-15', '08:00:00', '12:00:00', 'Sábado', 10),

-- Evento 17 (Salas 6-10)
(81, 17, 6, '2025-10-20', '2025-10-20', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 1),
(82, 17, 7, '2025-10-20', '2025-10-20', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 2),
(83, 17, 8, '2025-10-20', '2025-10-20', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 3),
(84, 17, 9, '2025-10-20', '2025-10-20', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 4),
(85, 17, 10, '2025-10-20', '2025-10-20', '2025-11-15', '13:00:00', '17:00:00', 'Segunda', 5),

-- Evento 18 (Salas 11-14 e Sala 15)
(86, 18, 11, '2025-10-21', '2025-10-21', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 8),
(87, 18, 12, '2025-10-21', '2025-10-21', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 9),
(88, 18, 13, '2025-10-21', '2025-10-21', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 10),
(89, 18, 14, '2025-10-21', '2025-10-21', '2025-11-15', '18:00:00', '22:00:00', 'Terça', 11),
(90, 18, 15, '2025-10-21', '2025-10-21', '2025-10-25', '18:00:00', '22:00:00', 'Terça', 1), -- **Sala 15: Disponível**

-- Evento 19 (Salas 1-5)
(91, 19, 1, '2025-10-22', '2025-10-22', '2025-11-15', '08:00:00', '12:00:00', 'Terça', 3),
(92, 19, 2, '2025-10-22', '2025-10-22', '2025-11-15', '08:00:00', '12:00:00', 'Terça', 4),
(93, 19, 3, '2025-10-22', '2025-10-22', '2025-11-15', '08:00:00', '12:00:00', 'Terça', 5),
(94, 19, 4, '2025-10-22', '2025-10-22', '2025-11-15', '08:00:00', '12:00:00', 'Terça', 6),
(95, 19, 5, '2025-10-22', '2025-10-22', '2025-11-15', '08:00:00', '12:00:00', 'Terça', 7),

-- Evento 20 (Salas 6-10)
(96, 20, 6, '2025-10-23', '2025-10-23', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 8),
(97, 20, 7, '2025-10-23', '2025-10-23', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 9),
(98, 20, 8, '2025-10-23', '2025-10-23', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 10),
(99, 20, 9, '2025-10-23', '2025-10-23', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 11),
(100, 20, 10, '2025-10-23', '2025-10-23', '2025-11-15', '13:00:00', '17:00:00', 'Quinta', 1);

INSERT INTO ENDERECOS (IDEndereco, UF, Cidade, Bairro, Rua, CEP) VALUES
(10, 'PR', 'Maringá', 'Zona 7', 'Av. Colombo, 5790', '87020-900'),
(11, 'PR', 'Londrina', 'Centro', 'Rua Piauí, 100', '86010-420'),
(12, 'PR', 'Cascavel', 'Cancelli', 'Rua Rio Grande do Sul', '85811-000'),
(13, 'PR', 'Foz do Iguaçu', 'Vila Yolanda', 'Av. das Cataratas', '85853-000'),
(14, 'PR', 'São José dos Pinhais', 'Cidade Jardim', 'Rua XV de Novembro', '83030-000'),
(15, 'PR', 'Colombo', 'Campo Alto', 'Rua da Pedreira, 120', '83411-000'),
(16, 'PR', 'Paranaguá', 'Borda do Campo', 'Rua dos Portuários', '83203-000'),
(17, 'PR', 'Toledo', 'Jardim Coopagro', 'Rua Dom Pedro II', '85903-000'),
(18, 'PR', 'Guarapuava', 'Santa Cruz', 'Rua Marechal Floriano', '85010-000'),
(19, 'PR', 'Arapongas', 'Centro', 'Rua Flamingos', '86700-000'),
(20, 'PR', 'Apucarana', 'Barra Funda', 'Rua Ponta Grossa', '86800-000'),
(21, 'PR', 'Campo Largo', 'Vila Bancária', 'Rua Centenário, 200', '83601-000'),
(22, 'PR', 'Pinhais', 'Vargem Grande', 'Av. Ayrton Senna', '83323-000'),
(23, 'PR', 'Almirante Tamandaré', 'Cachoeira', 'Rua Curitiba', '83500-000'),
(24, 'PR', 'Pato Branco', 'Zona Industrial', 'Rua Tocantins', '85301-000');

INSERT INTO CURSOS (IDCurso, Nome, Sigla, CargaHoraria, IDDepartamento) VALUES
(1, 'Engenharia de Software', 'ESOF', 3600.00, 1),
(2, 'Sistemas de Informação', 'SI', 3000.00, 1),
(3, 'Análise e Desenvolvimento de Sistemas', 'ADS', 2800.00, 1),
(4, 'Redes de Computadores', 'REDES', 2600.00, 1),
(5, 'Ciência de Dados', 'CDADOS', 3200.00, 1),
(6, 'Engenharia Elétrica - Ênfase em Potência', 'EEL1', 4000.00, 2),
(7, 'Engenharia Elétrica - Ênfase em Controle', 'EEL2', 4000.00, 2),
(8, 'Telecomunicações', 'TELE', 3800.00, 2),
(9, 'Eletrônica Industrial', 'EIND', 3400.00, 2),
(10, 'Sistemas Embarcados', 'SEMB', 3200.00, 2),
(11, 'Psicologia Cognitiva', 'PSIC', 2800.00, 3),
(12, 'Sociologia Urbana', 'SOCIO', 2400.00, 3),
(13, 'História Contemporânea', 'HCONT', 2500.00, 3),
(14, 'Filosofia Analítica', 'FILAN', 2300.00, 3),
(15, 'Geografia Humana', 'GEOHUM', 2700.00, 3),
(16, 'Administração de Empresas', 'ADM', 3800.00, 4),
(17, 'Marketing Digital', 'MKT', 3000.00, 4),
(18, 'Finanças Corporativas', 'FIN', 3500.00, 4),
(19, 'Recursos Humanos', 'RH', 2900.00, 4),
(20, 'Logística Empresarial', 'LOG', 3100.00, 4),
(21, 'Medicina Clínica Geral', 'MCG', 6000.00, 5),
(22, 'Enfermagem', 'ENF', 4000.00, 5),
(23, 'Fisioterapia', 'FISIO', 3800.00, 5),
(24, 'Odontologia', 'ODONTO', 4200.00, 5),
(25, 'Nutrição', 'NUTR', 3500.00, 5),
(26, 'Cibersegurança', 'CIBER', 2700.00, 1),
(27, 'Automação Industrial', 'AUT', 3900.00, 2),
(28, 'Ciência Política', 'CPOL', 2600.00, 3),
(29, 'Contabilidade', 'CONT', 3300.00, 4),
(30, 'Farmácia', 'FARM', 4100.00, 5);

--Pesquisas

--Dupliquei sem querer
DELETE A1
FROM DEPARTAMENTOS AS A1 INNER JOIN DEPARTAMENTOS AS A2
WHERE 
	A1.Nome = A2.Nome AND
	A1.Sigla = A2.Sigla AND
	A1.IDDepartamento > A2.IDDepartamento;
	
/* 
 * 1. Selecione as Cidades do estado do Paraná ordenando-as 
 *    por ordem crescente do Nome da cidade;
 */
 
SELECT * FROM ENDERECOS 
	WHERE UF = 'PR'
	ORDER BY Cidade ASC;

/* 
 * 2. Selecione o Nome do Funcionário o seu endereço. 
 *    Ordene de forma decrescente de UF e ordem crescente 
 *    do nome do Funcionário;
 */
 
SELECT 
	Nome, 
	UF, 
	cidade, 
	Bairro, 
	Rua, 
	CEP
FROM 
	ENDERECOS AS E 
JOIN 
	FUNCIONARIOS AS F 
ON 
	F.IDEndereco = E.IDEndereco
ORDER BY 
	E.UF DESC,
	F.Nome ASC;
	
/*
 * 3. Selecione o nome e sigla dos cursos do Departamento Acadêmico de Informática;
 */
 
SELECT 
	C.Nome AS NomeCursO, 
	C.Sigla AS SiglaCurso
FROM
	CURSOS AS C JOIN DEPARTAMENTOS AS D ON C.IDDepartamento = D.IDDepartamento
WHERE
	D.Sigla = 'DCC';
	
/*
 * 4. Seleciona todos os Funcionários do Departamento Acadêmico de medicina que moram em Curitiba;
 */
 
SELECT 
	 F.Nome, 
	 F.CPF, 
	 F.SALARIO
FROM
	FUNCIONARIOS AS F 
	JOIN DEPARTAMENTOS AS D ON F.IDDepartamento = D.IDDepartamento
	JOIN ENDERECOS AS E ON F.IDEndereco = E.IDEndereco
WHERE
	D.Sigla = 'MED' AND E.cidade = 'Curitiba';
	
/*
 * 5. Selecione o Nome e Email dos Funcionários que foram admitidos a partir do ano de 2020. Ordene de forma crescente da data de Admissão;
 */
 
SELECT 
	F.Nome,
	F.Email,
	F.DataAdmissao
FROM
	FUNCIONARIOS AS F
WHERE
	F.DataAdmissao >= '2020-01-01'
ORDER BY
	F.DataAdmissao ASC;
	
/*
 * 6. Selecione os Funcionários que estão ativos na data de hoje;
 */

/*
 * 7. Selecione os Equipamentos disponíveis na Universidade, ordenar pelo nome do Equipamento, ordem decrescente;
 */

SELECT 
	Nome
FROM
	Equipamentos
ORDER BY Nome ASC;	

/*
 * 8. Selecione os Funcionários com menos de 30 anos de serviço na data de hoje;
 */

SELECT 
	Nome,
	DataAdmissao,
	DATEDIFF(CURDATE(), DataAdmissao)/365 AS TempoDeServico
FROM
	FUNCIONARIOS
WHERE
	(DATEDIFF(CURDATE(), DataAdmissao)/ 365) < 30;

/*
 * 9. Selecione as Salas disponíveis na data de hoje;
 */

SELECT *
FROM 
	SALAS AS S
	JOIN ALOCACOES AS A ON S.IDSala = A.IDSala
WHERE A.DataTerminoReserva < CURDATE();

/*
 * 10. Selecione a quantidade de Funcionários por Departamento. Ordene da menor para a maior quantidade;
 */

SELECT 
	D.NOME AS NOMEDEPARTAMENTO,
	COUNT(*) AS QUANTFUNCIONARIOS
FROM 
	FUNCIONARIOS AS F
	JOIN DEPARTAMENTOS AS D ON F.IDDepartamento = D.IDDepartamento
GROUP BY D.IDDepartamento
ORDER BY QUANTFUNCIONARIOS ASC;

/*
 * 11. Selecione o valor total dos salários dos Funcionários do Departamento Acadêmico de Informática, Ciências Humanas e Mecânica. Apresente o total por departamento;
 */

SELECT 
	D.NOME AS NOMEDEPARTAMENTO,
	SUM(Salario) AS SoldoPorDepartamento
FROM 
	FUNCIONARIOS AS F
	JOIN DEPARTAMENTOS AS D ON F.IDDepartamento = D.IDDepartamento
WHERE D.Nome IN ('Departamento de Ciência da Computação', 'Departamento de Ciências Humanas', 'Departamento de Medicina')
GROUP BY F.IDDepartamento
order by SoldoPorDepartamento ASC;

/*
 * 12. Selecione o nome e sigla do Departamento que possui o maior número de cursos;
 */

SELECT D.Nome, D.sigla, COUNT(*) AS QuantNoSetor
FROM DEPARTAMENTOS AS D JOIN CURSOS AS C ON D.IDDepartamento = C.IDDepartamento
GROUP BY C.IDDepartamento
HAVING COUNT(*) = (SELECT MAX(QUANT)
				   FROM (SELECT COUNT(*) AS QUANT
				   FROM CURSOS 
				   GROUP BY IDDepartamento) AS TESTE);

/*
 * 13. Selecione o nome do Departamento que possui o número de Funcionários acima da média de todos os demais Departamentos;
 */

SELECT D.Nome, D.IDDepartamento
FROM DEPARTAMENTOS AS D JOIN FUNCIONARIOS AS F ON D.IDDepartamento = F.IDDepartamento
GROUP BY D.IDDepartamento
HAVING COUNT(*) > (SELECT AVG(QUANT)
				   FROM (SELECT COUNT(*) AS QUANT
				   FROM FUNCIONARIOS 
				   GROUP BY IDDepartamento) AS TESTE);

/*
 * 14. Selecione a Sala e o Dia da Semana que NÃO teve nenhuma Alocação no mês de Abril de 2022 
 */

/*
 * 17. Excluir a Sala que nunca foi alocada;
 */

DELETE FROM SALAS
WHERE IDSALA = (SELECT IDSala
				FROM SALAS
				WHERE IDSala NOT IN (SELECT DISTINCT IDSala FROM ALOCACOES));

/*
 * 18. Incluir a coluna Data de Nascimento na tabela Funcionário;
 */

ALTER TABLE FUNCIONARIOS
DROP COLUMN DataAniversario;

/*
 * 19. Excluir a coluna Email da tabela Funcionário;
 */

ALTER TABLE FUNCIONARIOS
DROP COLUMN Email;

/*
 * 20. Apresente o comando DDL que permite criar um índice na tabela Departamento na coluna Sigla;
 */

ALTER TABLE DEPARTAMENTOS ADD INDEX IDX_SIGLA(Sigla);






CREATE VIEW VISAOGERAL 
 AS
    SELECT 
		S.SIGLA AS SiglaSala,
		S.TipoSala,
		E.Nome,
		E.QuantExistente,
		SE.QuantAlocada,
		A.DataAlocacao,
		A.DataTerminoReserva,
		(E.QuantExistente - SE.QuantAlocada) AS QuantNaoAlocada
    FROM
		EQUIPAMENTOS AS E
		JOIN SALAEQUIPAMENTO AS SE ON E.IDEQUIPAMENTO = SE.IDEQUIPAMENTO
		JOIN SALAS AS S ON SE.IDSala = S.IDSala
		JOIN ALOCACOES AS A ON S.IDSala = A.IDSala
	ORDER BY S.Sigla ASC;