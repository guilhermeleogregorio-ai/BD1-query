CREATE TABLE equipe(
	id SMALLINT,
	nome VARCHAR(30) NOT NULL,
	CONSTRAINT equipe_pk PRIMARY KEY (id)
);


CREATE TABLE jogador(
	id 	SMALLINT,
	nome VARCHAR(50) NOT NULL,
	cpf VARCHAR(14) UNIQUE,
	data_nasc DATE,
	salario NUMERIC (8,2),
	id_equipe SMALLINT,
	CONSTRAINT jogador_pk PRIMARY KEY(id),
	CONSTRAINT salario_ck CHECK (salario > 0),
	CONSTRAINT id_equipe_fk FOREIGN KEY (id_equipe) REFERENCES equipe(id)
);


--1. Insira 4 equipes, sendo os IDs 10, 20, 30 e 40. Pode colocar os nomes que desejar.
INSERT INTO equipe(id,nome) VALUES (10,'A'),(20,'B'),(30,'C'),(40,'D');
SELECT * FROM equipe;


/*2. Insira 6 jogadores, sendo os IDs 1, 2, 3, 4, 5 e 6. Pode utilizar os demais
atributos como bem entender. Entretanto, os jogadores 1 e 4 devem
pertencer à equipe 10, o jogador 2 à equipe 20 e o jogador 3 à equipe 30.
Os jogadores 5 e 6 deve ficar SEM equipes.*/
INSERT INTO jogador(id,nome,cpf,data_nasc,salario,id_equipe) VALUES
	(1,'GUILHERME','501.366.789-58','04/09/2001',3000,10),
	(2,'PEDRO','456.987.569-95','05/10/2000',5000,20),
	(3,'LEANDRO','502.987.651-96','06/05/2002',4000,30),
	(4,'JORGE','564.987.564-98','06/08/2001',3500,10),
	(5,'MARIO','213.323.321-12','07/02/2001',4000,NULL),
	(6,'LUCAS','401.465.548-89','04/04/2003',5000,NULL);

--3. Adicione a coluna CONTATO à tabela JOGADOR. Pode ser VARCHAR(30).
ALTER TABLE jogador ADD contato VARCHAR(30);

--4. Consulte os dados das tabelas.
SELECT * FROM jogador;
SELECT * FROM equipe;

--5. Atualize a equipe do jogador 6 para a equipe de ID 20.
UPDATE jogador SET id_equipe = 20 WHERE id = 6;
SELECT * FROM jogador , equipe;

SELECT j.*, e.nome AS nome_equipe 
FROM jogador j 
LEFT JOIN equipe e ON j.id_equipe = e.id;

--6. Modifique também o contato de dois jogadores quaisquer.
UPDATE jogador SET contato = '16997304598' WHERE id = 1;
UPDATE jogador SET contato = '16998979596' WHERE id = 4;

--7. Altere o nome da equipe 40.
UPDATE equipe SET nome = 'N/A' WHERE id = 40;

--8. Modifique a data de nascimento (pode colocar qualquer uma) dos jogadores que ganharem mais do que 3000 e que sejam das equipes 10, 20 ou 30.
UPDATE jogador SET data_nasc = '10/05/2001' WHERE salario > 3000 AND id_equipe  in (10,20,30);

--9. Tente eliminar a equipe de ID 40. Deu certo? R: Sim.
DELETE FROM equipe WHERE id = 40;

--10.Tente agora eliminar a equipe de ID 20. Deu certo? R: Não, viola restrição de chave estrangeira "id_equipe_fk" em "jogador".
DELETE FROM equipe WHERE id = 20;

--11. Modifique a regra de remoção da FK na tabela JOGADOR que referencia a tabela EQUIPE, colocando em modo CASCATA.
ALTER TABLE jogador DROP CONSTRAINT id_equipe_fk;
ALTER TABLE jogador ADD CONSTRAINT id_equipe_fk FOREIGN KEY (id_equipe) REFERENCES equipe(id) ON DELETE CASCADE;

--12. Agora tente eliminar novamente a equipe de ID 20. O que aconteceu? R: Removeu.
DELETE FROM equipe WHERE id = 20;

--13. Elimine o jogador de ID 1. Deu certo? R:  Removeu.
DELETE FROM jogador WHERE id = 1;

--14. Volte a regra de remoção da FK na tabela JOGADOR para o modo padrão.
ALTER TABLE jogador DROP CONSTRAINT id_equipe_fk;
ALTER TABLE jogador ADD CONSTRAINT is_equipe_fk  FOREIGN KEY (id_equipe) REFERENCES equipe(id);

--15. Tente eliminar a tabela EQUIPE. Deu certo? R: Não.
DELETE FROM equipe;

--16. Elimine a tabela JOGADOR;
DELETE FROM jogador;

--17. Elimine a tabela EQUIPE;
DELETE FROM equipe;

--18. Elimine a base de dados CLUBE;
DROP DATABASE  clube; 
