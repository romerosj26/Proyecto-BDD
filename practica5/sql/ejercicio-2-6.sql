
/*
============================================================
 PRACTICA 5 - BASES DE DATOS
 EJERCICIO 2.6 - INTEGRIDAD REFERENCIAL INDIVIDUAL

 Proyecto: Concesionaria de automoviles
 Base original: ProyectoBDD
 Base de pruebas: ProyectoBDD_Individual
============================================================
*/


/* ==========================================================
   1. IDENTIFICAR LA BASE DE DATOS
   ========================================================== */

SELECT
    current_database() AS base_datos,
    current_user AS usuario;


/* ==========================================================
   2. VERIFICAR LOS REGISTROS ANTES DE LA MODIFICACION
   ========================================================== */

-- Consultar los clientes que tienen rentas.

SELECT
    c.idcliente,
    c.nombre,
    c.apellidopaterno,
    COUNT(DISTINCT r.idrenta) AS rentas,
    COUNT(DISTINCT tc.telefono) AS telefonos,
    COUNT(DISTINCT v.idventa) AS ventas
FROM cliente c
LEFT JOIN renta r
    ON r.idcliente = c.idcliente
LEFT JOIN telefonocliente tc
    ON tc.idcliente = c.idcliente
LEFT JOIN venta v
    ON v.idcliente = c.idcliente
GROUP BY
    c.idcliente,
    c.nombre,
    c.apellidopaterno
ORDER BY c.idcliente;


-- Consultar las dependencias del cliente seleccionado:
-- Ana Lopez, idcliente = 1.

SELECT
    c.idcliente,
    c.nombre,
    (SELECT COUNT(*)
     FROM renta r
     WHERE r.idcliente = c.idcliente) AS rentas,

    (SELECT COUNT(*)
     FROM telefonocliente tc
     WHERE tc.idcliente = c.idcliente) AS telefonos,

    (SELECT COUNT(*)
     FROM venta v
     WHERE v.idcliente = c.idcliente) AS ventas

FROM cliente c
WHERE c.idcliente = 1;


-- Consultar la renta, inspeccion y telefono asociados.

SELECT
    c.idcliente,
    c.nombre,
    r.idrenta,
    r.estado,
    i.idinspeccion,
    tc.telefono
FROM cliente c
JOIN renta r
    ON r.idcliente = c.idcliente
LEFT JOIN inspeccionrenta i
    ON i.idrenta = r.idrenta
LEFT JOIN telefonocliente tc
    ON tc.idcliente = c.idcliente
WHERE c.idcliente = 1
ORDER BY i.idinspeccion;


/* ==========================================================
   3. CONSULTAR LA ACCION REFERENCIAL ORIGINAL
   ========================================================== */

SELECT
    conname,
    pg_get_constraintdef(oid) AS definicion
FROM pg_constraint
WHERE conname = 'fk_renta_cliente';

/* ==========================================================
   4. MODIFICAR LA CLAVE FORANEA
   ========================================================== */

BEGIN;

-- Eliminar la restriccion anterior.

ALTER TABLE renta
DROP CONSTRAINT fk_renta_cliente;


-- Crear nuevamente la clave foranea,
-- ahora con ON DELETE CASCADE.

ALTER TABLE renta
ADD CONSTRAINT fk_renta_cliente
FOREIGN KEY (idcliente)
REFERENCES cliente(idcliente)
ON UPDATE CASCADE
ON DELETE CASCADE;

COMMIT;


-- Verificar que el cambio se aplico correctamente.

SELECT
    conname,
    pg_get_constraintdef(oid) AS definicion
FROM pg_constraint
WHERE conname = 'fk_renta_cliente';

/* ==========================================================
   5. ELIMINAR EL CLIENTE SELECCIONADO
   ========================================================== */

-- Eliminar a Ana Lopez (idcliente = 1).

DELETE FROM cliente
WHERE idcliente = 1
RETURNING
    idcliente,
    nombre,
    apellidopaterno;


/* ==========================================================
   6. COMPROBAR LA ELIMINACION EN CADENA
   ========================================================== */

-- Verificar si desaparecio el cliente.

SELECT
    'cliente' AS tabla,
    COUNT(*) AS registros
FROM cliente
WHERE idcliente = 1

UNION ALL

-- Verificar si desaparecio su renta.

SELECT
    'renta',
    COUNT(*)
FROM renta
WHERE idrenta = 1

UNION ALL

-- Verificar si desaparecio su inspeccion.

SELECT
    'inspeccionrenta',
    COUNT(*)
FROM inspeccionrenta
WHERE idinspeccion = 1

UNION ALL

-- Verificar si desaparecio su telefono.

SELECT
    'telefonocliente',
    COUNT(*)
FROM telefonocliente
WHERE idcliente = 1;

/* ==========================================================
   7. VERIFICAR QUE LA BASE DE PRUEBAS SIGUE CONSISTENTE
   ========================================================== */

-- Comprobar que no quedan rentas sin cliente.

SELECT r.*
FROM renta r
LEFT JOIN cliente c
    ON c.idcliente = r.idcliente
WHERE c.idcliente IS NULL;


-- Comprobar que no quedan inspecciones sin renta.

SELECT i.*
FROM inspeccionrenta i
LEFT JOIN renta r
    ON r.idrenta = i.idrenta
WHERE r.idrenta IS NULL;


/*
Ambas consultas deben devolver cero filas.
*/


/* ==========================================================
   8. COMPROBAR QUE LA BASE ORIGINAL NO FUE MODIFICADA
   ========================================================== */
-- Consultar a Ana Lopez y sus registros originales.

SELECT
    c.idcliente,
    c.nombre,
    c.apellidopaterno,

    (SELECT COUNT(*)
     FROM renta r
     WHERE r.idcliente = c.idcliente) AS rentas,

    (SELECT COUNT(*)
     FROM telefonocliente tc
     WHERE tc.idcliente = c.idcliente) AS telefonos

FROM cliente c
WHERE c.idcliente = 1;