-- 004_additional_luxury_perfumes.sql
-- Ampliación de base de datos con perfumes de lujo exclusivos
-- Basado en información web 2024-2025

-- Nuevas Marcas de Lujo
INSERT INTO marcas (nombre, pais_origen, ano_fundacion) VALUES
('Hermès', 'Francia', 1837),
('Guerlain', 'Francia', 1828),
('Byredo', 'Suecia', 2006),
('Le Labo', 'Estados Unidos', 2006),
('Maison Francis Kurkdjian', 'Francia', 2009),
('Prada', 'Italia', 1913),
('Valentino', 'Italia', 1960),
('Givenchy', 'Francia', 1952),
('Roja Parfums', 'Inglaterra', 2011),
('Amouage', 'Omán', 1983)
ON CONFLICT (nombre) DO NOTHING;

-- Familia Olfativa adicional
INSERT INTO familias_olfativas (nombre, descripcion) VALUES
('Gourmand', 'Dulce y comestible. Notas de caramelo, chocolate, café, vainilla.')
ON CONFLICT (nombre) DO NOTHING;

-- Notas Olfativas Adicionales (sin Gourmand primero)
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES
-- Notas de salida adicionales
('Azafrán', 'nota_salida', 4),
('Litsea Cubeba', 'nota_salida', 1),
('Pimienta Rosa', 'nota_salida', 4),
('Mandarina', 'nota_salida', 1),
('Pomelo', 'nota_salida', 1),
('Menta', 'nota_salida', 5),
('Albahaca', 'nota_salida', 5),
('Neroli', 'nota_salida', 2),
-- Notas de corazón adicionales
('Iris', 'nota_corazon', 2),
('Azahar', 'nota_corazon', 2),
('Violeta', 'nota_corazon', 2),
('Orquídea', 'nota_corazon', 2),
('Ylang-Ylang', 'nota_corazon', 2),
('Espino Blanco', 'nota_corazon', 2),
('Incienso', 'nota_corazon', 4),
('Palo de Oud', 'nota_corazon', 3),
('Bálsamo del Perú', 'nota_corazon', 4),
-- Notas de fondo adicionales
('Ambroxan', 'nota_fondo', 4),
('Musgo de Roble', 'nota_fondo', 3),
('Cedro Atlas', 'nota_fondo', 3),
('Tonka', 'nota_fondo', 4),
('Resina de Abeto', 'nota_fondo', 3),
('Benzoína', 'nota_fondo', 4),
('Guayaco', 'nota_fondo', 3)
ON CONFLICT (nombre) DO NOTHING;

-- Notas Gourmand (requieren que familia Gourmand exista)
INSERT INTO notas_olfativas (nombre, categoria, familia_id)
SELECT 'Haba Tonka', 'nota_fondo', id FROM familias_olfativas WHERE nombre = 'Gourmand'
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO notas_olfativas (nombre, categoria, familia_id)
SELECT 'Chocolate', 'nota_fondo', id FROM familias_olfativas WHERE nombre = 'Gourmand'
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO notas_olfativas (nombre, categoria, familia_id)
SELECT 'Caramelo', 'nota_fondo', id FROM familias_olfativas WHERE nombre = 'Gourmand'
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO notas_olfativas (nombre, categoria, familia_id)
SELECT 'Azúcar', 'nota_fondo', id FROM familias_olfativas WHERE nombre = 'Gourmand'
ON CONFLICT (nombre) DO NOTHING;

-- PERFUMES HERMÈS
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Hermès (marca_id = 9)
('Un Jardin à Cythère', 9, 1, 2, 3, 2024, 280.00, 'Fragancia cítrica fresca que evoca un jardín mediterráneo con pistachos y olivos. Premio Fragancia del Año 2024.', 4.8),
('Oud Alezan', 9, 3, 4, 1, 2023, 420.00, 'Amaderada intensa con oud y cuero. Colección Alta Gama.', 4.6),
('Barénia', 9, 3, 3, 2, 2022, 320.00, 'Amaderada cuero con notas de rosa y pachulí. Elegancia ecuestre.', 4.5),
('Terre d Hermès', 9, 3, 3, 1, 2006, 290.00, 'Amaderada mineral con naranja, cedro y vetiver. Icónica masculina.', 4.7),
('Twilly d Hermès', 9, 2, 3, 2, 2017, 265.00, 'Floral picante con jengibre, azahar y sándalo. Joven y vibrante.', 4.4);

-- PERFUMES GUERLAIN
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Guerlain (marca_id = 10)
('Tobacco Honey', 10, 4, 3, 3, 2023, 380.00, 'Oriental gourmand con tabaco y miel. Premio Perfume Extraordinario 2024.', 4.7),
('Aqua Allegoria Florabloom', 10, 2, 2, 2, 2023, 240.00, 'Floral fresca con peonía y rosa. Campaña destacada 2025.', 4.5),
('Shalimar', 10, 4, 4, 2, 1925, 320.00, 'Oriental clásica con bergamota, vainilla y tonka. Leyenda de la perfumería.', 4.9),
('L Homme Idéal', 10, 4, 3, 1, 2014, 260.00, 'Oriental amaderada con almendra, cuero y cedro. Moderna masculina.', 4.6),
('Mon Guerlain', 10, 4, 3, 2, 2017, 275.00, 'Oriental fresca con lavanda, vainilla y sándalo. Elegancia francesa.', 4.7);

-- PERFUMES BYREDO
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Byredo (marca_id = 11)
('Bal d Afrique', 11, 2, 3, 3, 2009, 380.00, 'Floral cítrica con violeta africana, neroli y vetiver. Top 4 más buscado 2024.', 4.8),
('Mojave Ghost Absolu', 11, 3, 4, 3, 2023, 420.00, 'Amaderada magnolia con sándalo y ámbar. Premio Perfume Nicho 2025.', 4.7),
('Gypsy Water', 11, 3, 3, 3, 2008, 370.00, 'Amaderada aromática con bergamota, pino y vainilla. Espíritu bohemio.', 4.6),
('Blanche', 11, 2, 3, 3, 2009, 360.00, 'Floral aldehídica con rosa blanca y sándalo. Minimalista sofisticada.', 4.5),
('Bibliothèque', 11, 3, 3, 3, 2017, 385.00, 'Amaderada con ciruela, melocotón, cuero y pachulí. Ambiente literario.', 4.6);

-- PERFUMES LE LABO
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Le Labo (marca_id = 12)
('Santal 33', 12, 3, 3, 3, 2011, 450.00, 'Amaderada cuero con sándalo, cedro y cardamomo. Top 6 más buscado 2024. Icónica.', 4.9),
('Another 13', 12, 5, 3, 3, 2010, 440.00, 'Aromática almizcle con ambroxan y musgo. Minimalista única.', 4.6),
('Rose 31', 12, 2, 3, 3, 2006, 435.00, 'Floral especiada con rosa, comino y cedro. Andrógina sofisticada.', 4.7),
('Bergamote 22', 12, 1, 2, 3, 2006, 420.00, 'Cítrica fresca con bergamota, pomelo y vetiver. Luminosa elegante.', 4.5),
('Thé Noir 29', 12, 3, 3, 3, 2012, 455.00, 'Amaderada té con bergamota, cedro y almizcle. Ceremonia del té.', 4.6);

-- PERFUMES MAISON FRANCIS KURKDJIAN
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- MFK (marca_id = 13)
('Baccarat Rouge 540', 13, 4, 3, 3, 2015, 520.00, 'Oriental ambarino con azafrán, jazmín, ambroxan y cedro. Icono de lujo.', 4.9),
('Aqua Universalis', 13, 1, 2, 3, 2009, 380.00, 'Cítrica fresca con bergamota calabresa, azahar y almizcle. Pureza universal.', 4.7),
('Oud Satin Mood', 13, 3, 4, 3, 2015, 495.00, 'Amaderada oud con rosa damascena, violeta y vainilla. Oriental voluptuosa.', 4.8),
('724', 13, 2, 3, 3, 2022, 410.00, 'Floral aldehídica con bergamota, jazmín y almizcle blanco. Frescura 24/7.', 4.6),
('Petit Matin', 13, 1, 2, 3, 2013, 390.00, 'Cítrica aromática con litsea cubeba, limón, lavanda y almizcle. Energía matinal.', 4.5);

-- PERFUMES PRADA
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Prada (marca_id = 14)
('Paradigme', 14, 3, 3, 1, 2025, 340.00, 'Amaderada ámbar con pirámide invertida: bálsamo Perú, benzoína, geranio, bergamota. Innovadora.', 4.7),
('L Homme Intense', 14, 4, 3, 1, 2017, 295.00, 'Oriental amaderada con iris, ámbar y pachulí. Elegancia oscura.', 4.6),
('Paradoxe', 14, 2, 3, 2, 2022, 310.00, 'Floral fresca con neroli, jazmín y ámbar blanco. Feminidad moderna.', 4.7),
('Luna Rossa Ocean', 14, 5, 3, 1, 2021, 285.00, 'Aromática amaderada con pomelo, incienso, sándalo y vainilla. Aventura acuática.', 4.5),
('Infusion d Iris', 14, 2, 2, 2, 2007, 270.00, 'Floral verde con iris, mandarina y cedro. Elegancia italiana.', 4.6);

-- PERFUMES VALENTINO
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Valentino (marca_id = 15)
('Uomo Intense', 15, 4, 3, 1, 2016, 280.00, 'Oriental amaderada con iris, tonka y cuero. Intensidad sofisticada.', 4.6),
('Voce Viva', 15, 2, 3, 2, 2020, 265.00, 'Floral amaderada con mandarina dorada, azahar y vainilla. Voz femenina.', 4.5),
('Donna Born in Roma', 15, 2, 3, 2, 2019, 275.00, 'Floral gourmand con jengibre, jazmín y vainilla bourbon. Espíritu romano.', 4.6),
('Uomo Born in Roma', 15, 5, 3, 1, 2019, 270.00, 'Aromática amaderada con violeta, salvia y vetiver. Artesanía italiana.', 4.5),
('V Pour Homme', 15, 5, 2, 1, 2004, 245.00, 'Aromática fresca con bergamota, lavanda y cedro. Clásica elegante.', 4.4);

-- PERFUMES GIVENCHY
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Givenchy (marca_id = 16)
('Gentleman Reserve Privée', 16, 3, 4, 1, 2017, 310.00, 'Amaderada iris con bergamota, iris y cedro. Elegancia parisina.', 4.7),
('L Interdit', 16, 2, 3, 2, 2018, 290.00, 'Floral blanca con azahar, jazmín y pachulí. Feminidad prohibida.', 4.7),
('Irresistible', 16, 2, 3, 2, 2020, 275.00, 'Floral frutal con rosa, pera y almizcle. Alegría espontánea.', 4.6),
('Gentleman Eau de Parfum Boisée', 16, 3, 3, 1, 2020, 295.00, 'Amaderada aromática con cacao, iris y sándalo. Carácter audaz.', 4.6),
('Ange ou Démon', 16, 4, 3, 2, 2006, 260.00, 'Oriental floral con azafrán, lirio, tonka y vainilla. Dualidad seductora.', 4.5);

-- PERFUMES ROJA PARFUMS
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Roja Parfums (marca_id = 17)
('Elysium', 17, 1, 4, 1, 2017, 650.00, 'Cítrica aromática con pomelo, lavanda, cedro y vetiver. Lujo británico.', 4.8),
('Enigma', 17, 4, 4, 1, 2013, 720.00, 'Oriental especiada con cognac, tabaco, oud y ámbar. Misterio profundo.', 4.7),
('Scandal', 17, 2, 4, 2, 2007, 680.00, 'Floral chipre con bergamota, gardenia, pachulí y vainilla. Opulencia rebelde.', 4.6),
('Dove', 17, 2, 4, 3, 2011, 710.00, 'Floral aldehídica con rosa, jazmín, iris y vainilla. Paz sublime.', 4.7),
('Apex', 17, 3, 4, 1, 2019, 695.00, 'Amaderada aromática con lavanda, cedro y almizcle. Cima del éxito.', 4.7);

-- PERFUMES AMOUAGE
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, puntuacion_popularidad) VALUES
-- Amouage (marca_id = 18)
('Interlude Man', 18, 4, 4, 1, 2012, 580.00, 'Oriental especiada con bergamota, incienso, mirra y ámbar. Caos organizado.', 4.8),
('Reflection Man', 18, 2, 4, 1, 2007, 560.00, 'Floral verde con romero, neroli, jazmín y cedro. Reflexión masculina.', 4.7),
('Jubilation XXV', 18, 4, 4, 1, 2007, 590.00, 'Oriental especiada con naranja, incienso, oud y pachulí. 25 años de lujo.', 4.8),
('Memoir Woman', 18, 4, 4, 2, 2010, 575.00, 'Oriental especiada con absenta, rosa, incienso y cuero. Memoria profunda.', 4.6),
('Gold Man', 18, 4, 4, 1, 2016, 620.00, 'Oriental especiada con azafrán, incienso, mirra y orris. Opulencia árabe.', 4.7)
ON CONFLICT DO NOTHING;

-- Relaciones perfume_notas para nuevos perfumes
-- Un Jardin à Cythère (16) - Hermès
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(16, 2), (16, 3), (16, 26), (16, 14);

-- Oud Alezan (17) - Hermès
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(17, 43), (17, 21), (17, 19);

-- Barénia (18) - Hermès
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(18, 9), (18, 21), (18, 17);

-- Terre d'Hermès (19) - Hermès
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(19, 3), (19, 15), (19, 16);

-- Twilly d'Hermès (20) - Hermès
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(20, 35), (20, 14), (20, 19);

-- Tobacco Honey (21) - Guerlain
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(21, 51), (21, 18), (21, 20);

-- Aqua Allegoria Florabloom (22) - Guerlain
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(22, 9), (22, 10), (22, 19);

-- Shalimar (23) - Guerlain
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(23, 1), (23, 18), (23, 48);

-- L'Homme Idéal (24) - Guerlain
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(24, 15), (24, 21), (24, 18);

-- Mon Guerlain (25) - Guerlain
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(25, 4), (25, 18), (25, 19);

-- Bal d'Afrique (26) - Byredo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(26, 28), (26, 38), (26, 16);

-- Mojave Ghost Absolu (27) - Byredo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(27, 14), (27, 19), (27, 20);

-- Gypsy Water (28) - Byredo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(28, 1), (28, 18), (28, 16);

-- Blanche (29) - Byredo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(29, 9), (29, 19), (29, 21);

-- Bibliothèque (30) - Byredo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(30, 21), (30, 17), (30, 19);

-- Santal 33 (31) - Le Labo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(31, 14), (31, 15), (31, 7);

-- Another 13 (32) - Le Labo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(32, 45), (32, 46), (32, 21);

-- Rose 31 (33) - Le Labo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(33, 9), (33, 13), (33, 15);

-- Bergamote 22 (34) - Le Labo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(34, 1), (34, 27), (34, 16);

-- Thé Noir 29 (35) - Le Labo
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(35, 1), (35, 15), (35, 21);

-- Baccarat Rouge 540 (36) - MFK
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(36, 22), (36, 8), (36, 45), (36, 15);

-- Aqua Universalis (37) - MFK
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(37, 1), (37, 35), (37, 21);

-- Oud Satin Mood (38) - MFK
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(38, 43), (38, 9), (38, 37), (38, 18);

-- 724 (39) - MFK
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(39, 1), (39, 8), (39, 21);

-- Petit Matin (40) - MFK
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(40, 23), (40, 2), (40, 4), (40, 21);

-- Paradigme (41) - Prada
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(41, 44), (41, 50), (41, 11), (41, 1);

-- L'Homme Intense (42) - Prada
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(42, 36), (42, 20), (42, 17);

-- Paradoxe (43) - Prada
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(43, 34), (43, 8), (43, 20);

-- Luna Rossa Ocean (44) - Prada
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(44, 27), (44, 42), (44, 19), (44, 18);

-- Infusion d'Iris (45) - Prada
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(45, 36), (45, 26), (45, 15);

-- Uomo Intense (46) - Valentino
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(46, 36), (46, 48), (46, 21);

-- Voce Viva (47) - Valentino
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(47, 26), (47, 35), (47, 18);

-- Donna Born in Roma (48) - Valentino
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(48, 8), (48, 18);

-- Uomo Born in Roma (49) - Valentino
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(49, 37), (49, 16);

-- V Pour Homme (50) - Valentino
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(50, 1), (50, 4), (50, 15);

-- Gentleman Reserve Privée (51) - Givenchy
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(51, 1), (51, 36), (51, 15);

-- L'Interdit (52) - Givenchy
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(52, 35), (52, 8), (52, 17);

-- Irresistible (53) - Givenchy
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(53, 9), (53, 21);

-- Gentleman Eau de Parfum Boisée (54) - Givenchy
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(54, 54), (54, 36), (54, 19);

-- Ange ou Démon (55) - Givenchy
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(55, 22), (55, 10), (55, 48), (55, 18);

-- Elysium (56) - Roja Parfums
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(56, 27), (56, 4), (56, 15), (56, 16);

-- Enigma (57) - Roja Parfums
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(57, 43), (57, 20);

-- Scandal (58) - Roja Parfums
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(58, 1), (58, 17), (58, 18);

-- Dove (59) - Roja Parfums
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(59, 9), (59, 8), (59, 36), (59, 18);

-- Apex (60) - Roja Parfums
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(60, 4), (60, 15), (60, 21);

-- Interlude Man (61) - Amouage
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(61, 1), (61, 42), (61, 20);

-- Reflection Man (62) - Amouage
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(62, 5), (62, 34), (62, 8), (62, 15);

-- Jubilation XXV (63) - Amouage
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(63, 3), (63, 42), (63, 43), (63, 17);

-- Memoir Woman (64) - Amouage
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(64, 9), (64, 42), (64, 21);

-- Gold Man (65) - Amouage
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
(65, 22), (65, 42), (65, 36);

-- Relaciones perfume_ocasiones para nuevos perfumes
INSERT INTO perfume_ocasiones (perfume_id, ocasion_id) VALUES
-- Hermès
(16, 1), (16, 5),
(17, 2), (17, 4), (17, 6),
(18, 2), (18, 4),
(19, 1), (19, 3),
(20, 1), (20, 7),
-- Guerlain
(21, 2), (21, 4), (21, 8),
(22, 1), (22, 5),
(23, 2), (23, 4),
(24, 2), (24, 3),
(25, 1), (25, 3),
-- Byredo
(26, 1), (26, 2), (26, 5),
(27, 2), (27, 4),
(28, 1), (28, 5),
(29, 1), (29, 3),
(30, 1), (30, 3), (30, 8),
-- Le Labo
(31, 1), (31, 2), (31, 3),
(32, 1), (32, 3),
(33, 2), (33, 4),
(34, 1), (34, 5),
(35, 1), (35, 3), (35, 8),
-- MFK
(36, 2), (36, 4),
(37, 1), (37, 3),
(38, 2), (38, 4), (38, 6),
(39, 1), (39, 3),
(40, 1), (40, 7),
-- Prada
(41, 1), (41, 3),
(42, 2), (42, 4),
(43, 1), (43, 3),
(44, 1), (44, 5),
(45, 1), (45, 3), (45, 7),
-- Valentino
(46, 2), (46, 4),
(47, 1), (47, 3),
(48, 1), (48, 2),
(49, 1), (49, 3),
(50, 1), (50, 3),
-- Givenchy
(51, 2), (51, 3), (51, 4),
(52, 2), (52, 4),
(53, 1), (53, 3),
(54, 2), (54, 6),
(55, 2), (55, 4),
-- Roja Parfums
(56, 1), (56, 3), (56, 5),
(57, 2), (57, 4), (57, 6),
(58, 2), (58, 4),
(59, 1), (59, 3),
(60, 1), (60, 3),
-- Amouage
(61, 2), (61, 4), (61, 6),
(62, 1), (62, 3),
(63, 2), (63, 4),
(64, 2), (64, 4),
(65, 2), (65, 4), (65, 6)
ON CONFLICT DO NOTHING;
