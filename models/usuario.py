from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from models.base import Base

class Usuario(Base):
    __tablename__ = 'usuarios'

    id = Column(Integer, primary_key=True)
    email = Column(String(255), unique=True, nullable=False)
    nombre = Column(String(100))
    password_hash = Column(String(255), nullable=False)
    preferencias = Column(JSON)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())
    actualizado_en = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    busquedas = relationship("Busqueda", back_populates="usuario", cascade="all, delete-orphan")
    favoritos = relationship("Favorito", back_populates="usuario", cascade="all, delete-orphan")
    valoraciones = relationship("Valoracion", back_populates="usuario", cascade="all, delete-orphan")

    @property
    def is_active(self):
        return True

    @property
    def is_authenticated(self):
        return True

    @property
    def is_anonymous(self):
        return False

    def get_id(self):
        return str(self.id)

    def to_dict(self):
        return {
            'id': self.id,
            'email': self.email,
            'nombre': self.nombre,
            'preferencias': self.preferencias,
            'creado_en': self.creado_en.isoformat() if self.creado_en else None
        }

class Busqueda(Base):
    __tablename__ = 'busquedas'

    id = Column(Integer, primary_key=True)
    usuario_id = Column(Integer, ForeignKey('usuarios.id', ondelete='CASCADE'))
    criterios = Column(JSON, nullable=False)
    resultados_obtenidos = Column(Integer)
    fecha = Column(DateTime(timezone=True), server_default=func.now())

    usuario = relationship("Usuario", back_populates="busquedas")

    def to_dict(self):
        return {
            'id': self.id,
            'criterios': self.criterios,
            'resultados_obtenidos': self.resultados_obtenidos,
            'fecha': self.fecha.isoformat() if self.fecha else None
        }

class Favorito(Base):
    __tablename__ = 'favoritos'

    usuario_id = Column(Integer, ForeignKey('usuarios.id', ondelete='CASCADE'), primary_key=True)
    perfume_id = Column(Integer, ForeignKey('perfumes.id', ondelete='CASCADE'), primary_key=True)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    usuario = relationship("Usuario", back_populates="favoritos")
    perfume = relationship("Perfume", back_populates="favoritos")

    def to_dict(self):
        return {
            'usuario_id': self.usuario_id,
            'perfume': self.perfume.to_dict() if self.perfume else None,
            'creado_en': self.creado_en.isoformat() if self.creado_en else None
        }

class Valoracion(Base):
    __tablename__ = 'valoraciones'

    id = Column(Integer, primary_key=True)
    usuario_id = Column(Integer, ForeignKey('usuarios.id', ondelete='CASCADE'))
    perfume_id = Column(Integer, ForeignKey('perfumes.id', ondelete='CASCADE'))
    puntuacion = Column(Integer)
    comentario = Column(Text)
    fecha = Column(DateTime(timezone=True), server_default=func.now())

    usuario = relationship("Usuario", back_populates="valoraciones")
    perfume = relationship("Perfume", back_populates="valoraciones")

    def to_dict(self):
        return {
            'id': self.id,
            'puntuacion': self.puntuacion,
            'comentario': self.comentario,
            'fecha': self.fecha.isoformat() if self.fecha else None,
            'usuario': {
                'id': self.usuario.id,
                'nombre': self.usuario.nombre
            } if self.usuario else None
        }