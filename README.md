# Personal Finance Manager

Sistema personal de gestión financiera diseñado para facilitar el registro y seguimiento de ingresos, gastos, cuentas, deudas y vencimientos mediante una interfaz móvil accesible y una posible integración con WhatsApp.

## Descripción del proyecto

Personal Finance Manager es un proyecto de desarrollo Full Stack cuyo objetivo es construir una herramienta sencilla y práctica para la administración de finanzas personales.

El sistema busca facilitar el registro de movimientos financieros, ofrecer una visión clara del dinero disponible y ayudar a controlar las obligaciones económicas pendientes.

Una de sus características principales será permitir el registro de operaciones mediante mensajes de lenguaje natural a través de WhatsApp, evitando formularios extensos y procesos innecesariamente complejos.

El proyecto también contempla una aplicación web móvil para consultar y administrar la información financiera.

## Objetivos

- Registrar ingresos y egresos.
- Consultar el dinero disponible total y por cuenta.
- Gestionar diferentes medios de dinero.
- Controlar deudas y compras a crédito.
- Registrar facturas y servicios pendientes de pago.
- Programar notificaciones de vencimientos.
- Consultar el historial de movimientos.
- Permitir la personalización de categorías.
- Ofrecer una experiencia de uso sencilla y accesible.

## Características y funcionalidades

### 1. Gestión de ingresos y egresos

Registro de todos los movimientos financieros.

**Ingresos:**
- Sueldos.
- Trabajos independientes y changas.
- Otros ingresos.

**Egresos:**
- Compras.
- Servicios.
- Gastos cotidianos.
- Otros pagos.

Cada movimiento tendrá información como importe, concepto, fecha, cuenta y categoría.

### 2. Gestión de cuentas y medios de dinero

El sistema permitirá administrar múltiples cuentas y medios de dinero:

- Efectivo.
- Cuentas bancarias.
- Billeteras digitales (Mercado Pago, Ualá, etc.).

Se podrá consultar:
- Saldo individual de cada cuenta.
- Dinero disponible total.
- Historial de movimientos por cuenta.

También se contemplarán las transferencias entre cuentas, sin alterar el dinero total disponible.

### 3. Categorías personalizables

El sistema contará con categorías predeterminadas, por ejemplo:

- Alimentación.
- Transporte.
- Medicamentos.
- Juegos de azar.
- Vestimenta.
- Vivienda y servicios.
- Entretenimiento.
- Otros.

El usuario podrá crear, modificar y desactivar categorías.

Cada movimiento deberá tener una categoría seleccionada manualmente.

### 4. Gestión de deudas

Registro y seguimiento de obligaciones económicas:

- Compras a cuenta.
- Préstamos personales.
- Compras en cuotas.
- Otras deudas pendientes.

El sistema mostrará el importe pendiente de cada deuda y permitirá registrar pagos parciales o totales.

Las deudas se visualizarán separadas del dinero disponible.

### 5. Gestión de facturas y servicios

Registro de obligaciones periódicas o puntuales:

- Electricidad.
- Internet.
- Cable.
- Agua.
- Otros servicios.

Cada factura tendrá:
- Nombre del servicio.
- Importe.
- Fecha de emisión, cuando corresponda.
- Fecha de vencimiento.
- Estado: pendiente o pagada.

Cuando se registre el pago, el sistema generará el egreso correspondiente y actualizará el estado de la factura.

### 6. Notificaciones y recordatorios

Sistema de notificaciones automáticas para anticipar vencimientos.

El usuario podrá configurar con cuántos días de anticipación desea recibir los avisos.

Las notificaciones podrán enviarse mediante WhatsApp.

### 7. Integración con WhatsApp

Se contempla integrar WhatsApp como canal de entrada y consulta de información financiera.

Ejemplos de mensajes:

- "Cobré $150.000 de una changa".
- "Combustible $8.000, efectivo".
- "Pagué $25.000 de luz desde Mercado Pago".

El sistema deberá interpretar los mensajes, identificar los datos relevantes y solicitar confirmación o aclaraciones cuando sea necesario.

También podrá responder consultas como:

- ¿Cuánto dinero tengo disponible?
- ¿Cuánto gasté este mes?
- ¿Cuánto debo?
- ¿Qué facturas están pendientes?
- ¿Qué vencimientos tengo próximos?

La integración se evaluará mediante los mecanismos oficiales de WhatsApp Business Platform.

### 8. Aplicación web móvil

Interfaz destinada a consultar y administrar las finanzas personales.

Se priorizarán:
- Diseño mobile-first.
- Botones grandes.
- Navegación sencilla.
- Formularios mínimos.
- Información financiera clara y legible.

## Requisitos de accesibilidad

La aplicación está pensada especialmente para una persona que utiliza el teléfono con la mano no dominante.

Por este motivo, el diseño deberá contemplar:

- Interacciones sencillas.
- Áreas táctiles amplias.
- Poca necesidad de precisión al tocar.
- Navegación intuitiva.
- Evitar pantallas sobrecargadas.
- Reducir la cantidad de pasos para registrar información.

La accesibilidad será un criterio central durante todo el desarrollo.

## Persistencia y seguridad de los datos

La información financiera deberá almacenarse en una base de datos remota.

El sistema no dependerá exclusivamente del almacenamiento del teléfono ni del historial de conversaciones de WhatsApp.

Se contemplarán:
- Autenticación de usuarios.
- Acceso desde diferentes dispositivos.
- Protección de información financiera.
- Persistencia de los datos en la nube.
- Mecanismos de recuperación de acceso.

## Arquitectura general propuesta

El sistema contempla los siguientes componentes:

1. **WhatsApp:** recepción de mensajes y envío de respuestas.
2. **Backend:** procesamiento de operaciones, validaciones y reglas de negocio.
3. **Base de datos:** almacenamiento persistente de la información.
4. **Frontend:** aplicación web para consultar y administrar los datos.
5. **Sistema de notificaciones:** programación y envío de recordatorios.

## Tecnologías

La selección definitiva de tecnologías se realizará durante la etapa de diseño técnico.

Se evaluarán herramientas para:

- Desarrollo frontend.
- Desarrollo backend.
- Gestión de bases de datos SQL.
- Integración con WhatsApp.
- Procesamiento de lenguaje natural.
- Autenticación.
- Despliegue y alojamiento.

## Etapas de desarrollo

- [x] Definición inicial del problema y objetivos.
- [x] Identificación de funcionalidades principales.
- [x] Definición inicial de cuentas, movimientos, categorías y deudas.
- [ ] Diseño completo del modelo de datos.
- [ ] Creación de la base de datos.
- [ ] Desarrollo del backend y API.
- [ ] Implementación de ingresos, egresos y transferencias.
- [ ] Implementación de cuentas y saldos.
- [ ] Implementación de deudas y pagos.
- [ ] Implementación de facturas y vencimientos.
- [ ] Desarrollo del sistema de notificaciones.
- [ ] Desarrollo de la interfaz web móvil.
- [ ] Integración con WhatsApp.
- [ ] Pruebas funcionales y de accesibilidad.
- [ ] Despliegue del sistema.

## Objetivo de aprendizaje

Este proyecto también funciona como entorno de práctica para consolidar conocimientos de desarrollo web, especialmente backend.

Los principales conceptos que se trabajarán son:

- Modelado de bases de datos relacionales.
- SQL y relaciones entre tablas.
- Diseño de APIs REST.
- Métodos HTTP y manejo de respuestas.
- Arquitectura backend.
- Validaciones y reglas de negocio.
- Autenticación y autorización.
- Integración mediante webhooks.
- Procesamiento de mensajes.
- Automatización de tareas.
- Despliegue de aplicaciones.

## Estado actual

**Fase:** Análisis y diseño funcional.

El proyecto se encuentra en etapa de definición de requisitos y arquitectura. Todavía no se ha seleccionado definitivamente el stack tecnológico ni comenzado la implementación.

---

Proyecto personal de práctica y aprendizaje Full Stack.
