# 1.6. Implementación de roles y permisos

## 1. Objetivo

Implementar un esquema de control de acceso en PostgreSQL mediante roles grupales y usuarios individuales, aplicando el principio de mínimo privilegio.

Se definieron tres perfiles:

- **Aplicación:** permite cargar y consultar información del catálogo de vehículos.
- **Consulta:** permite consultar la información de la base de datos sin modificarla.
- **Administración:** permite realizar operaciones de administración de datos y crear objetos dentro del esquema `public`.

El usuario `postgres` se conserva como administrador técnico de PostgreSQL.

## 2. Creación de roles y usuarios

Se crearon tres roles grupales sin capacidad de inicio de sesión (`NOLOGIN`):

```sql
CREATE ROLE rol_aplicacion NOLOGIN;
CREATE ROLE rol_consulta NOLOGIN;
CREATE ROLE rol_administracion NOLOGIN;
```

Posteriormente, se crearon los usuarios individuales:

```sql
CREATE USER usr_consulta LOGIN;
CREATE USER usr_admin LOGIN;
```

El usuario `app_carga` ya existía y se reutilizó para el perfil de aplicación.

Se asignó cada usuario a su respectivo rol:

```sql
GRANT rol_aplicacion TO app_carga;
GRANT rol_consulta TO usr_consulta;
GRANT rol_administracion TO usr_admin;
```

Finalmente, se concedió permiso de conexión a la base de datos `ProyectoBDD`:

```sql
GRANT CONNECT ON DATABASE "ProyectoBDD"
TO rol_aplicacion, rol_consulta, rol_administracion;
```

Las contraseñas de los usuarios se establecieron mediante el comando `\password` de PostgreSQL.

## 3. Asignación de privilegios

### 3.1. Rol de aplicación

El usuario `app_carga` tenía permisos directos sobre `catalogoversion`. Estos se retiraron para centralizar los privilegios en el rol grupal.

```sql
REVOKE SELECT, INSERT ON catalogoversion FROM app_carga;
REVOKE USAGE ON SEQUENCE catalogoversion_idcatalogo_seq FROM app_carga;
```

Se asignaron los permisos al rol:

```sql
GRANT USAGE ON SCHEMA public TO rol_aplicacion;

GRANT SELECT, INSERT
ON catalogoversion
TO rol_aplicacion;

GRANT USAGE
ON SEQUENCE catalogoversion_idcatalogo_seq
TO rol_aplicacion;
```

De esta manera, la aplicación puede consultar e insertar registros en el catálogo, pero no puede modificarlos ni eliminarlos.

### 3.2. Rol de consulta

Se concedieron permisos de lectura sobre todas las tablas y secuencias existentes en el esquema `public`.

```sql
GRANT USAGE ON SCHEMA public TO rol_consulta;

GRANT SELECT
ON ALL TABLES IN SCHEMA public
TO rol_consulta;

GRANT SELECT
ON ALL SEQUENCES IN SCHEMA public
TO rol_consulta;
```

Este perfil permite consultar información sin modificar los registros.

### 3.3. Rol de administración

Se concedieron privilegios sobre las tablas y secuencias existentes, además de permisos para utilizar y crear objetos dentro del esquema `public`.

```sql
GRANT USAGE, CREATE ON SCHEMA public
TO rol_administracion;

GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO rol_administracion;

GRANT ALL PRIVILEGES
ON ALL SEQUENCES IN SCHEMA public
TO rol_administracion;
```

Este rol permite administrar los datos de las tablas y realizar operaciones sobre las secuencias. También puede crear objetos dentro del esquema.

**Nota:** estos privilegios no convierten a `usr_admin` en superusuario ni propietario de todas las tablas. Por ello, no obtiene automáticamente permisos para ejecutar operaciones como `ALTER TABLE` o `DROP TABLE` sobre objetos de los que no es propietario.

## 4. Verificación de roles y usuarios

Se utilizó el siguiente comando para comprobar los roles existentes:

```sql
\du
```

El resultado confirmó la existencia de:

- `app_carga`
- `usr_consulta`
- `usr_admin`
- `rol_aplicacion`
- `rol_consulta`
- `rol_administracion`
- `postgres`

También se verificó la pertenencia de los usuarios a sus roles grupales:

```sql
SELECT
    r.rolname AS rol,
    m.rolname AS usuario
FROM pg_auth_members am
JOIN pg_roles r ON r.oid = am.roleid
JOIN pg_roles m ON m.oid = am.member
WHERE r.rolname IN (
    'rol_aplicacion',
    'rol_consulta',
    'rol_administracion'
)
ORDER BY r.rolname;
```

Resultado:

| Rol | Usuario |
|---|---|
| rol_administracion | usr_admin |
| rol_aplicacion | app_carga |
| rol_consulta | usr_consulta |

## 5. Pruebas de permisos

Las pruebas se realizaron mediante `SET ROLE` y `RESET ROLE`, simulando las operaciones de cada usuario desde la sesión administrativa.

### 5.1. Pruebas del perfil de aplicación

```sql
SET ROLE app_carga;

SELECT COUNT(*) FROM catalogoversion;

UPDATE catalogoversion
SET precioReferencia = precioReferencia
WHERE idCatalogo = 1;

SELECT * FROM cliente;

RESET ROLE;
```

Resultados:

| Operación | Resultado |
|---|---|
| Consultar `catalogoversion` | Permitida: 1127 registros |
| Actualizar `catalogoversion` | Denegada |
| Consultar `cliente` | Denegada |

Los errores de permisos confirmaron que el usuario únicamente tiene acceso al catálogo y no puede modificar sus registros.

### 5.2. Pruebas del perfil de consulta

```sql
SET ROLE usr_consulta;

SELECT COUNT(*) FROM cliente;
SELECT COUNT(*) FROM vehiculo;

INSERT INTO cliente (nombre)
VALUES ('Prueba de permisos');

RESET ROLE;
```

Resultados:

| Operación | Resultado |
|---|---|
| Consultar `cliente` | Permitida |
| Consultar `vehiculo` | Permitida |
| Insertar en `cliente` | Denegada |

El usuario puede consultar las tablas, pero no puede insertar registros.

### 5.3. Pruebas del perfil de administración

Se insertó un registro temporal con todos los campos obligatorios:

```sql
SET ROLE usr_admin;

INSERT INTO cliente (
    nombre,
    apellidopaterno,
    correo,
    calle,
    numero,
    colonia,
    codigopostal
)
VALUES (
    'Prueba',
    'Administrador',
    'prueba.admin.permisos@ejemplo.com',
    'Calle de prueba',
    '123',
    'Colonia de prueba',
    '01234'
);

SELECT *
FROM cliente
WHERE correo = 'prueba.admin.permisos@ejemplo.com';

DELETE FROM cliente
WHERE correo = 'prueba.admin.permisos@ejemplo.com';

RESET ROLE;
```

Resultados:

| Operación | Resultado |
|---|---|
| Consultar `cliente` | Permitida |
| Insertar cliente temporal | Permitida |
| Eliminar cliente temporal | Permitida |

El registro se insertó correctamente (`INSERT 0 1`), se consultó y posteriormente se eliminó (`DELETE 1`). Por lo tanto, no quedó información de prueba en la tabla.

## 6. Prueba de revocación de privilegios (REVOKE)

Para comprobar que los permisos pueden retirarse, se revocó temporalmente el privilegio `SELECT` del rol de aplicación:

```sql
REVOKE SELECT
ON catalogoversion
FROM rol_aplicacion;
```

Posteriormente, se intentó consultar la tabla:

```sql
SET ROLE app_carga;

SELECT COUNT(*) FROM catalogoversion;

RESET ROLE;
```

PostgreSQL devolvió el error:

```text
ERROR: permission denied for table catalogoversion
```

Esto confirmó que la revocación fue efectiva y que el usuario heredó correctamente los permisos de su rol grupal.

### 6.1. Restauración del permiso

Para restablecer el funcionamiento de la aplicación, se concedió nuevamente el privilegio:

```sql
GRANT SELECT
ON catalogoversion
TO rol_aplicacion;
```

Se verificó el resultado:

```sql
SET ROLE app_carga;

SELECT COUNT(*) FROM catalogoversion;

RESET ROLE;
```

La consulta devolvió nuevamente **1127 registros**, confirmando que el permiso fue restaurado.

## 7. Matriz general de permisos

| Operación | Aplicación | Consulta | Administración |
|---|:---:|:---:|:---:|
| SELECT en catálogo | Sí | Sí | Sí |
| INSERT en catálogo | Sí | No | Sí |
| UPDATE en catálogo | No | No | Sí |
| DELETE en catálogo | No | No | Sí |
| SELECT en otras tablas | No | Sí | Sí |
| INSERT en otras tablas | No | No | Sí |
| UPDATE en otras tablas | No | No | Sí |
| DELETE en otras tablas | No | No | Sí |
| CREATE en esquema `public` | No | No | Sí |

La matriz representa los privilegios concedidos sobre los objetos existentes en el momento de ejecutar los comandos. No se configuraron privilegios predeterminados para objetos futuros.

## 8. Conclusión

Se implementó un esquema de control de acceso basado en roles grupales, separando las responsabilidades de aplicación, consulta y administración.

Las pruebas demostraron que PostgreSQL permite controlar las operaciones de cada usuario mediante privilegios heredados de sus respectivos roles. También se comprobó el funcionamiento de `GRANT` y `REVOKE`, verificando que los permisos pueden concederse, retirarse y restaurarse.

Con esta implementación se reduce el acceso innecesario a la información y se evita que todos los usuarios tengan privilegios administrativos sobre la base de datos.
