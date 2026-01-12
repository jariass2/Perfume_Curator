# Paymsa - Mejoras al Sistema de Matching

**Fecha**: 6 de Enero, 2026
**Versión**: 1.0 - Propuesta de Mejoras
**Estado**: En investigación

---

## 📊 Análisis del Sistema Actual

### Factores de Matching Actuales

| Factor | Peso | Puntos Max | Tipo |
|--------|------|------------|------|
| **Familia Olfativa** | 25% | 25 pts | Crítico |
| **Notas Preferidas** | 25% | 25 pts | Crítico |
| **Ocasiones** | 20% | 20 pts | Importante |
| **Notas Rechazadas** | - | -15 pts/nota | Penalización |
| **Género** | 10% | 10 pts | Básico |
| **Intensidad** | 10% | 10 pts | Básico |
| **Popularidad** | 10% | 10 pts | Bonus |
| **Marca Preferida** | - | +15 pts | Bonus (aprendido) |

**Total Máximo**: ~100 puntos

### Preguntas Actuales del Cuestionario

1. **Género** (requerido) - Masculino / Femenino / Unisex
2. **Intensidad** (opcional) - Todas / Eau de Toilette / Eau de Parfum / Parfum / Extrait
3. **Familia Olfativa** (opcional) - Cualquiera / Cítrica / Floral / Amaderada / Oriental / Aromática
4. **Ocasiones** (múltiple) - Diario / Nocturno / Formal / Casual / Deportivo / Íntimo / Profesional / Especial
5. **Notas Deseadas** (múltiple) - 20+ notas filtradas por familia
6. **Notas a Evitar** (múltiple) - 20+ notas filtradas por familia

---

## 🎯 Mejoras Propuestas

### Nivel 1: Factores Personales (Nuevos)

#### 1.1 Edad / Rango Etario
**Justificación**: Las preferencias olfativas evolucionan con la edad.

**Pregunta**:
```
¿En qué rango de edad te encuentras?
○ 18-25 años
○ 26-35 años
○ 36-45 años
○ 46-55 años
○ 56+ años
○ Prefiero no especificar
```

**Impacto en Matching**:
- 18-25: Preferencia por frescas, cítricas, florales ligeras (+5 pts si es fresco/joven)
- 26-35: Versatilidad, orientales moderadas, amaderas ligeras
- 36-45: Sofisticación, orientales, amaderas, intensidades medias-altas
- 46-55+: Clásicos, elegancia, orientales profundas, amaderas nobles

**Implementación**:
```python
def ajuste_edad(perfume, rango_edad):
    if rango_edad == "18-25":
        if perfume['familia'] in ['Cítrica', 'Floral']:
            return +5
        if perfume['intensidad'] in ['Extrait', 'Parfum']:
            return -3
    elif rango_edad == "36-45":
        if perfume['familia'] in ['Oriental', 'Amaderada']:
            return +5
        if perfume['ano_lanzamiento'] < 2000:  # Clásicos
            return +3
    # ... más lógica
    return 0
```

#### 1.2 Tipo de Piel
**Justificación**: La química de la piel afecta cómo se desarrolla un perfume.

**Pregunta**:
```
¿Cómo describirías tu tipo de piel?
○ Piel seca (perfumes duran menos, necesito más intensidad)
○ Piel normal (duración estándar)
○ Piel grasa (perfumes duran más, puedo usar intensidades ligeras)
○ No estoy seguro/a
```

**Impacto en Matching**:
- **Piel seca**: +5 pts a Parfum/Extrait, +3 pts a orientales/amaderas (más duraderas)
- **Piel grasa**: +5 pts a EDT, +3 pts a cítricas/florales ligeras

#### 1.3 Clima / Estación Preferida
**Justificación**: Los perfumes se comportan diferente según temperatura y humedad.

**Pregunta**:
```
¿En qué estación/clima usarás principalmente el perfume?
○ Todo el año (clima templado)
○ Primavera (fresco y floral)
○ Verano (calor, necesito frescura)
○ Otoño (transición, elegancia)
○ Invierno (frío, necesito calidez)
```

**Impacto en Matching**:
```python
estacion_match = {
    'Verano': {
        'familias_favoritas': ['Cítrica', 'Aromática'],
        'bonus': +8,
        'intensidades_favoritas': ['Eau de Toilette', 'Eau de Parfum'],
        'notas_favoritas': ['Bergamota', 'Limón', 'Lavanda']
    },
    'Invierno': {
        'familias_favoritas': ['Oriental', 'Amaderada'],
        'bonus': +8,
        'intensidades_favoritas': ['Parfum', 'Extrait'],
        'notas_favoritas': ['Vainilla', 'Ámbar', 'Cuero']
    }
}
```

### Nivel 2: Contexto de Uso (Ampliado)

#### 2.1 Estilo de Vida
**Pregunta**:
```
¿Cómo describes tu estilo de vida?
☐ Activo/Deportivo (gimnasio, actividades al aire libre)
☐ Profesional corporativo (oficina, reuniones)
☐ Creativo/Artístico (expresión personal)
☐ Social/Nocturno (eventos, fiestas)
☐ Casual/Relajado (día a día simple)
☐ Elegante/Formal (eventos de gala)
```

**Impacto**:
- Activo/Deportivo → Frescos, aromáticos, baja intensidad
- Profesional → Sobrios, amaderas, orientales moderadas
- Creativo → Nicho, únicos, olfativas inusuales
- Social/Nocturno → Intensos, sensuales, proyección alta

#### 2.2 Duración Deseada
**Pregunta**:
```
¿Cuánto tiempo quieres que dure el perfume?
○ 2-4 horas (ligero, fresco)
○ 4-6 horas (moderado, día completo)
○ 6-8 horas (largo, de día a noche)
○ 8+ horas (muy largo, todo el día)
○ No me importa
```

**Impacto**: Influye en intensidad y familia
- 2-4h → EDT, Cítricas
- 8+h → Extrait/Parfum, Orientales/Amaderas

#### 2.3 Proyección (Sillage) Deseada
**Pregunta**:
```
¿Qué tan presente quieres que sea tu perfume?
○ Íntimo (solo yo lo percibo)
○ Cercano (solo quienes están muy cerca)
○ Moderado (se nota en un radio de 1-2m)
○ Fuerte (se nota al entrar a una habitación)
```

**Impacto en Matching**:
```python
proyeccion_factor = {
    'Íntimo': {'intensidad': ['Eau de Toilette'], 'bonus': 5},
    'Fuerte': {'intensidad': ['Parfum', 'Extrait'], 'bonus': 5}
}
```

### Nivel 3: Experiencia Previa (Nuevas Preguntas)

#### 3.1 Perfume Favorito Anterior
**Pregunta**:
```
¿Tienes algún perfume que te haya gustado especialmente?
[Input de texto con sugerencias]

Sugerencias populares:
- Dior Sauvage
- Chanel N°5
- Tom Ford Black Orchid
- Creed Aventus
- YSL Black Opium
- No tengo uno favorito
```

**Impacto**:
- Análisis de notas del perfume favorito
- Recomendación de similares (+20 pts bonus)
- Identificación de familias preferidas

**Implementación**:
```python
def analizar_perfume_favorito(perfume_nombre):
    # Buscar en base de datos
    favorito = db.query(Perfume).filter(nombre=perfume_nombre).first()
    if favorito:
        return {
            'familia': favorito.familia,
            'notas': favorito.notas,
            'intensidad': favorito.intensidad,
            'similares_ids': buscar_similares(favorito.id)
        }
```

#### 3.2 Experiencia con Perfumes
**Pregunta**:
```
¿Cuál es tu experiencia con perfumes?
○ Principiante (es mi primer perfume de lujo)
○ Conocedor (tengo varios, conozco familias)
○ Experto/Coleccionista (tengo colección extensa)
```

**Impacto**:
- Principiante → Recomendaciones clásicas, versátiles, seguras
- Experto → Perfumes nicho, audaces, complejos

### Nivel 4: Aspectos Psicológicos y Emocionales

#### 4.1 Personalidad Olfativa
**Pregunta**:
```
¿Cómo te describirías? (selecciona 2-3)
☐ Clásico/Atemporal
☐ Moderno/Vanguardista
☐ Romántico/Soñador
☐ Aventurero/Audaz
☐ Sofisticado/Elegante
☐ Natural/Auténtico
☐ Seductor/Sensual
☐ Enérgico/Vibrante
```

**Mapeo Personalidad → Perfume**:
```python
personalidad_mapping = {
    'Clásico/Atemporal': {
        'perfumes': ['Chanel N°5', 'Dior Homme', 'Guerlain Shalimar'],
        'familias': ['Floral', 'Oriental'],
        'caracteristicas': ['lanzamiento < 2000', 'popularidad > 4.5']
    },
    'Moderno/Vanguardista': {
        'perfumes': ['Le Labo Santal 33', 'Byredo', 'MFK'],
        'familias': ['Aromática', 'Nicho'],
        'caracteristicas': ['lanzamiento > 2015', 'marca_nicho = true']
    },
    'Aventurero/Audaz': {
        'familias': ['Oriental', 'Especiada'],
        'notas': ['Oud', 'Cuero', 'Incienso'],
        'intensidad': ['Extrait', 'Parfum']
    }
}
```

#### 4.2 Emociones que Desea Evocar
**Pregunta**:
```
¿Qué emociones o sensaciones quieres transmitir?
☐ Confianza y poder
☐ Elegancia y sofisticación
☐ Frescura y vitalidad
☐ Calidez y comodidad
☐ Misterio y seducción
☐ Alegría y optimismo
```

**Mapeo Emociones → Características**:
- Confianza → Amaderas nobles, orientales, alta proyección
- Frescura → Cítricas, aromáticas, EDT
- Misterio → Orientales oscuras, oud, especiadas

### Nivel 5: Preferencias de Marca y Presupuesto

#### 5.1 Rango de Presupuesto
**Pregunta**:
```
¿Cuál es tu rango de inversión? (100ml)
○ Abierto a todas las opciones
○ Hasta €150 (accesible lujo)
○ €150-€300 (lujo medio)
○ €300-€500 (lujo alto)
○ €500+ (alta perfumería)
```

**Impacto**: Filtrar perfumes fuera de rango antes del matching

#### 5.2 Marcas de Interés
**Pregunta**:
```
¿Hay marcas que te interesen especialmente?
☐ Hermès
☐ Guerlain
☐ Chanel
☐ Dior
☐ Tom Ford
☐ Byredo
☐ Le Labo
☐ Maison Francis Kurkdjian
☐ Roja Parfums
☐ Amouage
☐ No tengo preferencia
```

**Impacto**: +10 pts bonus si la marca está en la lista

---

## 🧮 Algoritmo de Matching Mejorado

### Nuevo Sistema de Puntuación

| Categoría | Subcategoría | Peso | Puntos Max |
|-----------|--------------|------|------------|
| **Perfil Olfativo** | Familia | Crítico | 20 pts |
| | Notas Preferidas | Crítico | 20 pts |
| | Notas Rechazadas | Penalización | -15 pts/nota |
| | Intensidad | Importante | 8 pts |
| **Contexto Personal** | Edad | Importante | 8 pts |
| | Tipo de Piel | Moderado | 5 pts |
| | Clima/Estación | Importante | 8 pts |
| **Uso y Aplicación** | Ocasiones | Importante | 12 pts |
| | Duración Deseada | Moderado | 5 pts |
| | Proyección | Moderado | 5 pts |
| | Estilo de Vida | Importante | 7 pts |
| **Experiencia** | Perfume Favorito | Bonus | +20 pts |
| | Nivel de Experiencia | Moderador | ±5 pts |
| **Psicológico** | Personalidad | Importante | 10 pts |
| | Emociones Deseadas | Moderado | 7 pts |
| **Marca y Precio** | Presupuesto | Filtro | Exclusión |
| | Marca Preferida | Bonus | +10 pts |
| | Popularidad | Bonus | +10 pts |

**Total Máximo**: ~135 puntos (sin bonuses)
**Con Bonuses**: Hasta ~165 puntos

### Fórmula de Compatibilidad

```python
def calcular_compatibilidad_avanzada(perfume, perfil_usuario):
    score = 0
    desglose = {}

    # 1. PERFIL OLFATIVO (48 pts max)
    score += match_familia(perfume, perfil_usuario)  # 20 pts
    score += match_notas_preferidas(perfume, perfil_usuario)  # 20 pts
    score -= penalizacion_notas_rechazadas(perfume, perfil_usuario)  # -15/nota
    score += match_intensidad(perfume, perfil_usuario)  # 8 pts

    # 2. CONTEXTO PERSONAL (21 pts max)
    score += ajuste_edad(perfume, perfil_usuario['edad'])  # 8 pts
    score += ajuste_tipo_piel(perfume, perfil_usuario['piel'])  # 5 pts
    score += match_estacion(perfume, perfil_usuario['estacion'])  # 8 pts

    # 3. USO Y APLICACIÓN (29 pts max)
    score += match_ocasiones(perfume, perfil_usuario)  # 12 pts
    score += match_duracion(perfume, perfil_usuario['duracion'])  # 5 pts
    score += match_proyeccion(perfume, perfil_usuario['proyeccion'])  # 5 pts
    score += match_estilo_vida(perfume, perfil_usuario['estilo_vida'])  # 7 pts

    # 4. EXPERIENCIA (25 pts max)
    if perfil_usuario.get('perfume_favorito'):
        score += bonus_perfume_similar(perfume, perfil_usuario['perfume_favorito'])  # +20 pts
    score += ajuste_experiencia(perfume, perfil_usuario['nivel_experiencia'])  # ±5 pts

    # 5. PSICOLÓGICO (17 pts max)
    score += match_personalidad(perfume, perfil_usuario['personalidad'])  # 10 pts
    score += match_emociones(perfume, perfil_usuario['emociones'])  # 7 pts

    # 6. MARCA Y POPULARIDAD (20 pts max bonus)
    if perfil_usuario.get('marcas_preferidas'):
        if perfume['marca'] in perfil_usuario['marcas_preferidas']:
            score += 10
    score += (perfume['popularidad'] / 5.0) * 10  # 10 pts max

    # Convertir a porcentaje de compatibilidad
    compatibilidad = min(100, (score / 140) * 100)  # 140 = puntos base sin bonuses extremos

    return round(compatibilidad, 1), desglose
```

---

## 📝 Propuesta de Cuestionario Revisado

### Versión Corta (7 pasos - Recomendado para UX)

1. **Género** (existente)
2. **Familia & Notas** (combinar pasos 3, 5, 6)
3. **Ocasión & Estilo de Vida** (combinar pasos 4 + nuevo)
4. **Perfil Personal** (NUEVO: edad, piel, clima)
5. **Preferencias de Uso** (NUEVO: duración, proyección)
6. **Personalidad** (NUEVO: rasgos, emociones)
7. **Experiencia** (NUEVO: perfume favorito, nivel)

### Versión Completa (12 pasos - Para usuarios que quieren máxima precisión)

**Opción al inicio**:
```
¿Prefieres un cuestionario rápido o detallado?
○ Rápido (7 pasos, ~2 minutos)
○ Detallado (12 pasos, ~4 minutos)
```

---

## 🔬 Mejoras Técnicas al Algoritmo

### 1. Machine Learning para Pesos Dinámicos

En lugar de pesos fijos, entrenar un modelo que aprenda qué factores son más predictivos:

```python
from sklearn.ensemble import RandomForestRegressor

# Entrenar con datos históricos
# X = features (edad, familia, notas, etc.)
# y = satisfacción del usuario (rating, compra, tiempo de uso)

model = RandomForestRegressor()
model.fit(X_train, y_train)

# Obtener importancia de features
feature_importance = model.feature_importances_
```

### 2. Collaborative Filtering Mejorado

Usar similitud de usuarios más sofisticada:

```python
def similitud_usuarios_avanzada(usuario_a, usuario_b):
    score = 0

    # Similitud demográfica
    if usuario_a['edad'] == usuario_b['edad']:
        score += 10
    if usuario_a['genero'] == usuario_b['genero']:
        score += 10

    # Similitud de preferencias
    familias_comunes = set(usuario_a['familias']) & set(usuario_b['familias'])
    score += len(familias_comunes) * 5

    # Similitud de perfumes favoritos
    favoritos_comunes = set(usuario_a['favoritos']) & set(usuario_b['favoritos'])
    score += len(favoritos_comunes) * 15

    return score
```

### 3. Sistema de Confianza por Factor

No todos los usuarios saben igual sobre todos los factores:

```python
def calcular_confianza_factor(usuario, factor):
    """
    Calcula qué tan confiable es la respuesta del usuario en cada factor
    """
    if factor == 'familia_olfativa':
        if usuario['nivel_experiencia'] == 'Experto':
            return 1.0  # Confianza total
        elif usuario['nivel_experiencia'] == 'Conocedor':
            return 0.7
        else:
            return 0.4  # Dar menos peso a la elección de principiantes

    if factor == 'tipo_piel':
        # Si dejó "No estoy seguro", confianza baja
        if usuario['piel'] == 'No estoy seguro':
            return 0.2
        return 0.8

    return 1.0  # Por defecto
```

---

## 📊 A/B Testing Plan

### Test 1: Cuestionario Corto vs. Largo
- **Grupo A**: Cuestionario actual (6 pasos)
- **Grupo B**: Cuestionario corto (7 pasos con nuevas preguntas)
- **Grupo C**: Cuestionario largo (12 pasos)
- **Métricas**: Tasa de completación, satisfacción con recomendaciones

### Test 2: Pesos de Factores
- **Grupo A**: Pesos actuales
- **Grupo B**: Pesos nuevos propuestos
- **Grupo C**: Pesos aprendidos por ML
- **Métricas**: CTR, conversión, ratings

---

## 🎯 Priorización de Implementación

### Fase 1 (Quick Wins - 1 semana)
- ✅ Edad/Rango etario
- ✅ Clima/Estación preferida
- ✅ Perfume favorito anterior (input texto)
- ✅ Presupuesto (filtro)

### Fase 2 (Medium Effort - 2 semanas)
- ⏳ Tipo de piel
- ⏳ Duración y proyección deseadas
- ⏳ Estilo de vida
- ⏳ Nivel de experiencia

### Fase 3 (Complex - 3-4 semanas)
- 🔮 Personalidad olfativa
- 🔮 Emociones a evocar
- 🔮 ML para pesos dinámicos
- 🔮 Collaborative filtering avanzado

---

## 📈 KPIs para Medir Éxito

1. **Tasa de Completación** del cuestionario: > 85%
2. **Compatibilidad Promedio** de top 3 recomendaciones: > 75%
3. **CTR** en resultados: > 40%
4. **Conversión** a favoritos: > 15%
5. **Rating promedio** de recomendaciones: > 4.0/5.0
6. **Tasa de retorno** para nueva búsqueda: < 20% (satisfacción alta)

---

## 🔗 Referencias y Fuentes

*(Pendiente - se completará con resultados de investigación web)*

---

**Estado**: 🟡 Borrador - En proceso de investigación
**Próximos pasos**:
1. ✅ Completar investigación de mercado
2. ⏳ Validar con usuarios potenciales
3. ⏳ Prototipar cuestionario mejorado
4. ⏳ Implementar Fase 1

**Autor**: Claude Code - Session 2026-01-06
