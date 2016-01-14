--[1] Crear una instantánea de la máquina Oracle antes de la ejecución de esta práctica
--[2] Crear un archivo de parámetros de texto PFILE a partir de la configuración del SPFILE actual
CREATE PFILE FROM SPFILE
--[3] Muestra, de dos maneras distintas, el valor actual del parámetro SESSION
SHOW PARAMETER SESSION --sale 247 
	--(otra forma)
SELECT name,value FROM V$PARAMETER WHERE name=’SESSION’;
--[4] Apagar Oracle de forma inmediata (pero segura)
SHUTDOWN IMMEDIATE
--[5] Modificar el archivo anterior para que el parámetro PROCESSES valga 60 y el parámetro
/*
STATISTICS_LEVEL que tome el valor ALL.
Se trata de abrir el archivo de parámetros y modificar processes y añadir ese nuevo
parámetro*/
--[6] Abrir Oracle usando el archivo PFILE modificado.
STARTUP PFILE=E:\app\oracle\product\11.2.0\dbhome_1\database\INITasir.ORA
--[7] Mostrar el valor del parámetro SESSIONS de nuevo. ¿Por qué se ha modificado?
SHOW PARAMETER SESSION --sale 112
--[8] Sin cerrar la sesión actual, abrir una nueva sesión como administrador y ejecutar estos comandos:
CREATE USER geografia IDENTIFIED BY geografia QUOTA UNLIMITED ON USERS;
GRANT CONNECT,RESOURCE,CREATE VIEW TO geografia;
--[9] Conectar con el usuario geografía creado antes y ejecutar el script geografiaCompleta.sql que está en la carpeta de ABD en comunes de Gandhi.
CONNECT geografia/geografia;
@geografiaCompleta.sql
	--(La última instrucción funciona si estamos en el mismo directorio que el archivo, sino hay que poner la ruta completa
--[10] Crea con ese usuario una vista llamada v1 que muestre el nombre de cada localidad y el nombre de la provincia a la que pertenece y el nombre de la comunidad a la que pertenece esa provincia
CREATE VIEW v1 AS
SELECT l.nombre localidad, p.nombre provincia, c.nombre comunidad
FROM localidades l
JOIN provincias p USING(n_provincia)
JOIN comunidades c USING(id_comunidad);
--[11] Crea otra vista llamada v2 en la que muestres el nombre de cada provincia y la población total que tiene.
CREATE VIEW v2 AS
SELECT p.nombre PROVINCIA, SUM(poblacion) POBLACION
FROM provincias p JOIN localidades l USING(n_provincia)
GROUP BY p.nombre;
--[12] Con ese usuario intentar comprobar el valor de la variable SESSIONS. 
--(No se puede)
--[13] Ir a la sesión abierta con el usuario administrador y ejecutar el comando:
ALTER hr IDENTIFIED BY hr
-- [14] Conectar con el usuario hr, contraseña hr y mostrar el nombre de sus tablas.
CONNECT hr/hr
SELECT TABLE_NAME FROM USER_TABLES;
--[15] Con ese mismo usuario, ejecutar este comando:
GRANT SELECT ON regions TO geografia;
--[16] Usando el usuario geografia, mostrar las tablas a las que tenemos acceso del usuario hr
SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER=’HR’;
--[17] Crear, con el usuario geografia, una tabla llamada paises con dos columnas: el nombre del país (no se debe repetir y deben caber hasta 40 caracteres) y la columna id_pais que es la clave y un número de hasta 3 cifras.
CREATE TABLE paises(
id_pais NUMBER(3) CONSTRAINT paises_pk PRIMARY KEY,
nombre VARCHAR(40) CONSTRAINT paises_uk UNIQUE
CONSTRAINT paises_nn NOT NULL);
-- [18] Ir a una sesión del usuario administrador y cerrar la base de datos en modo transaccional.
SHUTDOWN TRANSACTIONAL
-- [19] Intenta desde la otra sesión (la del usuario geografia) mostrar la tabla de paises.
No se puede, tendremos cortada la conexión
-- [20] Arranca Oracle y vuelve a conseguir una conexión como administrador y otra con el usuario geografia.
-- [21] Insertar como país número 1 a España.
INSERT INTO paises VALUES(1, ‘España’);
-- [22] Vuelve a cerrar en modo transaccional. Ahora desde geografía intenta consultar el contenido de la tabla de paises.
-- [23] No se ha cerrado la base de datos. Confirma la última transacción en geografía y observa que ahora sí se cierra
COMMIT; ‘Desde geografía
	--(La base de datos se cierra (igual habría ocurrido con un ROLLBACK))
-- [24] Abre la base de datos en NOMOUNT
STARTUP NOMOUNT
-- [25] Consulta el parámetro PROCESSES. Observa que no posee el valor que habíamos modificado a través del archivo de parámetros.
SHOW PARAMETER processes
-- [26] Consigue que los cambios del PFILE se lleven a cabo en el SPFILE y arranca hasta el modo NOMOUNT comprobando que el nuevo valor funciona.
STARTUP NOMOUNT PFILE=E:\app\oracle\product\11.2.0\dbhome_1\database
CREATE SPFILE FROM PFILE
SHUTDOWN IMMEDIATE
STARTUP NOMOUNT
SHOW PARAMETER PROCESSES
-- [27] Muestra la estructura de la tabla dinámica V$SESSION
DESCRIBE V$SESSION
-- [28] Muestra los usuarios conectados a través de esa vista. No se puede.
SELECT USERNAME FROM V$SESSION;
-- [29] Muestra la estructura de la vista del diccionario de datos. Observa que no se puede
DESCRIBE dict
-- [30] Cambia la base de datos a modo MOUNT y repite la instrucción anterior. Se sigue sin poder
SHUTDOWN IMMEDIATE
STARTUP MOUNT
DESC DICT --(da error)
-- [31] Ahora cambia a OPEN y observa que sí puedes consultar esa vista. Muestra los usuarios conectados a través de V$SESSION. Ahora se puede.
ALTER DATABASE open;
DESC DICT --(ahora se puede)
-- [32] Muestra el nombre de todas las vistas dinámicas (las que comienza con V$) existentes en el diccionario de datos.
SELECT TABLE_NAME FROM DICT WHERE TABLE_NAME LIKE ‘V$%’;
-- [33] Usa el resultado anterior para encontrar las vistas que muestran los parámetros en uso de la SGA
SELECT TABLE_NAME FROM DICT WHERE TABLE_NAME LIKE ‘%SGA%’;
-- [34] Cambia el parámetro SESSIONS para que valga 30 y processes para que valga 50. Observa que no se puede cambiar en la memoria ¿Qué tendriamos que hacer? Hazlo
alter system set sessions=30; --No se puede, da error
alter system set sessions=30 scope=spfile;
alter system set processes=50 scope=spfile;
shutdown immediate
startup
-- [35] Muestra ambos parámetros para comprobar si se han modificado. ¿Por qué sessions no ha tomado nuestro valor? 
	--SESSIONS depende de PROCESSES, el mínimo valor no se puede rebajar
-- [36] Cambia el formato de fecha (parámetro NLS_DATE_FORMAT) para la sesión actual de modo que muestre el día de la semana, luego el día (una o dos cifras), dos cifras para el mes y cuatro para el año. Ese cambio hazle para la sesión actual y también para el SPFILE (no se podría aplicar para la memoria).
ALTER SESSION SET NLS_DATE_FORMAT=’Day DD/MM/yyyy’;
ALTER SYSTEM SET NLS_DATE_FORMAT=’Day DD/MM/yyyy’ SCOPE=SPFILE;
-- [37] Muestra el valor del parámetro OPEN_CURSORS
SHOW PARAMETER OPEN_CURSORS
-- [38] Cambia su valor a 500 para que se aplique ya y además se grabe en el SPFILE.
ALTER SYSTEM SET OPEN_CURSORS=500 SCOPE=BOTH;
-- [39] Copia los parámetros en memoria en un archivo PFILE llamado e:\memory.ora
CREATE PFILE=’E:\MEMORY.ORA’ FROM MEMORY;
-- [40] Copia el SPFILE actual en un archivo PFILE llamado e:\pfile.ora
CREATE PFILE=’E:\PFILE.ORA’ FROM SPFILE;
-- [41] Compara el contenido de ambos archivos
	--Basta con abrirles y observar que el de la memoria es mucho más extenso
-- [42] Mostrar la ruta al archivo de alertas de Oracle
SELECT NAME,VALUE FROM V$DIAG_INFO WHERE name like’%Alert%’;
-- [43] Utiliza la vista V$CONTROLFILE para mostrar las ruitas a los archivos de control en uso:
SELECT NAME FROM v$controlfile;

--(Abre la máquina Windows 64 ASM de Oracle)
-- [44] Realiza los apartados 42 y 43 y saca conclusiones obre las rutas Las rutas a archivos de control están en discos ASM, las rutas a los de traza no.