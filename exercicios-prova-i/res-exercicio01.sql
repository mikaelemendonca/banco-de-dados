-- 1. Utilizando o Esquema contido no arquivo “Exercicio 01 - Visoes.sql”, executar as seguintes tarefas:

-- a. Criar uma Visão VW_FUNCIONARIO a ser utilizada por outra aplicação ou usuário. A visão deve apresentar todas as informações da tabela TB_FUNCIONARIO exceto o Salário.

USE exercicio01

CREATE VIEW vw_funcionario AS
SELECT MATRICULA, nm_funcionario, sexo, cd_setor FROM TB_FUNCIONARIO

-- b. Criar uma Visão VW_FUNCIONARIO_COMPLETO que apresente os seguintes atributos: MATRICULA, NOME, SEXO, SALARIO, CD_SETOR, NM_SETOR, CD_DEPARTAMENTO, NM_DEPARTAMENTO.

CREATE VIEW vw_funcionario_completo AS
SELECT f.matricula, f.nm_funcionario, f.sexo, f.salario, f.cd_setor, s.nm_setor, s.cd_departamento, d.nm_departamento FROM tb_funcionario f
INNER JOIN tb_setor s ON (f.cd_setor = s.cd_setor)
INNER JOIN tb_departamento d ON (s.cd_departamento = d.cd_departamento)

SELECT * FROM vw_funcionario_completo

-- c. Criar uma Visão VW_SETOR com os seguintes atributos: CD_SETOR, NM_SETOR, NM_GERENTE, NM_DEPARTAMENTO. A visão deve apresentar somente os Setores que possuem funcionários alocados.

CREATE VIEW vw_setor AS 
SELECT s.cd_setor, s.nm_setor, s.nm_gerente, d.nm_departamento FROM tb_setor s
INNER JOIN tb_departamento d ON (s.cd_departamento = d.cd_departamento)

-- d. Criar uma Visão VW_TOTAL_SOLICITACAO_DEPARTAMENTO que apresente o total de solicitações por Departamento.

CREATE VIEW vw_total_solicitacao_departamento AS
SELECT d.nm_departamento, COUNT(so.matricula) as matricula FROM tb_solicitacao so
INNER JOIN tb_funcionario f ON (so.matricula = f.matricula)
INNER JOIN tb_setor s ON (f.cd_setor = s.cd_setor)
INNER JOIN tb_departamento d ON (s.cd_departamento = d.cd_departamento)
GROUP BY d.nm_departamento

SELECT * FROM vw_total_solicitacao_departamento

DROP VIEW vw_total_solicitacao

-- e. Criar uma Visão VW_DEPARTAMENTOS_MAIORES_SOLICITACOES que apresente os Departamentos que possuem o maior número de solicitações.

CREATE VIEW VW_DEPARTAMENTOS_MAIORES_SOLICITACOES AS
SELECT MAX(matricula) as matricula FROM vw_total_solicitacao_departamento

SELECT * FROM VW_DEPARTAMENTOS_MAIORES_SOLICITACOES

-- 2. Considere a seguinte tabela:

CREATE TABLE TB_LIVRO (
  CD_LIVRO INT NOT NULL PRIMARY KEY,
  NM_LIVRO VARCHAR(40) NOT NULL,
  ISBN INT NOT NULL,
  ANO INT NOT NULL,
  DATA_CADASTRO DATETIME NOT NULL
)

INSERT INTO TB_LIVRO VALUES (3, 'A CULPA', 844, 2016, '2016-07-20')
SELECT * FROM VW_LIVRO

-- a. Criar uma visão VW_LIVRO para a tabela TB_LIVRO com os atributos CD_LIVRO, NM_LIVRO, ISBN e ANO.

CREATE VIEW VW_LIVRO (CD_LIVRO, NM_LIVRO, ISBN, ANO) AS
SELECT CD_LIVRO, NM_LIVRO, ISBN, ANO FROM TB_LIVRO 

-- b. Tentar atualizar a tabela TB_LIVRO através da visão VW_LIVRO.

-- c. É possível incluir uma linha através da visão VW_LIVRO ?

-- d. O que acontece com a visão VW_LIVRO quando removemos a tabela TB_LIVRO do banco de dados ?

DROP TABLE TB_LIVRO
























