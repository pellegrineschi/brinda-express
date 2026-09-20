import { findActiveCategories } from "./categorias.repository.js";

export async function listCategories(_request, response) {
    const categories = await findActiveCategories()
    
    response.status(200).json({data: categories})
    
}