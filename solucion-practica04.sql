/*[1]	Crear todos esos usuarios bajo estas premisas:
	Hay que crear un rol para cada departamento que contenga los privilegios que tendrán los usuarios de dicho departamento
	Los usuarios de producción tienen permiso de crear sus propias tablas, iniciar sesión y crear vistas. Tienen una cuota de 200MB en el tablespace USERS. Su contraseña inicial es '54545'
	Los usuarios de ventas pueden conectar con la base de datos y crear sus propias tablas en su esquema. Tienen una cuota de 100MB en el tablespace USERS. Su contraseña inicial es '34343'
	Los usuarios de dirección podrán conectar, crear otros usuarios y crear tablas y vistas en cualquier esquema. Tienen una cuota ilimitada en el tablespace USERS. Su contraseña inicial es '54321'
	Los usuarios externos sólo podrán conectar conectar con la base de datos. Tienen una cuota de 10MB en el tablespace USERS e inicialmente la cuenta está bloqueada. Su contraseña inicial es '12345'*/
-- Desde la línea de comandos:
sqlplus /nolog
CONNECT / AS SYSDBA

-- Comandos realizados por el superusuario:
CREATE ROLE Externos; 
GRANT CREATE SESSION TO Externos;
CREATE USER  Generico1 IDENTIFIED BY 12345 QUOTA 10M ON USERS ACCOUNT LOCK;
CREATE USER  Generico2 IDENTIFIED BY 12345 QUOTA 10M ON USERS ACCOUNT LOCK;
GRANT Externos TO Generico1,Generico2;

CREATE ROLE Direccion; 
GRANT 
CREATE SESSION,CREATE TABLE, CREATE ANY TABLE,  CREATE ANY VIEW,
SELECT ANY TABLE
TO Direccion;
CREATE USER  Director IDENTIFIED BY 54321 QUOTA UNLIMITED ON USERS;
GRANT Direccion TO Director;

CREATE ROLE Ventas; 
GRANT CREATE SESSION,CREATE TABLE TO Ventas;
CREATE USER  Ventas1 IDENTIFIED BY 34343 QUOTA 100M ON USERS;
CREATE USER  Ventas2 IDENTIFIED BY 34343 QUOTA 100M ON USERS;
CREATE USER  Ventas3 IDENTIFIED BY 34343 QUOTA 100M ON USERS;
GRANT Ventas TO Ventas1,Ventas2,Ventas3;

CREATE ROLE Produccion; 
GRANT CREATE SESSION,CREATE TABLE,CREATE VIEW TO Produccion;
CREATE USER  Prod1 IDENTIFIED BY 54545 QUOTA 200M ON USERS;
CREATE USER  Prod2 IDENTIFIED BY 54545 QUOTA 200M ON USERS;
GRANT Produccion TO Prod1,Prod2;

-- [2]	Crear una tabla en el esquema Director (conectando con dicho usuario)llamada Personal que esté formada por las columnas cod_personal (un nº de 7 cifras enteras), nombre (texto de tamaño 25), salario (número de 11 cifras con 2 decimales) y telefono (texto de tamaño fijo 9). La clave es cod_personal
CONNECT Director       --(meter contraseña 54321)
CREATE TABLE Personal(
cod_personal NUMBER(7) CONSTRAINT per_cod_pk PRIMARY KEY, 
nombre VARCHAR2(25), 
salario NUMBER(11,2),
telefono CHAR(9)
);

/*[3]	Añadir a esa tabla estos datos:
cod_personal	Nombre	Salario	Telefono
1	Antonio	2000	
2	Luisa	1800	979777777
3	Manuel	1000	979876532*/

INSERT INTO Personal VALUES(1,'Antonio',2000,null);
INSERT INTO Personal VALUES(2,'Luisa',1800,'979777777');
INSERT INTO Personal VALUES(3,'Luisa',1000,'979876532');
COMMIT;

--[4]	Usando la misma cuenta Director, dar permiso para consultar la tabla de personal a los usuarios de Producción y Ventas. Además permitir actualizar las columnas nombre y teléfono. Permitir además que los usuarios de producción y ventas puedan otorgar dichos privilegios a otros usuarios.
GRANT select,update (nombre,telefono) 
	ON Personal 
	TO PROD1,PROD2,VENTAS1,VENTAS2,VENTAS3  --No se puede usar GRANT OPTION con Roles
	WITH GRANT OPTION;

--[5]	Dar privilegio de consulta sobre dicha tabla al usuario Generico1 y permitir que dicho usuario pueda conceder a su vez dicho privilegio.
GRANT SELECT ON Personal TO Generico1 WITH GRANT OPTION;

--[6]	Desbloquear el usuario Generico1
CONNECT / AS SYSDBA
ALTER USER Generico1 ACCOUNT UNLOCK;

--[7]	Conectar con el usuario Generico1 y modificar su propia contraseña para que sea Caramelo
CONNECT Generico1 	--(meter contraseña 12345)
ALTER USER Generico1 IDENTIFIED BY Caramelo;

--[8]	Mostrar todos los datos de la tabla Personal del esquema Director
SELECT * FROM Director.Personal;

--[9]	A través de el usuario Generico1, permitir que el usuario Ventas2 pueda consultar la misma tabla
GRANT SELECT ON Director.Personal TO Ventas2;

--[10]	Al usuario Director no le ha gustado que Generico1 haga esas concesiones, por lo que ha decidido retirar el privilegio de que Generico1 pueda conceder permisos sobre SELECT en la tabla Personal (pero sí se permite a Generico1 que consulte dicha tabla); al usuario Ventas2 se le retira también el SELECT sobre esa tabla
CONNECT Director;
REVOKE SELECT ON Personal FROM Generico1,Ventas2;
GRANT SELECT ON Personal TO Generico1;

--[11]	Se  ha decidido que todo el departamento de Producción pueda consultar cualquier tabla en cualquier esquema. Escribir la forma más rápida de hacerlo
GRANT SELECT ANY TABLE TO Produccion;

/*[12]	Se van a aplicar las siguientes directivas sobre todos los usuarios de los departamentos de Producción y Ventas se les va a realizar las siguientes restricciones:
	Se establece un máximo de tres intentos al escribir la contraseña antes de que el usuario se bloquee
	La contraseña caducará a los 30 días
	El periodo de gracia tras caducar la contraseña será de 10 días
	Se permitirá un máximo de tres sesiones concurrentes
	El tiempo máximo de conexión será de 60 minutos
	El tiempo máximo de inactividad será de 9 minutos*/
CREATE PROFILE prodventas LIMIT
		FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LIFE_TIME 30
PASSWORD_GRACE_TIME 10
		SESSIONS_PER_USER 3
		CONNECT_TIME 60
		IDLE_TIME 9;

ALTER USER ventas1 PROFILE prodventas;
ALTER USER ventas2 PROFILE prodventas;
ALTER USER ventas3 PROFILE prodventas;
ALTER USER prod1 PROFILE prodventas;
ALTER USER prod2 PROFILE prodventas;

--[13]	Borrar todos los objetos creados en la práctica.
DROP USER Prod1;
DROP USER Prod2;
DROP USER Ventas1;
DROP USER Ventas2;
DROP USER Ventas3;
DROP USER Director CASCADE;  --(El CASCADE elimina la tabla creada anteriormente)
DROP USER Generico1;
DROP USER Generico2;
DROP ROLE Produccion;
DROP ROLE Ventas;
DROP ROLE Direccion;
DROP ROLE Externos;
DROP PROFILE prodventas;







