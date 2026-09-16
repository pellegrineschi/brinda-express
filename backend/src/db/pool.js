import pg from 'pg'

import { env } from '../config/env.js'

const { Pool } = pg

export const pool = new Pool({
  host: env.database.host,
  port: env.database.port,
  database: env.database.name,
  user: env.database.user,
  password: env.database.password,
  max: 10,
})

pool.on('error', (error) => {
  console.error('Error inesperado en una conexión PostgreSQL inactiva', error)
})
