
-- Para as quest�es abaixo, utilize o esquema contido no script do arquivo Exercicio 02.sql.

-- 1. Criar uma Trigger do tipo AFTER INSERT para a tabela TB_FUNCIONARIO para assegurar que o valor do sal�rio inclu�do para um funcion�rio est� dentro da faixa salarial determinada para seu cargo e escolaridade.

ALTER TRIGGER TG_FUNCIONARIO
ON TB_FUNCIONARIO
AFTER INSERT
AS
DECLARE @VALOR NUMERIC(10,2), @MATRICULA INT, @V_MAIOR NUMERIC(10,2), @V_MENOR NUMERIC(10,2)
SELECT @MATRICULA = MATRICULA, @VALOR = SALARIO FROM INSERTED

SELECT @V_MENOR = S.MENOR_VALOR, @V_MAIOR = S.MAIOR_VALOR FROM TB_FUNCIONARIO F 
INNER JOIN TB_CARGO C ON (F.CD_CARGO = C.CD_CARGO)
INNER JOIN TB_ESCOLARIDADE E ON (F.CD_ESCOLARIDADE = E.CD_ESCOLARIDADE)
INNER JOIN TB_FAIXASALARIAL S ON (C.CD_CARGO = S.CD_CARGO AND E.CD_ESCOLARIDADE = S.CD_ESCOLARIDADE)
WHERE MATRICULA = @MATRICULA

IF NOT (@VALOR >= @V_MENOR AND @VALOR <= @V_MAIOR)
BEGIN
	BEGIN
		RAISERROR ('ALGUM SALARIO INVALIDO',1,1)
		--ROLLBACK
		SELECT * FROM TB_FUNCIONARIO
	END
END

-- 2. Criar uma Trigger do tipo AFTER UPDATE para a tabela TB_FUNCIONARIO para assegurar que o valor do sal�rio atualizado para um funcion�rio est� dentro da faixa salarial determinada para seu cargo e escolaridade.

ALTER TRIGGER TG_FUNCIONARIO
ON TB_FUNCIONARIO
AFTER INSERT, UPDATE
AS 

IF NOT EXISTS (SELECT 1 FROM INSERTED I
			INNER JOIN TB_FAIXASALARIAL S ON (I.CD_CARGO = S.CD_CARGO AND I.CD_ESCOLARIDADE = S.CD_ESCOLARIDADE)
			WHERE I.SALARIO >= S.MENOR_VALOR AND I.SALARIO <= s.MAIOR_VALOR)
	BEGIN
		RAISERROR ('ALGUM SALARIO INVALIDO',1,1)
		ROLLBACK
	END


DROP TRIGGER TG_FUNCIONARIO




