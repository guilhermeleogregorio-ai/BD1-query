--1. Crie a base de dados Empresa e, em seguida, conecte-se nela; (criado fora)
--2. Crie as tabelas de acordo com Modelo Relacional, colocando todas as constraints necessárias (primary key, not null, unique, check, foreign key);
CREATE TABLE departamento(
	numero INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(20),
	qtde_empregados INTEGER,
	codigo_ger INTEGER ,
	data_inicio_ger DATE,
	CONSTRAINT departamento_pk FOREIGN KEY (codigo_ger) REFERENCES empregado(codigo)
);

CREATE TABLE empregado(
	codigo INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	cpf	VARCHAR(14) UNIQUE,
	sexo CHAR(1),
	data_nasc DATE ,
	nome VARCHAR(40),
	salario NUMERIC(8,2),
	logradouro VARCHAR(40),
	numero INTEGER,
	codigo_ger INTEGER,
	depto_num INTEGER,
	CONSTRAINT emp_sexo_ck CHECK (sexo in ('M','F','m','f'))
);
ALTER TABLE empregado ADD CONSTRAINT empregado_ger_fk FOREIGN KEY (codigo_ger) REFERENCES empregado(codigo);
ALTER TABLE empregado ADD CONSTRAINT empregado_fk FOREIGN KEY (depto_num) REFERENCES departamento(numero);

CREATE TABLE projeto(
	numero INTEGER primary key GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(40),
	localizacao VARCHAR(80),
	num_dep INTEGER,
 	CONSTRAINT projeto_pk FOREIGN KEY(num_dep) REFERENCES departamento(numero)
);

CREATE TABLE dependente(
	codigo_emp INTEGER,
	nome VARCHAR(40),
	cpf VARCHAR(14),
	sexo CHAR(1),
	parentesco VARCHAR(20),
	data_nasc DATE,
	CONSTRAINT dependente_pk PRIMARY KEY (codigo_emp,nome),
	CONSTRAINT dependente_fk FOREIGN KEY(codigo_emp) REFERENCES empregado(codigo),
	CONSTRAINT dep_sexo_ck CHECK (sexo in ('F','M','f','m'))
);



CREATE TABLE depto_local(
	depto_num INTEGER,
	localizacao VARCHAR(80),
	CONSTRAINT depto_num_pk PRIMARY KEY (depto_num,localizacao),
	CONSTRAINT depto_fk FOREIGN KEY(depto_num) REFERENCES departamento(numero)
);


CREATE TABLE trabalha_em(
	codigo_emp INTEGER,
	projeto_num INTEGER,
	horas NUMERIC(5,2),
	CONSTRAINT tabalha_em_pk PRIMARY KEY (codigo_emp,projeto_num),
	CONSTRAINT projeto_num_fk FOREIGN KEY(projeto_num ) REFERENCES projeto(numero),
	CONSTRAINT codigo_emp_fk FOREIGN KEY(codigo_emp ) REFERENCES empregado (codigo)
);


--2,5. Treinar constraints na criação das tabelas
--Checklist de constraints 0 de 6
--PRIMARY KEY
--Tente inserir duas linhas em DEPTO_LOCAL com a mesma combinação de depto_num e localizacao. Confira o erro
INSERT INTO departamento(nome,qtde_empregados) 
VALUES('Producao',10);
SELECT * FROM departamento;
INSERT INTO depto_local(depto_num,localizacao) VALUES (1,'Sao carlos');
INSERT INTO depto_local(depto_num,localizacao) VALUES(1,'Sao carlos');
--FOREIGN KEY
--Tente cadastrar um PROJETO com num_dep apontando para um departamento inexistente.
INSERT INTO projeto(nome,localizacao,num_dep) VALUES ('ATLAS','SAO CARLOS',2);
--NOT NULL
--Escolha nome em DEPARTAMENTO e cpf em EMPREGADO para serem obrigatórios. Teste inserir NULL.
ALTER TABLE departamento ALTER nome SET NOT NULL;
ALTER TABLE empregado ALTER cpf SET NOT NULL;
INSERT INTO departamento(nome,qtde_empregados) VALUES (NULL,'10');
--UNIQUE
--Tente cadastrar dois empregados com o mesmo CPF. Depois teste o que acontece com dois valores NULL.
INSERT INTO empregado(cpf,sexo,data_nasc,nome,salario,logradouro,numero,depto_num) 
VALUES ('501.377.499.58','M','10/09/2001','PEDRO',3000,'Rua miguel peixoto',505,1);
INSERT INTO empregado(cpf,sexo,data_nasc,nome,salario,logradouro,numero,depto_num) 
VALUES ('501.377.499.58','M','10/10/2001','jorge',3000,'Rua amadel',100,1); 
INSERT INTO empregado(cpf,sexo,data_nasc,nome,salario,logradouro,numero,depto_num)
VALUES ('null','f','10/02/2000','Vanessa',9000,'Rua joaquim',373,1);
INSERT INTO empregado(cpf,sexo,data_nasc,nome,salario,logradouro,numero,depto_num)
VALUES ('null','f','09/01/2000','isabela',5000,'Rua santa',1002,1);
--CHECK
--Insira um empregado com sexo = 'X'. Depois teste os valores aceitos pela sua constraint.
INSERT INTO empregado (cpf,sexo,data_nasc,nome,salario,logradouro,numero,depto_num)
VALUES('201.898.445.88','X','05/04/2003','julia',2000,'Rua marechal', 105,1);
--DEFAULT
--Escolha uma coluna apropriada, defina um valor padrão e insira uma linha sem informar essa coluna.
ALTER TABLE depto_local ALTER localizacao DEFAULT 'Sao Carlos';

--3. Modifique a estrutura de algumas tabelas, adicionando e removendo colunas, modificando seus domínios, renomeando colunas, colocando e modificando valores default;
ALTER TABLE empregado ADD COLUMN genero VARCHAR(50);
ALTER TABLE departamento ADD COLUMN medalhas INTEGER;
ALTER TABLE empregado ADD COLUMN voto_presidente VARCHAR(20);
ALTER TABLE empregado DROP COLUMN voto_presidente;
ALTER TABLE empregado ALTER numero TYPE VARCHAR(10); 
ALTER TABLE empregado ALTER numero TYPE INTEGER;
ALTER TABLE empregado ALTER COLUMN numero TYPE integer USING numero::integer;
UPDATE departamento  SET nome = 'Produx' WHERE numero = 1;
UPDATE empregado SET nome = 'Mateus' WHERE numero = 1;
UPDATE empregado SET cpf = '501.656.989.66' WHERE numero = 6;
UPDATE depto_local SET localizacao = 'Araras' where depto_num = 2;

--4. Apague e recrie algumas constraints. Dentre elas altere colunas NOT NULL para NULL e vice-versa.
ALTER TABLE empregado DROP CONSTRAINT empregado_ger_fk ;
ALTER TABLE empregado ADD CONSTRAINT empregado_ger_fk FOREIGN KEY(codigo_ger) REFERENCES empregado(codigo);
ALTER TABLE departamento DROP CONSTRAINT  departamento_pk;
ALTER TABLE departamento ADD CONSTRAINT departamento_pk FOREIGN KEY(codigo_ger) REFERENCES empregado(codigo);
ALTER TABLE empregado ALTER cpf DROP NOT NULL;
ALTER TABLE empregado ALTER cpf SET NOT NULL;

--5. Insira dados nas tabelas (pelo menos 5 tuplas em cada);
INSERT INTO departamento(nome,qtde_empregados) 
VALUES('Abner',50);
UPDATE departamento SET nome = 'MECANICA' WHERE numero = 3;
INSERT INTO departamento(nome,qtde_empregados)
VALUES('juliana',100);
UPDATE departamento SET nome ='QUALIDADE' WHERE numero = 4;
INSERT INTO departamento(nome,qtde_empregados)
VALUES('DEPOSITO',50);
INSERT INTO departamento (nome,qtde_empregados)
VALUES ('ELETRICA',50);
SELECT * FROM departamento;

INSERT INTO empregado(cpf,sexo,data_nasc,nome,salario,logradouro,numero,genero)
VALUES('154.646.998.56','F','20/10/2000','VALERIA',6000,'rua Capital',1023,'hetero');
INSERT INTO empregado(cpf,sexo,data_nasc,nome,salario,logradouro,numero,genero)
VALUES ('501.656.323.23','f','20/05/2005','Martina',4000,'Rua maralia',100,'homossexual');
UPDATE empregado SET cpf = '501.656.323.23' where codigo = 11;
INSERT INTO empregado(cpf,sexo,data_nasc,salario,logradouro,numero,genero)
VALUES ('454.565.546.66','m','10/10/2010',2000,'Rua marechal',1002,NULL);
INSERT INTO empregado(cpf,sexo,data_nasc,salario)
VALUES ('514.545.454.45','m','05/08/2004',5000);
SELECT * FROM empregado;

INSERT INTO projeto(nome,localizacao,num_dep)
VALUES('Melhorias','Sao carlos',3);
INSERT INTO projeto(nome,localizacao,num_dep)
VALUES ('QUALIDADE SEM IGUAL', 'SAO PAULO',4);
INSERT INTO projeto(nome,localizacao,num_dep)
VALUES ('Sem gambiarra','SAO PAULO',6);
INSERT INTO projeto(nome,localizacao,num_dep)
VALUES('Menos refudo','Sao carlos',1);
INSERT INTO projeto(nome,localizacao,num_dep)
SELECT * FROM projeto;

SELECT * FROM empregado;
INSERT INTO dependente(codigo_emp,nome,cpf,sexo,parentesco,data_nasc)
VALUES (11,'leo','112.121.212.22','m','filho','10/10/2024');
INSERT INTO dependente(codigo_emp,nome,cpf,sexo,parentesco,data_nasc)
VALUES (1,'MARIO','454.555.555.55','m','filho','10/05/2022');
INSERT INTO dependente(codigo_emp,nome,cpf,sexo,parentesco,data_nasc)
VALUES(4,'Maria','688.888.888.88','f','filha','04/04/2025');
INSERT INTO dependente(codigo_emp,nome,cpf,sexo,parentesco,data_nasc)
VALUES (1,'maria','999.999.991.99','f','filha','04/01/2015');
INSERT INTO dependente(codigo_emp,nome,cpf,sexo,parentesco,data_nasc)
VALUES (8,'Matheus','444.444.444.44','m','irmao','07/02/2020');
SELECT * FROM dependente;

SELECT * FROM departamento;
INSERT INTO depto_local(depto_num,localizacao)
VALUES (4,'SAO CARLOS');
INSERT INTO depto_local(depto_num,localizacao)
VALUES (3,'SAO PAULO');
INSERT INTO depto_local(depto_num,localizacao)
VALUES(5,'SAO PAULO');
SELECT * FROM depto_local;


SELECT 
    e.codigo AS codigo_do_empregado, 
    e.nome AS nome_do_empregado,
    p.numero AS numero_do_projeto, 
    p.nome AS nome_do_projeto
FROM empregado e
CROSS JOIN projeto p
ORDER BY e.nome, p.nome;
INSERT INTO trabalha_em(codigo_emp,projeto_num,horas)
VALUES (1,5,8);
INSERT INTO trabalha_em(codigo_emp,projeto_num,horas)
VALUES (1,7,12);
INSERT INTO trabalha_em(codigo_emp,projeto_num,horas)
VALUES (11,4,12);
INSERT INTO trabalha_em(codigo_emp,projeto_num,horas)
VALUES (11,8,5);
INSERT INTO trabalha_em(codigo_emp,projeto_num,horas)
VALUES (4,6,10);
INSERT INTO trabalha_em(codigo_emp,projeto_num,horas)
VALUES (4,8,5);
SELECT * FROM trabalha_em;


--6. Altere valores de algumas tuplas das tabelas;
UPDATE trabalha_em SET horas = 10 WHERE codigo_emp = 1; 
UPDATE trabalha_em SET horas = 5 WHERE codigo_emp = 1 AND projeto_num = 5;
UPDATE trabalha_em SET horas = 6 WHERE codigo_emp = 11 AND projeto_num = 4;
UPDATE empregado SET nome = 'gabriel' WHERE codigo = 9;
UPDATE empregado SET nome = 'jorge' WHERE codigo = 10;
UPDATE empregado SET logradouro = 'Rua aquidaban' WHERE codigo = 10;
UPDATE empregado SET numero = 154 WHERE codigo = 10; 

--7. Remova dados das tabelas;
UPDATE empregado SET genero = NULL WHERE codigo = 8 AND codigo = 11;
UPDATE dependente SET parentesco = NULL WHERE codigo_emp = 1; 

--8. Consulte os dados das tabelas.
SELECT * FROM departamento;
SELECT * FROM empregado;
SELECT * FROM dependente;
SELECT * FROM projeto;
SELECT * FROM depto_local;
SELECT * FROM trabalha_em;
--9. Modifique a regra de deleção de alguma foreign key para o modo cascata. Faça testes ao excluir tuplas.
ALTER TABLE departamento DROP CONSTRAINT departamento_pk;
ALTER TABLE departamento ADD CONSTRAINT  departamento_pk FOREIGN KEY (codigo_ger) REFERENCES empregado(codigo) ON DELETE CASCADE;
ALTER TABLE empregado DROP CONSTRAINT empregado_ger_fk;
ALTER TABLE empregado ADD CONSTRAINT empregado_ger_fk FOREIGN KEY (codigo_ger) REFERENCES empregado(codigo) ON DELETE CASCADE;
ALTER TABLE empregado DROP CONSTRAINT empregado_fk;
ALTER TABLE empregado ADD CONSTRAINT empregado_fk FOREIGN KEY(depto_num) REFERENCES departamento(numero);
ALTER TABLE projeto DROP CONSTRAINT projeto_pk;
ALTER TABLE projeto ADD CONSTRAINT projeto_pk FOREIGN KEY(num_dep) REFERENCES departamento(numero) ON DELETE CASCADE; 
ALTER TABLE dependente DROP CONSTRAINT dependente_fk;
ALTER TABLE dependente ADD CONSTRAINT dependente_fk FOREIGN KEY(codigo_emp) REFERENCES empregado(codigo) ON DELETE CASCADE;
ALTER TABLE depto_local DROP CONSTRAINT depto_fk;
ALTER TABLE depto_local ADD CONSTRAINT depto_fk FOREIGN KEY(depto_num) REFERENCES departamento(numero) ON DELETE CASCADE;
ALTER TABLE trabalha_em DROP CONSTRAINT projeto_num_fk;
ALTER TABLE trabalha_em ADD CONSTRAINT projeto_num_fk FOREIGN KEY(projeto_num) REFERENCES projeto(numero) ON DELETE CASCADE;
ALTER TABLE trabalha_em DROP CONSTRAINT codigo_emp_fk;
ALTER TABLE trabalha_em ADD CONSTRAINT codigo_emp_fk FOREIGN KEY(codigo_emp) REFERENCES empregado(codigo) ON DELETE CASCADE;

--10. Apague algumas tabelas.
DROP TABLE departamento;
DROP TABLE departamento CASCADE;
DROP TABLE empregado;
DROP TABLE empregado CASCADE;
DROP TABLE projeto;
DROP TABLE projeto CASCADE;
DROP TABLE dependente;
DROP TABLE depto_local;
DROP TABLE trabalha_em;





