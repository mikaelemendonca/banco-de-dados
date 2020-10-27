
-- Exercicio Adicional 01

-- 1. Criar uma tabela TB_ALUNO com a seguinte estrutura:
/*
	matricula int
	nome varchar(50)
	dt_nascimento datetime
*/

USE exercicioadicional

CREATE TABLE TB_ALUNO (
	MATRICULA INT,
	NOME VARCHAR(50),
	DT_NASCIMENTO DATETIME
)

INSERT INTO TB_ALUNO VALUES (3, 'JOAO', '19890618')
SELECT * FROM TB_ALUNO

-- 2. Criar um procedimento utilizando cursores para percorrer a tabela TB_ALUNO e, através da função PRINT, apresentar o seguinte resultado: 
/*
	ALUNOS MATRICULADOS
	MATRICULA NOME 	DATA NASCIMENTO
	--------------------------------------
	1 		 JOAO 	12/08/1976
	--------------------------------------
	2 		RICARDO 23/01/1970
	--------------------------------------
	3 		ROBERTO 26/07/1989
	--------------------------------------
	TOTAL DE ALUNOS: 3
*/

DECLARE @MATRICULA INT, @NOME VARCHAR(50), @DT_NASCIMENTO DATETIME, @CONTADOR INT
DECLARE C_ALUNO CURSOR FOR 
	SELECT MATRICULA, NOME, DT_NASCIMENTO FROM TB_ALUNO
OPEN C_ALUNO
FETCH C_ALUNO INTO @MATRICULA, @NOME, @DT_NASCIMENTO
PRINT 'MATRIUCLA'+ '	NOME	' + 'DT_NASCIMENTO'
PRINT '---------------------------------------------'
SET @CONTADOR = 0
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT STR(@MATRICULA) + '	' + @NOME + '	' + CONVERT(VARCHAR(10), @DT_NASCIMENTO, 103)
		PRINT '---------------------------------------------'
		SET @CONTADOR = @CONTADOR + 1
		FETCH C_ALUNO INTO @MATRICULA, @NOME, @DT_NASCIMENTO
	END
CLOSE C_ALUNO
DEALLOCATE C_ALUNO
PRINT 'CONTADOR = ' + STR(@CONTADOR)

-- Exercicio Adicional 02

-- 1. Utilizando o esquema contido no arquivo “exercicio-adicional.sql”, criar um procedimento armazenado utilizando cursores aninhados para, através da função PRINT, apresentar o seguinte resultado: 
/*
	FUNCIONARIOS E DEPENDENTES
MATRICULA 
NOME 
NOME DEPENDENTE
------------------------------------------------------------
1 JOSÉ RICARDO
ROBERTA
RITA
GABRIELA
------------------------------------------------------------
2 ANA MILLER
GUSTAVO
MARIANA
------------------------------------------------------------
*/

DECLARE @MATRICULAF INT, @NOMEF VARCHAR(50)
DECLARE C_FUNCIONARIO CURSOR FOR 
	SELECT MATRICULA, NOME FROM TB_FUNCIONARIO
OPEN C_FUNCIONARIO
FETCH C_FUNCIONARIO INTO @MATRICULAF, @NOMEF
--PRINT 'MATRIUCLA'+ CHAR(9) + 'NOME' + CHAR(9) + CHAR(9) + CHAR(9) + 'NOME DEPENDENTE'
PRINT 'MATRICULA' + REPLICATE(' ',3) + 'NOME' + REPLICATE(' ',15) + 'NOME DEPENDENTE'
PRINT '---------------------------------------------'
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @MATRICULAD INT, @NOMED VARCHAR(50)
		DECLARE C_DEPENDENTES CURSOR FOR 
			SELECT MATRICULA, NOME FROM TB_DEPENDENTES 
		OPEN C_DEPENDENTES
		FETCH C_DEPENDENTES INTO @MATRICULAD, @NOMED
		PRINT STR(@MATRICULAF, 2) + REPLICATE(' ',10) + @NOMEF
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF (@MATRICULAF = @MATRICULAD)
					PRINT REPLICATE(' ',32) + @NOMED
				FETCH C_DEPENDENTES INTO @MATRICULAD, @NOMED
			END
		PRINT '---------------------------------------------'
		CLOSE C_DEPENDENTES
		DEALLOCATE C_DEPENDENTES
	END
CLOSE C_FUNCIONARIO
DEALLOCATE C_FUNCIONARIO

PRINT CHAR(9) + 'MIKA' + CHAR(9) + 'COSTA'
PRINT CHAR(9) + 'EDIELMA' + CHAR(9) + 'MENDONCA'

