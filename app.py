from app import create_app
from services import DatabaseService

app = create_app()

if __name__ == '__main__':
    db_service = DatabaseService()

    print("Inicializando base de datos...")
    db_service.init_db()
    print("Base de datos inicializada correctamente")

    print("Iniciando servidor Flask...")
    app.run(host='127.0.0.1', port=5001, debug=True)