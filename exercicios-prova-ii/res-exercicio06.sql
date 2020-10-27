
-- Considere o esquema contido no script do arquivo Exercicio 06.sql.

-- 1. Criar uma Trigger na tabela TB_VENDAS que impeça a atualização da tabela nos seguintes intervalos:

-- a. Das 18:00 às 22:00
-- b. Das 12:00 às 14:00

CREATE TRIGGER TG_VENDAS_HORARIO_INSERT_UDPATE_DELETE
ON TB_VENDAS
AFTER INSERT,UPDATE,DELETE
AS
DECLARE @HORA_ATUAL INT
SET @HORA_ATUAL = DATEPART(HH,GETDATE())
IF (@HORA_ATUAL >= 12 AND @HORA_ATUAL <=13) OR
   (@HORA_ATUAL >= 18 AND @HORA_ATUAL <=21)
  BEGIN
    RAISERROR('HORARIO INVALIDO PARA ATUALIZACAO',1,1)
    ROLLBACK 
  END   

