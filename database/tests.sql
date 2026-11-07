-- 1) Debe funcionar
INSERT INTO usuarios (nombre, email, password_hash)
VALUES ('Ana', 'ana@mail.com', 'x');

-- 2) Debe FALLAR (email repetido con otras mayúsculas)
INSERT INTO usuarios (nombre, email, password_hash)
VALUES ('Otra', 'ANA@mail.com', 'x');

-- 3) Debe FALLAR (teléfono sin +)
INSERT INTO usuarios (nombre, email, password_hash, telefono)
VALUES ('Luis', 'luis@mail.com', 'x', '3704123456');

-- 4) Debe funcionar (teléfono en formato internacional)
INSERT INTO usuarios (nombre, email, password_hash, telefono)
VALUES ('Luis', 'luis@mail.com', 'x', '+5493704123456');

-- 5) Debe funcionar
INSERT INTO cuentas (usuario_id, nombre, tipo, saldo_inicial)
VALUES (1, 'Efectivo', 'efectivo', 25000.00);

-- 6) Debe FALLAR (cuenta repetida para el mismo usuario)
INSERT INTO cuentas (usuario_id, nombre, tipo, saldo_inicial)
VALUES (1, 'Efectivo', 'efectivo', 0);

-- 7) Debe FALLAR (tipo inválido)
INSERT INTO cuentas (usuario_id, nombre, tipo)
VALUES (1, 'Tarjeta', 'crypto');