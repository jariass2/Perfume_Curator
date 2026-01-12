from services.database_service import DatabaseService
from services.user_feedback_service import UserFeedbackService

class RecommendationEngine:
    def __init__(self):
        self.db_service = DatabaseService()
        self.feedback_service = None  # Inicializado cuando se necesite

    def calcular_score_perfil(self, perfume, preferencias):
        """
        Calcula score detallado con desglose de compatibilidad
        Retorna: (score_total, desglose_dict)
        """
        desglose = {
            'genero': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},
            'intensidad': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},
            'familia': {'puntos': 0, 'max': 25, 'match': False, 'detalle': ''},
            'ocasiones': {'puntos': 0, 'max': 20, 'match': False, 'detalle': ''},
            'notas_preferidas': {'puntos': 0, 'max': 25, 'match': False, 'detalle': ''},
            'notas_rechazadas': {'puntos': 0, 'max': 0, 'penalizacion': 0, 'detalle': ''},
            'popularidad': {'puntos': 0, 'max': 10, 'rating': 0, 'detalle': ''},
            'edad': {'puntos': 0, 'max': 8, 'match': False, 'detalle': ''},
            'clima': {'puntos': 0, 'max': 10, 'match': False, 'detalle': ''},
            'tipo_piel': {'puntos': 0, 'max': 7, 'match': False, 'detalle': ''},
            'marca_favorita': {'puntos': 0, 'max': 0, 'bonus': False, 'detalle': ''},
            'usuarios_similares': {'puntos': 0, 'max': 0, 'bonus': False, 'detalle': ''}
        }

        score = 0

        if not preferencias:
            return 0, desglose

        # Género (10 puntos max)
        if 'genero' in preferencias and preferencias['genero']:
            if perfume['genero'] == preferencias['genero']:
                puntos = 10
                desglose['genero']['match'] = True
                desglose['genero']['detalle'] = f"Match exacto: {perfume['genero']}"
            elif perfume['genero'] == 'Unisex':
                puntos = 7
                desglose['genero']['match'] = True
                desglose['genero']['detalle'] = "Unisex: Compatible"
            else:
                puntos = 0
                desglose['genero']['detalle'] = f"Buscas {preferencias['genero']}, esto es {perfume['genero']}"

            desglose['genero']['puntos'] = puntos
            score += puntos

        # Intensidad (10 puntos max)
        if 'intensidad' in preferencias and preferencias['intensidad']:
            if perfume['intensidad'] == preferencias['intensidad']:
                puntos = 10
                desglose['intensidad']['match'] = True
                desglose['intensidad']['detalle'] = f"Match exacto: {perfume['intensidad']}"
            else:
                puntos = 0
                desglose['intensidad']['detalle'] = f"Buscas {preferencias['intensidad']}, esto es {perfume['intensidad']}"

            desglose['intensidad']['puntos'] = puntos
            score += puntos

        # Familia Olfativa (25 puntos max) - CRÍTICO
        if 'familia' in preferencias and preferencias['familia']:
            if perfume['familia'] == preferencias['familia']:
                puntos = 25
                desglose['familia']['match'] = True
                desglose['familia']['detalle'] = f"Familia perfecta: {perfume['familia']}"
            else:
                puntos = 0
                desglose['familia']['detalle'] = f"Buscas {preferencias['familia']}, esto es {perfume['familia']}"

            desglose['familia']['puntos'] = puntos
            score += puntos

        # Ocasiones (20 puntos max)
        if 'ocasiones' in preferencias and preferencias['ocasiones']:
            ocasiones_perfume = perfume.get('ocasiones', [])
            ocasiones_match = [o for o in preferencias['ocasiones'] if o in ocasiones_perfume]

            if ocasiones_match:
                # 10 puntos por cada match, hasta 20 max
                puntos = min(len(ocasiones_match) * 10, 20)
                desglose['ocasiones']['match'] = True
                desglose['ocasiones']['detalle'] = f"Match en: {', '.join(ocasiones_match)}"
            else:
                puntos = 0
                desglose['ocasiones']['detalle'] = f"Buscas: {', '.join(preferencias['ocasiones'][:3])}"

            desglose['ocasiones']['puntos'] = puntos
            score += puntos

        # Notas Preferidas (25 puntos max) - CRÍTICO
        if 'notas_preferidas' in preferencias and preferencias['notas_preferidas']:
            notas_perfume = perfume.get('notas', [])
            notas_match = [n for n in preferencias['notas_preferidas'] if n in notas_perfume]

            if notas_match:
                # 5 puntos por nota, hasta 25 max
                puntos = min(len(notas_match) * 5, 25)
                desglose['notas_preferidas']['match'] = True
                desglose['notas_preferidas']['detalle'] = f"Contiene: {', '.join(notas_match[:5])}"
            else:
                puntos = 0
                desglose['notas_preferidas']['detalle'] = "No contiene tus notas favoritas"

            desglose['notas_preferidas']['puntos'] = puntos
            score += puntos

        # Notas Rechazadas (penalización severa)
        if 'notas_rechazadas' in preferencias and preferencias['notas_rechazadas']:
            notas_perfume = perfume.get('notas', [])
            notas_rechazadas_encontradas = [n for n in preferencias['notas_rechazadas'] if n in notas_perfume]

            if notas_rechazadas_encontradas:
                penalizacion = len(notas_rechazadas_encontradas) * 15  # 15 puntos por nota rechazada
                desglose['notas_rechazadas']['penalizacion'] = penalizacion
                desglose['notas_rechazadas']['detalle'] = f"⚠️ Contiene: {', '.join(notas_rechazadas_encontradas)}"
                score -= penalizacion

        # Popularidad (10 puntos max)
        if perfume.get('puntuacion_popularidad'):
            rating = float(perfume['puntuacion_popularidad'])
            puntos = (rating / 5.0) * 10  # Convertir 0-5 a 0-10
            desglose['popularidad']['puntos'] = round(puntos, 1)
            desglose['popularidad']['rating'] = rating
            desglose['popularidad']['detalle'] = f"Valoración: {rating}/5.0"
            score += puntos

        # Edad (8 puntos max) - Sofisticación según rango etario
        if 'edad' in preferencias and preferencias['edad']:
            # Mapeo de familias y notas según edad
            edad_familia_map = {
                '18-25': {'familias': ['Cítrica', 'Aromática', 'Floral'], 'intensidades': ['Suave', 'Media']},
                '26-35': {'familias': ['Floral', 'Aromática', 'Amaderada'], 'intensidades': ['Media', 'Fuerte']},
                '36-45': {'familias': ['Amaderada', 'Oriental', 'Floral'], 'intensidades': ['Media', 'Fuerte']},
                '46-55': {'familias': ['Oriental', 'Amaderada', 'Floral'], 'intensidades': ['Fuerte']},
                '56+': {'familias': ['Oriental', 'Amaderada'], 'intensidades': ['Fuerte']}
            }

            edad_prefs = edad_familia_map.get(preferencias['edad'], {})
            puntos = 0

            if perfume['familia'] in edad_prefs.get('familias', []):
                puntos += 5
            if perfume['intensidad'] in edad_prefs.get('intensidades', []):
                puntos += 3

            if puntos > 0:
                desglose['edad']['match'] = True
                desglose['edad']['detalle'] = f"Adecuado para {preferencias['edad']} años"
            else:
                desglose['edad']['detalle'] = f"Perfil para {preferencias['edad']}"

            desglose['edad']['puntos'] = puntos
            score += puntos

        # Clima (10 puntos max) - Adaptación al entorno
        if 'clima' in preferencias and preferencias['clima']:
            # Mapeo de familias adecuadas por clima
            clima_familia_map = {
                'tropical': ['Cítrica', 'Aromática'],  # Ligeras, frescas
                'mediterraneo': ['Aromática', 'Floral', 'Cítrica'],
                'templado': ['Floral', 'Amaderada', 'Aromática'],
                'frio-seco': ['Amaderada', 'Oriental'],  # Cálidas, intensas
                'frio-humedo': ['Oriental', 'Amaderada', 'Floral']
            }

            # Ajuste de intensidad por clima
            clima_intensidad_map = {
                'tropical': ['Suave', 'Media'],  # Evitar muy fuerte en calor
                'mediterraneo': ['Media', 'Fuerte'],
                'templado': ['Suave', 'Media', 'Fuerte'],
                'frio-seco': ['Fuerte'],  # Perfumes potentes
                'frio-humedo': ['Media', 'Fuerte']
            }

            familias_adecuadas = clima_familia_map.get(preferencias['clima'], [])
            intensidades_adecuadas = clima_intensidad_map.get(preferencias['clima'], [])

            puntos = 0
            if perfume['familia'] in familias_adecuadas:
                puntos += 6
            if perfume['intensidad'] in intensidades_adecuadas:
                puntos += 4

            if puntos >= 6:
                desglose['clima']['match'] = True
                desglose['clima']['detalle'] = f"Ideal para clima {preferencias['clima']}"
            elif puntos > 0:
                desglose['clima']['detalle'] = f"Compatible con clima {preferencias['clima']}"
            else:
                desglose['clima']['detalle'] = f"Mejor para otros climas"

            desglose['clima']['puntos'] = puntos
            score += puntos

        # Tipo de Piel (7 puntos max) - Longevidad y proyección
        if 'tipo_piel' in preferencias and preferencias['tipo_piel']:
            # Mapeo de intensidades recomendadas por tipo de piel
            piel_intensidad_map = {
                'muy-seca': ['Fuerte'],  # Necesita concentración alta
                'seca': ['Media', 'Fuerte'],  # Mejor con EDP+
                'normal': ['Suave', 'Media', 'Fuerte'],  # Flexible
                'mixta': ['Media', 'Fuerte'],  # Buena retención
                'grasa': ['Suave', 'Media']  # Evitar saturar
            }

            intensidades_ideales = piel_intensidad_map.get(preferencias['tipo_piel'], [])

            puntos = 0
            if perfume['intensidad'] in intensidades_ideales:
                puntos = 7
                desglose['tipo_piel']['match'] = True
                desglose['tipo_piel']['detalle'] = f"Óptimo para piel {preferencias['tipo_piel']}"
            else:
                puntos = 3  # Puntos parciales
                desglose['tipo_piel']['detalle'] = f"Funciona con piel {preferencias['tipo_piel']}"

            desglose['tipo_piel']['puntos'] = puntos
            score += puntos

        return round(score, 2), desglose

    def recomendar_perfumes(self, usuario_id=None, preferencias=None, limite=5, sesion_id=None):
        db = self.db_service.get_db()
        try:
            # Inicializar feedback service si no existe
            if self.feedback_service is None and db:
                try:
                    self.feedback_service = UserFeedbackService(db)
                except Exception as e:
                    print(f"Warning: No se pudo inicializar UserFeedbackService: {e}")
                    self.feedback_service = None

            # Obtener preferencias del usuario (explícitas + aprendidas)
            # IMPORTANTE: NO sobrescribir las preferencias pasadas como parámetro
            if usuario_id and not preferencias:
                from models import Usuario
                usuario = db.query(Usuario).filter(Usuario.id == usuario_id).first()
                if usuario:
                    # Solo usar preferencias guardadas si NO se pasaron preferencias
                    preferencias = usuario.preferencias or {}

            # Enriquecer con preferencias aprendidas (solo si hay feedback service)
            if usuario_id and self.feedback_service and preferencias:
                try:
                    preferencias_aprendidas = self.feedback_service.obtener_preferencias_aprendidas(
                        usuario_id, min_confianza=0.6
                    )

                    # Enriquecer con preferencias aprendidas
                    for tipo, valores in preferencias_aprendidas.items():
                        if tipo == 'familia_preferida' and valores:
                            # Si no hay preferencia explícita, usar la aprendida
                            if not preferencias.get('familia'):
                                preferencias['familia'] = valores[0]['valor']
                        elif tipo == 'marca_preferida':
                            preferencias['marca_preferida'] = [v['valor'] for v in valores[:3]]
                        elif tipo == 'intensidad_preferida' and valores:
                            if not preferencias.get('intensidad'):
                                preferencias['intensidad'] = valores[0]['valor']
                except Exception as e:
                    print(f"Warning: Error obteniendo preferencias aprendidas, continuando sin ellas: {e}")

            if not preferencias:
                # Si no hay preferencias, usar perfumes más populares
                if self.feedback_service:
                    try:
                        populares = self.feedback_service.obtener_perfumes_populares(
                            limite=limite, metrica='ctr'
                        )
                        if populares:
                            perfumes = self.db_service.get_vista_perfumes_completa()
                            ids_populares = [p['id'] for p in populares]
                            return [p for p in perfumes if p['id'] in ids_populares][:limite]
                    except Exception as e:
                        print(f"Warning: Error obteniendo perfumes populares, usando todos los perfumes: {e}")

                perfumes = self.db_service.get_vista_perfumes_completa()
                return perfumes[:limite]

            # Algoritmo híbrido: Content-based + Collaborative Filtering
            perfumes_completos = self.db_service.get_vista_perfumes_completa()

            # 1. Calcular score basado en contenido con desglose
            perfumes_con_score = []
            for perfume in perfumes_completos:
                score, desglose = self.calcular_score_perfil(perfume, preferencias)

                # Bonus por marca preferida (aprendida)
                if preferencias.get('marca_preferida'):
                    if perfume.get('marca') in preferencias['marca_preferida']:
                        bonus = 15
                        score += bonus
                        desglose['marca_favorita']['puntos'] = bonus
                        desglose['marca_favorita']['bonus'] = True
                        desglose['marca_favorita']['detalle'] = f"Marca que te gusta: {perfume.get('marca')}"

                if score >= 0:
                    perfumes_con_score.append({
                        'perfume': perfume,
                        'score': score,
                        'desglose': desglose
                    })

            # 2. Agregar recomendaciones colaborativas si hay usuario
            if usuario_id and self.feedback_service:
                try:
                    recomendaciones_colaborativas = self.feedback_service.obtener_recomendaciones_colaborativas(
                        usuario_id, limite=5
                    )

                    # Dar boost a perfumes recomendados por usuarios similares
                    for item in perfumes_con_score:
                        if item['perfume']['id'] in recomendaciones_colaborativas:
                            bonus = 20
                            item['score'] += bonus
                            item['perfume']['recomendado_por_similares'] = True
                            item['desglose']['usuarios_similares']['puntos'] = bonus
                            item['desglose']['usuarios_similares']['bonus'] = True
                            item['desglose']['usuarios_similares']['detalle'] = "Amado por usuarios con tus gustos"
                except Exception as e:
                    print(f"Warning: Error obteniendo recomendaciones colaborativas: {e}")

            perfumes_con_score.sort(key=lambda x: x['score'], reverse=True)

            # Calcular score máximo posible para normalizar
            score_maximo = 100  # Base: 10+10+25+20+25+10 = 100 puntos
            if preferencias.get('marca_preferida'):
                score_maximo += 15
            if usuario_id:
                score_maximo += 20  # Possible collaborative bonus

            resultados = []
            for item in perfumes_con_score[:limite]:
                resultado = item['perfume'].copy()

                # Calcular porcentaje de compatibilidad (0-100%)
                porcentaje = min(int((item['score'] / score_maximo) * 100), 100)
                resultado['compatibilidad_porcentaje'] = porcentaje
                resultado['compatibilidad_desglose'] = item['desglose']
                resultado['score_match'] = porcentaje

                # Clasificar nivel de compatibilidad
                if porcentaje >= 90:
                    resultado['compatibilidad_nivel'] = 'Excelente'
                    resultado['compatibilidad_color'] = 'luxury-gold'
                elif porcentaje >= 75:
                    resultado['compatibilidad_nivel'] = 'Muy Buena'
                    resultado['compatibilidad_color'] = 'green-500'
                elif porcentaje >= 60:
                    resultado['compatibilidad_nivel'] = 'Buena'
                    resultado['compatibilidad_color'] = 'blue-500'
                elif porcentaje >= 40:
                    resultado['compatibilidad_nivel'] = 'Moderada'
                    resultado['compatibilidad_color'] = 'yellow-500'
                else:
                    resultado['compatibilidad_nivel'] = 'Baja'
                    resultado['compatibilidad_color'] = 'gray-500'

                resultados.append(resultado)

            return resultados
        except Exception as e:
            print(f"Error en motor de recomendación: {e}")
            return []
        finally:
            self.db_service.close_db()

    def recomendar_similares(self, perfume_id, limite=5):
        try:
            perfume_base = self.db_service.get_perfume_by_id(perfume_id)
            if not perfume_base:
                return []

            preferencias = {
                'genero': perfume_base.get('genero'),
                'familia': perfume_base.get('familia'),
                'intensidad': perfume_base.get('intensidad'),
                'notas_preferidas': perfume_base.get('notas', [])
            }

            return self.recomendar_perfumes(preferencias=preferencias, limite=limite + 1)
        except Exception as e:
            print(f"Error recomendando similares: {e}")
            return []

    def obtener_recomendaciones_populares(self, limite=5):
        try:
            perfumes = self.db_service.get_vista_perfumes_completa()

            perfumes_ordenados = sorted(
                perfumes,
                key=lambda x: x.get('puntuacion_popularidad', 0),
                reverse=True
            )

            return perfumes_ordenados[:limite]
        except Exception as e:
            print(f"Error obteniendo populares: {e}")
            return []