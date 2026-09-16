import { findActiveProducts } from './productos.repository.js'

export async function listProducts(_request, response) {
  const products = await findActiveProducts()

  response.status(200).json({ data: products })
}
