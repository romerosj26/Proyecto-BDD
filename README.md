

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
| Jonathan Romero Sayún | *[Propuesta 1 del compañero]* | [#5](https://github.com/romerosj26/Proyecto-BDD/issues/5) |
| Jonathan Romero Sayún | *[Propuesta 2 del compañero]* | [#6](https://github.com/romerosj26/Proyecto-BDD/issues/6) |
| Jonathan Romero Sayún | *[Propuesta 3 del compañero]* | [#7](https://github.com/romerosj26/Proyecto-BDD/issues/7) |

*(Nota: actualiza los números `#` de los enlaces si tus issues en GitHub tienen otro ID)*.

---

## 4. Estructura del Repositorio
```text
practica2/
├── README.md
├── entorno/
│   └── compose.yaml
├── proyecto-propio/
│   ├── requisitos-ampliados.pdf
│   ├── eer-chen.png
│   └── eer-crows-feet.png
├── proyecto-asignado/
│   ├── levantamiento.md
│   ├── eer.png
│   └── correspondencia-con-el-esquema.pdf
├── articulos/
│   └── resumenes.pdf
├── propuestas/
│   └── propuestas-de-mejora.pdf
├── evidencias/
│   ├── git/
│   ├── docker/
│   └── proyecto-asignado/
└── exposicion/
      └── presentacion.pdf
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