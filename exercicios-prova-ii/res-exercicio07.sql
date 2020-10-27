
-- Considere o esquema contido no script do arquivo Exercicio 07.sql.

-- 1. Criar Triggers que possam registrar as mudanças que venham a ocorrer na tabela
-- TB_VENDAS: Inclusão, Alteração e Exclusão. Toda inclusão, alteração ou exclusão
-- deverá ser registrada na tabela TB_LOG_VENDAS com o seu respectivo tipo. Somente
-- podem ser alterados os atributos QUANTIDADE E VALOR. Na tabela
-- TB_LOG_VENDAS devem ficar registrados os valores antigos e novos para os atributos
-- QUANTIDADE E VALOR.

CREATE TRIGGER TB_REGISTRA_LOG_UPDATE
ON TB_VENDAS
AFTER UPDATE
AS
INSERT INTO TB_LOG_VENDAS
SELECT GETDATE(),
       TIPO_OPERACAO = 'A',
       I.CD_VENDA,
       I.CD_PRODUTO,
       I.CD_VENDEDOR,
       I.DT_VENDA,
       D.QUANTIDADE,
       D.VALOR,
       I.QUANTIDADE,
       I.VALOR
FROM INSERTED I
JOIN DELETED D
ON (I.CD_VENDA = D.CD_VENDA)


CREATE TRIGGER TB_REGISTRA_LOG_INSERT
ON TB_VENDAS
AFTER INSERT
AS
INSERT INTO TB_LOG_VENDAS
SELECT GETDATE(),
       TIPO_OPERACAO = 'I',
       I.CD_VENDA,
       I.CD_PRODUTO,
       I.CD_VENDEDOR,
       I.DT_VENDA,
       NULL,
       NULL,
       I.QUANTIDADE,
       I.VALOR
FROM INSERTED I


CREATE TRIGGER TB_REGISTRA_LOG_DELETE
ON TB_VENDAS
AFTER DELETE
AS
INSERT INTO TB_LOG_VENDAS
SELECT GETDATE(),
       TIPO_OPERACAO = 'R',
       D.CD_VENDA,
       D.CD_PRODUTO,
       D.CD_VENDEDOR,
       D.DT_VENDA,
       D.QUANTIDADE,
       D.VALOR,
       NULL,
       NULL
FROM DELETED D





