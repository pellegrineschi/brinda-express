import { pool } from '../../db/pool.js'

export async function findActiveProducts() {
  const result = await pool.query(`
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
    ORDER BY p.nombre, p.presentacion_ml
  `)

  return result.rows
}
