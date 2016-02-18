--------------Pregunta 1
SELECT LOG_MODE FROM V$DATABASE;

--------------Pregunta 2
SELECT name,value FROM v$parameter
WHERE name='db_recovery_file_dest';

--------------Pregunta 3
--Examinar REDOLOG
SELECT GROUP#,SEQUENCE#,MEMBERS,STATUS FROM V$LOG;
SELECT GROUP#,STATUS,MEMBER FROM V$LOGFILE;

--Añadir un miembro a cada grupo actual
ALTER DATABASE ADD LOGFILE MEMBER 'c:\multiplexados\RED001.LOG' TO GROUP 1;
ALTER DATABASE ADD LOGFILE MEMBER 'c:\multiplexados\RED002.LOG' TO GROUP 2;
ALTER DATABASE ADD LOGFILE MEMBER 'c:\multiplexados\RED003.LOG' TO GROUP 3;

--Añadir nuevo grupo
ALTER DATABASE ADD LOGFILE ('E:\APP\ORACLE\ORADATA\ASIR\REDO04.L','C:\multiplexados\REDO004.LOG') SIZE 50M;
OG

--------------Pregunta 4
--Comprobar archivos de 3ontrol actuales
SELECT STATUS,NAME FROM V$CONTROLFILE;

--------------Pregunta 5
--Hacer copia del SPFILE por si acaso
CREATE PFILE FROM SPFILE;

--Modificar parámetros
ALTER SYSTEM SET CONTROL_FILES='E:\APP\ORACLE\ORADATA\ASIR\CONTROL01.CTL',
                               'E:\APP\ORACLE\FLASH_RECOVERY_AREA\ASIR\CONTROL02.CTL',
                               'c:\multiplexados\CONTROL03.CTL'
SCOPE=SPFILE;
--Ahora hay que apagar el sistema
SHUTDOWN IMMEDIATE
--DESDE EL SISTEMA OPERATIVO SE COPIA UNO DE LOS ARCHIVOS A LA NUEVA RUTA Y SE LE DA NOMBRE, POR EJEMPLO:
copy E:\APP\ORACLE\ORADATA\ASIR\CONTROL01.CTL c:\multiplexados\CONTROL03.CTL

--------------Pregunta 6
--Establecer parámetros
ALTER SYSTEM SET LOG_ARCHIVE_FORMAT='%s_%t_%r.arc'
SCOPE=SPFILE;

ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST'
SCOPE=SPFILE;

ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='LOCATION=c:\multiplexados\HISTORICOS'
SCOPE=SPFILE;
--Cambiar modo
SHUTDOWN IMMEDIATE
STARTUP MOUNT
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

-------------Pregunta 7
ALTER SYSTEM SET LOG_ARCHIVE_TRACE=1;


--------------Pregunta 8
--Hacer checkpoint
ALTER SYSTEM CHECKPOINT;
SELECT GROUP#,SEQUENCE#,MEMBERS,STATUS FROM V$LOG;

--------------Pregunta 9
--Ejecutar 8 veces
ALTER SYSTEM SWITCH LOGFILE

--------------Pregunta 10
select * from v$log;
select * from v$archived_log;
select * from v$log_history;

--------------Pregunta 11
--Observar ruta al archivo de alerta
SELECT * FROM V$DIAG_INFO
WHERE name LIKE '%Alert%'

--En esa ruta se abre el archivo y se observa lo escrito 


--------------Pregunta 12
CREATE USER geografia IDENTIFIED BY geografia 
QUOTA UNLIMITED ON USERS;

GRANT CONNECT,RESOURCE TO GEOGRAFIA;

--CONECTAR COMN EL USUARIO GEOHGRAFIA Y EJECUTAR EL SCRIPT


--------------Pregunta 13
SHUTDOWN ABORT
STARTUP -- Si no funciona habrá que indicar las secuencias que falten, normalmente no hará falta
