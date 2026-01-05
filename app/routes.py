from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify
from flask_login import login_user, logout_user, login_required, current_user
from models import Usuario
from services import DatabaseService, RecommendationEngine

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    from flask import current_app
    db_service = current_app.db_service

    opciones = db_service.get_opciones_filtro()

    return render_template('index.html', opciones=opciones)

@main_bp.route('/register', methods=['GET', 'POST'])
def register():
    from flask import current_app
    db_service = current_app.db_service

    if request.method == 'POST':
        email = request.form.get('email')
        nombre = request.form.get('nombre')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')

        if password != confirm_password:
            flash('Las contraseñas no coinciden', 'error')
            return redirect(url_for('main.register'))

        resultado = db_service.registrar_usuario({
            'email': email,
            'nombre': nombre,
            'password': password
        })

        if resultado['success']:
            # Auto-login después del registro
            from models import Usuario
            from sqlalchemy.orm import sessionmaker

            engine = db_service.get_db().bind
            Session = sessionmaker(bind=engine)
            db = Session()
            try:
                usuario = db.query(Usuario).filter(Usuario.email == email).first()
                login_user(usuario)
                flash('¡Bienvenido! Comencemos a descubrir tu fragancia perfecta.', 'success')
                return redirect(url_for('main.index') + '#questionnaire')
            finally:
                db.close()
        else:
            flash(resultado['message'], 'error')
            return redirect(url_for('main.register'))

    return render_template('register.html')

@main_bp.route('/login', methods=['GET', 'POST'])
def login():
    from flask import current_app
    db_service = current_app.db_service

    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        resultado = db_service.auth_usuario(email, password)

        if resultado['success']:
            from models import Usuario
            from sqlalchemy.orm import sessionmaker

            engine = db_service.get_db().bind
            Session = sessionmaker(bind=engine)
            db = Session()
            try:
                usuario = db.query(Usuario).filter(Usuario.email == email).first()
                login_user(usuario)
                flash('¡Bienvenido!', 'success')
                return redirect(url_for('main.index'))
            finally:
                db.close()
        else:
            flash(resultado['message'], 'error')
            return redirect(url_for('main.login'))

    return render_template('login.html')

@main_bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Has cerrado sesión', 'info')
    return redirect(url_for('main.index'))

@main_bp.route('/perfil', methods=['GET', 'POST'])
@login_required
def perfil():
    from flask import current_app
    db_service = current_app.db_service

    if request.method == 'POST':
        preferencias = {
            'genero': request.form.get('genero'),
            'intensidad': request.form.get('intensidad'),
            'familia': request.form.get('familia'),
            'ocasiones': request.form.getlist('ocasiones'),
            'notas_preferidas': request.form.getlist('notas_preferidas'),
            'notas_rechazadas': request.form.getlist('notas_rechazadas')
        }

        resultado = db_service.actualizar_preferencias(current_user.id, preferencias)
        if resultado['success']:
            flash('Preferencias actualizadas', 'success')
        else:
            flash('Error actualizando preferencias', 'error')

    usuario_data = db_service.get_usuario_by_id(current_user.id)
    opciones = db_service.get_opciones_filtro()

    return render_template('perfil.html', usuario=usuario_data, opciones=opciones)

@main_bp.route('/resultados', methods=['GET', 'POST'])
def resultados():
    from flask import current_app
    db_service = current_app.db_service
    recommendation_engine = current_app.recommendation_engine

    preferencias = {
        'genero': request.form.get('genero') or session.get('genero'),
        'intensidad': request.form.get('intensidad') or session.get('intensidad'),
        'familia': request.form.get('familia') or session.get('familia'),
        'ocasiones': request.form.getlist('ocasiones') or session.get('ocasiones', []),
        'notas_preferidas': request.form.getlist('notas_preferidas') or session.get('notas_preferidas', []),
        'notas_rechazadas': request.form.getlist('notas_rechazadas') or session.get('notas_rechazadas', [])
    }

    if request.method == 'POST':
        session.update(preferencias)

    # Verificar si hay preferencias definidas
    tiene_preferencias = any([
        preferencias.get('genero'),
        preferencias.get('intensidad'),
        preferencias.get('familia'),
        preferencias.get('ocasiones'),
        preferencias.get('notas_preferidas'),
        preferencias.get('notas_rechazadas')
    ])


    # Si NO hay preferencias (acceso directo a Colección), mostrar TODOS los perfumes
    if not tiene_preferencias and request.method == 'GET':
        recomendaciones = db_service.get_vista_perfumes_completa()
        # Ordenar por puntuación de popularidad
        recomendaciones.sort(key=lambda x: x.get('puntuacion_popularidad', 0), reverse=True)
        # Limitar a 20 perfumes top para visualización en showroom
        recomendaciones = recomendaciones[:20]
    else:
        # Si hay preferencias, usar motor de recomendaciones con límite reducido
        limite = 12  # Showroom de lujo: 12 recomendaciones selectas
        recomendaciones = recommendation_engine.recomendar_perfumes(
            usuario_id=current_user.id if current_user.is_authenticated else None,
            preferencias=preferencias if tiene_preferencias else None,
            limite=limite
        )

    if current_user.is_authenticated and tiene_preferencias:
        db_service.registrar_busqueda(
            current_user.id,
            preferencias,
            len(recomendaciones)
        )

    opciones = db_service.get_opciones_filtro()

    return render_template('resultados.html',
                          recomendaciones=recomendaciones,
                          preferencias=preferencias,
                          opciones=opciones)

@main_bp.route('/favoritos/<int:perfume_id>', methods=['POST'])
@login_required
def toggle_favorito(perfume_id):
    from flask import current_app
    db_service = current_app.db_service

    resultado = db_service.agregar_favorito(current_user.id, perfume_id)

    if resultado['success']:
        if resultado['action'] == 'added':
            flash('Agregado a favoritos', 'success')
        else:
            flash('Eliminado de favoritos', 'info')
    else:
        flash('Error gestionando favorito', 'error')

    return redirect(url_for('main.perfil'))

@main_bp.route('/historial')
@login_required
def historial():
    from flask import current_app
    db_service = current_app.db_service

    historial = db_service.obtener_historial(current_user.id)

    return render_template('perfil.html', usuario=db_service.get_usuario_by_id(current_user.id),
                          historial=historial, active_tab='historial')

@main_bp.route('/perfume/<int:perfume_id>')
def detalle_perfume(perfume_id):
    from flask import current_app
    db_service = current_app.db_service

    perfume = db_service.get_perfume_by_id(perfume_id)

    if not perfume:
        flash('Perfume no encontrado', 'error')
        return redirect(url_for('main.index'))

    valoraciones = db_service.obtener_valoraciones_perfume(perfume_id)

    return render_template('resultados.html', perfume=perfume, valoraciones=valoraciones)