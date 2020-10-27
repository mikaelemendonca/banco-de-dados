
-- 1. Criar um procedimento para calcular o aumento de SALÁRIO a ser dado em função do tempo de serviço em uma determinada empresa. O procedimento deve apresentar como parâmetros de entrada o Ano de Admissão e o Salário Atual, e como parâmetro de saída o Salário após o aumento:
/*
	Ano de Admissão		Aumento
	 Antes de 2000		  30%
	 De 2000 a 2004		  20%
	 A partir de 2005	  10%
*/

CREATE PROCEDURE SP_CALCULAR_SALARIO (@ANO INT, @SALARIOATUAL NUMERIC(10,2), @SALARIO NUMERIC(10,2) OUTPUT)
AS
IF @ANO < 2000
	SET @SALARIO = @SALARIOATUAL + (@SALARIOATUAL * 0.3)
ELSE
  IF @ANO < 2005
    SET @SALARIO = @SALARIOATUAL + (@SALARIOATUAL * 0.2)
  ELSE
    SET @SALARIO = @SALARIOATUAL + (@SALARIOATUAL * 0.1)


DECLARE @SALARIO NUMERIC(10,2)
EXEC SP_CALCULAR_SALARIO 2005, 1000.00, @SALARIO OUTPUT
PRINT @SALARIO

-- 2. Criar uma tabela TB_FUNCIONARIO com os seguintes atributos: MATRICULA, NM_FUNCIONARIO, ANO_ADMISSAO, SALARIO

USE exercicio08

CREATE TABLE TB_FUNCIONARIO (
	MATRICULA INT,
	NM_FUNCIONARIO VARCHAR(40),
	ANO_ADMISSAO INT,
	SALARIO NUMERIC(10,2)
)

INSERT INTO TB_FUNCIONARIO VALUES
(1, 'MIKA', 2005, 1000.0),
(2, 'NANA', 2004, 2000.0),
(3, 'JOAO', 2003, 3000.0)

-- 3. Criar um procedimento, utilizando cursores, para percorrer a tabela TB_FUNCIONARIO e atualizar o SALARIO dos funcionários através do procedimento criado na questão 1.







