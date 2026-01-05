import os
from sqlalchemy import text, func
from sqlalchemy.orm import joinedload
from models import (
    SessionLocal, Perfume, Usuario, Favorito, Busqueda, Valoracion,
    Marca, FamiliaOlfatica, Intensidad, Genero, NotaOlfativa, Ocasion,
    PerfumeNotas, PerfumeOcasiones
)
from werkzeug.security import generate_password_hash, check_password_hash

class DatabaseService:
    def __init__(self):
        self.db = None

    def get_db(self):
        if not self.db:
            self.db = SessionLocal()
        return self.db

    def close_db(self):
        if self.db:
            self.db.close()
            self.db = None

    def init_db(self):
        db = self.get_db()
        try:
            schema_dir = os.path.join(os.path.dirname(__file__), '..', 'database', 'schema')
            schema_files = [
                '001_initial_schema.sql',
                '002_seed_data.sql',
                '003_indexes.sql',
                '004_additional_luxury_perfumes.sql',
                '005_user_feedback_system.sql'
            ]

            for file in schema_files:
                file_path = os.path.join(schema_dir, file)
                if os.path.exists(file_path):
                    with open(file_path, 'r') as f:
                        sql = f.read()
                        db.execute(text(sql))
                        db.commit()
                        print(f"Ejecutado: {file}")

            print("Base de datos inicializada correctamente")
            return True
        except Exception as e:
            db.rollback()
            print(f"Error inicializando base de datos: {e}")
            return False
        finally:
            self.close_db()

    def get_vista_perfumes_completa(self):
        db = self.get_db()
        try:
            result = db.execute(text("""
                SELECT * FROM vista_perfumes_completa
            """))

            perfumes = []
            for row in result:
                perfumes.append({
                    'id': row[0],
                    'nombre': row[1],
                    'descripcion': row[2],
                    'precio_ml': float(row[3]) if row[3] else None,
                    'puntuacion_popularidad': float(row[4]) if row[4] else 0,
                    'ano_lanzamiento': row[5],
                    'imagen_url': row[6],
                    'marca': row[7],
                    'familia': row[8],
                    'intensidad': row[9],
                    'genero': row[10],
                    'ocasiones': row[11] if row[11] else [],
                    'notas': row[12] if row[12] else [],
                    'notas_salida': row[13] if row[13] else [],
                    'notas_corazon': row[14] if row[14] else [],
                    'notas_fondo': row[15] if row[15] else []
                })
            return perfumes
        except Exception as e:
            print(f"Error obteniendo vista completa: {e}")
            return []
        finally:
            self.close_db()

    def get_perfumes_filtrados(self, filtros):
        db = self.get_db()
        try:
            query = db.query(Perfume).options(
                joinedload(Perfume.marca),
                joinedload(Perfume.familia),
                joinedload(Perfume.intensidad),
                joinedload(Perfume.genero),
                joinedload(Perfume.notas),
                joinedload(Perfume.ocasiones)
            )

            if 'genero' in filtros and filtros['genero']:
                query = query.join(Genero).filter(Genero.tipo == filtros['genero'])

            if 'intensidad' in filtros and filtros['intensidad']:
                query = query.join(Intensidad).filter(Intensidad.nivel == filtros['intensidad'])

            if 'familia' in filtros and filtros['familia']:
                query = query.join(FamiliaOlfatica).filter(FamiliaOlfatica.nombre == filtros['familia'])

            if 'ocasiones' in filtros and filtros['ocasiones']:
                query = query.join(PerfumeOcasiones).join(Ocasion).filter(
                    Ocasion.nombre.in_(filtros['ocasiones'])
                )

            if 'notas_preferidas' in filtros and filtros['notas_preferidas']:
                query = query.join(PerfumeNotas).join(NotaOlfativa).filter(
                    NotaOlfativa.nombre.in_(filtros['notas_preferidas'])
                )

            perfumes = query.all()
            return [p.to_dict() for p in perfumes]
        except Exception as e:
            print(f"Error filtrando perfumes: {e}")
            return []
        finally:
            self.close_db()

    def get_perfume_by_id(self, perfume_id):
        db = self.get_db()
        try:
            perfume = db.query(Perfume).options(
                joinedload(Perfume.marca),
                joinedload(Perfume.familia),
                joinedload(Perfume.intensidad),
                joinedload(Perfume.genero),
                joinedload(Perfume.notas),
                joinedload(Perfume.ocasiones)
            ).filter(Perfume.id == perfume_id).first()

            if perfume:
                result = perfume.to_dict()
                result['notas'] = [n.nombre for n in perfume.notas]
                result['ocasiones'] = [o.nombre for o in perfume.ocasiones]
                result['notas_por_tipo'] = perfume.get_notas_por_tipo(db)
                return result
            return None
        except Exception as e:
            print(f"Error obteniendo perfume: {e}")
            return None
        finally:
            self.close_db()

    def registrar_usuario(self, usuario_data):
        db = self.get_db()
        try:
            email = usuario_data.get('email')
            nombre = usuario_data.get('nombre', '')
            password = usuario_data.get('password')

            if not email or not password:
                return {'success': False, 'message': 'Email y contraseña son requeridos'}

            existing = db.query(Usuario).filter(Usuario.email == email).first()
            if existing:
                return {'success': False, 'message': 'El email ya está registrado'}

            password_hash = generate_password_hash(password)

            usuario = Usuario(
                email=email,
                nombre=nombre,
                password_hash=password_hash,
                preferencias=usuario_data.get('preferencias', {})
            )

            db.add(usuario)
            db.commit()
            db.refresh(usuario)

            return {'success': True, 'usuario': usuario.to_dict()}
        except Exception as e:
            db.rollback()
            print(f"Error registrando usuario: {e}")
            return {'success': False, 'message': str(e)}
        finally:
            self.close_db()

    def auth_usuario(self, email, password):
        db = self.get_db()
        try:
            usuario = db.query(Usuario).filter(Usuario.email == email).first()
            if usuario and check_password_hash(usuario.password_hash, password):
                return {'success': True, 'usuario': usuario.to_dict()}
            return {'success': False, 'message': 'Credenciales inválidas'}
        except Exception as e:
            print(f"Error autenticando usuario: {e}")
            return {'success': False, 'message': str(e)}
        finally:
            self.close_db()

    def get_usuario_by_id(self, usuario_id):
        db = self.get_db()
        try:
            usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
            if usuario:
                return usuario.to_dict()
            return None
        except Exception as e:
            print(f"Error obteniendo usuario: {e}")
            return None
        finally:
            self.close_db()

    def actualizar_preferencias(self, usuario_id, preferencias):
        db = self.get_db()
        try:
            usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
            if usuario:
                usuario.preferencias = preferencias
                db.commit()
                return {'success': True, 'preferencias': preferencias}
            return {'success': False, 'message': 'Usuario no encontrado'}
        except Exception as e:
            db.rollback()
            print(f"Error actualizando preferencias: {e}")
            return {'success': False, 'message': str(e)}
        finally:
            self.close_db()

    def agregar_favorito(self, usuario_id, perfume_id):
        db = self.get_db()
        try:
            existing = db.query(Favorito).filter(
                Favorito.usuario_id == usuario_id,
                Favorito.perfume_id == perfume_id
            ).first()

            if existing:
                db.delete(existing)
                db.commit()
                return {'success': True, 'action': 'removed'}
            else:
                favorito = Favorito(usuario_id=usuario_id, perfume_id=perfume_id)
                db.add(favorito)
                db.commit()
                return {'success': True, 'action': 'added'}
        except Exception as e:
            db.rollback()
            print(f"Error gestionando favorito: {e}")
            return {'success': False, 'message': str(e)}
        finally:
            self.close_db()

    def es_favorito(self, usuario_id, perfume_id):
        db = self.get_db()
        try:
            favorito = db.query(Favorito).filter(
                Favorito.usuario_id == usuario_id,
                Favorito.perfume_id == perfume_id
            ).first()
            return favorito is not None
        except Exception as e:
            print(f"Error verificando favorito: {e}")
            return False
        finally:
            self.close_db()

    def obtener_favoritos(self, usuario_id):
        db = self.get_db()
        try:
            favoritos = db.query(Favorito).options(
                joinedload(Favorito.perfume)
            ).filter(Favorito.usuario_id == usuario_id).all()

            return [f.to_dict() for f in favoritos]
        except Exception as e:
            print(f"Error obteniendo favoritos: {e}")
            return []
        finally:
            self.close_db()

    def registrar_busqueda(self, usuario_id, criterios, resultados_obtenidos):
        db = self.get_db()
        try:
            busqueda = Busqueda(
                usuario_id=usuario_id,
                criterios=criterios,
                resultados_obtenidos=resultados_obtenidos
            )
            db.add(busqueda)
            db.commit()
            return {'success': True}
        except Exception as e:
            db.rollback()
            print(f"Error registrando búsqueda: {e}")
            return {'success': False, 'message': str(e)}
        finally:
            self.close_db()

    def obtener_historial(self, usuario_id, limite=10):
        db = self.get_db()
        try:
            busquedas = db.query(Busqueda).filter(
                Busqueda.usuario_id == usuario_id
            ).order_by(Busqueda.fecha.desc()).limit(limite).all()

            return [b.to_dict() for b in busquedas]
        except Exception as e:
            print(f"Error obteniendo historial: {e}")
            return []
        finally:
            self.close_db()

    def valorar_perfume(self, usuario_id, perfume_id, puntuacion, comentario=''):
        db = self.get_db()
        try:
            existing = db.query(Valoracion).filter(
                Valoracion.usuario_id == usuario_id,
                Valoracion.perfume_id == perfume_id
            ).first()

            if existing:
                existing.puntuacion = puntuacion
                existing.comentario = comentario
            else:
                valoracion = Valoracion(
                    usuario_id=usuario_id,
                    perfume_id=perfume_id,
                    puntuacion=puntuacion,
                    comentario=comentario
                )
                db.add(valoracion)

            db.commit()

            self.actualizar_puntuacion_popularidad(perfume_id)

            return {'success': True}
        except Exception as e:
            db.rollback()
            print(f"Error valorando perfume: {e}")
            return {'success': False, 'message': str(e)}
        finally:
            self.close_db()

    def actualizar_puntuacion_popularidad(self, perfume_id):
        db = self.get_db()
        try:
            avg_score = db.query(func.avg(Valoracion.puntuacion)).filter(
                Valoracion.perfume_id == perfume_id
            ).scalar()

            if avg_score:
                perfume = db.query(Perfume).filter(Perfume.id == perfume_id).first()
                if perfume:
                    perfume.puntuacion_popularidad = round(avg_score, 2)
                    db.commit()
        except Exception as e:
            db.rollback()
            print(f"Error actualizando puntuación: {e}")
        finally:
            self.close_db()

    def obtener_valoraciones_perfume(self, perfume_id):
        db = self.get_db()
        try:
            valoraciones = db.query(Valoracion).options(
                joinedload(Valoracion.usuario)
            ).filter(Valoracion.perfume_id == perfume_id).order_by(
                Valoracion.fecha.desc()
            ).all()

            return [v.to_dict() for v in valoraciones]
        except Exception as e:
            print(f"Error obteniendo valoraciones: {e}")
            return []
        finally:
            self.close_db()

    def get_opciones_filtro(self):
        db = self.get_db()
        try:
            familias = [f[0] for f in db.query(FamiliaOlfatica.nombre).all()]
            generos = [g[0] for g in db.query(Genero.tipo).all()]
            intensidades = [i[0] for i in db.query(Intensidad.nivel).all()]
            notas = [n[0] for n in db.query(NotaOlfativa.nombre).all()]
            ocasiones = [o[0] for o in db.query(Ocasion.nombre).all()]

            return {
                'familias': familias,
                'generos': generos,
                'intensidades': intensidades,
                'notas': notas,
                'ocasiones': ocasiones
            }
        except Exception as e:
            print(f"Error obteniendo opciones de filtro: {e}")
            return {}
        finally:
            self.close_db()