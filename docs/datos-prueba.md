# Datos de prueba del catálogo

Desde la raíz del proyecto, con PostgreSQL local y el esquema creado.
En esta instalación, las tablas pertenecen a `postgres` y `matias` tiene
permiso de lectura; la carga debe ejecutarse con el propietario:

```bash
sudo -u postgres psql -X -v ON_ERROR_STOP=1 -d brinda_express < database/seed-pruebas.sql
```

Si ya activaste el [acceso de desarrollo](acceso-base-desarrollo.md), podés
cargar los datos directamente con `matias`, sin `sudo`:

```bash
psql -X -v ON_ERROR_STOP=1 -h /var/run/postgresql -U matias -d brinda_express -f database/seed-pruebas.sql
```

El script carga 24 productos ficticios y asegura que existan 9 categorías.
Los precios son importes de ejemplo en pesos, no precios comerciales.
No requiere ejecutar `database/seed.sql` y se puede volver a ejecutar:
conserva los registros existentes y solo agrega los faltantes, sin borrar
ni restablecer precios, stock o estados que hayas modificado.

Las categorías se identifican por nombre. Los productos se identifican por
categoría, nombre, marca y presentación; si cambiás alguno de esos campos,
una nueva ejecución puede volver a insertar la versión original del producto.
Los IDs los asigna PostgreSQL y se muestran al ejecutar el script.
La carga se realiza dentro de una transacción.

Con los 2 productos y las 4 categorías iniciales de esta base, quedan
26 productos y 9 categorías. Las rutas públicas deben devolver 24 productos
y 8 categorías, ya que excluyen el producto inactivo y la categoría inactiva.

## Casos incluidos

| Caso | Datos de ejemplo | Resultado esperado |
|---|---|---|
| Variedad de categorías | Cervezas, vinos, gaseosas, aguas, jugos, energizantes y destilados | Listados y filtro por categoría con varios resultados |
| Distintas presentaciones | Gaseosa cola de 500 y 1500 ml | Dos productos independientes |
| Con y sin alcohol en una categoría | Cervezas tradicionales y cerveza sin alcohol | Diferentes valores de `contiene_alcohol` |
| Stock cero | Cerveza negra y jugo de manzana | Aparecen en el catálogo actual con `stock: 0` |
| Última unidad | Cerveza IPA | `stock: 1` |
| Producto inactivo | Vino rosado | Ausente del listado; consulta por ID devuelve 404 |
| Categoría inactiva | Temporada Demo y su limonada activa | Ambos quedan fuera del catálogo; producto por ID devuelve 404 |
| Categoría activa vacía | Espumantes | Aparece en categorías; filtrar sus productos devuelve `data: []` |
| Campos opcionales nulos | Jugo multivitamínico | `marca`, `descripcion` e `imagen_url` son `null` |
| Decimales | Cerveza roja, cabernet, jugo multivitamínico y gin | `precio` conserva los centavos; PostgreSQL lo devuelve como cadena |
| Texto con acentos | Lima limón, multivitamínico, sin azúcar | Texto legible en la respuesta JSON |

Todos los productos nuevos tienen `imagen_url: null`.
El script solo carga categorías y productos.

## Consultas para probar la API

Con el backend iniciado (`cd backend` y `npm run dev`):

```bash
curl http://localhost:3000/api/categorias
curl http://localhost:3000/api/productos
```

Usá los IDs de esas respuestas para probar:

```text
GET /api/productos?categoria=<id_categoria>
GET /api/productos/<id_producto>
GET /api/productos?categoria=abc    → 400
GET /api/productos/0               → 400
```

Para localizar los IDs de los casos que no aparecen en el catálogo público:

```sql
SELECT c.id_categoria, c.nombre AS categoria, c.activo AS categoria_activa,
       p.id_producto, p.nombre AS producto, p.activo AS producto_activo, p.stock
FROM categorias AS c
LEFT JOIN productos AS p ON p.id_categoria = c.id_categoria
WHERE c.nombre IN ('Espumantes', 'Temporada Demo')
   OR p.nombre IN ('Vino rosado 750 ml', 'Cerveza negra 473 ml', 'Cerveza IPA 473 ml')
ORDER BY c.nombre, p.nombre;
```
