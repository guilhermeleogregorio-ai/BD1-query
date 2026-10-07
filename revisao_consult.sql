-- Criar a tabela de convênios
create table convenio(
	id int,
	nome varchar(30) not null,
	constraint convenio_pk primary key(id),
	constraint convenio_nome unique(nome)
);

-- Criar a tabela de pacientes
create table paciente(
	id int,
	cpf varchar(14) not null,
	nome varchar(50) not null,
	sexo char(1),
	datanasc date,
	endereco varchar(60),
	id_convenio int,

	constraint paciente_pk primary key(id),
	constraint pac_cpf unique(cpf),
	constraint paciente_sexo check (sexo in ('M','F')),
	constraint paciente_conv_fk foreign key(id_convenio) references convenio(id)
);

-- Criar a tabela de médicos
create table medico(
	id int,
	cpf varchar(14) not null,
	nome varchar(50) not null,
	crm varchar(13),
	especialidade varchar(20),

	constraint medico_pk primary key(id),
	constraint medico_cpf unique(cpf),
	constraint crm_un unique(crm)
);

-- Criar a tabela de consultas
create table consulta(
	numero int generated always as identity,
	data date not null,
	tipo char(1) default 'C',
	valor real,
	id_paciente int,
	id_medico int,

	constraint numero_pk primary key(numero),
	constraint tipo_ck check (tipo in ('P','C')),
	constraint valor_ck check (valor > 0),
	constraint id_paciente_fk foreign key(id_paciente) references paciente(id),
	constraint id_medico_fk foreign key(id_medico) references medico(id)
);


-- Inserir dados

-- Inserir um convênio
insert into convenio
values(1,'Unimed');

-- Inserir outro convênio
insert into convenio(nome,id)
values('São Francisco', 2);

-- Consultar todos os convênios
select * from convenio;


-- Inserir um paciente
insert into paciente
values(
	1,
	'123.432.556-99',
	'João José da Silva',
	'M',
	'2004-03-09',
	'Rua das Margaridas, 316',
	null
);

-- Inserir outro paciente
insert into paciente(
	id,
	cpf,
	nome,
	sexo,
	datanasc,
	id_convenio
)
values(
	2,
	'321.947.112-65',
	'Maria Felizardo',
	'F',
	'2008-11-30',
	1
);

-- Inserir outro paciente
insert into paciente(
	id,
	nome,
	id_convenio,
	datanasc,
	cpf
)
values(
	3,
	'Paulo Antunes Aguiar',
	1,
	'2001-07-14',
	'111.222.333-44'
);

-- Consultar todos os pacientes
select * from paciente;


-- Inserir um médico
insert into medico
values(
	1,
	'786.654.109-00',
	'Marcelo Gonçalves',
	'CRM/SP 900642',
	'Neurologia'
);

-- Inserir outro médico
insert into medico
values(
	2,
	'315.477.347-58',
	'Vanessa Domingues',
	'CRM/SP 900342',
	'Neurologia'
);

-- Inserir outro médico
insert into medico
values(
	3,
	'712.112.347-26',
	'Lucia Marques Santiago',
	'CRM/MG 845543',
	'Neurologia'
);

-- Consultar todos os médicos
select * from medico;


-- Inserir uma consulta
insert into consulta(data,tipo,valor,id_paciente,d_medico)values('2024-03-18','P',345.8,1,1);

-- Inserir uma consulta utilizando o tipo padrão
insert into consulta(data,id_paciente,id_medico)values('2024-05-19',1,2);

-- Inserir uma consulta
insert into consulta(data,tipo,valor,id_paciente,id_medico)values('2024-04-10','P',345.8,1,1);

-- Inserir uma consulta utilizando o tipo padrão
insert into consulta(data,id_paciente,id_medico)values('2024-01-02',2,2);

-- Consultar todas as consultas
select * from consulta;


-- Inserir um novo paciente
insert into paciente(id,cpf,nome,id_convenio)
values(4,'405.656.985-89','Maria',8);

-- Inserir um novo convênio
insert into convenio(id) values(8);


-- Atualização de dados

-- Atualizar a especialidade do médico de id 1
update medico set especialidade = 'Fisioterapeuta' where id = 1;

-- Atualizar a especialidade dos médicos Robert ou Rafael
update medico set especialidade = 'Cardiologista' where nome = 'Robert' or nome = 'Rafael';

-- Consultar todos os médicos
select * from medico;


-- Atualizar a data da consulta de número 4
update consulta
set data = '2024-04-20' where numero = 4;

-- Consultar a consulta de número 4
select * from consulta where numero = 4;


-- Atualizar o endereço dos pacientes 2 e 3 para N/I
update paciente set endereco = 'N/I' where id = 2 or id = 3;

-- Consultar os pacientes 2 e 3
select * from paciente where id = 2 or id = 3;


-- Atualizar o tipo das consultas que estão sem valor para P e definir o valor como 450.8
update consulta set tipo = 'P', valor = 450.8 where valor is null;


-- Atualizar em 10% o valor das consultas maiores que 450
update consulta set valor = valor * 1.10 where valor > 450;


-- Remover o paciente chamado Paulo Antunes Aguiar
delete from paciente where nome = 'Paulo Antunes Aguiar';


-- Remover todas as consultas com valores entre R$ 400,00 e R$ 500,00
delete from consulta where valor >= 400 and valor <= 500;


-- Apagar dados em tabelas

-- Remover todos os pacientes
delete from paciente;


-- Alterar o tipo das consultas com valor maior ou igual a 450 para C e definir o valor como nulo
update consulta
set tipo = 'C', valor = null where valor >= 450;


-- Consultar todos os pacientes
select * from paciente;

-- Consultar todas as consultas
select * from consulta;

-- Consultar todos os convênios
select * from convenio;


-- Remover o convênio de id 1
delete from convenio where id = 1;


-- Transformar uma FK em modo Cascade (Sera cobrado)

-- Remover a FK do convênio da tabela paciente
alter table paciente drop constraint paciente_conv_fk;

-- Adicionar novamente a FK com exclusão em cascata
alter table paciente add constraint paciente_conv_fk foreign key (id_convenio) references convenio(id) on delete cascade;


-- Remover a FK do paciente da tabela consulta
alter table consulta drop constraint id_paciente_fk;

-- Adicionar novamente a FK com exclusão em cascata
alter table consulta add constraint id_paciente_fk foreign key (id_paciente) references paciente(id) on delete cascade;

update paciente set id_convenio = null where id = 1;
select * from paciente;

insert into paciente(id,cpf,nome,id_conveio)
values(4,'111', 'Ingrid', 2)

-- Transformar uma FK em modo Set Null

alter table paciente drop constraint paciente_conv_fk;
alter table paciente add constraint paciente_conv_fk foreign key (id_convenio) references convenio(id) on delete set null;

select * from paciente;
select * from convenio;
delete from convenio where id = 2;

--Forma correta 
alter table paciente drop constraint paciente_conv_fk;
alter table paciente add constraint paciente_conv_fk foreign key (id_convenio) references convenio(id)
