import {
  findActiveProducts,
  findActiveProductById,
} from './productos.repository.js'

export async function listProducts(_request, response) {
  const products = await findActiveProducts()

  response.status(200).json({ data: products })
}

export async function getProductById(request, response) {
  const id = Number(request.params.id)

  if (!Number.isInteger(id) || id < 1 || id > 2147483647) {
    return response.status(400).json({
      error: 'El ID del producto no es válido',
    })
  }

  const product = await findActiveProductById(id)

  if (product === null) {
    return response.status(404).json({
      error: 'Producto no encontrado',
    })
  }

  return response.status(200).json({ data: product })
}