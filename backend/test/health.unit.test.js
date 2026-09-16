import assert from 'node:assert/strict'
import { after, describe, it } from 'node:test'

import { createApp } from '../src/app.js'

describe('GET /api/health', () => {
  const app = createApp()
  let server

  after(async () => {
    if (server) {
      await new Promise((resolve) => server.close(resolve))
    }
  })

  it('informa que la API está disponible', async () => {
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
    const response = await fetch(`http://127.0.0.1:${address.port}/api/health`)
    const body = await response.json()

    assert.equal(response.status, 200)
    assert.deepEqual(body, {
      status: 'ok',
      service: 'brinda-express-api',
    })
  })
})
