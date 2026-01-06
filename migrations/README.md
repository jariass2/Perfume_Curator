# Paymsa Database Migrations

This directory contains database migration scripts for the Paymsa perfume curation system.

---

## 📋 Available Migrations

### 1. **create_feedback_tables.sql** (v1.0 - 2026-01-06)

Creates advanced ML-powered feedback and analytics infrastructure.

**Tables Created**:
1. **sesiones_busqueda** - Tracks search sessions with criteria and metadata
2. **interacciones_usuario** - Records all user interactions with perfumes
3. **preferencias_aprendidas** - Stores learned user preferences with confidence levels
4. **feedback_explicito** - Detailed user ratings and feedback
5. **patrones_comportamiento** - Identified user behavior patterns

**Views Created**:
1. **perfumes_popularidad** - Perfume popularity statistics (CTR, conversions, ratings)
2. **metricas_usuario** - Comprehensive user engagement metrics

**Functions Created**:
1. **registrar_interaccion()** - Simplified interaction logging
2. **actualizar_preferencia_aprendida()** - Smart preference learning with confidence increments

---

## 🚀 How to Apply Migrations

### Prerequisites

- PostgreSQL database configured and running
- Database connection details in `config.py`
- Existing Paymsa base tables (usuarios, perfumes, etc.)

### Method 1: Using psql (Recommended)

```bash
# Navigate to migrations directory
cd /Users/jordiariassantaella/Development/Perfume_Curator/migrations

# Apply migration
psql -h localhost -U your_username -d paymsa_db -f create_feedback_tables.sql
```

### Method 2: Using pgAdmin

1. Open pgAdmin
2. Connect to your Paymsa database
3. Open Query Tool
4. Load `create_feedback_tables.sql`
5. Execute the script

### Method 3: Using Python Script

Create a `run_migration.py`:

```python
from config import Config
import psycopg2

# Read migration file
with open('migrations/create_feedback_tables.sql', 'r') as f:
    migration_sql = f.read()

# Connect to database
conn = psycopg2.connect(Config.SQLALCHEMY_DATABASE_URI)
cur = conn.cursor()

try:
    # Execute migration
    cur.execute(migration_sql)
    conn.commit()
    print("✓ Migration applied successfully!")
except Exception as e:
    conn.rollback()
    print(f"✗ Migration failed: {e}")
finally:
    cur.close()
    conn.close()
```

Run with: `python run_migration.py`

---

## 🔍 Verification

After applying the migration, verify it was successful:

```sql
-- Check tables were created
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
      'sesiones_busqueda',
      'interacciones_usuario',
      'preferencias_aprendidas',
      'feedback_explicito',
      'patrones_comportamiento'
  );

-- Check views were created
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name IN ('perfumes_popularidad', 'metricas_usuario');

-- Check functions were created
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_type = 'FUNCTION'
  AND routine_name IN ('registrar_interaccion', 'actualizar_preferencia_aprendida');
```

Expected output: 5 tables, 2 views, 2 functions.

---

## 📊 Table Relationships

```
usuarios (existing)
    ├── sesiones_busqueda (NEW)
    │   └── interacciones_usuario (NEW)
    │       └── perfumes (existing)
    ├── preferencias_aprendidas (NEW)
    ├── feedback_explicito (NEW)
    │   └── perfumes (existing)
    └── patrones_comportamiento (NEW)
```

---

## 🎯 Use Cases

### 1. Track User Interactions

```python
from services.user_feedback_service import UserFeedbackService

feedback_service = UserFeedbackService(db_session)

# Start a search session
sesion_id = feedback_service.iniciar_sesion(
    usuario_id=1,
    criterios={'genero': 'Unisex', 'familia': 'Floral'},
    dispositivo='desktop',
    navegador='Chrome'
)

# Register user viewing a perfume
feedback_service.registrar_vista_perfume(
    usuario_id=1,
    perfume_id=42,
    sesion_id=sesion_id
)

# Register clicking for details
feedback_service.registrar_click_detalle(
    usuario_id=1,
    perfume_id=42,
    sesion_id=sesion_id,
    tiempo_en_lista=5
)
```

### 2. Get Learned Preferences

```python
# Get user's learned preferences
preferencias = feedback_service.obtener_preferencias_aprendidas(
    usuario_id=1,
    min_confianza=0.7
)

# Example output:
# {
#     'familia': [
#         {'valor': 'Floral', 'confianza': 0.85, 'veces_observado': 12, 'origen': 'favoritos'}
#     ],
#     'nota': [
#         {'valor': 'Rosa', 'confianza': 0.78, 'veces_observado': 8, 'origen': 'valoraciones'}
#     ]
# }
```

### 3. Get Popular Perfumes

```python
# Get most popular perfumes by CTR
populares = feedback_service.obtener_perfumes_populares(
    limite=10,
    metrica='ctr'
)

# Metrics available: 'ctr', 'conversion', 'vistas', 'favoritos', 'valoracion'
```

### 4. Collaborative Filtering

```python
# Get recommendations based on similar users
recomendaciones = feedback_service.obtener_recomendaciones_colaborativas(
    usuario_id=1,
    limite=10
)
# Returns list of perfume IDs liked by similar users
```

---

## 🔧 Maintenance

### Analyzing Performance

```sql
-- Check most popular perfumes
SELECT * FROM perfumes_popularidad
ORDER BY ctr DESC
LIMIT 10;

-- Check user engagement
SELECT * FROM metricas_usuario
ORDER BY total_interacciones DESC
LIMIT 10;

-- Check learned preferences
SELECT u.nombre, pa.tipo_preferencia, pa.valor, pa.confianza, pa.veces_observado
FROM preferencias_aprendidas pa
JOIN usuarios u ON pa.usuario_id = u.id
WHERE pa.confianza >= 0.7
ORDER BY pa.confianza DESC;
```

### Cleanup Old Data (Optional)

```sql
-- Archive interactions older than 1 year
DELETE FROM interacciones_usuario
WHERE fecha < NOW() - INTERVAL '1 year';

-- Deactivate old behavior patterns
UPDATE patrones_comportamiento
SET activo = FALSE
WHERE fecha_identificacion < NOW() - INTERVAL '6 months';
```

---

## ⚠️ Important Notes

1. **Idempotent**: The migration uses `DROP ... IF EXISTS`, so it's safe to re-run
2. **Data Loss**: Re-running will delete existing feedback data. Backup first!
3. **Performance**: Views are not materialized. For large datasets, consider materializing:
   ```sql
   CREATE MATERIALIZED VIEW perfumes_popularidad_materialized AS
   SELECT * FROM perfumes_popularidad;

   -- Refresh periodically
   REFRESH MATERIALIZED VIEW perfumes_popularidad_materialized;
   ```

4. **Indexes**: All necessary indexes are created automatically
5. **Foreign Keys**: All foreign keys have ON DELETE CASCADE for data integrity

---

## 🐛 Troubleshooting

### Error: "relation does not exist"

**Cause**: Base tables (usuarios, perfumes, etc.) not created yet.

**Solution**: Run base migrations first, then feedback tables migration.

### Error: "function already exists"

**Cause**: Functions were created previously.

**Solution**: The migration handles this with `DROP FUNCTION IF EXISTS`. Re-run the migration.

### Error: "permission denied"

**Cause**: Insufficient database privileges.

**Solution**: Grant necessary privileges:
```sql
GRANT ALL PRIVILEGES ON DATABASE paymsa_db TO your_username;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO your_username;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO your_username;
```

---

## 📈 Rollback

To rollback this migration:

```sql
DROP VIEW IF EXISTS metricas_usuario CASCADE;
DROP VIEW IF EXISTS perfumes_popularidad CASCADE;
DROP TABLE IF EXISTS feedback_explicito CASCADE;
DROP TABLE IF EXISTS patrones_comportamiento CASCADE;
DROP TABLE IF EXISTS preferencias_aprendidas CASCADE;
DROP TABLE IF EXISTS interacciones_usuario CASCADE;
DROP TABLE IF EXISTS sesiones_busqueda CASCADE;
DROP FUNCTION IF EXISTS registrar_interaccion CASCADE;
DROP FUNCTION IF EXISTS actualizar_preferencia_aprendida CASCADE;
```

---

## 📝 Changelog

**v1.0** (2026-01-06):
- Initial creation of feedback tables
- Created 5 core tables for ML features
- Added 2 analytics views
- Implemented 2 helper functions
- Full PostgreSQL compatibility

---

## 🔗 Related Documentation

- **CLAUDE.md** - Session notes and bug fixes
- **SISTEMA_FEEDBACK_USUARIO.md** - Detailed feedback system architecture
- **services/user_feedback_service.py** - Service implementation
- **TESTING_GUIDE.md** - Testing procedures

---

**Author**: Claude Code Session
**Date**: 2026-01-06
**Version**: 1.0
