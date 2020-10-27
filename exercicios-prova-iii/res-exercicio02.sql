
-- 1. Criar um procedimento armazenado (stored procedure) SP_INCLUI_FORNECEDOR para incluir novos fornecedores. O procedimento deve apresentar os seguintes parâmetros: NM_FORNECEDOR, NM_CONTATO.

create or replace procedure 
    sp_inclui_fornecedor (nm_fornecedor varchar2, nm_contato varchar2, id out number)
as
begin
    insert into tb_fornecedor (cd_fornecedor, nm_fornecedor, nm_contato) 
        values (sq_fornecedor.nextval, nm_fornecedor, nm_contato);
    id := sq_fornecedor.currval;
end;

-- 2. Criar um bloco anônimo para testar o procedimento através da inclusão de alguns fornecedores.

declare
    id number(3);
begin
    sp_inclui_fornecedor('name home', '79888', id);
    dbms_output.put_line(to_char(id));
    select CD_FORNECEDOR ,
        NM_FORNECEDOR ,
        NM_CONTATO ,
        DT_CADASTRO  
    from tb_fornecedor;
end;


-- set serveroutput on 
