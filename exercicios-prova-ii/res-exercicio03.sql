
-- 1. Criar uma tabela TB_FUNCIONARIO com os 
-- seguintes atributos: MATRICULA, NOME, SALARIO, GRATIFICACAO.
-- A Matricula representa a chave primária. 

CREATE TABLE TB_FUNCIONARIO (
   MATRICULA INT NOT NULL PRIMARY KEY,
   NOME VARCHAR(40) NOT NULL,
   SALARIO NUMERIC (10,2) NULL,
   GRATIFICACAO NUMERIC(10,2) NULL
)

-- 2. Criar uma tabela de auditoria TB_LOG_AUMENTO_FUNCIONARIO
-- com os seguintes atributos: MATRICULA, NOME, DATA, SALARIO_INTEGRAL_ANTIGO, 
-- SALARIO_INTEGRAL_NOVO. Essa tabela será utilizada para registrar os
-- aumentos de salários que ocorrerem na tabela TB_FUNCIONARIO. 
-- Serão registradas as mudanças em que a soma Salário novo +  Gratificação 
-- nova é maior que  Salário antigo +  Gratificação antiga.

CREATE TABLE TB_LOG_AUMENTO_FUNCIONARIO (
   MATRICULA INT NOT NULL,
   NOME VARCHAR(40) NOT NULL,
   DATA DATETIME NULL,
   SALARIO_INTEGRAL_ANTIGO NUMERIC(10,2) NULL,
   SALARIO_INTEGRAL_NOVO NUMERIC(10,2) NULL
)

-- 3. Criar uma Trigger na tabela TB_FUNCIONARIO capaz de registrar 
-- os aumentos de salário integral (salário + gratificação).

ALTER TRIGGER TG_UPDATE_FUNCIONARIO
ON TB_FUNCIONARIO
AFTER UPDATE
AS

INSERT INTO TB_LOG_AUMENTO_FUNCIONARIO
SELECT I.MATRICULA, I.NOME, GETDATE(), isnull(D.SALARIO,0) + isnull(D.GRATIFICACAO,0),
       isnull(I.SALARIO,0) + isnull(I.GRATIFICACAO,0)
FROM INSERTED I 
     JOIN DELETED D ON (I.MATRICULA = D.MATRICULA)
WHERE 
   isnull(I.SALARIO,0) + isnull(I.GRATIFICACAO,0) >
   isnull(D.SALARIO,0) + isnull(D.GRATIFICACAO,0) 

insert into tb_funcionario values(1, 'andre', 200.00, 100.0)
insert into tb_funcionario values(2, 'joao', 300.00, 200.0)
insert into tb_funcionario values(3, 'ricardo', 200.00, null)

UPDATE TB_FUNCIONARIO SET SALARIO = 100.00,
 GRATIFICACAO = 100
WHERE MATRICULA = 1
SELECT * FROM TB_FUNCIONARIO
SELECT * FROM TB_LOG_AUMENTO_FUNCIONARIO