import express from 'express'
import { productsRouter } from './modules/productos/productos.routes.js'
import { categoriesRouter } from './modules/categorias/categorias.routes.js'


export function createApp() {
  const app = express()

  app.disable('x-powered-by')
  app.use(express.json())

  app.get('/api/health', (_request, response) => {
    response.status(200).json({
      status: 'ok',
      service: 'brinda-express-api',
    })
  })

  app.use('/api/productos', productsRouter)
  app.use('/api/categorias', categoriesRouter)

  app.use((request, response) => {
    response.status(404).json({
      error: `No existe la ruta ${request.method} ${request.originalUrl}`,
    })
  })

  app.use((error, request, response, next) => {
    if (response.headersSent) {
      return next(error)
    }

    console.error(`Error en ${request.method} ${request.originalUrl}`, error)

    return response.status(500).json({
      error: 'Ocurrió un error interno',
    })
  })

  return app
}
