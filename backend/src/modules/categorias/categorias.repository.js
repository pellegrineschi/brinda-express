import { pool } from '../../db/pool.js'

export async function findActiveCategories(){
    const result = await pool.query (
        `
    SELECT
      id_categoria,
      nombre,
      descripcion
    FROM categorias
    WHERE activo = TRUE
    ORDER BY nombre
  `
    )

    return result.rows
}