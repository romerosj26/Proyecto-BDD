BEGIN;

CREATE TEMP TABLE origen_consumo (
    fecha_referencia DATE, anio INT, bimestre INT,
    consumo_total_mixto NUMERIC, consumo_prom_dom NUMERIC, consumo_total_dom NUMERIC,
    consumo_prom_mixto NUMERIC, consumo_total NUMERIC, consumo_prom NUMERIC,
    consumo_prom_no_dom NUMERIC, consumo_total_no_dom NUMERIC,
    indice_des VARCHAR(50), colonia VARCHAR(255), alcaldia VARCHAR(255),
    latitud NUMERIC, longitud NUMERIC
);
\copy origen_consumo FROM '/tmp/dwdata/consumo_agua_historico_2019.csv' CSV HEADER NULL 'NA'

INSERT INTO dim_manzana (id_ubicacion, latitud, longitud)
SELECT u.id_ubicacion, ROUND(o.latitud, 6), ROUND(o.longitud, 6)
FROM origen_consumo o
JOIN dim_ubicacion u ON u.alcaldia = o.alcaldia AND u.colonia = o.colonia
GROUP BY u.id_ubicacion, ROUND(o.latitud, 6), ROUND(o.longitud, 6);

WITH k AS (
    SELECT t.id_tiempo, u.id_ubicacion, i.id_indice_des,
           o.consumo_total_mixto, o.consumo_prom_dom, o.consumo_total_dom, o.consumo_prom_mixto,
           o.consumo_total, o.consumo_prom, o.consumo_prom_no_dom, o.consumo_total_no_dom,
           ROUND(o.latitud, 6) AS latitud, ROUND(o.longitud, 6) AS longitud
    FROM origen_consumo o
    JOIN dim_tiempo t ON t.fecha = o.fecha_referencia
    JOIN dim_ubicacion u ON u.alcaldia = o.alcaldia AND u.colonia = o.colonia
    JOIN dim_indice_des i ON i.indice_des = o.indice_des
),
unicos AS (
    SELECT MIN(latitud) AS latitud, MIN(longitud) AS longitud,
           id_tiempo, id_ubicacion, id_indice_des,
           consumo_total_mixto, consumo_prom_dom, consumo_total_dom, consumo_prom_mixto,
           consumo_total, consumo_prom, consumo_prom_no_dom, consumo_total_no_dom
    FROM k
    GROUP BY id_tiempo, id_ubicacion, id_indice_des,
             consumo_total_mixto, consumo_prom_dom, consumo_total_dom, consumo_prom_mixto,
             consumo_total, consumo_prom, consumo_prom_no_dom, consumo_total_no_dom
    HAVING COUNT(*) = 1
)
UPDATE fact_consumo_agua f
SET id_manzana = m.id_manzana
FROM unicos x
JOIN dim_manzana m ON m.latitud = x.latitud AND m.longitud = x.longitud
WHERE f.id_tiempo = x.id_tiempo AND f.id_ubicacion = x.id_ubicacion AND f.id_indice_des = x.id_indice_des
  AND f.consumo_total_mixto IS NOT DISTINCT FROM x.consumo_total_mixto
  AND f.consumo_prom_dom IS NOT DISTINCT FROM x.consumo_prom_dom
  AND f.consumo_total_dom IS NOT DISTINCT FROM x.consumo_total_dom
  AND f.consumo_prom_mixto IS NOT DISTINCT FROM x.consumo_prom_mixto
  AND f.consumo_total IS NOT DISTINCT FROM x.consumo_total
  AND f.consumo_prom IS NOT DISTINCT FROM x.consumo_prom
  AND f.consumo_prom_no_dom IS NOT DISTINCT FROM x.consumo_prom_no_dom
  AND f.consumo_total_no_dom IS NOT DISTINCT FROM x.consumo_total_no_dom;

COMMIT;
