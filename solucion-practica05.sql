/*1) Crear un rol llamado operador que permita a los usuarios conectarse a la base de datos, crear tablas en cualquier esquema, consultar tablas de cualquier esquema y crear, modificar y eliminar  tablas en su esquema.*/
CREATE ROLE operador;
GRANT 	CREATE TABLE, CREATE ANY TABLE, 
		SELECT ANY TABLE, CREATE SESSION 
TO operador; 

/* [2]	Crear el usuario Tomas, con contraseña Tomas consiguiendo que tenga una cuota en USERS de 100MB, tenga obligatoriamente que cambiar la contraseña en el siguiente inicio de sesión, le caduquen las contraseñas a los 15 días y sólo pueda realizar tres conexiones simultáneas */
CREATE USER TOMAS IDENTIFIED BY TOMAS QUOTA 100M ON USERS PASSWORD EXPIRE;
CREATE PROFILE TOMAS LIMIT
  PASSWORD_LIFE_TIME 15
  SESSIONS_PER_USER 3;
ALTER USER TOMAS PROFILE TOMAS;

/*[3]	Crear la usuaria Ana, con contraseña Ana consiguiendo que tenga una cuota en USERS de 100MB le caduque la contraseña cada 30 días pero con un periodo de gracia de 7 días, y de modo que si lleva 15 minutos con una conexión abierta pero sin actividad, se le cierre la sesión.*/
CREATE USER ANA IDENTIFIED BY ANA QUOTA 100M ON USERS;
CREATE PROFILE ANA LIMIT
  PASSWORD_LIFE_TIME 30
  PASSWORD_GRACE_TIME 7
  IDLE_TIME 15;
ALTER USER ANA PROFILE ANA;

/*[4]	Crear los usuarios Pedro (contraseña Pedro) y Maria (contraseña Maria) con cuota ilimitada.*/
CREATE USER PEDRO IDENTIFIED BY PEDRO QUOTA UNLIMITED ON USERS;
CREATE USER MARIA IDENTIFIED BY MARIA QUOTA UNLIMITED ON USERS;

-- [5]	Asignar el rol operador a todos los usuarios anteriores excepto a María a la que se le asignará el rol que le permite realizar cualquier cosa en la base de datos.
GRANT operador TO PEDRO,ANA,TOMAS;
GRANT DBA TO MARIA;

-- [6]	Conectar con Maria y crear una tabla llamada tabla1 en el esquema de Pedro con una sola columna col1 de tipo number. Añadir tres filas con los valores 1,2 y3. Aceptar la transacción.
--Conectar con Ana y consultar la tabla1 de Pedro. Ana no puede añadirle filas a Pedro 
CONNECT MARIA
CREATE TABLE PEDRO.TABLA1 (COL1 NUMBER);
INSERT INTO PEDRO.TABLA1 VALUES(1);
INSERT INTO PEDRO.TABLA1 VALUES(2);
INSERT INTO PEDRO.TABLA1 VALUES(3);
COMMIT;

CONNECT ANA
SELECT * FROM PEDRO.TABLA1;
INSERT INTO PEDRO.TABLA1 VALUES(4); --Falla


--[7]	Conectar con Pedro y hacer que Ana pueda añadir y eliminar filas en la tabla1, permitiendo además que pueda conceder estos permisos a otros usuarios.
--Conectar con Ana y darle esos permisos a Tomás
CONNECT PEDRO
GRANT INSERT,DELETE ON TABLA1 TO ANA WITH GRANT OPTION;
connect ANA
GRANT INSERT,DELETE ON PEDRO.TABLA1 TO TOMAS;

--[8]	Pedro no quiere que otros usuarios le modifiquen la tabla así que habla con Ana y Ana quita los permisos concedidos en el apartado anterior a Tomás.
Para prevenir males mayores, Pedro modifica la situación de modo que Ana pueda seguir añadiendo y eliminando filas en la tabla1 de Pedro, pero sin poder conceder estos permisos a otros usuarios.
CONNECT ANA
REVOKE INSERT,DELETE ON PEDRO.TABLA1 FROM TOMAS;
CONNECT PEDRO
REVOKE INSERT,DELETE ON TABLA1 FROM ANA;
GRANT INSERT,DELETE ON TABLA1 TO ANA;

--[9]	María crea una tabla en su esquema llamada tabla2  con una sola columna llamada col1 de tipo number. Añadir los números 4,5 y 6 a la tabla (aceptar la transacción). Conseguir que dicha tabla sea consultable por cualquier usuario (los actuales y los futuros) de la base de datos.
CONNECT MARIA;
CREATE TABLE TABLA2 (COL1 NUMBER);
INSERT INTO TABLA2 VALUES(4);
INSERT INTO TABLA2 VALUES(5);
INSERT INTO TABLA2 VALUES(6);
COMMIT;
GRANT SELECT ON TABLA2 TO PUBLIC;

/*[10]	Usando María, añadir al rol operador la posibilidad de crear vistas, procedimientos y triggers en sus esquemas propios (no en los de otros usuarios. Conectar con Ana y crear el procedimiento llamado Hola: 
CREATE PROCEDURE Hola IS 
BEGIN
	DBMS_OUTPUT.PUT_LINE('Hola');
END;
Dar a Tomas (usando a Ana) el permiso de ejecutar este procedimiento.*/
GRANT CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER TO OPERADOR;

CONNECT ANA;
CREATE PROCEDURE Hola IS 
BEGIN
	dbms_output.put_line('Hola');
END;

GRANT EXECUTE ON HOLA TO TOMAS;

-- [11]	Usando María, quitar el rol operador al usuario Pedro pero permitirle conectar a la base de datos y crearse tablas en su esquema. 
CONNECT MARIA
REVOKE OPERADOR FROM PEDRO;
GRANT CREATE SESSION, CREATE TABLE TO PEDRO;

-- [12]	Borrar todos los roles, perfiles y usuarios creados (desde sys)
DROP USER TOMAS CASCADE;
DROP USER PEDRO CASCADE;
DROP USER ANA CASCADE;
DROP USER MARIA CASCADE;
DROP PROFILE TOMAS;
DROP PROFILE ANA;
DROP ROLE OPERADOR;

