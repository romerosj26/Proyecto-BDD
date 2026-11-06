# Análisis de tipos de datos y dominios

## 1. Introducción

El objetivo de este documento es identificar y justificar los tipos de datos utilizados en la base de datos de la concesionaria de venta y renta de automóviles.

La selección de los tipos de datos considera la naturaleza de la información, los valores que puede almacenar cada atributo, su longitud, precisión y las restricciones necesarias para mantener la integridad de los datos.

También se identifican dominios reutilizables que permiten establecer reglas comunes para atributos que representan el mismo concepto.

## 2. Criterios de selección

Se utilizaron los siguientes criterios:

- **Identificadores:** se utiliza `INT` para claves primarias y foráneas. Las claves primarias autogeneradas utilizan `GENERATED ALWAYS AS IDENTITY`.
- **Cadenas de longitud fija:** se utiliza `CHAR(n)` cuando el atributo requiere una cantidad fija de caracteres.
- **Cadenas de longitud variable:** se utiliza `VARCHAR(n)` cuando existe un límite máximo, pero no todos los valores necesitan ocupar la misma longitud.
- **Texto sin longitud máxima pequeña:** se utiliza `TEXT` para observaciones.
- **Cantidades enteras:** se utilizan `SMALLINT` o `INT` según el rango esperado.
- **Importes monetarios:** se utiliza `DECIMAL(p,s)` para conservar precisión decimal exacta.
- **Fechas:** se utiliza `DATE` cuando solo importa el día y `TIMESTAMP` cuando también es necesario registrar la hora.

## 3. Diccionario de tipos de datos por tabla

### 3.1. Tabla cliente

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idCliente | INT IDENTITY | Entero de 32 bits | Identificador único autogenerado. |
| nombre | VARCHAR(60) | Máximo 60 caracteres | Permite almacenar nombres de longitud variable. |
| apellidoPaterno | VARCHAR(60) | Máximo 60 caracteres | Permite almacenar apellidos de longitud variable. |
| apellidoMaterno | VARCHAR(60) | Máximo 60 caracteres | Puede quedar vacío cuando no se proporciona. |
| correo | VARCHAR(100) | Máximo 100 caracteres | Almacena direcciones de correo electrónico. |
| calle | VARCHAR(80) | Máximo 80 caracteres | Almacena nombres de calles. |
| numero | VARCHAR(10) | Máximo 10 caracteres | Permite números exteriores e interiores alfanuméricos. |
| colonia | VARCHAR(60) | Máximo 60 caracteres | Almacena nombres de colonias. |
| codigoPostal | CHAR(5) | Exactamente 5 caracteres | Representa códigos postales mexicanos de cinco dígitos. |

### 3.2. Tabla empleado

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idEmpleado | INT IDENTITY | Entero de 32 bits | Identificador único autogenerado. |
| numeroEmpleado | VARCHAR(20) | Máximo 20 caracteres | Permite identificadores alfanuméricos. |
| nombre | VARCHAR(60) | Máximo 60 caracteres | Almacena nombres de longitud variable. |
| apellidoPaterno | VARCHAR(60) | Máximo 60 caracteres | Almacena apellidos de longitud variable. |
| apellidoMaterno | VARCHAR(60) | Máximo 60 caracteres | Puede quedar vacío cuando no se proporciona. |
| telefono | VARCHAR(15) | Máximo 15 caracteres | Conserva prefijos y otros caracteres telefónicos. |
| correo | VARCHAR(100) | Máximo 100 caracteres | Almacena direcciones de correo electrónico. |

### 3.3. Tabla vehiculo

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVehiculo | INT IDENTITY | Entero de 32 bits | Identificador único autogenerado. |
| VIN | CHAR(17) | Exactamente 17 caracteres | Identificador vehicular de longitud fija. |
| marca | VARCHAR(40) | Máximo 40 caracteres | Almacena marcas de vehículos. |
| modelo | VARCHAR(40) | Máximo 40 caracteres | Almacena modelos de vehículos. |
| anio | SMALLINT | Entero de 16 bits | Almacena el año de fabricación. |
| color | VARCHAR(30) | Máximo 30 caracteres | Almacena colores de longitud variable. |
| kilometraje | INT | Entero de 32 bits | Almacena kilómetros recorridos. |
| estadoInventario | VARCHAR(20) | Máximo 20 caracteres | Almacena el estado actual del vehículo. |

### 3.4. Tabla telefonoCliente

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idCliente | INT | Entero de 32 bits | Referencia al cliente propietario del teléfono. |
| telefono | VARCHAR(15) | Máximo 15 caracteres | Almacena números telefónicos como texto. |

### 3.5. Tabla vehiculoVenta

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVehiculo | INT | Entero de 32 bits | Identifica al vehículo perteneciente al subtipo de venta. |
| precioVenta | DECIMAL(12,2) | 12 dígitos, 2 decimales | Almacena precios con precisión monetaria exacta. |
| condicion | VARCHAR(10) | Máximo 10 caracteres | Identifica si el vehículo es nuevo o usado. |

### 3.6. Tabla vehiculoRenta

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVehiculo | INT | Entero de 32 bits | Identifica al vehículo perteneciente al subtipo de renta. |
| tarifaDiaria | DECIMAL(10,2) | 10 dígitos, 2 decimales | Almacena la tarifa diaria con precisión monetaria. |
| categoria | VARCHAR(30) | Máximo 30 caracteres | Clasifica los vehículos por categoría. |

### 3.7. Tabla venta

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVenta | INT IDENTITY | Entero de 32 bits | Identificador único autogenerado. |
| idCliente | INT | Entero de 32 bits | Referencia al cliente que realiza la compra. |
| idEmpleado | INT | Entero de 32 bits | Referencia al empleado que atiende la venta. |
| fecha | DATE | Fecha sin hora | Registra el día en que se realiza la venta. |
| importeTotal | DECIMAL(12,2) | 12 dígitos, 2 decimales | Almacena el importe total de la operación. |

### 3.8. Tabla detalleVenta

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVenta | INT | Entero de 32 bits | Referencia a la venta correspondiente. |
| numLinea | SMALLINT | Entero de 16 bits | Identifica la posición del detalle dentro de la venta. |
| idVehiculo | INT | Entero de 32 bits | Referencia al vehículo vendido. |
| precioAplicado | DECIMAL(12,2) | 12 dígitos, 2 decimales | Conserva el precio aplicado al momento de la venta. |

### 3.9. Tabla renta

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idRenta | INT IDENTITY | Entero de 32 bits | Identificador único autogenerado. |
| idCliente | INT | Entero de 32 bits | Referencia al cliente que solicita la renta. |
| idEmpleado | INT | Entero de 32 bits | Referencia al empleado que gestiona la renta. |
| idVehiculo | INT | Entero de 32 bits | Referencia al vehículo rentado. |
| fechaHoraInicio | TIMESTAMP | Fecha y hora | Registra el inicio de la renta. |
| fechaHoraDevPrevista | TIMESTAMP | Fecha y hora | Registra la fecha y hora previstas de devolución. |
| fechaHoraDevReal | TIMESTAMP | Fecha y hora, nullable | Registra la devolución efectiva cuando ocurre. |
| tarifaAplicada | DECIMAL(10,2) | 10 dígitos, 2 decimales | Conserva la tarifa acordada para la renta. |
| importeTotal | DECIMAL(12,2) | 12 dígitos, 2 decimales | Almacena el importe total de la renta. |
| estado | VARCHAR(20) | Máximo 20 caracteres | Identifica el estado operativo de la renta. |

### 3.10. Tabla inspeccionRenta

| Atributo | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idInspeccion | INT IDENTITY | Entero de 32 bits | Identificador único autogenerado. |
| idRenta | INT | Entero de 32 bits | Referencia a la renta inspeccionada. |
| tipo | VARCHAR(10) | Máximo 10 caracteres | Identifica la inspección de entrega o devolución. |
| fechaHora | TIMESTAMP | Fecha y hora | Registra el momento de la inspección. |
| kilometraje | INT | Entero de 32 bits | Almacena el kilometraje registrado durante la inspección. |
| nivelCombustible | SMALLINT | Entero de 16 bits | Almacena el nivel de combustible como porcentaje. |
| observaciones | TEXT | Longitud variable | Permite registrar descripciones y observaciones sin un límite pequeño predefinido. |

## 4. Dominios propuestos

Un dominio en PostgreSQL es un tipo de dato definido por el usuario a partir de un tipo existente, al que se le pueden agregar restricciones.

Su principal ventaja es reutilizar reglas de validación en distintas columnas y evitar repetir definiciones equivalentes.

Se proponen los siguientes dominios:

| Dominio | Tipo base | Regla | Aplicación |
|---|---|---|---|
| codigo_postal_mx | CHAR(5) | Exactamente cinco dígitos | cliente.codigoPostal |
| vin_vehicular | CHAR(17) | Exactamente 17 caracteres alfanuméricos | vehiculo.VIN |
| telefono | VARCHAR(15) | Cadena no vacía | empleado.telefono y telefonoCliente.telefono |
| importe_monetario | DECIMAL(12,2) | Valor mayor o igual a cero | Importes y precios aplicados |
| tarifa_positiva | DECIMAL(10,2) | Valor mayor que cero | Tarifas de renta |

### 4.1. Definición SQL propuesta

```sql
CREATE DOMAIN codigo_postal_mx AS CHAR(5)
CHECK (VALUE ~ '^[0-9]{5}$');

CREATE DOMAIN vin_vehicular AS CHAR(17)
CHECK (VALUE ~ '^[A-HJ-NPR-Z0-9]{17}$');

CREATE DOMAIN telefono AS VARCHAR(15)
CHECK (VALUE ~ '^[0-9+() -]{7,15}$');

CREATE DOMAIN importe_monetario AS DECIMAL(12,2)
CHECK (VALUE >= 0);

CREATE DOMAIN tarifa_positiva AS DECIMAL(10,2)
CHECK (VALUE > 0);
```

### 4.2. Ventajas de utilizar dominios

- Centralizan reglas de validación comunes.
- Reducen la repetición de restricciones en diferentes tablas.
- Facilitan el mantenimiento del esquema.
- Mejoran la consistencia de los datos.
- Permiten expresar reglas propias del negocio mediante tipos reutilizables.

### 4.3. Consideraciones

Los dominios propuestos deberán evaluarse antes de incorporarlos al esquema definitivo.

Por ejemplo, un dominio de teléfono puede necesitar una expresión de validación más específica según los formatos que admita el negocio. Asimismo, un dominio monetario no debe utilizarse indiscriminadamente para todos los importes si algunos requieren permitir valores negativos o tienen precisiones diferentes.

## 5. Conclusión

La selección de tipos de datos busca representar correctamente la información de la concesionaria, evitando conversiones innecesarias, pérdida de precisión y almacenamiento de valores que no corresponden a la naturaleza de cada atributo.

La incorporación de dominios permite complementar los tipos de datos existentes mediante reglas reutilizables, fortaleciendo la integridad y consistencia de la base de datos.

# Restricciones de columna y reglas de integridad

## 1. Introducción

La base de datos de la concesionaria implementa restricciones para garantizar la integridad, consistencia y validez de la información almacenada.

Estas restricciones permiten evitar registros incompletos, valores fuera de los rangos permitidos, duplicidad de información y relaciones entre registros inexistentes.

## 2. Restricciones NOT NULL

Se utiliza `NOT NULL` en los atributos que son indispensables para el funcionamiento del sistema.

Ejemplos:
- `cliente.nombre`: el cliente debe tener nombre.
- `cliente.correo`: es necesario para identificar y contactar al cliente.
- `empleado.numeroEmpleado`: cada empleado debe tener un número asignado.
- `vehiculo.VIN`: todo vehículo debe contar con un identificador vehicular.
- `venta.idCliente`: toda venta debe estar asociada a un cliente.
- `renta.idVehiculo`: toda renta debe identificar el vehículo correspondiente.

Los atributos opcionales, como `apellidoMaterno`, `fechaHoraDevReal` y `observaciones`, permiten valores NULL.

## 3. Restricciones DEFAULT

Se utilizan valores predeterminados cuando existe un valor inicial natural para el atributo.

| Tabla | Columna | Valor predeterminado | Justificación |
|---|---|---|---|
| vehiculo | kilometraje | 0 | Un vehículo nuevo puede comenzar con cero kilómetros. |
| vehiculo | estadoInventario | 'Disponible' | Un vehículo registrado se considera disponible inicialmente. |
| venta | fecha | CURRENT_DATE | Registra la fecha actual si no se proporciona otra. |
| renta | estado | 'Reservada' | Una renta comienza en estado de reserva. |

## 4. Restricciones UNIQUE

| Tabla | Columnas | Regla de negocio |
|---|---|---|
| cliente | correo | Un correo no puede pertenecer a dos clientes. |
| empleado | correo | Cada empleado debe tener un correo único. |
| empleado | numeroEmpleado | El número de empleado no se puede repetir. |
| vehiculo | VIN | Cada vehículo tiene un VIN único. |
| detalleVenta | idVehiculo | Un vehículo no puede aparecer en más de un detalle de venta. |
| inspeccionRenta | idRenta, tipo | Una renta solo puede tener una inspección de cada tipo. |

También existen claves primarias simples y compuestas que garantizan la identificación única de los registros.

## 5. Restricciones CHECK

| Tabla | Restricción | Regla aplicada |
|---|---|---|
| cliente | ck_cliente_cp | El código postal debe contener cinco dígitos. |
| vehiculo | ck_vehiculo_anio | El año debe estar entre 1980 y 2100. |
| vehiculo | ck_vehiculo_km | El kilometraje no puede ser negativo. |
| vehiculo | ck_vehiculo_estado | El estado debe ser Disponible, Vendido o Fuera de servicio. |
| vehiculoVenta | ck_vehiculoventa_precio | El precio de venta debe ser mayor que cero. |
| vehiculoVenta | ck_vehiculoventa_condicion | La condición debe ser Nuevo o Usado. |
| vehiculoRenta | ck_vehiculorenta_tarifa | La tarifa diaria debe ser mayor que cero. |
| venta | ck_venta_importe | El importe total no puede ser negativo. |
| detalleVenta | ck_detalleventa_linea | El número de línea debe ser mayor que cero. |
| detalleVenta | ck_detalleventa_precio | El precio aplicado no puede ser negativo. |
| renta | ck_renta_periodo | La devolución prevista debe ser posterior al inicio. |
| renta | ck_renta_devreal | La devolución real no puede ser anterior al inicio. |
| renta | ck_renta_tarifa | La tarifa aplicada debe ser mayor que cero. |
| renta | ck_renta_importe | El importe total no puede ser negativo. |
| renta | ck_renta_estado | El estado debe pertenecer a los valores permitidos. |
| inspeccionRenta | ck_inspeccionrenta_comb | El nivel de combustible debe estar entre 0 y 100. |
| inspeccionRenta | ck_inspeccionrenta_km | El kilometraje no puede ser negativo. |
| inspeccionRenta | ck_inspeccionrenta_tipo | El tipo debe ser Entrega o Devolución. |

## 6. Restricciones FOREIGN KEY

Las claves foráneas mantienen la integridad referencial entre las entidades.

Se utilizan, entre otras, las siguientes relaciones:

- Venta referencia al cliente y al empleado que la realizaron.
- DetalleVenta referencia a una venta y a un vehículo destinado a la venta.
- Renta referencia al cliente, empleado y vehículo rentado.
- InspeccionRenta referencia a la renta correspondiente.
- TelefonoCliente referencia al cliente propietario del teléfono.

Las acciones `ON DELETE RESTRICT` evitan eliminar registros que todavía tienen operaciones relacionadas. `ON DELETE CASCADE` se utiliza cuando los registros dependientes no deben permanecer sin su entidad principal.

## 7. Restricción de exclusión

La tabla `renta` utiliza la restricción `ex_renta_sin_traslape`.

Esta restricción impide que un mismo vehículo tenga dos rentas con periodos superpuestos cuando ambas se encuentran en estado Reservada o Activa.

De esta manera se evita asignar simultáneamente el mismo vehículo a diferentes clientes.

## 8. Conclusión

Las restricciones implementadas protegen la integridad de los datos de la concesionaria y representan reglas reales del negocio. Se utilizan restricciones de nulidad, valores predeterminados, unicidad, validaciones de dominio, claves primarias, claves foráneas y exclusión de periodos.