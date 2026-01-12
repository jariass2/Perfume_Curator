# Instrucciones para Expansión de Pirámide Olfativa

## Resumen de Cambios Implementados

Se han realizado los siguientes cambios para expandir el sistema de 5 familias a 13 familias profesionales con 300+ notas olfativas:

### ✅ Archivos Creados
1. **`database/schema/006_expansion_familias_profesionales.sql`**
   - 9 nuevas familias olfativas (IDs 6-14)
   - 280+ nuevas notas olfativas clasificadas por:
     - Familia (1-14)
     - Categoría (nota_salida, nota_corazon, nota_fondo)
   - Total: ~800 líneas SQL

### ✅ Archivos Modificados
2. **`app/templates/index.html`** (línea 760-774)
   - Mapeo JavaScript `notasPorFamilia` expandido de 5 a 14 familias
   - Incluye 10-15 notas principales por familia
   - Mantiene familia "Oriental" para compatibilidad

---

## Pasos de Ejecución

### ⚠️ IMPORTANTE: Backup Primero

Antes de ejecutar cualquier cambio, **DEBES hacer backup de la base de datos**:

```bash
# Reemplaza 'usuario' y 'paymsa_db' con tus credenciales reales
pg_dump -U usuario -d paymsa_db > backup_$(date +%Y%m%d_%H%M%S).sql
```

---

### Paso 1: Ejecutar Script SQL

```bash
# Navegar al directorio del proyecto
cd /Users/jordiariassantaella/Development/Perfume_Curator

# Ejecutar el script de expansión (reemplaza con tus credenciales)
psql -U usuario -d paymsa_db -f database/schema/006_expansion_familias_profesionales.sql
```

**Salida esperada**: Deben aparecer mensajes "INSERT 0 X" sin errores.

---

### Paso 2: Verificar Inserción Correcta

Ejecuta estas queries de verificación:

```bash
psql -U usuario -d paymsa_db
```

```sql
-- 1. Verificar total de familias (debe ser 14)
SELECT COUNT(*) FROM familias_olfativas;

-- 2. Verificar total de notas (debe ser ~300+)
SELECT COUNT(*) FROM notas_olfativas;

-- 3. Distribución de notas por familia
SELECT f.nombre, COUNT(n.id) as total_notas
FROM familias_olfativas f
LEFT JOIN notas_olfativas n ON f.id = n.familia_id
GROUP BY f.nombre
ORDER BY f.id;

-- 4. Distribución por categoría (salida/corazón/fondo)
SELECT categoria, COUNT(*)
FROM notas_olfativas
GROUP BY categoria;

-- 5. Verificar integridad referencial (debe retornar 0)
SELECT COUNT(*) FROM notas_olfativas
WHERE familia_id NOT IN (SELECT id FROM familias_olfativas);

-- 6. Verificar perfumes existentes (deben seguir funcionando)
SELECT p.nombre, f.nombre as familia, COUNT(pn.nota_id) as total_notas
FROM perfumes p
JOIN familias_olfativas f ON p.familia_id = f.id
LEFT JOIN perfume_notas pn ON p.id = pn.perfume_id
GROUP BY p.id, p.nombre, f.nombre;
```

**Resultados esperados:**
- Total familias: **14**
- Total notas: **~300+**
- Distribución balanceada entre salida/corazón/fondo
- Integridad referencial: **0 errores**
- Los 15 perfumes existentes mantienen sus notas

---

### Paso 3: Reiniciar Aplicación

```bash
# Si usas Flask development server
export FLASK_APP=app
flask run

# O si tienes un script personalizado
python run.py
```

---

### Paso 4: Testing Frontend

#### 4.1 Verificar Selector de Familias (Paso 3)

1. Abrir navegador: `http://localhost:5000`
2. Hacer clic en "Comenzar Cuestionario"
3. Completar Paso 1 (Género) y Paso 2 (Intensidad)
4. **En Paso 3 - Familia Olfativa**:
   - ✅ Deben aparecer **14 opciones** (incluye "Cualquiera")
   - ✅ Nuevas familias deben ser: Frutal, Herbácea, Especiada, Animal/Almizclada, Gourmand, Ambarada/Balsámica, Acuática/Marina, Tabaco/Cuero, Musgo/Chypre

#### 4.2 Verificar Filtrado de Notas (Pasos 5-6)

Para cada familia nueva:
1. Seleccionar familia en Paso 3
2. Avanzar al Paso 5 (Notas Deseadas)
3. **Verificar**:
   - ✅ Solo se muestran notas de esa familia
   - ✅ Notas de otras familias están ocultas
   - ✅ Se pueden seleccionar múltiples notas

**Ejemplo con Familia "Gourmand":**
- Debe mostrar: Vainilla, Chocolate, Caramelo, Café, Miel, Vanilina, Maltol, Coumarina, Tonka
- NO debe mostrar: Bergamota, Rosa, Cedro, etc.

4. Ir al Paso 6 (Notas a Evitar)
5. **Verificar**:
   - ✅ Mismas notas que en Paso 5
   - ✅ Si seleccionaste "Vainilla" en Paso 5, debe estar **deshabilitada** en Paso 6

#### 4.3 Verificar Sincronización de Notas

1. En Paso 5, seleccionar "Vainilla"
2. Ir a Paso 6
3. **Verificar**: "Vainilla" debe estar **deshabilitada** (opacidad 40%, cursor not-allowed)
4. Volver a Paso 5, deseleccionar "Vainilla"
5. Ir a Paso 6
6. **Verificar**: "Vainilla" debe estar **habilitada** de nuevo

#### 4.4 Verificar Motor de Recomendaciones

Para cada familia nueva (Frutal, Gourmand, Acuática, etc.):
1. Completar cuestionario seleccionando esa familia
2. **Verificar**:
   - ✅ Aparecen recomendaciones de perfumes
   - ✅ Se muestra el índice de compatibilidad (%)
   - ✅ No hay errores en consola del navegador (F12 → Console)

#### 4.5 Verificar Perfumes Existentes

1. Buscar uno de los 15 perfumes existentes (ej: "Dior Sauvage")
2. **Verificar**:
   - ✅ Se muestra correctamente
   - ✅ Tiene familia asignada (Aromática, Cítrica, etc.)
   - ✅ Muestra notas olfativas
   - ✅ Se puede agregar a favoritos (si estás logueado)

---

### Paso 5: Testing de Consola (Opcional pero Recomendado)

Abre la consola del navegador (F12 → Console) y verifica:

```javascript
// 1. Verificar que el mapeo existe
console.log(Object.keys(notasPorFamilia));
// Debe mostrar: ["Cítrica", "Floral", "Frutal", "Amaderada", "Aromática", "Herbácea", "Especiada", "Animal/Almizclada", "Gourmand", "Ambarada/Balsámica", "Acuática/Marina", "Tabaco/Cuero", "Musgo/Chypre", "Oriental"]

// 2. Verificar una familia específica
console.log(notasPorFamilia['Gourmand']);
// Debe mostrar: ["Vainilla", "Chocolate", "Caramelo", "Café", "Miel", "Vanilina", "Maltol", "Coumarina", "Tonka"]

// 3. Verificar que las funciones existen
console.log(typeof filtrarNotasPorFamilia);  // Debe ser "function"
console.log(typeof sincronizarNotas);         // Debe ser "function"
```

---

## Checklist de Verificación Final

Antes de hacer commit, asegúrate de que:

- [ ] **BD**: 14 familias insertadas correctamente
- [ ] **BD**: ~300+ notas insertadas con categorías correctas
- [ ] **BD**: Integridad referencial verificada (0 errores)
- [ ] **BD**: 15 perfumes existentes funcionan sin cambios
- [ ] **Frontend**: Paso 3 muestra 14 opciones de familia
- [ ] **Frontend**: Filtrado de notas funciona para cada familia
- [ ] **Frontend**: Sincronización notas deseadas/rechazadas funciona
- [ ] **Frontend**: Motor de recomendaciones calcula compatibilidad
- [ ] **Frontend**: No hay errores en consola del navegador
- [ ] **Testing**: Probadas al menos 5 familias nuevas en cuestionario completo

---

## Si Encuentras Errores

### Error: Nombres inconsistentes entre BD y frontend

**Síntoma**: Al seleccionar una familia en Paso 3, no se filtran las notas correctamente.

**Solución**: Verificar que los nombres de las familias en la BD coincidan exactamente con los del mapeo JavaScript.

```sql
-- En BD
SELECT nombre FROM familias_olfativas ORDER BY id;

-- Debe coincidir EXACTAMENTE con las keys de:
const notasPorFamilia = {
    'Cítrica': [...],
    'Floral': [...],
    ...
}
```

### Error: Notas no aparecen en Pasos 5-6

**Síntoma**: Los pasos de notas deseadas/rechazadas están vacíos.

**Solución**: Verificar que las notas en `notasPorFamilia` existan en la BD.

```sql
-- Buscar una nota específica
SELECT * FROM notas_olfativas WHERE nombre = 'Vainilla';

-- Si no existe, verificar el script SQL
```

### Error: Perfumes existentes no funcionan

**Síntoma**: Los 15 perfumes originales muestran errores o datos incorrectos.

**Solución**: Restaurar backup inmediatamente.

```bash
# Restaurar backup
psql -U usuario -d paymsa_db < backup_[fecha].sql
```

---

## Commit de Cambios

Una vez que **TODOS** los tests pasen correctamente:

```bash
cd /Users/jordiariassantaella/Development/Perfume_Curator

git add database/schema/006_expansion_familias_profesionales.sql
git add app/templates/index.html
git add INSTRUCCIONES_EXPANSION.md

git commit -m "$(cat <<'EOF'
feat: Expand olfactory pyramid to 13 professional families with 300+ notes

- Add 9 new olfactory families: Frutal, Herbácea, Especiada,
  Animal/Almizclada, Gourmand, Ambarada/Balsámica, Acuática/Marina,
  Tabaco/Cuero, Musgo/Chypre
- Insert 280+ new olfactory notes classified by family and pyramid category
  (top/middle/base notes)
- Update frontend JavaScript mapping to display 10-15 key notes per family
- Maintain backward compatibility with existing 15 perfumes (no changes to
  family IDs 1-5)
- Classification follows professional perfumery standards based on
  'materias primas familias olfativas.md' document

Tested:
- ✅ 14 families in database
- ✅ 300+ notes with correct categories
- ✅ Frontend filtering works for all families
- ✅ Recommendation engine calculates compatibility
- ✅ Existing perfumes unaffected

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

---

## Rollback (Si es Necesario)

Si algo sale mal y necesitas revertir todos los cambios:

```bash
# 1. Restaurar base de datos
psql -U usuario -d paymsa_db < backup_[fecha].sql

# 2. Revertir cambios de Git
git reset --hard HEAD~1

# 3. Verificar que todo volvió a la normalidad
psql -U usuario -d paymsa_db -c "SELECT COUNT(*) FROM familias_olfativas;"
# Debe retornar: 5
```

---

## Próximos Pasos (Opcional)

Una vez que la expansión esté funcionando correctamente, puedes considerar:

1. **Agregar más perfumes** con las nuevas familias
2. **Crear subfamilias** (ej: "Cítrico dulce", "Cítrico amargo")
3. **Implementar campo de tipo** (natural/sintético) para las notas
4. **Optimizar performance** si las queries se vuelven lentas
5. **Agregar descripciones** detalladas de cada familia en la UI

---

## Soporte

Si encuentras problemas durante la implementación, revisa:
1. Los logs de la aplicación Flask
2. La consola del navegador (F12)
3. Los logs de PostgreSQL
4. El plan original: `/Users/jordiariassantaella/.claude/plans/squishy-plotting-scone.md`

---

**Generado**: 2026-01-12
**Modelo**: Claude Sonnet 4.5
**Tiempo estimado de ejecución**: 30-60 minutos (incluyendo testing)
