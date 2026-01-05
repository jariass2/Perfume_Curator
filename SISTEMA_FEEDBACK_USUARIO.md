# Sistema de Feedback y Aprendizaje de Usuario - Paymsa

## 📊 Resumen Ejecutivo

He implementado un **sistema completo de feedback y aprendizaje** que captura y analiza las elecciones de cada usuario para enriquecer el proceso de recomendación de perfumes. El sistema utiliza:

- **Feedback Implícito**: Tracking automático de acciones (vistas, clicks, favoritos)
- **Feedback Explícito**: Valoraciones detalladas y comentarios
- **Machine Learning**: Patrones de comportamiento y preferencias aprendidas
- **Collaborative Filtering**: Recomendaciones basadas en usuarios similares
- **Algoritmo Híbrido**: Combina contenido + comportamiento + usuarios similares

---

## 🎯 Cómo se Enriquece el Proceso con Cada Elección del Usuario

### 1. **Tracking de Interacciones (Feedback Implícito)**

Cada acción del usuario es registrada y analizada:

#### **Tipos de Interacciones Capturadas:**

| Interacción | Significado | Impacto en Recomendaciones |
|------------|-------------|---------------------------|
| **Vista** | Usuario ve perfume en lista | +0.5 puntos de confianza |
| **Click Detalle** | Usuario muestra interés | +1.0 punto, aprende notas/familia |
| **Agregar Favorito** | Usuario ama el perfume | +3.0 puntos, **fuerte señal** de preferencia |
| **Valoración** | Usuario califica 1-5 estrellas | Ponderado según puntuación |
| **Tiempo en Página** | Cuánto tiempo vio detalles | Indicador de interés real |

#### **Ejemplo de Aprendizaje:**

```
Usuario hace click en "Santal 33" (Le Labo)
↓
Sistema aprende automáticamente:
- Familia preferida: "Amaderada" (confianza: 0.7)
- Marca preferida: "Le Labo" (confianza: 0.6)
- Intensidad preferida: "Eau de Parfum" (confianza: 0.5)
- Notas preferidas: "Sándalo", "Cedro", "Cardamomo"

Usuario lo agrega a favoritos
↓
Sistema incrementa confianza:
- Familia preferida: "Amaderada" (confianza: 0.8 → 0.9)
- Veces observado: 2 → 3
```

### 2. **Preferencias Aprendidas Automáticamente**

El sistema identifica patrones sin que el usuario tenga que configurar nada:

#### **Tipos de Preferencias Aprendidas:**

- **Familias Olfativas**: "Le gusta Amaderada", "Evita Cítrica"
- **Marcas Favoritas**: "Prefiere Le Labo, Byredo, MFK"
- **Intensidad**: "Siempre elige Eau de Parfum"
- **Rango de Precio**: "Busca entre €350-500/ml"
- **Notas Específicas**: "Ama Sándalo, Evita Vainilla"
- **Ocasiones de Uso**: "Busca para noche/invierno"

#### **Nivel de Confianza:**

```
0.0 - 0.3: Muy baja (descartada)
0.4 - 0.6: Moderada (considerada)
0.7 - 0.8: Alta (priorizada)
0.9 - 1.0: Muy alta (crítica en recomendaciones)
```

### 3. **Sesiones de Búsqueda Inteligentes**

Cada sesión del usuario es analizada para entender su comportamiento:

#### **Métricas Capturadas por Sesión:**

```javascript
{
  "criterios_busqueda": {
    "genero": "Masculino",
    "familia": "Amaderada",
    "ocasiones": ["Noche", "Invierno"]
  },
  "resultados_mostrados": 15,
  "perfumes_vistos": 5,
  "perfumes_favoriteados": 2,
  "tiempo_sesion_segundos": 420,
  "conversion": true,  // Realizó acción valiosa
  "dispositivo": "desktop",
  "navegador": "chrome"
}
```

#### **Análisis de Conversión:**

- **Tasa de Click (CTR)**: Clicks / Vistas
- **Tasa de Conversión**: Favoritos / Clicks
- **Tiempo Promedio**: Indica nivel de interés
- **Patrón de Navegación**: Exploratorio vs Decisivo

### 4. **Patrones de Comportamiento Identificados**

El sistema clasifica automáticamente a cada usuario:

#### **Tipos de Comportamiento:**

| Patrón | Descripción | Estrategia de Recomendación |
|--------|-------------|----------------------------|
| **Exploratorio** | Ve muchas opciones (>10), baja conversión (<30%) | Mostrar +variedad, +opciones novedosas |
| **Decisivo** | Ve pocas opciones (<5), alta conversión (>50%) | Mostrar -opciones, +precisión, best matches |
| **Coleccionista** | Muchos favoritos (>10) | Recomendar ediciones limitadas, nichos exclusivos |
| **Ocasional** | Uso esporádico | Mostrar populares, seguros, bien valorados |

### 5. **Collaborative Filtering (Usuarios Similares)**

El sistema encuentra usuarios con gustos similares:

#### **Cómo Funciona:**

```
1. Usuario A tiene favoritos: [Santal 33, Baccarat Rouge 540, Oud Wood]

2. Sistema encuentra Usuario B con:
   - Favoritos comunes: [Santal 33, Baccarat Rouge 540]
   - Similitud Jaccard: 0.85 (muy alta)

3. Usuario B también tiene: [Oud Satin Mood, Tobacco Honey]

4. Sistema recomienda a Usuario A:
   → Oud Satin Mood (+2.0 bonus por similar user)
   → Tobacco Honey (+2.0 bonus por similar user)
```

#### **Métricas de Similitud:**

```python
Similitud = Favoritos Comunes / (Total A + Total B - Comunes)

Ejemplo:
A tiene: [1, 2, 3, 4, 5]
B tiene: [3, 4, 5, 6, 7]
Comunes: [3, 4, 5] = 3
Similitud = 3 / (5 + 5 - 3) = 3/7 = 0.43
```

### 6. **Feedback Explícito Enriquecido**

El usuario puede dar feedback detallado:

#### **Sistema de Valoración Multi-Dimensional:**

```javascript
{
  "puntuacion_general": 5,      // Satisfacción global
  "puntuacion_longevidad": 4,   // Duración en piel
  "puntuacion_proyeccion": 5,   // Intensidad/sillage
  "puntuacion_versatilidad": 3, // Usos variados
  "lo_usaria_para": ["Noche", "Invierno", "Fiesta"],
  "temporada_preferida": "invierno",
  "comentario": "Increíble para ocasiones especiales",
  "util": true  // ¿La recomendación fue útil?
}
```

Esto permite al sistema:
- **Afinar recomendaciones de duración** (si valora longevidad alto)
- **Entender contextos de uso** (ocasiones específicas)
- **Mejorar para temporadas** (verano vs invierno)

### 7. **Algoritmo Híbrido de Recomendación**

El motor combina múltiples fuentes:

```
Score Final =
  + Content-Based Score (familia, notas, género)
  + Preferencias Aprendidas (+1.5 si marca favorita)
  + Collaborative Filtering (+2.0 si usuario similar lo ama)
  + Popularidad (puntuación * 0.5)
  - Penalización por notas rechazadas (-3.0)

Ejemplo:
Perfume "Oud Wood"
- Base: +5.0 (match familia amaderada, notas correctas)
- Marca favorita: +1.5 (Tom Ford es preferida aprendida)
- Usuario similar: +2.0 (usuario 85% similar lo tiene)
- Popularidad: +2.3 (4.6 * 0.5)
- Total: 10.8 → 100% match
```

---

## 📈 Métricas del Sistema

### **Dashboard de Usuario (Vista Personal):**

```javascript
{
  "total_interacciones": 145,
  "perfumes_vistos": 42,
  "detalles_vistos": 18,
  "favoritos_actuales": 7,
  "perfumes_valorados": 5,
  "valoracion_promedio": 4.2,
  "sesiones_totales": 12,
  "tiempo_promedio_sesion": 350,  // segundos
  "tasa_conversion": 0.39,        // 39% conversión
  "ultima_interaccion": "2025-01-04 14:30:00",
  "patron_comportamiento": "exploratorio"
}
```

### **Analytics de Perfumes (Vista Showroom):**

```javascript
{
  "id": 36,
  "nombre": "Baccarat Rouge 540",
  "marca": "Maison Francis Kurkdjian",
  "usuarios_unicos": 87,
  "vistas": 245,
  "clicks": 98,
  "favoritos": 42,
  "valoraciones": 28,
  "valoracion_promedio": 4.8,
  "ctr": 0.40,              // 40% click-through rate
  "tasa_conversion": 0.43   // 43% de clicks → favoritos
}
```

---

## 🔄 Ciclo de Mejora Continua

```
┌─────────────────────────────────────┐
│  Usuario Interactúa con Perfumes   │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  Sistema Registra Interacciones     │
│  - Vistas, Clicks, Favoritos        │
│  - Valoraciones, Tiempo             │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  Análisis de Patrones               │
│  - Preferencias Aprendidas          │
│  - Comportamiento del Usuario       │
│  - Similitud con Otros              │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  Motor de Recomendación Actualizado │
│  - Algoritmo Híbrido Refinado       │
│  - Scores Personalizados            │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  Recomendaciones Mejoradas          │
│  (Más Precisas y Personalizadas)    │
└──────────────┬──────────────────────┘
               ↓
        (Ciclo se repite)
```

---

## 🗄️ Estructura de Base de Datos

### **Tablas Principales:**

1. **`interacciones_usuario`**: Todas las acciones (vistas, clicks, favoritos, valoraciones)
2. **`sesiones_busqueda`**: Métricas de cada sesión de búsqueda
3. **`feedback_explicito`**: Valoraciones detalladas multi-dimensionales
4. **`preferencias_aprendidas`**: Preferencias inferidas automáticamente
5. **`similitud_usuarios`**: Matriz de similitud entre usuarios
6. **`patrones_comportamiento`**: Clasificación de usuarios
7. **`experimentos_recomendacion`**: A/B testing de algoritmos

### **Vistas Analíticas:**

- **`metricas_usuario`**: Dashboard completo por usuario
- **`perfumes_popularidad`**: Rankings con CTR, conversión
- **`perfil_usuario_enriquecido`**: Perfil 360° del usuario

---

## 🚀 Beneficios del Sistema

### **Para el Usuario:**

✅ **Recomendaciones cada vez más precisas** sin esfuerzo
✅ **Descubre perfumes que realmente le gustarán** (basado en comportamiento real)
✅ **Ahorra tiempo** (menos opciones irrelevantes)
✅ **Experiencia personalizada** única

### **Para el Showroom:**

📊 **Analytics profundos** de preferencias de clientes
🎯 **Optimización de inventario** (qué perfumes traer)
💰 **Mayor conversión** (recomendaciones precisas = más ventas)
🔬 **A/B Testing** de algoritmos de recomendación
📈 **KPIs medibles**: CTR, conversión, engagement

---

## 💡 Ejemplo de Uso Completo

### **Escenario: Nuevo Usuario**

```
Día 1: Usuario se registra, completa cuestionario
→ Preferencias explícitas guardadas
→ Recibe 10 recomendaciones basadas en respuestas

Día 2: Usuario navega, ve 5 perfumes, hace click en 2
→ Sistema aprende: prefiere "Amaderada", "Le Labo"
→ Próximas recomendaciones priorizan amaderadas

Día 3: Usuario agrega "Santal 33" a favoritos
→ Sistema actualiza:
   - Familia Amaderada: confianza 0.9
   - Marca Le Labo: confianza 0.8
   - Notas: Sándalo, Cedro (preferidas)

Día 7: Usuario busca de nuevo
→ Sistema usa:
   - Preferencias explícitas (cuestionario)
   - Preferencias aprendidas (amaderada, Le Labo)
   - Collaborative filtering (usuarios similares aman Oud Wood)
→ Recomienda: Oud Wood (+2.0 boost), Oud Satin Mood, Bibliothèque
→ ¡Conversión exitosa! Usuario agrega Oud Wood a favoritos

Día 30: Usuario es clasificado como "Coleccionista"
→ Sistema ajusta:
   - Muestra ediciones limitadas
   - Prioriza perfumes de nicho
   - Sugiere marcas exclusivas (Roja Parfums, Amouage)
```

---

## 🔧 Implementación Técnica

### **Archivos Creados:**

1. **`005_user_feedback_system.sql`**: Schema completo de feedback
2. **`user_feedback_service.py`**: Servicio Python para tracking y análisis
3. **Motor de Recomendación Mejorado**: Algoritmo híbrido actualizado

### **Funciones SQL Clave:**

```sql
-- Registrar cualquier interacción
registrar_interaccion(usuario_id, perfume_id, tipo, valor, sesion_id, contexto)

-- Actualizar preferencias automáticamente
actualizar_preferencia_aprendida(usuario_id, tipo, valor, confianza, origen)

-- Trigger automático al agregar favorito
CREATE TRIGGER trigger_aprender_favorito
AFTER INSERT ON favoritos
FOR EACH ROW EXECUTE FUNCTION aprender_de_favorito();
```

### **API Python:**

```python
# Inicializar servicio
feedback_service = UserFeedbackService(db_session)

# Registrar vista
feedback_service.registrar_vista_perfume(
    usuario_id=1,
    perfume_id=36,
    sesion_id="abc-123"
)

# Obtener preferencias aprendidas
preferencias = feedback_service.obtener_preferencias_aprendidas(
    usuario_id=1,
    min_confianza=0.6
)

# Obtener recomendaciones colaborativas
recomendaciones = feedback_service.obtener_recomendaciones_colaborativas(
    usuario_id=1,
    limite=5
)

# Identificar patrón
patron = feedback_service.identificar_patron_comportamiento(usuario_id=1)
```

---

## 📊 A/B Testing y Experimentos

El sistema permite testear diferentes algoritmos:

```sql
-- Crear experimento
INSERT INTO experimentos_recomendacion (nombre, variante, algoritmo_config)
VALUES (
    'Collaborative vs Content-Based',
    'A',
    '{"weight_collaborative": 0.7, "weight_content": 0.3}'
);

-- Asignar usuarios aleatoriamente
-- Medir métricas por variante
-- Seleccionar ganador
```

---

## 🎓 Conclusión

Este sistema transforma **cada elección del usuario en aprendizaje**, creando un **círculo virtuoso** donde:

1. Más interacciones → Mejor comprensión del usuario
2. Mejor comprensión → Recomendaciones más precisas
3. Recomendaciones precisas → Mayor satisfacción
4. Mayor satisfacción → Más interacciones
5. **(El ciclo continúa mejorando infinitamente)**

El resultado es una **experiencia de showroom personalizada y única** para cada cliente, que mejora automáticamente con cada visita. 🎯✨
