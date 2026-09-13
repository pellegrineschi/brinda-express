-- Roles iniciales.
INSERT INTO roles (nombre, descripcion)
VALUES
    ('cliente', 'Realiza compras y consulta sus pedidos'),
    ('administrador', 'Gestiona productos y stock');

-- Categorías iniciales.
INSERT INTO categorias (nombre, descripcion)
VALUES
    ('Cervezas', 'Cervezas en distintas presentaciones'),
    ('Vinos', 'Vinos tintos, blancos y rosados'),
    ('Gaseosas', 'Bebidas gaseosas sin alcohol'),
    ('Aguas', 'Aguas con y sin gas');


-- Productos iniciales.
INSERT INTO productos (
    id_categoria,
    nombre,
    marca,
    presentacion_ml,
    precio,
    contiene_alcohol,
    porcentaje_alcohol,
    stock)
VALUES
    (
        (SELECT id_categoria FROM categorias WHERE nombre = 'Cervezas'),
        'Cerveza rubia 473 ml',
        'Marca Demo',
        473,
        2500.00,
        TRUE,
        5.00,
        24
    ),
    (
        (SELECT id_categoria FROM categorias WHERE nombre = 'Aguas'),
        'Agua sin gas 500 ml',
        'Marca Demo',
        500,
        1000.00,
        FALSE,
        0,
        30
    );

-- Usuario de Prueba
INSERT INTO usuarios (
    id_rol,
    nombre,
    apellido,
    email,
    password_hash,
    fecha_nacimiento,
    activo
)
VALUES (
    (SELECT id_rol FROM roles WHERE nombre = 'cliente'),
    'Cliente',
    'Demo',
    'cliente.demo@example.com',
    'CUENTA_DE_PRUEBA_SIN_ACCESO',
    '1990-01-15',
    FALSE
); 


-- Pedido de Prueba
INSERT INTO pedidos (
    id_usuario,
    subtotal,
    total
)
VALUES (
    (
        SELECT id_usuario
        FROM usuarios
        WHERE email = 'cliente.demo@example.com'
    ),
    0,
    0
)
RETURNING id_pedido, id_usuario, estado, subtotal, total;


INSERT INTO detalles_pedido (
    id_pedido,
    id_producto,
    cantidad,
    precio_unitario
)
VALUES
    (
        1,
        1,
        2,
        (SELECT precio FROM productos WHERE id_producto = 1)
    ),
    (
        1,
        2,
        1,
        (SELECT precio FROM productos WHERE id_producto = 2)
    )
RETURNING id_detalle, id_producto, cantidad, precio_unitario, subtotal;

UPDATE pedidos
SET
    subtotal = (
        SELECT SUM(subtotal)
        FROM detalles_pedido
        WHERE id_pedido = 1
    ),
    total = (
        SELECT SUM(subtotal)
        FROM detalles_pedido
        WHERE id_pedido = 1
    )
WHERE id_pedido = 1
RETURNING id_pedido, estado, subtotal, total;