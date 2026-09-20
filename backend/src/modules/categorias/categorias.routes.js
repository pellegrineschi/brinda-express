import { Router } from 'express'
import { listCategories } from './categorias.controller.js'

export const categoriesRouter = Router()

categoriesRouter.get('/', listCategories)