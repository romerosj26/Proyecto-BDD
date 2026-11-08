
-- ============================================================
-- PRACTICA 5 - EJERCICIO 2.4
-- Edicion de valores y transacciones
-- Base de datos: ProyectoBDD
-- ============================================================


-- ------------------------------------------------------------
-- 2.4.1 INSERT basado en una consulta y resolucion de duplicados
-- ------------------------------------------------------------

-- Insertar un telefono para el cliente Ana Lopez.

INSERT INTO telefonocliente (idcliente, telefono)
SELECT idcliente, '5598765432'
FROM cliente
WHERE correo = 'ana@correo.com';


-- Intentar insertar nuevamente el mismo telefono.
-- ON CONFLICT evita duplicar la clave primaria compuesta.

INSERT INTO telefonocliente (idcliente, telefono)
SELECT idcliente, '5598765432'
FROM cliente
WHERE correo = 'ana@correo.com'
ON CONFLICT (idcliente, telefono) DO NOTHING;


-- Consultar los telefonos registrados para Ana Lopez.

SELECT *
FROM telefonocliente
WHERE idcliente = (
    SELECT idcliente
    FROM cliente
    WHERE correo = 'ana@correo.com'
);


-- ------------------------------------------------------------
-- 2.4.2 UPDATE dependiente de otra tabla y UPDATE con CASE
-- ------------------------------------------------------------

-- Actualizar el importe total de las ventas utilizando
-- la suma de los precios de sus detalles.

BEGIN;

UPDATE venta AS v
SET importetotal = totales.total_calculado
FROM (
    SELECT
        idventa,
        SUM(precioaplicado) AS total_calculado
    FROM detalleventa
    GROUP BY idventa
) AS totales
WHERE v.idventa = totales.idventa
RETURNING
    v.idventa,
    v.importetotal;

ROLLBACK;


-- Actualizar la condicion de los vehiculos de venta
-- dependiendo de su kilometraje.

BEGIN;

UPDATE vehiculoventa AS vv
SET condicion = CASE
    WHEN v.kilometraje = 0 THEN 'Nuevo'
    ELSE 'Usado'
END
FROM vehiculo AS v
WHERE vv.idvehiculo = v.idvehiculo
RETURNING
    vv.idvehiculo,
    v.marca,
    v.modelo,
    v.kilometraje,
    vv.condicion;

ROLLBACK;


-- ------------------------------------------------------------
-- 2.4.3 DELETE con subconsulta y eliminacion logica
-- ------------------------------------------------------------

-- Consultar el telefono temporal de Ana Lopez.

BEGIN;

SELECT *
FROM telefonocliente
WHERE idcliente = (
    SELECT idcliente
    FROM cliente
    WHERE correo = 'ana@correo.com'
)
AND telefono = '5598765432';


-- Eliminar fisicamente el telefono temporal.

DELETE FROM telefonocliente
WHERE idcliente = (
    SELECT idcliente
    FROM cliente
    WHERE correo = 'ana@correo.com'
)
AND telefono = '5598765432';


-- Comprobar que el telefono fue eliminado.

SELECT *
FROM telefonocliente
WHERE idcliente = (
    SELECT idcliente
    FROM cliente
    WHERE correo = 'ana@correo.com'
);

COMMIT;


-- Simular una eliminacion logica de una renta.
-- En lugar de eliminar la fila, se cambia su estado.

BEGIN;

SELECT idrenta, estado
FROM renta
WHERE idrenta = 12;

UPDATE renta
SET estado = 'Cancelada'
WHERE idrenta = 12;

SELECT idrenta, estado
FROM renta
WHERE idrenta = 12;

ROLLBACK;


-- ------------------------------------------------------------
-- 2.4.4 Transaccion multitabla con SAVEPOINT
-- ------------------------------------------------------------

-- Crear un cliente y realizar operaciones relacionadas
-- con sus telefonos dentro de una misma transaccion.

BEGIN;

INSERT INTO cliente (
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
    'Daniel',
    'Prueba',
    'Transaccion',
    'prueba.transaccion@correo.com',
    'Avenida Ejemplo',
    '200',
    'Centro',
    '06000'
)
RETURNING idcliente;


-- Crear un punto de recuperacion antes de insertar
-- el primer telefono.

SAVEPOINT punto_telefono;

INSERT INTO telefonocliente (idcliente, telefono)
VALUES (15, '5511111115');

SELECT *
FROM telefonocliente
WHERE idcliente = 15;


-- Revertir solamente la operacion posterior al SAVEPOINT.

ROLLBACK TO SAVEPOINT punto_telefono;

SELECT *
FROM telefonocliente
WHERE idcliente = 15;


-- Insertar el telefono definitivo y confirmar
-- la transaccion completa.

INSERT INTO telefonocliente (idcliente, telefono)
VALUES (15, '5522222215');

COMMIT;


-- Comprobar los registros que quedaron guardados.

SELECT *
FROM cliente
WHERE correo = 'prueba.transaccion@correo.com';

SELECT *
FROM telefonocliente
WHERE idcliente = 15;


-- ------------------------------------------------------------
-- 2.4.5 Transaccion que falla por una restriccion
-- ------------------------------------------------------------

-- Comprobar que el correo de prueba no exista.

SELECT *
FROM cliente
WHERE correo = 'fallo.transaccion@correo.com';


-- Iniciar una transaccion e insertar un cliente.

BEGIN;

INSERT INTO cliente (
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
    'Carlos',
    'Prueba',
    'Fallo',
    'fallo.transaccion@correo.com',
    'Calle de Prueba',
    '300',
    'Centro',
    '06000'
)
RETURNING idcliente;


-- Intentar insertar un telefono con un cliente inexistente.
-- Esta operacion debe provocar un error de clave foranea.

INSERT INTO telefonocliente (idcliente, telefono)
VALUES (999999, '5533333333');


-- IMPORTANTE:
-- Despues del error, ejecutar ROLLBACK por separado.
-- La transaccion queda en estado abortado.

ROLLBACK;


-- Comprobar que el cliente de prueba no se guardo.

SELECT *
FROM cliente
WHERE correo = 'fallo.transaccion@correo.com';


-- Comprobar que tampoco existe el telefono asociado.

SELECT *
FROM telefonocliente
WHERE idcliente = 999999;
