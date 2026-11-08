
-- ============================================================
-- PRACTICA 5 - EJERCICIO 2.3
-- Pruebas de integridad referencial
-- Base de datos: ProyectoBDD
-- ============================================================


-- 1. PRUEBA DE DELETE CASCADE
-- Se comprueba la relacion entre renta e inspeccionrenta.
-- La eliminacion de la renta debe eliminar sus inspecciones.

BEGIN;

SELECT *
FROM inspeccionrenta
WHERE idrenta = 1;

DELETE FROM renta
WHERE idrenta = 1;

SELECT *
FROM inspeccionrenta
WHERE idrenta = 1;

ROLLBACK;


-- 2. PRUEBA DE DELETE RESTRICT
-- Se intenta eliminar un cliente que tiene registros
-- relacionados en venta y renta.
-- PostgreSQL debe rechazar la eliminacion.

BEGIN;

DELETE FROM cliente
WHERE idcliente = 1;

-- Si PostgreSQL rechaza el DELETE, ejecutar por separado:
ROLLBACK;


-- 3. PRUEBA DE UPDATE CASCADE
-- Se cambia temporalmente la clave primaria del cliente.
-- El cambio debe propagarse a las tablas relacionadas.

BEGIN;

UPDATE cliente
SET idcliente = 999
WHERE idcliente = 1;

SELECT *
FROM telefonocliente
WHERE idcliente = 999;

SELECT *
FROM venta
WHERE idcliente = 999;

SELECT *
FROM renta
WHERE idcliente = 999;

ROLLBACK;


-- 4. PRUEBA DE INSERCION CON UNA CLAVE FORANEA INEXISTENTE
-- Se intenta registrar un telefono para un cliente
-- que no existe.
-- PostgreSQL debe rechazar la insercion.

BEGIN;

INSERT INTO telefonocliente (idcliente, telefono)
VALUES (999, '5500000000');

-- Si PostgreSQL rechaza el INSERT, ejecutar por separado:
ROLLBACK;


-- 5. PRUEBA DEL ORDEN DE CARGA:
-- Primero debe existir el registro padre (cliente).
-- Despues se puede insertar el registro hijo (telefonocliente).

BEGIN;

INSERT INTO cliente (
    idcliente,
    nombre,
    apellidopaterno,
    apellidomaterno,
    correo,
    calle,
    numero,
    colonia,
    codigopostal
)
VALUES (
    999,
    'Cliente',
    'Prueba',
    'Orden',
    'prueba.orden@correo.com',
    'Calle de Prueba',
    '100',
    'Centro',
    '06000'
);

INSERT INTO telefonocliente (idcliente, telefono)
VALUES (999, '5500000000');

SELECT *
FROM cliente
WHERE idcliente = 999;

SELECT *
FROM telefonocliente
WHERE idcliente = 999;

ROLLBACK;
