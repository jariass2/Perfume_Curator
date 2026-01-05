-- 001_initial_schema.sql
-- Esquema de base de datos para Sistema de Perfumería Paymsa

-- Tabla: familias_olfativas
CREATE TABLE IF NOT EXISTS familias_olfativas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: intensidades
CREATE TABLE IF NOT EXISTS intensidades (
    id SERIAL PRIMARY KEY,
    nivel VARCHAR(20) UNIQUE NOT NULL,
    descripcion TEXT,
    duracion_estimada_horas INT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: generos
CREATE TABLE IF NOT EXISTS generos (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(20) UNIQUE NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: notas_olfativas
CREATE TABLE IF NOT EXISTS notas_olfativas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    categoria VARCHAR(20) NOT NULL CHECK (categoria IN ('nota_salida', 'nota_corazon', 'nota_fondo')),
    familia_id INT REFERENCES familias_olfativas(id),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: ocasiones
CREATE TABLE IF NOT EXISTS ocasiones (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    temporada VARCHAR(50),
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: marcas
CREATE TABLE IF NOT EXISTS marcas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    pais_origen VARCHAR(50),
    ano_fundacion INT,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: perfumes
CREATE TABLE IF NOT EXISTS perfumes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    marca_id INT REFERENCES marcas(id),
    familia_id INT REFERENCES familias_olfativas(id),
    intensidad_id INT REFERENCES intensidades(id),
    genero_id INT REFERENCES generos(id),
    ano_lanzamiento INT,
    precio_ml DECIMAL(10,2),
    descripcion TEXT,
    imagen_url VARCHAR(500),
    puntuacion_popularidad DECIMAL(3,2) DEFAULT 0,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: perfume_notas (relación muchos a muchos)
CREATE TABLE IF NOT EXISTS perfume_notas (
    perfume_id INT REFERENCES perfumes(id) ON DELETE CASCADE,
    nota_id INT REFERENCES notas_olfativas(id) ON DELETE CASCADE,
    PRIMARY KEY (perfume_id, nota_id)
);

-- Tabla: perfume_ocasiones (relación muchos a muchos)
CREATE TABLE IF NOT EXISTS perfume_ocasiones (
    perfume_id INT REFERENCES perfumes(id) ON DELETE CASCADE,
    ocasion_id INT REFERENCES ocasiones(id) ON DELETE CASCADE,
    PRIMARY KEY (perfume_id, ocasion_id)
);

-- Tabla: usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    nombre VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    preferencias JSONB,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: busquedas
CREATE TABLE IF NOT EXISTS busquedas (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    criterios JSONB NOT NULL,
    resultados_obtenidos INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: favoritos
CREATE TABLE IF NOT EXISTS favoritos (
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    perfume_id INT REFERENCES perfumes(id) On DELETE CASCADE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, perfume_id)
);

-- Tabla: valoraciones
CREATE TABLE IF NOT EXISTS valoraciones (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
    perfume_id INT REFERENCES perfumes(id) ON DELETE CASCADE,
    puntuacion INT CHECK (puntuacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(usuario_id, perfume_id)
);