# 1.1. Tipos de dato y dominios

## 1. Objetivo

El objetivo de este apartado es justificar la selección de los tipos de datos utilizados en el diseño de la base de datos de una concesionaria dedicada a la venta y renta de automóviles.

La selección considera la naturaleza de cada atributo, el rango de valores que puede almacenar, la precisión requerida y las restricciones necesarias para mantener la integridad de la información.

Se priorizaron los siguientes criterios:

- Evitar el uso de tipos de punto flotante para almacenar cantidades monetarias.
- Utilizar identificadores enteros con generación automática.
- Diferenciar fechas que requieren hora de aquellas que solamente necesitan día, mes y año.
- Establecer longitudes razonables para los textos.
- Utilizar tipos de longitud fija cuando el formato del dato lo requiere.
- Definir dominios reutilizables para atributos que comparten reglas de validación.

## 2. Tipos de datos utilizados

### 2.1. Tabla cliente

Almacena la información personal y de contacto de los clientes de la concesionaria.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idCliente | INT GENERATED ALWAYS AS IDENTITY | 32 bits | Identificador numérico generado automáticamente para cada cliente. |
| nombre | VARCHAR(60) | 60 caracteres | Permite almacenar nombres de diferentes longitudes. |
| apellidoPaterno | VARCHAR(60) | 60 caracteres | Almacena el apellido paterno del cliente. |
| apellidoMaterno | VARCHAR(60) | 60 caracteres | Permite almacenar el segundo apellido; admite valores NULL. |
| correo | VARCHAR(100) | 100 caracteres | Permite almacenar direcciones de correo electrónico de longitud variable. |
| calle | VARCHAR(80) | 80 caracteres | Almacena el nombre de la calle del domicilio. |
| numero | VARCHAR(10) | 10 caracteres | Se utiliza texto porque los números de domicilio pueden incluir letras o caracteres adicionales. |
| colonia | VARCHAR(60) | 60 caracteres | Almacena el nombre de la colonia. |
| codigoPostal | CHAR(5) | 5 caracteres | Se utiliza longitud fija porque el código postal mexicano tiene cinco dígitos y puede comenzar con cero. |

### 2.2. Tabla empleado

Almacena la información de los trabajadores que participan en las operaciones de venta y renta.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idEmpleado | INT GENERATED ALWAYS AS IDENTITY | 32 bits | Identificador generado automáticamente para cada empleado. |
| numeroEmpleado | VARCHAR(20) | 20 caracteres | Permite almacenar un número de empleado que podría contener letras o números. |
| nombre | VARCHAR(60) | 60 caracteres | Almacena el nombre del empleado. |
| apellidoPaterno | VARCHAR(60) | 60 caracteres | Almacena el apellido paterno. |
| apellidoMaterno | VARCHAR(60) | 60 caracteres | Almacena el apellido materno; admite NULL. |
| telefono | VARCHAR(15) | 15 caracteres | Se utiliza texto porque los teléfonos pueden contener prefijos y no se realizan operaciones aritméticas con ellos. |
| correo | VARCHAR(100) | 100 caracteres | Permite almacenar el correo electrónico del empleado. |

### 2.3. Tabla vehiculo

Contiene la información general de los automóviles registrados en la concesionaria.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVehiculo | INT GENERATED ALWAYS AS IDENTITY | 32 bits | Identificador interno generado automáticamente. |
| VIN | CHAR(17) | 17 caracteres | El número de identificación vehicular tiene una longitud estandarizada de 17 caracteres. |
| marca | VARCHAR(40) | 40 caracteres | Almacena el nombre de la marca del automóvil. |
| modelo | VARCHAR(40) | 40 caracteres | Almacena el modelo del automóvil. |
| anio | SMALLINT | 16 bits | Es suficiente para almacenar años de fabricación dentro del rango establecido. |
| color | VARCHAR(30) | 30 caracteres | Almacena el color del vehículo. |
| kilometraje | INT | 32 bits | Permite almacenar distancias recorridas como cantidades enteras. Su valor predeterminado es 0. |
| estadoInventario | VARCHAR(20) | 20 caracteres | Almacena el estado actual del vehículo dentro del inventario. Tiene el valor predeterminado 'Disponible'. |

### 2.4. Tabla telefonoCliente

Representa los números telefónicos asociados a cada cliente. Se utiliza para resolver el atributo multivaluado de los teléfonos.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idCliente | INT | 32 bits | Identificador del cliente al que pertenece el teléfono. Funciona como clave foránea. |
| telefono | VARCHAR(15) | 15 caracteres | Almacena números telefónicos con longitud variable, incluyendo posibles prefijos. |

La clave primaria está compuesta por `idCliente` y `telefono`, permitiendo registrar varios teléfonos para un mismo cliente sin repetir el mismo número para ese cliente.

### 2.5. Tabla vehiculoVenta

Almacena los atributos particulares de los vehículos destinados a la venta.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVehiculo | INT | 32 bits | Identificador del vehículo. Funciona como clave primaria y foránea respecto a `vehiculo`. |
| precioVenta | DECIMAL(12,2) | 12 dígitos, 2 decimales | Representa el precio de venta con precisión decimal exacta, evitando errores de punto flotante. |
| condicion | VARCHAR(10) | 10 caracteres | Almacena la condición del automóvil, como 'Nuevo' o 'Usado'. |

### 2.6. Tabla vehiculoRenta

Contiene los atributos específicos de los vehículos disponibles para renta.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVehiculo | INT | 32 bits | Identificador del vehículo y clave foránea respecto a `vehiculo`. |
| tarifaDiaria | DECIMAL(10,2) | 10 dígitos, 2 decimales | Almacena el costo diario de renta con precisión monetaria exacta. |
| categoria | VARCHAR(30) | 30 caracteres | Permite clasificar el vehículo según su categoría. |

### 2.7. Tabla venta

Registra las operaciones de venta realizadas por la concesionaria.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVenta | INT GENERATED ALWAYS AS IDENTITY | 32 bits | Identificador único generado automáticamente para cada venta. |
| idCliente | INT | 32 bits | Identifica al cliente que realiza la compra. Es clave foránea. |
| idEmpleado | INT | 32 bits | Identifica al empleado que atiende la operación. Es clave foránea. |
| fecha | DATE | Día, mes y año | Almacena la fecha de la venta. No requiere hora específica. Tiene como valor predeterminado la fecha actual. |
| importeTotal | DECIMAL(12,2) | 12 dígitos, 2 decimales | Almacena el importe total de la venta con precisión decimal exacta. |

### 2.8. Tabla detalleVenta

Almacena los vehículos y precios asociados a cada operación de venta. Es una entidad débil identificada mediante la clave de la venta y el número de línea.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idVenta | INT | 32 bits | Identifica la venta a la que pertenece el detalle. Es clave foránea y parte de la clave primaria. |
| numLinea | SMALLINT | 16 bits | Identifica el número de línea dentro de una venta. Se utiliza un entero pequeño porque la cantidad de líneas es limitada. |
| idVehiculo | INT | 32 bits | Identifica el vehículo vendido y funciona como clave foránea. |
| precioAplicado | DECIMAL(12,2) | 12 dígitos, 2 decimales | Almacena el precio aplicado al vehículo durante la venta, utilizando precisión decimal exacta. |

La clave primaria compuesta por `idVenta` y `numLinea` permite identificar cada detalle dentro de una venta.

### 2.9. Tabla renta

Registra las operaciones de alquiler de vehículos, incluyendo fechas, tarifas, importes y estado de la renta.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idRenta | INT GENERATED ALWAYS AS IDENTITY | 32 bits | Identificador único generado automáticamente para cada renta. |
| idCliente | INT | 32 bits | Identifica al cliente que solicita el vehículo. Es clave foránea. |
| idEmpleado | INT | 32 bits | Identifica al empleado responsable de gestionar la renta. Es clave foránea. |
| idVehiculo | INT | 32 bits | Identifica el vehículo que se renta. Es clave foránea. |
| fechaHoraInicio | TIMESTAMP | Fecha y hora | Registra el momento exacto en que inicia la renta. |
| fechaHoraDevPrevista | TIMESTAMP | Fecha y hora | Registra el momento previsto para devolver el vehículo. |
| fechaHoraDevReal | TIMESTAMP | Fecha y hora | Registra el momento real de devolución. Admite NULL mientras el vehículo no haya sido devuelto. |
| tarifaAplicada | DECIMAL(10,2) | 10 dígitos, 2 decimales | Almacena la tarifa aplicada a la renta con precisión decimal exacta. |
| importeTotal | DECIMAL(12,2) | 12 dígitos, 2 decimales | Almacena el importe total de la renta. |
| estado | VARCHAR(20) | 20 caracteres | Almacena el estado de la operación. Su valor predeterminado es 'Reservada'. |

Se utiliza `TIMESTAMP` en lugar de `DATE` porque las rentas requieren controlar tanto el día como la hora de inicio y devolución. Esto permite calcular periodos y evitar traslapes entre reservaciones.

### 2.10. Tabla inspeccionRenta

Registra las inspecciones que se realizan al entregar y recibir un vehículo rentado.

| Columna | Tipo de dato | Longitud / precisión | Justificación |
|---|---|---|---|
| idInspeccion | INT GENERATED ALWAYS AS IDENTITY | 32 bits | Identificador único generado automáticamente para cada inspección. |
| idRenta | INT | 32 bits | Identifica la renta a la que pertenece la inspección. Es clave foránea. |
| tipo | VARCHAR(10) | 10 caracteres | Identifica si la inspección corresponde a la entrega o devolución del vehículo. |
| fechaHora | TIMESTAMP | Fecha y hora | Registra el momento exacto en que se realiza la inspección. |
| kilometraje | INT | 32 bits | Almacena el kilometraje registrado durante la inspección. |
| nivelCombustible | SMALLINT | 16 bits | Almacena el nivel de combustible como porcentaje entero de 0 a 100. |
| observaciones | TEXT | Longitud variable | Permite registrar comentarios de longitud variable sobre el estado del vehículo. |

## 3. Justificación de decisiones generales

### 3.1. Identificadores

Se utilizó `INT GENERATED ALWAYS AS IDENTITY` para los identificadores principales de las entidades que generan registros independientes.

Este mecanismo permite que PostgreSQL genere automáticamente valores únicos, evitando que el usuario tenga que proporcionar manualmente cada identificador.

En las tablas relacionadas se utiliza `INT` para almacenar las claves foráneas, manteniendo compatibilidad con los identificadores de las tablas principales.

### 3.2. Cantidades monetarias

Se utilizaron los tipos `DECIMAL(12,2)` y `DECIMAL(10,2)` para los precios, tarifas e importes.

Se eligieron estos tipos porque permiten representar cantidades monetarias con precisión decimal exacta.

No se utilizaron `FLOAT` ni `REAL`, ya que son tipos de punto flotante y pueden producir aproximaciones en operaciones aritméticas. Esto podría ocasionar diferencias no deseadas en cálculos de precios, tarifas o importes.

### 3.3. Fechas y horas

Se utilizaron dos tipos principales:

- `DATE`: para registrar fechas que no requieren información de hora, como la fecha de una venta.
- `TIMESTAMP`: para registrar eventos que requieren precisión temporal, como el inicio y la devolución de una renta, así como las inspecciones.

### 3.4. Textos de longitud fija y variable

Se utilizaron:

- `CHAR(5)` para los códigos postales, porque tienen una longitud fija de cinco caracteres.
- `CHAR(17)` para el VIN, porque tiene una longitud estandarizada de 17 caracteres.
- `VARCHAR(n)` para nombres, apellidos, correos, teléfonos, direcciones y categorías, porque su longitud puede variar.
- `TEXT` para observaciones, ya que no se requiere establecer un límite pequeño y fijo.

Los códigos postales y teléfonos se almacenan como texto, no como números, porque no se realizan operaciones aritméticas con ellos y pueden contener ceros iniciales o caracteres especiales.

### 3.5. Tipos enteros

Se utilizaron `SMALLINT` e `INT` para atributos numéricos enteros:

- `SMALLINT` para años, números de línea y niveles de combustible.
- `INT` para identificadores, kilometrajes y cantidades que pueden requerir un rango mayor.

La elección considera el rango de valores que puede necesitar cada atributo.

## 4. Creación de dominios reutilizables

PostgreSQL permite crear dominios mediante `CREATE DOMAIN`. Un dominio es un tipo de dato definido por el usuario que se construye a partir de un tipo existente y puede incluir restricciones adicionales.

Se definieron los siguientes dominios para representar reglas que pueden reutilizarse en diferentes partes del sistema.

### 4.1. Dominio codigo_postal_mx

```sql
CREATE DOMAIN codigo_postal_mx AS CHAR(5)
CHECK (VALUE ~ '^[0-9]{5}$');
```

Representa códigos postales mexicanos de cinco dígitos.

Su restricción impide almacenar valores con letras o con una cantidad diferente de cinco dígitos.

### 4.2. Dominio vin_vehicular

```sql
CREATE DOMAIN vin_vehicular AS CHAR(17)
CHECK (VALUE ~ '^[A-HJ-NPR-Z0-9]{17}$');
```

Representa números de identificación vehicular de 17 caracteres, excluyendo las letras I, O y Q, que no se utilizan en el VIN estándar.

### 4.3. Dominio telefono

```sql
CREATE DOMAIN telefono AS VARCHAR(15)
CHECK (VALUE ~ '^[0-9+() -]{7,15}$');
```

Permite almacenar números telefónicos con dígitos y algunos caracteres de formato, como espacios, paréntesis, guiones y el signo más.

### 4.4. Dominio importe_monetario

```sql
CREATE DOMAIN importe_monetario AS DECIMAL(12,2)
CHECK (VALUE >= 0);
```

Representa cantidades monetarias no negativas con dos posiciones decimales.

Se puede utilizar en precios, importes y otros valores económicos del sistema.

### 4.5. Dominio tarifa_positiva

```sql
CREATE DOMAIN tarifa_positiva AS DECIMAL(10,2)
CHECK (VALUE > 0);
```

Representa tarifas monetarias estrictamente positivas, como las tarifas diarias de renta.

## 5. Ventajas de utilizar dominios

La creación de dominios permite centralizar reglas de validación que se repiten en diferentes atributos de una base de datos.

Entre sus principales ventajas se encuentran:

1. **Reutilización:** un mismo dominio puede utilizarse en varias columnas y tablas.
2. **Consistencia:** los atributos que utilizan un mismo dominio comparten las mismas reglas de validación.
3. **Mantenimiento:** si una regla debe modificarse, puede actualizarse desde la definición del dominio.
4. **Legibilidad:** los nombres de los dominios permiten identificar la finalidad de los datos.
5. **Integridad:** PostgreSQL valida automáticamente los valores que se intentan almacenar en columnas que utilizan esos dominios.

### 5.1. Estado de implementación

Los cinco dominios anteriores fueron creados en PostgreSQL. Sin embargo, en la versión actual del esquema original, las columnas todavía utilizan sus tipos base (`CHAR`, `VARCHAR` y `DECIMAL`) y sus restricciones individuales.

Por lo tanto, los dominios están definidos y disponibles para su reutilización, pero todavía no están asociados directamente a las columnas originales.

## 6. Conclusión

La selección de tipos de datos se realizó considerando la naturaleza de la información que administra una concesionaria de vehículos.

Se utilizaron tipos enteros para identificadores y cantidades, tipos decimales para valores monetarios, tipos temporales para fechas y horas, y tipos de caracteres para información textual.

Además, se definieron cinco dominios reutilizables en PostgreSQL para establecer reglas comunes de validación.

Estas decisiones permiten construir una estructura de datos más consistente, reducir errores de almacenamiento y facilitar el mantenimiento de la base de datos.
