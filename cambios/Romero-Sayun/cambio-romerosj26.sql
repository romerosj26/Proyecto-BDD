BEGIN;

CREATE TABLE dim_manzana (
    id_manzana            SERIAL PRIMARY KEY,
    clave_geoestadistica  VARCHAR(16) UNIQUE,
    id_ubicacion          INT NOT NULL REFERENCES dim_ubicacion (id_ubicacion),
    latitud               NUMERIC(9,6) NOT NULL,
    longitud              NUMERIC(9,6) NOT NULL,
    CONSTRAINT uq_manzana_coordenada UNIQUE (latitud, longitud),
    CONSTRAINT ck_manzana_clave CHECK (clave_geoestadistica ~ '^09[0-9A-Z]{14}$'),
    CONSTRAINT ck_manzana_cdmx CHECK (latitud BETWEEN 19.04 AND 19.60 AND longitud BETWEEN -99.36 AND -98.94)
);
CREATE INDEX idx_manzana_ubicacion ON dim_manzana (id_ubicacion);

CREATE TABLE dato_censal (
    id_manzana           INT NOT NULL REFERENCES dim_manzana (id_manzana) ON DELETE CASCADE,
    anio_censo           SMALLINT NOT NULL CHECK (anio_censo >= 2010),
    poblacion_total      INT NOT NULL CHECK (poblacion_total >= 0),
    viviendas_habitadas  INT NOT NULL CHECK (viviendas_habitadas >= 0),
    PRIMARY KEY (id_manzana, anio_censo),
    CONSTRAINT ck_viviendas_poblacion CHECK (viviendas_habitadas <= poblacion_total)
);

ALTER TABLE fact_consumo_agua
    ADD COLUMN id_manzana INT REFERENCES dim_manzana (id_manzana);
CREATE INDEX idx_fact_consumo_manzana ON fact_consumo_agua (id_manzana);

CREATE VIEW v_lectura_per_capita AS
SELECT f.id_fact,
       f.id_manzana,
       t.anio,
       t.bimestre,
       d.dias_bimestre,
       c.anio_censo,
       c.poblacion_total,
       f.consumo_total,
       ROUND(f.consumo_total * 1000 / NULLIF(c.poblacion_total * d.dias_bimestre, 0), 2) AS litros_hab_dia
FROM fact_consumo_agua f
JOIN dim_tiempo t ON t.id_tiempo = f.id_tiempo
JOIN (SELECT anio, bimestre, COUNT(*) AS dias_bimestre FROM dim_tiempo GROUP BY anio, bimestre) d
       ON d.anio = t.anio AND d.bimestre = t.bimestre
JOIN dato_censal c ON c.id_manzana = f.id_manzana
                  AND c.anio_censo = (SELECT c2.anio_censo FROM dato_censal c2
                                      WHERE c2.id_manzana = f.id_manzana
                                      ORDER BY ABS(c2.anio_censo - t.anio), c2.anio_censo DESC LIMIT 1);

CREATE TABLE modelo_ml (
    id_modelo     SERIAL PRIMARY KEY,
    nombre        VARCHAR(80) NOT NULL,
    version       VARCHAR(30) NOT NULL,
    algoritmo     VARCHAR(80) NOT NULL,
    parametros    JSONB NOT NULL DEFAULT '{}'::jsonb,
    entrenado_en  TIMESTAMPTZ NOT NULL,
    CONSTRAINT uq_modelo_version UNIQUE (nombre, version)
);

CREATE TABLE deteccion_anomalia (
    id_deteccion      BIGSERIAL PRIMARY KEY,
    id_fact           INT NOT NULL REFERENCES fact_consumo_agua (id_fact),
    id_modelo         INT NOT NULL REFERENCES modelo_ml (id_modelo),
    calculado_en      TIMESTAMPTZ NOT NULL DEFAULT now(),
    puntaje_anomalia  DOUBLE PRECISION NOT NULL,
    es_anomalia       BOOLEAN NOT NULL,
    atributos         JSONB,
    CONSTRAINT uq_deteccion_hecho_modelo UNIQUE (id_fact, id_modelo)
);
CREATE INDEX idx_deteccion_modelo_puntaje ON deteccion_anomalia (id_modelo, puntaje_anomalia DESC);

COMMIT;
