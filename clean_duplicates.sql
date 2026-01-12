-- Limpiar duplicados de perfumes en la base de datos
-- Ejecutar después de verificar el estado actual

-- Paso 1: Eliminar relaciones de perfumes duplicados
DELETE FROM perfume_notas 
WHERE perfume_id NOT IN (SELECT id FROM perfumes WHERE id <= 15);

DELETE FROM perfume_ocasiones 
WHERE perfume_id NOT IN (SELECT id FROM perfumes WHERE id <= 15);

-- Paso 2: Eliminar perfumes duplicados (mantener solo IDs 1-15)
DELETE FROM perfumes 
WHERE id > 15;

-- Paso 3: Verificar resultados
SELECT 
    'Perfumes restantes:' as info,
    COUNT(*) as count
FROM perfumes
UNION ALL
SELECT 
    'Notas de perfume restantes:' as info,
    COUNT(*) as count
FROM perfume_notas
UNION ALL
SELECT 
    'Ocasiones de perfume restantes:' as info,
    COUNT(*) as count
FROM perfume_ocasiones;