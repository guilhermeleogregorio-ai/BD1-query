create table equipe(
	id smallint primary key,
	nome varchar(30)not null
);


create table Jogador(
	id 		int,
	nome	varchar(60) not null,
	cpf		varchar(14) unique,
	data_nacs		date,
	salario 	numeric(8,2), 
	id_equipe		smallint,
	constraint jogador_pk primary key(id),
	constraint salario check(salario > 0),
	constraint jogador_equipe_fk foreign key (id_equipe) references equipe(id)
);


--Modifique a estrutura da tabelas JOGADOR, adicionando a coluna
--CONTATO, do tipo VARCHAR de tamanho 10;

alter table Jogador add contato varchar(10);


--Modifique a coluna CONTATO da tabela JOGADOR, passando para o
--tipo VARCHAR de tamanho 20;

alter table jogador alter contato type varchar(16);

--Renomeie a coluna CONTATO da tabela JOGADOR para TELEFONE;

alter table jogador rename contato to telefone;

--Adicione a coluna EMAIL à tabela JOGADOR, sendo uma coluna de
--texto variável com tamanho máximo 60 caracteres;

alter table jogador add email varchar(60);

--Elimine a coluna EMAIL criada no passo anterior da tabela JOGADOR;

alter table jogador drop email;

--Adicione a coluna Estado à tabela Equipe, do tipo CHAR de tamanho 2;

alter table equipe add estado char(2);

--Altere a coluna Estado criada para que seu valor default seja ‘SP’;

alter table equipe alter estado set default 'SP'

--Adicione uma constraint do tipo CHECK à coluna Estado de modo que
-- permita apenas os valores ‘SP’, ‘RJ’, ‘MG’ ou ‘ES’.

alter table equipe add constraint estado check(estado in('SP','RJ','MG','ES'));



