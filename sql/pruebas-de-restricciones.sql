-- ============================================================================
-- Práctica 3: Pruebas de Violación de Restricciones (Ejercicio 6.2)
-- ============================================================================

INSERT INTO cliente (nombre, apellido, telefono, correo) 
VALUES ('Carlos', 'Gómez', '5511223344', 'carlos.gomez@gmail.com');

INSERT INTO vehiculo (vin, marca, modelo, anio, color, kilometraje, tipo_operacion)
VALUES ('3N1AB7AP8KY123456', 'Nissan', 'Versa', 2022, 'Gris', 35000, 'RENTA');

INSERT INTO vehiculo_renta (id_vehiculo, tarifa_diaria, deposito_garantia)
VALUES (1, 850.00, 2500.00);

-- PRUEBA 1: Violación de Clave Foránea
INSERT INTO renta (id_cliente, id_empleado, id_vehiculo, fecha_inicio, fecha_devolucion_prevista, importe_total)
VALUES (1, 1, 999, '2026-11-01 10:00:00', '2026-11-05 18:00:00', 3400.00);

-- PRUEBA 2: Violación de Restricción CHECK
INSERT INTO renta (id_cliente, id_empleado, id_vehiculo, fecha_inicio, fecha_devolucion_prevista, importe_total)
VALUES (1, 1, 1, '2026-11-10 10:00:00', '2026-11-02 10:00:00', 2500.00);

-- PRUEBA 3: Violación de Clave Única (UNIQUE)
INSERT INTO cliente (nombre, apellido, telefono, correo) 
VALUES ('Alberto', 'Pérez', '5599887766', 'carlos.gomez@gmail.com');