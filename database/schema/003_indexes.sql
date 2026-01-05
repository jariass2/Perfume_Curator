-- 003_indexes.sql
-- Índices para optimización de consultas

-- Índices en perfumes
CREATE INDEX IF NOT EXISTS idx_perfumes_familia ON perfumes(familia_id);
CREATE INDEX IF NOT EXISTS idx_perfumes_genero ON perfumes(genero_id);
CREATE INDEX IF NOT EXISTS idx_perfumes_precio ON perfumes(precio_ml);
CREATE INDEX IF NOT EXISTS idx_perfumes_popularidad ON perfumes(puntuacion_popularidad DESC);
CREATE INDEX IF NOT EXISTS idx_perfumes_marca ON perfumes(marca_id);
CREATE INDEX IF NOT EXISTS idx_perfumes_intensidad ON perfumes(intensidad_id);

-- Índices en relaciones
CREATE INDEX IF NOT EXISTS idx_perfume_notas_nota ON perfume_notas(nota_id);
CREATE INDEX IF NOT EXISTS idx_perfume_notas_perfume ON perfume_notas(perfume_id);
CREATE INDEX IF NOT EXISTS idx_perfume_ocasiones_ocasion ON perfume_ocasiones(ocasion_id);
CREATE INDEX IF NOT EXISTS idx_perfume_ocasiones_perfume ON perfume_ocasiones(perfume_id);

-- Índices en usuarios
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_preferencias ON usuarios USING GIN (preferencias);

-- Índices en busquedas
CREATE INDEX IF NOT EXISTS idx_busquedas_usuario ON busquedas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_busquedas_fecha ON busquedas(fecha DESC);

-- Índices en favoritos
CREATE INDEX IF NOT EXISTS idx_favoritos_usuario ON favoritos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_favoritos_perfume ON favoritos(perfume_id);

-- Índices en valoraciones
CREATE INDEX IF NOT EXISTS idx_valoraciones_perfume ON valoraciones(perfume_id);
CREATE INDEX IF NOT EXISTS idx_valoraciones_usuario ON valoraciones(usuario_id);
CREATE INDEX IF NOT EXISTS idx_valoraciones_puntuacion ON valoraciones(puntuacion);

-- Vista para consultas completas de perfumes
CREATE OR REPLACE VIEW vista_perfumes_completa AS
SELECT
    p.id,
    p.nombre,
    p.descripcion,
    p.precio_ml,
    p.puntuacion_popularidad,
    p.ano_lanzamiento,
    p.imagen_url,
    m.nombre AS marca,
    f.nombre AS familia,
    i.nivel AS intensidad,
    g.tipo AS genero,
    ARRAY_AGG(DISTINCT o.nombre) AS ocasiones,
    ARRAY_AGG(DISTINCT n.nombre) AS notas,
    ARRAY_AGG(DISTINCT CASE WHEN n.categoria = 'nota_salida' THEN n.nombre END) FILTER (WHERE n.categoria = 'nota_salida') AS notas_salida,
    ARRAY_AGG(DISTINCT CASE WHEN n.categoria = 'nota_corazon' THEN n.nombre END) FILTER (WHERE n.categoria = 'nota_corazon') AS notas_corazon,
    ARRAY_AGG(DISTINCT CASE WHEN n.categoria = 'nota_fondo' THEN n.nombre END) FILTER (WHERE n.categoria = 'nota_fondo') AS notas_fondo
FROM perfumes p
JOIN marcas m ON p.marca_id = m.id
JOIN familias_olfativas f ON p.familia_id = f.id
JOIN intensidades i ON p.intensidad_id = i.id
JOIN generos g ON p.genero_id = g.id
LEFT JOIN perfume_ocasiones po ON p.id = po.perfume_id
LEFT JOIN ocasiones o ON po.ocasion_id = o.id
LEFT JOIN perfume_notas pn ON p.id = pn.perfume_id
LEFT JOIN notas_olfativas n ON pn.nota_id = n.id
GROUP BY p.id, m.nombre, f.nombre, i.nivel, g.tipo;