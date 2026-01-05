from flask import Flask, g
from flask_login import LoginManager
from config import Config
import os

def create_app():
    # Configurar rutas correctas para templates y static
    template_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), 'templates'))
    static_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'static'))

    app = Flask(__name__,
                template_folder=template_dir,
                static_folder=static_dir,
                static_url_path='/static')
    app.config.from_object(Config)

    from services import DatabaseService, RecommendationEngine

    app.db_service = DatabaseService()
    app.recommendation_engine = RecommendationEngine()

    login_manager = LoginManager()
    login_manager.init_app(app)
    login_manager.login_view = 'login'
    login_manager.login_message = 'Por favor inicia sesión para acceder a esta página'

    @login_manager.user_loader
    def load_user(user_id):
        from models import Usuario
        from sqlalchemy.orm import sessionmaker
        engine = app.db_service.get_db().bind
        Session = sessionmaker(bind=engine)
        db = Session()
        try:
            return db.query(Usuario).filter(Usuario.id == int(user_id)).first()
        finally:
            db.close()

    from app.routes import main_bp
    app.register_blueprint(main_bp)

    @app.teardown_appcontext
    def teardown_db(exception=None):
        app.db_service.close_db()

    @app.context_processor
    def utility_processor():
        def es_favorito(perfume_id):
            from flask_login import current_user
            if current_user.is_authenticated:
                return app.db_service.es_favorito(current_user.id, perfume_id)
            return False

        return dict(es_favorito=es_favorito)

    return app