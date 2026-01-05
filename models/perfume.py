from sqlalchemy import Column, Integer, String, Numeric, Text, DateTime, DECIMAL, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from models.base import Base

class Perfume(Base):
    __tablename__ = 'perfumes'

    id = Column(Integer, primary_key=True)
    nombre = Column(String(200), nullable=False)
    marca_id = Column(Integer, ForeignKey('marcas.id'))
    familia_id = Column(Integer, ForeignKey('familias_olfativas.id'))
    intensidad_id = Column(Integer, ForeignKey('intensidades.id'))
    genero_id = Column(Integer, ForeignKey('generos.id'))
    ano_lanzamiento = Column(Integer)
    precio_ml = Column(DECIMAL(10, 2))
    descripcion = Column(Text)
    imagen_url = Column(String(500))
    puntuacion_popularidad = Column(DECIMAL(3, 2), default=0)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())
    actualizado_en = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    marca = relationship("Marca", back_populates="perfumes")
    familia = relationship("FamiliaOlfatica", back_populates="perfumes")
    notas = relationship("NotaOlfativa", secondary="perfume_notas", back_populates="perfumes")
    ocasiones = relationship("Ocasion", secondary="perfume_ocasiones", back_populates="perfumes")
    favoritos = relationship("Favorito", back_populates="perfume")
    valoraciones = relationship("Valoracion", back_populates="perfume")

    def get_notas_por_tipo(self, db_session):
        from models.usuario import NotaOlfativa
        from sqlalchemy import and_

        notas_salida = db_session.query(NotaOlfativa).join(
            PerfumeNotas, NotaOlfativa.id == PerfumeNotas.nota_id
        ).filter(
            and_(
                PerfumeNotas.perfume_id == self.id,
                NotaOlfativa.categoria == 'nota_salida'
            )
        ).all()

        notas_corazon = db_session.query(NotaOlfativa).join(
            PerfumeNotas, NotaOlfativa.id == PerfumeNotas.nota_id
        ).filter(
            and_(
                PerfumeNotas.perfume_id == self.id,
                NotaOlfativa.categoria == 'nota_corazon'
            )
        ).all()

        notas_fondo = db_session.query(NotaOlfativa).join(
            PerfumeNotas, NotaOlfativa.id == PerfumeNotas.nota_id
        ).filter(
            and_(
                PerfumeNotas.perfume_id == self.id,
                NotaOlfativa.categoria == 'nota_fondo'
            )
        ).all()

        return {
            'nota_salida': [n.nombre for n in notas_salida],
            'nota_corazon': [n.nombre for n in notas_corazon],
            'nota_fondo': [n.nombre for n in notas_fondo]
        }

    def to_dict(self):
        return {
            'id': self.id,
            'nombre': self.nombre,
            'marca': self.marca.nombre if self.marca else None,
            'familia': self.familia.nombre if self.familia else None,
            'intensidad': self.intensidad.nivel if self.intensidad else None,
            'genero': self.genero.tipo if self.genero else None,
            'ano_lanzamiento': self.ano_lanzamiento,
            'precio_ml': float(self.precio_ml) if self.precio_ml else None,
            'descripcion': self.descripcion,
            'imagen_url': self.imagen_url,
            'puntuacion_popularidad': float(self.puntuacion_popularidad) if self.puntuacion_popularidad else 0
        }

class Marca(Base):
    __tablename__ = 'marcas'

    id = Column(Integer, primary_key=True)
    nombre = Column(String(100), unique=True, nullable=False)
    pais_origen = Column(String(50))
    ano_fundacion = Column(Integer)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    perfumes = relationship("Perfume", back_populates="marca")

class FamiliaOlfatica(Base):
    __tablename__ = 'familias_olfativas'

    id = Column(Integer, primary_key=True)
    nombre = Column(String(50), unique=True, nullable=False)
    descripcion = Column(Text)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    perfumes = relationship("Perfume", back_populates="familia")
    notas = relationship("NotaOlfativa", back_populates="familia")

class Intensidad(Base):
    __tablename__ = 'intensidades'

    id = Column(Integer, primary_key=True)
    nivel = Column(String(20), unique=True, nullable=False)
    descripcion = Column(Text)
    duracion_estimada_horas = Column(Integer)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

class Genero(Base):
    __tablename__ = 'generos'

    id = Column(Integer, primary_key=True)
    tipo = Column(String(20), unique=True, nullable=False)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

class NotaOlfativa(Base):
    __tablename__ = 'notas_olfativas'

    id = Column(Integer, primary_key=True)
    nombre = Column(String(100), unique=True, nullable=False)
    categoria = Column(String(20), nullable=False)
    familia_id = Column(Integer, ForeignKey('familias_olfativas.id'))
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    familia = relationship("FamiliaOlfatica", back_populates="notas")
    perfumes = relationship("Perfume", secondary="perfume_notas", back_populates="notas")

class Ocasion(Base):
    __tablename__ = 'ocasiones'

    id = Column(Integer, primary_key=True)
    nombre = Column(String(50), unique=True, nullable=False)
    temporada = Column(String(50))
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    perfumes = relationship("Perfume", secondary="perfume_ocasiones", back_populates="ocasiones")

class PerfumeNotas(Base):
    __tablename__ = 'perfume_notas'

    perfume_id = Column(Integer, ForeignKey('perfumes.id', ondelete='CASCADE'), primary_key=True)
    nota_id = Column(Integer, ForeignKey('notas_olfativas.id', ondelete='CASCADE'), primary_key=True)

class PerfumeOcasiones(Base):
    __tablename__ = 'perfume_ocasiones'

    perfume_id = Column(Integer, ForeignKey('perfumes.id', ondelete='CASCADE'), primary_key=True)
    ocasion_id = Column(Integer, ForeignKey('ocasiones.id', ondelete='CASCADE'), primary_key=True)