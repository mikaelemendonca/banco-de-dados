
-- 1. Criar uma Trigger do tipo AFTER INSERT, UPDATE para a tabela TB_VENDAS. A Trigger deve atualizar a tabela TB_RESUMO_VENDAS de acordo com a venda efetuada ou atualizada.

CREATE TRIGGER TG_ATUALIZA_RESUMO_VENDAS
ON TB_VENDAS
AFTER INSERT, UPDATE
AS

DELETE FROM TB_RESUMO_VENDAS
WHERE 
DT_VENDA IN (SELECT DISTINCT DT_VENDA FROM INSERTED)

INSERT INTO TB_RESUMO_VENDAS
SELECT CD_PRODUTO, DT_VENDA, SUM(QUANTIDADE), SUM(VALOR)
FROM TB_VENDAS
WHERE DT_VENDA IN (SELECT DISTINCT DT_VENDA FROM INSERTED)
GROUP BY CD_PRODUTO, DT_VENDA

