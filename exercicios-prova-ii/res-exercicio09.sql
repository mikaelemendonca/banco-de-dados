
-- Considere o esquema do arquivo Exerc�cio 09.sql,

-- Uma ag�ncia de viagens possui como principal modelo de neg�cio a venda de pacotes de
-- viagens. Cada pacote possui um determinado destino (cidade, praia, etc.), o n�mero de dias ,
-- um per�odo de validade (composto por uma data inicial e uma data final) e as datas de sa�da.
-- Os clientes da ag�ncia de viagens, quando est�o interessados em viajar para determinado
-- destino, preenchem um cadastro e informam quais os destinos de seu interesse, assim como o
-- per�odo desejado. Quando surge um novo pacote, a ag�ncia fica respons�vel por entrar em
-- contato com os clientes para oferecer os pacotes que est�o de acordo com o interesse
-- previamente cadastrado.

-- 1. Criar uma trigger para preencher automaticamente as datas de sa�da de um pacote na
-- tabela TB_PACOTE_SAIDA de acordo com as datas inicial e final do pacote. A tabela
-- TB_PACOTE_SAIDA deve ser atualizada todas as vezes que um pacote for inclu�do ou
-- modificado. Ap�s a inclus�o ou altera��o de um pacote, as sa�das devem ser cadastradas
-- ou atualizadas de acordo com o seguinte procedimento:

-- a) As datas de sa�da devem estar compreendidas entre a data inicial e a data final do pacote.

-- b) Deve existir um intervalo de 2 dias entre a chegada de um grupo e a sa�da de outro. A
-- data de chegada de um grupo � determinada pela data de sa�da e n�mero de dias do
-- pacote. Exemplo: Se um pacote de 5 dias tem uma data de sa�da como 01/07/2018, a
-- pr�xima data de sa�da deve ser 08/07/2018, desde que essa data esteja dentro do
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
