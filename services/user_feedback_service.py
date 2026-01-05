"""
Servicio de Feedback y Aprendizaje de Usuario
Captura y analiza interacciones para mejorar recomendaciones
"""

from sqlalchemy import text, func
from datetime import datetime, timedelta
import json
import uuid
from typing import Dict, List, Optional, Tuple


class UserFeedbackService:
    """Gestiona el feedback del usuario y aprendizaje del sistema"""

    def __init__(self, db_session):
        self.db = db_session

    # ==================== TRACKING DE INTERACCIONES ====================

    def registrar_vista_perfume(self, usuario_id: Optional[int], perfume_id: int,
                               sesion_id: str, contexto: Dict = None) -> int:
        """Registra cuando un usuario ve un perfume en los resultados"""
        return self._registrar_interaccion(
            usuario_id=usuario_id,
            perfume_id=perfume_id,
            tipo='vista',
            sesion_id=sesion_id,
            contexto=contexto or {}
        )

    def registrar_click_detalle(self, usuario_id: Optional[int], perfume_id: int,
                                sesion_id: str, tiempo_en_lista: int = None) -> int:
        """Registra cuando un usuario hace click para ver detalles"""
        contexto = {'tiempo_en_lista_segundos': tiempo_en_lista} if tiempo_en_lista else {}
        return self._registrar_interaccion(
            usuario_id=usuario_id,
            perfume_id=perfume_id,
            tipo='click_detalle',
            sesion_id=sesion_id,
            contexto=contexto
        )

    def registrar_favorito(self, usuario_id: int, perfume_id: int,
                          accion: str, sesion_id: str = None) -> int:
        """Registra cuando se agrega/remueve un favorito"""
        tipo = 'agregado_favorito' if accion == 'added' else 'removido_favorito'
        return self._registrar_interaccion(
            usuario_id=usuario_id,
            perfume_id=perfume_id,
            tipo=tipo,
            sesion_id=sesion_id
        )

    def registrar_valoracion(self, usuario_id: int, perfume_id: int,
                            puntuacion: int, sesion_id: str = None) -> int:
        """Registra una valoración de usuario"""
        return self._registrar_interaccion(
            usuario_id=usuario_id,
            perfume_id=perfume_id,
            tipo='valoracion',
            valor=puntuacion,
            sesion_id=sesion_id
        )

    def _registrar_interaccion(self, usuario_id: Optional[int], perfume_id: int,
                              tipo: str, valor: int = None,
                              sesion_id: str = None, contexto: Dict = None) -> int:
        """Método interno para registrar cualquier tipo de interacción"""
        try:
            # Si no hay usuario_id (usuario no logueado), crear uno temporal basado en sesión
            if usuario_id is None:
                usuario_id = -1  # Indicador de usuario anónimo

            result = self.db.execute(
                text("""
                    SELECT registrar_interaccion(
                        :usuario_id, :perfume_id, :tipo, :valor, :sesion_id, :contexto::jsonb
                    )
                """),
                {
                    'usuario_id': usuario_id,
                    'perfume_id': perfume_id,
                    'tipo': tipo,
                    'valor': valor,
                    'sesion_id': sesion_id,
                    'contexto': json.dumps(contexto or {})
                }
            )
            self.db.commit()
            return result.scalar()
        except Exception as e:
            self.db.rollback()
            print(f"Error registrando interacción: {e}")
            return None

    # ==================== GESTIÓN DE SESIONES ====================

    def iniciar_sesion(self, usuario_id: Optional[int], criterios: Dict,
                      dispositivo: str = None, navegador: str = None) -> str:
        """Inicia una nueva sesión de búsqueda"""
        sesion_id = str(uuid.uuid4())

        try:
            self.db.execute(
                text("""
                    INSERT INTO sesiones_busqueda (
                        usuario_id, sesion_id, criterios_busqueda,
                        dispositivo, navegador
                    ) VALUES (
                        :usuario_id, :sesion_id, :criterios::jsonb,
                        :dispositivo, :navegador
                    )
                """),
                {
                    'usuario_id': usuario_id or -1,
                    'sesion_id': sesion_id,
                    'criterios': json.dumps(criterios),
                    'dispositivo': dispositivo,
                    'navegador': navegador
                }
            )
            self.db.commit()
            return sesion_id
        except Exception as e:
            self.db.rollback()
            print(f"Error iniciando sesión: {e}")
            return None

    def finalizar_sesion(self, sesion_id: str, resultados_mostrados: int) -> bool:
        """Finaliza una sesión y calcula métricas"""
        try:
            self.db.execute(
                text("""
                    UPDATE sesiones_busqueda
                    SET
                        fecha_fin = NOW(),
                        resultados_mostrados = :resultados,
                        tiempo_sesion_segundos = EXTRACT(EPOCH FROM (NOW() - fecha_inicio))::INTEGER
                    WHERE sesion_id = :sesion_id
                """),
                {
                    'sesion_id': sesion_id,
                    'resultados': resultados_mostrados
                }
            )
            self.db.commit()
            return True
        except Exception as e:
            self.db.rollback()
            print(f"Error finalizando sesión: {e}")
            return False

    # ==================== FEEDBACK EXPLÍCITO ====================

    def guardar_feedback_detallado(self, usuario_id: int, perfume_id: int,
                                  puntuaciones: Dict, comentario: str = None,
                                  lo_usaria_para: List[str] = None,
                                  temporada: str = None, util: bool = True) -> bool:
        """Guarda feedback detallado del usuario sobre un perfume"""
        try:
            self.db.execute(
                text("""
                    INSERT INTO feedback_explicito (
                        usuario_id, perfume_id,
                        puntuacion_general, puntuacion_longevidad,
                        puntuacion_proyeccion, puntuacion_versatilidad,
                        lo_usaria_para, temporada_preferida,
                        comentario, util
                    ) VALUES (
                        :usuario_id, :perfume_id,
                        :general, :longevidad, :proyeccion, :versatilidad,
                        :lo_usaria::jsonb, :temporada, :comentario, :util
                    )
                    ON CONFLICT (usuario_id, perfume_id)
                    DO UPDATE SET
                        puntuacion_general = EXCLUDED.puntuacion_general,
                        puntuacion_longevidad = EXCLUDED.puntuacion_longevidad,
                        puntuacion_proyeccion = EXCLUDED.puntuacion_proyeccion,
                        puntuacion_versatilidad = EXCLUDED.puntuacion_versatilidad,
                        lo_usaria_para = EXCLUDED.lo_usaria_para,
                        temporada_preferida = EXCLUDED.temporada_preferida,
                        comentario = EXCLUDED.comentario,
                        util = EXCLUDED.util,
                        fecha = NOW()
                """),
                {
                    'usuario_id': usuario_id,
                    'perfume_id': perfume_id,
                    'general': puntuaciones.get('general'),
                    'longevidad': puntuaciones.get('longevidad'),
                    'proyeccion': puntuaciones.get('proyeccion'),
                    'versatilidad': puntuaciones.get('versatilidad'),
                    'lo_usaria': json.dumps(lo_usaria_para or []),
                    'temporada': temporada,
                    'comentario': comentario,
                    'util': util
                }
            )
            self.db.commit()
            return True
        except Exception as e:
            self.db.rollback()
            print(f"Error guardando feedback detallado: {e}")
            return False

    # ==================== PREFERENCIAS APRENDIDAS ====================

    def obtener_preferencias_aprendidas(self, usuario_id: int,
                                       min_confianza: float = 0.5) -> Dict:
        """Obtiene preferencias aprendidas del usuario con nivel de confianza mínimo"""
        try:
            result = self.db.execute(
                text("""
                    SELECT tipo_preferencia, valor, confianza, veces_observado, origen
                    FROM preferencias_aprendidas
                    WHERE usuario_id = :usuario_id
                      AND confianza >= :min_confianza
                    ORDER BY confianza DESC, veces_observado DESC
                """),
                {'usuario_id': usuario_id, 'min_confianza': min_confianza}
            )

            preferencias = {}
            for row in result:
                tipo = row[0]
                if tipo not in preferencias:
                    preferencias[tipo] = []
                preferencias[tipo].append({
                    'valor': row[1],
                    'confianza': float(row[2]),
                    'veces_observado': row[3],
                    'origen': row[4]
                })

            return preferencias
        except Exception as e:
            print(f"Error obteniendo preferencias aprendidas: {e}")
            return {}

    def actualizar_preferencia_manual(self, usuario_id: int, tipo: str,
                                     valor: str, confianza: float = 0.9) -> bool:
        """Actualiza una preferencia manualmente (feedback explícito)"""
        try:
            self.db.execute(
                text("""
                    SELECT actualizar_preferencia_aprendida(
                        :usuario_id, :tipo, :valor, :confianza, 'explicito'
                    )
                """),
                {
                    'usuario_id': usuario_id,
                    'tipo': tipo,
                    'valor': valor,
                    'confianza': confianza
                }
            )
            self.db.commit()
            return True
        except Exception as e:
            self.db.rollback()
            print(f"Error actualizando preferencia: {e}")
            return False

    # ==================== ANÁLISIS Y MÉTRICAS ====================

    def obtener_metricas_usuario(self, usuario_id: int) -> Dict:
        """Obtiene métricas completas del usuario"""
        try:
            result = self.db.execute(
                text("""
                    SELECT * FROM metricas_usuario
                    WHERE usuario_id = :usuario_id
                """),
                {'usuario_id': usuario_id}
            ).fetchone()

            if result:
                return {
                    'total_interacciones': result[3],
                    'perfumes_vistos': result[4],
                    'detalles_vistos': result[5],
                    'favoritos_actuales': result[6],
                    'perfumes_valorados': result[7],
                    'valoracion_promedio': float(result[8]) if result[8] else 0,
                    'sesiones_totales': result[9],
                    'tiempo_promedio_sesion': result[10],
                    'tasa_conversion': float(result[11]) if result[11] else 0,
                    'ultima_interaccion': result[12]
                }
            return {}
        except Exception as e:
            print(f"Error obteniendo métricas: {e}")
            return {}

    def obtener_perfumes_populares(self, limite: int = 10,
                                  metrica: str = 'ctr') -> List[Dict]:
        """Obtiene perfumes más populares según métrica especificada"""
        orden_map = {
            'ctr': 'ctr DESC NULLS LAST',
            'conversion': 'tasa_conversion DESC NULLS LAST',
            'vistas': 'vistas DESC',
            'favoritos': 'favoritos DESC',
            'valoracion': 'valoracion_promedio DESC NULLS LAST'
        }

        orden = orden_map.get(metrica, 'ctr DESC NULLS LAST')

        try:
            result = self.db.execute(
                text(f"""
                    SELECT * FROM perfumes_popularidad
                    WHERE vistas > 0
                    ORDER BY {orden}
                    LIMIT :limite
                """),
                {'limite': limite}
            )

            perfumes = []
            for row in result:
                perfumes.append({
                    'id': row[0],
                    'nombre': row[1],
                    'marca': row[2],
                    'usuarios_unicos': row[3],
                    'vistas': row[4],
                    'clicks': row[5],
                    'favoritos': row[6],
                    'valoraciones': row[7],
                    'valoracion_promedio': float(row[8]) if row[8] else 0,
                    'ctr': float(row[9]) if row[9] else 0,
                    'tasa_conversion': float(row[10]) if row[10] else 0
                })

            return perfumes
        except Exception as e:
            print(f"Error obteniendo perfumes populares: {e}")
            return []

    def identificar_patron_comportamiento(self, usuario_id: int) -> Optional[str]:
        """Identifica el patrón de comportamiento del usuario"""
        try:
            metricas = self.obtener_metricas_usuario(usuario_id)

            if not metricas or metricas.get('sesiones_totales', 0) < 3:
                return None

            # Lógica simple de clasificación de patrones
            tasa_conversion = metricas.get('tasa_conversion', 0)
            promedio_vistos = metricas.get('perfumes_vistos', 0) / max(metricas.get('sesiones_totales', 1), 1)

            patron = None
            if promedio_vistos > 10 and tasa_conversion < 0.3:
                patron = 'exploratorio'
            elif promedio_vistos < 5 and tasa_conversion > 0.5:
                patron = 'decisivo'
            elif metricas.get('favoritos_actuales', 0) > 10:
                patron = 'coleccionista'
            else:
                patron = 'ocasional'

            # Guardar el patrón
            self._guardar_patron(usuario_id, patron)

            return patron
        except Exception as e:
            print(f"Error identificando patrón: {e}")
            return None

    def _guardar_patron(self, usuario_id: int, patron: str) -> bool:
        """Guarda el patrón de comportamiento identificado"""
        try:
            # Desactivar patrones anteriores
            self.db.execute(
                text("""
                    UPDATE patrones_comportamiento
                    SET activo = FALSE
                    WHERE usuario_id = :usuario_id
                """),
                {'usuario_id': usuario_id}
            )

            # Insertar nuevo patrón
            self.db.execute(
                text("""
                    INSERT INTO patrones_comportamiento (
                        usuario_id, patron_tipo, descripcion, confianza
                    ) VALUES (
                        :usuario_id, :patron, :descripcion, 0.75
                    )
                """),
                {
                    'usuario_id': usuario_id,
                    'patron': patron,
                    'descripcion': f'Usuario con comportamiento {patron}'
                }
            )
            self.db.commit()
            return True
        except Exception as e:
            self.db.rollback()
            print(f"Error guardando patrón: {e}")
            return False

    # ==================== COLLABORATIVE FILTERING ====================

    def calcular_similitud_usuarios(self, usuario_id: int, limite: int = 10) -> List[Tuple[int, float]]:
        """Calcula similitud con otros usuarios basándose en favoritos comunes"""
        try:
            result = self.db.execute(
                text("""
                    WITH usuario_favoritos AS (
                        SELECT perfume_id
                        FROM favoritos
                        WHERE usuario_id = :usuario_id
                    ),
                    otros_usuarios AS (
                        SELECT
                            f.usuario_id,
                            COUNT(CASE WHEN uf.perfume_id IS NOT NULL THEN 1 END) as comunes,
                            COUNT(DISTINCT f.perfume_id) as total_otros,
                            (SELECT COUNT(*) FROM usuario_favoritos) as total_usuario
                        FROM favoritos f
                        LEFT JOIN usuario_favoritos uf ON f.perfume_id = uf.perfume_id
                        WHERE f.usuario_id != :usuario_id
                        GROUP BY f.usuario_id
                        HAVING COUNT(CASE WHEN uf.perfume_id IS NOT NULL THEN 1 END) > 0
                    )
                    SELECT
                        usuario_id,
                        (comunes::FLOAT / (total_usuario + total_otros - comunes)) as similitud_jaccard
                    FROM otros_usuarios
                    ORDER BY similitud_jaccard DESC
                    LIMIT :limite
                """),
                {'usuario_id': usuario_id, 'limite': limite}
            )

            return [(row[0], float(row[1])) for row in result]
        except Exception as e:
            print(f"Error calculando similitud: {e}")
            return []

    def obtener_recomendaciones_colaborativas(self, usuario_id: int,
                                             limite: int = 10) -> List[int]:
        """Obtiene recomendaciones basadas en usuarios similares"""
        usuarios_similares = self.calcular_similitud_usuarios(usuario_id, limite=5)

        if not usuarios_similares:
            return []

        try:
            # IDs de usuarios similares
            ids_similares = [u[0] for u in usuarios_similares]

            # Perfumes que les gustaron a usuarios similares pero no al usuario actual
            result = self.db.execute(
                text("""
                    SELECT DISTINCT f.perfume_id, COUNT(*) as veces_favorito
                    FROM favoritos f
                    WHERE f.usuario_id = ANY(:similares)
                      AND f.perfume_id NOT IN (
                          SELECT perfume_id FROM favoritos WHERE usuario_id = :usuario_id
                      )
                    GROUP BY f.perfume_id
                    ORDER BY veces_favorito DESC
                    LIMIT :limite
                """),
                {
                    'similares': ids_similares,
                    'usuario_id': usuario_id,
                    'limite': limite
                }
            )

            return [row[0] for row in result]
        except Exception as e:
            print(f"Error obteniendo recomendaciones colaborativas: {e}")
            return []
