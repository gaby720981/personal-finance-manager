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