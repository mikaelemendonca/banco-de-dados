
-- 1. Criar um procedimento para calcular o aumento de SALÁRIO a ser dado em função do tempo de serviço em uma determinada empresa. O procedimento deve apresentar como parâmetros de entrada o Ano de Admissão e o Salário Atual, e como parâmetro de saída o aumento a ser dado de acordo com a tabela abaixo:

-- Ano de Admissão     Aumento
-- Antes de 2000       20%
-- De 2000 a 2004      10%
-- A partir de 2005    5%

create or replace procedure
    sp_calcula_automento (ano in number, salario in number, aumento out number)
as
begin
    if ano < 2000 then
        aumento := salario * 0.2;
    end if;
    if ano >= 2000 and ano < 2004 then
        aumento := salario * 0.1;
    end if;
    if ano > 2005 then
        aumento := salario * 0.05;
    end if;
end;

declare
    aumento number;
begin
    sp_calcula_automento (1990, 1000, aumento);
    DBMS_OUTPUT.put_line(aumento);
end;

-- 2. Criar uma tabela TB_FUNCIONARIO com os seguintes atributos: MATRICULA, NM_FUNCIONARIO, ANO_ADMISSAO, SALARIO

create table tb_func (
    matricula number(4),
    nm_func varchar2(50),
    ano_admissao number(4),
    salario number(10,2)
);

insert into tb_func values (147, 'mika', 2000, 10000);
insert into tb_func values (148, 'joao', 1990, 1000);

select * from tb_func;

-- 3. Criar um procedimento, utilizando cursores, para percorrer a tabela TB_FUNCIONARIO e atualizar o SALARIO dos funcionários através do aumento calculado a partir do procedimento criado na questão 1.

create or replace procedure sp_atualiza_salario
as
    cursor c_func is select matricula, ano_admissao, salario from tb_func;
    r_func c_func%rowtype;
    aumento number(10,5);
begin
    open c_func;
    loop
        fetch c_func into r_func;
        exit when c_func%notfound;
        sp_calcula_automento (r_func.ano_admissao, r_func.salario, aumento);
        update tb_func set salario = (r_func.salario + aumento) where matricula = r_func.matricula;
    end loop;
end;

begin
    sp_atualiza_salario();
end;
