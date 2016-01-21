---------------------     [2] 
SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;
--Los tablespaces nuevos son Normales y Administradores

---------------------     [3] 
SELECT default_tablespace FROM dba_users WHERE username='ANGEL';
-- Es el table_space Administradores

---------------------     [4] 
SELECT GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE='ANGEL';
-- Sale Chulos y Creadores

---------------------     [5] 
--Lista de privilegios
SELECT ROLE,PRIVILEGE,ADMIN_OPTION 
FROM ROLE_SYS_PRIVS WHERE ROLE IN ('CHULOS','CREADORES');
--Lista de roles
SELECT ROLE,GRANTED_ROLE,ADMIN_OPTION 
FROM ROLE_ROLE_PRIVS WHERE ROLE IN ('CHULOS','CREADORES');

---------------------     [6] 
SELECT GRANTEE FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='CREADORES';
-- Son Sofia, raúl, SYS y ANGEL

---------------------     [7] 
REVOKE CREADORES FROM ANGEL;


---------------------     [8] 
connect raul/12345 --falla, Raúl está bloqueado
--Desbloqueo:
connect / as sysdba
ALTER USER RAUL ACCOUNT UNLOCK;
connect raul/12345 --Ahora al conectar se indicará que no hay CREATE SESSION
connect / as sysdba
GRANT CREATE SESSION TO CREADORES;
 
---------------------     [9] 
connect raul/12345
SELECT PRIVILEGE FROM SESSION_PRIVS;

---------------------     [10] 
SELECT grantor,table_name,privilege FROM user_tab_privs_recd;
--Sólo puede hacer SELECT sobre ingredientes de ANGEL
SELECT * FROM  angel.ingredientes;

---------------------     [11] 
connect / as sysdba
SELECT username FROM dba_users WHERE created>='01/02/2015';

ALTER USER HENAR DEFAULT TABLESPACE NORMALES;
ALTER USER MATEO DEFAULT TABLESPACE NORMALES;
ALTER USER SOFIA DEFAULT TABLESPACE NORMALES;
ALTER USER CLARA DEFAULT TABLESPACE NORMALES;
ALTER USER RAUL DEFAULT TABLESPACE NORMALES;

---------------------------   [12]
CONNECT sofia/12345

CREATE TABLE incidencias(
	id_incidencias NUMBER(3) CONSTRAINT incidencias_pk PRIMARY KEY,
	comentario VARCHAR2(50) CONSTRAINT incidencias_nn1 NOT NULL
);


---------------------------   [13]
-- Sofia tiene como TABLESPACE por defecto NORMALES, 
-- pero no tiene cuota ahí, la tiene en USERS
connect / as sysdba
ALTER USER SOFIA QUOTA 10M ON NORMALES;
ALTER USER HENAR QUOTA 10M ON NORMALES;
ALTER USER RAUL QUOTA 10M ON NORMALES;

CONNECT SOFIA/12345
INSERT INTO INCIDENCIAS values(1,'Prueba');
INSERT INTO INCIDENCIAS values(2,'Prueba2');
commit;


---------------------------   [14]
GRANT SELECT,UPDATE(comentario) ON incidencias TO CLARA;
CREATE VIEW CLARA.V_COMENTARIO AS
	SELECT COMENTARIO FROM SOFIA.INCIDENCIAS;

---------------------------   [15]
SELECT * FROM SESSION_ROLES; --sale Visores
CONNECT / AS SYSDBA
SELECT GRANTEE FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE='VISORES';


--------------------------  [16]
--Hay que desbloquearla
CONNECT / AS SYSDBA
ALTER USER clara ACCOUNT UNLOCK;
CONNECT clara/12345
grant select on v_comentario to henar,mateo; --Falla
		--al referirse a la tabla ingredientes de Sofia
		--debió hacerse:
CONNECT SOFIA/12345
GRANT SELECT,UPDATE(comentario) 
ON incidencias TO CLARA
WITH GRANT OPTION;

--aHORA YA PODREMOS:
connect clara/12345
grant select on v_comentario to henar,mateo;

--------------------------  [17]
connect / as sysdba
SELECT username, account_status FROM dba_users
 	 WHERE account_status='EXPIRED'; --Sale Henar

--------------------------  [18] 	 
--Basta con conectar con Henar y poner una nueva contraseña

--------------------------  [19] 	 
CREATE PROFILE practica8 LIMIT
	IDLE_TIME 15
	SESSIONS_PER_USER 2
	FAILED_LOGIN_ATTEMPTS 3
	PASSWORD_LIFE_TIME 30;

ALTER USER ANGEL PROFILE PRACTICA8;	
ALTER USER HENAR PROFILE PRACTICA8;	
ALTER USER CLARA PROFILE PRACTICA8;	
ALTER USER MATEO PROFILE PRACTICA8;	
ALTER USER RAUL PROFILE PRACTICA8;	
ALTER USER SOFIA PROFILE PRACTICA8;	


ALTER USER ANGEL PROFILE DEFAULT;	
