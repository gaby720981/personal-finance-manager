# Entity Relationship Diagram (ERD)

## Descripción

Este documento contiene el diseño entidad-relación de Personal Finance Manager.

El modelo representa las entidades necesarias para administrar cuentas, movimientos financieros, categorías, deudas, facturas y recordatorios.

## Entidades

1. USUARIOS
2. CUENTAS
3. CATEGORIAS
4. MOVIMIENTOS
5. TRANSFERENCIAS
6. DEUDAS
7. PAGOS_DEUDA
8. FACTURAS
9. PAGOS_FACTURA
10. RECORDATORIOS

## Convenciones

- PK: Primary Key (clave primaria).
- FK: Foreign Key (clave foránea).
- Una relación uno a muchos se representa mediante `||--o{`.
- Una relación uno a cero o uno se representa mediante `||--o|`.

## Reglas de integridad

- Cada cuenta pertenece a un usuario.
- Cada movimiento pertenece a un usuario y se asocia a una cuenta.
- Cada movimiento podrá tener una categoría.
- Las transferencias conectan dos cuentas del mismo usuario.
- Los pagos de deudas y facturas se vinculan con movimientos de egreso.
- Los recordatorios pertenecen a un usuario y están asociados a una factura.
- Los registros financieros no deberán eliminarse físicamente sin una política explícita de auditoría.

## Estado

Primera versión del diagrama entidad-relación. Pendiente de revisión y normalización antes de implementar el esquema SQL.