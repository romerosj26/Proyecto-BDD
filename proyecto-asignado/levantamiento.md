Levantamiento del proyecto
1. Requisitos del entorno
Para ejecutar el proyecto localmente se requieren los siguientes componentes:

Sistema operativo: Windows.

Git: para clonar el repositorio y consultar su historial.

Docker Desktop: para ejecutar el contenedor de PsotgreSQL

Docker Compose: para construir y levantar los servicios definidos en warehouse/compose.yml.

Visual Studio Code: para inspeccionar el código fuente y ejecutar la interfaz web mediante Live Server.

Navegador web: para visualizar la interfaz local.

PostgreSQL 16: se ejecuta dentro del contenedor Docker, por lo que no es necesario instalar el servidor de PostgreSQL directamente en Windows.

Configuración de la base de datos

Base de datos: data_warehouse.

Usuario: postgres.

Puerto publicado en el equipo anfitrión: 5433.

Puerto de PostgreSQL dentro del contenedor: 5432.

Contenedor: data_warehouse_cdmx.

La configuración anterior corresponde al entorno de desarrollo proporcionado por el proyecto.

## 2. Clonación del repositorio

Se realizó un fork del repositorio original en GitHub y se clonó en una carpeta independiente del repositorio del equipo.

- **Repositorio original:** https://github.com/gabrielhuav/Data_Warehouse_static
- **Fork personal:**  https://github.com/EMMAUELMG15/Data_Warehouse_static

Comandos utilizados en PowerShell:

```powershell
cd Proyecto-Asignado
git clone  https://github.com/EMMAUELMG15/Data_Warehouse_static
cd Data_Warehouse_static
git status
```

La clonación finalizó correctamente y Git indicó que la rama local `main` estaba sincronizada con `origin/main`, sin cambios pendientes.

## 3. Construcción y arranque de la base de datos

Desde la raíz del repositorio, se accedió a la carpeta `warehouse` y se construyó e inició el contenedor:

```powershell
cd warehouse
docker compose up -d --build
```

El primer intento falló porque Docker no podía conectarse al motor de Docker Desktop. El mensaje indicaba que no se encontraba la tubería de comunicación `dockerDesktopLinuxEngine`.

### Solución del problema

Se abrió Docker Desktop y se verificó que el motor estuviera disponible mediante:

```powershell
docker info
```

Después de confirmar que el servidor de Docker respondía y al abrir la aplicación de Docker Desktop donde verificamos que no tuvieramos un mensaje de error, se repitió el comando de construcción y arranque. La imagen se construyó y el contenedor `data_warehouse_cdmx` inició correctamente.

## 4. Verificación de la base de datos

Se consultaron los registros del contenedor para comprobar que PostgreSQL inicializara el esquema, importara los datos y ejecutara los scripts SQL.

Comando utilizado:

```powershell
docker logs data_warehouse_cdmx
```

Los registros mostraron la creación de tablas, la carga de datos desde archivos CSV y la inserción de 70,886 registros en la tabla `fact_consumo_agua`.


## 5. Conexión y consultas SQL desde la terminal

Con el contenedor en ejecución, se estableció una conexión directa con PostgreSQL mediante `psql`, sin utilizar una interfaz gráfica de administración de bases de datos.

Comando de conexión:

```powershell
docker exec -it data_warehouse_cdmx psql -U postgres -d data_warehouse
```

Una vez dentro de la terminal de PostgreSQL, se listaron las tablas disponibles mediante:

```sql
\dt
```

Posteriormente, se ejecutó una consulta para comprobar el número de registros de la tabla de hechos:

```sql
SELECT COUNT(*) FROM fact_consumo_agua;
```

**Resultado obtenido:** 70,886 registros.

Finalmente, se consultaron cinco registros para verificar la estructura y los datos de la tabla:

```sql
SELECT * FROM fact_consumo_agua LIMIT 5;
```

La consulta mostró las columnas de la tabla, entre ellas `id_fact`, `id_tiempo`, `id_ubicacion`, `id_indice_des` y las columnas relacionadas con el consumo de agua.

Para finalizar la sesión interactiva de PostgreSQL se utilizó:

```sql
\q
```

Estas pruebas confirmaron que fue posible conectarse directamente a la base de datos, consultar sus tablas y recuperar información almacenada.

## 6. Ejecución y verificación de la interfaz web

Se utilizó Visual Studio Code con la extensión Live Server para ejecutar la interfaz web localmente.

Procedimiento:

1. Abrir el repositorio clonado `Data_Warehouse_static` en Visual Studio Code.
2. Localizar el archivo HTML correspondiente a la interfaz que se desea ejecutar.
3. Iniciar Live Server desde Visual Studio Code.
4. Abrir la página en el navegador y comprobar su funcionamiento.

Durante la verificación se abrió la página `vecindad.html` en la siguiente dirección local:

http://127.0.0.1:5500/index.html

7. Errores encontrados y soluciones

7.1. Docker Desktop no estaba iniciado

Problema: Durante el primer intento de ejecutar docker compose up -d --build, Docker no pudo establecer comunicación con el motor de Docker Desktop. El mensaje de error hacía referencia a la tubería dockerDesktopLinuxEngine.

Solución: Se inició Docker Desktop y se verificó la disponibilidad del motor mediante docker info. Después se volvió a ejecutar el comando de construcción y arranque.

Resultado: La imagen se construyó y el contenedor data_warehouse_cdmx inició correctamente.

7.2. Advertencia durante la inicialización de PostgreSQL

Durante la inicialización apareció un aviso relacionado con la inexistencia previa de una tabla que se intentaba eliminar. Los scripts continuaron ejecutándose y PostgreSQL quedó listo para aceptar conexiones.

Resultado: La advertencia no impidió la inicialización de la base de datos ni la carga de los datos.

8. Observaciones finales

La base de datos PostgreSQL se ejecutó correctamente dentro de un contenedor Docker. Fue posible establecer una conexión directa mediante psql, consultar las tablas disponibles y recuperar registros de la tabla fact_consumo_agua.

La interfaz web también se ejecutó localmente mediante Visual Studio Code y Live Server. Durante la inspección se identificó que la página utiliza archivos de datos estáticos, como consumo.json y kg_demo.ttl. Por lo tanto, no se afirma que la interfaz consulte directamente PostgreSQL en tiempo real.

Con las pruebas realizadas se verificó el funcionamiento local de la base de datos y de la interfaz web, así como la ejecución de consultas SQL desde la terminal.