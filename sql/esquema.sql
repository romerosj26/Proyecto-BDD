-- ============================================================================
-- Práctica 3: Esquema Relacional de la Concesionaria (PostgreSQL)
-- ============================================================================

DROP TABLE IF EXISTS detalle_venta CASCADE;
DROP TABLE IF EXISTS venta CASCADE;
DROP TABLE IF EXISTS incidencia_alquiler CASCADE;
DROP TABLE IF EXISTS renta CASCADE;
DROP TABLE IF EXISTS mantenimiento CASCADE;
DROP TABLE IF EXISTS vehiculo_venta CASCADE;
DROP TABLE IF EXISTS vehiculo_renta CASCADE;
DROP TABLE IF EXISTS vehiculo CASCADE;
DROP TABLE IF EXISTS empleado CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;

-- 1. Entidades Fuertes (Regla 1)
CREATE TABLE cliente (
    id_cliente SERIAL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    direccion TEXT,
    fecha_registro DATE DEFAULT CURRENT_DATE,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_correo UNIQUE (correo)
);

CREATE TABLE empleado (
    id_empleado SERIAL,
    numero_empleado VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    puesto VARCHAR(50) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT uq_empleado_num UNIQUE (numero_empleado),
    CONSTRAINT uq_empleado_correo UNIQUE (correo)
);

-- 2. Jerarquía de Especialización (Regla 9 - Estrategia A)
CREATE TABLE vehiculo (
    id_vehiculo SERIAL,
    vin VARCHAR(17) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio SMALLINT NOT NULL,
    color VARCHAR(30) NOT NULL,
    kilometraje INTEGER NOT NULL DEFAULT 0,
    tipo_operacion VARCHAR(10) NOT NULL,
    CONSTRAINT pk_vehiculo PRIMARY KEY (id_vehiculo),
    CONSTRAINT uq_vehiculo_vin UNIQUE (vin),
    CONSTRAINT chk_vehiculo_anio CHECK (anio >= 1990 AND anio <= 2027),
    CONSTRAINT chk_vehiculo_km CHECK (kilometraje >= 0),
    CONSTRAINT chk_vehiculo_tipo CHECK (tipo_operacion IN ('RENTA', 'VENTA'))
);

CREATE TABLE vehiculo_renta (
    id_vehiculo INTEGER,
    tarifa_diaria NUMERIC(10, 2) NOT NULL,
    deposito_garantia NUMERIC(10, 2) NOT NULL DEFAULT 3000.00,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_vehiculo_renta PRIMARY KEY (id_vehiculo),
    CONSTRAINT fk_vrenta_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES vehiculo (id_vehiculo) ON DELETE CASCADE,
    CONSTRAINT chk_vrenta_tarifa CHECK (tarifa_diaria > 0),
    CONSTRAINT chk_vrenta_deposito CHECK (deposito_garantia >= 0)
);

CREATE TABLE vehiculo_venta (
    id_vehiculo INTEGER,
    precio_lista NUMERIC(12, 2) NOT NULL,
    es_seminuevo BOOLEAN NOT NULL DEFAULT FALSE,
    vendido BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_vehiculo_venta PRIMARY KEY (id_vehiculo),
    CONSTRAINT fk_vventa_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES vehiculo (id_vehiculo) ON DELETE CASCADE,
    CONSTRAINT chk_vventa_precio CHECK (precio_lista > 0)
);

-- 3. Entidad Débil (Regla 8): Mantenimiento de Vehículos
CREATE TABLE mantenimiento (
    id_vehiculo INTEGER,
    numero_servicio INTEGER NOT NULL,
    fecha_servicio DATE NOT NULL DEFAULT CURRENT_DATE,
    tipo_mantenimiento VARCHAR(50) NOT NULL,
    costo NUMERIC(10, 2) NOT NULL,
    descripcion TEXT,
    CONSTRAINT pk_mantenimiento PRIMARY KEY (id_vehiculo, numero_servicio),
    CONSTRAINT fk_mantenimiento_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES vehiculo (id_vehiculo) ON DELETE CASCADE,
    CONSTRAINT chk_mantenimiento_costo CHECK (costo >= 0)
);

-- 4. Operación de Renta (Regla 4: 1 a N)
CREATE TABLE renta (
    id_renta SERIAL,
    id_cliente INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    id_vehiculo INTEGER NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_devolucion_prevista TIMESTAMP NOT NULL,
    fecha_devolucion_real TIMESTAMP,
    importe_total NUMERIC(10, 2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'RESERVADA',
    CONSTRAINT pk_renta PRIMARY KEY (id_renta),
    CONSTRAINT fk_renta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_renta_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado) ON DELETE RESTRICT,
    CONSTRAINT fk_renta_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES vehiculo_renta (id_vehiculo) ON DELETE RESTRICT,
    CONSTRAINT chk_renta_fechas CHECK (fecha_devolucion_prevista > fecha_inicio),
    CONSTRAINT chk_renta_estado CHECK (estado IN ('RESERVADA', 'ACTIVA', 'FINALIZADA', 'CANCELADA')),
    CONSTRAINT chk_renta_importe CHECK (importe_total >= 0)
);

-- 5. Entidad Débil (Regla 8): Incidencias en contratos de renta
CREATE TABLE incidencia_alquiler (
    id_renta INTEGER,
    consecutivo_incidencia INTEGER NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto_cargo NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    descripcion TEXT NOT NULL,
    CONSTRAINT pk_incidencia PRIMARY KEY (id_renta, consecutivo_incidencia),
    CONSTRAINT fk_incidencia_renta FOREIGN KEY (id_renta)
        REFERENCES renta (id_renta) ON DELETE CASCADE,
    CONSTRAINT chk_incidencia_monto CHECK (monto_cargo >= 0)
);

-- 6. Operación de Venta y Detalle (Regla 4 y 5)
CREATE TABLE venta (
    id_venta SERIAL,
    id_cliente INTEGER NOT NULL,
    id_empleado INTEGER NOT NULL,
    fecha_venta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto_total NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_venta PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleado (id_empleado) ON DELETE RESTRICT,
    CONSTRAINT chk_venta_monto CHECK (monto_total >= 0)
);

CREATE TABLE detalle_venta (
    id_venta INTEGER,
    id_vehiculo INTEGER,
    precio_venta_final NUMERIC(12, 2) NOT NULL,
    CONSTRAINT pk_detalle_venta PRIMARY KEY (id_venta, id_vehiculo),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta)
        REFERENCES venta (id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_vehiculo FOREIGN KEY (id_vehiculo)
        REFERENCES vehiculo_venta (id_vehiculo) ON DELETE RESTRICT,
    CONSTRAINT uq_detalle_vehiculo UNIQUE (id_vehiculo),
    CONSTRAINT chk_detalle_precio CHECK (precio_venta_final > 0)
);
