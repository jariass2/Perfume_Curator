# Implementation Roadmap - Advanced Recommendation Features

**Project**: Paymsa - Curador de Perfumes Exclusivos
**Date**: January 6, 2026
**Based on**: Advanced Recommendation Systems Research

---

## Current System Analysis

### What You Already Have (Excellent Foundation!)

**Questionnaire Steps** (6 total):
1. Género - Gender preference (Hombre/Mujer/Unisex)
2. Intensidad - Concentration level (EDT/EDP/Parfum/Extrait)
3. Familia Olfativa - Olfactory family (Citrica/Floral/Amaderada/Oriental/Aromatica)
4. Ocasiones - Use occasions (work/leisure/evening)
5. Notas Deseadas - Preferred notes with family filtering
6. Notas a Evitar - Avoided notes with consistency checking

**Matching Algorithm** (`recommendation_engine.py`):
- Gender matching (10 points)
- Intensity matching (10 points)
- Olfactory family matching (25 points - CRITICAL)
- Occasion matching (20 points)
- Preferred notes matching (25 points - CRITICAL)
- Avoided notes penalty (15 points per note)
- Popularity bonus (10 points)
- Brand preference bonus (15 points - learned)
- Similar users bonus (20 points - collaborative)

**Current Score Range**: 0-120 points (normalized to 0-100%)

**Database Structure**:
- `perfumes` table with: familia_id, intensidad_id, genero_id, puntuacion_popularidad
- `preferencias` JSON column in usuarios table
- Relationships: notas, ocasiones, marca

---

## Phase 1: Essential Environmental & Performance Factors
**Time Estimate**: 6-8 hours
**Impact**: High (immediately improves recommendation relevance)
**Complexity**: Low (straightforward additions)

### 1.1 Add Climate & Seasonality to Database

**New Database Columns**:
```sql
-- Run these migrations
ALTER TABLE perfumes ADD COLUMN clima_recomendado VARCHAR(20);
-- Values: 'calido', 'frio', 'templado', 'versatil'

ALTER TABLE perfumes ADD COLUMN estacionalidad JSONB DEFAULT '{"primavera": 0.5, "verano": 0.5, "otono": 0.5, "invierno": 0.5}';
-- JSON format: {"primavera": 0.8, "verano": 0.9, "otono": 0.4, "invierno": 0.3}
-- Each season gets a 0.0-1.0 rating for how suitable the perfume is

ALTER TABLE perfumes ADD COLUMN longevidad_promedio DECIMAL(3,1) DEFAULT 6.0;
-- Average hours (e.g., 6.5 hours)

ALTER TABLE perfumes ADD COLUMN sillage_nivel VARCHAR(20) DEFAULT 'moderado';
-- Values: 'intimo', 'moderado', 'pronunciado', 'potente'
```

**Extend Usuario Preferences**:
```sql
-- Update the usuarios table's preferencias JSON structure to include:
-- {
--   "genero": "Mujer",
--   "familia": "Floral",
--   "intensidad": "EDP",
--   "clima": "calido",                    -- NEW
--   "estacion_preferida": "verano",       -- NEW
--   "longevidad_deseada": "6-8",          -- NEW
--   "sillage_deseado": "moderado",        -- NEW
--   "ocasiones": ["trabajo", "diario"],
--   "notas_preferidas": [...],
--   "notas_rechazadas": [...]
-- }
```

### 1.2 Update Questionnaire (index.html)

**Add New Steps** (between current steps):

**NEW Step 3: Climate & Environment**
Insert after Step 2 (Intensidad), before Step 3 (Familia):
```html
<!-- Step 3: Clima -->
<div class="step" data-step="3">
    <div class="text-center mb-20">
        <h2 class="font-serif text-5xl md:text-6xl font-light text-hermes-black mb-4 tracking-tight">
            Entorno
        </h2>
        <p class="text-base text-gray-500 font-light">
            ¿En qué clima usarás principalmente este perfume?
        </p>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto mb-20">
        <label class="group relative cursor-pointer block">
            <input type="radio" name="clima" value="calido" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">☀️</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Cálido</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="clima" value="templado" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">🍂</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Templado</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="clima" value="frio" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">❄️</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Frío</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="clima" value="versatil" class="peer sr-only" checked>
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">🌍</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Cualquiera</span>
            </div>
        </label>
    </div>
</div>

<!-- Step 4: Estacionalidad -->
<div class="step" data-step="4">
    <div class="text-center mb-20">
        <h2 class="font-serif text-5xl md:text-6xl font-light text-hermes-black mb-4 tracking-tight">
            Estación
        </h2>
        <p class="text-base text-gray-500 font-light">
            ¿Para qué momento del año?
        </p>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-5 gap-4 max-w-4xl mx-auto mb-20">
        <label class="group relative cursor-pointer block">
            <input type="radio" name="estacion" value="primavera" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">🌸</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Primavera</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="estacion" value="verano" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">🏖️</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Verano</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="estacion" value="otono" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">🍁</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Otoño</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="estacion" value="invierno" class="peer sr-only">
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">⛄</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Invierno</span>
            </div>
        </label>
        <label class="group relative cursor-pointer block">
            <input type="radio" name="estacion" value="todo_el_ano" class="peer sr-only" checked>
            <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                <span class="text-2xl mb-2">📅</span>
                <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Todo el año</span>
            </div>
        </label>
    </div>
</div>
```

**NEW Step: Performance Preferences**
Add as Step 8 (after current Step 6 - Notas a Evitar):
```html
<!-- Step 8: Performance -->
<div class="step" data-step="8">
    <div class="text-center mb-20">
        <h2 class="font-serif text-5xl md:text-6xl font-light text-hermes-black mb-4 tracking-tight">
            Duración y Presencia
        </h2>
        <p class="text-base text-gray-500 font-light">
            Define el rendimiento ideal
        </p>
    </div>

    <div class="space-y-16">
        <!-- Longevidad -->
        <div>
            <h3 class="text-center text-2xl font-serif font-light text-hermes-black mb-8">
                ¿Cuánto debe durar?
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto">
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="longevidad" value="2-4" class="peer sr-only">
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">⏱️</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">2-4h</span>
                        <span class="text-xs text-gray-400 mt-1">Ligero</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="longevidad" value="4-6" class="peer sr-only">
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">⏰</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">4-6h</span>
                        <span class="text-xs text-gray-400 mt-1">Medio</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="longevidad" value="6-8" class="peer sr-only" checked>
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">⌚</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">6-8h</span>
                        <span class="text-xs text-gray-400 mt-1">Largo</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="longevidad" value="8+" class="peer sr-only">
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">⏲️</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">8+ h</span>
                        <span class="text-xs text-gray-400 mt-1">Extra</span>
                    </div>
                </label>
            </div>
        </div>

        <!-- Sillage -->
        <div>
            <h3 class="text-center text-2xl font-serif font-light text-hermes-black mb-8">
                ¿Qué tan notorio?
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto">
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="sillage" value="intimo" class="peer sr-only">
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">🤫</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Íntimo</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="sillage" value="moderado" class="peer sr-only" checked>
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">💼</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Moderado</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="sillage" value="pronunciado" class="peer sr-only">
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">✨</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Pronunciado</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="radio" name="sillage" value="potente" class="peer sr-only">
                    <div class="h-28 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex flex-col items-center justify-center px-4">
                        <span class="text-2xl mb-2">💥</span>
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Potente</span>
                    </div>
                </label>
            </div>
        </div>
    </div>
</div>
```

**Update Progress Indicator**:
Change from 6 steps to 8 steps:
```html
<div class="flex items-center justify-center space-x-2">
    <div id="step-indicator-1" class="w-16 h-px bg-hermes-orange transition-all duration-500"></div>
    <div id="step-indicator-2" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
    <div id="step-indicator-3" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
    <div id="step-indicator-4" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
    <div id="step-indicator-5" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
    <div id="step-indicator-6" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
    <div id="step-indicator-7" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
    <div id="step-indicator-8" class="w-16 h-px bg-gray-300 transition-all duration-500"></div>
</div>
<p class="text-center text-xs text-gray-400 mt-6 tracking-[0.2em] uppercase font-light">
    <span id="current-step">1</span> de 8
</p>
```

**Update JavaScript navigation**:
Find `showStep()` function and update max steps:
```javascript
function showStep(stepNumber) {
    const steps = document.querySelectorAll('.step');
    const totalSteps = 8; // Changed from 6

    steps.forEach((step, index) => {
        step.classList.remove('active');
        if (index === stepNumber - 1) {
            step.classList.add('active');
        }
    });

    // Update indicators
    for (let i = 1; i <= totalSteps; i++) {
        const indicator = document.getElementById(`step-indicator-${i}`);
        if (i <= stepNumber) {
            indicator.classList.add('bg-hermes-orange');
            indicator.classList.remove('bg-gray-300');
        } else {
            indicator.classList.remove('bg-hermes-orange');
            indicator.classList.add('bg-gray-300');
        }
    }

    document.getElementById('current-step').textContent = stepNumber;

    // Update button visibility
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    const submitBtn = document.getElementById('submitBtn');

    prevBtn.style.display = stepNumber === 1 ? 'none' : 'inline-flex';
    nextBtn.style.display = stepNumber === totalSteps ? 'none' : 'inline-flex';
    submitBtn.style.display = stepNumber === totalSteps ? 'inline-flex' : 'none';
}
```

### 1.3 Update Routes (app/routes.py)

**Modify the `/resultados` POST handler** to capture new fields:
```python
@app.route('/resultados', methods=['GET', 'POST'])
@login_required
def resultados():
    if request.method == 'POST':
        # Existing fields
        preferencias = {
            'genero': request.form.get('genero'),
            'intensidad': request.form.get('intensidad'),
            'familia': request.form.get('familia'),
            'ocasiones': request.form.getlist('ocasiones'),
            'notas_preferidas': request.form.getlist('notas_preferidas'),
            'notas_rechazadas': request.form.getlist('notas_rechazadas'),

            # NEW FIELDS - Phase 1
            'clima': request.form.get('clima', 'versatil'),
            'estacion': request.form.get('estacion', 'todo_el_ano'),
            'longevidad_deseada': request.form.get('longevidad', '6-8'),
            'sillage_deseado': request.form.get('sillage', 'moderado')
        }

        # Filter out empty values
        preferencias = {k: v for k, v in preferencias.items() if v and v != ''}

        # Save to user profile
        current_user.preferencias = preferencias
        db.session.commit()

        # Get recommendations with new preferences
        engine = RecommendationEngine()
        recomendaciones = engine.recomendar_perfumes(
            usuario_id=current_user.id,
            preferencias=preferencias,
            limite=10
        )

        return render_template('resultados.html',
                             perfumes=recomendaciones,
                             preferencias=preferencias)

    # ... existing GET logic
```

### 1.4 Enhanced Recommendation Algorithm (services/recommendation_engine.py)

**Add new scoring methods** to `RecommendationEngine` class:

```python
def calcular_score_perfil(self, perfume, preferencias):
    """
    Enhanced scoring with environmental and performance factors
    """
    desglose = {
        'genero': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},
        'intensidad': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},
        'familia': {'puntos': 0, 'max': 25, 'match': False, 'detalle': ''},
        'ocasiones': {'puntos': 0, 'max': 20, 'match': False, 'detalle': ''},
        'notas_preferidas': {'puntos': 0, 'max': 25, 'match': False, 'detalle': ''},
        'notas_rechazadas': {'puntos': 0, 'max': 0, 'penalizacion': 0, 'detalle': ''},
        'clima': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},  # NEW
        'estacionalidad': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},  # NEW
        'longevidad': {'puntos': 0, 'max': 5, 'match': False, 'detalle': ''},  # NEW
        'sillage': {'puntos': 0, 'max': 5, 'match': False, 'detalle': ''},  # NEW
        'popularidad': {'puntos': 0, 'max': 10, 'rating': 0, 'detalle': ''},
        'marca_favorita': {'puntos': 0, 'max': 0, 'bonus': False, 'detalle': ''},
        'usuarios_similares': {'puntos': 0, 'max': 0, 'bonus': False, 'detalle': ''}
    }

    score = 0

    if not preferencias:
        return 0, desglose

    # ... [Keep existing gender, intensity, family, occasions, notes scoring] ...

    # NEW: Climate matching (10 points max)
    if 'clima' in preferencias and preferencias['clima'] and preferencias['clima'] != 'versatil':
        clima_perfume = perfume.get('clima_recomendado', 'versatil')

        if clima_perfume == preferencias['clima']:
            puntos = 10
            desglose['clima']['match'] = True
            desglose['clima']['detalle'] = f"Clima ideal: {clima_perfume}"
        elif clima_perfume == 'versatil':
            puntos = 7
            desglose['clima']['match'] = True
            desglose['clima']['detalle'] = "Versátil: Funciona en tu clima"
        else:
            # Partial match based on note compatibility
            puntos = self._calcular_compatibilidad_clima(
                preferencias['clima'],
                perfume.get('notas', [])
            )
            desglose['clima']['detalle'] = f"Adaptable a {preferencias['clima']}"

        desglose['clima']['puntos'] = puntos
        score += puntos

    # NEW: Seasonality matching (10 points max)
    if 'estacion' in preferencias and preferencias['estacion'] and preferencias['estacion'] != 'todo_el_ano':
        estacionalidad = perfume.get('estacionalidad', {})

        if isinstance(estacionalidad, dict) and preferencias['estacion'] in estacionalidad:
            rating_estacional = float(estacionalidad[preferencias['estacion']])
            puntos = rating_estacional * 10  # Convert 0.0-1.0 to 0-10

            if rating_estacional >= 0.8:
                desglose['estacionalidad']['match'] = True
                desglose['estacionalidad']['detalle'] = f"Perfecto para {preferencias['estacion']}"
            elif rating_estacional >= 0.6:
                desglose['estacionalidad']['match'] = True
                desglose['estacionalidad']['detalle'] = f"Muy bueno para {preferencias['estacion']}"
            else:
                desglose['estacionalidad']['detalle'] = f"Funciona en {preferencias['estacion']}"

            desglose['estacionalidad']['puntos'] = round(puntos, 1)
            score += puntos

    # NEW: Longevity matching (5 points max)
    if 'longevidad_deseada' in preferencias and preferencias['longevidad_deseada']:
        longevidad_perfume = perfume.get('longevidad_promedio', 6.0)
        puntos = self._match_longevidad(
            preferencias['longevidad_deseada'],
            longevidad_perfume
        )

        if puntos >= 4:
            desglose['longevidad']['match'] = True
            desglose['longevidad']['detalle'] = f"Dura {longevidad_perfume}h (ideal para ti)"
        else:
            desglose['longevidad']['detalle'] = f"Dura {longevidad_perfume}h"

        desglose['longevidad']['puntos'] = puntos
        score += puntos

    # NEW: Sillage matching (5 points max)
    if 'sillage_deseado' in preferencias and preferencias['sillage_deseado']:
        sillage_perfume = perfume.get('sillage_nivel', 'moderado')

        if sillage_perfume == preferencias['sillage_deseado']:
            puntos = 5
            desglose['sillage']['match'] = True
            desglose['sillage']['detalle'] = f"Proyección {sillage_perfume} (perfecta)"
        elif self._sillage_compatible(sillage_perfume, preferencias['sillage_deseado']):
            puntos = 3
            desglose['sillage']['detalle'] = f"Proyección {sillage_perfume} (aceptable)"
        else:
            puntos = 1
            desglose['sillage']['detalle'] = f"Proyección {sillage_perfume}"

        desglose['sillage']['puntos'] = puntos
        score += puntos

    # ... [Keep existing popularity, brand, collaborative scoring] ...

    return round(score, 2), desglose


def _calcular_compatibilidad_clima(self, clima_usuario, notas_perfume):
    """
    Calculate climate compatibility based on notes
    Returns 0-10 points
    """
    clima_notas_mapping = {
        'calido': ['citrus', 'aquatic', 'marine', 'fresh', 'bergamota', 'limon', 'naranja'],
        'frio': ['amber', 'vanilla', 'spice', 'woody', 'vainilla', 'ambar', 'canela', 'cedro'],
        'templado': ['floral', 'fruity', 'green', 'rosa', 'jazmin', 'lavanda']
    }

    notas_ideales = clima_notas_mapping.get(clima_usuario, [])
    notas_perfume_lower = [n.lower() for n in notas_perfume]

    matches = sum(1 for nota in notas_ideales if any(nota in n for n in notas_perfume_lower))

    if len(notas_ideales) == 0:
        return 5  # Default middle score

    compatibilidad = matches / len(notas_ideales)
    return round(compatibilidad * 10, 1)


def _match_longevidad(self, deseada_range, perfume_horas):
    """
    Match desired longevity range with perfume's actual longevity
    Returns 0-5 points
    """
    rangos = {
        '2-4': (2, 4),
        '4-6': (4, 6),
        '6-8': (6, 8),
        '8+': (8, 24)
    }

    min_h, max_h = rangos.get(deseada_range, (6, 8))

    if min_h <= perfume_horas <= max_h:
        return 5  # Perfect match
    elif perfume_horas < min_h:
        # Too short - penalty proportional
        return max(1, (perfume_horas / min_h) * 5)
    else:
        # Too long - minor penalty (longer is often acceptable)
        return max(3, (max_h / perfume_horas) * 5)


def _sillage_compatible(self, sillage_perfume, sillage_deseado):
    """
    Check if sillage levels are compatible (adjacent levels okay)
    """
    niveles = ['intimo', 'moderado', 'pronunciado', 'potente']

    try:
        idx_perfume = niveles.index(sillage_perfume)
        idx_deseado = niveles.index(sillage_deseado)
        return abs(idx_perfume - idx_deseado) <= 1
    except ValueError:
        return False


def recomendar_perfumes(self, usuario_id=None, preferencias=None, limite=5, sesion_id=None):
    # ... [Keep existing logic] ...

    # Update score_maximo calculation to include new factors
    score_maximo = 130  # Base: 10+10+25+20+25+10+10+10+5+5 = 130 points
    if preferencias.get('marca_preferida'):
        score_maximo += 15
    if usuario_id:
        score_maximo += 20

    # ... [Rest of existing logic] ...
```

### 1.5 Populate Database with New Data

**Create a data population script** (`scripts/populate_advanced_attributes.py`):
```python
from services.database_service import DatabaseService
from sqlalchemy import text

db_service = DatabaseService()
db = db_service.get_db()

# Climate assignment based on family
climate_by_family = {
    'Citrica': 'calido',
    'Floral': 'templado',
    'Amaderada': 'versatil',
    'Oriental': 'frio',
    'Aromatica': 'templado'
}

# Seasonality ratings by family
seasonality_by_family = {
    'Citrica': {"primavera": 0.8, "verano": 0.9, "otono": 0.4, "invierno": 0.3},
    'Floral': {"primavera": 0.9, "verano": 0.7, "otono": 0.6, "invierno": 0.4},
    'Amaderada': {"primavera": 0.5, "verano": 0.4, "otono": 0.8, "invierno": 0.9},
    'Oriental': {"primavera": 0.4, "verano": 0.3, "otono": 0.8, "invierno": 0.9},
    'Aromatica': {"primavera": 0.7, "verano": 0.6, "otono": 0.7, "invierno": 0.6}
}

# Longevity by intensity
longevity_by_intensity = {
    'EDT': 4.5,
    'EDP': 6.5,
    'Parfum': 8.5,
    'Extrait': 10.0
}

# Sillage by intensity (general rule)
sillage_by_intensity = {
    'EDT': 'moderado',
    'EDP': 'pronunciado',
    'Parfum': 'pronunciado',
    'Extrait': 'potente'
}

try:
    perfumes = db.execute(text("""
        SELECT p.id, f.nombre as familia, i.nivel as intensidad
        FROM perfumes p
        LEFT JOIN familias_olfativas f ON p.familia_id = f.id
        LEFT JOIN intensidades i ON p.intensidad_id = i.id
    """)).fetchall()

    for perfume in perfumes:
        clima = climate_by_family.get(perfume.familia, 'versatil')
        estacionalidad = seasonality_by_family.get(perfume.familia, {
            "primavera": 0.5, "verano": 0.5, "otono": 0.5, "invierno": 0.5
        })
        longevidad = longevity_by_intensity.get(perfume.intensidad, 6.0)
        sillage = sillage_by_intensity.get(perfume.intensidad, 'moderado')

        db.execute(text("""
            UPDATE perfumes
            SET clima_recomendado = :clima,
                estacionalidad = :estacionalidad::jsonb,
                longevidad_promedio = :longevidad,
                sillage_nivel = :sillage
            WHERE id = :id
        """), {
            'clima': clima,
            'estacionalidad': str(estacionalidad).replace("'", '"'),
            'longevidad': longevidad,
            'sillage': sillage,
            'id': perfume.id
        })

    db.commit()
    print(f"✅ Successfully updated {len(perfumes)} perfumes with advanced attributes")

except Exception as e:
    db.rollback()
    print(f"❌ Error: {e}")
finally:
    db_service.close_db()
```

**Run the script**:
```bash
cd /Users/jordiariassantaella/Development/Perfume_Curator
python scripts/populate_advanced_attributes.py
```

---

## Phase 2: Personality & Lifestyle Integration
**Time Estimate**: 8-10 hours
**Impact**: Medium-High (deeper personalization)
**Complexity**: Medium (requires subjective mapping)

### 2.1 Add Personality Assessment (Optional Step)

**Add as final optional step** in questionnaire:
```html
<!-- Step 9: Personalidad (Optional) -->
<div class="step" data-step="9">
    <div class="text-center mb-20">
        <h2 class="font-serif text-5xl md:text-6xl font-light text-hermes-black mb-4 tracking-tight">
            Personalidad
            <span class="text-sm text-gray-400 block mt-4">(Opcional)</span>
        </h2>
        <p class="text-base text-gray-500 font-light">
            Ayúdanos a entender tu estilo personal
        </p>
    </div>

    <div class="space-y-12">
        <!-- Color Preference -->
        <div>
            <h3 class="text-center text-xl font-light text-gray-600 mb-6 tracking-[0.15em] uppercase">
                ¿Qué color te atrae más?
            </h3>
            <div class="grid grid-cols-4 md:grid-cols-8 gap-3 max-w-4xl mx-auto">
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="rojo" class="sr-only peer">
                    <div class="w-full h-full bg-red-500 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="naranja" class="sr-only peer">
                    <div class="w-full h-full bg-orange-500 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="amarillo" class="sr-only peer">
                    <div class="w-full h-full bg-yellow-400 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="verde" class="sr-only peer">
                    <div class="w-full h-full bg-green-600 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="azul" class="sr-only peer">
                    <div class="w-full h-full bg-blue-600 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="morado" class="sr-only peer">
                    <div class="w-full h-full bg-purple-600 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="negro" class="sr-only peer">
                    <div class="w-full h-full bg-black hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
                <label class="aspect-square cursor-pointer">
                    <input type="radio" name="color_preferencia" value="blanco" class="sr-only peer">
                    <div class="w-full h-full bg-white border border-gray-300 hover:scale-110 transition-transform duration-300 peer-checked:ring-4 peer-checked:ring-hermes-orange"></div>
                </label>
            </div>
        </div>

        <!-- Lifestyle Archetype -->
        <div>
            <h3 class="text-center text-xl font-light text-gray-600 mb-6 tracking-[0.15em] uppercase">
                ¿Cómo te describes?
            </h3>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4 max-w-4xl mx-auto">
                <label class="group relative cursor-pointer block">
                    <input type="checkbox" name="personalidad" value="sofisticado" class="peer sr-only">
                    <div class="h-20 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex items-center justify-center px-4">
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Sofisticado</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="checkbox" name="personalidad" value="aventurero" class="peer sr-only">
                    <div class="h-20 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex items-center justify-center px-4">
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Aventurero</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="checkbox" name="personalidad" value="romantico" class="peer sr-only">
                    <div class="h-20 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex items-center justify-center px-4">
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Romántico</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="checkbox" name="personalidad" value="minimalista" class="peer sr-only">
                    <div class="h-20 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex items-center justify-center px-4">
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Minimalista</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="checkbox" name="personalidad" value="sensual" class="peer sr-only">
                    <div class="h-20 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex items-center justify-center px-4">
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Sensual</span>
                    </div>
                </label>
                <label class="group relative cursor-pointer block">
                    <input type="checkbox" name="personalidad" value="natural" class="peer sr-only">
                    <div class="h-20 border border-gray-300 bg-white hover:border-hermes-orange transition-all duration-300 peer-checked:border-hermes-orange peer-checked:bg-hermes-orange/5 flex items-center justify-center px-4">
                        <span class="text-sm font-light text-gray-600 peer-checked:text-hermes-orange tracking-[0.15em] uppercase transition-all duration-300 text-center">Natural</span>
                    </div>
                </label>
            </div>
        </div>
    </div>
</div>
```

### 2.2 Personality-to-Fragrance Mapping

**Add to recommendation_engine.py**:
```python
def _calcular_bonus_personalidad(self, perfume, color_pref, personalidades):
    """
    Calculate personality alignment bonus
    Returns 0-10 points
    """
    bonus = 0

    # Color psychology mapping
    color_familia_map = {
        'rojo': ['Oriental', 'Amaderada'],
        'naranja': ['Citrica', 'Oriental'],
        'amarillo': ['Citrica', 'Aromatica'],
        'verde': ['Aromatica', 'Amaderada'],
        'azul': ['Citrica', 'Aromatica'],
        'morado': ['Floral', 'Oriental'],
        'negro': ['Amaderada', 'Oriental'],
        'blanco': ['Floral', 'Citrica']
    }

    if color_pref and perfume.get('familia') in color_familia_map.get(color_pref, []):
        bonus += 3

    # Personality archetype mapping
    personalidad_notas_map = {
        'sofisticado': ['aldehidos', 'iris', 'cuero'],
        'aventurero': ['oud', 'incienso', 'especias'],
        'romantico': ['rosa', 'jazmin', 'vainilla'],
        'minimalista': ['almizcle', 'algodon', 'te blanco'],
        'sensual': ['ambar', 'vainilla', 'ylang-ylang'],
        'natural': ['vetiver', 'musgo', 'cedro']
    }

    notas_perfume_lower = [n.lower() for n in perfume.get('notas', [])]

    for personalidad in (personalidades or []):
        notas_ideales = personalidad_notas_map.get(personalidad, [])
        matches = sum(1 for nota in notas_ideales if any(nota in n for n in notas_perfume_lower))
        if matches > 0:
            bonus += min(matches * 2, 7)  # Max 7 points from personality

    return min(bonus, 10)  # Cap at 10 points
```

---

## Phase 3: Advanced ML & Personalization
**Time Estimate**: 15-20 hours
**Impact**: High (long-term)
**Complexity**: High (requires ML implementation)

### 3.1 Cosine Similarity for "Similar Perfumes"

**Add to recommendation_engine.py**:
```python
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity

def _crear_vector_perfume(self, perfume):
    """
    Create a feature vector for a perfume
    Returns numpy array
    """
    # Binary encoding of categorical features
    familias = ['Citrica', 'Floral', 'Amaderada', 'Oriental', 'Aromatica']
    intensidades = ['EDT', 'EDP', 'Parfum', 'Extrait']
    generos = ['Hombre', 'Mujer', 'Unisex']

    vector = []

    # Family (one-hot encoding)
    vector.extend([1 if perfume.get('familia') == f else 0 for f in familias])

    # Intensity (one-hot encoding)
    vector.extend([1 if perfume.get('intensidad') == i else 0 for i in intensidades])

    # Gender (one-hot encoding)
    vector.extend([1 if perfume.get('genero') == g else 0 for g in generos])

    # Notes (multi-hot encoding - top 20 common notes)
    notas_comunes = ['bergamota', 'rosa', 'jazmin', 'vainilla', 'ambar', 'cedro',
                     'sandalwood', 'pachuli', 'vetiver', 'limon', 'lavanda', 'musk',
                     'naranja', 'canela', 'pimienta', 'geranio', 'lirio', 'almizcle',
                     'oud', 'cuero']

    notas_perfume_lower = [n.lower() for n in perfume.get('notas', [])]
    vector.extend([1 if nota in notas_perfume_lower else 0 for nota in notas_comunes])

    # Numerical features (normalized 0-1)
    vector.append(perfume.get('longevidad_promedio', 6.0) / 12.0)  # Normalize to 0-1
    vector.append(float(perfume.get('puntuacion_popularidad', 3.0)) / 5.0)

    return np.array(vector)


def encontrar_perfumes_similares(self, perfume_id, limite=5):
    """
    Find similar perfumes using cosine similarity
    """
    perfumes = self.db_service.get_vista_perfumes_completa()
    perfume_base = next((p for p in perfumes if p['id'] == perfume_id), None)

    if not perfume_base:
        return []

    # Create vectors for all perfumes
    vector_base = self._crear_vector_perfume(perfume_base)

    similitudes = []
    for perfume in perfumes:
        if perfume['id'] == perfume_id:
            continue

        vector_perfume = self._crear_vector_perfume(perfume)
        similaridad = cosine_similarity([vector_base], [vector_perfume])[0][0]

        similitudes.append({
            'perfume': perfume,
            'similaridad': similaridad
        })

    # Sort by similarity
    similitudes.sort(key=lambda x: x['similaridad'], reverse=True)

    return [item['perfume'] for item in similitudes[:limite]]
```

### 3.2 Learning from User Feedback

**Track implicit feedback** (views, time spent):
```python
# Add to routes.py
@app.route('/api/track/view', methods=['POST'])
@login_required
def track_view():
    perfume_id = request.json.get('perfume_id')
    time_spent = request.json.get('time_spent_seconds', 0)

    # Log view
    from models.usuario import Busqueda
    db.session.add(Busqueda(
        usuario_id=current_user.id,
        criterios={'action': 'view', 'perfume_id': perfume_id, 'duration': time_spent},
        resultados_obtenidos=1
    ))
    db.session.commit()

    return jsonify({'success': True})


@app.route('/api/favoritos/toggle', methods=['POST'])
@login_required
def toggle_favorito():
    perfume_id = request.json.get('perfume_id')

    from models.usuario import Favorito
    favorito_existente = db.session.query(Favorito).filter_by(
        usuario_id=current_user.id,
        perfume_id=perfume_id
    ).first()

    if favorito_existente:
        db.session.delete(favorito_existente)
        accion = 'removed'
    else:
        db.session.add(Favorito(
            usuario_id=current_user.id,
            perfume_id=perfume_id
        ))
        accion = 'added'

    db.session.commit()
    return jsonify({'success': True, 'action': accion})
```

---

## Testing & Validation Plan

### Phase 1 Testing Checklist

- [ ] Database migrations run successfully
- [ ] New questionnaire steps display correctly (8 steps total)
- [ ] Progress indicator updates from 1/8 to 8/8
- [ ] Form submission captures all new fields
- [ ] User preferences JSON stores new fields correctly
- [ ] Recommendation engine incorporates new scoring (clima, estacionalidad, longevidad, sillage)
- [ ] Compatibility percentage reflects new factors
- [ ] Perfumes with better environmental/performance match rank higher
- [ ] Mobile responsive design maintained
- [ ] No JavaScript errors in console
- [ ] Page load times remain acceptable (<2s)

### Test Scenarios

**Scenario 1: Hot Climate, Summer, Long Longevity**
- Select: Cálido + Verano + 8+ hours + Pronunciado
- Expected: High scores for EDT/EDP citrus/aquatic fragrances with good longevity
- Should NOT rank: Heavy orientals, winter fragrances

**Scenario 2: Cold Climate, Winter, Moderate Sillage**
- Select: Frío + Invierno + 6-8 hours + Moderado
- Expected: High scores for warm amaderadas/orientales, EDP concentration
- Should NOT rank: Light citrus, summer fragrances

**Scenario 3: All-season Versatile**
- Select: Versatil + Todo el año + 4-6 hours + Moderado
- Expected: Balanced recommendations across families
- Versatile perfumes should score higher

---

## Rollout Strategy

### Week 1: Foundation (Phase 1 - Part 1)
- Day 1-2: Database schema updates and migrations
- Day 3-4: Questionnaire UI updates (clima, estacionalidad)
- Day 5: Testing and bug fixes

### Week 2: Algorithm Enhancement (Phase 1 - Part 2)
- Day 1-2: Update recommendation algorithm with new factors
- Day 3: Populate existing perfumes with new attributes
- Day 4-5: End-to-end testing and refinement

### Week 3: Performance Features (Phase 1 - Part 3)
- Day 1-2: Add longevidad/sillage questionnaire step
- Day 3: Integrate performance matching in algorithm
- Day 4-5: User acceptance testing

### Week 4: Polish & Launch
- Day 1-2: Mobile testing and responsive fixes
- Day 3: Performance optimization
- Day 4: Documentation updates
- Day 5: Production deployment

### Future: Phase 2 & 3
- Month 2: Personality features (optional)
- Month 3: ML similarity engine
- Month 4: User feedback learning loop

---

## Success Metrics

**Quantitative**:
- Avg compatibility score: Target >75%
- User satisfaction: Track ratings on recommendations
- Conversion rate: % users who favorite/purchase
- Return rate: % users who retake quiz
- Session duration: Increase due to better matches

**Qualitative**:
- User feedback: "Recommendations feel more relevant"
- Complaint reduction: Fewer "doesn't match my climate" issues
- Engagement: More detailed quiz responses

---

## Risk Mitigation

**Risk**: Too many questionnaire steps (user drop-off)
**Mitigation**:
- Make steps 8-9 optional
- Add "skip" option for non-critical questions
- Track completion rates and adjust

**Risk**: Database performance with complex scoring
**Mitigation**:
- Index new columns (clima_recomendado, sillage_nivel)
- Cache perfume vectors for similarity calculations
- Limit result set size (max 50 perfumes scored)

**Risk**: Inaccurate attribute assignment
**Mitigation**:
- Start with algorithmic assignment (family-based)
- Allow manual override in admin panel
- Collect user feedback to refine

**Risk**: Mobile experience degradation
**Mitigation**:
- Test on real devices (iOS Safari, Android Chrome)
- Use mobile-first CSS approach
- Compress images and lazy load

---

## Next Steps - Immediate Actions

1. **Review this roadmap** with team/stakeholders
2. **Create git branch**: `feature/advanced-recommendations`
3. **Run database migrations** (backup first!)
4. **Update questionnaire HTML** (8 steps)
5. **Test locally** with existing perfume data
6. **Iterate based on results**

---

**Document Status**: Ready for Implementation
**Last Updated**: January 6, 2026
**Owner**: Paymsa Development Team
