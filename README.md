# Paymsa - Sistema Experto de Recomendación de Perfumes

Sistema web de inteligencia artificial que recomienda perfumes basándose en las preferencias del usuario mediante un algoritmo de scoring experto.

## Características

- **Sistema Experto de Recomendación**: Algoritmo que puntúa perfumes según preferencias de género, intensidad, familia olfativa, ocasiones y notas olfativas
- **Base de Datos Relacional PostgreSQL**: Almacenamiento optimizado en VPS remoto
- **Autenticación de Usuarios**: Registro, login y gestión de preferencias personales
- **Sistema de Favoritos**: Guarda perfumes favoritos
- **Historial de Búsquedas**: Registro de todas las búsquedas realizadas
- **Sistema de Valoraciones**: Usuarios pueden calificar perfumes (1-5 estrellas)
- **Interfaz Web Responsiva**: Diseño moderno con HTML/CSS

## Tecnologías

- **Backend**: Python + Flask + SQLAlchemy
- **Base de Datos**: PostgreSQL (VPS: 116.203.112.201:5432)
- **Frontend**: HTML5 + CSS3 (sin frameworks)
- **Autenticación**: Flask-Login
- **Hashing**: Werkzeug

## Estructura del Proyecto

```
Paymsa/
├── app/
│   ├── __init__.py           # Inicialización Flask
│   ├── routes.py              # Rutas de la aplicación
│   └── templates/             # Plantillas HTML
│       ├── base.html
│       ├── index.html
│       ├── register.html
│       ├── login.html
│       ├── perfil.html
│       └── resultados.html
├── database/
│   ├── schema/
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_seed_data.sql
│   │   └── 003_indexes.sql
│   └── docs/
│       └── diagrama_er.md
├── models/                    # Modelos SQLAlchemy
│   ├── base.py
│   ├── perfume.py
│   └── usuario.py
├── services/                  # Lógica de negocio
│   ├── database_service.py
│   └── recommendation_engine.py
├── app.py                     # Punto de entrada
├── config.py                  # Configuración
├── requirements.txt
├── .env                       # Variables de entorno
└── README.md
```

## Instalación y Configuración

### Prerrequisitos

- Python 3.8+
- PostgreSQL 12+ (configurado en VPS)
- pip

### Pasos de Instalación

1. **Clonar el repositorio** (o descargar el proyecto)
2. **Instalar dependencias**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Configurar variables de entorno**:
   El archivo `.env` ya está configurado con:
   ```
   DATABASE_URL=postgresql://postgres:Ba3171967@116.203.112.201:5432/paymsa
   SECRET_KEY=tu_clave_secreta_aqui_cambiala_en_produccion
   FLASK_ENV=development
   FLASK_APP=app.py
   ```

4. **Inicializar base de datos** (si aún no está inicializada):
   La base de datos ya está inicializada con los scripts SQL:
   - `001_initial_schema.sql`: Estructura de tablas
   - `002_seed_data.sql`: Datos de ejemplo (15 perfumes, 5 usuarios)
   - `003_indexes.sql`: Índices y vistas

   Para ejecutar manualmente:
   ```bash
   PGPASSWORD=Ba3171967 psql -h 116.203.112.201 -p 5432 -U postgres -d paymsa -f database/schema/001_initial_schema.sql
   PGPASSWORD=Ba3171967 psql -h 116.203.112.201 -p 5432 -U postgres -d paymsa -f database/schema/002_seed_data.sql
   PGPASSWORD=Ba3171967 psql -h 116.203.112.201 -p 5432 -U postgres -d paymsa -f database/schema/003_indexes.sql
   ```

## Ejecutar la Aplicación

```bash
python app.py
```

La aplicación estará disponible en: `http://localhost:5000`

## Uso

### 1. Flujo Principal (Sin Login)

1. Accede a `http://localhost:5000`
2. Completa el cuestionario de preferencias:
   - Género (Masculino, Femenino, Unisex)
   - Intensidad (Eau de Cologne, Eau de Toilette, Eau de Parfum, Extrait)
   - Familia olfativa (Cítrica, Floral, Amaderada, Oriental, Aromática)
   - Ocasiones (Día, Noche, Oficina, Fiesta, etc.)
   - Notas preferidas (Bergamota, Lavanda, Vainilla, etc.)
   - Notas rechazadas (para evitar perfumes con estas notas)
3. Click en "Obtener Recomendaciones"
4. Ver los perfumes recomendados con su score de compatibilidad

### 2. Flujo con Usuario Registrado

1. **Registro**:
   - Click en "Registrarse"
   - Ingresa email, nombre y contraseña
   - Inicia sesión

2. **Perfil y Preferencias**:
   - Accede a "Mi Perfil"
   - Configura tus preferencias
   - Guarda para futuras recomendaciones

3. **Favoritos**:
   - Agrega perfumes a favoritos
   - Ver lista de favoritos en el perfil
   - Elimina de favoritos

4. **Historial**:
   - Todas las búsquedas se registran automáticamente
   - Ver historial en el perfil

## Algoritmo de Recomendación

El sistema calcula un **score de compatibilidad** para cada perfume:

| Factor | Puntos |
|--------|--------|
| Género coincide | +1 |
| Intensidad coincide | +1 |
| Familia olfativa coincide | +2 |
| Ocasión coincide | +2 por cada coincidencia |
| Nota preferida | +1 por cada nota |
| Nota rechazada | -3 por cada nota |
| Popularidad | +0.5 por estrella de valoración |

**Ejemplo**: Si un usuario busca perfume masculino, de intensidad media, para oficina, con notas de bergamota y lavanda, el sistema buscará perfumes que cumplan estos criterios y calculará el score total.

## Base de Datos

### Tablas Principales

- **familias_olfativas**: Categorías de fragancias
- **intensidades**: Niveles de concentración
- **generos**: Masculino, Femenino, Unisex
- **notas_olfativas**: Ingredientes (clasificados por tipo)
- **ocasiones**: Momentos de uso
- **marcas**: Fabricantes
- **perfumes**: Perfumes principales
- **perfume_notas**: Relación muchos-a-muchos
- **perfume_ocasiones**: Relación muchos-a-muchos
- **usuarios**: Usuarios del sistema
- **busquedas**: Historial de búsquedas
- **favoritos**: Perfumes marcados como favoritos
- **valoraciones**: Calificaciones de usuarios

### Vista: `vista_perfumes_completa`

Combina toda la información de perfumes para consultas rápidas, incluyendo notas agrupadas por tipo (salida, corazón, fondo).

## Usuarios de Prueba

El sistema incluye 5 usuarios de ejemplo:

| Email | Preferencias |
|-------|--------------|
| usuario1@example.com | Masculino, Media, Bergamota/Lavanda |
| usuario2@example.com | Femenino, Fuerte, Jazmín/Vainilla (sin Pachuli) |
| usuario3@example.com | Unisex, Suave, Limón/Sándalo |
| usuario4@example.com | Masculino, Fuerte, Ámbar/Cuero (sin Floral) |
| usuario5@example.com | Femenino, Media, Rosa/Almizcle |

**Nota**: Las contraseñas están hasheadas. Para probar, regístrate con un nuevo usuario.

## Perfumes de Ejemplo

El sistema incluye 15 perfumes reales de marcas como:
- Dior (Sauvage, Acqua di Gio, Dior Homme Intense)
- Chanel (No. 5, Bleu de Chanel)
- Creed (Aventus, Silver Mountain Water)
- Tom Ford (Oud Wood, Black Orchid)
- YSL (La Nuit de L'Homme, Libre)
- Calvin Klein (CK One)
- Armani (Code)
- Ralph Lauren (Polo Blue)

## API Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Página principal con cuestionario |
| GET/POST | `/register` | Registro de usuarios |
| GET/POST | `/login` | Login de usuarios |
| GET | `/logout` | Cerrar sesión |
| GET/POST | `/perfil` | Perfil y preferencias |
| GET/POST | `/resultados` | Recomendaciones de perfumes |
| POST | `/favoritos/<id>` | Toggle favoritos |
| GET | `/historial` | Historial de búsquedas |
| GET | `/perfume/<id>` | Detalle de perfume |

## Personalización

### Cambiar Estilos

Los estilos CSS están definidos en `app/templates/base.html` dentro del tag `<style>`.

### Modificar Algoritmo de Recomendación

Edita `services/recommendation_engine.py` y modifica el método `calcular_score_perfil()`.

### Agregar Nuevos Perfumes

Usa SQL directo o el servicio de base de datos:
```python
from services import DatabaseService
db_service = DatabaseService()
# Agregar nuevo perfume
```

## Seguridad

- Contraseñas hasheadas con Werkzeug
- Variables de entorno en `.env`
- Validación de formularios
- Protección de rutas con Flask-Login

## Solución de Problemas

### Error de conexión a base de datos

Verifica que el VPS PostgreSQL esté accesible:
```bash
pg_isready -h 116.203.112.201 -p 5432
```

### Error en import de módulos

Asegúrate de estar en el directorio del proyecto:
```bash
cd /Users/jordiariassantaella/Downloads/Paymsa
```

### Dependencias faltantes

Reinstala las dependencias:
```bash
pip install -r requirements.txt --force-reinstall
```

## Despliegue en Producción

1. Cambiar `FLASK_ENV` a `production`
2. Usar SECRET_KEY seguro
3. Implementar servidor WSGI (Gunicorn, uWSGI)
4. Configurar HTTPS
5. Considerar reverse proxy (Nginx)

## Licencia

Proyecto creado para el Sistema de Perfumería Paymsa.

## Contacto

Para soporte técnico o consultas, contacta al equipo de desarrollo.

---

**¡Disfruta descubriendo tu perfume ideal!**