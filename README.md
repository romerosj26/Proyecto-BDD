

# Proyecto-BDD

**Unidad de aprendizaje:** Bases de Datos  
**Programa:** Ingeniería en Sistemas Computacionales / Plan 2020  
**Escuela Superior de Cómputo — Instituto Politécnico Nacional**  
**Grupo:** 3CV4  

---

## Alumnos
* **Morales González Emmanuel** — Boleta: 2025630602 ([@EMMAUELMG15](https://github.com/EMMAUELMG15))
* **Romero Sayún Jonathan** — Boleta: 2025630298 ([@romerosj26](https://github.com/romerosj26))

---

## 1. Proyecto Propio: Concesionaria de Autos (Renta y Venta)
* **Descripción:** Sistema de gestión integral para la comercialización de automóviles nuevos y usados, así como el servicio de renta de vehículos por periodos determinados.
* **Modelo EER:** Ampliado con especialización total y disjunta de vehículos (`VehiculoRenta` y `VehiculoVenta`), entidades débiles por identificación (`Mantenimiento` e `IncidenciaAlquiler`) y cardinalidades mínimas y máximas justificadas por reglas de negocio.
* **Ubicación:** `proyecto-propio/`

---

## 2. Proyecto Asignado: Consumo de Agua en la CDMX
* **Artículo de referencia:** *Territorial information retrieval from heterogeneous open data through the construction of a data warehouse for water management in Mexico City* (ICOKG 2026 / Springer).
* **Repositorio Fork:** [https://github.com/EMMAUELMG15/Data_Warehouse_static](https://github.com/EMMAUELMG15/Data_Warehouse_static)
* **Identificador de confirmación (Commit ID) en funcionamiento:** `b221008f51a2d48074d2847a9ff754e60ea9b4a4`
* **Bitácora de levantamiento y verificación:** [`proyecto-asignado/levantamiento.md`](./proyecto-asignado/levantamiento.md)

---

## 3. Propuestas de Mejora (Issues en GitHub)

| Integrante | Título de la Propuesta | Issue |
| :--- | :--- | :---: |
| Emmanuel Morales González | Incorporación de módulo de reportes ciudadanos y detección geoespacial de fugas | [#2](https://github.com/romerosj26/Proyecto-BDD/issues/2) |
| Emmanuel Morales González | Estratificación de consumo por tipo de tarifa y régimen de tenencia | [#3](https://github.com/romerosj26/Proyecto-BDD/issues/3) |
| Emmanuel Morales González | Monitoreo de tandeo y disponibilidad por fuente de abastecimiento | [#4](https://github.com/romerosj26/Proyecto-BDD/issues/4) |
| Jonathan Romero Sayún | Registro y revisión de zonas atípicas | [#5](https://github.com/romerosj26/Proyecto-BDD/issues/9) |
| Jonathan Romero Sayún | Consumo per cápita con datos censales | [#6](https://github.com/romerosj26/Proyecto-BDD/issues/10) |
| Jonathan Romero Sayún | Límites oficiales y colindancia exacta | [#7](https://github.com/romerosj26/Proyecto-BDD/issues/11) |


---

## 4. Estructura del Repositorio
```text
practica4/
├── dominios.md
├── fuente.md
├── pruebas-dominio.md
├── permisos.md
├── datos/
├── poblar/
│   └── poblar.sh
└── proyecto-asignado/
practica5/
├── referencias.md
├── pruebas-referenciales.md
├── edicion-de-valores.md
├── integridad-almacen.md
├── integrantes/
└── sql/
├── README.md
└── evidencias/

```
---
## 5. Declaración sobre el uso de IA Generativa
En apego a los lineamientos de integridad académica:
* **Herramienta:** Gemini (Google).
* **Uso:** Configuración de mapeo de puertos concurrentes en Docker para PostgreSQL (5432 y 5433), estructuración técnica de bitácoras de levantamiento y redacción de propuestas de mejora conforme a los requerimientos de la práctica.  


### Documentación y Entregables del Repositorio

### Práctica 1: Fundamentos teóricos y entorno
* [Ejercicio 1: Control de Versiones con Git y GitHub](./docs/control-versiones-git.pdf)
* [Ejercicio 2: Arquitectura de Contenedores con Docker](./docs/entorno-docker.pdf)
* [Ejercicio 3: Fundamentos e Investigación sobre SGBD](./docs/investigacion-sgbd.pdf)
* [Ejercicio 4: Estado del Arte de Artículos Científicos](./docs/estado-del-arte.pdf)

---

### Proyecto Propio: Concesionaria de Autos (Renta y Venta)
* [Caso de Estudio y Entrevista de Dominio](./proyecto-propio/caso-estudio-concesionaria.pdf)
* [Requisitos Ampliados y Modelo Conceptual EER](./proyecto-propio/requisitos-ampliados.pdf)
* [Diagrama EER (Notación Peter Chen)](./proyecto-propio/eer-chen.png)
* [Diagrama EER (Notación Crow's Feet)](./proyecto-propio/eer-crows-feet.png)

---

### Proyecto Asignado: Consumo de Agua CDMX (ICOKG 2026)
* **Repositorio Fork:** [https://github.com/EMMAUELMG15/Data_Warehouse_static](https://github.com/EMMAUELMG15/Data_Warehouse_static)
* **Commit ID evaluado:** `b221008f51a2d48074d2847a9ff754e60ea9b4a4`
* [Bitácora Técnica de Puesta en Marcha](./proyecto-asignado/levantamiento.md)
* [Modelo Conceptual del Dominio (EER)](./proyecto-asignado/eer.png)
* [Correspondencia Conceptual vs. Esquema Dimensional](./proyecto-asignado/correspondencia-con-el-esquema.pdf)
* **Evidencias Gráficas de Funcionamiento:**
  * [Despliegue del contenedor en Docker](./evidencias/proyecto-asignado/arranque_docker.png)
  * [Aplicación web local interactiva](./evidencias/proyecto-asignado/app_local.png)
  * [Consulta directa en PostgreSQL](./evidencias/proyecto-asignado/consulta_db.png)


---
##Ejercicio 2. Inventario del modelo EER del proyecto propio
  
## Contenido

| Archivo | Descripción |
|---|---|
| `Ejercicio2_Inventario_EER.docx` | Inventario del modelo EER: entidades fuertes y débiles, relaciones, jerarquías, atributos multivaluados, compuestos y derivados, relaciones ternarias, y las tres preguntas previas a la transformación. |
| `README.md` | Cambios hechos al modelo EER antes de transformarlo. |

## Cambios al modelo EER antes de la transformación

Al comparar el diagrama de Chen con el de Crow's Feet se encontraron diferencias de nombre y de cardinalidad entre ambos. Se corrigieron en el diagrama de Chen para que los dos representen exactamente el mismo modelo. El inventario usa los nombres corregidos.

| # | Cambio | Por qué |
|---|---|---|
| 1 | La entidad débil `Entity` se renombró como `DetalleVenta`. | `Entity` es la etiqueta que draw.io asigna por defecto. En el resto del modelo, los requisitos y las consultas la entidad se llama `DetalleVenta`. |
| 2 | En `Cliente – realiza – Venta`, `Cliente – solicita – Renta` y `VehiculoRenta – se renta en – Renta`, la cardinalidad `N` pasó a `(0,N)`. | El modelo usa el formato (mín,máx) en todas las relaciones. Con solo `N` no se sabe si la participación es opcional u obligatoria, y la mínima decide qué claves foráneas serán `NOT NULL`. |
| 3 | En `Renta – tiene – InspeccionRenta` se agregó `(0,2)` del lado de `Renta`. | Faltaba en el diagrama de Chen. El diagrama de Crow's Feet y el Ejercicio 4 lo declaran: una renta tiene como máximo dos inspecciones (entrega y devolución). |
| 4 | `nivelGasolina` se renombró como `nivelCombustible`. | Es el nombre que usan el diagrama de Crow's Feet y las consultas del Ejercicio 4. |
| 5 | `año` se renombró como `anio`. | Es el nombre que usa el diagrama de Crow's Feet, y evita la `ñ` en los nombres de columnas SQL. |
| 6 | `vehiculoVenta`, `vehiculoRenta` e `inspeccionRenta` se renombraron como `VehiculoVenta`, `VehiculoRenta` e `InspeccionRenta`. | Son los nombres de las tablas del diagrama de Crow's Feet. |

La estructura del modelo no cambió: son las mismas entidades, relaciones, la misma jerarquía de `Vehiculo` (solapada y total) y los mismos atributos compuestos y multivaluado.

# Práctica 4 — Implementación de bases de datos y permisos

## 1.4. Script de carga de datos

### Descripción

Se desarrolló un script en Python para importar información de un catálogo de vehículos nuevos en México hacia la tabla `catalogoversion` de la base de datos `ProyectoBDD`.

El archivo de origen es:

`datos/precios-autos-nuevos-mexico.csv`

El conjunto contiene 1,127 registros y 14 columnas.

### Requisitos

- PostgreSQL 16.
- Python 3.11 o superior.
- Biblioteca `psycopg` para la conexión con PostgreSQL.

Instalación de la dependencia:

```powershell
python -m pip install "psycopg[binary]"
```

### Configuración de conexión

El script utiliza variables de entorno para evitar almacenar credenciales directamente en el código.

Configurar las siguientes variables en PowerShell:

```powershell
$env:DB_HOST = "localhost"
$env:DB_PORT = "5432"
$env:DB_NAME = "ProyectoBDD"
$env:DB_USER = "app_carga"
$env:DB_PASSWORD = Read-Host "Contraseña de app_carga"
```

El usuario `app_carga` tiene permisos de conexión, lectura e inserción sobre la tabla `catalogoversion`, así como permiso de uso sobre su secuencia. No tiene permisos de actualización, eliminación ni administración de la base de datos.

### Ejecución

Desde el directorio raíz de la práctica, ejecutar:

```powershell
python .\scripts\cargar_catalogo.py
```

### Funcionamiento del script

El proceso realiza las siguientes operaciones:

1. Lee el archivo CSV de origen.
2. Comprueba que estén presentes las 14 columnas esperadas.
3. Valida los registros y convierte los datos a sus tipos correspondientes.
4. Identifica registros inválidos y los almacena en `datos/rechazados/rechazos_catalogo.csv`, indicando la fila y el motivo del rechazo.
5. Establece conexión con PostgreSQL utilizando el usuario `app_carga`.
6. Crea una tabla temporal para preparar la información.
7. Utiliza `COPY` para cargar los registros de forma masiva en la tabla temporal.
8. Inserta en `catalogoversion` únicamente los registros que todavía no existen.
9. Confirma la transacción y muestra los resultados de la operación.

La carga se ejecuta dentro de una transacción: si ocurre un error durante el proceso, los cambios de esa operación se revierten.

### Prevención de duplicados

Se utiliza una combinación de los campos `marca`, `modelo`, `version` y `anio` para identificar registros existentes.

La comparación considera los valores nulos del año y no distingue entre mayúsculas y minúsculas en los campos de identificación.

Esto permite ejecutar el script varias veces sin insertar nuevamente los registros que ya fueron cargados.

### Resultados de ejecución

**Primera ejecución, antes de corregir la longitud del campo motor:**

| Indicador | Resultado |
|---|---:|
| Registros válidos | 1,120 |
| Registros insertados | 1,120 |
| Registros rechazados | 7 |

Durante esta ejecución se detectó que siete descripciones de motor superaban el límite de 100 caracteres. Se corrigió la definición de la columna `motor` para utilizar el tipo `TEXT` y se eliminó el límite artificial de longitud en la validación del script.

**Ejecución posterior a la corrección:**

| Indicador | Resultado |
|---|---:|
| Registros válidos | 1,127 |
| Registros insertados | 7 |
| Registros ya existentes | 1,120 |
| Registros rechazados | 0 |
| Tiempo de ejecución | 0.121 segundos |

**Segunda ejecución posterior a la corrección:**

| Indicador | Resultado |
|---|---:|
| Registros válidos | 1,127 |
| Registros insertados | 0 |
| Registros ya existentes | 1,127 |
| Registros rechazados | 0 |
| Tiempo de ejecución | 0.128 segundos |

Se verificó directamente en PostgreSQL el total de registros:

```sql
SELECT COUNT(*) FROM catalogoversion;
```

Resultado esperado:

```text
1127
```

### Evidencias

Las salidas de ejecución se almacenan en el directorio `evidencias/`.

- `carga-segunda-ejecucion.txt`: salida de la segunda ejecución posterior a la corrección.
- `carga-correccion.txt`: salida de la ejecución posterior a la corrección, si se captura.

Los registros rechazados se almacenan en:

`datos/rechazados/rechazos_catalogo.csv`

### Conclusión

El script permite realizar una carga masiva, validar la información de origen, registrar los errores y evitar duplicados. Las pruebas confirmaron la inserción de los 1,127 registros y la repetibilidad del proceso sin generar duplicados.