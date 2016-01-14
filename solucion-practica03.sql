--[1]	Crear un usuario llamado conectador (con cualquier contraseña) y permitirle conectar a la base de datos. Darle una cuto en el tablespace USERS de 100MB
--conectar como SQLPLUS /NOLOG
CONNECT / AS SYSDBA
CREATE USER conectador IDENTIFIED BY 12345 QUOTA 100M ON USERS;
GRANT CREATE SESSION TO conectador;

--[2]	Crear un usuario llamado tabla (con cualquier contraseña) con capacidad de conectar a la base de datos, crear tablas y crear vistas.
CREATE USER tabla IDENTIFIED BY 12345 QUOTA 100M ON USERS;
GRANT CREATE SESSION,CREATE TABLE,CREATE VIEW TO tabla;

--[3]	Crear un usuario llamado supertabla con capacidad de conectar a la base de datos y crear tablas en cualquier esquema de la base de datos
CREATE USER supertabla IDENTIFIED BY 12345 QUOTA 100M ON USERS;
GRANT CREATE SESSION,CREATE ANY TABLE, CREATE ANY INDEX , UPDATE ANY TABLE, SELECT ANY TABLE, INSERT ANY TABLE TO supertabla;
--Nota: CREATE ANY INDEX permite poner la clave primaria (entre otras cosas)

--[4]	Crear un usuario llamado dador con los mismos permisos que el usuario tabla y además la capacidad de concederles
CREATE USER dador IDENTIFIED BY 12345 QUOTA 100M ON USERS;
GRANT CREATE SESSION,CREATE TABLE,CREATE VIEW TO dador WITH ADMIN OPTION;

--[5]	Crear el usuario temporal con capacidad de conectarse a la base de datos, pero su cuenta bloqueada
CREATE USER temporal IDENTIFIED BY 12345 QUOTA 100M ON USERS ACCOUNT LOCK;
GRANT CREATE SESSION TO temporal;

--[6]	Conectar con el usuario tabla y crear en su esquema una tabla llamada personas que tenga dos columnas, cod_persona (un nº) y el nombre de la persona (un texto de tamaño 25). Añadir las personas: 1, Antonio; 2, Laura; 3, Felisa
CONNECT tabla
CREATE TABLE personas(cod_persona NUMBER CONSTRAINT per_cod_pk PRIMARY KEY, nombre VARCHAR(25));
INSERT INTO personas VALUES(1,'Antonio');
INSERT INTO personas VALUES(2,'Laura');
INSERT INTO personas VALUES(3,'Felisa');
COMMIT;

--[7]	Conectar con el usuario supertabla y crear una tabla en el esquema del usuario tabla llamada tareas con dos columnas cod_tarea (nº) y descripción (texto de tamaño 40). Conseguir (haciendo lo necesario) para añadir las filas: 1,Instalar S.O.; 2, Instalar SW; 3, Probar instalación
CONNECT supertabla
CREATE TABLE tabla.tareas(cod_tarea NUMBER CONSTRAINT tar_cod_pk PRIMARY KEY, descripción VARCHAR(25));
INSERT INTO tabla.tareas VALUES(1,'Instalar S.O.');
INSERT INTO tabla.tareas VALUES(2,'Instalar SW');
INSERT INTO  tabla.areas VALUES(3,'Probar instalación');
COMMIT;
                                           
--[8]	Conectar con el usuario tabla y dar permiso de consulta sobre su tabla de personas para que la lea el usuario, conectador
CONNECT tabla;
GRANT SELECT ON personas TO conectador;

--[9]	Conectar con conectador y conseguir mostrar el contenido de la tabla personas en el esquema tabla
CONNECT  conectador
SELECT * FROM tabla.personas;

--[10]	Conectar con dador y sólo usando dicho usuario, conceder permiso de creación de tablas al usuario conectador
CONNECT dador
GRANT CREATE TABLE TO conectador;

--[11]	Usando a conectador, crear una tabla llamada prueba con una sola columna x de tipo entero. Permitir la escritura, borrado y modificación de datos en esa tabla al usuario dador
CONNECT conectador
CREATE TABLE prueba(x NUMBER);
GRANT INSERT, UPDATE, DELETE, SELECT ON prueba TO dador;

--[12]	Mediante el usuario dador, añadir tres filas cualquiera en la tabla prueba creada anteriormente. Confirmar la transacción
CONNECT dador
INSERT INTO conectador.prueba VALUES(1);
INSERT INTO conectador.prueba VALUES(2);
INSERT INTO conectador.prueba VALUES(3);
COMMIT;


--[13]	Desbloquear al usuario temporal  y asignarle privilegios de conexión a la base de datos y creación y borrado de usuarios. 
CONNECT / AS SYSDBA
ALTER USER temporal ACCOUNT UNLOCK;
GRANT CREATE SESSION, CREATE USER, DROP USER TO temporal

--[14]	Usando a temporal, eliminar a todos los usuarios anteriores
CONNECT temporal
DROP USER conectador CASCADE;
DROP USER dador CASCADE;
DROP USER tabla CASCADE;
DROP USER supertabla CASCADE;

--[15]	Cambiar la contraseña al usuario temporal.
--Sin salir del usuario
ALTER USER temporal IDENTIFIED BY 54321;
