SELECT d.id_fact,
       u.alcaldia,
       u.colonia,
       ROUND(d.puntaje_anomalia::numeric, 4) AS puntaje,
       f.consumo_total                       AS consumo_m3,
       p.litros_hab_dia,
       m.nombre || ' v' || m.version         AS modelo,
       d.calculado_en
FROM deteccion_anomalia d
JOIN modelo_ml m              ON m.id_modelo = d.id_modelo
LEFT JOIN v_lectura_per_capita p ON p.id_fact = d.id_fact
JOIN fact_consumo_agua f      ON f.id_fact = d.id_fact
JOIN dim_ubicacion u          ON u.id_ubicacion = f.id_ubicacion
WHERE d.es_anomalia
ORDER BY d.puntaje_anomalia DESC
LIMIT 5;
