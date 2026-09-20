-- Catálogo ficticio para desarrollo: precios de ejemplo expresados en pesos.
-- Requiere database/schema.sql. No requiere ejecutar database/seed.sql.
-- Agrega registros faltantes; no actualiza ni elimina los existentes.
-- Ejecutar desde la raíz del proyecto:
-- sudo -u postgres psql -X -v ON_ERROR_STOP=1 -d brinda_express < database/seed-pruebas.sql

BEGIN;

INSERT INTO categorias (nombre, descripcion, activo)
VALUES
    ('Cervezas', 'Cervezas en distintas presentaciones', TRUE),
    ('Vinos', 'Vinos tintos, blancos y rosados', TRUE),
    ('Gaseosas', 'Bebidas gaseosas sin alcohol', TRUE),
    ('Aguas', 'Aguas con y sin gas', TRUE),
    ('Jugos', 'Jugos de frutas sin alcohol', TRUE),
    ('Energizantes', 'Bebidas energizantes sin alcohol', TRUE),
    ('Destilados', 'Bebidas destiladas', TRUE),
    ('Espumantes', 'Categoría de prueba activa sin productos', TRUE),
    ('Temporada Demo', 'Categoría de prueba inactiva con un producto activo', FALSE)
ON CONFLICT (nombre) DO NOTHING
RETURNING id_categoria, nombre, activo;

WITH datos (
    categoria, nombre, marca, presentacion_ml, descripcion,
    precio, contiene_alcohol, porcentaje_alcohol, stock, activo
) AS (
    VALUES
        ('Cervezas', 'Cerveza rubia 1000 ml', 'Marca Demo', 1000,
         'Botella retornable. Presentación alternativa a la lata de 473 ml.',
         4200.00, TRUE, 5.00, 18, TRUE),
        ('Cervezas', 'Cerveza roja 473 ml', 'Marca Demo', 473,
         'Lata de cerveza roja.',
         2850.50, TRUE, 5.50, 16, TRUE),
        ('Cervezas', 'Cerveza negra 473 ml', 'Marca Demo', 473,
         'Producto activo agotado: permite probar stock igual a cero.',
         3100.00, TRUE, 6.00, 0, TRUE),
        ('Cervezas', 'Cerveza IPA 473 ml', 'Marca Demo', 473,
         'Última unidad disponible: permite probar el límite de stock.',
         3500.00, TRUE, 6.50, 1, TRUE),
        ('Cervezas', 'Cerveza sin alcohol 473 ml', 'Marca Demo', 473,
         'Cerveza de prueba con graduación de 0%.',
         2700.00, FALSE, 0.00, 12, TRUE),
        ('Vinos', 'Vino malbec 750 ml', 'Bodega Demo', 750,
         'Vino tinto malbec.',
         8200.00, TRUE, 13.50, 15, TRUE),
        ('Vinos', 'Vino cabernet 750 ml', 'Bodega Demo', 750,
         'Vino tinto cabernet sauvignon.',
         9450.75, TRUE, 14.00, 8, TRUE),
        ('Vinos', 'Vino chardonnay 750 ml', 'Bodega Demo', 750,
         'Vino blanco chardonnay.',
         7800.00, TRUE, 12.50, 10, TRUE),
        ('Vinos', 'Vino rosado 750 ml', 'Bodega Demo', 750,
         'Producto inactivo con stock: debe quedar fuera del catálogo público.',
         6900.00, TRUE, 12.00, 7, FALSE),
        ('Gaseosas', 'Gaseosa cola 500 ml', 'Soda Demo', 500,
         'Gaseosa sabor cola en botella individual.',
         1800.00, FALSE, 0.00, 40, TRUE),
        ('Gaseosas', 'Gaseosa cola 1500 ml', 'Soda Demo', 1500,
         'Misma bebida en presentación familiar.',
         3200.00, FALSE, 0.00, 22, TRUE),
        ('Gaseosas', 'Gaseosa naranja 2250 ml', 'Soda Demo', 2250,
         'Gaseosa sabor naranja.',
         4100.00, FALSE, 0.00, 14, TRUE),
        ('Gaseosas', 'Gaseosa lima limón 1500 ml', 'Soda Demo', 1500,
         'Nombre con acento para comprobar la visualización de texto.',
         3150.00, FALSE, 0.00, 20, TRUE),
        ('Aguas', 'Agua sin gas 1500 ml', 'Marca Demo', 1500,
         'Presentación alternativa al agua de 500 ml del seed inicial.',
         1700.00, FALSE, 0.00, 35, TRUE),
        ('Aguas', 'Agua con gas 500 ml', 'Marca Demo', 500,
         'Agua con gas en botella individual.',
         1200.00, FALSE, 0.00, 25, TRUE),
        ('Aguas', 'Agua saborizada pera 1500 ml', 'Marca Demo', 1500,
         'Agua saborizada sin alcohol.',
         2350.00, FALSE, 0.00, 18, TRUE),
        ('Jugos', 'Jugo de naranja 1000 ml', 'Fruta Demo', 1000,
         'Jugo sabor naranja.',
         2800.00, FALSE, 0.00, 16, TRUE),
        ('Jugos', 'Jugo de manzana 1000 ml', 'Fruta Demo', 1000,
         'Segundo caso de producto activo sin stock, en otra categoría.',
         2650.00, FALSE, 0.00, 0, TRUE),
        ('Jugos', 'Jugo multivitamínico 200 ml', NULL, 200,
         NULL,
         850.25, FALSE, 0.00, 50, TRUE),
        ('Energizantes', 'Energizante clásico 250 ml', 'Energía Demo', 250,
         'Bebida energizante sin alcohol.',
         2900.00, FALSE, 0.00, 24, TRUE),
        ('Energizantes', 'Energizante sin azúcar 473 ml', 'Energía Demo', 473,
         'Presentación grande sin azúcar.',
         4300.00, FALSE, 0.00, 6, TRUE),
        ('Destilados', 'Vodka 750 ml', 'Destilería Demo', 750,
         'Bebida destilada para probar mayor graduación alcohólica.',
         12500.00, TRUE, 40.00, 9, TRUE),
        ('Destilados', 'Gin 700 ml', 'Destilería Demo', 700,
         'Bebida destilada en presentación de 700 ml.',
         18750.50, TRUE, 42.00, 4, TRUE),
        ('Temporada Demo', 'Limonada de temporada 500 ml', 'Marca Demo', 500,
         'Producto activo oculto porque su categoría está inactiva.',
         1950.00, FALSE, 0.00, 10, TRUE)
)
INSERT INTO productos (
    id_categoria, nombre, marca, presentacion_ml, descripcion,
    precio, contiene_alcohol, porcentaje_alcohol, stock, activo
)
SELECT
    c.id_categoria, d.nombre, d.marca, d.presentacion_ml, d.descripcion,
    d.precio, d.contiene_alcohol, d.porcentaje_alcohol, d.stock, d.activo
FROM datos AS d
JOIN categorias AS c ON c.nombre = d.categoria
WHERE NOT EXISTS (
    SELECT 1
    FROM productos AS p
    WHERE p.id_categoria = c.id_categoria
      AND p.nombre = d.nombre
      AND p.marca IS NOT DISTINCT FROM d.marca
      AND p.presentacion_ml = d.presentacion_ml
)
RETURNING id_producto, nombre, precio, stock, activo;

COMMIT;
