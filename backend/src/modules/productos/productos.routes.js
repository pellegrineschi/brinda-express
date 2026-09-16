import { Router } from 'express'

import { listProducts } from './productos.controller.js'

export const productsRouter = Router()

productsRouter.get('/', listProducts)
