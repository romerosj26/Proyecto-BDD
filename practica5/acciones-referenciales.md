# Ejercicio 2.2. Acciones referenciales

## 1. Introducción

Las acciones referenciales determinan el comportamiento de las claves foráneas cuando se intenta eliminar o actualizar un registro de la tabla padre.

En el proyecto de la concesionaria se utilizan principalmente las acciones `ON DELETE CASCADE`, `ON DELETE RESTRICT` y `ON UPDATE CASCADE`.

La selección de estas acciones se basa en las reglas del negocio, considerando la dependencia entre las entidades y la necesidad de conservar el historial de las operaciones.

## 2. Acciones referenciales seleccionadas

| Clave foránea | ON DELETE | ON UPDATE | Justificación |
|---|---|---|---|
| fk_telefonocliente_cliente | CASCADE | CASCADE | Los teléfonos registrados dependen de un cliente. Si el cliente desaparece, sus teléfonos también dejan de tener utilidad dentro del sistema. |
| fk_vehiculoventa_vehiculo | CASCADE | CASCADE | La clasificación de venta depende de la existencia del vehículo. Si se elimina el vehículo, también debe eliminarse su clasificación. |
| fk_vehiculorenta_vehiculo | CASCADE | CASCADE | La clasificación de renta depende de la existencia del vehículo. Si se elimina el vehículo, también debe eliminarse su clasificación. |
| fk_venta_cliente | RESTRICT | CASCADE | No se permite eliminar un cliente que tenga ventas registradas, porque se perdería el historial comercial y la relación con las operaciones realizadas. |
| fk_venta_empleado | RESTRICT | CASCADE | No se permite eliminar un empleado que tenga ventas asociadas, porque debe conservarse la información de quién atendió cada operación. |
| fk_detalleventa_venta | CASCADE | CASCADE | Los detalles de una venta dependen directamente de ella. Si se elimina una venta, sus detalles también deben desaparecer. |
| fk_detalleventa_vehiculoventa | RESTRICT | CASCADE | No se permite eliminar la clasificación de un vehículo que ya aparece en un detalle de venta, porque se afectaría el historial de la operación. |
| fk_renta_cliente | RESTRICT | CASCADE | No se permite eliminar un cliente con rentas registradas, porque deben conservarse las operaciones realizadas y su historial. |
| fk_renta_empleado | RESTRICT | CASCADE | No se permite eliminar un empleado que tenga rentas asociadas, porque debe mantenerse la información del responsable de cada operación. |
| fk_renta_vehiculorenta | RESTRICT | CASCADE | No se permite eliminar la clasificación de renta de un vehículo que tenga operaciones de renta asociadas. |
| fk_inspeccionrenta_renta | CASCADE | CASCADE | Las inspecciones de entrega y devolución dependen de una renta específica. Si se elimina la renta, sus inspecciones dejan de tener sentido. |

## 3. Justificación de las acciones utilizadas

### 3.1 ON DELETE CASCADE

Se utiliza cuando el registro de la tabla hija depende directamente de la existencia del registro padre.

En el proyecto se aplica en las siguientes relaciones:

- Cliente y telefonoCliente.
- Vehículo y vehiculoVenta.
- Vehículo y vehiculoRenta.
- Venta y detalleVenta.
- Renta e inspeccionRenta.

Estas relaciones representan información dependiente. Eliminar el registro padre provoca que sus registros hijos también sean eliminados.

### 3.2 ON DELETE RESTRICT

Se utiliza cuando el registro padre no debe eliminarse mientras existan registros hijos que dependan de él.

En el proyecto se aplica en:

- Cliente y venta.
- Empleado y venta.
- VehiculoVenta y detalleVenta.
- Cliente y renta.
- Empleado y renta.
- VehiculoRenta y renta.

La finalidad es proteger el historial comercial y operativo de la concesionaria.

Por ejemplo, no sería adecuado eliminar un cliente que ya realizó compras o rentas, porque se perdería la asociación entre las operaciones y la persona que las realizó.

### 3.3 ON UPDATE CASCADE

Se utiliza en las 11 claves foráneas del proyecto.

Esta acción permite que, si se modifica el identificador de un registro padre, PostgreSQL actualice automáticamente los valores correspondientes en las tablas hijas.

Aunque los identificadores generados mediante `IDENTITY` normalmente no necesitan modificarse, esta acción mantiene la integridad referencial si llegara a realizarse una modificación de la clave.

## 4. Acciones no utilizadas

### 4.1 ON DELETE SET NULL

No se utiliza porque las columnas que forman las claves foráneas están declaradas como `NOT NULL`.

Además, las operaciones de venta y renta necesitan conservar la identificación del cliente, empleado y vehículo involucrados.

### 4.2 ON DELETE SET DEFAULT

No se utiliza porque las claves foráneas no tienen valores predeterminados que representen una entidad válida para sustituir al registro eliminado.

Asignar una entidad genérica podría provocar que las operaciones históricas quedaran asociadas incorrectamente.

## 5. Consideraciones sobre la eliminación en cascada

Aunque `CASCADE` facilita la eliminación de información dependiente, debe utilizarse cuidadosamente.

Por ejemplo, eliminar una venta provoca también la eliminación de sus detalles. De igual manera, eliminar una renta provoca la eliminación de sus inspecciones.

En cambio, eliminar un cliente o empleado con operaciones registradas está restringido para conservar el historial de la concesionaria.

Por esta razón, en un sistema real sería preferible utilizar mecanismos de baja lógica para clientes, empleados y vehículos cuando se requiera conservar información histórica.

## 6. Conclusión

Las acciones referenciales implementadas buscan equilibrar la eliminación de información dependiente con la conservación de los registros históricos.

Se utiliza `CASCADE` para relaciones cuyos registros hijos dependen directamente del padre, `RESTRICT` para proteger las operaciones comerciales y `ON UPDATE CASCADE` para mantener sincronizadas las claves relacionadas cuando se modifica un identificador.