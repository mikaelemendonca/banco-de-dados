
-- 1. Criar uma tabela TB_FUNCIONARIO com os atributos MATRICULA, NOME, SALARIO, CONTRIBUICAO_SINDICAL (Valor Monetário).

create table tb_funcionario (
    matricula number(4),
    nome varchar2(50),
    salario number(5,2),
    contribuicao_sindical number(5,2)
);

-- 2. Criar uma tabela TB_DIFERENCA_CONTRIBUICAO com os atributos MATRICULA e VALOR (Valor Monetário).

create table tb_diferenca_contribuicao (
    matricula number(4),
    valor number(5,2)
);

-- 3. Criar um procedimento SP_CALCULA_CONTRIBUICAO para calcular o valor da contribuição sindical a ser paga por um funcionário em função do seu salário. O procedimento deve apresentar como parâmetro de entrada o Salário, e como parâmetro de saída a contribuição a ser paga. Considere as seguintes informações para cálculo da contribuição sindical:

--    TABELA DE CONTRIBUIÇÃO SINDICAL - 2016 
-- Salário (R$)            Contribuição (% do Salário)
-- <= 1.200,00                     2%
-- > 1.200,00 <= 1.800,00          3%
-- > 1.800,00                      4%

create or replace procedure 
    sp_calcula_contribuicao (salario in number, contribuicao out number)
as
begin
    if salario < 120 then
        contribuicao := salario * 0.02;
    end if;
    if salario > 120 and salario < 180 then
        contribuicao := salario * 0.03;
    end if;
    if salario > 180 then
        contribuicao := salario * 0.04;
    end if;
end;

declare
    contribuicao number;
begin
    sp_calcula_contribuicao (1000, contribuicao);
    dbms_output.put_line(to_char(contribuicao));
end;

begin 
    insert into tb_funcionario values 
        (123, 'joao', 100.0, 10);
    insert into tb_funcionario values 
        (124, 'tata', 50.0, 5);
    insert into tb_funcionario values 
        (125, 'maria', 100.0, 1);
    select * from tb_funcionario;
end;

-- 4. Criar um procedimento armazenado utilizando cursores para percorrer a tabela TB_FUNCIONARIO e, para cada funcionário, verificar, utilizando o procedimento criado no item 3, a diferença entre a contribuição sindical paga (contida na tabela TB_FUNCIONARIO), e a contribuição que deveria ser paga (calculada a partir do procedimento do item 3). Os funcionários que apresentarem diferenças deverão ter o valor da diferença incluído na tabela TB_DIFERENCA_CONTRIBUICAO. O valor devido deve estar como negativo e o valor a ser restituído deverá estar como positivo.

create or replace procedure sp_diferenca_contribuicao
is
    cursor c_funcionarios is select matricula, salario, contribuicao_sindical from tb_funcionario;
    r_funcionarios c_funcionarios%rowtype;
    contrib_calc number(5,2);
begin
    open c_funcionarios;
    loop
        fetch c_funcionarios into r_funcionarios;
        exit when c_funcionarios%notfound;
        dbms_output.put_line('Sal='||to_char(r_funcionarios.salario));
        dbms_output.put_line('Pag='||to_char(r_funcionarios.contribuicao_sindical));
        sp_calcula_contribuicao(r_funcionarios.salario, contrib_calc);
        dbms_output.put_line('Calc='||to_char(contrib_calc));
        dbms_output.put_line('Dif='||to_char(r_funcionarios.contribuicao_sindical - contrib_calc));
        insert into tb_diferenca_contribuicao values (r_funcionarios.matricula, r_funcionarios.contribuicao_sindical - contrib_calc);
    end loop;
end;

begin 
    sp_diferenca_contribuicao();
    select * from tb_diferenca_contribuicao;
end;
    
begin
    for c_emp in (select nome from tb_funcionario) LOOP
        dbms_output.put_line(C_EMP.nome);
    END LOOP;
end;

set serveroutput on;

create or replace procedure teste
as
CURSOR C_EMP IS
select nome from tb_funcionario;
R_EMP C_EMP%ROWTYPE;
BEGIN
  OPEN C_EMP;
    LOOP
    FETCH C_EMP
    INTO R_EMP;
    EXIT WHEN C_EMP%NOTFOUND;
    dbms_output.put_line(R_EMP.nome);
    END LOOP;
  CLOSE C_EMP;
END;

begin teste(); end;
