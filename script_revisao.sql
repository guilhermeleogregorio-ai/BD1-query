CREATE TABLE equipe(
	ID SMALLINT,
	NOME VARCHAR(30) NOT NULL,
	CONSTRAINT id_equipe PRIMARY KEY (id)
);
	
CREATE TABLE jogador(
	ID INT,
	NOME VARCHAR(50) NOT NULL,
	CPF VARCHAR(14) UNIQUE,
	DATA_NASC DATE,
	SALARIO NUMERIC(8,2),
	ID_EQUIPE SMALLINT,
	CONSTRAINT jogador_pk primary key(id),
	CONSTRAINT salario_ck check (salario > 0),
	CONSTRAINT jogador_equipe_fk FOREIGN KEY (id_equipe) REFERENCES equipe(id)
);

--3. Modifique a estrutua da tabelas JOGADOR, adicionando a coluna CONTATO, do tipo VARCHAR de tamanho 10;
ALTER TABLE jogador ADD contato VARCHAR(10);

--4. Modifique a coluna CONTATO da tabela JOGADOR, passando para o tipo VARCHAR de tamanho 20;
ALTER TABLE jogador ALTER contato TYPE  VARCHAR(20);

--5. Renomeie a coluna CONTATO da tabela JOGADOR para TELEFONE;
ALTER TABLE jogador RENAME contato TO telefone;

--6. Adicione a coluna EMAIL à tabela JOGADOR, sendo uma coluna de texto variável com tamanho máximo 60 caracteres;
ALTER TABLE jogador ADD email VARCHAR(60);

--7. Elimine a coluna EMAIL criada no passo anterior da tabela JOGADOR;
ALTER TABLE jogador DROP email;

--8. Adicione a coluna Estado à tabela Equipe, do tipo CHAR de tamanho 2;
ALTER TABLE equipe ADD  estado CHAR(2);

--9. Altere a coluna Estado criada para que seu valor default seja ‘SP’;
ALTER TABLE equipe ALTER estado SET DEFAULT('SP');

--10. Adicione uma constraint do tipo CHECK à coluna Estado de modo que permita apenas os valores ‘SP’, ‘RJ’, ‘MG’ ou ‘ES’.
ALTER TABLE equipe ADD CONSTRAINT equipe_check CHECK (estado in ('SP', 'RJ', 'MG' , 'ES'));

--11. Apague a constraint do tipo CHECK criada para a coluna Salário. E recrie-a permitindo apenas salários superiores a 1000.
ALTER TABLE	jogador DROP CONSTRAINT salario_ck;
ALTER TABLE jogador ADD CONSTRAINT salario_ck CHECK(salario < 1000);

--12. Apague a primary key da tabela Jogador. Depois, recrie-a com o nome PK_Jogador.
ALTER TABLE jogador DROP CONSTRAINT jogador_pk;
ALTER TABLE jogador ADD CONSTRAINT PK_jogador primary key (id);

--13. Remova a constraint NOT NULL da coluna Nome da tabela Equipe.
ALTER TABLE jogador ALTER nome DROP NOT NULL;

--14. Crie a tabela TREINADOR:
CREATE TABLE treinador(
	ID INTEGER,
	NOME VARCHAR(30),
	CONSTRAINT treinador_pk primary key(id)
);

--15. Modifique a coluna NOME da tabela TREINADOR, passando para o tipo VARCHAR de tamanho 40;
ALTER TABLE treinador ALTER nome TYPE VARCHAR(40);

--16. Adicione as constraints UNIQUE (dê um nome a ela) e NOT NULL (não precisa de nome) à coluna NOME da tabela TREINADOR.
ALTER TABLE treinador ADD CONSTRAINT nome_uk UNIQUE(nome);
ALTER TABLE treinador ALTER COLUMN nome SET NOT NULL;


--17. Adicione a coluna ID_TREINADOR à tabela EQUIPE como sendo uma FK referenciando a tabela TREINADOR.
ALTER TABLE equipe ADD COLUMN id_treinador INTEGER;
ALTER TABLE equipe ADD CONSTRAINT fk_id_treinador FOREIGN KEY(id_treinador) REFERENCES treinador(id);

--18. Remova a tabela TREINADOR;
ALTER TABLE equipe DROP CONSTRAINT id_treinador;
ALTER TABLE equipe DROP CONSTRAINT fk_id_treinador;
DROP TABLE treinador;

--19. Remova a tabela EQUIPE;
ALTER TABLE jogador DROP CONSTRAINT jogador_equipe_fk; 
DROP TABLE equipe;

--20. Remova a tabela JOGADOR;
DROP TABLE jogador;

--21. Crie a tabela LIVRO
CREATE TABLE livro(
	id INTEGER GENERATED ALWAYS AS IDENTITY,
	titulo VARCHAR(60) NOT NULL,
	ano INTEGER ,
	preco NUMERIC(8,2),
	quantidade INTEGER DEFAULT 1,
	preco_promo NUMERIC (8,2) GENERATED ALWAYS AS (preco*0.90) STORED,
	valor_acervo NUMERIC(10,2) GENERATED ALWAYS AS (preco*quantidade) STORED,
	CONSTRAINT pk_livro PRIMARY KEY(id),
	CONSTRAINT ck_preco CHECK (preco >=0)
);

-- 22. Apague o banco de dados criado para esses exercícios.
DROP TABLE livro;
DROP DATABASE clube;


