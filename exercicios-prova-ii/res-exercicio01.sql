
-- Para as quest�es abaixo, utilize o esquema contido no script do arquivo Exercicio 01.sql.

-- Os atributos RG, ENDERECO e TELEFONE da tabela TB_ALUNO podem assumir valores nulos. No entanto, foi criada uma tabela de pend�ncias, TB_LOG_PENDENCIAS, para registrar as pend�ncias de cadastro existentes. Essa tabela dever� apresentar uma linha para cada pend�ncia de aluno. Exemplo: Se o aluno Jo�o n�o informou o telefone e o RG no momento de cadastro, essa tabela conter� duas linhas:

-- 1. Criar uma Trigger do tipo AFTER INSERT para registrar as pend�ncias de cadastro de Alunos para os atributos RG, TELEFONE e ENDERECO.

CREATE TRIGGER TG_ALUNO_INSERT
ON TB_ALUNO
AFTER INSERT
AS

INSERT INTO TB_LOG_PENDENCIAS 
SELECT MATRICULA, NOME, 'FALTA RG'
FROM INSERTED
WHERE RG IS NULL

UNION ALL

SELECT MATRICULA, NOME, 'FALTA ENDERECO'
FROM INSERTED 
WHERE ENDERECO IS NULL

UNION ALL

SELECT MATRICULA, NOME, 'FALTA TELEFONE'
FROM INSERTED
WHERE TELEFONE IS NULL

-- 2. Criar uma Trigger do tipo AFTER UPDATE para atualizar as pend�ncias de cadastro de Alunos. Se uma informa��o passou a ter valor, ela deve ser removida da tabela de pend�ncias. Se uma informa��o deixou de ter valor, ela deve ser inclu�da na tabela de pend�ncias.

ALTER TRIGGER TG_ALUNO_INSERT
ON TB_ALUNO
AFTER INSERT, UPDATE
AS

DELETE FROM TB_LOG_PENDENCIAS 
WHERE MATRICULA IN (SELECT MATRICULA FROM INSERTED)

INSERT INTO TB_LOG_PENDENCIAS 
SELECT MATRICULA, NOME, 'FALTA RG'
FROM INSERTED
WHERE RG IS NULL

UNION ALL

SELECT MATRICULA, NOME, 'FALTA ENDERECO'
FROM INSERTED 
WHERE ENDERECO IS NULL

UNION ALL

SELECT MATRICULA, NOME, 'FALTA TELEFONE'
FROM INSERTED
WHERE TELEFONE IS NULL

-- 3. Criar uma Trigger do tipo AFTER DELETE para atualizar as pend�ncias de cadastro de Alunos. Todas as pend�ncias de um Aluno que foi removido do cadastro devem ser removidas.

CREATE TRIGGER TG_ALUNO_DELETE
ON TB_ALUNO
AFTER DELETE
AS
DELETE FROM TB_LOG_PENDENCIAS WHERE MATRICULA = (SELECT MATRICULA FROM DELETED)


INSERT INTO TB_ALUNO VALUES(1, 'JOAO',NULL,NULL,NULL)
INSERT INTO TB_ALUNO VALUES(2, 'GUSTAVO',NULL,'RUA H',NULL)

SELECT * FROM TB_LOG_PENDENCIAS
SELECT * FROM TB_ALUNO

TRUNCATE TABLE TB_LOG_PENDENCIAS

UPDATE TB_ALUNO SET TELEFONE='0000' WHERE MATRICULA=1

DELETE FROM TB_ALUNO WHERE MATRICULA = 1

