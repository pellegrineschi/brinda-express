-- Brinda Express: estructura de la base de datos

-- Roles de la aplicación: cliente y administrador.
CREATE TABLE roles (
    id_rol INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Usuarios registrados.
CREATE TABLE usuarios (
    id_usuario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_rol INTEGER NOT NULL REFERENCES roles(id_rol),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(30),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Categorías del catálogo.
CREATE TABLE categorias (
    id_categoria INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Cada presentación de una bebida es un producto diferente.
CREATE TABLE productos (
    id_producto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_categoria INTEGER NOT NULL REFERENCES categorias(id_categoria),
    nombre VARCHAR(150) NOT NULL,
    marca VARCHAR(100),
    presentacion_ml INTEGER NOT NULL CHECK (presentacion_ml > 0),
    descripcion TEXT,
    precio NUMERIC(12, 2) NOT NULL CHECK (precio > 0),
    contiene_alcohol BOOLEAN NOT NULL DEFAULT FALSE,
    porcentaje_alcohol NUMERIC(5, 2) NOT NULL DEFAULT 0,
    imagen_url TEXT,
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_productos_alcohol CHECK (
        (contiene_alcohol = FALSE AND porcentaje_alcohol = 0)
        OR
        (contiene_alcohol = TRUE
         AND porcentaje_alcohol > 0
         AND porcentaje_alcohol <= 100)
    )
);

-- Datos generales de cada pedido.
CREATE TABLE pedidos (
    id_pedido INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario),
    fecha TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) NOT NULL DEFAULT 'pendiente_pago',
    subtotal NUMERIC(12, 2) NOT NULL CHECK (subtotal >= 0),
    total NUMERIC(12, 2) NOT NULL CHECK (total >= subtotal),

    CONSTRAINT chk_pedidos_estado CHECK (
        estado IN (
            'pendiente_pago',
            'confirmado',
            'cancelado',
            'vencido'
        )
    )
);

-- Productos incluidos en cada pedido.
CREATE TABLE detalles_pedido (
    id_detalle INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido),
    id_producto INTEGER NOT NULL REFERENCES productos(id_producto),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12, 2) NOT NULL CHECK (precio_unitario > 0),
    subtotal NUMERIC(12, 2)
        GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,

    CONSTRAINT uq_detalle_pedido_producto
        UNIQUE (id_pedido, id_producto)
);

-- Unidades reservadas temporalmente para un pedido.
CREATE TABLE reservas_stock (
    id_reserva INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido),
    id_producto INTEGER NOT NULL REFERENCES productos(id_producto),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'activa',
    vence_en TIMESTAMPTZ NOT NULL,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_reservas_estado CHECK (
        estado IN (
            'activa',
            'confirmada',
            'liberada',
            'vencida'
        )
    ),

    CONSTRAINT chk_reservas_vencimiento CHECK (
        vence_en > creado_en
    ),

    CONSTRAINT uq_reserva_pedido_producto
        UNIQUE (id_pedido, id_producto),

    CONSTRAINT fk_reserva_detalle
        FOREIGN KEY (id_pedido, id_producto)
        REFERENCES detalles_pedido (id_pedido, id_producto)
);

-- Pago simulado: un registro por pedido en esta primera versión.
CREATE TABLE pagos (
    id_pago INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedidos(id_pedido),
    fecha TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo VARCHAR(30) NOT NULL DEFAULT 'simulado'
        CHECK (metodo = 'simulado'),
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente'
        CHECK (estado IN ('pendiente', 'aprobado', 'rechazado')),
    monto NUMERIC(12, 2) NOT NULL CHECK (monto > 0),
    referencia_simulada VARCHAR(100) UNIQUE
);

-- Dirección y modalidad de entrega de cada pedido.
CREATE TABLE entregas (
    id_entrega INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedidos(id_pedido),
    tipo VARCHAR(20) NOT NULL
        CHECK (tipo IN ('inmediata', 'programada')),
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente'
        CHECK (
            estado IN (
                'pendiente',
                'en_preparacion',
                'en_camino',
                'entregada',
                'cancelada'
            )
        ),
    calle VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    piso_departamento VARCHAR(30),
    ciudad VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(20) NOT NULL,
    referencias TEXT,
    costo NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (costo >= 0),
    fecha_programada DATE,
    franja_horaria VARCHAR(50),

    CONSTRAINT chk_entregas_programacion CHECK (
        (
            tipo = 'inmediata'
            AND fecha_programada IS NULL
            AND franja_horaria IS NULL
        )
        OR
        (
            tipo = 'programada'
            AND fecha_programada IS NOT NULL
            AND franja_horaria IS NOT NULL
            AND LENGTH(TRIM(franja_horaria)) > 0
        )
    )
);