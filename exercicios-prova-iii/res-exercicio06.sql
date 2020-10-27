
Considere o esquema do arquivo Exercicio 06.sql.

O processo de Faturamento de uma determinada empresa envolve examinar os pedidos
pendentes e gerar informações necessárias para que os pedidos possam ser atendidos. O
processamento de Pedidos é realizado da seguinte maneira: Para cada Pedido com situação
Pendente, é gerada uma linha na tabela TB_FATURAMENTO. Após o registro do
Faturamento, são geradas linhas nas tabelas TB_ITEM_FATURAMENTO ou TB_CORTE
correspondente a cada item de pedido processado. Se um item de pedido pode ser atendido
(existe quantidade suficiente no estoque), é gerada uma linha na tabela
TB_ITEM_FATURAMENTO. Se um item de pedido não pode ser atendido (não existe
quantidade no estoque para atender completamente o item de pedido), é gerada uma linha
na tabela TB_CORTE. Quando o item de pedido gera uma linha em
TB_ITEM_FATURAMENTO, a quantidade em estoque do produto deve ser atualizada. Ao
final do processamento de um pedido, o Faturamento do Pedido é caracterizado como
Completo (quando todos os itens podem ser atendidos), Parcial (quando pelo menos um dos
itens pode ser atendido) ou Cancelado (quando nenhum dos itens pode ser atendido). A
quantidade (QTD_CORTE) na tabela TB_CORTE representa a diferença entre a
quantidade do item de pedido e a quantidade do produto no estoque no momento de
processamento do pedido. Ao final do processamento de um pedido, a situação do pedido é
modificada de PENDENTE para PROCESSADO.

1. Criar um procedimento armazenado em PL/SQL, SP_FATURAMENTO, para
processar os pedidos com situação PENDENTE.
Observações:

a) Os pedidos devem ser processados por ordem de solicitação (DT_PEDIDO);
b) As tabelas TB_FATURAMENTO e TB_CORTE devem fazer uso, respectivamente,
das sequencias SQ_FATURAMENTO e SQ_CORTE como valores para os
atributos COD_FATURAMENTO E COD_CORTE;
c) O processamento de um pedido deve estar no contexto de uma transação. O Pedido
é processado completamente ou nada é processado.

declare
    cursor c_fat is 
        select p.cod_pedido, i.cod_produto, i.quantidade 
        from tb_pedido p
        inner join tb_item_pedido i on (p.cod_pedido = i.cod_pedido)
        where p.situacao = 'PENDENTE';
    r_faturamento c_fat%rowtype;
    qt_estoque number(6);
    situacao varchar2(50);
begin
    open c_fat;
    loop
        fetch c_fat into r_faturamento;
        exit when c_fat%notfound;
        dbms_output.put_line(to_char(r_faturamento.cod_produto));
        select qtd_estoque into qt_estoque from tb_produto
          where cod_produto = r_faturamento.cod_produto;
        dbms_output.put_line(to_char(qt_estoque));
        
        if r_faturamento.quantidade <= qt_estoque then
            insert into tb_corte values (sq_corte.nextval, );
            situacao := '';
            dbms_output.put_line('pode');
        else
            dbms_output.put_line('nao pode');
        end if;
        
        update tb_pedido set situacao = 'PROCESSADO' where cod_pedido = r_faturamento.cod_pedido;
        
    end loop;
    close c_fat;
end;
