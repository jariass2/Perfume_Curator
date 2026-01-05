# Diagrama Entidad-Relación - Sistema de Perfumería Paymsa

## Descripción General

El sistema de perfumería Paymsa es una base de datos relacional que permite gestionar un catálogo de perfumes, usuarios y un sistema experto de recomendación.

## Tablas Principales

### 1. **familias_olfativas**
Define las categorías principales de fragancias.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| nombre | VARCHAR(50) UNIQUE | Nombre de la familia (Cítrica, Floral, etc.) |
| descripcion | TEXT | Descripción detallada |
| creado_en | TIMESTAMP | Fecha de creación |

**Valores**: Cítrica, Floral, Amaderada, Oriental, Aromática

---

### 2. **intensidades**
Niveles de concentración y duración de los perfumes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| nivel | VARCHAR(20) UNIQUE | Nivel (Eau de Cologne, Eau de Toilette, etc.) |
| descripcion | TEXT | Descripción |
| duracion_estimada_horas | INT | Duración en horas |
| creado_en | TIMESTAMP | Fecha de creación |

**Valores**: Eau de Cologne (2h), Eau de Toilette (4h), Eau de Parfum (8h), Extrait (12h)

---

### 3. **generos**
Categorías de género de los perfumes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| tipo | VARCHAR(20) UNIQUE | Tipo (Masculino, Femenino, Unisex) |
| creado_en | TIMESTAMP | Fecha de creación |

**Valores**: Masculino, Femenino, Unisex

---

### 4. **notas_olfativas**
Ingredientes individuales que componen los perfumes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| nombre | VARCHAR(100) UNIQUE | Nombre de la nota (limón, vainilla, etc.) |
| categoria | VARCHAR(20) | Tipo (nota_salida, nota_corazon, nota_fondo) |
| familia_id | INT FK | FK a familias_olfativas |
| creado_en | TIMESTAMP | Fecha de creación |

**Categorías**:
- nota_salida: Notas iniciales que se perciben primero
- nota_corazon: Notas principales que duran horas
- nota_fondo: Notas finales que persisten más tiempo

---

### 5. **ocasiones**
Momentos o situaciones de uso recomendados.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| nombre | VARCHAR(50) UNIQUE | Nombre (Dia, Noche, Oficina, etc.) |
| temporada | VARCHAR(50) | Temporada asociada |
| creado_en | TIMESTAMP | Fecha de creación |

**Valores**: Dia, Noche, Oficina, Fiesta, Verano, Invierno, Primavera, Otoño

---

### 6. **marcas**
Fabricantes de perfumes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| nombre | VARCHAR(100) UNIQUE | Nombre de la marca |
| pais_origen | VARCHAR(50) | País de origen |
| ano_fundacion | INT | Año de fundación |
| creado_en | TIMESTAMP | Fecha de creación |

---

### 7. **perfumes**
Tabla principal de perfumes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| nombre | VARCHAR(200) | Nombre del perfume |
| marca_id | INT FK | FK a marcas |
| familia_id | INT FK | FK a familias_olfativas |
| intensidad_id | INT FK | FK a intensidades |
| genero_id | INT FK | FK a generos |
| ano_lanzamiento | INT | Año de lanzamiento |
| precio_ml | DECIMAL(10,2) | Precio por mililitro |
| descripcion | TEXT | Descripción detallada |
| imagen_url | VARCHAR(500) | URL de imagen |
| puntuacion_popularidad | DECIMAL(3,2) | Promedio de valoraciones (0-5) |
| creado_en | TIMESTAMP | Fecha de creación |
| actualizado_en | TIMESTAMP | Fecha última actualización |

---

### 8. **perfume_notas** (Relación Muchos-a-Muchos)
Asocia perfumes con sus notas olfativas.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| perfume_id | INT FK | FK a perfumes (PK parte 1) |
| nota_id | INT FK | FK a notas_olfativas (PK parte 2) |

**Relación**: Un perfume tiene múltiples notas, una nota puede estar en múltiples perfumes.

---

### 9. **perfume_ocasiones** (Relación Muchos-a-Muchos)
Asocia perfumes con sus ocasiones recomendadas.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| perfume_id | INT FK | FK a perfumes (PK parte 1) |
| ocasion_id | INT FK | FK a ocasiones (PK parte 2) |

**Relación**: Un perfume es adecuado para múltiples ocasiones, una ocasión tiene múltiples perfumes.

---

### 10. **usuarios**
Usuarios del sistema con sus preferencias.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| email | VARCHAR(255) UNIQUE | Email del usuario (único) |
| nombre | VARCHAR(100) | Nombre del usuario |
| password_hash | VARCHAR(255) | Contraseña encriptada |
| preferencias | JSONB | Preferencias en formato JSON |
| creado_en | TIMESTAMP | Fecha de creación |
| actualizado_en | TIMESTAMP | Fecha última actualización |

**Formato de preferencias JSONB**:
```json
{
  "genero": "Masculino",
  "intensidad": "Media",
  "notas_preferidas": ["Bergamota", "Lavanda"],
  "notas_rechazadas": ["Pachuli"],
  "ocasiones_preferidas": ["Dia", "Oficina"]
}
```

---

### 11. **busquedas**
Historial de búsquedas realizadas por usuarios.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| usuario_id | INT FK | FK a usuarios |
| criterios | JSONB | Criterios de búsqueda en JSON |
| resultados_obtenidos | INT | Cantidad de resultados |
| fecha | TIMESTAMP | Fecha de la búsqueda |

**Formato de criterios JSONB**:
```json
{
  "genero": "Masculino",
  "intensidad": "Media",
  "notas_preferidas": ["Bergamota"],
  "ocasiones": ["Dia", "Oficina"]
}
```

---

### 12. **favoritos** (Relación Muchos-a-Muchos)
Perfumes marcados como favoritos por usuarios.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| usuario_id | INT FK | FK a usuarios (PK parte 1) |
| perfume_id | INT FK | FK a perfumes (PK parte 2) |
| creado_en | TIMESTAMP | Fecha que se agregó |

**Relación**: Un usuario puede tener múltiples favoritos, un perfume puede ser favorito de múltiples usuarios.

---

### 13. **valoraciones**
Calificaciones y comentarios de usuarios a perfumes.

| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | SERIAL | PK |
| usuario_id | INT FK | FK a usuarios |
| perfume_id | INT FK | FK a perfumes |
| puntuacion | INT | Calificación 1-5 |
| comentario | TEXT | Comentario del usuario |
| fecha | TIMESTAMP | Fecha de la valoración |

**Restricción**: UNIQUE(usuario_id, perfume_id) - Un usuario solo puede valorar un perfume una vez.

---

## Relaciones

### Relaciones Uno-a-Muchos (1:N)
- **marcas → perfumes**: Una marca tiene muchos perfumes
- **familias_olfativas → perfumes**: Una familia tiene muchos perfumes
- **intensidades → perfumes**: Una intensidad tiene muchos perfumes
- **generos → perfumes**: Un género tiene muchos perfumes
- **notas_olfativas → perfumes** (vía perfume_notas): Una nota está en muchos perfumes
- **ocasiones → perfumes** (vía perfume_ocasiones): Una ocasión tiene muchos perfumes
- **usuarios → busquedas**: Un usuario tiene muchas búsquedas
- **usuarios → valoraciones**: Un usuario tiene muchas valoraciones

### Relaciones Muchos-a-Muchos (N:M)
- **perfumes ↔ notas_olfativas**: Tabla intermedia `perfume_notas`
- **perfumes ↔ ocasiones**: Tabla intermedia `perfume_ocasiones`
- **usuarios ↔ perfumes** (favoritos): Tabla intermedia `favoritos`

---

## Vista: vista_perfumes_completa

Vista materializada que combina toda la información de perfumes para consultas rápidas.

**Campos**:
- Todos los campos de `perfumes`
- `marca` (nombre)
- `familia` (nombre)
- `intensidad` (nombre)
- `genero` (nombre)
- `ocasiones` (ARRAY de nombres)
- `notas` (ARRAY de nombres)
- `notas_salida` (ARRAY de nombres)
- `notas_corazon` (ARRAY de nombres)
- `notas_fondo` (ARRAY de nombres)

---

## Índices Optimizados

### Índices en perfumes
- `idx_perfumes_familia` - Búsquedas por familia
- `idx_perfumes_genero` - Búsquedas por género
- `idx_perfumes_precio` - Búsquedas por precio
- `idx_perfumes_popularidad` - Ordenamiento por popularidad
- `idx_perfumes_marca` - Búsquedas por marca
- `idx_perfumes_intensidad` - Búsquedas por intensidad

### Índices en relaciones
- `idx_perfume_notas_nota` - Búsquedas de notas
- `idx_perfume_notas_perfume` - Búsquedas de perfumes por nota
- `idx_perfume_ocasiones_ocasion` - Búsquedas de ocasión
- `idx_perfume_ocasiones_perfume` - Búsquedas de perfumes por ocasión

### Índices en usuarios
- `idx_usuarios_email` - Login rápido
- `idx_usuarios_preferencias` - Búsquedas JSONB (GIN)

### Índices en busquedas
- `idx_busquedas_usuario` - Historial de usuario
- `idx_busquedas_fecha` - Búsquedas por fecha

### Índices en favoritos
- `idx_favoritos_usuario` - Favoritos de usuario
- `idx_favoritos_perfume` - Usuarios que favoritaron un perfume

### Índices en valoraciones
- `idx_valoraciones_perfume` - Valoraciones de perfume
- `idx_valoraciones_usuario` - Valoraciones de usuario
- `idx_valoraciones_puntuacion` - Búsquedas por puntuación

---

## Sistema Experto de Recomendación

El sistema usa los siguientes campos para el algoritmo de scoring:

1. **Género** (+1 punto si coincide)
2. **Intensidad** (+1 punto si coincide)
3. **Familia olfativa** (+2 puntos si coincide)
4. **Ocasiones** (+2 puntos por cada coincidencia)
5. **Notas preferidas** (+1 punto cada una)
6. **Notas rechazadas** (-3 puntos cada una)
7. **Popularidad** (+0.5 puntos por cada estrella)

El sistema calcula el score total y devuelve los perfumes con mayor puntuación.