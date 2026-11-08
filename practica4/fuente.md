# 1.3. Fuente de datos del proyecto propio

## 1. Identificación de la fuente

- **Nombre:** Datos abiertos: precios de autos nuevos en México.
- **Publicador:** Autocifras.
- **Fecha de consulta:** 6 de noviembre de 2026.
- **Actualización indicada en el sitio:** 25 de octubre de 2026.
- **URL:** https://autocifras.com/datos/
- **Licencia:** Creative Commons Attribution 4.0 International (CC BY 4.0).
- **Formato disponible:** CSV.
- **Cantidad publicada:** 1,127 registros de precios correspondientes a 404 modelos.
- **Tamaño del archivo:** 250kb.

## 2. Descripción del conjunto de datos

El conjunto contiene información de precios de vehículos nuevos comercializados en México. Cada registro identifica una marca, modelo y versión, e incluye información relacionada con el precio y algunas características del vehículo.

Los campos publicados son:

| Campo | Descripción |
|---|---|
| marca | Fabricante del vehículo. |
| modelo | Modelo del vehículo. |
| version | Versión específica del modelo. |
| precio_mxn | Precio de lista en pesos mexicanos, con IVA. |
| rendimiento_km_l | Rendimiento combinado oficial en kilómetros por litro. |
| frenado_autonomo | Indica si cuenta con frenado autónomo; puede no estar disponible. |
| fuente | Fuente original de la información. |
| url | Dirección donde se verificó el dato. |
| fecha_verificacion | Fecha de verificación del precio. |

## 3. Correspondencia con el modelo relacional

| Campo de origen | Tabla destino | Columna destino | Tratamiento |
|---|---|---|---|
| marca | vehiculo | marca | Correspondencia directa. |
| modelo | vehiculo | modelo | Correspondencia directa. |
| precio_mxn | vehiculoVenta | precioVenta | Convertir a DECIMAL(12,2) y validar. |
| version | — | — | No existe una columna equivalente. |
| rendimiento_km_l | — | — | No existe una columna equivalente. |
| frenado_autonomo | — | — | No existe una columna equivalente. |
| fuente | — | — | Conservar como dato de procedencia. |
| url | — | — | Conservar como referencia externa. |
| fecha_verificacion | — | — | Conservar como fecha de consulta del precio. |

## 4. Limitaciones y problemas de calidad

El conjunto presenta algunas limitaciones para su incorporación directa a la base de datos:

1. Contiene precios de vehículos nuevos, por lo que no representa el mercado completo de vehículos usados.
2. No contiene VIN, identificador necesario para registrar vehículos en el modelo actual.
3. No proporciona kilometraje ni color.
4. No incluye información de clientes, empleados, ventas o rentas.
5. Los precios pueden cambiar, por lo que es necesario considerar la fecha de verificación.
6. Algunos campos pueden estar vacíos cuando la fuente original no publica la información.

Por estas razones, los datos de Autocifras se utilizarán como referencia para el catálogo de vehículos y la comparación de precios. No se insertarán directamente en las tablas definitivas sin completar y validar los atributos obligatorios.

## 5. Limpieza y transformación propuesta

Antes de utilizar los datos se realizarán las siguientes operaciones:

- Normalizar los nombres de marcas y modelos.
- Eliminar espacios innecesarios.
- Comprobar que los precios sean numéricos y mayores que cero.
- Convertir los precios a formato decimal.
- Identificar registros duplicados.
- Conservar la fecha de verificación y la procedencia de cada precio.
- Registrar los campos que no tengan correspondencia con el esquema.

## 6. Licencia y atribución

El conjunto se publica bajo licencia Creative Commons Attribution 4.0 International (CC BY 4.0). Se permite su reutilización siempre que se otorgue el crédito correspondiente.

## 7. Referencia bibliográfica

Autocifras. (2026). *Datos abiertos: precios de autos nuevos en México*. https://autocifras.com/datos/