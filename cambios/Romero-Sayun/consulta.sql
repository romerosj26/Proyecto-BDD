WITH por_manzana AS (
    SELECT f.id_manzana, t.anio, t.bimestre, SUM(f.consumo_total) AS consumo_m3
    FROM fact_consumo_agua f
    JOIN dim_tiempo t ON t.id_tiempo = f.id_tiempo
    WHERE f.id_manzana IS NOT NULL AND t.bimestre = 3
    GROUP BY f.id_manzana, t.anio, t.bimestre
),
dias AS (
    SELECT anio, bimestre, COUNT(*) AS dias_bimestre FROM dim_tiempo GROUP BY anio, bimestre
),
por_alcaldia AS (
    SELECT u.alcaldia,
           SUM(pm.consumo_m3)                       AS consumo_m3,
           SUM(c.poblacion_total)                   AS habitantes,
           ROUND(SUM(pm.consumo_m3) * 1000 / (SUM(c.poblacion_total) * MAX(d.dias_bimestre)), 1) AS litros_hab_dia
    FROM por_manzana pm
    JOIN dim_manzana m  ON m.id_manzana = pm.id_manzana
    JOIN dim_ubicacion u ON u.id_ubicacion = m.id_ubicacion
    JOIN dato_censal c  ON c.id_manzana = pm.id_manzana AND c.anio_censo = 2020
    JOIN dias d         ON d.anio = pm.anio AND d.bimestre = pm.bimestre
    GROUP BY u.alcaldia
)
SELECT alcaldia,
       ROUND(consumo_m3)                         AS consumo_m3,
       habitantes,
       litros_hab_dia,
       RANK() OVER (ORDER BY consumo_m3 DESC)     AS lugar_por_total,
       RANK() OVER (ORDER BY litros_hab_dia DESC) AS lugar_por_habitante
FROM por_alcaldia
ORDER BY litros_hab_dia DESC;
