--Creación TAblespaces

CREATE TABLESPACE normales 
DATAFILE 'E:\app\oracle\oradata\asir\normales.dbf' 
SIZE 40M 
AUTOEXTEND ON
MAXSIZE 400M
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K BLOCKSIZE 8K;


CREATE TABLESPACE administradores 
DATAFILE 'E:\app\oracle\oradata\asir\admin.dbf' 
SIZE 40M 
AUTOEXTEND ON
MAXSIZE 600M
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K BLOCKSIZE 8K;


 CREATE USER raul IDENTIFIED BY 12345
 QUOTA 10M ON USERS;

CREATE USER sofia IDENTIFIED BY 12345
 QUOTA 10M ON USERS;

CREATE USER clara IDENTIFIED BY 12345;
CREATE USER mateo IDENTIFIED BY 12345;
CREATE USER HENAR IDENTIFIED BY 12345;

CREATE USER angel IDENTIFIED BY 12345
QUOTA UNLIMITED ON administradores
DEFAULT TABLESPACE administradores;

---ROLES

CREATE ROLE CREADORES;
CREATE ROLE VISORES;
CREATE ROLE CHULOS;

GRANT CREATE TABLE, CREATE ANY TABLE, CREATE ANY VIEW, 
INSERT ANY TABLE, SELECT ANY TABLE to creadores;

GRANT CREATE SESSION TO VISORES;

GRANT DBA, CONNECT, RESOURCE TO CHULOS;

--PERMISOS DE SISTEMAS Y ROLES A USUARIOS
GRANT CREADORES TO RAUL,SOFIA,ANGEL;
GRANT CREATE SEQUENCE, CREATE VIEW, CREATE MATERIALIZED VIEW TO RAUL;
GRANT CREATE VIEW TO SOFIA;
GRANT VISORES TO CLARA,MATEO, henar;
GRANT CHULOS TO ANGEL;


--BLOQUEOS
ALTER USER RAUL ACCOUNT LOCK;
ALTER USER CLARA ACCOUNT LOCK;
ALTER USER HENAR PASSWORD EXPIRE;


--CREAR Y COMPARTIR RECETAS
CONNECT ANGEL/12345
--SCRIPT RECETAS


CREATE TABLE recetas(
	id_receta NUMBER(4) CONSTRAINT recetas_pk PRIMARY KEY,
	nombre VARCHAR2(50) CONSTRAINT recetas_nn NOT NULL
		CONSTRAINT recetas_uk UNIQUE,
	duracion INTERVAL DAY TO SECOND,
	descripcion CLOB,
	notas CLOB
);

CREATE TABLE medidas(
	id_medida NUMBER(3) CONSTRAINT medidas_pk PRIMARY KEY,
	medida VARCHAR2(25) CONSTRAINT medidas_nn NOT NULL
		CONSTRAINT medidas_uk UNIQUE
);

CREATE TABLE ingredientes(
	id_ingrediente NUMBER(4) CONSTRAINT ingredientes_pk PRIMARY KEY,
	nombre VARCHAR2(25) CONSTRAINT ingredientes_nn NOT NULL
		CONSTRAINT ingredientes_uk UNIQUE
);

CREATE TABLE alinar(
	id_receta NUMBER(4) CONSTRAINT alinar_fk1 REFERENCES recetas
		ON DELETE CASCADE,
	id_ingrediente NUMBER(4) CONSTRAINT alinar_fk2 REFERENCES ingredientes
		ON DELETE CASCADE,
	id_medida NUMBER(3) CONSTRAINT alinar_fk3 REFERENCES medidas
		ON DELETE CASCADE,
	cantidad NUMBER(6,2) CONSTRAINT alinar_ck CHECK(cantidad>0),
	CONSTRAINT ali_pk PRIMARY KEY(id_receta, id_ingrediente, id_medida)
);

INSERT INTO recetas VALUES(9,'Pastel de boniatos con carne y calabaza','0 2:0:00','Por un lado se cuecen las patatas y los boniatos y por otro la calabaza. En ambos casos se hace un puré (sin usar casi agua). Y se deja enfriar.Pochar la cebolla y el pimiento. Añadir el bacon y rehogar. Añadir la carne y hacer hasta que suelte todo el jugo, añadir el pimentón y el ají. Salar.  Añadir los dos huevos batidos y el queso crema a la calabaza y batir junto con la pimienta y la nuez moscada. Calentar el horno y mientras en una fuenta poner una capa de la calabaza, encima el sofrito de carne y encima el pure de patatas y boniato espolvoreado con pan rallado. Hacer al horno fuerte durante 15 o 20 minutos','La calabaza será de tamaño mediano Los bonitos y patatas de tamaño normal');
INSERT INTO recetas VALUES(10,'Solomillo de cerdo con cebolla confitada','0 0:30:00','El solomillo se dora sin cortar a fuego medio para se haga el interior (pero no mucho). Aparte se rehoga la cebolla cortada fina a la que se añade un poco de sal y  azúcar (más azúcar que sal) a fuego suave. Cuando empiece a trasparentar se añade el vino dulce y se deja durante bastante tiempo a fuego suave (unos 15 minutos).  Cuando espese la mezcla se quita del fuego. A parte se corta el solomillo en rodajas a las que se acompaña la mezcla.','Lo ideal es utilizar Oporto, pero con cualquier vino dulce queda bien (con Sansón me quedo perfecto)');
INSERT INTO recetas VALUES(11,'Magret de pato al vino dulce','0 0:15:00','El magret se prepara dorando unos 5 minutos la parte con piel y después otros 2 la parte sin piel (no conviene hacer mucho el interior). Aparte se mezcla la miel con el vino dulce y se reuce al fuego unos 5 minutos. Cuando se dore el magret unir el vino dulce con la miel y dejar al fuego unos 5 minutos más. Para acompañar se puede preparar un puré de castañas, de esta forma, se cuecen las castañas. Se pelan y se mezclan con la nata y la mantequilla. Finalmente se tritura todo.',null);
INSERT INTO recetas VALUES(12,'Tacos de pavo con canónigos y mermelada de sandía','0 1:15:00','Cortar la sandía en trocitos y cocer durante media hora. Retirar agua (aunque no es imprescindible) e incorporrar el azúcar y dejar otra media hora hasta dejar hecha la mermelada de sandía. Mientras cortar la pechuga en tacos gruesos untar de sal y pimienta y dejar marinando con el limón, el aceite y la menta. Tras el proceso de marinado y ya preparada la mermelada, sofreir el ajo en tiras y añadir el pavo. En cuanto se haga el pavo incorporar los canónigos y pasarlo todo unos minutos.',null);
INSERT INTO recetas VALUES(13,'Berenjenas rellenas de cordero y setas','0 1:0:00','Quitar la carne de las berenjenas y cortarlas en cuadraditos. Cortar el cuadraditos el cordero y picar finamente las setas y la cebolla. Freir las carcasas de las berenjenas y retirar. Pochar la carne de corder y después añadir la cebolla y las setas. Rehogar durante 10 o 15 minutos. Añadir el oporto y pasar otros cuatro o cinco minutos. Retirar la mezcla. Saltear la berenjena hasta que quede perfectamente ablandada. En ese punto añadir la mezcla anterior y unirla bien. Añadir la harina y mezclarla hasta que se diluya del todo. Añadir entonces la leche para formar bechamel. Añadir además la nuez moscada y la pimienta. Probar de sal y retirar. Por otro lado en un bol emulsionar la mantequilla derretida con el zumo de la lima.  Añadir y mezclar de forma homogénea el queso. Rellenar las berenjenas con la mezcla de la pulpa, la bechamel y el cordero. En la parte de arriba colocar la mezcla con el queso. Gratinar hasta que se dore el queso.',null);
INSERT INTO recetas VALUES(14,'Enchiladas de cerdo','0 0:15:00','Dorar la carne picada. Después rehogar con el pimiento verde, la cebolla y el ajo hasta que quede bien pochado añadiendo sal y pimienta al gusto. Después añadir queso rallado, los jalapeños y los huevos (si es necesario añadir agua). Una vez cuajados los huevos, rellenar las tortillas con las masa de carne y verdura.Y colocarlas en una fuente de horno. Encima de las tortillas colocar las lonchas de queso y el tomate frito. Hornear unos 10 o 15 minutos a 180 grados y gratinar unos dos minutos.','En lugar del pimiento verde y los jalapeños, se debería utilizar chile.');
INSERT INTO recetas VALUES(15,'Marmitako','0 1:0:00','Picar fino la cebolla, los pimientos y los ajos. Rehogar en la cazuela con un chorro de aceite. Tras pochar, añadir las patatas peladas y troceadas. Rehogar nuevamente unos minutos. Añadir la carne de los pimientos choriceros y la guindilla. Añadir el caldo de pescado. Dejar cocer todo hasta que se hagan las patatas (unos 25 minutos). Después añadir el bonito troceado en tacos y limpio. Hacer unos 5 minutos, probar de sal y espolvorear el perejil picado. Reposar otros 5 minutos fuera del fuego antes de servir.',null);
INSERT INTO recetas VALUES(17,'Cuscús de cordero','0 0:45:00','Cortar el cordero en tacos, el calabacín en rodajas finas, el pimiento y la cebolla en tiras y el ajo en láminas. Dorar el cordero salpimentado en una sarten con un poquito de aceite. Añadir un poco de vino blanco, especia marroquí y pimentón. Una vez dorado, retirar de la sartén. En la misma sarten, rehogar la verdura. Cuando esté rehogada añadir un poco de vino blanco y de caldo. Dejar evaporar un poco y añadir el azúcar. Cuando se rebaje bastante el caldo, añadir el vinagre, canela, pimentón y especia marroquí. Rehogar un par de minutos y añadir el cilantro. Preparar el cuscús según las instrucciones del paquete, pero en el agua echar canela, especia marroquí, una hoja de laurel y azúcar (pecar un poco de exceso de agua). Servir colocando primero en cuscús, encima el guiso de verdura (que deberá quedar con bastante caldo) y finalmente la carne.',null);
INSERT INTO recetas VALUES(18,'Pencas de acelga rellenas de anchoa','0 0:45:00','Trocear las patatas peladas y ponerlas en una cazuela con agua y sal. Cocer unos 20 minutos para hacer un puré. Retirar agua y batir las patatas hasta formar una crema. A dicha crema añadirle perejil picado y un chorrito de aceite de oliva virgen en crudo. De las hojas de acelga coger sólo las pencas (las hojas se pueden reservar para una crema) quitarles los hilos y cortarlas al mismo tamaño (tipo San Jacobo). Cocerlas unos 10 minutos. Confitar los ajos en un buen chorro de aceite. Mientras, majar las anchoas hasta hacer una pasta con las mismas. Añadir los ajos a la pasta y majar el conjunto hasta tener una pasta homogénea. Rellenar dos trozos de penca con la mezcla (haciéndolo estilo San Jacobo). Pasar por huevo y harina y freir utilizando el aceite de los ajos confitados. Saltear en un poquito de aceite las habitas. Presentar el conjunto.',null);
INSERT INTO recetas VALUES(19,'Filete Stroganov con puré de patata','0 1:0:00','Para preparar el puré, pelar las patatas y cocerlas bien. Después retirar el agua y añadir leche caliente y el queso rallado. Batir bien dejando el puré espeso (añadir la leche poco a poco para calcular el espesor). Reservar. Mientras se cuecen las patatas, cortar la carne en tiras, filetear los champiñones, cortar en tiras los pepinillos, en dados el jamón y picar muy fino (brunoise) las chalotes Calentar la mantequilla y dorar las carne. Retirar la misma y reservar.  En la misma cazuela rehogar las chalotes hasta que transparenten. Añadir el pepinillo y el jamón. Rehogar un poco y añadir los champiñones. Mover mientras se hacen los champiñones.  Añadir el caldo de vacuno moviendo continuamente para que no se peguen los ingredientes. Añadir el pimenton y la mostaza, después la nata agria. Cocer todo hasta que quede una salsa espesa. Añadir al guiso la carne y calentar un poco. Añadir la pimienta blanca recién rallado y probar de sal. Retirar del fuego y espolvorear la mitad del perejil picado muy fino. En una sartén dorar un poco el pan rallado junto con el resto del perejil picado. Poner en cada plato el guiso. Añadir un copo de puré y en cima del mismo colocar la mezcla de pan rallado y perejil.',null);
INSERT INTO recetas VALUES(20,'Torta de patatas con salmón','0 0:30:00','Mezcla la mantequilla a punto de pomada con el cebollino picado. Coloca en recipientes pequeños, tápalo con un film transparente y enfría en el frigorífico. Pela y corta las patatas en lonchas finas. Unta un molde de horno con un poco de aceite y coloca las lonchas de patata formando una margarita. Sazona, añade un poco de aceite por encima y hornea a 170º C, durante 20 minutos, hasta que se doren.  Prepara la mezcla para marinar el salmón con la salsa de ostras, la salsa de soja, una pizca de sal, un chorro de aceite y unas hojas de cilantro muy picado. Limpia el salmón, desespina y retírale también la piel dejando solo los lomos. Úntalos con la salsa para marinar y reserva. Saltea el salmón en una sartén.  Sirve, la torta de patatas, encima pon los filetes de salmón, acompaña con la mantequilla de cebollino y adorna con unas ramas de cebollino.','En lugar de salsa de ostras se puede utilizar caldo de pescado (aunque saca el mismo sabor, también queda muy bien)' );
INSERT INTO recetas VALUES(21,'Vitello tonnato','0 2:0:00','Atar con un bramante el redondo. Trocear el apio, la cebolla, el puerro y la zanahoria. En una olla colocar el vinagre, el vino y el agua hasta cubrir el redondo de ternera. Añadir la verdura, sal y pimienta en grano. Cocer durante unos 90 minutos hasta comprobar que la carne esté hecha. Cocer los huevos. Mientras machacar el atún y las anchoas hasta crear una pasta. A ella se le añadirá el aceite, el zumo de los limones y la mitad de las alcaparras. Después añadir un poco de caldo del redondo poco a poco hasta obtener una textura suave y cremosa. Para presentar es convenienta dejar el redondo enfriar un día entero. Después filetear muy fino y colocar junto con la salsa, el resto de alcaparras, los huevos duros fileteados y el tomate en gajos.',null);
INSERT INTO recetas VALUES(22,'Ensalada de cuscús con naranja y frutos secos','0 1:0:00','Preparar el cuscús a la marroquí, es decir. Sustituir el agua parea cocer por caldo de verdura (según las instrucciones del paquete), añadir al hervir un poco de azúcar, canela, comino picado, cúrcuma y especias maqrroquís. Reposar unos minutos y desgranar el cuscús (según instrucciones del paquete). Picar muy fino el perejil.  Preparar el aliño de naranja usando el zumo de las mismas y rallando la corteza, mezclar con el aceite, el vinagre de manzana, el azúcar y la sal en un cuenco grande. Mezclar el cuscús con el perejil, y los frutos (dátiles, sultanas, anacardos,…)',null);
INSERT INTO recetas VALUES(23,'Pollo agridulce con piña','0 0:40:00','Dorar el pollo sazonado y troceado en una cazuela. Picar en juliana el pimiento y la zanahoria. Junto con los brotes de soja, añadir a la cazuela y sofreir un poco. Añadir el zumo y el caldo y dejar cocer el conjunto hasta que el pollo y la verdura queden tiernos.  Añadir el azúcar, el vinagre y la salsa de soja. Además añadir las rodajas troceadas.  Ligar la salsa con harina de maiz disuelta hasta que quede espesa.',null);
INSERT INTO recetas VALUES(24,'Patatas con carne','0 1:0:00',null,null);
INSERT INTO recetas VALUES(4,'Pimientos rellenos a la italiana','0 1:25:00','Preparar los pimientos para rellenar quitándoles la tapa de arriba y quitando las semillas. Cortar en dados el pan y ponerlos en un bol junto con el aceite de oliva de modo que se empapen. Añadir el resto del relleno picando fino todos los ingredientes excepto el queso y el caldo. Mezclar bien todos los ingredientes. Y rellenar con ellos los pimientos. Antes de tapar los pimientos, poner por encima el queso parmesano rallado y agregar el caldo por dentro de los pimientos y por fuera.  Meter los pimientos en el horno precalentado a 180 grados durante una hora','Pg. 112 Las 100 mejores recetas ');
INSERT INTO recetas VALUES(5,'Pollo agridulce con mango al wok','0 0:35:00','Cortar el mango y el puerro en juliana Trocear el pollo y freirle en el wok con el aceite hasta que se haga del todo (unos 10 minutos), entonces añadir el puerro, el mango y los brotes de soja hasta que queden tiernos.  Mientras en un bol, añadir el zumo, la harina, el vinagre, la miel y el ketchup y mezlar bien los ingredientes. Echar la mezcla hasta que se mezcle todo en el wok.','pg. 46 de Recetas de wok El mango debe de ser maduro.');
INSERT INTO recetas VALUES(6,'Bacalao al coco','0 0:30:00','Cortar el pescado en tajadas grandes y quitar las espinas. Rebozar el pescado con la harina. Freir el pescado en un wok.  Mientras majar el ajo y echarle al wok junto con la pasta de curry y la salsa de coco. Añadir los tomates cereza y rehogarlos unos 4 minutos. Finalmente añadir la albahaca cortada en trozos grandes. Acompañar la mezla del wok junto con arroz aromático de acompañamiento.','Pg. 120 de ''Recetas al wok'' La pasta de curry se puede cambiar por curry si no se encuentra');
INSERT INTO recetas VALUES(7,'Pasta al pesto siciliano','0 0:25:00','Mientras se cuece la pasta, preparar el pesto. Mezclar el ajo, los piñones, la sal y las almendras y picarlos en un robot o majar en un mortero. Añadir el orégano picado fino junto con el parmesano, las aceitunas y las alcaparras y volver a picar. Añadir poco a poco el aceite hsta obtener una pasta.  Añadir los tomates y mezclarlos con la pasta.  Tras cocer la pasta saltearla junto con el pesto (al sofreir puede ser necesario añadir agua).',null);
INSERT INTO recetas VALUES(8,'Bacalao a las natas','0 0:15:00','Desalar y desmigar bien el bacalao. Rehogar la cebolla picada y echar el bacalao hasta que se dore. Añadir sal y pimienta y mezclar bien. Partir las patatas en rodajas finas y freir un poco. Colocarlas en una fuente y colocar encima el bacalo y la cebolla. Cubrir de nata, echar el queso rallado y hornear a unos 180 grados durante 5 o 10 minutos.  Finalmente gratinar.',null);

INSERT INTO ingredientes VALUES(4,'Pimiento rojo');
INSERT INTO ingredientes VALUES(5,'Pan de molde tostado');
INSERT INTO ingredientes VALUES(6,'Aceite de Oliva');
INSERT INTO ingredientes VALUES(7,'Alcaparras');
INSERT INTO ingredientes VALUES(8,'Ajo');
INSERT INTO ingredientes VALUES(9,'Anchoa');
INSERT INTO ingredientes VALUES(10,'Perejil');
INSERT INTO ingredientes VALUES(11,'Tomillo');
INSERT INTO ingredientes VALUES(12,'Aceitunas negras');
INSERT INTO ingredientes VALUES(13,'Sal');
INSERT INTO ingredientes VALUES(14,'Pimienta negra');
INSERT INTO ingredientes VALUES(15,'queso Parmesano');
INSERT INTO ingredientes VALUES(16,'Caldo de carne');
INSERT INTO ingredientes VALUES(17,'Pollo');
INSERT INTO ingredientes VALUES(18,'Mango');
INSERT INTO ingredientes VALUES(19,'Puerro');
INSERT INTO ingredientes VALUES(20,'Brotes de soja');
INSERT INTO ingredientes VALUES(21,'Zumo de mango');
INSERT INTO ingredientes VALUES(22,'Vinagre de vino blanco');
INSERT INTO ingredientes VALUES(23,'Miel');
INSERT INTO ingredientes VALUES(24,'Ketchup');
INSERT INTO ingredientes VALUES(25,'Harina de maíz');
INSERT INTO ingredientes VALUES(26,'Cilantro');
INSERT INTO ingredientes VALUES(27,'Bacalao');
INSERT INTO ingredientes VALUES(28,'Harina');
INSERT INTO ingredientes VALUES(29,'Pasta de curry');
INSERT INTO ingredientes VALUES(30,'Caldo de Pescado');
INSERT INTO ingredientes VALUES(31,'Salsa de coco');
INSERT INTO ingredientes VALUES(32,'Tomates cereza');
INSERT INTO ingredientes VALUES(33,'Albahaca');
INSERT INTO ingredientes VALUES(34,'Arroz aromático');
INSERT INTO ingredientes VALUES(35,'Pasta');
INSERT INTO ingredientes VALUES(36,'Piñones');
INSERT INTO ingredientes VALUES(37,'Almendras');
INSERT INTO ingredientes VALUES(38,'Orégano');
INSERT INTO ingredientes VALUES(39,'Tomates en lata');
INSERT INTO ingredientes VALUES(40,'Bacalao desmigado');
INSERT INTO ingredientes VALUES(41,'Patata');
INSERT INTO ingredientes VALUES(42,'Cebolla');
INSERT INTO ingredientes VALUES(43,'Nata');
INSERT INTO ingredientes VALUES(44,'Calabaza');
INSERT INTO ingredientes VALUES(45,'Boniatos');
INSERT INTO ingredientes VALUES(46,'Panceta');
INSERT INTO ingredientes VALUES(48,'Carne picada');
INSERT INTO ingredientes VALUES(51,'Apio');
INSERT INTO ingredientes VALUES(53,'Ají');
INSERT INTO ingredientes VALUES(55,'Pimentón');
INSERT INTO ingredientes VALUES(56,'Huevos');
INSERT INTO ingredientes VALUES(57,'Queso crema');
INSERT INTO ingredientes VALUES(58,'Nuez moscada');
INSERT INTO ingredientes VALUES(59,'Pan rallado');
INSERT INTO ingredientes VALUES(60,'Solomillo de cerdo');
INSERT INTO ingredientes VALUES(61,'Azúcar');
INSERT INTO ingredientes VALUES(62,'Vino dulce');
INSERT INTO ingredientes VALUES(63,'Magret de pato');
INSERT INTO ingredientes VALUES(64,'Castañas');
INSERT INTO ingredientes VALUES(65,'Mantequilla');
INSERT INTO ingredientes VALUES(66,'sandía');
INSERT INTO ingredientes VALUES(67,'Pechiga de pavo');
INSERT INTO ingredientes VALUES(68,'Limón');
INSERT INTO ingredientes VALUES(69,'Menta');
INSERT INTO ingredientes VALUES(70,'Canónigos');
INSERT INTO ingredientes VALUES(71,'Cordero');
INSERT INTO ingredientes VALUES(72,'Berenjena');
INSERT INTO ingredientes VALUES(73,'Setas');
INSERT INTO ingredientes VALUES(74,'Leche');
INSERT INTO ingredientes VALUES(75,'Queso rallado');
INSERT INTO ingredientes VALUES(76,'Lima');
INSERT INTO ingredientes VALUES(77,'Oporto');
INSERT INTO ingredientes VALUES(78,'Tortillas de maíz');
INSERT INTO ingredientes VALUES(79,'Carne picada de cerdo');
INSERT INTO ingredientes VALUES(80,'Pimiento verde');
INSERT INTO ingredientes VALUES(81,'Tomate frito');
INSERT INTO ingredientes VALUES(82,'Lonchas de queso');
INSERT INTO ingredientes VALUES(84,'Jalapeños');
INSERT INTO ingredientes VALUES(85,'Pimienta');
INSERT INTO ingredientes VALUES(86,'Atún');
INSERT INTO ingredientes VALUES(87,'Pimiento Choricero');
INSERT INTO ingredientes VALUES(88,'Tomate maduro');
INSERT INTO ingredientes VALUES(89,'Cayena');
INSERT INTO ingredientes VALUES(90,'cuscús');
INSERT INTO ingredientes VALUES(91,'Canela');
INSERT INTO ingredientes VALUES(92,'Especias marroquíes');
INSERT INTO ingredientes VALUES(93,'Azúcar Moreno');
INSERT INTO ingredientes VALUES(94,'Laurel');
INSERT INTO ingredientes VALUES(95,'Vinagre de Módena');
INSERT INTO ingredientes VALUES(96,'Vino blanco');
INSERT INTO ingredientes VALUES(97,'Calabacín');
INSERT INTO ingredientes VALUES(98,'Acelga');
INSERT INTO ingredientes VALUES(99,'Habas');
INSERT INTO ingredientes VALUES(100,'Filete de Ternera');
INSERT INTO ingredientes VALUES(101,'Jamón cocido');
INSERT INTO ingredientes VALUES(102,'Pepinillos');
INSERT INTO ingredientes VALUES(103,'Chalotes');
INSERT INTO ingredientes VALUES(104,'Champiñones');
INSERT INTO ingredientes VALUES(105,'Mostaza de Dijon');
INSERT INTO ingredientes VALUES(106,'Nata agría');
INSERT INTO ingredientes VALUES(107,'Pimienta blanca');
INSERT INTO ingredientes VALUES(108,'Salmón');
INSERT INTO ingredientes VALUES(109,'Cebollino');
INSERT INTO ingredientes VALUES(110,'Salsa de soja');
INSERT INTO ingredientes VALUES(111,'Salsa de ostras');
INSERT INTO ingredientes VALUES(112,'Redondo de ternera');
INSERT INTO ingredientes VALUES(113,'Zanahoria');
INSERT INTO ingredientes VALUES(114,'Atún al natural');
INSERT INTO ingredientes VALUES(115,'Tomate');
INSERT INTO ingredientes VALUES(116,'Agua');
INSERT INTO ingredientes VALUES(117,'Dátiles');
INSERT INTO ingredientes VALUES(118,'Naranjas de zumo');
INSERT INTO ingredientes VALUES(119,'Vinagre de manzana');
INSERT INTO ingredientes VALUES(120,'Pasas');
INSERT INTO ingredientes VALUES(121,'Jengibre');
INSERT INTO ingredientes VALUES(122,'Anacardos');
INSERT INTO ingredientes VALUES(123,'Cúrcuma');
INSERT INTO ingredientes VALUES(124,'Comino');
INSERT INTO ingredientes VALUES(125,'Caldo de verdura');
INSERT INTO ingredientes VALUES(126,'caldo de pollo');
INSERT INTO ingredientes VALUES(127,'Zumo de piña');
INSERT INTO ingredientes VALUES(128,'Piña');
INSERT INTO ingredientes VALUES(129,'Morcillo de ternera');
INSERT INTO ingredientes VALUES(130,'Vinagre');
INSERT INTO ingredientes VALUES(131,'Mejorana');

INSERT INTO medidas VALUES(1,'gramos');
INSERT INTO medidas VALUES(2,'cabezas');
INSERT INTO medidas VALUES(3,'dientes');
INSERT INTO medidas VALUES(4,'cucharadas soperas');
INSERT INTO medidas VALUES(5,'cucharaditas');
INSERT INTO medidas VALUES(6,'puños');
INSERT INTO medidas VALUES(7,'chorrito');
INSERT INTO medidas VALUES(8,'vaso');
INSERT INTO medidas VALUES(9,'copa');
INSERT INTO medidas VALUES(10,'ml');
INSERT INTO medidas VALUES(11,'litro');
INSERT INTO medidas VALUES(12,'filetes');
INSERT INTO medidas VALUES(13,'unidades');
INSERT INTO medidas VALUES(14,'tajadas');
INSERT INTO medidas VALUES(15,'cucharada');
INSERT INTO medidas VALUES(16,'pizca');
INSERT INTO medidas VALUES(17,'contramuslos');
INSERT INTO medidas VALUES(18,'hojas');
INSERT INTO medidas VALUES(19,'Manojo');
INSERT INTO medidas VALUES(20,'Nuez');
INSERT INTO medidas VALUES(21,'Rodajas');
INSERT INTO medidas VALUES(22,'Hebras');



INSERT INTO alinar VALUES(4,4,13,4);
INSERT INTO alinar VALUES(9,4,13,1);
INSERT INTO alinar VALUES(4,5,13,2);
INSERT INTO alinar VALUES(13,6,7,1);
INSERT INTO alinar VALUES(14,6,7,1);
INSERT INTO alinar VALUES(4,6,10,100);
INSERT INTO alinar VALUES(12,6,13,1);
INSERT INTO alinar VALUES(18,6,13,1);
INSERT INTO alinar VALUES(5,6,15,2);
INSERT INTO alinar VALUES(6,6,15,2);
INSERT INTO alinar VALUES(7,6,15,10);
INSERT INTO alinar VALUES(9,6,15,3);
INSERT INTO alinar VALUES(21,6,15,5);
INSERT INTO alinar VALUES(22,6,15,3);
INSERT INTO alinar VALUES(10,6,16,1);
INSERT INTO alinar VALUES(15,6,16,1);
INSERT INTO alinar VALUES(20,6,16,1);
INSERT INTO alinar VALUES(23,6,16,1);
INSERT INTO alinar VALUES(24,6,16,1);
INSERT INTO alinar VALUES(7,7,13,25);
INSERT INTO alinar VALUES(4,7,15,1);
INSERT INTO alinar VALUES(21,7,15,2);
INSERT INTO alinar VALUES(4,8,3,2);
INSERT INTO alinar VALUES(6,8,3,1);
INSERT INTO alinar VALUES(7,8,3,2);
INSERT INTO alinar VALUES(12,8,3,2);
INSERT INTO alinar VALUES(14,8,3,2);
INSERT INTO alinar VALUES(15,8,3,4);
INSERT INTO alinar VALUES(17,8,3,2);
INSERT INTO alinar VALUES(18,8,3,8);
INSERT INTO alinar VALUES(24,8,3,1);
INSERT INTO alinar VALUES(4,9,12,10);
INSERT INTO alinar VALUES(18,9,12,10);
INSERT INTO alinar VALUES(21,9,13,6);
INSERT INTO alinar VALUES(4,10,15,2);
INSERT INTO alinar VALUES(19,10,15,1);
INSERT INTO alinar VALUES(15,10,16,1);
INSERT INTO alinar VALUES(18,10,16,1);
INSERT INTO alinar VALUES(22,10,19,1);
INSERT INTO alinar VALUES(4,11,15,1);
INSERT INTO alinar VALUES(4,12,13,15);
INSERT INTO alinar VALUES(7,12,13,25);
INSERT INTO alinar VALUES(22,13,5,1);
INSERT INTO alinar VALUES(7,13,13,1);
INSERT INTO alinar VALUES(4,13,16,1);
INSERT INTO alinar VALUES(8,13,16,1);
INSERT INTO alinar VALUES(9,13,16,1);
INSERT INTO alinar VALUES(10,13,16,1);
INSERT INTO alinar VALUES(11,13,16,1);
INSERT INTO alinar VALUES(12,13,16,1);
INSERT INTO alinar VALUES(13,13,16,1);
INSERT INTO alinar VALUES(14,13,16,1);
INSERT INTO alinar VALUES(15,13,16,1);
INSERT INTO alinar VALUES(17,13,16,1);
INSERT INTO alinar VALUES(18,13,16,1);
INSERT INTO alinar VALUES(19,13,16,1);
INSERT INTO alinar VALUES(20,13,16,1);
INSERT INTO alinar VALUES(21,13,16,1);
INSERT INTO alinar VALUES(23,13,16,1);
INSERT INTO alinar VALUES(24,13,16,1);
INSERT INTO alinar VALUES(4,14,16,1);
INSERT INTO alinar VALUES(8,14,16,1);
INSERT INTO alinar VALUES(9,14,16,1);
INSERT INTO alinar VALUES(12,14,16,1);
INSERT INTO alinar VALUES(13,14,16,1);
INSERT INTO alinar VALUES(21,14,16,1);
INSERT INTO alinar VALUES(4,15,1,100);
INSERT INTO alinar VALUES(7,15,1,40);
INSERT INTO alinar VALUES(8,15,1,50);
INSERT INTO alinar VALUES(17,16,8,0.5);
INSERT INTO alinar VALUES(4,16,10,125);
INSERT INTO alinar VALUES(19,16,11,0.25);
INSERT INTO alinar VALUES(23,17,1,700);
INSERT INTO alinar VALUES(5,17,17,6);
INSERT INTO alinar VALUES(5,18,13,1);
INSERT INTO alinar VALUES(5,19,1,225);
INSERT INTO alinar VALUES(21,19,13,1);
INSERT INTO alinar VALUES(5,20,1,100);
INSERT INTO alinar VALUES(23,20,1,100);
INSERT INTO alinar VALUES(5,21,10,150);
INSERT INTO alinar VALUES(21,22,10,200);
INSERT INTO alinar VALUES(5,22,15,1);
INSERT INTO alinar VALUES(5,23,15,2);
INSERT INTO alinar VALUES(11,23,15,1);
INSERT INTO alinar VALUES(5,24,15,2);
INSERT INTO alinar VALUES(5,25,5,1);
INSERT INTO alinar VALUES(23,25,15,1);
INSERT INTO alinar VALUES(5,26,15,1);
INSERT INTO alinar VALUES(17,26,16,1);
INSERT INTO alinar VALUES(20,26,16,1);
INSERT INTO alinar VALUES(6,27,1,450);
INSERT INTO alinar VALUES(6,28,1,25);
INSERT INTO alinar VALUES(18,28,1,50);
INSERT INTO alinar VALUES(13,28,13,2);
INSERT INTO alinar VALUES(6,29,15,2);
INSERT INTO alinar VALUES(15,30,11,1);
INSERT INTO alinar VALUES(6,30,15,2);
INSERT INTO alinar VALUES(6,31,10,300);
INSERT INTO alinar VALUES(6,32,1,175);
INSERT INTO alinar VALUES(6,33,18,20);
INSERT INTO alinar VALUES(6,34,1,250);
INSERT INTO alinar VALUES(7,35,1,250);
INSERT INTO alinar VALUES(7,36,1,30);
INSERT INTO alinar VALUES(7,37,1,60);
INSERT INTO alinar VALUES(7,38,19,1);
INSERT INTO alinar VALUES(7,39,13,4);
INSERT INTO alinar VALUES(8,40,1,250);
INSERT INTO alinar VALUES(15,41,1,1000);
INSERT INTO alinar VALUES(8,41,13,4);
INSERT INTO alinar VALUES(9,41,13,4);
INSERT INTO alinar VALUES(18,41,13,2);
INSERT INTO alinar VALUES(19,41,13,4);
INSERT INTO alinar VALUES(20,41,13,2);
INSERT INTO alinar VALUES(24,41,13,6);
INSERT INTO alinar VALUES(8,42,13,2);
INSERT INTO alinar VALUES(9,42,13,2);
INSERT INTO alinar VALUES(10,42,13,2);
INSERT INTO alinar VALUES(13,42,13,2);
INSERT INTO alinar VALUES(14,42,13,1);
INSERT INTO alinar VALUES(15,42,13,2);
INSERT INTO alinar VALUES(17,42,13,1);
INSERT INTO alinar VALUES(21,42,13,1);
INSERT INTO alinar VALUES(24,42,13,1);
INSERT INTO alinar VALUES(8,43,10,120);
INSERT INTO alinar VALUES(11,43,10,70);
INSERT INTO alinar VALUES(9,44,13,1);
INSERT INTO alinar VALUES(9,45,13,4);
INSERT INTO alinar VALUES(9,46,1,100);
INSERT INTO alinar VALUES(9,48,1,200);
INSERT INTO alinar VALUES(9,51,1,50);
INSERT INTO alinar VALUES(21,51,13,1);
INSERT INTO alinar VALUES(9,53,15,1);
INSERT INTO alinar VALUES(9,55,15,1);
INSERT INTO alinar VALUES(17,55,16,1);
INSERT INTO alinar VALUES(19,55,16,1);
INSERT INTO alinar VALUES(9,56,13,2);
INSERT INTO alinar VALUES(14,56,13,2);
INSERT INTO alinar VALUES(18,56,13,1);
INSERT INTO alinar VALUES(21,56,13,1);
INSERT INTO alinar VALUES(9,57,15,3);
INSERT INTO alinar VALUES(9,58,16,1);
INSERT INTO alinar VALUES(13,58,16,1);
INSERT INTO alinar VALUES(9,59,16,1);
INSERT INTO alinar VALUES(19,59,16,1);
INSERT INTO alinar VALUES(10,60,13,2);
INSERT INTO alinar VALUES(12,61,1,200);
INSERT INTO alinar VALUES(22,61,5,1);
INSERT INTO alinar VALUES(23,61,15,1);
INSERT INTO alinar VALUES(10,61,16,1);
INSERT INTO alinar VALUES(10,62,9,1);
INSERT INTO alinar VALUES(11,62,9,1);
INSERT INTO alinar VALUES(11,63,13,2);
INSERT INTO alinar VALUES(11,64,1,120);
INSERT INTO alinar VALUES(19,65,1,20);
INSERT INTO alinar VALUES(20,65,1,20);
INSERT INTO alinar VALUES(11,65,20,1);
INSERT INTO alinar VALUES(13,65,20,1);
INSERT INTO alinar VALUES(12,66,13,0.5);
INSERT INTO alinar VALUES(12,67,1,400);
INSERT INTO alinar VALUES(12,68,13,2);
INSERT INTO alinar VALUES(21,68,13,2);
INSERT INTO alinar VALUES(12,69,18,4);
INSERT INTO alinar VALUES(12,70,1,80);
INSERT INTO alinar VALUES(13,71,1,350);
INSERT INTO alinar VALUES(17,71,1,400);
INSERT INTO alinar VALUES(13,72,13,4);
INSERT INTO alinar VALUES(13,73,1,100);
INSERT INTO alinar VALUES(13,74,8,1);
INSERT INTO alinar VALUES(19,74,8,1);
INSERT INTO alinar VALUES(13,75,1,50);
INSERT INTO alinar VALUES(14,75,1,30);
INSERT INTO alinar VALUES(19,75,1,30);
INSERT INTO alinar VALUES(13,76,13,1);
INSERT INTO alinar VALUES(13,77,8,0.5);
INSERT INTO alinar VALUES(14,78,13,4);
INSERT INTO alinar VALUES(14,79,1,250);
INSERT INTO alinar VALUES(14,80,13,1);
INSERT INTO alinar VALUES(15,80,13,3);
INSERT INTO alinar VALUES(17,80,13,3);
INSERT INTO alinar VALUES(23,80,13,1);
INSERT INTO alinar VALUES(24,80,13,1);
INSERT INTO alinar VALUES(14,81,1,50);
INSERT INTO alinar VALUES(14,82,13,4);
INSERT INTO alinar VALUES(14,84,16,1);
INSERT INTO alinar VALUES(14,85,16,1);
INSERT INTO alinar VALUES(17,85,16,1);
INSERT INTO alinar VALUES(15,86,1,1000);
INSERT INTO alinar VALUES(15,87,15,1);
INSERT INTO alinar VALUES(15,88,13,2);
INSERT INTO alinar VALUES(15,89,13,2);
INSERT INTO alinar VALUES(17,90,1,200);
INSERT INTO alinar VALUES(22,90,1,200);
INSERT INTO alinar VALUES(22,91,15,1);
INSERT INTO alinar VALUES(17,91,16,1);
INSERT INTO alinar VALUES(22,92,15,1);
INSERT INTO alinar VALUES(17,92,16,1);
INSERT INTO alinar VALUES(17,93,15,1);
INSERT INTO alinar VALUES(17,94,18,1);
INSERT INTO alinar VALUES(17,95,7,1);
INSERT INTO alinar VALUES(17,96,7,1);
INSERT INTO alinar VALUES(24,96,7,1);
INSERT INTO alinar VALUES(21,96,10,300);
INSERT INTO alinar VALUES(17,97,13,1);
INSERT INTO alinar VALUES(18,98,18,6);
INSERT INTO alinar VALUES(18,99,1,100);
INSERT INTO alinar VALUES(19,100,1,350);
INSERT INTO alinar VALUES(19,101,1,60);
INSERT INTO alinar VALUES(19,102,13,8);
INSERT INTO alinar VALUES(19,103,13,6);
INSERT INTO alinar VALUES(19,104,1,200);
INSERT INTO alinar VALUES(19,105,5,0.5);
INSERT INTO alinar VALUES(19,106,11,0.1);
INSERT INTO alinar VALUES(19,107,16,1);
INSERT INTO alinar VALUES(20,108,21,4);
INSERT INTO alinar VALUES(20,109,22,6);
INSERT INTO alinar VALUES(20,110,15,3);
INSERT INTO alinar VALUES(23,110,15,1);
INSERT INTO alinar VALUES(20,111,15,3);
INSERT INTO alinar VALUES(21,112,1,1000);
INSERT INTO alinar VALUES(21,113,13,2);
INSERT INTO alinar VALUES(23,113,13,1);
INSERT INTO alinar VALUES(21,114,1,200);
INSERT INTO alinar VALUES(21,115,13,1);
INSERT INTO alinar VALUES(21,116,10,500);
INSERT INTO alinar VALUES(24,116,11,0.5);
INSERT INTO alinar VALUES(22,117,1,25);
INSERT INTO alinar VALUES(22,118,13,2);
INSERT INTO alinar VALUES(22,119,15,3);
INSERT INTO alinar VALUES(23,119,15,3);
INSERT INTO alinar VALUES(22,120,1,150);
INSERT INTO alinar VALUES(22,121,15,2);
INSERT INTO alinar VALUES(22,122,1,175);
INSERT INTO alinar VALUES(22,123,15,1);
INSERT INTO alinar VALUES(22,124,15,1);
INSERT INTO alinar VALUES(22,125,8,0.5);
INSERT INTO alinar VALUES(23,126,8,1.5);
INSERT INTO alinar VALUES(23,127,8,1);
INSERT INTO alinar VALUES(23,128,21,4);
INSERT INTO alinar VALUES(24,129,1,500);

COMMIT;





CREATE VIEW v_recetas
as
SELECT r.nombre nombre, duracion, descripcion,
	cantidad||' '||medida||' de '|| i.nombre ingrediente
FROM recetas r
JOIN alinar USING(id_receta)
JOIN ingredientes i USING(id_ingrediente)
JOIN medidas m USING (id_medida);


GRANT UPDATE(NOMBRE,DURACION,DESCRIPCION) on recetas to raul;
grant update(nombre),select on ingredientes to raul;
GRANT select on recetas to mateo,clara;
