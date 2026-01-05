-- 005_user_feedback_system.sql
-- Sistema de Feedback y Aprendizaje de Usuario
-- Captura interacciones para enriquecer recomendaciones

-- Tabla de Interacciones de Usuario
-- Registra todas las acciones del usuario con perfumes
CREATE TABLE IF NOT EXISTS interacciones_usuario (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    perfume_id INTEGER REFERENCES perfumes(id) ON DELETE CASCADE,
    tipo_interaccion VARCHAR(50) NOT NULL, -- 'vista', 'click_detalle', 'agregado_favorito', 'removido_favorito', 'valoracion', 'compartido'
    valor_interaccion INTEGER, -- Para valoraciones (1-5), o NULL para otros tipos
    contexto JSONB, -- Información contextual: origen, tiempo en página, etc.
    fecha TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    sesion_id VARCHAR(100), -- Para agrupar interacciones de una sesión
    CONSTRAINT interaccion_valida CHECK (
        (tipo_interaccion = 'valoracion' AND valor_interaccion BETWEEN 1 AND 5) OR
        (tipo_interaccion != 'valoracion' AND valor_interaccion IS NULL)
    )
);

-- Tabla de Sesiones de Usuario
-- Captura información de cada sesión de búsqueda
CREATE TABLE IF NOT EXISTS sesiones_busqueda (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    sesion_id VARCHAR(100) UNIQUE NOT NULL,
    criterios_busqueda JSONB NOT NULL, -- Criterios utilizados en la búsqueda
    resultados_mostrados INTEGER, -- Cantidad de resultados mostrados
    perfumes_vistos INTEGER DEFAULT 0, -- Cuántos perfumes vio en detalle
    perfumes_favoriteados INTEGER DEFAULT 0, -- Cuántos agregó a favoritos
    tiempo_sesion_segundos INTEGER, -- Duración de la sesión
    conversion BOOLEAN DEFAULT FALSE, -- Si realizó alguna acción valiosa
    fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_fin TIMESTAMP WITH TIME ZONE,
    dispositivo VARCHAR(50), -- 'desktop', 'mobile', 'tablet'
    navegador VARCHAR(50)
);

-- Tabla de Feedback Explícito
-- Valoraciones y comentarios detallados
CREATE TABLE IF NOT EXISTS feedback_explicito (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    perfume_id INTEGER REFERENCES perfumes(id) ON DELETE CASCADE,
    puntuacion_general INTEGER CHECK (puntuacion_general BETWEEN 1 AND 5),
    puntuacion_longevidad INTEGER CHECK (puntuacion_longevidad BETWEEN 1 AND 5),
    puntuacion_proyeccion INTEGER CHECK (puntuacion_proyeccion BETWEEN 1 AND 5),
    puntuacion_versatilidad INTEGER CHECK (puntuacion_versatilidad BETWEEN 1 AND 5),
    lo_usaria_para JSONB, -- Array de ocasiones donde lo usaría
    temporada_preferida VARCHAR(20), -- 'verano', 'invierno', 'primavera', 'otoño', 'todo_ano'
    comentario TEXT,
    util BOOLEAN, -- Si la recomendación fue útil
    fecha TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(usuario_id, perfume_id)
);

-- Tabla de Preferencias Aprendidas
-- Preferencias inferidas del comportamiento del usuario
CREATE TABLE IF NOT EXISTS preferencias_aprendidas (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo_preferencia VARCHAR(50) NOT NULL, -- 'nota_preferida', 'familia_preferida', 'marca_preferida', 'intensidad_preferida', 'precio_maximo'
    valor VARCHAR(100) NOT NULL,
    confianza DECIMAL(3, 2), -- Nivel de confianza 0.00-1.00
    veces_observado INTEGER DEFAULT 1, -- Cuántas veces se ha observado este patrón
    ultima_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    origen VARCHAR(50), -- 'explicito', 'implicito', 'ml_inference'
    UNIQUE(usuario_id, tipo_preferencia, valor)
);

-- Tabla de Similitud entre Usuarios
-- Para collaborative filtering
CREATE TABLE IF NOT EXISTS similitud_usuarios (
    usuario_1_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    usuario_2_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    puntuacion_similitud DECIMAL(3, 2), -- 0.00-1.00
    metricas JSONB, -- Detalles de la similitud: familias comunes, marcas comunes, etc.
    fecha_calculo TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (usuario_1_id, usuario_2_id),
    CHECK (usuario_1_id < usuario_2_id) -- Evitar duplicados
);

-- Tabla de Patrones de Comportamiento
-- Patrones identificados en el comportamiento del usuario
CREATE TABLE IF NOT EXISTS patrones_comportamiento (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    patron_tipo VARCHAR(50) NOT NULL, -- 'exploratorio', 'decisivo', 'coleccionista', 'ocasional'
    descripcion TEXT,
    caracteristicas JSONB, -- Métricas que definen este patrón
    confianza DECIMAL(3, 2),
    fecha_identificacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de Experimentos A/B
-- Para testear diferentes algoritmos de recomendación
CREATE TABLE IF NOT EXISTS experimentos_recomendacion (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    variante VARCHAR(50) NOT NULL, -- 'A', 'B', 'C', etc.
    algoritmo_config JSONB, -- Configuración del algoritmo
    fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_fin TIMESTAMP WITH TIME ZONE,
    activo BOOLEAN DEFAULT TRUE,
    metricas_resultado JSONB -- CTR, conversion rate, etc.
);

-- Tabla de Asignaciones de Experimentos
CREATE TABLE IF NOT EXISTS usuario_experimentos (
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    experimento_id INTEGER REFERENCES experimentos_recomendacion(id) ON DELETE CASCADE,
    variante VARCHAR(50) NOT NULL,
    fecha_asignacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (usuario_id, experimento_id)
);

-- Índices para optimización
CREATE INDEX IF NOT EXISTS idx_interacciones_usuario_id ON interacciones_usuario(usuario_id);
CREATE INDEX IF NOT EXISTS idx_interacciones_perfume_id ON interacciones_usuario(perfume_id);
CREATE INDEX IF NOT EXISTS idx_interacciones_tipo ON interacciones_usuario(tipo_interaccion);
CREATE INDEX IF NOT EXISTS idx_interacciones_fecha ON interacciones_usuario(fecha DESC);
CREATE INDEX IF NOT EXISTS idx_sesiones_usuario_id ON sesiones_busqueda(usuario_id);
CREATE INDEX IF NOT EXISTS idx_sesiones_fecha ON sesiones_busqueda(fecha_inicio DESC);
CREATE INDEX IF NOT EXISTS idx_feedback_usuario_id ON feedback_explicito(usuario_id);
CREATE INDEX IF NOT EXISTS idx_preferencias_usuario_id ON preferencias_aprendidas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_preferencias_tipo ON preferencias_aprendidas(tipo_preferencia);

-- Vista de Métricas de Usuario
CREATE OR REPLACE VIEW metricas_usuario AS
SELECT
    u.id as usuario_id,
    u.nombre,
    u.email,
    COUNT(DISTINCT i.id) as total_interacciones,
    COUNT(DISTINCT CASE WHEN i.tipo_interaccion = 'vista' THEN i.perfume_id END) as perfumes_vistos,
    COUNT(DISTINCT CASE WHEN i.tipo_interaccion = 'click_detalle' THEN i.perfume_id END) as detalles_vistos,
    COUNT(DISTINCT f.perfume_id) as favoritos_actuales,
    COUNT(DISTINCT v.perfume_id) as perfumes_valorados,
    AVG(CASE WHEN i.tipo_interaccion = 'valoracion' THEN i.valor_interaccion END) as valoracion_promedio,
    COUNT(DISTINCT s.id) as sesiones_totales,
    AVG(s.tiempo_sesion_segundos) as tiempo_promedio_sesion,
    SUM(CASE WHEN s.conversion THEN 1 ELSE 0 END)::FLOAT / NULLIF(COUNT(DISTINCT s.id), 0) as tasa_conversion,
    MAX(i.fecha) as ultima_interaccion
FROM usuarios u
LEFT JOIN interacciones_usuario i ON u.id = i.usuario_id
LEFT JOIN favoritos f ON u.id = f.usuario_id
LEFT JOIN valoraciones v ON u.id = v.usuario_id
LEFT JOIN sesiones_busqueda s ON u.id = s.usuario_id
GROUP BY u.id, u.nombre, u.email;

-- Vista de Perfumes Populares
CREATE OR REPLACE VIEW perfumes_popularidad AS
SELECT
    p.id,
    p.nombre,
    m.nombre as marca,
    COUNT(DISTINCT i.usuario_id) as usuarios_unicos,
    COUNT(CASE WHEN i.tipo_interaccion = 'vista' THEN 1 END) as vistas,
    COUNT(CASE WHEN i.tipo_interaccion = 'click_detalle' THEN 1 END) as clicks,
    COUNT(CASE WHEN i.tipo_interaccion = 'agregado_favorito' THEN 1 END) as favoritos,
    COUNT(CASE WHEN i.tipo_interaccion = 'valoracion' THEN 1 END) as valoraciones,
    AVG(CASE WHEN i.tipo_interaccion = 'valoracion' THEN i.valor_interaccion END) as valoracion_promedio,
    COUNT(CASE WHEN i.tipo_interaccion = 'click_detalle' THEN 1 END)::FLOAT /
        NULLIF(COUNT(CASE WHEN i.tipo_interaccion = 'vista' THEN 1 END), 0) as ctr,
    COUNT(CASE WHEN i.tipo_interaccion = 'agregado_favorito' THEN 1 END)::FLOAT /
        NULLIF(COUNT(CASE WHEN i.tipo_interaccion = 'click_detalle' THEN 1 END), 0) as tasa_conversion
FROM perfumes p
LEFT JOIN marcas m ON p.marca_id = m.id
LEFT JOIN interacciones_usuario i ON p.id = i.perfume_id
GROUP BY p.id, p.nombre, m.nombre;

-- Vista de Recomendaciones Personalizadas Base
CREATE OR REPLACE VIEW perfil_usuario_enriquecido AS
SELECT
    u.id as usuario_id,
    u.preferencias as preferencias_explicitas,
    jsonb_object_agg(
        DISTINCT pa.tipo_preferencia,
        jsonb_build_object(
            'valor', pa.valor,
            'confianza', pa.confianza,
            'origen', pa.origen
        )
    ) FILTER (WHERE pa.id IS NOT NULL) as preferencias_aprendidas,
    jsonb_agg(DISTINCT jsonb_build_object(
        'perfume_id', f.perfume_id,
        'familia', fam.nombre,
        'marca', m.nombre,
        'intensidad', int.nivel
    )) FILTER (WHERE f.id IS NOT NULL) as favoritos_perfil,
    COUNT(DISTINCT i.perfume_id) FILTER (WHERE i.fecha > NOW() - INTERVAL '30 days') as interacciones_ultimo_mes,
    pc.patron_tipo as patron_comportamiento
FROM usuarios u
LEFT JOIN preferencias_aprendidas pa ON u.id = pa.usuario_id AND pa.confianza > 0.5
LEFT JOIN favoritos f ON u.id = f.usuario_id
LEFT JOIN perfumes pf ON f.perfume_id = pf.id
LEFT JOIN familias_olfativas fam ON pf.familia_id = fam.id
LEFT JOIN marcas m ON pf.marca_id = m.id
LEFT JOIN intensidades int ON pf.intensidad_id = int.id
LEFT JOIN interacciones_usuario i ON u.id = i.usuario_id
LEFT JOIN patrones_comportamiento pc ON u.id = pc.usuario_id AND pc.activo = TRUE
GROUP BY u.id, u.preferencias, pc.patron_tipo;

-- Función para registrar interacción
CREATE OR REPLACE FUNCTION registrar_interaccion(
    p_usuario_id INTEGER,
    p_perfume_id INTEGER,
    p_tipo_interaccion VARCHAR(50),
    p_valor_interaccion INTEGER DEFAULT NULL,
    p_sesion_id VARCHAR(100) DEFAULT NULL,
    p_contexto JSONB DEFAULT '{}'::jsonb
) RETURNS INTEGER AS $$
DECLARE
    interaccion_id INTEGER;
BEGIN
    INSERT INTO interacciones_usuario (
        usuario_id,
        perfume_id,
        tipo_interaccion,
        valor_interaccion,
        sesion_id,
        contexto
    ) VALUES (
        p_usuario_id,
        p_perfume_id,
        p_tipo_interaccion,
        p_valor_interaccion,
        p_sesion_id,
        p_contexto
    ) RETURNING id INTO interaccion_id;

    -- Actualizar métricas de sesión si existe
    IF p_sesion_id IS NOT NULL THEN
        UPDATE sesiones_busqueda
        SET
            perfumes_vistos = perfumes_vistos + CASE WHEN p_tipo_interaccion = 'click_detalle' THEN 1 ELSE 0 END,
            perfumes_favoriteados = perfumes_favoriteados + CASE WHEN p_tipo_interaccion = 'agregado_favorito' THEN 1 ELSE 0 END,
            conversion = TRUE
        WHERE sesion_id = p_sesion_id;
    END IF;

    RETURN interaccion_id;
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar preferencias aprendidas
CREATE OR REPLACE FUNCTION actualizar_preferencia_aprendida(
    p_usuario_id INTEGER,
    p_tipo_preferencia VARCHAR(50),
    p_valor VARCHAR(100),
    p_confianza DECIMAL(3,2),
    p_origen VARCHAR(50)
) RETURNS VOID AS $$
BEGIN
    INSERT INTO preferencias_aprendidas (
        usuario_id,
        tipo_preferencia,
        valor,
        confianza,
        veces_observado,
        origen
    ) VALUES (
        p_usuario_id,
        p_tipo_preferencia,
        p_valor,
        p_confianza,
        1,
        p_origen
    )
    ON CONFLICT (usuario_id, tipo_preferencia, valor)
    DO UPDATE SET
        veces_observado = preferencias_aprendidas.veces_observado + 1,
        confianza = LEAST(1.0, preferencias_aprendidas.confianza + 0.1),
        ultima_actualizacion = NOW();
END;
$$ LANGUAGE plpgsql;

-- Trigger para aprender de favoritos
CREATE OR REPLACE FUNCTION aprender_de_favorito() RETURNS TRIGGER AS $$
DECLARE
    perfume_data RECORD;
BEGIN
    -- Obtener información del perfume
    SELECT
        fam.nombre as familia,
        m.nombre as marca,
        int.nivel as intensidad,
        p.precio_ml
    INTO perfume_data
    FROM perfumes p
    JOIN familias_olfativas fam ON p.familia_id = fam.id
    JOIN marcas m ON p.marca_id = m.id
    JOIN intensidades int ON p.intensidad_id = int.id
    WHERE p.id = NEW.perfume_id;

    -- Actualizar preferencias aprendidas
    IF TG_OP = 'INSERT' THEN
        PERFORM actualizar_preferencia_aprendida(
            NEW.usuario_id, 'familia_preferida', perfume_data.familia, 0.7, 'implicito'
        );
        PERFORM actualizar_preferencia_aprendida(
            NEW.usuario_id, 'marca_preferida', perfume_data.marca, 0.6, 'implicito'
        );
        PERFORM actualizar_preferencia_aprendida(
            NEW.usuario_id, 'intensidad_preferida', perfume_data.intensidad, 0.5, 'implicito'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_aprender_favorito
    AFTER INSERT ON favoritos
    FOR EACH ROW
    EXECUTE FUNCTION aprender_de_favorito();

-- Datos de ejemplo para testing
INSERT INTO patrones_comportamiento (usuario_id, patron_tipo, descripcion, caracteristicas, confianza) VALUES
(1, 'exploratorio', 'Usuario que explora muchas opciones antes de decidir', '{"perfumes_vistos_promedio": 15, "sesiones_largas": true}', 0.85),
(2, 'decisivo', 'Usuario que toma decisiones rápidas', '{"perfumes_vistos_promedio": 3, "tasa_conversion_alta": true}', 0.90)
ON CONFLICT DO NOTHING;
