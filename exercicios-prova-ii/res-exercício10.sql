
-- 1. Criar a seguinte tabela de auditoria.

CREATE TABLE  TB_LOG_AUDITORIA  (
   id_log		int not null primary key identity(1,1),
   dt_log		datetime,
   nm_login     varchar(30),
   nm_usuario	varchar(30),
   banco		nvarchar(100),
   esquema	    nvarchar(100),
   nm_objeto	nvarchar(100),
   tipo_objeto	nvarchar(100),
   evento		nvarchar(100),
   comando	    nvarchar(2000)
) 

-- 2. Criar uma Trigger DDL para registrar na tabela criada no item 1 os eventos de criação, alteração e remoção de tabelas, views e stored procedures.

CREATE TRIGGER TG_DDL_ALTERACOES_ESQUEMA 
ON DATABASE
FOR DDL_TABLE_EVENTS, DDL_VIEW_EVENTS, DDL_PROCEDURE_EVENTS
AS 
DECLARE @evento XML
SET @evento = EVENTDATA()
INSERT INTO TB_LOG_AUDITORIA(dt_log, 
							 nm_login, 
							 nm_usuario, 
							 banco, 
							 esquema,
							 nm_objeto,
							 tipo_objeto,
							 evento, 
							 comando)
VALUES(
        GETDATE(),
        @evento.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(30)'), 
        @evento.value('(/EVENT_INSTANCE/UserName)[1]', 'nvarchar(30)'),
        @evento.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'nvarchar(100)'),
        @evento.value('(/EVENT_INSTANCE/SchemaName)[1]', 'nvarchar(100)'),
        @evento.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)'),
        @evento.value('(/EVENT_INSTANCE/ObjectType)[1]', 'nvarchar(100)'),
        @evento.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
        @evento.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'nvarchar(2000)')
       )

-- 3. Criar uma Trigger DDL para assegurar que os novos objetos criados no banco de dados tenham o seguinte padrão de nomenclatura:
-- a) Nomes de Tabelas devem iniciar com TB_
-- b) Nomes de Views devem iniciar com VW_
-- c) Nomes de Stored Procedures devem iniciar com SP_

-- 4. Refatore a Trigger criada no item 3 para que as adições de novos padrões possam ser realizadas sem alteração no código da Trigger.

CREATE TABLE TB_PADRAO (
	tipo varchar(100),
	prefixo varchar(3)
)

insert into tb_padrao values('TABLE','TB_')
insert into tb_padrao values('VIEW','VW_')


CREATE TRIGGER TG_DDL_ALTERACOES_ESQUEMA 
ON DATABASE
FOR CREATE_TABLE, CREATE_VIEW 
AS 
DECLARE @evento XML,
        @tipo_objeto nvarchar(100),
        @nome_objeto nvarchar(100),
        @prefixo varchar(3),
        @MENSAGEM VARCHAR(200)
        
SET @evento = EVENTDATA()
SET @tipo_objeto = @evento.value('(/EVENT_INSTANCE/ObjectType)[1]', 'nvarchar(100)')
SET @nome_objeto = @evento.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)')
SET @prefixo = (SELECT prefixo from tb_padrao WHERE tipo = @tipo_objeto)
if @prefixo is not null
   begin
      if LEFT(@nome_objeto,3) <> @prefixo
        begin
          set @mensagem = 'O prefixo para o nome desse objeto deve ser ' + @prefixo
          RAISERROR(@mensagem, 1,1)
          ROLLBACK
        end
   end