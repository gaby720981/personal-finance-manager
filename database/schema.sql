-- =================================
-- TABLA: USUARIOS
-- =================================
-- Identidad principal: email + contraseña.
-- El teléfono es opcional y solo se usa para WhatsApp una vez verificado.

CREATE TABLE usuarios (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(16),
    telefono_verificado_at TIMESTAMP,
    dias_anticipacion_aviso SMALLINT NOT NULL DEFAULT 3,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Teléfono en formato internacional, por ejemplo +5493704123456
    CONSTRAINT chk_usuarios_telefono
        CHECK (telefono IS NULL OR telefono ~ '^\+[0-9]{8,15}$'),

    -- No puede haber un teléfono verificado sin teléfono
    CONSTRAINT chk_usuarios_telefono_verificado
        CHECK (telefono_verificado_at IS NULL OR telefono IS NOT NULL),

    CONSTRAINT chk_usuarios_dias_aviso
        CHECK (dias_anticipacion_aviso BETWEEN 0 AND 30),

    CONSTRAINT uq_usuarios_telefono
        UNIQUE (telefono)
);

-- Email único sin distinguir mayúsculas de minúsculas
CREATE UNIQUE INDEX uq_usuarios_email
    ON usuarios (LOWER(email));


-- =================================
-- TABLA: CUENTAS
-- =================================
-- El saldo actual se calcula con una vista:
-- saldo_inicial + movimientos confirmados +/- transferencias confirmadas.

CREATE TABLE cuentas (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    moneda CHAR(3) NOT NULL DEFAULT 'ARS',
    saldo_inicial NUMERIC(14,2) NOT NULL DEFAULT 0,
    activa BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_cuentas_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id),

    -- Permite claves foráneas compuestas desde otras tablas
    CONSTRAINT uq_cuenta_usuario
        UNIQUE (id, usuario_id),

    -- Evita duplicados como dos cuentas "Efectivo" del mismo usuario
    CONSTRAINT uq_cuentas_usuario_nombre
        UNIQUE (usuario_id, nombre),

    CONSTRAINT chk_tipo_cuenta
        CHECK (tipo IN ('efectivo', 'banco', 'billetera', 'otro')),

    CONSTRAINT chk_cuentas_moneda
        CHECK (moneda ~ '^[A-Z]{3}$')
);

-- =================================
-- TABLA: CATEGORIAS
-- =================================

CREATE TABLE categorias (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    activa BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_categorias_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id),

    -- Permite claves foráneas compuestas desde otras tablas
    CONSTRAINT uq_categoria_usuario
        UNIQUE (id, usuario_id),

    -- Evita categorías duplicadas dentro de un mismo usuario
    CONSTRAINT uq_categorias_usuario_nombre
        UNIQUE (usuario_id, nombre),

    CONSTRAINT chk_tipo_categoria
        CHECK (tipo IN ('ingreso', 'egreso', 'ambos'))
);

-- =================================
-- FUNCIÓN: actualizar updated_at
-- =================================
-- Se usa desde triggers para registrar la última modificación de un registro.

CREATE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =================================
-- TABLA: MOVIMIENTOS
-- =================================
-- Ingresos y egresos. La moneda se hereda de la cuenta.
-- Los registros no se borran: se anulan (estado = 'anulado').

CREATE TABLE movimientos (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    cuenta_id BIGINT NOT NULL,
    categoria_id BIGINT NOT NULL,
    tipo VARCHAR(10) NOT NULL,
    concepto VARCHAR(200) NOT NULL,
    importe NUMERIC(14,2) NOT NULL,
    fecha_operacion DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(20) NOT NULL DEFAULT 'confirmado',
    anulado_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_movimientos_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id),

    -- La cuenta debe pertenecer al mismo usuario del movimiento
    CONSTRAINT fk_movimientos_cuenta
        FOREIGN KEY (cuenta_id, usuario_id)
        REFERENCES cuentas(id, usuario_id),

    -- La categoría debe pertenecer al mismo usuario del movimiento
    CONSTRAINT fk_movimientos_categoria
        FOREIGN KEY (categoria_id, usuario_id)
        REFERENCES categorias(id, usuario_id),

    -- Permite claves foráneas compuestas desde pagos de deuda y de factura
    CONSTRAINT uq_movimiento_usuario
        UNIQUE (id, usuario_id),

    CONSTRAINT chk_movimientos_tipo
        CHECK (tipo IN ('ingreso', 'egreso')),

    CONSTRAINT chk_movimientos_importe
        CHECK (importe > 0),

    CONSTRAINT chk_movimientos_estado
        CHECK (estado IN ('confirmado', 'anulado')),

    -- anulado_at solo tiene valor cuando el movimiento está anulado
    CONSTRAINT chk_movimientos_anulacion
        CHECK ((estado = 'anulado') = (anulado_at IS NOT NULL))
);

CREATE INDEX idx_movimientos_usuario_fecha
    ON movimientos (usuario_id, fecha_operacion DESC);

CREATE INDEX idx_movimientos_cuenta_fecha
    ON movimientos (cuenta_id, fecha_operacion DESC);

CREATE INDEX idx_movimientos_categoria
    ON movimientos (categoria_id);

CREATE TRIGGER trg_movimientos_updated_at
    BEFORE UPDATE ON movimientos
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();


-- =================================
-- TABLA: TRANSFERENCIAS
-- =================================
-- Traslado de dinero entre dos cuentas del mismo usuario.
-- No es ingreso ni egreso: no altera el dinero total disponible.

CREATE TABLE transferencias (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    cuenta_origen_id BIGINT NOT NULL,
    cuenta_destino_id BIGINT NOT NULL,
    concepto VARCHAR(200),
    importe NUMERIC(14,2) NOT NULL,
    fecha_operacion DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(20) NOT NULL DEFAULT 'confirmado',
    anulado_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transferencias_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id),

    -- Ambas cuentas deben pertenecer al mismo usuario de la transferencia
    CONSTRAINT fk_transferencias_origen
        FOREIGN KEY (cuenta_origen_id, usuario_id)
        REFERENCES cuentas(id, usuario_id),

    CONSTRAINT fk_transferencias_destino
        FOREIGN KEY (cuenta_destino_id, usuario_id)
        REFERENCES cuentas(id, usuario_id),

    CONSTRAINT uq_transferencia_usuario
        UNIQUE (id, usuario_id),

    CONSTRAINT chk_transferencias_cuentas_distintas
        CHECK (cuenta_origen_id <> cuenta_destino_id),

    CONSTRAINT chk_transferencias_importe
        CHECK (importe > 0),

    CONSTRAINT chk_transferencias_estado
        CHECK (estado IN ('confirmado', 'anulado')),

    CONSTRAINT chk_transferencias_anulacion
        CHECK ((estado = 'anulado') = (anulado_at IS NOT NULL))
);

CREATE INDEX idx_transferencias_usuario_fecha
    ON transferencias (usuario_id, fecha_operacion DESC);

CREATE INDEX idx_transferencias_origen
    ON transferencias (cuenta_origen_id);

CREATE INDEX idx_transferencias_destino
    ON transferencias (cuenta_destino_id);

CREATE TRIGGER trg_transferencias_updated_at
    BEFORE UPDATE ON transferencias
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();