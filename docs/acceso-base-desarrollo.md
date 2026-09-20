# Acceso local a la base de desarrollo

La conexión actual utiliza el usuario PostgreSQL `matias` y el socket local
`/var/run/postgresql`. El archivo `backend/.env` ya configura esa conexión.

Para habilitar la administración de datos y tablas, ejecutar una vez desde
la raíz del proyecto:

```bash
sudo -u postgres psql -X -v ON_ERROR_STOP=1 -h /var/run/postgresql -d brinda_express < database/permisos-desarrollo.sql
```

`sudo` puede pedir la contraseña local en la terminal. Esa es la única
intervención local necesaria para activar estos permisos.

El script concede a `matias` acceso al esquema `public` y permiso para crear
objetos allí. También transfiere a `matias` la propiedad de las nueve tablas
actuales y sus secuencias de identidad, permitiendo consultar, insertar,
actualizar y borrar registros, así como modificar y eliminar esas tablas.
Se ejecuta en una transacción y conserva los registros existentes.

El alcance es la base local `brinda_express`; no convierte a `matias` en
superusuario ni le concede administración de otras bases. Como el backend usa
ese mismo usuario, también dispondrá de estos permisos de desarrollo.

La propiedad es necesaria para modificar o eliminar la estructura de las
tablas: `GRANT ALL` por sí solo no concede esas operaciones.
Referencia: [privilegios de PostgreSQL 16](https://www.postgresql.org/docs/16/ddl-priv.html).

## Después de la activación

El resultado del script debe mostrar `matias` como propietario de las nueve
tablas, todos los permisos en `t` y `crear_tablas` en `t`.

La conexión de trabajo queda así, sin cambios necesarios en el backend:

```bash
psql -X -h /var/run/postgresql -U matias -d brinda_express
```

Las nuevas tablas deben crearse con `matias` para que pueda administrarlas
desde el principio. Si se recrea la base con `postgres`, hay que volver a
aplicar el script de permisos después de cargar el esquema.

Codex puede usar esta conexión para ejecutar las tareas que le pidas,
incluida la carga de `database/seed-pruebas.sql`, sin ejecutar `sudo`.
El entorno de ejecución de Codex puede seguir solicitando aprobación para
acceder al socket de PostgreSQL; esa aprobación se da en la aplicación.
