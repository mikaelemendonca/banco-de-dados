
-- 1. Executar as seguintes tarefas:
-- a. Efetuar logon no servidor oracle com o usuário SYSTEM.
-- b. Criar um usuário (esquema) através do seguinte comando do dialeto SQL Oracle:
-- c. Conceder o Role (Papel) DBA para o usuário criado utilizando o seguinte comando:

CREATE USER mika
IDENTIFIED BY 123
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT DBA TO mika;

-- 2. Utilizando o novo esquema criado no item 1 efetuar as seguintes tarefas:

-- a. Criar uma tabela TB_FORNECEDOR com os atributos: CD_FORNECEDOR, NM_FORNECEDOR, NM_CONTATO, DT_CADASTRO. A data de cadastro (DT_CADASTRO) representa um atributo com restrição DEFAULT que inclui a data e hora atual do sistema. O código do Fornecedor (CD_FORNECEDOR) deve ser chave primária.

-- b. Criar um objeto SEQUENCE (SQ_FORNECEDOR) para servir de auto incremento para o atributo CD_FORNECEDOR

-- c. Incluir alguns fornecedores utilizando o objeto SEQUENCE criado.

create table tb_fornecedor (
    cd_fornecedor number(5),
    nm_fornecedor varchar2(50),
    nm_contato varchar2(50),
    dt_cadastro date default sysdate
);

insert into tb_fornecedor (cd_fornecedor, nm_fornecedor, nm_contato) values (2, 'nome', '799999');
select * from tb_fornecedor ;

create sequence sq_fornecedor
star with 1 increment by 1
nocache;

INSERT INTO tb_fornecedor (cd_fornecedor, nm_fornecedor, nm_contato)  VALUES (sq_fornecedor.nextval, 'nome', '799999');

create table tb_aluno2 (
  matricula number(2) not null,
  nm_aluno varchar2(50),
  dt_nascimento date not null
);
