export function validateRegistracion(data) {
  if (data === null || typeof data !== "object" || Array.isArray(data)) {
    return "los datos del registro deben de ser un objeto JSON";
  }

  const requiredFields = [
    "nombre",
    "apellido",
    "email",
    "password",
    "fechaNacimiento",
  ];

 for (const field of requiredFields) {
  const value = data[field]

  if (typeof value !== 'string' || value.trim() === '') {
    return `El campo ${field} es obligatorio y debe ser texto`
  }
}

  if(data.nombre.trim().length > 100) {
    return 'el nombre no puede superar los 100 cracteres'

  }

  if(data.apellido.trim().length > 100){
    return 'el apellido no puede superar los 100 cracteres'
  }

  const email = data.email.trim()

if (email.length > 254) {
  return 'El correo no puede superar los 254 caracteres'
}

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

if (!emailPattern.test(email)) {
  return 'El correo debe tener un formato válido'
}

const passwordLength = Array.from(data.password).length

if(passwordLength < 15) {
    return 'la contraseña debe tener al menos 15 caracteres'
}

if(passwordLength > 128 ) {
    return 'la contraseña no puede superar los 128 cracteres'
}

const fechaNacimiento = data.fechaNacimiento
const datePattern = /^\d{4}-\d{2}-\d{2}$/

if (!datePattern.test(fechaNacimiento)) {
  return 'La fecha de nacimiento debe tener el formato AAAA-MM-DD'
}

const birthDate = new Date(`${fechaNacimiento}T00:00:00.000Z`)

if (
  Number.isNaN(birthDate.getTime()) ||
  birthDate.getUTCFullYear() < 1 ||
  birthDate.toISOString().slice(0, 10) !== fechaNacimiento
) {
  return 'La fecha de nacimiento no es válida'
}

  return null
}
