# 1.5. Pruebas de restricciones

## Objetivo

Comprobar el funcionamiento de las restricciones implementadas en la base de datos de la concesionaria, mediante operaciones de inserción que intentan introducir información inválida o duplicada.

Las pruebas se ejecutaron en PostgreSQL 16 dentro de una transacción que finalizó con `ROLLBACK`, evitando conservar los registros auxiliares.

## Resultados

| N.º | Restricción | Operación intentada | Resultado esperado | Resultado obtenido |
|---:|---|---|---|---|
| 1 | NOT NULL | Insertar cliente sin nombre | Rechazar NULL | SQLSTATE 23502. Rechazado correctamente. |
| 2 | DEFAULT | Insertar vehículo sin kilometraje ni estado | Asignar 0 y Disponible | Valores predeterminados aplicados correctamente. |
| 3 | UNIQUE simple | Repetir correo de cliente | Rechazar duplicado | SQLSTATE 23505. Restricción uq_cliente_correo. |
| 4 | PRIMARY KEY compuesta | Repetir idcliente y teléfono | Rechazar duplicado | SQLSTATE 23505. Restricción pk_telefonocliente. |
| 5 | CHECK de rango | Registrar vehículo con año 2200 | Rechazar año fuera de rango | SQLSTATE 23514. Restricción ck_vehiculo_anio. |
| 6 | CHECK de formato | Registrar código postal ABC | Rechazar formato incorrecto | SQLSTATE 23514. Restricción ck_cliente_cp. |
| 7 | CHECK entre columnas | Registrar devolución anterior al inicio | Rechazar fechas inconsistentes | SQLSTATE 23514. Restricción ck_renta_devreal. |
| 8 | FOREIGN KEY | Registrar venta con cliente inexistente | Rechazar referencia inválida | SQLSTATE 23503. Restricción fk_venta_cliente. |
| 9 | UNIQUE compuesto | Repetir tipo de inspección para una renta | Rechazar duplicado | SQLSTATE 23505. Restricción uq_inspeccionrenta_tipo. |
| 10 | EXCLUSION | Registrar dos rentas traslapadas para el mismo vehículo | Rechazar traslape | SQLSTATE 23P01. Restricción ex_renta_sin_traslape. |

## Análisis de resultados

Las diez pruebas produjeron los resultados esperados.

Se verificó que las restricciones NOT NULL, UNIQUE, PRIMARY KEY, CHECK, FOREIGN KEY y EXCLUSION impiden operaciones que podrían comprometer la integridad de los datos.

También se comprobó que los valores DEFAULT permiten asignar automáticamente valores iniciales cuando no se especifican durante una inserción.

La restricción de exclusión resultó especialmente importante para el proyecto, ya que evita que un mismo vehículo tenga dos rentas activas o reservadas cuyos periodos se traslapen.

## Conclusión

Las pruebas confirmaron que las restricciones de integridad de la base de datos funcionan correctamente. PostgreSQL rechazó las operaciones inválidas mediante los códigos SQLSTATE correspondientes y aplicó los valores predeterminados esperados.

La transacción terminó con ROLLBACK, por lo que los datos utilizados exclusivamente para las pruebas no quedaron almacenados en la base de datos.