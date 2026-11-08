# Pruebas de integridad referencial

## 2.1. Identificación de claves foráneas y relaciones

La base de datos del proyecto cuenta con 11 claves foráneas que permiten mantener la integridad referencial entre las tablas.

Una clave foránea (FK) es una restricción que establece que el valor de una columna debe corresponder con un registro existente en otra tabla. De esta manera, se evita almacenar referencias a registros inexistentes.

| Clave foránea | Tabla hija y columna | Tabla padre y columna |
|---|---|---|
| `fk_telefonocliente_cliente` | telefonoCliente.idcliente | cliente.idcliente |
| `fk_vehiculoventa_vehiculo` | vehiculoVenta.idvehiculo | vehiculo.idvehiculo |
| `fk_vehiculorenta_vehiculo` | vehiculoRenta.idvehiculo | vehiculo.idvehiculo |
| `fk_venta_cliente` | venta.idcliente | cliente.idcliente |
| `fk_venta_empleado` | venta.idempleado | empleado.idempleado |
| `fk_detalleventa_venta` | detalleVenta.idventa | venta.idventa |
| `fk_detalleventa_vehiculoventa` | detalleVenta.idvehiculo | vehiculoVenta.idvehiculo |
| `fk_renta_cliente` | renta.idcliente | cliente.idcliente |
| `fk_renta_empleado` | renta.idempleado | empleado.idempleado |
| `fk_renta_vehiculorenta` | renta.idvehiculo | vehiculoRenta.idvehiculo |
| `fk_inspeccionrenta_renta` | inspeccionRenta.idrenta | renta.idrenta |

Las relaciones representan las siguientes dependencias:

- Un cliente puede tener varios teléfonos, ventas y rentas.
- Un empleado puede registrar varias ventas y rentas.
- Un vehículo puede pertenecer a la categoría de venta o de renta.
- Una venta puede contener varios detalles de venta.
- Cada detalle de venta corresponde a un vehículo registrado para venta.
- Una renta corresponde a un cliente, un empleado y un vehículo registrado para renta.
- Una renta puede tener inspecciones asociadas.

## 2.2. Acciones referenciales

Las acciones referenciales determinan qué sucede con los registros relacionados cuando se modifica o elimina un registro de la tabla padre.

Se definieron las siguientes acciones:

### ON DELETE CASCADE

Se utiliza cuando los registros de la tabla hija dependen directamente de la existencia del registro padre.

Se aplica en:

- `telefonoCliente` respecto a `cliente`.
- `vehiculoVenta` respecto a `vehiculo`.
- `vehiculoRenta` respecto a `vehiculo`.
- `detalleVenta` respecto a `venta`.
- `inspeccionRenta` respecto a `renta`.

La eliminación del registro padre provoca la eliminación automática de sus registros dependientes.

### ON DELETE RESTRICT

Se utiliza para impedir la eliminación de registros que forman parte del historial comercial de la concesionaria.

Se aplica en:

- `venta` respecto a `cliente`.
- `venta` respecto a `empleado`.
- `detalleVenta` respecto a `vehiculoVenta`.
- `renta` respecto a `cliente`.
- `renta` respecto a `empleado`.
- `renta` respecto a `vehiculoRenta`.

Esta acción protege la información histórica de las operaciones comerciales.

### ON UPDATE CASCADE

Se configuró en las 11 claves foráneas.

Cuando cambia el valor de una clave primaria referenciada, PostgreSQL actualiza automáticamente los valores correspondientes en las tablas hijas.

### ON DELETE SET NULL y ON DELETE SET DEFAULT

No se utilizaron estas acciones.

`SET NULL` no resulta adecuado porque las columnas que contienen las claves foráneas fueron definidas como `NOT NULL`.

`SET DEFAULT` tampoco fue necesario, ya que no se definieron valores predeterminados que representen una referencia válida para sustituir los valores eliminados.

## 2.3. Pruebas de integridad referencial

Se realizaron pruebas controladas en PostgreSQL para comprobar el comportamiento de las acciones referenciales.

### 2.3.1. Prueba de ON DELETE CASCADE

**Objetivo:** comprobar que al eliminar un registro padre también se eliminen sus registros dependientes.

Se utilizó la relación entre `renta` e `inspeccionRenta`.

```sql
BEGIN;

DELETE FROM renta
WHERE idrenta = 1;

SELECT COUNT(*) FROM renta
WHERE idrenta = 1;

SELECT COUNT(*) FROM inspeccionRenta
WHERE idrenta = 1;

ROLLBACK;
```

**Resultado obtenido:**

- Antes de la eliminación existía una renta con identificador 1 y una inspección asociada.
- Después del `DELETE`, ambos conteos fueron 0.
- Se ejecutó `ROLLBACK` para revertir la prueba y recuperar los registros.

**Conclusión:** la acción `ON DELETE CASCADE` funcionó correctamente. La eliminación del registro padre provocó la eliminación automática del registro dependiente.

### 2.3.2. Prueba de ON DELETE RESTRICT

**Objetivo:** comprobar que PostgreSQL impida eliminar un registro padre cuando existen registros relacionados que deben conservarse.

Se intentó eliminar un cliente que tenía una renta asociada.

```sql
DELETE FROM cliente
WHERE idcliente = 1;
```

**Resultado obtenido:**

PostgreSQL rechazó la operación e indicó que no era posible eliminar el registro debido a la restricción `fk_renta_cliente`.

**Conclusión:** la acción `ON DELETE RESTRICT` funcionó correctamente, protegiendo los registros relacionados con el historial de rentas.

### 2.3.3. Prueba de ON UPDATE CASCADE

**Objetivo:** comprobar que la actualización de una clave primaria se propague automáticamente a las tablas relacionadas.

Se modificó temporalmente el identificador del cliente 1 a 999.

Debido a que la columna utiliza una identidad `GENERATED ALWAYS`, fue necesario permitir temporalmente la generación manual de valores.

```sql
BEGIN;

ALTER TABLE cliente
ALTER COLUMN idcliente SET GENERATED BY DEFAULT;

UPDATE cliente
SET idcliente = 999
WHERE idcliente = 1;

SELECT idcliente
FROM renta
WHERE idrenta = 1;

ROLLBACK;
```

**Resultado obtenido:**

El identificador del cliente relacionado con la renta también cambió automáticamente de 1 a 999.

Después se ejecutó `ROLLBACK`, por lo que tanto el identificador original como la configuración de identidad quedaron restaurados.

**Conclusión:** la acción `ON UPDATE CASCADE` funcionó correctamente.

### 2.3.4. Prueba de inserción con una clave foránea inexistente

**Objetivo:** comprobar que no sea posible insertar un registro que haga referencia a un registro padre inexistente.

Se intentó insertar una renta utilizando identificadores que no correspondían con registros existentes.

**Resultado obtenido:**

PostgreSQL rechazó la inserción y señaló la restricción `fk_renta_cliente`.

El motor detuvo la operación al encontrar la primera referencia inválida, por lo que no se comprobaron individualmente las demás referencias de esa misma inserción.

**Conclusión:** la integridad referencial impide insertar registros con referencias inexistentes.

## 2.4. Comprobación general de integridad

Después de ejecutar las pruebas y cargar los datos, se realizaron consultas de verificación sobre las tablas.

### 2.4.1. Comprobación de registros huérfanos

Se revisaron las 11 claves foráneas para identificar registros hijos que no tuvieran un registro padre correspondiente.

**Resultado obtenido:**

Las 11 comprobaciones devolvieron 0 registros huérfanos.

**Conclusión:** todas las referencias existentes corresponden a registros válidos de sus respectivas tablas padre.

### 2.4.2. Comprobación de valores duplicados

Se verificaron las restricciones de unicidad definidas en el modelo:

- `cliente.correo`.
- `empleado.correo`.
- `empleado.numeroempleado`.
- `vehiculo.vin`.
- `detalleVenta.idvehiculo`.
- Combinación `telefonoCliente.idcliente` y `telefonoCliente.telefono`.
- Combinación `inspeccionRenta.idrenta` e `inspeccionRenta.tipo`.
- Combinación `catalogoVersion.marca`, `modelo`, `version` y `anio`.

**Resultado obtenido:**

Las ocho comprobaciones devolvieron 0 registros duplicados.

**Conclusión:** no se encontraron duplicados en los campos y combinaciones de columnas revisados.

### 2.4.3. Comprobación de valores NOT NULL

Se revisaron 12 columnas importantes de distintas tablas, entre ellas:

- `cliente.nombre` y `cliente.correo`.
- `empleado.nombre` y `empleado.telefono`.
- `vehiculo.vin` y `vehiculo.marca`.
- `venta.idcliente` y `venta.importetotal`.
- `renta.idvehiculo` y `renta.tarifaaplicada`.
- `inspeccionRenta.idrenta` y `inspeccionRenta.kilometraje`.

**Resultado obtenido:**

Las 12 comprobaciones devolvieron 0 valores nulos.

**Conclusión:** las columnas seleccionadas cumplen con la condición de obligatoriedad establecida en el modelo. Esta revisión corresponde a una selección de columnas, no a un análisis exhaustivo de todas las columnas `NOT NULL` de la base de datos.

### 2.4.4. Comprobación de restricciones CHECK

Se consultó el catálogo de restricciones de PostgreSQL mediante `pg_constraint`.

**Resultado obtenido:**

Se encontraron 28 restricciones `CHECK` validadas (`convalidated = true`), incluyendo restricciones definidas sobre tablas y dominios.

**Conclusión:** las restricciones `CHECK` registradas se encuentran validadas por PostgreSQL.

También se verificaron reglas de negocio mediante consultas específicas:

- Kilometraje de vehículos no negativo.
- Estados de inventario dentro de los valores permitidos.
- Fechas de renta coherentes.
- Nivel de combustible de las inspecciones entre 0 y 100.

Las cuatro comprobaciones devolvieron 0 registros que incumplieran las condiciones revisadas.

### 2.4.5. Comprobación de claves primarias

Se consultó `information_schema.table_constraints` junto con `information_schema.key_column_usage`.

**Resultado obtenido:**

Las 11 tablas cuentan con clave primaria.

Se identificaron dos claves primarias compuestas:

- `detalleVenta`: `(idventa, numlinea)`.
- `telefonoCliente`: `(idcliente, telefono)`.

Las nueve tablas restantes utilizan una clave primaria simple.

**Conclusión:** todas las tablas tienen identificadores primarios definidos.

## 2.5. Carga de datos mediante operaciones DML

Se realizaron operaciones DML (`INSERT`, `UPDATE` y consultas `SELECT`) para poblar las tablas y comprobar el funcionamiento de las relaciones.

La carga se organizó respetando las dependencias entre las tablas, insertando primero los registros padre y posteriormente los registros hijos.

### 2.5.1. Orden de inserción

Se utilizó el siguiente orden:

1. `cliente`
2. `empleado`
3. `vehiculo`
4. `telefonoCliente`
5. `vehiculoVenta`
6. `vehiculoRenta`
7. `venta`
8. `detalleVenta`
9. `renta`
10. `inspeccionRenta`

La tabla `catalogoVersion` ya contaba con 1,127 registros provenientes del archivo de datos del proyecto, por lo que se conservaron y no se realizó una nueva carga para evitar duplicados.

### 2.5.2. Registros insertados

Se conservaron los registros que ya existían y se agregaron nuevos datos de prueba.

**Clientes:**
- Se agregaron cuatro clientes.
- Se conservaron los registros existentes.

**Empleados:**
- Se agregaron dos empleados.
- Se conservó el empleado existente.

**Vehículos:**
- Se agregaron ocho vehículos.
- Se conservó el vehículo existente.

**Teléfonos de clientes:**
- Se agregaron cinco registros.

**Vehículos para venta:**
- Se agregaron cuatro registros.

**Vehículos para renta:**
- Se agregaron cuatro registros, además del vehículo que ya estaba registrado para renta.

**Ventas:**
- Se agregaron cuatro operaciones de venta.

**Detalles de venta:**
- Se agregaron cuatro detalles, uno por cada venta.

**Rentas:**
- Se agregaron cuatro rentas con diferentes estados: dos finalizadas, una activa y una reservada, además de la renta que ya existía.

**Inspecciones de renta:**
- Se agregaron cinco inspecciones, conservando la inspección existente.

### 2.5.3. Validación de las operaciones DML

Se realizaron consultas para comprobar que:

- Los vehículos estuvieran clasificados correctamente para venta o renta.
- Ningún vehículo apareciera simultáneamente en ambas categorías.
- Cada venta tuviera su detalle correspondiente.
- Los importes totales de las ventas coincidieran con la suma de sus detalles.
- No existieran vehículos vendidos más de una vez.
- Las inspecciones no se duplicaran para una misma renta y tipo.
- El kilometraje de devolución no fuera inferior al kilometraje de entrega.

**Resultados obtenidos:**

Las comprobaciones realizadas no detectaron vehículos duplicados entre las categorías, diferencias entre los importes de las ventas y sus detalles, inspecciones duplicadas ni kilometrajes de devolución inferiores a los de entrega.

### 2.5.4. Actualización del estado de los vehículos vendidos

Durante la revisión se detectó que cuatro vehículos registrados en `detalleVenta` todavía tenían el estado `Disponible` en la tabla `vehiculo`.

Para mantener la coherencia entre las ventas registradas y el estado del inventario, se ejecutó la siguiente actualización:

```sql
UPDATE vehiculo
SET estadoinventario = 'Vendido'
WHERE idvehiculo IN (
    SELECT idvehiculo
    FROM detalleVenta
);
```

La operación se ejecutó dentro de una transacción y se verificó mediante una consulta `SELECT`.

**Resultado obtenido:**

PostgreSQL reportó `UPDATE 4`. Los cuatro vehículos relacionados con las ventas quedaron registrados con estado `Vendido`.

Posteriormente se confirmó la transacción mediante `COMMIT` y se verificó que los cambios permanecieran en la base de datos.

## 2.6. Conteo final de registros

Se realizó un conteo de los registros almacenados en las 11 tablas para comprobar que las operaciones DML se ejecutaron correctamente.

| Tabla | Registros finales |
|---|---:|
| catalogoVersion | 1,127 |
| cliente | 5 |
| detalleVenta | 4 |
| empleado | 3 |
| inspeccionRenta | 6 |
| renta | 5 |
| telefonoCliente | 5 |
| vehiculo | 9 |
| vehiculoRenta | 5 |
| vehiculoVenta | 4 |
| venta | 4 |
| **Total** | **1,177** |

**Conclusión:** el conteo final coincide con la cantidad de registros esperada después de las operaciones de inserción realizadas. Los registros preexistentes se conservaron y los nuevos registros se incorporaron respetando las relaciones y restricciones de la base de datos.

## 2.7. Conclusión general

Las pruebas realizadas permitieron comprobar el funcionamiento de las claves foráneas, las acciones referenciales `CASCADE`, `RESTRICT` y `ON UPDATE CASCADE`, así como las restricciones de unicidad, obligatoriedad y validación de datos.

También se realizaron operaciones DML para incorporar información de clientes, empleados, vehículos, ventas, rentas e inspecciones.

Las consultas de verificación confirmaron que no existen registros huérfanos en las relaciones revisadas, no se encontraron duplicados en las restricciones de unicidad comprobadas y los importes y datos de las operaciones comerciales cumplen con las condiciones verificadas.

Finalmente, se comprobó que la base de datos conserva un total de 1,177 registros distribuidos entre sus 11 tablas.

En conjunto, los resultados demuestran que el modelo y las operaciones realizadas cumplen con las pruebas de integridad referencial y manipulación de datos contempladas en esta práctica.