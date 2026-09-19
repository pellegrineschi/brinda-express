import { Router } from 'express'

import {
  listProducts,
  getProductById,
} from './productos.controller.js'

export const productsRouter = Router()

productsRouter.get('/', listProducts)
productsRouter.get('/:id', getProductById)