# Interfaz de Lujo - Paymsa

## Descripción

Se ha rediseñado completamente la interfaz de Paymsa con un **estilo de lujo minimalista y profesional**, ideal para presentarse en un showroom de alta gama. La interfaz utiliza:

- **Tailwind CSS v3.4+** (CDN)
- **Diseño oscuro elegante** con acentos dorados
- **Tipografía serif premium** (Playfair Display)
- **Interactividad moderna** con transiciones suaves
- **Layout responsive** optimizado para todos los dispositivos

## Características del Diseño

### Colores
- **Primary**: Dorado (`hsl(45, 70%, 55%)`)
- **Backgrounds**: Gradientes oscuros (`#0f0f0f` → `#0a0a0a`)
- **Textos**: Blancos y grises suaves
- **Bordes**: Sutil y elegante

### Tipografía
- **Headings**: Playfair Display (serif elegante)
- **Body**: Inter (sans-serif moderna)

### Elementos UI

#### Cards y Contenedores
- Bordes sutiles con hover states
- Sombras suaves
- Gradientes dorados en elementos destacados
- Animaciones de fade-in

#### Botones
- Botón primario: Gradiente dorado con hover effect
- Botón secundario: Borde con hover dorado
- Transformaciones suaves (-translate-y)
- Sombras en hover

#### Formularios
- Inputs con borde sutil
- Focus ring dorado
- Radio/checkbox buttons personalizados
- Estados checked elegantes

#### Navegación
- Barra fija con backdrop blur
- Logo circular con gradiente dorado
- Links con hover dorado
- Responsive mobile menu

### Secciones

#### 1. Hero Section
- Títulos grandes con gradiente dorado
- Animaciones suaves
- Botones CTA prominentes

#### 2. Cuestionario
- 6 secciones numeradas
- Cards con bordes elegantes
- Selección visual con estados checked
- Grid responsive

#### 3. Resultados/Colección
- Cards de perfumes con hover effects
- Score badges dorados
- Botones de favoritos animados
- Pyramid olfativa visual

#### 4. Perfil de Usuario
- Dos columnas (preferencias + favoritos)
- Grid de opciones seleccionables
- Historial de búsquedas
- Cards con contenido desplazable

#### 5. Login/Registro
- Centrados y minimalistas
- Logo con gradiente
- Inputs elegantes
- Focus states dorados

## Archivos Modificados/Creados

### Plantillas HTML
1. `base.html` - Template base con Tailwind
2. `index.html` - Landing con cuestionario
3. `resultados.html` - Grid de perfumes y detalle
4. `login.html` - Formulario de login
5. `register.html` - Formulario de registro
6. `perfil.html` - Perfil de usuario

### Estilos
1. `static/css/style.css` - Configuración Tailwind

### Scripts
- JavaScript inline para toggle favoritos
- Flash messages con auto-dismiss
- Animaciones CSS

## Configuración de Tailwind

### CDN (En línea)
```html
<script src="https://cdn.tailwindcss.com"></script>
```

### Personalización
```javascript
tailwind.config = {
    darkMode: 'class',
    theme: {
        extend: {
            colors: {
                luxury: {
                    gold: 'hsl(45, 70%, 55%)',
                    'gold-light': 'hsl(45, 60%, 70%)',
                    dark: 'hsl(220, 30%, 10%)',
                    darker: 'hsl(220, 30%, 7%)',
                    border: 'hsl(220, 20%, 18%)',
                },
            },
            fontFamily: {
                serif: ['Playfair Display', 'serif'],
                sans: ['Inter', 'system-ui', 'sans-serif'],
            },
            backgroundImage: {
                'luxury-gradient': 'radial-gradient(circle at top, rgba(45, 45, 45, 1) 0%, rgba(15, 15, 15, 1) 100%)',
                'gold-gradient': 'linear-gradient(135deg, hsl(var(--luxury-gold)) 0%, hsl(var(--luxury-gold-light)) 100%)',
            },
        },
    },
}
```

## Características Especiales

### 1. Animaciones
- `animate-fade-in`: Aparece suavemente desde abajo
- `animate-shimmer`: Efecto de brillo (para loading states)
- Hover effects con transformaciones

### 2. Interactividad
- Toggle favoritos con JavaScript
- Formularios con validación
- Flash messages auto-dismiss
- Responsive navigation

### 3. Responsive Design
- Mobile-first approach
- Grids adaptativos
- Breakpoints: sm, md, lg, xl
- Touch-friendly targets

### 4. Accesibilidad
- Contrast ratios cumplidos
- Focus visibles
- Labels en inputs
- Alt text en imágenes

## Compatibilidad con shadcn/ui

El diseño sigue los principios de shadcn/ui:
- ✅ Componentes minimalistas
- ✅ Customizables vía Tailwind
- ✅ Dark mode native
- ✅ Animaciones suaves
- ✅ Diseño consistente

**Nota**: Como shadcn/ui es específico de React, se ha recreado el estilo usando Tailwind CSS puro, compatible con Flask/Jinja2.

## Ejecutar la Aplicación

```bash
python app.py
```

Accede a: `http://127.0.0.1:5001`

## Personalización

### Cambiar Colores

Edita `app/templates/base.html`:
```javascript
colors: {
    luxury: {
        gold: 'hsl(45, 70%, 55%)',      // Cambiar tono dorado
        dark: 'hsl(220, 30%, 10%)',    // Cambiar fondo oscuro
        // ... otros colores
    },
}
```

### Cambiar Fuentes

Edita en `base.html`:
```html
<link href="https://fonts.googleapis.com/css2?family=TU+FUENTE+Sans:wght@400;500;600&display=swap" rel="stylesheet">
```

Y en la config de Tailwind:
```javascript
fontFamily: {
    serif: ['TU FUENTE SERIF', 'serif'],
    sans: ['TU FUENTE SANS', 'sans-serif'],
},
```

### Agregar Animaciones

En `static/css/style.css`:
```css
@keyframes tuAnimacion {
    from { opacity: 0; }
    to { opacity: 1; }
}
.tu-animacion {
    animation: tuAnimacion 0.5s ease-out;
}
```

## Optimización

### Performance
- CDN de Tailwind para desarrollo
- Para producción: Considerar build con PostCSS/Tailwind CLI
- Lazy loading de imágenes cuando se agreguen reales
- Minificar CSS en producción

### SEO
- Meta tags en `base.html`
- Open Graph cuando se agreguen imágenes reales
- Schema.org markup para productos (perfumes)

## Próximos Mejoras Sugeridas

1. **Imágenes Reales**: Agregar fotos de perfumes reales
2. **Loading States**: Skeletons con animación shimmer
3. **Modales**: Detalle del perfume en modal
4. **Filtros Avanzados**: Sidebar con sliders de precio
5. **Carrito de Compras**: Si se integra e-commerce
6. **Reviews System**: Estrellas interactivas
7. **Wishlist**: Guardar múltiples listas
8. **Social Sharing**: Botones para compartir perfumes

## Troubleshooting

### Tailwind no carga
- Verifica la conexión a internet (CDN)
- Revisa la consola del navegador

### Estilos no aplican
- Limpia caché del navegador
- Verifica que el script de Tailwind está en el head

### Responsive no funciona
- Verifica viewport meta tag
- Revisa breakpoints en Tailwind config

---

**Resultado**: Una interfaz elegante, profesional y de lujo perfecta para un showroom de alta gama.