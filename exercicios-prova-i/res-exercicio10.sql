
-- 1. Criar um procedimento SP_CLASSIFICA_CLIENTE para classificar um Cliente como PARCEIRO ou ALVO. O procedimento deve receber como par�metros de entrada a data de inclus�o do Cliente e a quantidade de produtos que um Cliente j� comprou. O procedimento deve apresentar um par�metro de sa�da informando se o Cliente � PARCEIRO ou ALVO. O cliente ser� classificado de acordo com a seguinte regra:
/*
	Se a data de inclus�o do Cliente � maior ou igual a �01/03/2010� ou a Quantidade de Produtos j� comprados pelo Cliente � maior que 50
		O Cliente � PARCEIRO
	Caso Contr�rio o Cliente � ALVO.
*/

USE exercicio10

CREATE PROCEDURE SP_CLASSIFICA_CLIENTE (@DATAINCLUSAO DATE, @QTPRODUTOS INT, @RETORNO VARCHAR(25) OUTPUT)
AS
IF (@DATAINCLUSAO >= '20100301' OR @QTPRODUTOS > 50)
	SET @RETORNO = 'PARCEIRO'
ELSE
	SET @RETORNO = 'ALVO'

--DECLARE @MSG VARCHAR(25)

-- 2. Criar um procedimento SP_COPIA_CLENTE utilizando cursores para varrer a tabela TB_CLIENTE e, utilizando o procedimento desenvolvido da quest�o 1 e as informa��es contidas na tabela TB_VENDAS, copiar as informa��es de um cliente para a tabela TB_CLIENTE_ALVO ou para a tabela TB_CLIENTE_PARCEIRO de acordo com sua classifica��o. A classifica��o do Cliente deve ser dada necessariamente pelo procedimento da quest�o 1.

CREATE PROCEDURE SP_COPIA_CLENTE 
AS
DECLARE @DT DATE, @CDCLI INT, @NM VARCHAR(40), @CPF VARCHAR(25), @QT INT, @MSG VARCHAR(25)
DECLARE C_CLIENTE CURSOR FOR
SELECT CL.CD_CLIENTE, CL.NM_CLIENTE, CL.CPF, CL.DT_INCLUSAO, V.QUANTIDADE
FROM TB_CLIENTE AS CL
INNER JOIN TB_VENDAS AS V ON (CL.CD_CLIENTE = V.CD_CLIENTE)
OPEN C_CLIENTE
FETCH C_CLIENTE INTO @CDCLI, @NM, @CPF, @DT, @QT
WHILE (@@FETCH_STATUS = 0)
BEGIN
EXEC SP_CLASSIFICA_CLIENTE @DT, @QT, @MSG OUTPUT
--PRINT @MSG
--PRINT STR(@QT)
IF (@MSG = 'PARCEIRO')
	INSERT INTO TB_CLIENTE_PARCEIRO VALUES (@CDCLI, @NM, @CPF, @DT)
ELSE
	INSERT INTO TB_CLIENTE_ALVO VALUES (@CDCLI, @NM, @CPF, @DT)
FETCH C_CLIENTE INTO @CDCLI, @NM, @CPF, @DT, @QT
END
CLOSE C_CLIENTE
DEALLOCATE C_CLIENTE

EXEC SP_COPIA_CLENTE
SELECT * FROM TB_CLIENTE_PARCEIRO
