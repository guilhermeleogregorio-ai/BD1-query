--View
--View 

create view v_aluno_computacao as 
	select id ra,nome, id_curso from aluno
	where id_curso = 1;

select * from v_aluno_computacao;

create or replace view v_aluno_computaca as 
	select id as id_aluno, ra as ra_aluno, nome, id_curso as curso
	from aluno
	where id_curso = 1;

--Criar um view v_curso_depto com ID e nome dos cursos , bem como o ID e nome dos departamentos 
--a que perntencem, ordenados po ID do curso. As colunas na view devem ser chamar
--id_curso , nome_curso, id_depto e nome_depto,
create view v_curso_depto (id_curso, nome_curso, id_depto, nome_depto) as 
select 	c.id , c.nome , d.id , d.nome
	from curso c inner join departamento d
		on c.id_departamento = d.id
	order by c.id;

select * from v_curso_depto;

--Crie a view v_depto_info com o nome dos departamentos, a quantidade de professores 
--que trabalham neles e a soma salarial desses professores. Chama as colunas na view
--de nome_depto, qtde_profs e soma_sal_profs e media_sal_profs salarial respectivamente 
create or replace view v_depto_info(nome_depto, qtde_profs, soma_sal_profs, media_sal_profs) as
	select d.nome , count(*) , sum(p.salario), round(avg(p.salario),2)
	 from departamento d, professor p
	where p.id_departamento = d.id
	group by d.nome;

select * from v_depto_info;

--Operações DML por meio de views
select * from v_aluno_computacao;
insert into v_aluno_computacao values(101,'2060001','Francisco Pilar', 1);

update v_aluno_computacao set nome = 'Francisco Pilar' where id_aluno = 101;

delete from v_aluno_computacao where id_aluno - 101;

select * from v_aluno_computacao;

--Restrição WITH CHECK OPTION
create or replace view v_aluno_computacao(id_aluno, ra_aluno, nome, curso)as
	select id, ra, nome, id_curso, from aluno
		where id_curso = 1 with check option;

--Crie uma visão chamada V_PROF_SALANUAL que liste o nome, o e-mail
--e o salário anual (salário x 12) dos professores. Consulte a visão criada.

create view v_prof_salario( nome, email, salario_anual) as
	select nome, email , salario * 12 
	 from professor;

select * from v_prof_salario;

--Crie uma visão chamada V_ALUNO_IDADE que liste o nome, a data de
--nascimento e a idade dos alunos. A idade deve ser calculada em função
--da data de nascimento. Consulte a visão criada

CREATE VIEW v_aluno_idade (nome, data_nasc, idade) AS
    SELECT nome, data_nascimento, CAST(EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS INTEGER) AS idade
    FROM aluno;

select * from v_aluno_idade;

--Modifique a visão V_ALUNO_IDADE, incluindo o RA do aluno como
--sendo a última coluna da view. Consulte novamente a visão

create or replace view v_aluno_idade(nome,data_nasc,idade , ra) as
	select nome,data_nascimento, cast(extract(year from age(current_date , data_nascimento)) as integer)as idade, ra
	from aluno

select * from v_aluno_idade;

--Crie uma visão chamada V_DISCIPLINA_COMP que liste id, sigla, nome 
--e id_departamento das disciplinas que pertencem ao Departamento 1
--(Computação). Ative a restrição que verifica o domínio da view em
--operações DML feitas por meio dela. Consulte a visão criada.

create view v_disciplina_comp (id,sigla,nome, id_departamento) as
	select id, sigla,nome , id_departamento
	from disciplina where id_departamento = 1 with check option;

SELECT * FROM v_disciplina_comp;

--Insira, por meio da view V_DISCIPLINA_COMP, uma nova disciplina com
--os seguintes valores:
--id: 21, sigla: 'PRW1’, nome: 'Programação para Web I’, id_departamento: 1

insert into  v_disciplina_comp values(21,'PRW1','Programação para Web I',1);

--Tente atualizar a disciplina recém-inserida (id 21), alterando o id do
--departamento dela para o 2. Deu certo?

update v_disciplina_comp set id_departamento = 2 where id = 21;

-- Agora tente inserir uma nova disciplina por meio da view, com os valores
--a seguir, e verifique se deu certo:
--id: 22, sigla: ‘PRW2’, nome: 'Programação para Web II’, id_departamento: 2

insert into v_disciplina_comp values (22,'PRW2','Programação para Web II',2);

--Crie uma visão chamada V_PROF_DEPENDENTE que liste o id e nome
--dos professores e a quantidade de seus dependentes. Chame as colunas
--de id_prof, nome_prof e qtde_dep, respectivamente.

create view v_prof_dependente (id,nome_prof, qtd_dep) as 
	select p.id , p.nome ,  count (d.id)
	from professor p 
	left join dependente d on p.id = d.id_professor
	group by p.id, p.nome;

select * from v_prof_dependente;

--Crie uma visão chamada V_DISCIPLINA_PREREQ que liste a sigla, nome
--e número de créditos das disciplinas, além da sigla e nome das
--disciplinas que são pré-requisitos delas. Chame as colunas de sigla,
--nome, creditos, sigla_prereq e nome_prereq, respectivamente.

create view v_disciplina_prereq (sigla, nome , creditos, sigla_prereq , nome_prereq) as
	select d.sigla, d.nome , d.creditos, p.sigla, p.nome
	from disciplina d
	left join disciplina_prerequisito pr on d.id = pr.id_disciplina
	left join disciplina p on pr.id_prerequisito = p.id;
	
--Crie uma visão chamada V_DEP_PROF_DISC_SEM_PRE que liste o nome
--do departamento, o nome do professor, a sigla e nome da disciplina, e o
--período em que foram ministradas. Considere somente as disciplinas
--que não possuem pré-requisitos. O período deve ser a concatenação de
--ano com ‘/’ com semestre. Chame as colunas de depto_nome, prof_nome,
--disc_sigla, disc_nome e período, respectivamente.

CREATE VIEW v_dep_prof_disc_sem_pre (depto_nome, prof_nome, disc_sigla, disc_nome, periodo) AS
    SELECT 
        dep.nome,
        prof.nome,
        disc.sigla,
        disc.nome,
        t.ano || '/' || t.semestre
    FROM departamento dep
    INNER JOIN professor prof ON dep.id = prof.id_departamento
    INNER JOIN turma t ON prof.id = t.id_professor
    INNER JOIN disciplina disc ON t.id_disciplina = disc.id
    WHERE disc.id NOT IN (
        SELECT id_disciplina FROM disciplina_prerequisito
    );
--Elimine a visão de nome V_PROF_SALANUAL.

drop view v_prof_salanual;



			
