

-- ============================================================
-- PRACTICA 5 - EJERCICIO 2.1
-- Identificacion de las claves foraneas del proyecto propio
-- Base de datos: ProyectoBDD
-- ============================================================

-- 1. Comprobar la base de datos y el usuario actual.
SELECT
    current_database() AS base_de_datos,
    current_user AS usuario;


-- 2. Consultar las claves foraneas existentes,
--    sus tablas relacionadas y sus acciones referenciales.
SELECT
    tc.constraint_name AS nombre_clave_foranea,
    kcu.table_name AS tabla_hija,
    kcu.column_name AS columna_hija,
    ccu.table_name AS tabla_padre,
    ccu.column_name AS columna_padre,
    rc.delete_rule AS accion_on_delete,
    rc.update_rule AS accion_on_update
FROM information_schema.table_constraints AS tc
INNER JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.constraint_schema = kcu.constraint_schema
INNER JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.constraint_schema = tc.constraint_schema
INNER JOIN information_schema.referential_constraints AS rc
    ON rc.constraint_name = tc.constraint_name
    AND rc.constraint_schema = tc.constraint_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY
    kcu.table_name,
    tc.constraint_name;


-- 3. Consultar la nulabilidad de las columnas
--    que participan en las claves foraneas.
SELECT
    table_name AS tabla,
    column_name AS columna,
    is_nullable AS permite_nulos
FROM information_schema.columns
WHERE table_schema = 'public'
    AND (
        (table_name = 'telefonocliente' AND column_name = 'idcliente')
        OR (table_name = 'vehiculoventa' AND column_name = 'idvehiculo')
        OR (table_name = 'vehiculorenta' AND column_name = 'idvehiculo')
        OR (table_name = 'venta' AND column_name IN ('idcliente', 'idempleado'))
        OR (table_name = 'detalleventa' AND column_name IN ('idventa', 'idvehiculo'))
        OR (table_name = 'renta' AND column_name IN ('idcliente', 'idempleado', 'idvehiculo'))
        OR (table_name = 'inspeccionrenta' AND column_name = 'idrenta')
    )
ORDER BY
    table_name,
    column_name;


-- 4. Consultar las claves primarias de las tablas.
SELECT
    tc.table_name AS tabla,
    kcu.column_name AS columna,
    kcu.ordinal_position AS posicion_en_clave
FROM information_schema.table_constraints AS tc
INNER JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.constraint_schema = kcu.constraint_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
ORDER BY
    tc.table_name,
    kcu.ordinal_position;
