

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
practica3/
├── README.md
├── proyecto-propio/
│   ├── inventario-eer.pdf
│   ├── transformacion.pdf
│   ├── diagrama-relacional.png
│   └── sql/
│       ├── esquema.sql
│       └── pruebas-de-restricciones.sql
├── proyecto-asignado/
│   ├── analisis-del-esquema.pdf
│   └── comparacion-eer-relacional.pdf
├── cambios/
│   ├── cambio-usuario.sql
│   └── cambio-usuario.pdf
└── evidencias
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


  --
  ###Ejercicio 2. Inventario del modelo EER del proyecto propio
  
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