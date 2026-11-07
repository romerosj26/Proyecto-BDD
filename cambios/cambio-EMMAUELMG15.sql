-- ============================================================================
-- Práctica 3 - Ejercicio 8: Cambio de Esquema Individual (Requisito IA)
-- Autor: Emmanuel Morales González (EMMAUELMG15)
-- Proyecto: ICOKG 2026 - Consumo de Agua CDMX
-- Propuesta: Modelo predictivo y detección de anomalías en consumo de agua
-- ============================================================================

DROP TABLE IF EXISTS prediccion_anomalia_consumo CASCADE;

-- 1. Creación de la tabla de inferencias desacoplada
CREATE TABLE prediccion_anomalia_consumo (
    id_evaluacion SERIAL,
    id_factura_consumo INTEGER NOT NULL,
    version_modelo VARCHAR(50) NOT NULL,
    marca_tiempo_evaluacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    probabilidad_anomalia NUMERIC(5, 4) NOT NULL,
    es_anomalia BOOLEAN NOT NULL,
    desviacion_estandar_estimada NUMERIC(8, 2),
    consumo_esperado_m3 NUMERIC(10, 2) NOT NULL,
    metadatos_hiperparametros JSONB,
    CONSTRAINT pk_prediccion_anomalia PRIMARY KEY (id_evaluacion),
    CONSTRAINT fk_prediccion_fact FOREIGN KEY (id_factura_consumo)
        REFERENCES fact_consumo_agua (id_fact) ON DELETE CASCADE,
    CONSTRAINT chk_probabilidad CHECK (probabilidad_anomalia >= 0.0000 AND probabilidad_anomalia <= 1.0000),
    CONSTRAINT chk_consumo_esp CHECK (consumo_esperado_m3 >= 0)
);

-- 2. Índice especializado
CREATE INDEX idx_anomalias_detectadas 
ON prediccion_anomalia_consumo (es_anomalia, version_modelo);

-- 3. Poblado inicial con datos simulados vinculados a hechos reales
INSERT INTO prediccion_anomalia_consumo 
    (id_factura_consumo, version_modelo, probabilidad_anomalia, es_anomalia, desviacion_estandar_estimada, consumo_esperado_m3, metadatos_hiperparametros)
SELECT 
    f.id_fact,
    'IsolationForest-v1.2.0',
    0.9350,
    TRUE,
    3.45,
    ROUND((f.consumo_total * 0.45)::numeric, 2),
    '{"n_estimators": 100, "contamination": 0.05, "algorithm": "auto"}'::jsonb
FROM fact_consumo_agua f
WHERE f.consumo_total > 500
LIMIT 10;