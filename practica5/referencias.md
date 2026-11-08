# Ejercicio 2.1. Claves foráneas del proyecto propio

## 1. Descripción

El proyecto consiste en una base de datos para administrar una concesionaria dedicada a la venta y renta de automóviles.

La integridad referencial se implementa mediante claves foráneas (`FOREIGN KEY`), las cuales garantizan que los valores de las columnas relacionadas en una tabla hija correspondan a registros existentes en una tabla padre.

Se identificaron **11 claves foráneas** distribuidas entre las tablas del proyecto.

## 2. Inventario de claves foráneas

| Clave foránea | Relación del modelo EER | Tabla y columna hija | Tabla y columna referenciada | ¿Admite NULL? |
|---|---|---|---|---|
| fk_telefonocliente_cliente | Cliente — Tiene teléfonos | telefonoCliente.idCliente | cliente.idCliente | No |
| fk_vehiculoventa_vehiculo | Vehículo — Clasificación para venta | vehiculoVenta.idVehiculo | vehiculo.idVehiculo | No |
| fk_vehiculorenta_vehiculo | Vehículo — Clasificación para renta | vehiculoRenta.idVehiculo | vehiculo.idVehiculo | No |
| fk_venta_cliente | Cliente — Realiza ventas | venta.idCliente | cliente.idCliente | No |
| fk_venta_empleado | Empleado — Atiende ventas | venta.idEmpleado | empleado.idEmpleado | No |
| fk_detalleventa_venta | Venta — Contiene detalles | detalleVenta.idVenta | venta.idVenta | No |
| fk_detalleventa_vehiculoventa | Vehículo de venta — Se incluye en detalle | detalleVenta.idVehiculo | vehiculoVenta.idVehiculo | No |
| fk_renta_cliente | Cliente — Realiza rentas | renta.idCliente | cliente.idCliente | No |
| fk_renta_empleado | Empleado — Gestiona rentas | renta.idEmpleado | empleado.idEmpleado | No |
| fk_renta_vehiculorenta | Vehículo de renta — Se asigna a rentas | renta.idVehiculo | vehiculoRenta.idVehiculo | No |
| fk_inspeccionrenta_renta | Renta — Tiene inspecciones | inspeccionRenta.idRenta | renta.idRenta | No |

## 3. Justificación de las relaciones

### 3.1 Cliente y teléfonoCliente

Un cliente puede registrar varios números telefónicos. Cada registro de teléfono pertenece obligatoriamente a un cliente.

La tabla `telefonoCliente` utiliza una clave primaria compuesta por `idCliente` y `telefono`, y su clave foránea referencia a `cliente.idCliente`.

La columna `idCliente` no admite valores nulos porque un teléfono registrado no tiene sentido dentro del sistema si no está asociado a un cliente.

### 3.2 Vehículo y vehículoVenta

Un vehículo puede estar clasificado para la venta. La tabla `vehiculoVenta` representa esa clasificación y utiliza `idVehiculo` como clave primaria y foránea.

La relación es obligatoria para cada registro de `vehiculoVenta`, ya que no puede existir una clasificación de venta sin un vehículo registrado.

### 3.3 Vehículo y vehículoRenta

Un vehículo puede estar clasificado para la renta. La tabla `vehiculoRenta` representa esa clasificación y utiliza `idVehiculo` como clave primaria y foránea.

La columna no admite valores nulos porque toda clasificación de renta debe corresponder a un vehículo existente.

### 3.4 Cliente y venta

Un cliente puede realizar varias compras, pero cada venta debe pertenecer obligatoriamente a un cliente.

Por ello, `venta.idCliente` es una clave foránea que referencia a `cliente.idCliente` y no admite valores nulos.

### 3.5 Empleado y venta

Un empleado puede atender varias ventas, pero cada venta debe registrar al empleado responsable.

La columna `venta.idEmpleado` referencia a `empleado.idEmpleado` y es obligatoria.

### 3.6 Venta y detalleVenta

Una venta puede contener uno o varios detalles, mientras que cada detalle pertenece a una sola venta.

La columna `detalleVenta.idVenta` referencia a `venta.idVenta` y no admite valores nulos porque un detalle no puede existir independientemente de su venta.

### 3.7 VehículoVenta y detalleVenta

Cada detalle de venta identifica un vehículo destinado a la comercialización.

La columna `detalleVenta.idVehiculo` referencia a `vehiculoVenta.idVehiculo`. Además, cuenta con una restricción `UNIQUE`, que impide que un mismo vehículo aparezca en más de un detalle de venta.

Esta relación garantiza que solamente se incluyan vehículos clasificados para la venta.

### 3.8 Cliente y renta

Un cliente puede realizar varias rentas, pero cada renta debe estar asociada obligatoriamente a un cliente.

La columna `renta.idCliente` referencia a `cliente.idCliente` y no admite valores nulos.

### 3.9 Empleado y renta

Un empleado puede gestionar varias rentas, pero cada operación de renta debe identificar al empleado responsable.

La columna `renta.idEmpleado` referencia a `empleado.idEmpleado` y es obligatoria.

### 3.10 VehículoRenta y renta

Un vehículo clasificado para renta puede participar en diferentes operaciones de renta a lo largo del tiempo. Cada registro de renta debe identificar obligatoriamente un vehículo disponible para ese propósito.

La columna `renta.idVehiculo` referencia a `vehiculoRenta.idVehiculo`.

Además, el proyecto utiliza una restricción de exclusión para evitar que dos rentas activas o reservadas del mismo vehículo tengan periodos de tiempo traslapados.

### 3.11 Renta e inspeccionRenta

Una renta puede tener inspecciones relacionadas con la entrega y la devolución del automóvil.

Cada inspección debe pertenecer obligatoriamente a una renta. Por ello, `inspeccionRenta.idRenta` referencia a `renta.idRenta` y no admite valores nulos.

La restricción `UNIQUE (idRenta, tipo)` permite registrar como máximo una inspección de cada tipo por renta.

## 4. Análisis de nulabilidad y cardinalidades

Todas las columnas que forman las claves foráneas son `NOT NULL`. Esto significa que cada registro de una tabla hija debe estar relacionado con un registro padre existente.

Sin embargo, esto no obliga a que cada registro padre tenga hijos. Por ejemplo:

- Un cliente puede existir sin haber realizado una compra.
- Un empleado puede existir sin haber atendido ventas.
- Un vehículo puede existir sin estar clasificado para venta o renta.
- Una venta puede tener detalles obligatorios en el modelo de negocio, aunque la estructura actual no impone un mínimo de detalles mediante una clave foránea.
- Una renta puede existir sin inspecciones, aunque el proceso operativo pueda requerirlas posteriormente.

Por lo tanto, la nulabilidad de las claves foráneas representa la participación obligatoria de la entidad hija en la relación, no la participación obligatoria de la entidad padre.

## 5. Relaciones no implementadas mediante claves foráneas

No se identificaron relaciones del esquema original que requieran una clave foránea adicional para conectar las diez tablas principales.

La tabla `catalogoVersion` se incorporó posteriormente como un catálogo auxiliar de versiones y precios de referencia de vehículos nuevos. No tiene una clave foránea hacia `vehiculo`, porque sus registros representan información de referencia del mercado y no vehículos individuales registrados en el inventario de la concesionaria.

## 6. Conclusión

El esquema de la concesionaria cuenta con 11 claves foráneas que implementan las relaciones entre sus entidades y garantizan que los registros dependientes hagan referencia a información existente.

Todas las claves foráneas tienen nulabilidad obligatoria (`NOT NULL`). Las acciones referenciales establecidas permiten controlar qué sucede cuando se intenta eliminar o actualizar un registro padre, aspecto que se analizará en el ejercicio 2.2.