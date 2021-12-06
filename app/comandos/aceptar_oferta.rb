require_relative 'comando'
require_relative '../models/errors/errores'
class AceptarOferta < Comando
  def ejecutar(oferta)
    publicacion = oferta.publicacion
    raise PublicacionVendidaError unless publicacion.estado != EstadoVendido.new

    publicacion.vendida if oferta.fiubak?
    publicacion_nueva = PublicacionFiubak.new(oferta.monto * 1.3, fiubak, publicacion.auto)
    publicacion_nueva.activar
    oferta.aceptar
    guardar_cambios(oferta, publicacion, publicacion_nueva)
  end

  private

  def guardar_cambios(oferta, publicacion, publicacion_nueva)
    guardar_publicacion(publicacion_nueva)
    guardar_publicacion(publicacion)
    guardar_oferta(oferta)
  end

  def fiubak
    fiubak = Usuario.new('fiubak', 'fiubak', 'fiubak')
    guardar_usuario(fiubak)
  end
end
