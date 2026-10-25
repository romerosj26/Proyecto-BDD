

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
| Jonathan Romero Sayún | Registro y revisión de zonas atípicas | [#5](https://github.com/romerosj26/Proyecto-BDD/issues/5) |
| Jonathan Romero Sayún | Consumo per cápita con datos censales | [#6](https://github.com/romerosj26/Proyecto-BDD/issues/6) |
| Jonathan Romero Sayún | Límites oficiales y colindancia exacta | [#7](https://github.com/romerosj26/Proyecto-BDD/issues/7) |

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

## Documentación y Entregables del Repositorio

### Práctica 1: Fundamentos y Entorno
* [Planteamiento General del Proyecto](./docs/planteamiento-general.pdf)
* [Estudio del Dominio del Problema](./docs/estudio-dominio.pdf)
* [Especificación de Requisitos del Sistema](./docs/requisitos-sistema.pdf)
* [Diseño del Entorno y Arquitectura Docker](./docs/arquitectura-entorno.pdf)
* [Estado del Arte y Análisis Comparativo](./docs/estado-del-arte.pdf)

---

### Práctica 2: Modelo EER y Proyecto Asignado
* **Proyecto Asignado:** Consumo de Agua en la CDMX (ICOKG 2026)
* **Repositorio Fork Oficial:** [EMMAUELMG15/Data_Warehouse_static](https://github.com/EMMAUELMG15/Data_Warehouse_static)
* **Commit ID evaluado:** `b221008f51a2d48074d2847a9ff754e60ea9b4a4`
* [Bitácora de Levantamiento Técnico](./proyecto-asignado/levantamiento.md)
* **Evidencias de Ejecución:**
  * [Despliegue del contenedor en Docker](./evidencias/proyecto-asignado/arranque_docker.png)
  * [Aplicación web local interactiva](./evidencias/proyecto-asignado/app_local.png)
  * [Consulta directa en PostgreSQL](./evidencias/proyecto-asignado/consulta_db.png)* 
