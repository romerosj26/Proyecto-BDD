Se realizó una copia independiente de la base de datos ProyectoBDD, denominada ProyectoBDD_Individual, para evaluar el comportamiento de las acciones referenciales sin modificar la información original.

Se seleccionó la relación entre las tablas cliente y renta, cuya clave foránea fk_renta_cliente tenía inicialmente la acción ON DELETE RESTRICT. Posteriormente, se modificó a ON DELETE CASCADE.

Para comprobar su funcionamiento, se eliminó al cliente Ana López (idcliente = 1), quien tenía una renta y un teléfono registrados. La eliminación se realizó correctamente y provocó también la eliminación de su renta. Debido a que la inspección depende de la renta mediante otra clave foránea con ON DELETE CASCADE, también fue eliminada. El teléfono desapareció por la acción CASCADE definida en su propia relación con cliente.

Finalmente, se verificó que la base original ProyectoBDD permaneció intacta, conservando al cliente y sus registros relacionados.

Se concluye que ON DELETE CASCADE puede provocar pérdidas de información en cadena. Para este proyecto se considera más apropiado conservar ON DELETE RESTRICT en la relación cliente-renta, ya que las rentas representan operaciones comerciales cuyo historial debe preservarse.

-ROMERO SAYUN JONATHAN
-2025630298