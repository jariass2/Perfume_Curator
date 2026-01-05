-- 002_seed_data.sql
-- Datos de ejemplo para Sistema de Perfumería Paymsa

-- Familias Olfativas
INSERT INTO familias_olfativas (nombre, descripcion) VALUES
('Cítrica', 'Fresca, ácida y energética. Notas de limón, naranja, bergamota.'),
('Floral', 'Elegante y romántica. Notas de rosa, jazmín, lavanda, lirio.'),
('Amaderada', 'Cálida y terrosa. Notas de sándalo, cedro, vetiver, pino.'),
('Oriental', 'Dulce y seductora. Notas de vainilla, ámbar, especias, resinas.'),
('Aromática', 'Herbácea y fresca. Notas de lavanda, romero, menta, hierbas.')
ON CONFLICT (nombre) DO NOTHING;

-- Intensidades
INSERT INTO intensidades (nivel, descripcion, duracion_estimada_horas) VALUES
('Eau de Cologne', 'Muy suave, frescura inmediata', 2),
('Eau de Toilette', 'Suave a media, ideal para diario', 4),
('Eau de Parfum', 'Fuerte, buena duración', 8),
('Extrait', 'Muy fuerte, larga duración', 12)
ON CONFLICT (nivel) DO NOTHING;

-- Géneros
INSERT INTO generos (tipo) VALUES
('Masculino'),
('Femenino'),
('Unisex')
ON CONFLICT (tipo) DO NOTHING;

-- Ocasiones
INSERT INTO ocasiones (nombre, temporada) VALUES
('Dia', 'Todo el año'),
('Noche', 'Todo el año'),
('Oficina', 'Todo el año'),
('Fiesta', 'Todo el año'),
('Verano', 'Verano'),
('Invierno', 'Invierno'),
('Primavera', 'Primavera'),
('Otoño', 'Otoño')
ON CONFLICT (nombre) DO NOTHING;

-- Marcas
INSERT INTO marcas (nombre, pais_origen, ano_fundacion) VALUES
('Dior', 'Francia', 1946),
('Chanel', 'Francia', 1910),
('Creed', 'Francia', 1760),
('Armani', 'Italia', 1975),
('Calvin Klein', 'Estados Unidos', 1968),
('Ralph Lauren', 'Estados Unidos', 1967),
('Tom Ford', 'Estados Unidos', 2005),
('Yves Saint Laurent', 'Francia', 1961)
ON CONFLICT (nombre) DO NOTHING;

-- Notas Olfativas
INSERT INTO notas_olfativas (nombre, categoria, familia_id) VALUES
-- Notas de salida
('Bergamota', 'nota_salida', 1),
('Limón', 'nota_salida', 1),
('Naranja', 'nota_salida', 1),
('Lavanda', 'nota_salida', 5),
('Romero', 'nota_salida', 5),
('Pimienta', 'nota_salida', 4),
('Cardamomo', 'nota_salida', 4),
-- Notas de corazón
('Jazmín', 'nota_corazon', 2),
('Rosa', 'nota_corazon', 2),
('Lirio', 'nota_corazon', 2),
('Geranio', 'nota_corazon', 5),
('Clavo', 'nota_corazon', 4),
('Canela', 'nota_corazon', 4),
-- Notas de fondo
('Sándalo', 'nota_fondo', 3),
('Cedro', 'nota_fondo', 3),
('Vetiver', 'nota_fondo', 3),
('Pachuli', 'nota_fondo', 4),
('Vainilla', 'nota_fondo', 4),
('Ámbar', 'nota_fondo', 4),
('Almizcle', 'nota_fondo', 4),
('Cuero', 'nota_fondo', 3)
ON CONFLICT (nombre) DO NOTHING;

-- Perfumes
INSERT INTO perfumes (nombre, marca_id, familia_id, intensidad_id, genero_id, ano_lanzamiento, precio_ml, descripcion, imagen_url, puntuacion_popularidad) VALUES
('Acqua di Gioia', 1, 1, 2, 2, 2010, 120.00, 'Frescura acuática con notas cítricas y florales. Ideal para verano.', 'https://example.com/acqua-di-gioia.jpg', 4.5),
('Dior Sauvage', 1, 5, 3, 1, 2015, 150.00, 'Aromática fresca con bergamota y ambroxan. Versátil para día y noche.', 'https://example.com/sauvage.jpg', 4.8),
('Chanel No. 5', 2, 4, 4, 2, 1921, 250.00, 'Clásico oriental floral con aldehídos, rosa y vainilla. Icono de la perfumería.', 'https://example.com/chanel-no5.jpg', 4.9),
('Creed Aventus', 3, 3, 3, 1, 2010, 450.00, 'Amaderada sofisticada con piña, abedul y roble. Elegancia masculina.', 'https://example.com/creed-aventus.jpg', 4.7),
('CK One', 5, 1, 2, 3, 1994, 80.00, 'Cítrica unisex con bergamota, cardamomo y musgo. Fresca y casual.', 'https://example.com/ck-one.jpg', 4.2),
('Acqua di Gio Profumo', 1, 3, 3, 1, 2015, 160.00, 'Amaderada acuática con bergamota, incienso y pachuli. Profunda y misteriosa.', 'https://example.com/adg-profumo.jpg', 4.6),
('Tom Ford Oud Wood', 7, 3, 4, 1, 2007, 380.00, 'Amaderada rica con oud, sándalo y vetiver. Orientada a lujo masculino.', 'https://example.com/oud-wood.jpg', 4.5),
('YSL La Nuit de L''Homme', 8, 4, 3, 1, 2009, 140.00, 'Oriental seductora con cardamomo, lavanda y vainilla. Perfecta para la noche.', 'https://example.com/la-nuit.jpg', 4.6),
('Ralph Lauren Polo Blue', 6, 1, 2, 1, 2003, 110.00, 'Cítrica fresca con pepino, melón y sándalo. Ideal para verano y deporte.', 'https://example.com/polo-blue.jpg', 4.3),
('Armani Code', 4, 4, 3, 1, 2004, 145.00, 'Oriental moderna con cítricos, olivo y tonka. Elegante para la noche.', 'https://example.com/armani-code.jpg', 4.4),
('Chanel Bleu de Chanel', 2, 5, 3, 1, 2010, 155.00, 'Aromática fresca con menta, lavanda y cedro. Versátil y moderna.', 'https://example.com/bleu.jpg', 4.7),
('Creed Silver Mountain Water', 3, 1, 2, 3, 1995, 420.00, 'Cítrica mineral con bergamota, té verde y musgo. Frescura pura.', 'https://example.com/silver-mountain.jpg', 4.5),
('Dior Homme Intense', 1, 2, 4, 1, 2007, 175.00, 'Floral oscura con iris, ámbar y cuero. Misteriosa y sofisticada.', 'https://example.com/homme-intense.jpg', 4.4),
('Tom Ford Black Orchid', 7, 4, 4, 2, 2006, 350.00, 'Oriental oscura con orquídea, chocolate y vainilla. Seductora nocturna.', 'https://example.com/black-orchid.jpg', 4.6),
('YSL Libre', 8, 2, 3, 2, 2019, 165.00, 'Floral moderna con lavanda, azahar y vainilla. Libre y feminista.', 'https://example.com/libre.jpg', 4.5)
ON CONFLICT DO NOTHING;

-- Relaciones perfume_notas
INSERT INTO perfume_notas (perfume_id, nota_id) VALUES
-- Acqua di Gioia (1)
(1, 2), (1, 7), (1, 14),
-- Dior Sauvage (2)
(2, 1), (2, 4), (2, 19), (2, 21),
-- Chanel No. 5 (3)
(3, 14), (3, 15), (3, 16), (3, 18),
-- Creed Aventus (4)
(4, 1), (4, 18), (4, 20),
-- CK One (5)
(5, 1), (5, 7), (5, 14), (5, 19),
-- Acqua di Gio Profumo (6)
(6, 1), (6, 20), (6, 21),
-- Tom Ford Oud Wood (7)
(7, 19), (7, 20), (7, 18),
-- YSL La Nuit de L'Homme (8)
(8, 7), (8, 4), (8, 18),
-- Ralph Lauren Polo Blue (9)
(9, 2), (9, 19),
-- Armani Code (10)
(10, 1), (10, 16), (10, 18),
-- Chanel Bleu de Chanel (11)
(11, 4), (11, 18), (11, 19),
-- Creed Silver Mountain Water (12)
(12, 1), (12, 19),
-- Dior Homme Intense (13)
(13, 15), (13, 21), (13, 18),
-- Tom Ford Black Orchid (14)
(14, 16), (14, 18), (14, 17),
-- YSL Libre (15)
(15, 4), (15, 14), (15, 18)
ON CONFLICT DO NOTHING;

-- Relaciones perfume_ocasiones
INSERT INTO perfume_ocasiones (perfume_id, ocasion_id) VALUES
-- Acqua di Gioia
(1, 1), (1, 5),
-- Dior Sauvage
(2, 1), (2, 2), (2, 3),
-- Chanel No. 5
(3, 2), (3, 4),
-- Creed Aventus
(4, 3), (4, 2),
-- CK One
(5, 1), (5, 5),
-- Acqua di Gio Profumo
(6, 2), (6, 4),
-- Tom Ford Oud Wood
(7, 2), (7, 4), (7, 7),
-- YSL La Nuit de L'Homme
(8, 2), (8, 4),
-- Ralph Lauren Polo Blue
(9, 1), (9, 5),
-- Armani Code
(10, 2), (10, 4),
-- Chanel Bleu de Chanel
(11, 1), (11, 3),
-- Creed Silver Mountain Water
(12, 1), (12, 5),
-- Dior Homme Intense
(13, 2), (13, 4), (13, 8),
-- Tom Ford Black Orchid
(14, 2), (14, 4),
-- YSL Libre
(15, 1), (15, 3), (15, 5)
ON CONFLICT DO NOTHING;

-- Usuarios de ejemplo
INSERT INTO usuarios (email, nombre, password_hash, preferencias) VALUES
('usuario1@example.com', 'Usuario Uno', 'scrypt:32768:8:1$kCt3VJv9xVvXhXj4$8e9a3b2c1d4e5f6a7b8c9d0e1f2a3b4c', '{"genero": "Masculino", "intensidad": "Media", "notas_preferidas": ["Bergamota", "Lavanda"], "notas_rechazadas": []}'),
('usuario2@example.com', 'Usuario Dos', 'scrypt:32768:8:1$kCt3VJv9xVvXhXj4$8e9a3b2c1d4e5f6a7b8c9d0e1f2a3b4c', '{"genero": "Femenino", "intensidad": "Fuerte", "notas_preferidas": ["Jazmín", "Vainilla"], "notas_rechazadas": ["Pachuli"]}'),
('usuario3@example.com', 'Usuario Tres', 'scrypt:32768:8:1$kCt3VJv9xVvXhXj4$8e9a3b2c1d4e5f6a7b8c9d0e1f2a3b4c', '{"genero": "Unisex", "intensidad": "Suave", "notas_preferidas": ["Limón", "Sándalo"], "notas_rechazadas": []}'),
('usuario4@example.com', 'Usuario Cuatro', 'scrypt:32768:8:1$kCt3VJv9xVvXhXj4$8e9a3b2c1d4e5f6a7b8c9d0e1f2a3b4c', '{"genero": "Masculino", "intensidad": "Fuerte", "notas_preferidas": ["Ámbar", "Cuero"], "notas_rechazadas": ["Floral"]}'),
('usuario5@example.com', 'Usuario Cinco', 'scrypt:32768:8:1$kCt3VJv9xVvXhXj4$8e9a3b2c1d4e5f6a7b8c9d0e1f2a3b4c', '{"genero": "Femenino", "intensidad": "Media", "notas_preferidas": ["Rosa", "Almizcle"], "notas_rechazadas": []}')
ON CONFLICT (email) DO NOTHING;