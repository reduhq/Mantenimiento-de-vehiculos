CREATE DATABASE MantenimientoDeVehiculos
GO
USE MantenimientoDeVehiculos
GO
CREATE TABLE clientes(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre CHAR(50)
)

CREATE TABLE vehiculos(
	n_matricula CHAR(20) PRIMARY KEY,
	id_cliente INT,
)

CREATE TABLE mantenimientos(
	id INT PRIMARY KEY IDENTITY(1,1),
	descripcion CHAR(150),
	precio MONEY,
	tipo CHAR(20) CHECK(tipo = 'ordinario' or tipo = 'extraordinario')
)

CREATE TABLE vehiculos_mantenimientos(
	id INT PRIMARY KEY IDENTITY(1,1),
	matricula_vehiculo CHAR(20),
	id_mantenimiento INT,
	precio MONEY
)

CREATE TABLE repuestos(
	id INT PRIMARY KEY IDENTITY(1,1),
	titulo CHAR(25),
	descripcion CHAR(250),
	marca CHAR(25),
	modelo CHAR(25),
	precio MONEY
)

CREATE TABLE vehiculos_mantenimientos_repuestos(
	id INT PRIMARY KEY IDENTITY(1,1),
	id_vehiculo_mantenimiento INT,
	id_repuesto INT,
	cantidad_repuesto INT,
	precio MONEY
)

CREATE TABLE mecanicos(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre CHAR(50),
	apellido CHAR(50)
)

CREATE TABLE detalle_mecanicos(
	id INT PRIMARY KEY IDENTITY(1,1),
	id_mecanico INT,
	id_vehiculo_mantenimiento INT
)

-- Creacion de integridad relacional/relaciones
ALTER TABLE vehiculos 
ADD FOREIGN KEY(id_cliente)
REFERENCES clientes(id)

ALTER TABLE vehiculos_mantenimientos
ADD FOREIGN KEY(matricula_vehiculo)
REFERENCES vehiculos(n_matricula)

ALTER TABLE vehiculos_mantenimientos
ADD FOREIGN KEY(id_mantenimiento)
REFERENCES mantenimientos(id)

ALTER TABLE vehiculos_mantenimientos_repuestos
ADD FOREIGN KEY(id_vehiculo_mantenimiento)
REFERENCES vehiculos_mantenimientos(id)

ALTER TABLE vehiculos_mantenimientos_repuestos
ADD FOREIGN KEY(id_repuesto)
REFERENCES repuestos(id)

ALTER TABLE detalle_mecanicos
ADD FOREIGN KEY(id_mecanico)
REFERENCES mecanicos(id)

ALTER TABLE detalle_mecanicos
ADD FOREIGN KEY(id_vehiculo_mantenimiento)
REFERENCES vehiculos_mantenimientos(id)

-- Insertando datos
INSERT INTO mantenimientos(descripcion, precio, tipo)
VALUES('Cambio de bandas del motor', 80, 'extraordinario'),
		('Mantenimiento 10000 km', 1800, 'ordinario'),
		('Mantenimiento 5000 km', 1500, 'ordinario'),
		('Revision del sistema electrico', 400, 'extraordinario'),
		('Reparacion del aire acondicionado', 2000, 'extraordinario'),
		('Mantenimiento 25,000 km', 2100, 'ordinario')

INSERT INTO repuestos(titulo, descripcion, marca, modelo, precio)
VALUES('a', '', '', '', 80),
		('b', '', '', '', 150),
		('c', '', '', '', 75),
		('d', '', '', '', 250),
		('e', '', '', '', 600)

INSERT INTO clientes(nombre)
VALUES('Julia'),
		('Maria'),
		('Miguel'),
		('Birin'),
		('Sofia'),
		('Mbappe')

INSERT INTO vehiculos(n_matricula, id_cliente)
VALUES('afdasf', 1),
		('jrwether', 1),
		('gwsahg', 2),
		('qwet', 3),
		('jr3qgw', 4),
		('jrkwe', 5),
		('her', 6),
		('7645asffg', 6),
		('hr3e34', 6)

INSERT INTO vehiculos_mantenimientos(matricula_vehiculo, id_mantenimiento, precio)
VALUES('jrwether', 2, (SELECT precio FROM mantenimientos WHERE id = 2)),
		('jr3qgw', 2, (SELECT precio FROM mantenimientos WHERE id = 2)),
		('jr3qgw', 3, (SELECT precio FROM mantenimientos WHERE id = 3)),
		('7645asffg', 5, (SELECT precio FROM mantenimientos WHERE id = 5)),
		('qwet', 5, (SELECT precio FROM mantenimientos WHERE id = 5))

INSERT INTO vehiculos_mantenimientos_repuestos(id_vehiculo_mantenimiento, id_repuesto, cantidad_repuesto, precio)
VALUES(1, 2, 2, (SELECT precio FROM repuestos WHERE id = 2)),
		(1, 3, 1, (SELECT precio FROM repuestos WHERE id = 3)),
		(3, 1, 1, (SELECT precio FROM repuestos WHERE id = 1)),
		(3, 4, 1, (SELECT precio FROM repuestos WHERE id = 4)),
		(3, 5, 2, (SELECT precio FROM repuestos WHERE id = 5)),
		(5, 2, 1, (SELECT precio FROM repuestos WHERE id = 2))

INSERT INTO mecanicos(nombre, apellido)
VALUES('Mario','Bermudez'),
		('Pepe','Aguilar'),
		('Sandra','Aguilera'),
		('Josue','Peralta'),
		('Freddy','Castillo')

INSERT INTO detalle_mecanicos(id_mecanico, id_vehiculo_mantenimiento)
VALUES(1, 4),
		(5, 1),
		(2, 3),
		(3, 2),
		(4, 5)

-- Consultas
SELECT cl.id n_cliente,
	v.n_matricula matricula_vehiculo,
	mant.id n_mantenimiento,
	mant.precio precio_mantenimiento,
	rep.id n_repuesto,
	vmr.cantidad_repuesto,
	rep.precio precio_repuesto
FROM clientes cl join vehiculos v on cl.id = v.id_cliente
	join vehiculos_mantenimientos vm on vm.matricula_vehiculo = v.n_matricula
	left join vehiculos_mantenimientos_repuestos vmr on vmr.id_vehiculo_mantenimiento = vm.id
	left join repuestos rep on rep.id = vmr.id_repuesto
	join mantenimientos mant on mant.id = vm.id_mantenimiento