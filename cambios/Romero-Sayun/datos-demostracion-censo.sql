INSERT INTO dato_censal (id_manzana, anio_censo, poblacion_total, viviendas_habitadas)
SELECT id_manzana, 2020, p, GREATEST(1, LEAST(p, ROUND(p / 3.7)::INT))
FROM (SELECT id_manzana, 30 + (ABS(hashtext(id_manzana::text)) % 220) AS p FROM dim_manzana) x;
