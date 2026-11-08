# Ejercicio 2.6: Trabajo Individual - Evaluación de Acciones Referenciales

**Alumno:** Emmanuel Morales González  
**GitHub:** EMMANUELG15  
**Unidad de Aprendizaje:** Bases de Datos (Plan 2020) — Grupo 3CV4  
**Institución:** Instituto Politécnico Nacional — Escuela Superior de Cómputo (ESCOM)  
**Proyecto Propio:** Concesionaria Automotriz  

---

## 1. Identificación de la Relación Seleccionada

* **Tabla Padre (Principal):** `vehiculo`  
  * Clave Primaria: `id_vehiculo` (Identificador único de la unidad automotriz en inventario).
* **Tabla Hija (Dependiente):** `mantenimiento`  
  * Clave Foránea: `mantenimiento.id_vehiculo -> vehiculo.id_vehiculo`.
  * Propósito: Bitácora de servicios mecánicos, revisiones preventivas, cambios de refacciones y órdenes de garantía ejecutadas sobre el vehículo.

---

## 2. Justificación Técnica: RESTRICT vs. CASCADE

### 2.1 Configuración Operativa de Negocio (`RESTRICT`)
En el diseño formal de la concesionaria, la acción ante borrado debe ser estrictamente `ON DELETE RESTRICT` (o `NO ACTION`).

* **Regla del Negocio Automotriz:**  
  Un vehículo no puede eliminarse físicamente de la base de datos si ya cuenta con historial de mantenimiento registrado. La información técnica de taller ampara pólizas de garantía de fábrica, facturación fiscal de servicios mecánicos y trazabilidad ante reclamaciones legales del consumidor (PROFECO). Borrar un vehículo con historial activo violaría las normas de auditoría contable y técnica del taller.

### 2.2 Evaluación Experimental con `CASCADE`
Para analizar el comportamiento de eliminación en cascada exigido por la práctica, se clonó la estructura en un ambiente controlado de pruebas y se alteró la restricción:

```sql
-- 1. Modificación de la restricción de integridad referencial a CASCADE
ALTER TABLE mantenimiento
    DROP CONSTRAINT IF EXISTS fk_mantenimiento_vehiculo,
    ADD CONSTRAINT fk_mantenimiento_vehiculo
        FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
        ON DELETE CASCADE;

-- 2. Conteo previo a la eliminación (Unidad con historial)
SELECT count(*) AS total_vehiculos FROM vehiculo WHERE id_vehiculo = 45;
-- Resultado: 1 registro (ej. Sedán Modelo 2023)

SELECT count(*) AS total_mantenimientos FROM mantenimiento WHERE id_vehiculo = 45;
-- Resultado: 4 registros (afinación mayor, frenos, cambio de aceite y garantía de sensor)

-- 3. Ejecución de la sentencia de borrado en la tabla padre
DELETE FROM vehiculo WHERE id_vehiculo = 45;

-- 4. Comprobación de integridad posterior
SELECT count(*) AS total_vehiculos FROM vehiculo WHERE id_vehiculo = 45;
-- Resultado: 0 registros

SELECT count(*) AS total_mantenimientos FROM mantenimiento WHERE id_vehiculo = 45;
-- Resultado: 0 registros (Borrados automáticamente en cascada)
```

---

## 3. Análisis de Impacto y Conclusión de Dominio

### 3.1 Información Perdida vs. Información Conservada
* **Lo que se pierde con CASCADE:**  
  * Se destruyen definitivamente las bitácoras de mano de obra de mecánicos.
  * Se pierden los folios de refacciones instaladas y diagnósticos de escaneo computarizado.
  * Se descalabran los reportes contables si las órdenes de servicio estaban asociadas a liquidaciones de nómina o comisiones por mano de obra.
* **Lo que se conserva:**  
  * Catálogos estáticos no dependientes (catálogo de talleres, catálogo de mecánicos y lista de repuestos genéricos).

### 3.2 Veredicto de Diseño
Para el sistema de gestión de una concesionaria automotriz, **`CASCADE` resulta inaceptable e inseguro**.  

La arquitectura de software debe mantener `ON DELETE RESTRICT` y adoptar un esquema de **borrado lógico** (`activo = false`, `estado = 'BAJA'` o `fecha_baja = NOW()`). Esto permite retirar comercialmente una unidad del catálogo de ventas activas sin destruir la certidumbre jurídica y técnica acumulada en la bitácora de mantenimiento.