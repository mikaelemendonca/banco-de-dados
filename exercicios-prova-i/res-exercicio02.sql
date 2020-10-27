-- 1. Verificar o conceito de visões particionadas a partir dos seguintes passos:

-- a. Criar três tabelas que representam vendas Semestrais:
/*
	TB_VENDAS_S02_2013
	TB_VENDAS_S01_2014
	TB_VENDAS_S02_2014
	
	As tabelas devem apresentar a seguinte estrutura:
	
	CD_PRODUTO
	CD_FUNCIONARIO
	DT_VENDA
	VALOR_VENDA
	
	A chave primária das tabelas deve ser a composição dos atributos CD_PRODUTO, CD_FUNCIONARIO, DT_VENDA.
	
	O campo data será a coluna de particionamento. Logo, a mesma deve apresentar uma restrição do tipo CHECK que estabeleça o intervalo de datas possível para cada partição.
*/
USE exercicio02

DROP TABLE TB_VENDAS_S02_2013
CREATE TABLE TB_VENDAS_S02_2013 (
	CD_PRODUTO INT NOT NULL,
	CD_FUNCIONARIO INT NOT NULL,
	DT_VENDA DATETIME CHECK (DT_VENDA >= '20130701' AND DT_VENDA < '20140101'),
	VALOR_VENDA NUMERIC(10,2)
	PRIMARY KEY (CD_PRODUTO, CD_FUNCIONARIO, DT_VENDA)
)

DROP TABLE TB_VENDAS_S01_2014 
CREATE TABLE TB_VENDAS_S01_2014 (
	CD_PRODUTO INT NOT NULL,
	CD_FUNCIONARIO INT NOT NULL,
	DT_VENDA DATETIME CHECK (DT_VENDA >= '20140101' AND DT_VENDA < '20140701'),
	VALOR_VENDA NUMERIC(10,2)
	PRIMARY KEY (CD_PRODUTO, CD_FUNCIONARIO, DT_VENDA)
)

DROP TABLE TB_VENDAS_S02_2014 
CREATE TABLE TB_VENDAS_S02_2014 (
	CD_PRODUTO INT NOT NULL,
	CD_FUNCIONARIO INT NOT NULL,
	DT_VENDA DATETIME CHECK (DT_VENDA >= '20140701' AND DT_VENDA < '20150101'),
	VALOR_VENDA NUMERIC(10,2)
	PRIMARY KEY (CD_PRODUTO, CD_FUNCIONARIO, DT_VENDA)
)

SELECT * FROM TB_VENDAS_S02_2013

-- b. Criar uma visão VW_VENDAS utilizando a união de todas as tabelas anteriormente criadas. A união deve ser criada com o operador UNION ALL

DROP VIEW VW_VENDAS
CREATE VIEW VW_VENDAS AS 
SELECT * FROM TB_VENDAS_S02_2013
UNION ALL
SELECT * FROM TB_VENDAS_S01_2014
UNION ALL
SELECT * FROM TB_VENDAS_S02_2014

-- c. Utilizar a visão para incluir valores e verificar a atualização correta da tabela correspondente.

INSERT INTO VW_VENDAS VALUES (1, 5, '2014-02-25', 4555.0)
SELECT * FROM TB_VENDAS_S02_2013
SELECT * FROM TB_VENDAS_S01_2014