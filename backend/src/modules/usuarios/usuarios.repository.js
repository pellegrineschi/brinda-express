import { pool } from '../../db/pool.js'

export async function findUserByEmail(email) {
    const result = await pool.query (
         `
      SELECT
        id_usuario,
        email
      FROM usuarios
      WHERE LOWER(email) = LOWER($1)
      LIMIT 1
    `,
    [email],
    )

    return result.rows[0] ?? null
}

export async function createCliente({
  nombre,
  apellido,
  email,
  passwordHash,
  fechaNacimiento,
  telefono = null,
}){
  const result = await pool.query(
     `
      INSERT INTO usuarios (
        id_rol,
        nombre,
        apellido,
        email,
        password_hash,
        fecha_nacimiento,
        telefono
      )
      VALUES (
        (SELECT id_rol FROM roles WHERE nombre = 'cliente'),
        $1,
        $2,
        $3,
        $4,
        $5,
        $6
      )
      RETURNING id_usuario, nombre, apellido, email, activo
    `,
    [nombre, apellido, email, passwordHash, fechaNacimiento, telefono],
  )

  return result.rows[0]

  

}