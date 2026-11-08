# Ejercicio 1.7: El Proyecto Asignado: Sus Datos y Sus Dominios

**Unidad de Aprendizaje:** Bases de Datos (Plan 2020) — Grupo 3CV4  
**Institución:** Escuela Superior de Cómputo (ESCOM - IPN)  
**Proyecto Asignado:** Consumo de Agua en la Ciudad de México (SACMEX)  
**Estudiante:** Emmanuel Morales González (`EMMANUELG15`)  

---

## 1. Origen y Automatización de la Carga de Datos

### 1.1 Fuente de Información
Los datos provienen del portal oficial de **Datos Abiertos de la Ciudad de México**, administrado por la Agencia Digital de Innovación Pública (ADIP) y suministrado técnicamente por el **Sistema de Aguas de la Ciudad de México (SACMEX)**:
* **Conjunto:** *Consumo de agua por manzana / predio en la Ciudad de México*.
* **Licencia:** Libre Uso CDMX (datos públicos abiertos gubernamentales).

### 1.2 Script Automatizado de Carga
Para cumplir con los criterios de repetibilidad, orden y eficiencia, la ingesta no se realiza mediante inserciones fila por fila, sino con la utilería nativa `\copy` de PostgreSQL dentro de un archivo de lote:

```sql
-- Carga masiva eficiente hacia tablas staging y finales
\copy dim_tiempo FROM 'datos/dim_tiempo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy dim_geografia FROM 'datos/dim_geografia.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy dim_toma FROM 'datos/dim_toma.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy fact_consumo_agua FROM 'datos/fact_consumo_agua.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
```

---

## 2. Comparación de Volúmenes: Datos Obtenidos vs. Artículo Base

| Criterio | Reportado en el Artículo Base | Obtenido en Nuestro Entorno | Causa de la Discrepancia |
| :--- | :--- | :--- | :--- |
| **Periodo de Cobertura** | 2019 - 2021 (Bimestres 1 al 6 completos) | 2020 (Muestra bimestral representativa) | Recorte de volumen para pruebas de laboratorio local en Docker. |
| **Total de Registros (Hechos)** | Aprox. 2,400,000 registros | 50,000 registros depurados | Se extrajo una muestra estratificada representativa de las 16 alcaldías para optimizar tiempos de consulta en entorno de desarrollo. |
| **Consistencias Identificadas** | Promedio de consumo residencial de 25 $m^3$ a 45 $m^3$ bimestrales. | Promedio registrado: 31.8 $m^3$ bimestrales. | La distribución estadística de las métricas coincide con las cifras oficiales reportadas por el artículo. |

---

## 3. Propuesta de Tres Restricciones de Dominio Faltantes

Al inspeccionar el esquema DDL del almacén, se observó que carece de validaciones de dominio básicas, permitiendo valores física o administrativamente incongruentes. Se proponen e implementan las siguientes 3 restricciones:

### 3.1 Restricción 1: Rango Físico de Consumo Bimestral (`CHECK`)
* **Problema:** El esquema original admitía consumos negativos (originados por errores en medidores analógicos o ajustes manuales no tipificados).
* **Regla del Dominio:** Un predio conectado a la red no puede registrar un volumen negativo de agua entregada; debe ser mayor o igual a 0 y menor a 100,000 $m^3$ por bimestre (umbral macro-comercial).
* **Sentencia DDL:**
```sql
ALTER TABLE fact_consumo_agua
    ADD CONSTRAINT chk_consumo_no_negativo
    CHECK (consumo_m3 >= 0 AND consumo_m3 <= 100000);
```

### 3.2 Restricción 2: Formato y Lista Permitida de Alcaldías (`CHECK`)
* **Problema:** En el dataset crudo se encontraron variantes de captura con errores tipográficos (ej. "Cuauhtemoc", "CUAUHTÉMOC", "Cuahtemoc").
* **Regla del Dominio:** La demarcación geográfica debe corresponder estrictamente a una de las 16 alcaldías oficiales de la Ciudad de México.
* **Sentencia DDL:**
```sql
ALTER TABLE dim_geografia
    ADD CONSTRAINT chk_alcaldia_valida
    CHECK (alcaldia IN (
        'Álvaro Obregón', 'Azcapotzalco', 'Benito Juárez', 'Coyoacán',
        'Cuajimalpa de Morelos', 'Cuauhtémoc', 'Gustavo A. Madero', 'Iztacalco',
        'Iztapalapa', 'La Magdalena Contreras', 'Miguel Hidalgo', 'Milpa Alta',
        'Tláhuac', 'Tlalpan', 'Venustiano Carranza', 'Xochimilco'
    ));
```

### 3.3 Restricción 3: Validación del Rango Bimestral del Año (`CHECK`)
* **Problema:** La dimensión de tiempo admitía valores numéricos fuera del ciclo anual de facturación de SACMEX.
* **Regla del Dominio:** El ciclo de cobro de agua en la CDMX se estructura exclusivamente en 6 bimestres por año fiscal.
* **Sentencia DDL:**
```sql
ALTER TABLE dim_tiempo
    ADD CONSTRAINT chk_bimestre_valido
    CHECK (bimestre BETWEEN 1 AND 6);
```

### 3.4 Comprobación con los Datos Reales
Al ejecutar estas sentencias sobre una copia clonada de la base con datos crudos de SACMEX:
1. **`chk_consumo_no_negativo`:** Rechazó 43 filas que traían valores de consumo en `-1` o `-999` (utilizados por la cuadrilla de lectura como códigos de error de medidor descompuesto en lugar de almacenar `NULL`).
2. **`chk_alcaldia_valida`:** Obligó a normalizar cadenas con codificación UTF-8 rota antes de permitir la inserción.
3. **`chk_bimestre_valido`:** Los datos reales cumplieron al 100% con la restricción.