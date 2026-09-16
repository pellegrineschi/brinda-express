function readPort(name, fallback) {
  const value = Number(process.env[name] ?? fallback)

  if (!Number.isInteger(value) || value < 1 || value > 65535) {
    throw new Error(`${name} debe ser un número entero entre 1 y 65535`)
  }

  return value
}

const databaseUser = process.env.PGUSER ?? process.env.USER

if (!databaseUser) {
  throw new Error('Falta configurar PGUSER')
}

export const env = Object.freeze({
  port: readPort('PORT', 3000),
  database: Object.freeze({
    host: process.env.PGHOST ?? '/var/run/postgresql',
    port: readPort('PGPORT', 5432),
    name: process.env.PGDATABASE ?? 'brinda_express',
    user: databaseUser,
    password: process.env.PGPASSWORD,
  }),
})
