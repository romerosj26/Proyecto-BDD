# Ejercicio 8. Cambio de esquema — Propuesta 2: Consumo per cápita con datos censales

**Integrante:** Romero Sayún Jonathan · **Grupo:** 3CV4 · **Unidad de aprendizaje:** Bases de Datos

## 1. Cambios sobre el esquema del proyecto asignado

| Objeto | Cambio | Restricciones |
|---|---|---|
| `dim_manzana` | Tabla nueva (entidad MANZANA) | PK `id_manzana`; `clave_geoestadistica` UNIQUE y con formato CDMX (`CHECK`); FK `id_ubicacion` → `dim_ubicacion`; UNIQUE (`latitud`, `longitud`); coordenadas dentro de la CDMX |
| `dato_censal` | Tabla nueva (entidad débil DATO CENSAL) | PK (`id_manzana`, `anio_censo`); FK a `dim_manzana` con `ON DELETE CASCADE`; `anio_censo` ≥ 2010; población y viviendas ≥ 0; viviendas habitadas ≤ población |
| `fact_consumo_agua` | Columna nueva `id_manzana` | FK → `dim_manzana`, nula para los hechos existentes; índice |
| `v_lectura_per_capita` | Vista nueva (atributo derivado `consumo_per_cápita`) | Litros por habitante al día = consumo_total × 1000 / (población × días del bimestre), con el censo más cercano al año de la lectura |
| `modelo_ml` | Tabla nueva | PK `id_modelo`; UNIQUE (`nombre`, `version`); `parametros` JSONB; `entrenado_en` TIMESTAMPTZ |
| `deteccion_anomalia` | Tabla nueva (salida del modelo) | PK `id_deteccion`; FK `id_fact` → `fact_consumo_agua` (hecho que califica); FK `id_modelo` → `modelo_ml` (versión del modelo); `calculado_en` TIMESTAMPTZ (marca de tiempo); `puntaje_anomalia` DOUBLE PRECISION; `es_anomalia` BOOLEAN; `atributos` JSONB; UNIQUE (`id_fact`, `id_modelo`) |

**Tipos elegidos para el resultado del modelo.** `puntaje_anomalia` es DOUBLE PRECISION porque el modelo devuelve un número de punto flotante cuyo valor sirve para ordenar, no para cuentas exactas; NUMERIC aparentaría una precisión decimal que el modelo no tiene. `es_anomalia` es BOOLEAN porque guarda la decisión tomada con el umbral de esa versión, y así el resultado se puede reproducir sin volver a ejecutar el modelo. `calculado_en` es TIMESTAMPTZ para que la marca de tiempo no dependa de la zona horaria de quien consulta. `atributos` y `parametros` son JSONB porque cada modelo usa variables e hiperparámetros distintos y no conviene una columna por cada uno.

## 2. Archivo `cambio-romerosj26.sql` y ejecución

El archivo `cambio-romerosj26.sql` se ejecutó sobre `data_warehouse_copia`, copia de la base `data_warehouse` del proyecto asignado (70,886 hechos, 1,553 ubicaciones). Después del cambio se cargaron las manzanas desde el CSV de origen (`carga-datos-existentes.sql`), la población (`datos-demostracion-censo.sql`) y las predicciones del modelo (`ejecutar_modelo.py`: Isolation Forest, versión 1.0.0, 70,886 detecciones y 353 anomalías).

## 3. Consulta posible solo después del cambio

Consumo por habitante por alcaldía en el bimestre 3 de 2019, con su lugar por consumo total y por habitante (`consulta.sql`). La población usada en esta ejecución es de demostración y no proviene del censo.

| alcaldía | consumo_m3 | habitantes | litros_hab_dia | lugar_por_total | lugar_por_habitante |
|---|---|---|---|---|---|
| CUAJIMALPA DE MORELOS | 971438 | 36618 | 434.9 | 12 | 1 |
| MIGUEL HIDALGO | 4590353 | 215064 | 349.9 | 2 | 2 |
| CUAUHTEMOC | 5599997 | 289203 | 317.4 | 1 | 3 |
| BENITO JUAREZ | 4564978 | 270881 | 276.3 | 3 | 4 |
| ALVARO OBREGON | 3025964 | 186768 | 265.6 | 5 | 5 |
| AZCAPOTZALCO | 2496659 | 178288 | 229.6 | 7 | 6 |
| IZTACALCO | 2113890 | 165849 | 208.9 | 10 | 7 |
| TLALPAN | 1512351 | 126870 | 195.4 | 11 | 8 |
| COYOACAN | 2316496 | 220091 | 172.5 | 9 | 9 |
| LA MAGDALENA CONTRERAS | 430106 | 41769 | 168.8 | 14 | 10 |
| VENUSTIANO CARRANZA | 2361157 | 235982 | 164.0 | 8 | 11 |
| GUSTAVO A. MADERO | 3902283 | 424635 | 150.7 | 4 | 12 |
| IZTAPALAPA | 2737186 | 438971 | 102.2 | 6 | 13 |
| XOCHIMILCO | 611547 | 106371 | 94.2 | 13 | 14 |
| TLAHUAC | 282526 | 87042 | 53.2 | 15 | 15 |
| MILPA ALTA | 48544 | 26256 | 30.3 | 16 | 16 |

## 4. Nota

**Regla de transformación.** Apliqué las reglas de paso del modelo EER al relacional. MANZANA, que con `clave_geoestadística` pasa a entidad fuerte, se convierte en la tabla `dim_manzana`, y la relación 1:N SE UBICA EN en una llave foránea hacia `dim_ubicacion`. DATO CENSAL, entidad débil, se convierte en una tabla cuya llave primaria es la de su propietaria más la clave parcial (`id_manzana`, `anio_censo`). La relación 1:N TIENE LECTURA se vuelve la llave foránea `id_manzana` en la tabla de hechos. El atributo derivado `consumo_per_cápita` no se almacena: se calcula en una vista. La salida del modelo de IA va en `deteccion_anomalia`, ligada al hecho y a la versión del modelo.

**Por qué esta estrategia.** Una tabla por entidad evita repetir la población en cada lectura y conserva la dependencia del censo. Como la clave oficial no viene en el CSV, la llave primaria es un identificador sustituto (igual que en el resto del almacén) y la clave geoestadística es única pero admite nulos hasta cargar la correspondencia con el censo.

**Datos existentes.** `ALTER TABLE ... ADD COLUMN` deja `id_manzana` en nulo y no modifica ningún valor. Como los hechos no guardaban coordenadas, se vincularon con el CSV por coincidencia exacta en todas sus medidas: 66,519 de 70,886 hechos quedaron ligados a su manzana. Los 4,367 restantes tienen medidas idénticas a otro hecho y no se pueden distinguir, así que conservan nulo y no entran al cálculo per cápita. Se crearon 22,858 manzanas; 72 coordenadas pertenecen a registros sin colonia y no se cargaron.
