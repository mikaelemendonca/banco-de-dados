
-- Considere o esquema do arquivo Exercício 09.sql,

-- Uma agência de viagens possui como principal modelo de negócio a venda de pacotes de
-- viagens. Cada pacote possui um determinado destino (cidade, praia, etc.), o número de dias ,
-- um período de validade (composto por uma data inicial e uma data final) e as datas de saída.
-- Os clientes da agência de viagens, quando estão interessados em viajar para determinado
-- destino, preenchem um cadastro e informam quais os destinos de seu interesse, assim como o
-- período desejado. Quando surge um novo pacote, a agência fica responsável por entrar em
-- contato com os clientes para oferecer os pacotes que estão de acordo com o interesse
-- previamente cadastrado.

-- 1. Criar uma trigger para preencher automaticamente as datas de saída de um pacote na
-- tabela TB_PACOTE_SAIDA de acordo com as datas inicial e final do pacote. A tabela
-- TB_PACOTE_SAIDA deve ser atualizada todas as vezes que um pacote for incluído ou
-- modificado. Após a inclusão ou alteração de um pacote, as saídas devem ser cadastradas
-- ou atualizadas de acordo com o seguinte procedimento:

-- a) As datas de saída devem estar compreendidas entre a data inicial e a data final do pacote.

-- b) Deve existir um intervalo de 2 dias entre a chegada de um grupo e a saída de outro. A
-- data de chegada de um grupo é determinada pela data de saída e número de dias do
-- pacote. Exemplo: Se um pacote de 5 dias tem uma data de saída como 01/07/2018, a
-- próxima data de saída deve ser 08/07/2018, desde que essa data esteja dentro do
-- intervalo do pacote.

CREATE TRIGGER TG
ON TB_PACOTE
AFTER INSERT, UPDATE
AS

--DECLARE @DT_SAIDA DATE
SELECT dbo.CALCULASAIDA(COD_PACOTE, DATA_INICIAL, DATA_FINAL, NR_DIAS),  COD_PACOTE, DATA_INICIAL, DATA_FINAL, NR_DIAS FROM TB_PACOTE 
WHERE VALIDO = 'SIM'



ALTER FUNCTION CALCULASAIDA(@CD INT, @DI DATE, @DF DATE, @N INT)
RETURNS INT
BEGIN
	DECLARE @DT_SAIDA DATE
	SET @DT_SAIDA = '20180101'
	
	WHILE (@DT_SAIDA <= @DF)
	BEGIN
		EXEC INSERESAIDA @CD, @DT_SAIDA
		SET @DT_SAIDA = DATEADD(DD, @N+2, @DT_SAIDA)
	END
	RETURN 1
END

ALTER PROCEDURE INSERESAIDA (@CD INT, @DS DATE)
AS
INSERT INTO TB_PACOTE_SAIDA  VALUES (@CD, @DS)


SELECT * FROM TB_PACOTE_SAIDA
