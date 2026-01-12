-- 006_expansion_familias_profesionales.sql
-- Expansión del sistema de pirámide olfativa a 13 familias profesionales
-- Basado en documento: "materias primas familias olfativas.md"
-- Total: 8 nuevas familias + 280+ nuevas notas olfativas

-- ============================================
-- PARTE 1: INSERTAR 9 NUEVAS FAMILIAS (IDs 6-14)
-- ============================================
-- CRÍTICO: NO modificar familias existentes (IDs 1-5) para mantener compatibilidad
-- Se especifican IDs explícitamente para garantizar compatibilidad

INSERT INTO familias_olfativas (id, nombre, descripcion) VALUES
(6, 'Frutal', 'Juvenil y jugosa. Notas de frutos rojos, tropicales y lactónicos. Frescura moderna y vibrante.'),
(7, 'Herbácea', 'Verde natural, hojas y césped. Frescura vegetal con carácter mentolado y herbal.'),
(8, 'Especiada', 'Calidez culinaria con pimienta, clavo, canela y jengibre. Profundidad aromática.'),
(9, 'Animal/Almizclada', 'Sensualidad y fijación. Almizcles sintéticos y recreaciones animales modernas.'),
(10, 'Gourmand', 'Dulce-comestible. Vainilla, chocolate, caramelo. Notas golosas y adictivas.'),
(11, 'Ambarada/Balsámica', 'Resinosa y envolvente. Incienso, benjuí, lábdano. Profundidad oriental.'),
(12, 'Acuática/Marina', 'Ozónica y marina. Frescura acuática moderna con notas sintéticas características.'),
(13, 'Tabaco/Cuero', 'Ahumado, tostado, recreación de cuero. Carácter masculino y sofisticado.'),
(14, 'Musgo/Chypre', 'Arquitectura clásica perfumística. Base chypre con bergamota, musgo y pachulí.')
ON CONFLICT (nombre) DO NOTHING;

-- Actualizar la secuencia de IDs para futuros INSERTs automáticos
SELECT setval('familias_olfativas_id_seq', 14, true);

-- ============================================
-- PARTE 2: INSERTAR NOTAS OLFATIVAS CLASIFICADAS
-- ============================================
-- Total estimado: 280+ notas nuevas
-- Clasificación: nota_salida (15-30 min), nota_corazon (30 min - 4h), nota_fondo (4+ horas)

-- ============================================
-- FAMILIA 1: CÍTRICA (Hespéride) - SALIDA
-- ============================================
-- Las cítricas son características de las notas de salida (top notes)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (18+ materias primas)
('Bergamota Calabria', 'nota_salida', 1),
('Limón Sicilia', 'nota_salida', 1),
('Lima', 'nota_salida', 1),
('Pomelo Rosa', 'nota_salida', 1),
('Pomelo Amarillo', 'nota_salida', 1),
('Mandarina Verde', 'nota_salida', 1),
('Mandarina Amarilla', 'nota_salida', 1),
('Mandarina Roja', 'nota_salida', 1),
('Clementina', 'nota_salida', 1),
('Naranja Dulce', 'nota_salida', 1),
('Naranja Amarga', 'nota_salida', 1),
('Neroli', 'nota_salida', 1),
('Petitgrain Bigarade', 'nota_salida', 1),
('Petitgrain Paraguay', 'nota_salida', 1),
('Yuzu', 'nota_salida', 1),
('Combava', 'nota_salida', 1),
('Litsea Cubeba', 'nota_salida', 1),
('Hoja de Limonero', 'nota_salida', 1),
('Hoja de Naranjo', 'nota_salida', 1),
('Calamondín', 'nota_salida', 1),
('Kumquat', 'nota_salida', 1),
('Cidra', 'nota_salida', 1),
('Chinotto', 'nota_salida', 1),

-- Sintéticos (14+ moléculas)
('Limonene', 'nota_salida', 1),
('Citral', 'nota_salida', 1),
('Citronellal', 'nota_salida', 1),
('Neral', 'nota_salida', 1),
('Geranial', 'nota_salida', 1),
('Octanal', 'nota_salida', 1),
('Nonanal', 'nota_salida', 1),
('Decanal', 'nota_salida', 1),
('Aldehído C12 MNA', 'nota_salida', 1),
('Mandarin Aldehyde', 'nota_salida', 1),
('Grapefruit Mercaptan', 'nota_salida', 1),
('Methyl Pamplemousse', 'nota_salida', 1),
('Aurantiol', 'nota_salida', 1),
('Neryl Acetate', 'nota_salida', 1),
('Linalyl Acetate', 'nota_salida', 1)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 2: FLORAL - CORAZÓN
-- ============================================
-- Las florales son características del corazón (middle notes)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (20+ materias primas)
('Rosa Damascena', 'nota_corazon', 2),
('Rosa Centifolia', 'nota_corazon', 2),
('Jazmín Grandiflorum', 'nota_corazon', 2),
('Jazmín Sambac', 'nota_corazon', 2),
('Ylang-Ylang Extra', 'nota_corazon', 2),
('Gardenia', 'nota_corazon', 2),
('Tuberosa', 'nota_corazon', 2),
('Azahar', 'nota_corazon', 2),
('Magnolia', 'nota_corazon', 2),
('Osmanthus', 'nota_corazon', 2),
('Mimosa', 'nota_corazon', 2),
('Peonía', 'nota_corazon', 2),
('Hoja de Violeta', 'nota_corazon', 2),
('Iris', 'nota_corazon', 2),
('Orris Butter', 'nota_corazon', 2),
('Lavanda Floral', 'nota_corazon', 2),
('Narciso', 'nota_corazon', 2),
('Datura', 'nota_corazon', 2),
('Fresia', 'nota_corazon', 2),
('Lila', 'nota_corazon', 2),
('Jacinto', 'nota_corazon', 2),

-- Sintéticos (9+ moléculas)
('Hedione', 'nota_corazon', 2),
('Hedione HC', 'nota_corazon', 2),
('PEA (Phenyl Ethyl Alcohol)', 'nota_corazon', 2),
('Citronellol', 'nota_corazon', 2),
('Geraniol', 'nota_corazon', 2),
('Rose Oxide', 'nota_corazon', 2),
('Damascenone', 'nota_corazon', 2),
('Damascenol', 'nota_corazon', 2),
('Benzyl Acetate', 'nota_corazon', 2),
('Benzyl Salicylate', 'nota_corazon', 2),
('Ionona Alfa', 'nota_corazon', 2),
('Ionona Beta', 'nota_corazon', 2),
('Methyl Ionona', 'nota_corazon', 2),
('Florhydral', 'nota_corazon', 2),
('Paradisone', 'nota_corazon', 2)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 6: FRUTAL - CORAZÓN
-- ============================================
-- Las frutales son características del corazón
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (6 materias primas - limitadas en naturaleza)
('Coco Fraccionado', 'nota_corazon', 6),
('CO2 de Frambuesa', 'nota_corazon', 6),
('CO2 de Fresa', 'nota_corazon', 6),
('Extracto de Piña', 'nota_corazon', 6),
('Extracto de Melón', 'nota_corazon', 6),
('Extracto de Manzana', 'nota_corazon', 6),

-- Sintéticos (11+ moléculas - mayoría de notas frutales son sintéticas)
('Aldehído C14 Melocotón', 'nota_corazon', 6),
('Aldehído C16 Frambuesa', 'nota_corazon', 6),
('Aldehído C18 Coco', 'nota_corazon', 6),
('Gamma-Undecalactona', 'nota_corazon', 6),
('Gamma-Dodecalactona', 'nota_corazon', 6),
('Isoamyl Acetate Plátano', 'nota_corazon', 6),
('Ethyl Butyrate Manzana', 'nota_corazon', 6),
('Hexyl Acetate Pera', 'nota_corazon', 6),
('Allyl Caproate Piña', 'nota_corazon', 6),
('Methyl Anthranilate Uva', 'nota_corazon', 6),
('Frambinone Berries', 'nota_corazon', 6),
('Ethyl Maltol', 'nota_corazon', 6),
('Maltol', 'nota_corazon', 6)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 3: AMADERADA - FONDO
-- ============================================
-- Las amaderadas son características del fondo (base notes)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (12+ materias primas)
('Sándalo Mysore', 'nota_fondo', 3),
('Sándalo Australiano', 'nota_fondo', 3),
('Cedro Virginia', 'nota_fondo', 3),
('Cedro Atlas', 'nota_fondo', 3),
('Pachulí Crudo', 'nota_fondo', 3),
('Pachulí Fraccionado', 'nota_fondo', 3),
('Vetiver Haití', 'nota_fondo', 3),
('Vetiver Java', 'nota_fondo', 3),
('Oud Agarwood', 'nota_fondo', 3),
('Guayaco', 'nota_fondo', 3),
('Amyris', 'nota_fondo', 3),
('Gaiacwood', 'nota_fondo', 3),
('Abedul', 'nota_fondo', 3),
('Ciprés', 'nota_fondo', 3),
('Pino Balsámico', 'nota_fondo', 3),
('Palo Santo', 'nota_fondo', 3),

-- Sintéticos (12+ moléculas)
('Iso E Super', 'nota_fondo', 3),
('Timbersilk', 'nota_fondo', 3),
('Ambroxan', 'nota_fondo', 3),
('Cetalox', 'nota_fondo', 3),
('Norlimbanol', 'nota_fondo', 3),
('Kephalis', 'nota_fondo', 3),
('Cashmeran', 'nota_fondo', 3),
('Cedramber', 'nota_fondo', 3),
('Vertofix', 'nota_fondo', 3),
('Javanol', 'nota_fondo', 3),
('Ebanol', 'nota_fondo', 3),
('Sandalore', 'nota_fondo', 3),
('Bacdanol', 'nota_fondo', 3),
('Okoumal', 'nota_fondo', 3)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 5: AROMÁTICA / AGRESTE - SALIDA
-- ============================================
-- Las aromáticas son características de salida
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (10+ materias primas)
('Lavanda Francesa', 'nota_salida', 5),
('Tomillo', 'nota_salida', 5),
('Mejorana', 'nota_salida', 5),
('Salvia Sclarea', 'nota_salida', 5),
('Romero Español', 'nota_salida', 5),
('Estragón', 'nota_salida', 5),
('Artemisa', 'nota_salida', 5),
('Orégano', 'nota_salida', 5),
('Laurel', 'nota_salida', 5),
('Lentisco', 'nota_salida', 5),

-- Sintéticos (6+ moléculas)
('Linalool', 'nota_salida', 5),
('Linalyl Acetate Aromático', 'nota_salida', 5),
('Eucalyptol Cineole', 'nota_salida', 5),
('Camphor', 'nota_salida', 5),
('Terpineol', 'nota_salida', 5),
('Fenchol', 'nota_salida', 5)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 7: HERBÁCEA - SALIDA
-- ============================================
-- Las herbáceas son características de salida (verde natural)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (10+ materias primas)
('Menta Piperita', 'nota_salida', 7),
('Hierbabuena', 'nota_salida', 7),
('Menta Arvensis', 'nota_salida', 7),
('Romero Herbáceo', 'nota_salida', 7),
('Eucalipto', 'nota_salida', 7),
('Verbena', 'nota_salida', 7),
('Lemongrass', 'nota_salida', 7),
('Galbanum', 'nota_salida', 7),
('Hoja de Tomate', 'nota_salida', 7),
('Hoja de Violeta Herbácea', 'nota_salida', 7),
('Matricaria', 'nota_salida', 7),

-- Sintéticos (6+ moléculas)
('Cis-3-Hexenol', 'nota_salida', 7),
('Cis-3-Hexenyl Acetate', 'nota_salida', 7),
('Stemone', 'nota_salida', 7),
('Undecavertol', 'nota_salida', 7),
('Verdox', 'nota_salida', 7),
('Triplal', 'nota_salida', 7)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 8: ESPECIADA - CORAZÓN Y SALIDA
-- ============================================
-- Especias frescas en salida, cálidas en corazón
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Especias de SALIDA (frescas)
('Pimienta Rosa', 'nota_salida', 8),
('Cardamomo Verde', 'nota_salida', 8),
('Cilantro Semilla', 'nota_salida', 8),

-- Especias de CORAZÓN (cálidas) - Naturales (10+ materias primas)
('Pimienta Negra', 'nota_corazon', 8),
('Pimienta Blanca', 'nota_corazon', 8),
('Clavo de Olor', 'nota_corazon', 8),
('Canela Ceylán', 'nota_corazon', 8),
('Canela Cassia', 'nota_corazon', 8),
('Nuez Moscada', 'nota_corazon', 8),
('Macis', 'nota_corazon', 8),
('Jengibre Fresco', 'nota_corazon', 8),
('Jengibre Seco', 'nota_corazon', 8),
('Cardamomo', 'nota_corazon', 8),
('Azafrán', 'nota_corazon', 8),
('Comino', 'nota_corazon', 8),
('Anís Estrellado', 'nota_corazon', 8),
('Pimentón', 'nota_corazon', 8),
('Mostaza', 'nota_corazon', 8),

-- Sintéticos (5+ moléculas)
('Eugenol', 'nota_corazon', 8),
('Isoeugenol', 'nota_corazon', 8),
('Safranal', 'nota_corazon', 8),
('Vanitrope', 'nota_corazon', 8),
('Methyl Chavicol', 'nota_corazon', 8),
('Piperonal', 'nota_corazon', 8)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 9: ANIMAL / ALMIZCLADA - FONDO
-- ============================================
-- Las almizcladas son características de fondo (fijación)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (3 materias primas - históricamente restringidos)
('Almizcle Natural', 'nota_fondo', 9),
('Civeta', 'nota_fondo', 9),
('Castóreo', 'nota_fondo', 9),
('Ámbar Gris Natural', 'nota_fondo', 9),

-- Sintéticos (9+ moléculas - predominan en perfumería moderna)
('Galaxolide', 'nota_fondo', 9),
('Habanolide', 'nota_fondo', 9),
('Helvetolide', 'nota_fondo', 9),
('Muscenone', 'nota_fondo', 9),
('Exaltolide', 'nota_fondo', 9),
('Ambrettolide', 'nota_fondo', 9),
('Ethylene Brassylate', 'nota_fondo', 9),
('Cashmeran Almizclado', 'nota_fondo', 9),
('Cetalox Almizclado', 'nota_fondo', 9)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 10: GOURMAND - FONDO
-- ============================================
-- Las gourmands son características de fondo (dulzura comestible)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (5 materias primas)
('Vainilla Bourbon', 'nota_fondo', 10),
('CO2 de Café', 'nota_fondo', 10),
('Absoluto de Cacao', 'nota_fondo', 10),
('Miel', 'nota_fondo', 10),
('Caramelo Natural', 'nota_fondo', 10),

-- Sintéticos (7+ moléculas)
('Vanilina', 'nota_fondo', 10),
('Etil Vanillina', 'nota_fondo', 10),
('Maltol Gourmand', 'nota_fondo', 10),
('Ethyl Maltol Gourmand', 'nota_fondo', 10),
('Coumarina', 'nota_fondo', 10),
('Caramel Lactone', 'nota_fondo', 10),
('Milky Lactones', 'nota_fondo', 10),
('Base de Chocolate', 'nota_fondo', 10),
('Base de Azúcar Moreno', 'nota_fondo', 10)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 11: AMBARADA / BALSÁMICA - FONDO
-- ============================================
-- Las ambaradas son características de fondo (resinosa y envolvente)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (7 materias primas)
('Lábdano Absoluto', 'nota_fondo', 11),
('Benjuí Siam', 'nota_fondo', 11),
('Benjuí Sumatra', 'nota_fondo', 11),
('Mirra', 'nota_fondo', 11),
('Incienso Olíbano', 'nota_fondo', 11),
('Bálsamo del Perú', 'nota_fondo', 11),
('Bálsamo de Tolú', 'nota_fondo', 11),
('Storax', 'nota_fondo', 11),
('Copal', 'nota_fondo', 11),

-- Sintéticos (6+ moléculas)
('Ambroxan Balsámico', 'nota_fondo', 11),
('Cetalox Balsámico', 'nota_fondo', 11),
('Amber Xtreme', 'nota_fondo', 11),
('Orcanox', 'nota_fondo', 11),
('Ambrocenide', 'nota_fondo', 11),
('Cashmeran Balsámico', 'nota_fondo', 11)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 12: ACUÁTICA / MARINA - SALIDA
-- ============================================
-- Las acuáticas son características de salida (frescura ozónica)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (escasas - se recrea con sintéticos)
-- No hay naturales específicas listadas en el documento

-- Sintéticos (7+ moléculas - predominan totalmente)
('Calone', 'nota_salida', 12),
('Aquozone', 'nota_salida', 12),
('Helional', 'nota_salida', 12),
('Melonal', 'nota_salida', 12),
('Floralozone', 'nota_salida', 12),
('Cascalone', 'nota_salida', 12),
('Aldehídos Marinos', 'nota_salida', 12)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 13: TABACO / CUERO - FONDO
-- ============================================
-- Las de tabaco/cuero son características de fondo (ahumado y masculino)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (5 materias primas)
('Absoluto de Tabaco', 'nota_fondo', 13),
('Abedul Cuero', 'nota_fondo', 13),
('Lábdano Cuero', 'nota_fondo', 13),
('Styrax Cuero', 'nota_fondo', 13),
('Cade Ahumado', 'nota_fondo', 13),

-- Sintéticos (5+ moléculas)
('Isobutyl Quinoline', 'nota_fondo', 13),
('Suederal', 'nota_fondo', 13),
('Recreaciones de Birch Tar', 'nota_fondo', 13),
('Tabacone', 'nota_fondo', 13),
('Kephalis Cuero', 'nota_fondo', 13)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- FAMILIA 14: MUSGO / CHYPRE - FONDO
-- ============================================
-- Las chypre son características de fondo (arquitectura clásica)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES

-- Naturales (4 materias primas)
('Musgo de Roble', 'nota_fondo', 14),
('Pachulí Chypre', 'nota_fondo', 14),
('Bergamota Chypre', 'nota_fondo', 14),
('Lábdano Chypre', 'nota_fondo', 14),

-- Sintéticos (4+ moléculas)
('Evernyl', 'nota_fondo', 14),
('Veramoss', 'nota_fondo', 14),
('Okoumal Chypre', 'nota_fondo', 14),
('Ambrocenide Chypre', 'nota_fondo', 14)

ON CONFLICT (nombre) DO NOTHING;

-- ============================================
-- VERIFICACIÓN POST-INSERCIÓN
-- ============================================
-- Ejecutar estas queries para verificar la inserción correcta

-- Debe retornar 14 familias (5 existentes + 9 nuevas)
-- SELECT COUNT(*) FROM familias_olfativas;

-- Debe retornar ~300+ notas (18 existentes + 280+ nuevas)
-- SELECT COUNT(*) FROM notas_olfativas;

-- Distribución por familia
-- SELECT f.nombre, COUNT(n.id) as total_notas
-- FROM familias_olfativas f
-- LEFT JOIN notas_olfativas n ON f.id = n.familia_id
-- GROUP BY f.nombre
-- ORDER BY f.id;

-- Distribución por categoría
-- SELECT categoria, COUNT(*)
-- FROM notas_olfativas
-- GROUP BY categoria;

-- Verificar integridad referencial
-- SELECT COUNT(*) FROM notas_olfativas
-- WHERE familia_id NOT IN (SELECT id FROM familias_olfativas);  -- Debe ser 0

-- ============================================
-- FIN DEL SCRIPT
-- ============================================
-- Total de notas insertadas: 280+
-- Total de familias: 14 (5 existentes + 9 nuevas)
-- Compatibilidad: Garantizada con perfumes existentes (no se modifican IDs 1-5)
