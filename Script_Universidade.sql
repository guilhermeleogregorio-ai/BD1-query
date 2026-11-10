-- Criação das tabelas
CREATE TABLE Departamento (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
	id_prof_responsavel INT,
	UNIQUE(nome)
);

CREATE TABLE Curso (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(50),
	ano_criacao INT,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id),
	UNIQUE(nome)
);

CREATE TABLE Professor (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(100),
	salario NUMERIC(8,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id),
	CHECK(salario > 0),
	UNIQUE(email)
);

CREATE TABLE Disciplina (
    id INT PRIMARY KEY,
	sigla CHAR(4) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(80),
	creditos numeric(5,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id),
	UNIQUE(sigla)
);

CREATE TABLE Dependente (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE,
	grau_parentesco VARCHAR(10),
    id_professor INT,
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
	CHECK(grau_parentesco IN ('Cônjuge','Filho','Filha'))
);

CREATE TABLE Aluno (
    id INT PRIMARY KEY,
	RA VARCHAR(8) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
	sexo CHAR(1),
    email VARCHAR(100),
	ano_ingresso INT,
	semestre_ingresso INT,
	situacao VARCHAR(10),
    id_curso INT,
	UNIQUE(ra),
	UNIQUE(email),
	CHECK(sexo in ('M','F')),
	CHECK(situacao IN ('Cursando', 'Trancado', 'Transferido', 'Cancelado', 'Formado')),
    FOREIGN KEY (id_curso) REFERENCES Curso(id)
);

CREATE TABLE Turma (
    id INT PRIMARY KEY,
    ano INT NOT NULL,
    semestre INT NOT NULL,
    id_professor INT NOT NULL,
    id_disciplina INT NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES Professor(id),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id)
);

CREATE TABLE Disciplina_PreRequisito (
    id_disciplina INT,
    id_preRequisito INT,
    PRIMARY KEY (id_disciplina, id_prerequisito),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id),
    FOREIGN KEY (id_prerequisito) REFERENCES Disciplina(id)
);


CREATE TABLE Matriculado(
	id_turma int, 
	id_aluno int, 
	frequencia numeric(5,2), 
	media numeric(3,1),
	CHECK (frequencia >= 0),
	CHECK (media >= 0),
	PRIMARY KEY(id_turma, id_aluno),
	FOREIGN KEY (id_turma) REFERENCES Turma(id),
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id)
);

-- População das tabelas com dados fictícios
-- Departamentos
INSERT INTO Departamento (id, nome, id_prof_responsavel) VALUES
(1, 'Departamento de Computação', null),
(2, 'Departamento de Matemática', null),
(3, 'Departamento de Física', null);

-- Professores
INSERT INTO Professor (id, nome, data_nascimento, email, salario, id_departamento) VALUES
(1, 'Agnaldo Silva', '1980-05-15', 'agnaldo.silva@universidade.edu', 12580.75, 1),
(2, 'Lorena Domingues', '1975-10-20', 'lorena.domingues@universidade.edu', 9750.45, 2),
(3, 'Pietro Hanz', '1982-03-12', 'pietro.hanz@universidade.edu', 10713.1, 3),
(4, 'Adriana Santiago', '1978-08-25', 'adriana.santiago@universidade.edu', 15322.87, 1),
(5, 'Carlos Armando', '1987-12-30', 'carlos.armando@universidade.edu', 7425.4, 2),
(6, 'Ivone Conceição', '1984-06-18', 'ivone.conceicao@universidade.edu', 9430.7, 3),
(7, 'Miguel Francesco', '1976-04-02', 'miguel.francesco@universidade.edu', 5200.9, 1),
(8, 'Fabiana Vieira', '1973-09-08', 'fabiana.vieira@universidade.edu', 11422.6, 2),
(9, 'Domênico Lemos', null, 'domenico.lemos@universidade.edu', 8725.5, 3),
(10, 'Eva Terranova', '1979-07-14', null, 9518.35, 1);

update departamento set id_prof_responsavel = 4 where id = 1;
update departamento set id_prof_responsavel = 8 where id = 2;

-- Cursos
INSERT INTO Curso (id, nome, descricao, ano_criacao, id_departamento) VALUES
(1, 'Ciência da Computação', 'Curso de graduação em Ciência da Computação', 1980, 1),
(2, 'Licenciatura em Matemática', 'Curso de graduação em Matemática', 1965, 2),
(3, 'Licenciatura em Física', 'Curso de graduação em Física', 1972, 3);

-- Disciplinas
INSERT INTO Disciplina (id, sigla, nome, descricao, creditos, id_departamento) VALUES
(1, 'PRG1', 'Programação I', 'Introdução à programação em linguagem C', 100, 1),
(2, 'CAL1', 'Cálculo I', 'Cálculo diferencial e integral', 80, 2),
(3, 'FIS1', 'Física I', 'Mecânica clássica', 60, 3),
(4, 'ESDD', 'Estrutura de Dados', 'Estruturas de dados lineares e não-lineares', 80, 1),
(5, 'AGLI', 'Álgebra Linear', 'Álgebra vetorial e matricial', 80, 2),
(6, 'FIS2', 'Física II', 'Eletromagnetismo e óptica', 60, 3),
(7, 'BDD1', 'Banco de Dados I', 'Modelagem e implementação de banco de dados', 80, 1),
(8, 'GEAN', 'Geometria Analítica', 'Geometria analítica no plano e no espaço', 40, 2),
(9, 'FIS3', 'Física III', 'Física moderna', 40, 3),
(10, 'BDD2', 'Banco de Dados II', 'Administração de Banco de Dados', 80, 1);

-- Dependentes
INSERT INTO Dependente (id, nome, data_nascimento, grau_parentesco, id_professor) VALUES
(1, 'Lucas Silva', '2015-02-10', 'Filho', 1),
(2, 'Isabela Domingues', '2012-07-20', 'Filha', 2),
(3, 'Gustavo Hanz', '2013-11-15', 'Filho', 3),
(4, 'Carolina Silva', '1983-04-05', 'Cônjuge', 1),
(5, 'Luiza Armando', '1988-09-30', 'Cônjuge', 5),
(6, 'Ricardo Domingues', '1970-06-18', 'Cônjuge', 2),
(7, 'Mariana Vieira', '2015-03-22', 'Filha', 8),
(8, 'Pedro Vieira', '2019-08-12', 'Filho', 8);

-- Disciplina_PreRequisito
INSERT INTO Disciplina_PreRequisito(id_disciplina, id_prerequisito) values
(4, 1),
(5, 8),
(6, 3),
(9, 6),
(10, 1),
(10, 7);

-- Alunos
INSERT INTO Aluno (id, ra, nome, data_nascimento, sexo, email, ano_ingresso, semestre_ingresso, situacao, id_curso) VALUES
(1, '20220001', 'Fernando Silva', '2003-07-15', 'M', 'fernando.silva@gmail.com', 2022, 1, 'Cursando', 1),
(2, '20190001', 'Carla Santos', '2003-08-27', 'F', 'carla.santos@yahoo.com', 2019, 1, 'Formado', 1),
(3, '20210001', 'Mateus Oliveira', '2003-12-12', 'M', 'mateus.oliveira@outlook.com', 2021, 1, 'Cursando', 2),
(4, '20200001', 'Patrícia Souza', '2003-06-29', 'F', 'patricia.souza@gmail.com', 2020, 2, 'Cursando', 2),
(5, '20240001', 'Rodrigo Lima', '2003-10-01', 'M', 'rodrigo.lima@yahoo.com', 2024, 1, 'Cursando', 3),
(6, '20240002', 'Ana Costa', '2003-07-11', 'F', 'ana.costa@gmail.com', 2024, 2, 'Cursando', 3),
(7, '20220002', 'Gabriel Pereira', '2003-05-02', 'M', 'gabriel.pereira@yahoo.com', 2022, 1, 'Cursando', 1),
(8, '20210002', 'Amanda Ferreira', '2003-11-08', 'F', 'amanda.ferreira@gmail.com', 2021, 2, 'Cursando', 1),
(9, '20230001', 'Paulo Almeida', '2003-02-17', 'M', 'paulo.almeida@outlook.com', 2023, 1, 'Cursando', 2),
(10, '20200003', 'Júlia Gonçalves', '2003-01-30', 'F', 'julia.goncalves@gmail.com', 2020, 1, 'Formado', 2),
(11, '20220003', 'Lucas Barbosa', '2003-08-12', 'M', 'lucas.barbosa@yahoo.com', 2022, 2, 'Cursando', 3),
(12, '20240003', 'Mariana Rocha', null, 'F', 'mariana.rocha@gmail.com', 2024, 1, 'Cursando', 3),
(13, '20210003', 'Diego Costa', '2001-07-01', 'M', 'diego.costa@outlook.com', 2021, 1, 'Cursando', 1),
(14, '20230002', 'Letícia Lima', '2004-02-24', 'F', 'leticia.lima@gmail.com', 2023, 2, 'Cursando', 1),
(15, '20200004', 'Thiago Oliveira', '2003-09-30', 'M', 'thiago.oliveira@yahoo.com', 2020, 1, 'Formado', 2),
(16, '20240004', 'Larissa Santos', '2003-08-06', 'F', 'larissa.santos@gmail.com', 2024, 1, 'Cursando', 2),
(17, '20210004', 'Victor Alves', '2000-11-02', 'M', 'victor.alves@yahoo.com', 2021, 2, 'Cursando', 3),
(18, '20220004', 'Camila Fernandes', '2003-06-22', 'F', 'camila.fernandes@gmail.com', 2022, 1, 'Cursando', 3),
(19, '20230003', 'Vinícius Nogueira', '2004-09-18', 'M', 'vinicius.nogueira@outlook.com', 2023, 2, 'Cursando', 1),
(20, '20200005', 'Juliana Martins', '2002-06-14', 'F', 'juliana.martins@gmail.com', 2020, 1, 'Cursando', 1),
(21, '20230004', 'Rafaela Costa', '2003-04-30', null, 'rafaela.costa@yahoo.com', 2023, 1, 'Cursando', 2),
(22, '20240005', 'André Silva', '2001-02-15', 'M', 'andre.silva@gmail.com', 2024, 2, 'Cursando', 2),
(23, '20230005', 'Renata Oliveira', '2002-12-27', 'F', 'renata.oliveira@outlook.com', 2023, 1, 'Cursando', 3),
(24, '20220005', 'Bruno Pereira', '2003-02-16', 'M', 'bruno.pereira@gmail.com', 2022, 2, 'Cursando', 3),
(25, '20220006', 'Eduardo Ferreira', '2001-04-02', 'M', 'eduardo.ferreira@yahoo.com', 2022, 1, 'Cursando', 1),
(26, '20240006', 'Ana Clara Almeida', '2003-12-08', 'F', 'anaclara.almeida@gmail.com', 2024, 1, 'Cursando', 1),
(27, '20210005', 'Fábio Martins', '2003-05-19', 'M', 'fabio.martins@outlook.com', 2021, 2, 'Cursando', 2),
(28, '20200006', 'Isabela Barbosa', '2002-08-30', 'F', 'isabela.barbosa@gmail.com', 2020, 1, 'Cursando', 2),
(29, '20230006', 'Felipe Gonçalves', '2002-09-02', 'M', 'felipe.goncalves@yahoo.com', 2023, 1, 'Trancado', 3),
(30, '20220007', 'Laura Alves', '2003-10-20', 'F', 'laura.alves@gmail.com', 2022, 2, 'Cursando', 3),
(31, '20200007', 'Gustavo Rocha', '2003-01-15', 'M', 'gustavo.rocha@yahoo.com', 2020, 2, 'Cursando', 1),
(32, '20210006', 'Mariana Costa', '2003-07-12', 'F', null, 2021, 1, 'Cursando', 1),
(33, '20220008', 'Pedro Lima', '2002-01-30', 'M', 'pedro.lima@yahoo.com', 2022, 1, 'Cursando', 2),
(34, '20240007', 'Carolina Fernandes', '2002-07-15', 'F', 'carolina.fernandes@gmail.com', 2024, 2, 'Cursando', 2),
(35, '20210007', 'Daniel Oliveira', '2002-02-02', 'M', 'daniel.oliveira@yahoo.com', 2021, 2, 'Trancado', 3),
(36, '20220009', 'Beatriz Nogueira', '2003-04-18', 'F', 'beatriz.nogueira@gmail.com', 2022, 1, 'Cursando', 3),
(37, '20230007', 'Lucas Silva', '2003-09-01', 'M', null, 2023, 2, 'Cursando', 1),
(38, '20200008', 'Amanda Santos', '2002-07-08', 'F', 'amanda.santos@gmail.com', 2020, 1, 'Cursando', 1),
(39, '20210008', 'Paulo Oliveira', '2001-06-26', 'M', 'paulo.oliveira@yahoo.com', 2021, 1, 'Cursando', 2),
(40, '20240008', 'Júlia Souza', '2002-02-02', 'F', 'julia.souza@gmail.com', 2024, 2, 'Cursando', 2),
(41, '20230008', 'Lucas Lima', '2003-11-12', 'M', 'lucas.lima@gmail.com', 2023, 1, 'Cursando', 3),
(42, '20220010', 'Mariana Costa', '2003-01-22', 'F', 'mariana.costa@gmail.com', 2022, 2, 'Cursando', 3),
(43, '20220011', 'Diego Silva', '2001-10-18', 'M', null, 2022, 1, 'Cursando', 1),
(44, '20240009', 'Letícia Oliveira', '2002-11-14', 'F', 'leticia.oliveira@gmail.com', 2024, 2, 'Trancado', 1),
(45, '20210009', 'Thiago Santos', '2002-03-30', 'M', 'thiago.santos@yahoo.com', 2021, 2, 'Cursando', 2),
(46, '20230009', 'Larissa Lima', '2001-04-15', 'F', 'larissa.lima@gmail.com', 2023, 1, 'Cursando', 2),
(47, '20220012', 'Victor Oliveira', '2003-11-27', 'M', 'victor.oliveira@yahoo.com', 2022, 1, 'Cursando', 3),
(48, '20220013', 'Camila Souza', '2001-10-12', 'F', 'camila.souza@gmail.com', 2022, 2, 'Cursando', 3),
(49, '20240010', 'Vinícius Lima', '2002-01-02', 'M', null, 2024, 1, 'Cursando', 1),
(50, '20240011', 'Juliana Costa', '2003-10-18', 'F', 'juliana.costa@gmail.com', 2024, 2, 'Cursando', 1);

-- Turmas
INSERT INTO Turma (id, ano, semestre, id_professor, id_disciplina) VALUES
(1, 2024, 1, 1, 7),
(2, 2024, 1, 2, 2),
(3, 2024, 1, 3, 1),
(4, 2024, 1, 4, 8),
(5, 2024, 1, 5, 3),
(6, 2024, 1, 6, 6),
(7, 2024, 1, 7, 4);

-- Matriculado
INSERT INTO Matriculado(id_turma, id_aluno, frequencia, media) VALUES
(1, 1, 100.0, 9.5),
(1, 7, 88.5, 8.2),
(1, 8, 27.2, 2.5),
(1, 13, 75.0, 6.5),
(1, 20, 80.5, 7.0),
(1, 25, 79.2, 5.5),
(1, 31, 92.0, 6.8),
(1, 32, 100.0, 9.0),
(1, 38, 95.5, 7.8),
(3, 49, 90.5, 7.4),
(3, 50, 100.0, 8.2),
(3, 26, 78.0, 4.0),
(3, 1, 50.0, 5.5),
(3, 14, 70.0, 0.0),
(3, 19, 84.3, 6.5),
(3, 7, 91.5, 7.2),
(3, 38, 100.0, 9.1),
(3, 37, 82.4, 7.5),
(3, 25, 94.0, 8.0),
(3, 13, 80.0, 2.0),
(7, 1, 75.0, 7.5),
(7, 14, 55.0, 3.0),
(7, 32, 90.0, 8.5),
(7, 50, 79.2, 9.0),
(7, 49, 90.0, 5.0),
(7, 13, 86.5, 10.0),
(7, 20, 100.0, 9.4),
(7, 37, 0.0, 0.0),
(7, 25, 85.0, 6.0),
(7, 26, 73.4, 6.8),
(2, 3, 100.0, 8.5),
(2, 4, 92.5, 7.0),
(2, 9, 20.0, 0.5),
(2, 16, 75.0, 6.0),
(2, 21, 86.0, 4.5),
(2, 22, 79.0, 5.0),
(2, 27, 98.0, 8.0),
(2, 28, 100.0, 8.8),
(4, 33, 45.0, 3.0),
(4, 34, 78.0, 5.0),
(4, 39, 100.0, 8.0),
(4, 40, 95.0, 7.5),
(4, 45, 80.0, 6.5),
(4, 22, 60.0, 0.0),
(4, 9, 78.0, 7.9),
(4, 16, 100.0, 9.0),
(6, 5, 80.5, 8.5),
(6, 11, 100.0, 9.0),
(6, 12, 100.0, 7.8),
(6, 18, 0.0, 0.0),
(6, 23, 75.0, 6.0),
(6, 24, 90.5, 7.8),
(6, 30, 100.0, 10.0),
(6, 36, 88.5, 6.5),
(6, 42, 79.0, 7.5),
(6, 47, 90.0, 8.0);

select * from professor;
select * from dependente;
select * from departamento;
select * from curso;
select * from disciplina;
select * from disciplina_prerequisito;
select * from aluno;
select * from turma;
select * from matriculado;
