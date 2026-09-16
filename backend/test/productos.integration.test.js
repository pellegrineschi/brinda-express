import assert from 'node:assert/strict'
import { after, describe, it } from 'node:test'

import { createApp } from '../src/app.js'
import { pool } from '../src/db/pool.js'

describe('GET /api/productos', () => {
  const app = createApp()
  let server

  after(async () => {
    if (server) {
      await new Promise((resolve) => server.close(resolve))
    }

    await pool.end()
  })

  it('devuelve los productos activos de PostgreSQL', async () => {
    server = await new Promise((resolve, reject) => {
      const listeningServer = app.listen(0, '127.0.0.1', (error) => {
        if (error) {
          reject(error)
          return
        }

        resolve(listeningServer)
      })
    })

    const address = server.address()
    const response = await fetch(`http://127.0.0.1:${address.port}/api/productos`)
    const body = await response.json()

    assert.equal(response.status, 200)
    assert.ok(Array.isArray(body.data))
    assert.ok(body.data.length > 0)
    assert.equal(typeof body.data[0].precio, 'string')
    assert.ok(body.data[0].categoria)
  })
})
