import argon2 from 'argon2'

export async function hashPassword (password){
    const passwordHash = await argon2.hash(password, {
        type: argon2.argon2id,
    })

    return passwordHash
}