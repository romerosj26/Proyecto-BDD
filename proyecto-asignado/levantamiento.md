# Bitácora de Levantamiento: Consumo de Agua en la Ciudad de México

* **Proyecto asignado:** *Territorial Information Retrieval from Heterogeneous Open Data through the Construction of a Data Warehouse for Water Management in Mexico City* (ICOKG 2026).
* **Repositorio Fork:** [https://github.com/EMMAUELMG15/Data_Warehouse_static](https://github.com/EMMAUELMG15/Data_Warehouse_static)
* **Identificador de confirmación (Commit ID) evaluado:** `b221008f51a2d48074d2847a9ff754e60ea9b4a4`

---

## 1. Requisitos Previos del Sistema
* **Docker Desktop:** Versión 4.x con soporte para Linux containers.
* **Docker Compose:** Versión v2.x.
* **Puertos TCP de red:**
  * Puerto `5433` TCP libre (para el gestor PostgreSQL del almacén dimensional).
  * Puerto `8080` TCP libre (para servir la interfaz web estática mediante contenedor Nginx).

---

## 2. Procedimiento de Puesta en Marcha (Paso a Paso)

1. **Clonación del repositorio asignado:**  
   Se realizó en un directorio independiente del proyecto de aula:
   ```bash
   git clone [https://github.com/EMMAUELMG15/Data_Warehouse_static.git](https://github.com/EMMAUELMG15/Data_Warehouse_static.git)
   cd Data_Warehouse_static/warehouse