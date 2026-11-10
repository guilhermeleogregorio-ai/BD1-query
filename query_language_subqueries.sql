
--Rodar o script universidade para criação das tabelas 
--Liste o id , nome e salário dos professores que ganha mais
--do que Eva terranova

select id,nome ,salario
	from professor
where salario > (select salario from professor 
				where nome = 'Eva Terranova');

--Listar id,nome e data de nascimento do professor responsavel
--pelo Departamento de Matemática
select id,nome ,data_nascimento from professor
where id = (select id_prof_responsavel from departamento 
			where nome = 'Departamento de Matemática');

--Listar id,nome e salario dos professores que ganham menos ou igual
--ao menor salário do departamento 3;

select id , nome , salario from professor
where salario <= (select min(salario) from professor 
				where o id_departamento = 3);

--Listar id,nome e email dos professores que sao responsaveis 
--por algum departamento 

select id ,nome ,email from professor
	where id in (select id_prof_responsavel from departamento);

--listar o nome e salario dos professores que ganham mais doque
--todos os professores do departamento 2

select nome,salario from professor
	where salario > (select salario from professor where id_departamento = 2);

select nome , salario from professor
	where salario > (select max (salario) from professor where id_departamento = 2);

--Listar o nome,salario dos professores que ganham mais do que 
--algum professor do departamento 2 
select nome,salario, from professor
	where salario > ANY (select salario from professor where id_departamento = 2);

select nome, salario from professor
	where salario > (select min(salario) from professor where id_departameto = 2);

--Liste o id,nome e e-email dos professores que NÃO são responsaveis
--por nenhum departamento

select id, nome , email from professor 
	where id NOT IN (select id_prof_responsavel from departamento
						where id_prof_responsavel is not null);

select id, nome , email from professor 
	where id NOT IN (select coalesce(id_prof_responsavel, -1) from departamento);

--subconsultas correlacionadas
--Listar os nomes dos professores que são responsaveis por algum departamento
--Ao usar exists deve ter uma relação(where) entre a tabela de fora e da subconsulta (select)
select nome from professor p
	where exists (select 1 from departamento d
					where d.id_prof_responsavel = p.id);

--Listar os nomes dos professores que NÃO são responsaveis por algum departamento
select nome from professor p
	where not exists(select 1 from departamento d
					where d.id_prof_responsavel = p.id);

--OPERADORES DE CONJUNTOS
--UNION, UNION ALL, INTERSECT , EXCEPT (MINUS)
--Listar o ID dos alunos que cursaram a turma 1 com média maior dique 7,0
--e os que cursaram a turma 3 com media maior doque 6,0
select id_aluno from matriculado where id_turma = 1 and media > 7
union --union all tem duplicidade
select id_aluno from matriculado where id_turma = 3 and media > 6
order by id_aluno;

--Listar os IDs dos alunos que cursaram a turma 1 e a turma 3 
select id_aluno from matriculado where id_turma = 1 
INTERSECT
	select id_aluno from matriculado where id_turma = 3 
ORDER BY id_aluno;

--Liste os IDs dis alunos que cursaram a turma 1, mas não cursaram a turma 3
select id_aluno from matriculado where id_turma = 1 
EXCEPT 
select id_aluno from matriculado where id_turma = 3
ORDER BY id_aluno;

--Listar o email e nome dos professores e o cpf e email e nome dos alunos
--UNION faz validação para unir selects, verifica se tem a mesma quantidade de colunas, mesmo tipos
select email,nome from professor
UNION
select email,nome from aluno;

--Liste o ID e nome dos departamentos sob responsabilidades do professor 8
-- e o ID, nome e data de nascimento de seus dependentes
select id ,nome ,null as Data_nascimento, 'Departamento' AS tipo from departamento
	where id_prof_responsavel = 8
UNION
select id, nome, data_nascimento, 'Dependente' AS tipo from dependente
 	where id_professor = 8

	


				
