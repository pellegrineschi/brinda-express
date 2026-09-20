import { pool } from '../../db/pool.js'

export async function findActiveProducts(categoryId = null) {
  const result = await pool.query(
    `
      SELECT
        p.id_producto,
        p.nombre,
        p.marca,
        p.presentacion_ml,
        p.descripcion,
        p.precio,
        p.contiene_alcohol,
        p.porcentaje_alcohol,
        p.imagen_url,
        p.stock,
        c.id_categoria,
        c.nombre AS categoria
      FROM productos AS p
      JOIN categorias AS c
        ON c.id_categoria = p.id_categoria
      WHERE p.activo = TRUE
        AND c.activo = TRUE
        AND ($1::integer IS NULL OR p.id_categoria = $1)
      ORDER BY p.nombre, p.presentacion_ml
    `,
    [categoryId],
  )

  return result.rows
}

export async function findActiveProductById(id) {
  const result = await pool.query(
    `
      SELECT
        p.id_producto,
        p.nombre,
        p.marca,
        p.presentacion_ml,
        p.descripcion,
        p.precio,
        p.contiene_alcohol,
        p.porcentaje_alcohol,
        p.imagen_url,
        p.stock,
        c.id_categoria,
        c.nombre AS categoria
      FROM productos AS p
      JOIN categorias AS c
        ON c.id_categoria = p.id_categoria
      WHERE p.id_producto = $1
        AND p.activo = TRUE
        AND c.activo = TRUE
    `,
    [id],
  )

  return result.rows[0] ?? null
}