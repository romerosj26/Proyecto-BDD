

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

## 2. Estructura del Repositorio
```text
Practica1/
├── README.md
├── .gitignore
├── docs/
|   └── Estudio_Proyecto.pdf
|   └── Practica1_Ej1_ParteA.pdf
|   └── Practica1_Ej2_ParteA.pdf
|   └── Practica1_Ej3.pdf
|   └── Practica1_Ej4_Estado_del_Arte.pdf
├── entorno/
│   └── compose.yaml
├── modelos/
│   └── ER.drawio.png
├── evidencias/
│   ├── git/
│   ├── docker/
└── 
```
---
## 5. Declaración sobre el uso de IA Generativa
En apego a los lineamientos de integridad académica:
* **Herramienta:** Gemini (Google).
* **Uso:** Configuración de mapeo de puertos concurrentes en Docker para PostgreSQL (5432 y 5433), estructuración técnica de bitácoras de levantamiento y redacción de propuestas de mejora conforme a los requerimientos de la práctica.
