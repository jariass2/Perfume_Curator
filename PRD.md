# PRD: Paymsa - Curador de Perfumes Exclusivos

**Documento de Requisitos del Producto**

---

## 📋 Información del Documento

| Campo | Valor |
|-------|-------|
| **Producto** | Paymsa |
| **Versión** | 1.0 |
| **Fecha** | Enero 2026 |
| **Autor** | Equipo Paymsa |
| **Estado** | En Desarrollo |
| **Última actualización** | 5 de Enero, 2026 |

---

## 🎯 Resumen Ejecutivo

Paymsa es una plataforma web de curaduría olfativa que ofrece recomendaciones personalizadas de perfumes de lujo mediante un cuestionario inteligente y un motor de recomendaciones avanzado. La aplicación combina elegancia visual inspirada en Hermès con tecnología de machine learning para crear una experiencia única de descubrimiento de fragancias.

### Propuesta de Valor
- **Para usuarios**: Descubrir perfumes perfectamente alineados con sus preferencias sin necesidad de visitar tiendas físicas
- **Para la marca**: Posicionarse como curador experto en fragancias de lujo con tecnología de vanguardia
- **Diferenciador**: Índice de compatibilidad detallado + interfaz de lujo + filtrado inteligente por familias olfativas

---

## 👥 Usuarios Objetivo

### Persona Primaria: "El Conocedor Sofisticado"
- **Demografía**: 30-55 años, ingresos altos, educación superior
- **Comportamiento**: Aprecia productos de lujo, investiga antes de comprar
- **Necesidades**: Descubrir fragancias exclusivas que coincidan con su estilo personal
- **Frustraciones**: Perfumerías genéricas, falta de orientación personalizada, pérdida de tiempo

### Persona Secundaria: "El Comprador de Regalo"
- **Demografía**: 25-50 años, busca regalos especiales
- **Comportamiento**: Investiga opciones de regalo, valora la presentación y exclusividad
- **Necesidades**: Encontrar el perfume perfecto para regalar sin conocimientos técnicos
- **Frustraciones**: No saber qué comprar, miedo a equivocarse, opciones abrumadoras

### Persona Terciaria: "El Entusiasta Curioso"
- **Demografía**: 20-40 años, interesado en aprender sobre perfumería
- **Comportamiento**: Explora nuevas fragancias, lee reseñas, colecciona perfumes
- **Necesidades**: Descubrir fragancias únicas, aprender sobre notas olfativas
- **Frustraciones**: Información dispersa, dificultad para filtrar opciones

---

## 🎨 Características del Producto

### 1. Sistema de Onboarding y Autenticación

#### 1.1 Registro de Usuario
**Descripción**: Proceso simplificado de creación de cuenta

**Requisitos Funcionales**:
- RF-1.1.1: Formulario con campos: nombre, email, contraseña, confirmar contraseña
- RF-1.1.2: Validación en tiempo real de formato de email
- RF-1.1.3: Validación de coincidencia de contraseñas
- RF-1.1.4: Hash seguro de contraseñas (bcrypt)
- RF-1.1.5: Auto-login después de registro exitoso
- RF-1.1.6: Redirección automática al cuestionario

**Requisitos No Funcionales**:
- RNF-1.1.1: Tiempo de registro < 3 segundos
- RNF-1.1.2: Modal responsive que funciona en todos los dispositivos
- RNF-1.1.3: Mensajes de error claros y en español

**Criterios de Aceptación**:
- ✅ Usuario puede registrarse con datos válidos
- ✅ Sistema rechaza emails duplicados
- ✅ Contraseñas se almacenan hasheadas
- ✅ Redirección automática al cuestionario tras registro

#### 1.2 Inicio de Sesión
**Descripción**: Acceso seguro para usuarios registrados

**Requisitos Funcionales**:
- RF-1.2.1: Formulario con email y contraseña
- RF-1.2.2: Verificación de credenciales contra base de datos
- RF-1.2.3: Sesión persistente con Flask-Login
- RF-1.2.4: Opción de cerrar sesión

**Criterios de Aceptación**:
- ✅ Usuario autenticado accede a funcionalidades completas
- ✅ Credenciales incorrectas muestran mensaje de error
- ✅ Sesión persiste entre recargas de página

---

### 2. Cuestionario de Preferencias Olfativas

#### 2.1 Arquitectura del Cuestionario
**Descripción**: Wizard de 6 pasos para capturar preferencias del usuario

**Estructura**:
```
Paso 1: Género (requerido)
Paso 2: Intensidad (opcional)
Paso 3: Familia Olfativa (opcional)
Paso 4: Ocasiones (opcional, múltiple)
Paso 5: Notas Deseadas (opcional, múltiple, filtrado por familia)
Paso 6: Notas a Evitar (opcional, múltiple, filtrado por familia)
```

#### 2.2 Paso 1: Selección de Género
**Requisitos Funcionales**:
- RF-2.2.1: Opciones: Masculino, Femenino, Unisex
- RF-2.2.2: Selección única (radio button)
- RF-2.2.3: Campo obligatorio - no permite avanzar sin selección
- RF-2.2.4: Validación antes de pasar al siguiente paso

**Diseño UI**:
- Tarjetas rectangulares de 112px altura (h-28)
- Borde naranja en hover
- Borde naranja y fondo naranja/5 cuando seleccionado
- Grid de 3 columnas en desktop

#### 2.3 Paso 2: Intensidad del Perfume
**Requisitos Funcionales**:
- RF-2.3.1: Opciones: Todas, Eau de Cologne, Eau de Toilette, Eau de Parfum, Extrait
- RF-2.3.2: Selección única (radio button)
- RF-2.3.3: Campo opcional - puede avanzar sin selección
- RF-2.3.4: "Todas" seleccionada por defecto

**Información de Producto**:
- Eau de Cologne: 2-5% concentración
- Eau de Toilette: 5-15% concentración
- Eau de Parfum: 15-20% concentración
- Extrait: 20-40% concentración

#### 2.4 Paso 3: Familia Olfativa
**Requisitos Funcionales**:
- RF-2.4.1: Opciones: Cualquiera, Cítrica, Floral, Amaderada, Oriental, Aromática
- RF-2.4.2: Selección única (radio button)
- RF-2.4.3: Campo opcional
- RF-2.4.4: **CRÍTICO**: Selección dispara filtrado de notas en pasos 5 y 6

**Lógica de Filtrado**:
```javascript
Familias → Notas Compatibles:
- Cítrica: Bergamota, Limón, Naranja, Lavanda, Romero
- Floral: Jazmín, Rosa, Lirio, Geranio, Bergamota, Vainilla, Ámbar
- Amaderada: Sándalo, Cedro, Vetiver, Pachuli, Cuero, Bergamota, Pimienta
- Oriental: Vainilla, Ámbar, Almizcle, Clavo, Canela, Cardamomo, Pachuli, Rosa
- Aromática: Lavanda, Romero, Pimienta, Cardamomo, Geranio, Bergamota, Cedro
```

**Criterios de Aceptación**:
- ✅ Seleccionar familia filtra notas en pasos posteriores
- ✅ Cambiar familia actualiza filtrado dinámicamente
- ✅ "Cualquiera" muestra todas las notas

#### 2.5 Paso 4: Ocasiones
**Requisitos Funcionales**:
- RF-2.5.1: Opciones obtenidas dinámicamente de BD
- RF-2.5.2: Selección múltiple (checkboxes)
- RF-2.5.3: Campo opcional - puede no seleccionar ninguna
- RF-2.5.4: Sin límite de selecciones

**Diseño UI**:
- Grid 2 columnas móvil → 4 columnas desktop
- Tarjetas con borde superior naranja cuando seleccionadas

#### 2.6 Paso 5: Notas Deseadas
**Requisitos Funcionales**:
- RF-2.6.1: Lista de 21 notas olfativas
- RF-2.6.2: **Filtrado automático** según familia seleccionada en paso 3
- RF-2.6.3: Selección múltiple (checkboxes)
- RF-2.6.4: **Sincronización bidireccional** con paso 6:
  - Si nota está en "Deseadas", se deshabilita en "Rechazadas"
  - Indicador visual de deshabilitación (opacidad 40%)

**Notas Disponibles**:
```
Bergamota, Limón, Naranja, Lavanda, Romero, Pimienta, Cardamomo,
Jazmín, Rosa, Lirio, Geranio, Clavo, Canela, Sándalo, Cedro,
Vetiver, Pachuli, Vainilla, Ámbar, Almizcle, Cuero
```

**Diseño UI**:
- Tarjetas de 96px altura (h-24)
- Grid responsivo 2/3/4 columnas
- Borde superior naranja grueso (4px) cuando seleccionada
- Texto cambia a naranja en selección
- Sombra pronunciada (shadow-xl) en selección

#### 2.7 Paso 6: Notas a Evitar
**Requisitos Funcionales**:
- RF-2.7.1: Misma lista de notas que paso 5
- RF-2.7.2: **Filtrado automático** según familia seleccionada
- RF-2.7.3: Selección múltiple (checkboxes)
- RF-2.7.4: **Sincronización bidireccional** con paso 5
- RF-2.7.5: Las notas seleccionadas aquí penalizan el score de compatibilidad

**Diseño UI**:
- Idéntico a paso 5 pero con acentos rojos
- Borde superior rojo (4px) cuando seleccionada
- Texto cambia a rojo en selección
- Diferenciación clara: rojo = rechazo/exclusión

#### 2.8 Navegación del Cuestionario
**Requisitos Funcionales**:
- RF-2.8.1: Indicador de progreso visual (6 líneas)
- RF-2.8.2: Contador "X de 6"
- RF-2.8.3: Botón "Siguiente" para avanzar
- RF-2.8.4: Botón "Anterior" para retroceder (oculto en paso 1)
- RF-2.8.5: Botón "Descubrir" en paso 6 para enviar
- RF-2.8.6: Validación de campos requeridos antes de avanzar
- RF-2.8.7: Transiciones suaves entre pasos (fade in/out)

**Requisitos No Funcionales**:
- RNF-2.8.1: Transiciones de 500ms con ease
- RNF-2.8.2: No scroll automático entre pasos (solo botón "Comenzar")
- RNF-2.8.3: Estado del cuestionario se mantiene si usuario navega atrás

---

### 3. Motor de Recomendaciones

#### 3.1 Algoritmo de Scoring
**Descripción**: Sistema híbrido de Content-Based Filtering con scoring detallado

**Fórmula de Compatibilidad**:
```
Score Total = Género + Intensidad + Familia + Ocasiones +
              Notas Preferidas - Notas Rechazadas + Popularidad +
              Bonuses (Marca, Colaborativo)

Porcentaje Compatibilidad = (Score Total / Score Máximo) × 100
```

**Distribución de Puntos**:
| Criterio | Puntos Max | Condición Match |
|----------|------------|-----------------|
| Género | 10 | Coincidencia exacta (Unisex = 7 pts) |
| Intensidad | 10 | Coincidencia exacta |
| Familia Olfativa | 25 | Coincidencia exacta (CRÍTICO) |
| Ocasiones | 20 | 10 pts por coincidencia (max 2) |
| Notas Preferidas | 25 | 5 pts por nota (max 5 notas) |
| Notas Rechazadas | -∞ | -15 pts por nota rechazada encontrada |
| Popularidad | 10 | (Rating/5.0) × 10 |
| Marca Favorita | +15 | Bonus si marca aprendida |
| Usuarios Similares | +20 | Bonus si recomendado por similares |

**Score Máximo Dinámico**:
- Base: 100 puntos
- +15 si hay marcas preferidas aprendidas
- +20 si hay datos de collaborative filtering
- **Máximo posible**: 135 puntos

#### 3.2 Niveles de Compatibilidad
**Clasificación**:
```
≥ 90%: Excelente    (color: naranja Hermès)
≥ 75%: Muy Buena    (color: verde)
≥ 60%: Buena        (color: azul)
≥ 40%: Moderada     (color: amarillo)
< 40%: Baja         (color: gris)
```

#### 3.3 Desglose de Compatibilidad
**Requisitos Funcionales**:
- RF-3.3.1: Mostrar puntos obtenidos por cada criterio
- RF-3.3.2: Indicar matches (✓) y penalizaciones (✗)
- RF-3.3.3: Detalles expandibles con botón "Ver desglose"
- RF-3.3.4: Información educativa sobre por qué cada perfume encaja

**Ejemplo de Desglose**:
```
Género: +10 (Match exacto: Masculino)
Intensidad: +10 (Match exacto: Eau de Parfum)
Familia: +25 (Familia perfecta: Cítrica)
Ocasiones: +10 (Match en: Día)
Notas Preferidas: +15 (Contiene: Bergamota, Limón, Naranja)
Notas Rechazadas: -15 (⚠️ Contiene: Vetiver)
Popularidad: +8 (Valoración: 4.0/5.0)

Score Total: 63 / 120 = 52% (Moderada)
```

#### 3.4 Lógica de Recomendaciones
**Requisitos Funcionales**:
- RF-3.4.1: Retornar top 12 perfumes con mayor compatibilidad
- RF-3.4.2: Si no hay preferencias (acceso directo), mostrar top 20 por popularidad
- RF-3.4.3: Ordenar por score descendente
- RF-3.4.4: Incluir todos los datos del perfume + compatibilidad

**Algoritmo**:
```python
1. Obtener todas las fragancias de la base de datos
2. Para cada fragancia:
   a. Calcular score según preferencias
   b. Si score < 0 (notas rechazadas), excluir
   c. Calcular porcentaje de compatibilidad
   d. Clasificar nivel (Excelente/Muy Buena/etc.)
   e. Generar desglose detallado
3. Ordenar por score descendente
4. Retornar top 12
```

---

### 4. Visualización de Resultados

#### 4.1 Página de Resultados
**Requisitos Funcionales**:
- RF-4.1.1: Grid responsivo de recomendaciones (1/2/3 columnas)
- RF-4.1.2: Cada tarjeta muestra:
  - Icono de perfume (SVG)
  - Badge con % de compatibilidad (esquina superior derecha)
  - Botón de favorito (corazón)
  - Marca del perfume
  - Nombre del perfume
  - Rating de popularidad (estrellas)
  - Familia y género
  - Sección de compatibilidad expandible

#### 4.2 Tarjeta de Compatibilidad
**Diseño**:
```
┌─────────────────────────────────────┐
│  [Icono]              [Badge: 85%]  │
│                       [♡ Favorito]  │
│                                     │
│  ─────────────────────────────────  │
│  COMPATIBILIDAD              85%    │
│  ████████████████░░░░ [Barra]       │
│          Muy Buena                  │
│                                     │
│  [▼ Ver desglose]                   │
│  ─────────────────────────────────  │
│                                     │
│  HERMÈS                        ⭐4.5│
│  Terre d'Hermès                     │
│  Amaderada · Masculino              │
│                                     │
│  Ver Detalles →                     │
└─────────────────────────────────────┘
```

#### 4.3 Página de Detalle del Perfume
**Requisitos Funcionales**:
- RF-4.3.1: Vista ampliada con toda la información
- RF-4.3.2: Pirámide olfativa completa:
  - Notas de salida
  - Notas de corazón
  - Notas de fondo
- RF-4.3.3: Ocasiones recomendadas
- RF-4.3.4: Información de marca, género, intensidad
- RF-4.3.5: Botón "Agregar a Colección"
- RF-4.3.6: Valoraciones de otros usuarios (futuro)

---

### 5. Sistema de Favoritos

#### 5.1 Agregar/Quitar Favoritos
**Requisitos Funcionales**:
- RF-5.1.1: Solo usuarios autenticados pueden usar favoritos
- RF-5.1.2: Toggle de favorito con un click
- RF-5.1.3: Feedback visual inmediato (corazón lleno/vacío)
- RF-5.1.4: Persistencia en base de datos
- RF-5.1.5: Sincronización en todas las vistas

**Requisitos No Funcionales**:
- RNF-5.1.1: Operación < 500ms
- RNF-5.1.2: Sin recarga de página (AJAX)

#### 5.2 Página de Perfil
**Requisitos Funcionales**:
- RF-5.2.1: Mostrar perfumes favoritos del usuario
- RF-5.2.2: Editar preferencias guardadas
- RF-5.2.3: Ver historial de búsquedas
- RF-5.2.4: Grid similar a página de resultados

---

## 🏗️ Arquitectura Técnica

### Stack Tecnológico

#### Backend
- **Framework**: Flask 3.x (Python)
- **ORM**: SQLAlchemy 2.x
- **Base de Datos**: PostgreSQL 15
- **Autenticación**: Flask-Login
- **Password Hashing**: bcrypt
- **Session Management**: Flask-Session

#### Frontend
- **Template Engine**: Jinja2
- **CSS Framework**: Tailwind CSS 3.x (CDN)
- **JavaScript**: Vanilla JS (ES6+)
- **Tipografía**:
  - Serif: Playfair Display (Google Fonts)
  - Sans: Helvetica Neue, Arial

#### Infraestructura
- **Hosting**: (Por definir - Heroku/Railway/Render)
- **CDN**: Tailwind CSS CDN
- **Control de Versiones**: Git + GitHub

### Estructura de Archivos
```
Paymsa/
├── app/
│   ├── __init__.py              # Factory pattern, Flask app
│   ├── routes.py                # Endpoints y lógica de vistas
│   └── templates/
│       ├── base.html            # Layout base
│       ├── index.html           # Landing + Cuestionario
│       ├── resultados.html      # Resultados + Detalles
│       ├── perfil.html          # Perfil de usuario
│       ├── login.html           # Login
│       └── register.html        # Registro
├── services/
│   ├── __init__.py
│   ├── database_service.py      # CRUD operations
│   ├── recommendation_engine.py # Motor de recomendaciones
│   └── user_feedback_service.py # Sistema de aprendizaje
├── models.py                    # Modelos SQLAlchemy
├── config.py                    # Configuración
├── app.py                       # Entry point
├── static/
│   └── css/
│       └── style.css            # Estilos custom
├── database/
│   ├── init_db.sql              # Schema inicial
│   └── seed_data.sql            # Datos de prueba
├── requirements.txt             # Dependencias Python
├── README.md
├── PRD.md                       # Este documento
└── claude.md                    # Documentación de sesión
```

### Modelo de Datos

#### Tabla: usuarios
```sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    preferencias JSONB
);
```

#### Tabla: perfumes
```sql
CREATE TABLE perfumes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    marca VARCHAR(100) NOT NULL,
    genero VARCHAR(50),
    familia VARCHAR(50),
    intensidad VARCHAR(50),
    descripcion TEXT,
    anio_lanzamiento INTEGER,
    perfumista VARCHAR(200),
    precio_aprox DECIMAL(10,2)
);
```

#### Tabla: notas
```sql
CREATE TABLE notas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    tipo VARCHAR(50), -- salida, corazon, fondo
    familia VARCHAR(50)
);
```

#### Tabla: perfume_notas (Many-to-Many)
```sql
CREATE TABLE perfume_notas (
    perfume_id INTEGER REFERENCES perfumes(id),
    nota_id INTEGER REFERENCES notas(id),
    tipo_nota VARCHAR(20), -- salida, corazon, fondo
    PRIMARY KEY (perfume_id, nota_id)
);
```

#### Tabla: favoritos
```sql
CREATE TABLE favoritos (
    usuario_id INTEGER REFERENCES usuarios(id),
    perfume_id INTEGER REFERENCES perfumes(id),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, perfume_id)
);
```

#### Tabla: busquedas_usuario
```sql
CREATE TABLE busquedas_usuario (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    preferencias JSONB,
    resultados_count INTEGER,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Vista: vista_perfumes_completa
```sql
CREATE VIEW vista_perfumes_completa AS
SELECT
    p.id, p.nombre, p.marca, p.genero, p.familia, p.intensidad,
    p.descripcion, p.perfumista,
    COALESCE(pop.puntuacion_popularidad, 0) as puntuacion_popularidad,
    array_agg(DISTINCT n.nombre) as notas,
    array_agg(DISTINCT o.nombre) as ocasiones
FROM perfumes p
LEFT JOIN perfume_notas pn ON p.id = pn.perfume_id
LEFT JOIN notas n ON pn.nota_id = n.id
LEFT JOIN perfume_ocasiones po ON p.id = po.perfume_id
LEFT JOIN ocasiones o ON po.ocasion_id = o.id
LEFT JOIN perfumes_popularidad pop ON p.id = pop.id
GROUP BY p.id, pop.puntuacion_popularidad;
```

---

## 🎨 Diseño e Interfaz

### Paleta de Colores
```css
/* Hermès Inspired */
--hermes-orange: #FF8C42;      /* Color principal */
--hermes-orange-dark: #F37021; /* Hover states */
--hermes-cream: #FAFAF8;       /* Fondo alternativo */
--hermes-black: #1A1A1A;       /* Texto principal */

/* Grises */
--gray-200: #E5E7EB;
--gray-300: #D1D5DB;
--gray-400: #9CA3AF;
--gray-500: #6B7280;
--gray-600: #4B5563;
```

### Tipografía
```css
/* Headings */
h1, h2, h3, h4, h5, h6 {
    font-family: 'Playfair Display', Georgia, serif;
    font-weight: 400;
    letter-spacing: 0.02em;
}

/* Body */
body, p, span, div {
    font-family: 'Helvetica Neue', Arial, sans-serif;
    letter-spacing: 0.01em;
    font-weight: 300; /* Light */
}

/* Buttons */
button {
    letter-spacing: 0.1em;
    text-transform: uppercase;
    font-size: 0.75rem; /* 12px */
}
```

### Espaciado y Ritmo
- **Padding contenedor**: 48px desktop, 32px móvil
- **Gap entre elementos**: 16px-24px
- **Altura de tarjetas**:
  - Opciones simples: 112px (h-28)
  - Notas: 96px (h-24)
- **Bordes**: 1px gris claro, 4px naranja/rojo en selección
- **Sombras**:
  - Hover: shadow-lg
  - Selección: shadow-xl

### Transiciones
```css
/* Estándar */
transition: all 300ms ease;

/* Pasos del cuestionario */
.step {
    opacity: 0;
    transform: translateY(10px);
    transition: opacity 500ms ease, transform 500ms ease;
}

.step.active {
    opacity: 1;
    transform: translateY(0);
}
```

### Responsive Breakpoints
```css
/* Mobile First */
- Base: < 640px (1-2 columnas)
- sm: ≥ 640px
- md: ≥ 768px (3 columnas)
- lg: ≥ 1024px (4 columnas)
- xl: ≥ 1280px
```

---

## 🔐 Seguridad

### Autenticación
- **Password Hashing**: bcrypt con salt automático
- **Session Management**: Flask-Session con cookies HttpOnly
- **CSRF Protection**: Flask-WTF (futuro)

### Base de Datos
- **SQL Injection Prevention**: SQLAlchemy ORM (parametrized queries)
- **Connection Pooling**: SQLAlchemy con límites de conexión
- **Transactions**: Rollback automático en errores

### Frontend
- **XSS Prevention**: Jinja2 auto-escaping
- **Input Validation**: Client-side + Server-side
- **Sanitización**: Validación de formatos (email, etc.)

---

## 📊 Métricas de Éxito

### KPIs Principales
1. **Tasa de Conversión del Cuestionario**
   - Meta: > 70% completan los 6 pasos
   - Medición: (Cuestionarios completados / Iniciados) × 100

2. **Satisfacción con Recomendaciones**
   - Meta: > 80% agregan al menos 1 favorito
   - Medición: (Usuarios con favoritos / Total usuarios) × 100

3. **Engagement**
   - Meta: > 3 perfumes vistos por sesión
   - Medición: Promedio de clicks en "Ver Detalles"

4. **Retención**
   - Meta: > 40% regresan en 7 días
   - Medición: Usuarios activos recurrentes

### Métricas Secundarias
- Tiempo promedio en cuestionario (meta: < 3 minutos)
- Tasa de abandono por paso
- Distribución de niveles de compatibilidad
- Familias olfativas más populares
- Notas más seleccionadas/rechazadas

---

## 🚀 Roadmap

### Versión 1.0 (Actual) - MVP
- ✅ Sistema de registro y autenticación
- ✅ Cuestionario de 6 pasos con validación
- ✅ Motor de recomendaciones con compatibilidad
- ✅ Filtrado de notas por familia olfativa
- ✅ Sincronización notas deseadas/rechazadas
- ✅ Visualización de resultados con índice de compatibilidad
- ✅ Sistema de favoritos
- ✅ Diseño Hermès-inspired responsive

### Versión 1.1 - Mejoras de UX (Q1 2026)
- [ ] Onboarding tutorial (primera visita)
- [ ] Búsqueda y filtros avanzados en resultados
- [ ] Comparador de perfumes (lado a lado)
- [ ] Share de recomendaciones (links únicos)
- [ ] PWA - Instalable en móvil
- [ ] Dark mode (opcional)

### Versión 1.2 - Social y Comunidad (Q2 2026)
- [ ] Valoraciones y reviews de usuarios
- [ ] Sistema de comentarios
- [ ] Perfil público de usuario
- [ ] Feed de actividad
- [ ] Recomendaciones de usuarios similares (collaborative filtering)

### Versión 2.0 - Machine Learning Avanzado (Q3 2026)
- [ ] Tablas de feedback implementadas
- [ ] Aprendizaje de preferencias implícitas
- [ ] Recomendaciones personalizadas en homepage
- [ ] Predicción de fragancias de temporada
- [ ] Clustering de usuarios por perfil olfativo

### Versión 2.1 - Comercio (Q4 2026)
- [ ] Integración con perfumerías (afiliación)
- [ ] Links de compra directa
- [ ] Programa de referidos
- [ ] Descuentos exclusivos
- [ ] Sistema de suscripción premium

---

## 🧪 Testing y QA

### Testing Manual
**Casos de Prueba Críticos**:
1. Registro de nuevo usuario
2. Login con credenciales válidas/inválidas
3. Completar cuestionario completo
4. Validación de pasos requeridos
5. Filtrado de notas al cambiar familia
6. Sincronización notas deseadas/rechazadas
7. Ver resultados con diferentes preferencias
8. Agregar/quitar favoritos
9. Ver detalles de perfume
10. Responsive en móvil/tablet/desktop

### Testing Automatizado (Futuro)
- **Unit Tests**: pytest para servicios y modelos
- **Integration Tests**: pytest con base de datos de prueba
- **E2E Tests**: Selenium/Playwright para flujos completos

### Criterios de Calidad
- [ ] Todos los flujos principales funcionan sin errores
- [ ] Tiempo de carga < 3 segundos
- [ ] Sin errores en consola del navegador
- [ ] Responsive en dispositivos principales (iPhone, iPad, Desktop)
- [ ] Accesibilidad básica (contraste, navegación por teclado)

---

## 📝 Notas y Consideraciones

### Limitaciones Actuales
1. **Tablas de Feedback Avanzado**: No implementadas
   - `preferencias_aprendidas`
   - `perfumes_popularidad`
   - Sistema funciona sin ellas pero sin ML avanzado

2. **Imágenes de Perfumes**: Actualmente solo iconos SVG
   - Futuro: imágenes reales de frascos

3. **Información de Compra**: No hay links de afiliación aún

4. **Valoraciones**: Base de datos preparada pero sin interfaz

### Decisiones de Diseño
1. **Por qué Tailwind CDN**: Rapidez de desarrollo, sin build step
2. **Por qué no React/Vue**: Complejidad innecesaria para MVP
3. **Por qué PostgreSQL**: Escalabilidad, JSONB para preferencias
4. **Por qué solo 12 recomendaciones**: Showroom de lujo, no abrumar

### Dependencias Externas
```txt
Flask==3.0.0
SQLAlchemy==2.0.23
psycopg2-binary==2.9.9
Flask-Login==0.6.3
python-dotenv==1.0.0
bcrypt==4.1.2
```

---

## 📞 Contacto y Recursos

**Repositorio GitHub**: https://github.com/jariass2/Perfume_Curator

**Documentación Relacionada**:
- `README.md` - Overview del proyecto
- `claude.md` - Documentación de desarrollo
- `LUXURY_INTERFACE.md` - Guía de diseño Hermès
- `INDICE_COMPATIBILIDAD.md` - Algoritmo de compatibilidad
- `SISTEMA_FEEDBACK_USUARIO.md` - Sistema de aprendizaje

**Stack y Referencias**:
- [Flask Documentation](https://flask.palletsprojects.com/)
- [SQLAlchemy Docs](https://docs.sqlalchemy.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Hermès Design Inspiration](https://www.hermes.com/)

---

## ✅ Criterios de Aceptación del Producto

### MVP Completo
- [x] Usuario puede registrarse e iniciar sesión
- [x] Usuario puede completar cuestionario de 6 pasos
- [x] Sistema valida campos requeridos
- [x] Notas se filtran según familia olfativa seleccionada
- [x] No se puede seleccionar misma nota como deseada y rechazada
- [x] Sistema genera 12 recomendaciones con % de compatibilidad
- [x] Cada recomendación muestra desglose detallado
- [x] Usuario puede agregar/quitar favoritos
- [x] Usuario puede ver detalles completos de cada perfume
- [x] Interfaz es responsive y funciona en móvil
- [x] Diseño sigue estética Hermès (minimalista, elegante)

### Calidad del Código
- [x] Sin errores críticos en producción
- [x] Código bien estructurado (MVC)
- [x] Commits descriptivos y organizados
- [x] Documentación completa (PRD, claude.md, README)

---

**Documento vivo**: Este PRD se actualizará según evolucione el producto.

**Última revisión**: 5 de Enero, 2026
**Próxima revisión**: A determinar según roadmap
