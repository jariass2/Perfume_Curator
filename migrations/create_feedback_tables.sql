-- =============================================================================
-- PAYMSA - Advanced Feedback Tables Migration
-- =============================================================================
-- Description: Creates tables for ML-powered user feedback and analytics
-- Author: Claude Code Session
-- Date: 2026-01-06
-- =============================================================================

-- Drop existing objects if they exist (for clean re-runs)
DROP VIEW IF EXISTS metricas_usuario CASCADE;
DROP VIEW IF EXISTS perfumes_popularidad CASCADE;
DROP TABLE IF EXISTS feedback_explicito CASCADE;
DROP TABLE IF EXISTS patrones_comportamiento CASCADE;
DROP TABLE IF EXISTS preferencias_aprendidas CASCADE;
DROP TABLE IF EXISTS interacciones_usuario CASCADE;
DROP TABLE IF EXISTS sesiones_busqueda CASCADE;
DROP FUNCTION IF EXISTS registrar_interaccion CASCADE;
DROP FUNCTION IF EXISTS actualizar_preferencia_aprendida CASCADE;

-- =============================================================================
-- 1. SESIONES DE BÚSQUEDA
-- =============================================================================
-- Rastrea cada sesión de búsqueda del usuario

CREATE TABLE sesiones_busqueda (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    sesion_id VARCHAR(100) UNIQUE NOT NULL,
    criterios_busqueda JSONB NOT NULL,

    -- Metadata de sesión
    dispositivo VARCHAR(50),
    navegador VARCHAR(50),

    -- Timestamps
    fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_fin TIMESTAMP WITH TIME ZONE,

    -- Métricas de sesión
    resultados_mostrados INTEGER DEFAULT 0,
    tiempo_sesion_segundos INTEGER,

    -- Índices
    CONSTRAINT chk_sesion_tiempo CHECK (tiempo_sesion_segundos IS NULL OR tiempo_sesion_segundos >= 0)
);

CREATE INDEX idx_sesiones_usuario ON sesiones_busqueda(usuario_id);
CREATE INDEX idx_sesiones_fecha ON sesiones_busqueda(fecha_inicio DESC);
CREATE INDEX idx_sesiones_id ON sesiones_busqueda(sesion_id);

COMMENT ON TABLE sesiones_busqueda IS 'Registra cada sesión de búsqueda con sus criterios y métricas';

-- =============================================================================
-- 2. INTERACCIONES DE USUARIO
-- =============================================================================
-- Rastrea cada interacción del usuario con perfumes

CREATE TABLE interacciones_usuario (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    perfume_id INTEGER REFERENCES perfumes(id) ON DELETE CASCADE,
    sesion_id VARCHAR(100) REFERENCES sesiones_busqueda(sesion_id) ON DELETE SET NULL,

    -- Tipo de interacción
    tipo VARCHAR(50) NOT NULL, -- 'vista', 'click_detalle', 'agregado_favorito', 'removido_favorito', 'valoracion'

    -- Valor opcional (ej: puntuación de valoración)
    valor INTEGER,

    -- Contexto adicional
    contexto JSONB DEFAULT '{}'::jsonb,

    -- Timestamp
    fecha TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Índices
    CONSTRAINT chk_interaccion_tipo CHECK (
        tipo IN ('vista', 'click_detalle', 'agregado_favorito', 'removido_favorito', 'valoracion')
    ),
    CONSTRAINT chk_interaccion_valor CHECK (valor IS NULL OR (valor >= 1 AND valor <= 5))
);

CREATE INDEX idx_interacciones_usuario ON interacciones_usuario(usuario_id);
CREATE INDEX idx_interacciones_perfume ON interacciones_usuario(perfume_id);
CREATE INDEX idx_interacciones_tipo ON interacciones_usuario(tipo);
CREATE INDEX idx_interacciones_fecha ON interacciones_usuario(fecha DESC);
CREATE INDEX idx_interacciones_sesion ON interacciones_usuario(sesion_id);

COMMENT ON TABLE interacciones_usuario IS 'Registra cada interacción del usuario con perfumes para análisis de comportamiento';

-- =============================================================================
-- 3. PREFERENCIAS APRENDIDAS
-- =============================================================================
-- Almacena preferencias inferidas del comportamiento del usuario

CREATE TABLE preferencias_aprendidas (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Tipo y valor de la preferencia
    tipo_preferencia VARCHAR(50) NOT NULL, -- 'familia', 'intensidad', 'nota', 'marca', 'ocasion'
    valor VARCHAR(100) NOT NULL,

    -- Métricas de confianza
    confianza NUMERIC(3, 2) NOT NULL DEFAULT 0.5, -- 0.0 a 1.0
    veces_observado INTEGER DEFAULT 1,

    -- Origen del aprendizaje
    origen VARCHAR(50) NOT NULL, -- 'explicito', 'implicito', 'valoraciones', 'favoritos'

    -- Timestamps
    primera_observacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ultima_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Constraints
    CONSTRAINT chk_pref_confianza CHECK (confianza >= 0 AND confianza <= 1),
    CONSTRAINT chk_pref_veces CHECK (veces_observado > 0),
    CONSTRAINT chk_pref_tipo CHECK (
        tipo_preferencia IN ('familia', 'intensidad', 'nota', 'marca', 'ocasion', 'genero')
    ),
    CONSTRAINT uq_usuario_tipo_valor UNIQUE (usuario_id, tipo_preferencia, valor)
);

CREATE INDEX idx_pref_usuario ON preferencias_aprendidas(usuario_id);
CREATE INDEX idx_pref_tipo ON preferencias_aprendidas(tipo_preferencia);
CREATE INDEX idx_pref_confianza ON preferencias_aprendidas(confianza DESC);

COMMENT ON TABLE preferencias_aprendidas IS 'Preferencias inferidas del comportamiento del usuario con niveles de confianza';

-- =============================================================================
-- 4. FEEDBACK EXPLÍCITO
-- =============================================================================
-- Almacena valoraciones detalladas de los usuarios

CREATE TABLE feedback_explicito (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    perfume_id INTEGER REFERENCES perfumes(id) ON DELETE CASCADE,

    -- Puntuaciones detalladas (1-5)
    puntuacion_general INTEGER,
    puntuacion_longevidad INTEGER,
    puntuacion_proyeccion INTEGER,
    puntuacion_versatilidad INTEGER,

    -- Contexto de uso
    lo_usaria_para JSONB, -- ['diario', 'nocturno', 'formal', etc.]
    temporada_preferida VARCHAR(50), -- 'verano', 'invierno', 'todo el año', etc.

    -- Comentarios
    comentario TEXT,

    -- Utilidad
    util BOOLEAN DEFAULT TRUE,

    -- Timestamp
    fecha TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Constraints
    CONSTRAINT chk_fb_general CHECK (puntuacion_general IS NULL OR (puntuacion_general >= 1 AND puntuacion_general <= 5)),
    CONSTRAINT chk_fb_longevidad CHECK (puntuacion_longevidad IS NULL OR (puntuacion_longevidad >= 1 AND puntuacion_longevidad <= 5)),
    CONSTRAINT chk_fb_proyeccion CHECK (puntuacion_proyeccion IS NULL OR (puntuacion_proyeccion >= 1 AND puntuacion_proyeccion <= 5)),
    CONSTRAINT chk_fb_versatilidad CHECK (puntuacion_versatilidad IS NULL OR (puntuacion_versatilidad >= 1 AND puntuacion_versatilidad <= 5)),
    CONSTRAINT uq_usuario_perfume_feedback UNIQUE (usuario_id, perfume_id)
);

CREATE INDEX idx_feedback_usuario ON feedback_explicito(usuario_id);
CREATE INDEX idx_feedback_perfume ON feedback_explicito(perfume_id);
CREATE INDEX idx_feedback_puntuacion ON feedback_explicito(puntuacion_general DESC);

COMMENT ON TABLE feedback_explicito IS 'Valoraciones detalladas y feedback explícito de usuarios sobre perfumes';

-- =============================================================================
-- 5. PATRONES DE COMPORTAMIENTO
-- =============================================================================
-- Identifica y almacena patrones de comportamiento de usuarios

CREATE TABLE patrones_comportamiento (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,

    -- Tipo de patrón identificado
    patron_tipo VARCHAR(50) NOT NULL, -- 'exploratorio', 'decisivo', 'coleccionista', 'ocasional'
    descripcion TEXT,

    -- Confianza del patrón
    confianza NUMERIC(3, 2) DEFAULT 0.75,

    -- Estado
    activo BOOLEAN DEFAULT TRUE,

    -- Timestamps
    fecha_identificacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Constraints
    CONSTRAINT chk_patron_confianza CHECK (confianza >= 0 AND confianza <= 1),
    CONSTRAINT chk_patron_tipo CHECK (
        patron_tipo IN ('exploratorio', 'decisivo', 'coleccionista', 'ocasional')
    )
);

CREATE INDEX idx_patrones_usuario ON patrones_comportamiento(usuario_id);
CREATE INDEX idx_patrones_activo ON patrones_comportamiento(activo) WHERE activo = TRUE;

COMMENT ON TABLE patrones_comportamiento IS 'Patrones de comportamiento identificados para cada usuario';

-- =============================================================================
-- 6. VISTA: PERFUMES POPULARIDAD
-- =============================================================================
-- Vista materializada con estadísticas de popularidad de perfumes

CREATE VIEW perfumes_popularidad AS
SELECT
    p.id AS perfume_id,
    p.nombre,
    m.nombre AS marca,

    -- Métricas de engagement
    COUNT(DISTINCT CASE WHEN i.tipo = 'vista' THEN i.usuario_id END) AS usuarios_unicos,
    COUNT(CASE WHEN i.tipo = 'vista' THEN 1 END) AS vistas,
    COUNT(CASE WHEN i.tipo = 'click_detalle' THEN 1 END) AS clicks,
    COUNT(DISTINCT f.usuario_id) AS favoritos,
    COUNT(DISTINCT v.id) AS valoraciones,
    AVG(v.puntuacion) AS valoracion_promedio,

    -- Métricas calculadas
    CASE
        WHEN COUNT(CASE WHEN i.tipo = 'vista' THEN 1 END) > 0
        THEN COUNT(CASE WHEN i.tipo = 'click_detalle' THEN 1 END)::NUMERIC /
             COUNT(CASE WHEN i.tipo = 'vista' THEN 1 END)
        ELSE 0
    END AS ctr, -- Click-Through Rate

    CASE
        WHEN COUNT(CASE WHEN i.tipo = 'vista' THEN 1 END) > 0
        THEN COUNT(DISTINCT f.usuario_id)::NUMERIC /
             COUNT(DISTINCT CASE WHEN i.tipo = 'vista' THEN i.usuario_id END)
        ELSE 0
    END AS tasa_conversion -- Conversion to Favoritos

FROM perfumes p
LEFT JOIN marcas m ON p.marca_id = m.id
LEFT JOIN interacciones_usuario i ON p.id = i.perfume_id
LEFT JOIN favoritos f ON p.id = f.perfume_id
LEFT JOIN valoraciones v ON p.id = v.perfume_id
GROUP BY p.id, p.nombre, m.nombre;

COMMENT ON VIEW perfumes_popularidad IS 'Estadísticas de popularidad y engagement para cada perfume';

-- =============================================================================
-- 7. VISTA: MÉTRICAS DE USUARIO
-- =============================================================================
-- Vista con métricas completas de cada usuario

CREATE VIEW metricas_usuario AS
SELECT
    u.id AS usuario_id,
    u.nombre,
    u.email,

    -- Interacciones totales
    COUNT(i.id) AS total_interacciones,
    COUNT(DISTINCT CASE WHEN i.tipo = 'vista' THEN i.perfume_id END) AS perfumes_vistos,
    COUNT(DISTINCT CASE WHEN i.tipo = 'click_detalle' THEN i.perfume_id END) AS detalles_vistos,
    COUNT(DISTINCT f.perfume_id) AS favoritos_actuales,
    COUNT(DISTINCT v.perfume_id) AS perfumes_valorados,
    AVG(v.puntuacion) AS valoracion_promedio,

    -- Sesiones
    COUNT(DISTINCT s.sesion_id) AS sesiones_totales,
    AVG(s.tiempo_sesion_segundos) AS tiempo_promedio_sesion,

    -- Tasa de conversión
    CASE
        WHEN COUNT(DISTINCT CASE WHEN i.tipo = 'vista' THEN i.perfume_id END) > 0
        THEN COUNT(DISTINCT f.perfume_id)::NUMERIC /
             COUNT(DISTINCT CASE WHEN i.tipo = 'vista' THEN i.perfume_id END)
        ELSE 0
    END AS tasa_conversion,

    -- Última actividad
    MAX(i.fecha) AS ultima_interaccion

FROM usuarios u
LEFT JOIN interacciones_usuario i ON u.id = i.usuario_id
LEFT JOIN sesiones_busqueda s ON u.id = s.usuario_id
LEFT JOIN favoritos f ON u.id = f.usuario_id
LEFT JOIN valoraciones v ON u.id = v.usuario_id
GROUP BY u.id, u.nombre, u.email;

COMMENT ON VIEW metricas_usuario IS 'Métricas completas de comportamiento y engagement de usuarios';

-- =============================================================================
-- 8. FUNCIÓN: REGISTRAR INTERACCIÓN
-- =============================================================================
-- Función para registrar interacciones de forma simplificada

CREATE OR REPLACE FUNCTION registrar_interaccion(
    p_usuario_id INTEGER,
    p_perfume_id INTEGER,
    p_tipo VARCHAR(50),
    p_valor INTEGER DEFAULT NULL,
    p_sesion_id VARCHAR(100) DEFAULT NULL,
    p_contexto JSONB DEFAULT '{}'::jsonb
)
RETURNS INTEGER AS $$
DECLARE
    v_interaccion_id INTEGER;
BEGIN
    INSERT INTO interacciones_usuario (
        usuario_id, perfume_id, tipo, valor, sesion_id, contexto
    )
    VALUES (
        p_usuario_id, p_perfume_id, p_tipo, p_valor, p_sesion_id, p_contexto
    )
    RETURNING id INTO v_interaccion_id;

    RETURN v_interaccion_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION registrar_interaccion IS 'Registra una interacción de usuario con un perfume';

-- =============================================================================
-- 9. FUNCIÓN: ACTUALIZAR PREFERENCIA APRENDIDA
-- =============================================================================
-- Función para actualizar o insertar preferencias aprendidas

CREATE OR REPLACE FUNCTION actualizar_preferencia_aprendida(
    p_usuario_id INTEGER,
    p_tipo VARCHAR(50),
    p_valor VARCHAR(100),
    p_confianza NUMERIC DEFAULT 0.5,
    p_origen VARCHAR(50) DEFAULT 'implicito'
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO preferencias_aprendidas (
        usuario_id, tipo_preferencia, valor, confianza, veces_observado, origen
    )
    VALUES (
        p_usuario_id, p_tipo, p_valor, p_confianza, 1, p_origen
    )
    ON CONFLICT (usuario_id, tipo_preferencia, valor)
    DO UPDATE SET
        confianza = LEAST(1.0, preferencias_aprendidas.confianza + (p_confianza * 0.1)),
        veces_observado = preferencias_aprendidas.veces_observado + 1,
        ultima_actualizacion = NOW();
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION actualizar_preferencia_aprendida IS 'Actualiza o inserta preferencias aprendidas con incremento de confianza';

-- =============================================================================
-- 10. DATOS DE EJEMPLO (OPCIONAL - COMENTADO)
-- =============================================================================
-- Puedes descomentar para poblar con datos de prueba

/*
-- Ejemplo de sesión de búsqueda
INSERT INTO sesiones_busqueda (usuario_id, sesion_id, criterios_busqueda, dispositivo, navegador)
VALUES (1, '123e4567-e89b-12d3-a456-426614174000', '{"genero": "Unisex", "familia": "Floral"}'::jsonb, 'desktop', 'Chrome');

-- Ejemplo de interacción
SELECT registrar_interaccion(1, 1, 'vista', NULL, '123e4567-e89b-12d3-a456-426614174000', '{}'::jsonb);
SELECT registrar_interaccion(1, 1, 'click_detalle', NULL, '123e4567-e89b-12d3-a456-426614174000', '{"tiempo_en_lista_segundos": 5}'::jsonb);

-- Ejemplo de preferencia aprendida
SELECT actualizar_preferencia_aprendida(1, 'familia', 'Floral', 0.8, 'explicito');
SELECT actualizar_preferencia_aprendida(1, 'nota', 'Rosa', 0.7, 'favoritos');

-- Ejemplo de feedback explícito
INSERT INTO feedback_explicito (
    usuario_id, perfume_id, puntuacion_general, puntuacion_longevidad,
    puntuacion_proyeccion, puntuacion_versatilidad, lo_usaria_para,
    temporada_preferida, comentario
)
VALUES (
    1, 1, 5, 4, 5, 4, '["diario", "nocturno"]'::jsonb,
    'todo el año', 'Excelente perfume, muy versátil'
);
*/

-- =============================================================================
-- MIGRATION COMPLETED
-- =============================================================================

COMMENT ON SCHEMA public IS 'Paymsa Feedback Tables Migration - v1.0 - 2026-01-06';

-- Verify tables were created
SELECT
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
      'sesiones_busqueda',
      'interacciones_usuario',
      'preferencias_aprendidas',
      'feedback_explicito',
      'patrones_comportamiento'
  )
ORDER BY table_name;

-- Verify views were created
SELECT
    table_name,
    table_type
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name IN ('perfumes_popularidad', 'metricas_usuario')
ORDER BY table_name;
