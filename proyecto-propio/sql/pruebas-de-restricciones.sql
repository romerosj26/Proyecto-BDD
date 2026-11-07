-- Datos válidos de apoyo
INSERT INTO cliente (nombre, apellidoPaterno, correo, calle, numero, colonia, codigoPostal)
VALUES ('Ana', 'Lopez', 'ana@correo.com', 'Reforma', '10', 'Centro', '06000');
INSERT INTO empleado (numeroEmpleado, nombre, apellidoPaterno, telefono, correo)
VALUES ('E-001', 'Luis', 'Perez', '5512345678', 'luis@concesionaria.com');
INSERT INTO vehiculo (VIN, marca, modelo, anio, color)
VALUES ('ABC12345678901234', 'Nissan', 'Versa', 2024, 'Gris');
INSERT INTO vehiculoRenta (idVehiculo, tarifaDiaria, categoria) VALUES (1, 650.00, 'Compacto');
INSERT INTO renta (idCliente, idEmpleado, idVehiculo, fechaHoraInicio, fechaHoraDevPrevista, tarifaAplicada, importeTotal, estado)
VALUES (1, 1, 1, '2026-11-01 10:00', '2026-11-05 10:00', 650.00, 2600.00, 'Activa');

-- Rechazo 1 (UNIQUE): VIN repetido
INSERT INTO vehiculo (VIN, marca, modelo, anio, color)
VALUES ('ABC12345678901234', 'Kia', 'Rio', 2023, 'Rojo');

-- Rechazo 2 (FOREIGN KEY): venta con un cliente que no existe
INSERT INTO venta (idCliente, idEmpleado, fecha, importeTotal)
VALUES (999, 1, '2026-11-02', 250000.00);

-- Rechazo 3 (CHECK): devolución prevista anterior al inicio
INSERT INTO renta (idCliente, idEmpleado, idVehiculo, fechaHoraInicio, fechaHoraDevPrevista, tarifaAplicada, importeTotal)
VALUES (1, 1, 1, '2026-12-10 10:00', '2026-12-09 10:00', 650.00, 650.00);

-- Rechazo 4 (CHECK): estado de renta fuera del catálogo
INSERT INTO renta (idCliente, idEmpleado, idVehiculo, fechaHoraInicio, fechaHoraDevPrevista, tarifaAplicada, importeTotal, estado)
VALUES (1, 1, 1, '2026-12-01 10:00', '2026-12-03 10:00', 650.00, 1300.00, 'Pendiente');

-- Rechazo 5 (NOT NULL): cliente sin correo
INSERT INTO cliente (nombre, apellidoPaterno, correo, calle, numero, colonia, codigoPostal)
VALUES ('Beto', 'Ruiz', NULL, 'Hidalgo', '5', 'Roma', '06700');

-- Rechazo 6 (EXCLUDE): renta que se traslapa con otra vigente del mismo vehículo
INSERT INTO renta (idCliente, idEmpleado, idVehiculo, fechaHoraInicio, fechaHoraDevPrevista, tarifaAplicada, importeTotal, estado)
VALUES (1, 1, 1, '2026-11-03 10:00', '2026-11-07 10:00', 650.00, 2600.00, 'Reservada');

-- Rechazo 7 (PRIMARY KEY/UNIQUE): una tercera inspección del mismo tipo en la renta
INSERT INTO inspeccionRenta (idRenta, tipo, fechaHora, kilometraje, nivelCombustible)
VALUES (1, 'Entrega', '2026-11-01 10:00', 12000, 100);
INSERT INTO inspeccionRenta (idRenta, tipo, fechaHora, kilometraje, nivelCombustible)
VALUES (1, 'Entrega', '2026-11-01 10:05', 12000, 100);
