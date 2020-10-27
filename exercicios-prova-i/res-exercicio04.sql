
-- 1. Criar uma tabela TB_CLIENTE com a seguinte estrutura:
/*
  MATRICULA INT
  NOME VARCHAR(40)
  TELEFONE VARCHAR(10)
*/
USE exercicio04

CREATE TABLE TB_CLIENTE (
	MATRICULA INT,
	NOME VARCHAR(40),
	TELEFONE VARCHAR(40)
)

-- 2. Criar um procedimento armazenado, SP_INCLUI_CLIENTE, para incluir um novo Cliente. O procedimento deve apresentar como par�metros de entrada a Matr�cula, o Nome e o Telefone do Cliente a ser inclu�do.

CREATE PROCEDURE SP_LISTA_CLIENTE 
AS
SELECT * FROM TB_CLIENTE
EXEC SP_LISTA_CLIENTE

-- 3. Criar um procedimento armazenado, SP_REMOVE_CLIENTE, para remover um Cliente cadastrado. O procedimento deve apresentar como par�metro de entrada a Matr�cula do Cliente a ser removido.

CREATE PROCEDURE SP_INCLUI_CLIENTE (@MATRICULA INT, @NOME VARCHAR(40), @TELEFONE VARCHAR(40))
AS
INSERT INTO TB_CLIENTE VALUES (@MATRICULA, @NOME, @TELEFONE)
EXEC SP_INCLUI_CLIENTE 2, 'MIKA', '99999-5555'

-- 4. Alterar os procedimentos dos itens 2 e 3 para incluir um par�metro de sa�da a fim de informar o resultado da execu��o do procedimento.

ALTER PROCEDURE SP_INCLUI_CLIENTE (@MATRICULA INT, @NOME VARCHAR(40), @TELEFONE VARCHAR(40),
@MENSAGEM VARCHAR(50) OUTPUT)
AS
INSERT INTO TB_CLIENTE VALUES (@MATRICULA, @NOME, @TELEFONE)
SET @MENSAGEM = 'CLIENTE CADASTRADO'
DECLARE @MSG VARCHAR(50)
EXEC SP_INCLUI_CLIENTE 2, 'MIKA', '99999-5555', @MSG OUTPUT
PRINT @MSG

CREATE PROCEDURE SP_REMOVE_CLIENTE (@MATRICULA INT)
AS
DELETE FROM TB_CLIENTE WHERE MATRICULA = @MATRICULA
EXEC SP_REMOVE_CLIENTE 2

ALTER PROCEDURE SP_REMOVE_CLIENTE (@MATRICULA INT, @MENSAGEM VARCHAR(50) OUTPUT)
AS
DELETE FROM TB_CLIENTE WHERE MATRICULA = @MATRICULA
SET @MENSAGEM = 'CLIENTE DELETADO'
DECLARE @MSG VARCHAR(50)
EXEC SP_REMOVE_CLIENTE 2, @MSG OUTPUT
PRINT @MSG

-- 5. Criar um procedimento armazenado, SP_ALTERA_CLIENTE, para alterar as informa��es (Nome e Telefone) de um Cliente cadastrado. O procedimento deve apresentar como par�metros de entrada a Matr�cula, o Nome e o Telefone do Cliente.

CREATE PROCEDURE SP_ALTERA_CLIENTE (@MATRICULA INT, @NOME VARCHAR(40), @TELEFONE VARCHAR(40), 
@MSG VARCHAR(50) OUTPUT)
AS
UPDATE TB_CLIENTE SET NOME = @NOME, TELEFONE = @TELEFONE WHERE MATRICULA = @MATRICULA
SET @MSG = 'CLIENTE ALTERADO'

-- 6. Alterar o procedimento SP_ALTERA_CLIENTE para adicionar a seguinte funcionalidade: Se o valor do par�metro passado for nulo (NULL) o atributo correspondente n�o deve ser modificado.

ALTER PROCEDURE SP_ALTERA_CLIENTE (@MATRICULA INT, @NOME VARCHAR(40), @TELEFONE VARCHAR(40), 
@MSG VARCHAR(50) OUTPUT)
AS
BEGIN
 DECLARE @ERRO INT, @ROWCOUNT INT

 UPDATE TB_CLIENTE SET NOME = 
  CASE
    WHEN @NOME IS NULL THEN NOME
	ELSE @NOME
  END, TELEFONE = 
  CASE
    WHEN @TELEFONE IS NULL THEN TELEFONE
	ELSE @TELEFONE
  END
 WHERE MATRICULA = @MATRICULA

 SELECT @ERRO = @@ERROR, @ROWCOUNT = @@ROWCOUNT
  IF @ERRO = 0
   BEGIN
    IF @ROWCOUNT = 1
	  SET @MSG = 'CLIENTE ALTERADO'
	ELSE
	  SET @MSG = 'MATRICULA INVALIDA'
   END
  ELSE
   SET @MSG = 'ERRO'
END

DECLARE @MSG VARCHAR(50)
EXEC SP_ALTERA_CLIENTE 3, 'PEDRO', '7777-2222', @MSG OUTPUT
PRINT @MSG

SELECT * FROM TB_CLIENTE

