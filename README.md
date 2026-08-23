# Brinda Express

Brinda Express es un e-commerce full-stack de bebidas con y sin alcohol, desarrollado como proyecto de Práctica Profesionalizante de la carrera de Programación en Teclab.

La plataforma permitirá consultar productos disponibles, administrar el catálogo, realizar pedidos y elegir entre delivery inmediato o entrega programada.

## Objetivo

Desarrollar una aplicación web full-stack que permita aplicar conocimientos de diseño de bases de datos, PostgreSQL, creación de APIs con Node.js y Express, desarrollo de interfaces con React, autenticación, reglas de negocio, documentación y control de versiones.

## Funcionalidades planificadas

### Cliente

- Registro e inicio de sesión.
- Catálogo de bebidas con y sin alcohol.
- Organización de productos por categorías.
- Búsqueda y filtrado de productos.
- Vista detallada de cada producto.
- Carrito disponible durante la sesión.
- Modificación de cantidades.
- Cálculo del subtotal, costo de entrega y total.
- Reserva temporal de stock durante el checkout.
- Simulación del pago.
- Consulta del estado de los pedidos.
- Delivery inmediato.
- Entregas programadas por fecha y franja horaria.
- Validación de mayoría de edad para bebidas alcohólicas.
- Diseño adaptable a computadoras, tablets y celulares.

### Administrador

- Inicio de sesión con rol Administrador.
- Panel básico de administración.
- Gestión de categorías y productos.
- Actualización del stock.
- Consulta de pedidos.
- Actualización del estado de pedidos y entregas.

## Reglas principales

- Para comprar será obligatorio registrarse e iniciar sesión.
- El carrito existirá únicamente durante la sesión y no se guardará en la base de datos.
- Al iniciar el checkout, el stock se reservará durante 30 minutos.
- Un pago simulado aprobado confirmará el pedido y descontará definitivamente el stock.
- Un pago rechazado o una reserva vencida liberará las unidades reservadas.
- Para comprar bebidas alcohólicas, el cliente deberá ser mayor de 18 años y confirmarlo durante el checkout.
- Cada presentación o tamaño será un producto independiente.
- Habrá un único stock general.
- Las entregas podrán ser inmediatas o programadas.

## Tecnologías

- PostgreSQL
- Node.js
- Express
- React
- JavaScript
- HTML
- CSS
- Vite
- ESLint
- Git y GitHub

## Metodología de trabajo

El proyecto se desarrolla individualmente mediante Scrum, con planificación semanal, sprints de jueves a domingo y presentación de resultados los lunes.

El seguimiento de las tareas se realiza mediante un tablero Kanban en Trello.

## Documentación

- [Modelo de datos](docs/modelo-datos.md)
- [Bitácora de desarrollo](docs/bitacora.md)

## Estructura planificada

```text
brinda-express/
├── database/
├── backend/
├── frontend/
├── docs/
│   ├── bitacora.md
│   └── modelo-datos.md
└── README.md
```

La aplicación React creada inicialmente será reorganizada dentro de `frontend` cuando comience esa etapa del proyecto.

## Estado del proyecto

Primer sprint en desarrollo. Se definieron el alcance, las reglas de negocio, las entidades, los atributos, las claves y las relaciones del modelo inicial de la base de datos.

El siguiente paso será implementar el esquema en PostgreSQL y comenzar el backend con Node.js y Express.

## Ejecución local actual

En esta etapa, el proyecto ejecutable corresponde a la aplicación inicial de React.

Instalar las dependencias:

```bash
npm install
```

Iniciar el servidor de desarrollo:

```bash
npm run dev
```

Luego, abrir en el navegador la dirección indicada por Vite.

## Autor

Matías Pellegrineschi
