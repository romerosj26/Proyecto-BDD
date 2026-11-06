-- Concesionaria de venta y renta de automóviles
-- Esquema relacional (PostgreSQL)

DROP TABLE IF EXISTS detalleVenta CASCADE;
DROP TABLE IF EXISTS venta CASCADE;
DROP TABLE IF EXISTS inspeccionRenta CASCADE;
DROP TABLE IF EXISTS renta CASCADE;
DROP TABLE IF EXISTS telefonoCliente CASCADE;
DROP TABLE IF EXISTS vehiculoVenta CASCADE;
DROP TABLE IF EXISTS vehiculoRenta CASCADE;
DROP TABLE IF EXISTS vehiculo CASCADE;
DROP TABLE IF EXISTS empleado CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- Regla 1 y 2: entidades fuertes; atributos compuestos descompuestos
CREATE TABLE cliente (
    idCliente        INT           GENERATED ALWAYS AS IDENTITY,
    nombre           VARCHAR(60)   NOT NULL,
    apellidoPaterno  VARCHAR(60)   NOT NULL,
    apellidoMaterno  VARCHAR(60),
    correo           VARCHAR(100)  NOT NULL,
    calle            VARCHAR(80)   NOT NULL,
    numero           VARCHAR(10)   NOT NULL,
    colonia          VARCHAR(60)   NOT NULL,
    codigoPostal     CHAR(5)       NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (idCliente),
    CONSTRAINT uq_cliente_correo UNIQUE (correo),
    CONSTRAINT ck_cliente_cp CHECK (codigoPostal ~ '^[0-9]{5}$')
);

CREATE TABLE empleado (
    idEmpleado       INT           GENERATED ALWAYS AS IDENTITY,
    numeroEmpleado   VARCHAR(20)   NOT NULL,
    nombre           VARCHAR(60)   NOT NULL,
    apellidoPaterno  VARCHAR(60)   NOT NULL,
    apellidoMaterno  VARCHAR(60),
    telefono         VARCHAR(15)   NOT NULL,
    correo           VARCHAR(100)  NOT NULL,
    CONSTRAINT pk_empleado PRIMARY KEY (idEmpleado),
    CONSTRAINT uq_empleado_numero UNIQUE (numeroEmpleado),
    CONSTRAINT uq_empleado_correo UNIQUE (correo)
);

CREATE TABLE vehiculo (
    idVehiculo       INT           GENERATED ALWAYS AS IDENTITY,
    VIN              CHAR(17)      NOT NULL,
    marca            VARCHAR(40)   NOT NULL,
    modelo           VARCHAR(40)   NOT NULL,
    anio             SMALLINT      NOT NULL,
    color            VARCHAR(30)   NOT NULL,
    kilometraje      INT           NOT NULL DEFAULT 0,
    estadoInventario VARCHAR(20)   NOT NULL DEFAULT 'Disponible',
    CONSTRAINT pk_vehiculo PRIMARY KEY (idVehiculo),
    CONSTRAINT uq_vehiculo_vin UNIQUE (VIN),
    CONSTRAINT ck_vehiculo_anio CHECK (anio BETWEEN 1980 AND 2100),
    CONSTRAINT ck_vehiculo_km CHECK (kilometraje >= 0),
    CONSTRAINT ck_vehiculo_estado CHECK (estadoInventario IN ('Disponible','Vendido','Fuera de servicio'))
);

-- Regla 3: atributo multivaluado
CREATE TABLE telefonoCliente (
    idCliente        INT           NOT NULL,
    telefono         VARCHAR(15)   NOT NULL,
    CONSTRAINT pk_telefonocliente PRIMARY KEY (idCliente, telefono),
    CONSTRAINT fk_telefonocliente_cliente FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Regla 9, estrategia A: una tabla por subtipo, con la clave del supertipo
CREATE TABLE vehiculoVenta (
    idVehiculo       INT,
    precioVenta      DECIMAL(12,2) NOT NULL,
    condicion        VARCHAR(10)   NOT NULL,
    CONSTRAINT pk_vehiculoventa PRIMARY KEY (idVehiculo),
    CONSTRAINT fk_vehiculoventa_vehiculo FOREIGN KEY (idVehiculo)
        REFERENCES Vehiculo (idVehiculo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_vehiculoventa_precio CHECK (precioVenta > 0),
    CONSTRAINT ck_vehiculoventa_condicion CHECK (condicion IN ('Nuevo','Usado'))
);

CREATE TABLE vehiculoRenta (
    idVehiculo       INT,
    tarifaDiaria     DECIMAL(10,2) NOT NULL,
    categoria        VARCHAR(30)   NOT NULL,
    CONSTRAINT pk_vehiculorenta PRIMARY KEY (idVehiculo),
    CONSTRAINT fk_vehiculorenta_vehiculo FOREIGN KEY (idVehiculo)
        REFERENCES Vehiculo (idVehiculo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_vehiculorenta_tarifa CHECK (tarifaDiaria > 0)
);

-- Regla 4: relaciones 1:N (realiza, atiende)
CREATE TABLE venta (
    idVenta          INT           GENERATED ALWAYS AS IDENTITY,
    idCliente        INT           NOT NULL,
    idEmpleado       INT           NOT NULL,
    fecha            DATE          NOT NULL DEFAULT CURRENT_DATE,
    importeTotal     DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_venta PRIMARY KEY (idVenta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_venta_empleado FOREIGN KEY (idEmpleado)
        REFERENCES Empleado (idEmpleado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_venta_importe CHECK (importeTotal >= 0)
);

-- Regla 8: entidad débil por identificación (contiene)
CREATE TABLE detalleVenta (
    idVenta          INT           NOT NULL,
    numLinea         SMALLINT      NOT NULL,
    idVehiculo       INT           NOT NULL,
    precioAplicado   DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detalleventa PRIMARY KEY (idVenta, numLinea),
    CONSTRAINT uq_detalleventa_vehiculo UNIQUE (idVehiculo),
    CONSTRAINT fk_detalleventa_venta FOREIGN KEY (idVenta)
        REFERENCES Venta (idVenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalleventa_vehiculoventa FOREIGN KEY (idVehiculo)
        REFERENCES VehiculoVenta (idVehiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_detalleventa_linea CHECK (numLinea > 0),
    CONSTRAINT ck_detalleventa_precio CHECK (precioAplicado >= 0)
);

-- Entidad asociativa Renta (relaciones solicita, gestiona, se renta en)
CREATE TABLE renta (
    idRenta              INT           GENERATED ALWAYS AS IDENTITY,
    idCliente            INT           NOT NULL,
    idEmpleado           INT           NOT NULL,
    idVehiculo           INT           NOT NULL,
    fechaHoraInicio      TIMESTAMP     NOT NULL,
    fechaHoraDevPrevista TIMESTAMP     NOT NULL,
    fechaHoraDevReal     TIMESTAMP,
    tarifaAplicada       DECIMAL(10,2) NOT NULL,
    importeTotal         DECIMAL(12,2) NOT NULL,
    estado               VARCHAR(20)   NOT NULL DEFAULT 'Reservada',
    CONSTRAINT pk_renta PRIMARY KEY (idRenta),
    CONSTRAINT fk_renta_cliente FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_renta_empleado FOREIGN KEY (idEmpleado)
        REFERENCES Empleado (idEmpleado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_renta_vehiculorenta FOREIGN KEY (idVehiculo)
        REFERENCES VehiculoRenta (idVehiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_renta_periodo CHECK (fechaHoraDevPrevista > fechaHoraInicio),
    CONSTRAINT ck_renta_devreal CHECK (fechaHoraDevReal IS NULL OR fechaHoraDevReal >= fechaHoraInicio),
    CONSTRAINT ck_renta_tarifa CHECK (tarifaAplicada > 0),
    CONSTRAINT ck_renta_importe CHECK (importeTotal >= 0),
    CONSTRAINT ck_renta_estado CHECK (estado IN ('Reservada','Activa','Finalizada','Cancelada')),
    -- Un vehículo no puede tener dos rentas vigentes con periodos superpuestos
    CONSTRAINT ex_renta_sin_traslape EXCLUDE USING gist (
        idVehiculo WITH =,
        tsrange(fechaHoraInicio, fechaHoraDevPrevista) WITH &&
    ) WHERE (estado IN ('Reservada','Activa'))
);

-- Regla 8: entidad débil por existencia (tiene); máximo 2 inspecciones por renta
CREATE TABLE inspeccionRenta (
    idInspeccion     INT           GENERATED ALWAYS AS IDENTITY,
    idRenta          INT           NOT NULL,
    tipo             VARCHAR(10)   NOT NULL,
    fechaHora        TIMESTAMP     NOT NULL,
    kilometraje      INT           NOT NULL,
    nivelCombustible SMALLINT      NOT NULL,
    observaciones    TEXT,
    CONSTRAINT pk_inspeccionrenta PRIMARY KEY (idInspeccion),
    CONSTRAINT uq_inspeccionrenta_tipo UNIQUE (idRenta, tipo),
    CONSTRAINT fk_inspeccionrenta_renta FOREIGN KEY (idRenta)
        REFERENCES Renta (idRenta)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_inspeccionrenta_tipo CHECK (tipo IN ('Entrega','Devolución')),
    CONSTRAINT ck_inspeccionrenta_km CHECK (kilometraje >= 0),
    CONSTRAINT ck_inspeccionrenta_comb CHECK (nivelCombustible BETWEEN 0 AND 100)
);
