
-- 1. Criar uma tabela TB_FUNCIONARIO com os atributos: MATRICULA, NOME, TELEFONE, ENDERECO, SALARIO, PENDENCIA. Somente os atributos MATRICULA e NOME s�o obrigat�rios.

USE exercicio06

CREATE TABLE TB_FUNCIONARIO (
	MATRICULA INT NOT NULL,
	NOME VARCHAR(40) NOT NULL,
	TELEFONE VARCHAR(20),
	ENDERECO VARCHAR(40),
	SALARIO NUMERIC(10,2),
	PENDENCIA VARCHAR(20)
)

INSERT INTO TB_FUNCIONARIO VALUES ( 5, 'MIKA', NULL, NULL, NULL, NULL ),
( 6, 'PEDRO', NULL, NULL, NULL, NULL ), 
( 7, 'MARIA', NULL, NULL, NULL, NULL ),
( 8, 'NANA', NULL, NULL, NULL, NULL )

-- 2. Criar um procedimento armazenado que, utilizando um cursor, percorra a tabela TB_FUNCIONARIO e atualize o campo de PENDENCIA. O campo de PENDENCIA dever� conter:

-- a. O texto �SEM PEND�NCIA� quando todos os atributos de um funcion�rio apresentarem valores.

DECLARE @MATRICULA INT, @TELEFONE VARCHAR(20), 
@ENDERECO VARCHAR(20), @SALARIO NUMERIC(10,2), @PENDENCIA VARCHAR(20)

DECLARE C_FUNCIONARIO CURSOR FOR

SELECT MATRICULA, TELEFONE, ENDERECO, SALARIO 
FROM TB_FUNCIONARIO

OPEN C_FUNCIONARIO 
FETCH C_FUNCIONARIO 
INTO @MATRICULA, @TELEFONE, @ENDERECO, @SALARIO

-- b. Um texto �EXISTE PEND�NCIA� quando existirem atributos sem valores.

SET @PENDENCIA = 'SEM PENDENCIA'

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF @TELEFONE IS NULL OR @ENDERECO IS NULL OR @SALARIO IS NULL
			SET @PENDENCIA = 'EXISTE PENDENCIA'

	    UPDATE TB_FUNCIONARIO SET PENDENCIA = @PENDENCIA WHERE MATRICULA = @MATRICULA
		FETCH C_FUNCIONARIO INTO @MATRICULA, @TELEFONE, @ENDERECO, @SALARIO
	END
CLOSE C_FUNCIONARIO
DEALLOCATE C_FUNCIONARIO

SELECT * FROM TB_FUNCIONARIO
