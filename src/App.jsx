import { useEffect, useState } from 'react'
import './App.css'

function App() {
  const [productos, setProductos] = useState([])
  const [cargando, setCargando] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    const controller = new AbortController()

    async function cargarProductos() {
      try {
        const respuesta = await fetch('/api/productos', {
          signal: controller.signal,
        })

        if (!respuesta.ok) {
          throw new Error('No se pudieron cargar los productos')
        }

        const resultado = await respuesta.json()
        setProductos(resultado.data)
      } catch (error) {
        if (error.name !== 'AbortError') {
          setError('No pudimos cargar los productos. Intentá más tarde.')
        }
      } finally {
        if (!controller.signal.aborted) {
          setCargando(false)
        }
      }
    }

    cargarProductos()

    return () => controller.abort()
  }, [])

  return (
    <main>
      <h1>Brinda Express</h1>
      <h2>Nuestros productos</h2>

      {cargando && <p>Cargando productos...</p>}

      {error && <p role="alert">{error}</p>}

      {!cargando && !error && productos.length === 0 && (
        <p>No hay productos disponibles.</p>
      )}

      <ul>
        {productos.map((producto) => (
          <li key={producto.id_producto}>
            {producto.nombre}
          </li>
        ))}
      </ul>
    </main>
  )
}

export default App