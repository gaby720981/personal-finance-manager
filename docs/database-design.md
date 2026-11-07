# Database Design

## 1. Introducción

Este documento describe el diseño conceptual de la base de datos de Personal Finance Manager.

El objetivo es definir las entidades, los datos que almacenan y las relaciones necesarias para administrar ingresos, egresos, cuentas, transferencias, deudas y facturas.

La base de datos deberá garantizar la persistencia de la información y permitir consultar el historial financiero del usuario.

## 2. Entidades principales

### Usuarios (`usuarios`)

Almacena la información de cada usuario del sistema.

### Cuentas (`cuentas`)

Representa los diferentes medios donde el usuario administra su dinero.

Ejemplos:
- Efectivo.
- Mercado Pago.
- Ualá.
- Banco Nación.
- Banco Galicia.

Un usuario puede tener múltiples cuentas.

### Categorías (`categorias`)

Permite clasificar manualmente los movimientos.

Categorías iniciales:
- Alimentación.
- Transporte.
- Medicamentos.
- Juegos de azar.
- Vestimenta.
- Vivienda y servicios.
- Entretenimiento.
- Ingresos laborales.
- Otros.

El usuario podrá crear, modificar y desactivar categorías.

Las categorías desactivadas deberán conservarse para mantener el historial de movimientos.

### Movimientos (`movimientos`)

Registra las operaciones que afectan el dinero disponible.

Tipos principales:
- Ingreso.
- Egreso.

Cada movimiento tendrá:
- Usuario.
- Cuenta asociada.
- Categoría.
- Tipo de movimiento.
- Concepto.
- Importe.
- Fecha de operación.
- Fecha de creación del registro.
- Fecha de última modificación.
- Estado o fecha de anulación, según corresponda.

Los saldos de las cuentas y el total disponible se calcularán a partir de los movimientos y transferencias confirmados.

### Transferencias (`transferencias`)

Representa el traslado de dinero entre dos cuentas del mismo usuario.

Ejemplo:

Transferir $30.000 desde Banco Nación hacia Mercado Pago.

Una transferencia:
- Reduce el saldo de la cuenta de origen.
- Aumenta el saldo de la cuenta de destino.
- No representa un ingreso ni un gasto.
- No modifica el dinero total disponible.

### Deudas (`deudas`)

Almacena obligaciones económicas pendientes.

Tipos:
- Compras a cuenta.
- Préstamos personales.
- Compras en cuotas.
- Otras obligaciones.

Cada deuda tendrá:
- Descripción.
- Importe original.
- Fecha de origen.
- Estado.

El saldo pendiente se calculará restando los pagos confirmados al importe original.

Las deudas se mostrarán separadas del dinero disponible.

### Pagos de deuda (`pagos_deuda`)

Registra los pagos parciales o totales de cada deuda.

Cada pago estará asociado a:
- Una deuda.
- Una cuenta desde la que se realiza el pago.
- Un movimiento de egreso.
- Importe pagado.
- Fecha de pago.

Una deuda podrá recibir múltiples pagos hasta completar el importe original.

### Facturas (`facturas`)

Registra obligaciones de servicios y otros vencimientos.

Ejemplos:
- Electricidad.
- Cable.
- Internet.
- Agua.

Cada factura tendrá:
- Nombre del servicio.
- Importe original.
- Fecha de emisión, si corresponde.
- Fecha de vencimiento.
- Estado.

Una factura podrá recibir múltiples pagos parciales o un pago total.

### Pagos de factura (`pagos_factura`)

Registra los pagos realizados de cada factura.

Cada pago estará relacionado con:
- Una factura.
- Una cuenta utilizada.
- Un movimiento de egreso.
- Importe pagado.
- Fecha de pago.

Cuando se registre un pago, se actualizará el saldo pendiente de la factura.

La factura cambiará a estado pagada cuando su saldo pendiente llegue a cero.

### Recordatorios (`recordatorios`)

Almacena los avisos programados para las facturas.

Permitirá configurar:
- Anticipación del aviso.
- Fecha y hora de envío.
- Estado del recordatorio.
- Confirmación de envío.

## 3. Relaciones principales

- Un usuario puede tener muchas cuentas.
- Un usuario puede tener muchas categorías.
- Un usuario puede registrar muchos movimientos.
- Una cuenta puede estar asociada a muchos movimientos.
- Una categoría puede clasificar muchos movimientos.
- Un usuario puede tener muchas deudas.
- Una deuda puede recibir muchos pagos.
- Un usuario puede registrar muchas facturas.
- Una factura puede recibir uno o varios pagos.
- Una factura puede generar varios recordatorios.
- Una transferencia conecta una cuenta de origen con una cuenta de destino.

## 4. Reglas de negocio

### Saldos

El saldo de cada cuenta se calcula a partir de sus movimientos confirmados y transferencias.

El dinero disponible total corresponde a la suma de los saldos de todas las cuentas.

### Deudas y pagos parciales

Registrar una compra a crédito genera una obligación pendiente, pero no descuenta dinero de las cuentas.

El sistema permitirá realizar pagos parciales o totales de una deuda.

Ejemplo:
- Deuda original: $50.000.
- Primer pago: $20.000.
- Segundo pago: $10.000.
- Saldo pendiente: $20.000.

Cada pago:
1. Se registra individualmente.
2. Genera un movimiento de egreso.
3. Se asocia a la cuenta utilizada.
4. Reduce el saldo pendiente de la deuda.

El saldo pendiente se calcula mediante:

`Saldo pendiente = Importe original - Suma de pagos confirmados`

La deuda permanecerá pendiente mientras su saldo sea mayor que cero. Cuando llegue a cero, su estado cambiará a saldada.

### Facturas y pagos parciales

Registrar una factura genera una obligación pendiente, pero no un egreso.

El sistema permitirá realizar uno o varios pagos para completar el importe de una factura.

Ejemplo:
- Factura de electricidad: $30.000.
- Primer pago: $20.000.
- Saldo pendiente: $10.000.
- Segundo pago: $10.000.
- Saldo pendiente: $0.

Cada pago:
1. Se registra individualmente.
2. Genera un movimiento de egreso.
3. Se relaciona con la factura.
4. Se asocia a la cuenta utilizada.
5. Reduce el saldo pendiente.

Cuando el saldo pendiente llegue a cero, la factura cambiará a estado pagada.

### Validaciones de pagos

- No se permitirá pagar un importe superior al saldo pendiente.
- El importe de cada pago deberá ser mayor que cero.
- Los pagos deberán estar asociados a una cuenta válida.
- Los pagos confirmados no deberán duplicarse.
- La anulación o modificación de un pago deberá actualizar correctamente el saldo pendiente y el movimiento asociado.
- Las operaciones relacionadas deberán ejecutarse de forma consistente mediante transacciones de base de datos.

### Transferencias

Las transferencias no se contabilizan como ingresos ni egresos en los informes generales de gastos e ingresos.

Una transferencia deberá afectar simultáneamente la cuenta de origen y la cuenta de destino.

### Categorías

Las categorías serán seleccionadas manualmente y podrán administrarse desde la aplicación.

No se eliminarán físicamente las categorías que ya tengan movimientos asociados.

### Edición y anulación de registros

Los movimientos podrán editarse.

El sistema conservará las fechas de creación y última modificación.

Los registros financieros no deberán eliminarse físicamente sin una política explícita de auditoría. Se contemplará la anulación para preservar el historial y mantener la consistencia de los datos relacionados.

## 5. Consultas que deberá permitir la base de datos

- Dinero disponible total.
- Saldo individual por cuenta.
- Ingresos de un período.
- Egresos de un período.
- Gastos agrupados por categoría.
- Deudas pendientes.
- Saldo pendiente de cada deuda.
- Historial de pagos de deudas.
- Facturas pendientes.
- Saldo pendiente de cada factura.
- Próximos vencimientos.
- Historial de pagos de facturas.
- Historial completo de movimientos.

## 6. Decisiones de diseño

Decisiones tomadas para la primera versión (MVP). Si alguna cambia, se actualiza este apartado y el esquema SQL.

| Tema | Decisión |
|---|---|
| Motor de base de datos | PostgreSQL. |
| Moneda | Solo pesos argentinos (ARS) en el MVP. Cuentas y movimientos incluirán un campo `moneda` para permitir otras monedas más adelante. |
| Importes | `NUMERIC(14,2)`. No se usa `FLOAT` para dinero. |
| Anulación de registros | Todas las tablas financieras usan `estado` (`confirmado` / `anulado`) y `anulado_at`. No hay borrado físico. |
| Saldos | Se calculan mediante vistas a partir de movimientos y transferencias confirmados. No se guardan como columna. |
| Usuarios | El modelo soporta varios usuarios (todo cuelga de `usuario_id`), aunque el MVP puede usarse con uno solo. |
| Integridad entre usuarios | Claves foráneas compuestas `(id, usuario_id)` para impedir que un registro mezcle datos de distintos usuarios. |
| WhatsApp | Fuera del MVP. El modelo se prepara para sumarlo después (ver paso de operaciones pendientes de confirmación). |
| Categorías | Cada usuario tiene sus propias categorías, copiadas desde una lista inicial al crearse su cuenta. |

### Lista oficial de categorías iniciales

| Categoría | Tipo |
|---|---|
| Alimentación | egreso |
| Transporte | egreso |
| Medicamentos | egreso |
| Juegos de azar | egreso |
| Vestimenta | egreso |
| Vivienda y servicios | egreso |
| Entretenimiento | egreso |
| Ingresos laborales | ingreso |
| Otros | ambos |

## 7. Estado del diseño

Este documento representa el modelo conceptual inicial.

Todavía deben definirse:
- Los campos y tipos de datos definitivos.
- Las claves primarias y foráneas.
- Las restricciones de integridad.
- El tratamiento técnico de pagos parciales.
- La implementación técnica de las transferencias.
- La estrategia para calcular y consultar saldos.
- La estrategia de auditoría y anulación de registros.

**Estado:** Diseño conceptual en desarrollo.