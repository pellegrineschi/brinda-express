-- Acceso de desarrollo local para matias en brinda_express.
-- Ejecutar una vez desde la raíz del proyecto como administrador:
-- sudo -u postgres psql -X -v ON_ERROR_STOP=1 -h /var/run/postgresql -d brinda_express < database/permisos-desarrollo.sql
-- Se puede repetir. Requiere las 9 tablas de database/schema.sql.

BEGIN;
SET LOCAL lock_timeout = '5s';

-- Evitar aplicar los permisos en otra base por error.
DO $$
BEGIN
    IF current_database() <> 'brinda_express' THEN
        RAISE EXCEPTION 'Este script solo debe ejecutarse en brinda_express';
    END IF;
END;
$$;

GRANT CONNECT ON DATABASE brinda_express TO matias;
GRANT USAGE, CREATE ON SCHEMA public TO matias;

-- Ser propietario permite administrar los datos y usar ALTER TABLE / DROP TABLE.
-- PostgreSQL también transfiere las secuencias de identidad de estas tablas.
ALTER TABLE public.roles OWNER TO matias;
ALTER TABLE public.usuarios OWNER TO matias;
ALTER TABLE public.categorias OWNER TO matias;
ALTER TABLE public.productos OWNER TO matias;
ALTER TABLE public.pedidos OWNER TO matias;
ALTER TABLE public.detalles_pedido OWNER TO matias;
ALTER TABLE public.reservas_stock OWNER TO matias;
ALTER TABLE public.pagos OWNER TO matias;
ALTER TABLE public.entregas OWNER TO matias;

COMMIT;

-- Resultado esperado: propietario = matias y todos los permisos = t.
SELECT
    tablename AS tabla,
    tableowner AS propietario,
    has_table_privilege('matias', format('%I.%I', schemaname, tablename), 'SELECT') AS leer,
    has_table_privilege('matias', format('%I.%I', schemaname, tablename), 'INSERT') AS insertar,
    has_table_privilege('matias', format('%I.%I', schemaname, tablename), 'UPDATE') AS editar,
    has_table_privilege('matias', format('%I.%I', schemaname, tablename), 'DELETE') AS borrar
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

SELECT has_schema_privilege('matias', 'public', 'CREATE') AS crear_tablas;
