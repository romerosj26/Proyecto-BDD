
-- ============================================================
-- PRACTICA 5 - EJERCICIO 2.2
-- Identificacion de las acciones referenciales
-- Base de datos: ProyectoBDD
-- ============================================================

-- Consultar las claves foraneas y sus acciones referenciales.
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


-- Consultar la definicion completa de las restricciones
-- registradas en PostgreSQL.
SELECT
    conname AS nombre_clave_foranea,
    conrelid::regclass AS tabla_hija,
    confrelid::regclass AS tabla_padre,
    pg_get_constraintdef(oid) AS definicion
FROM pg_constraint
WHERE contype = 'f'
    AND connamespace = 'public'::regnamespace
ORDER BY
    conrelid::regclass::text,
    conname;
