require 'spec_helper'
require_relative '../../../app/comandos/aceptar_oferta'
describe AceptarOferta do
  let(:precio) {300000}
  let(:oferente) {Usuario.new('nombre', 'mail', '100')}
  let(:publicacion) {Publicacion.new(precio, oferente, 1)}
  let(:oferta) {Oferta.new(precio, oferente, publicacion)}

  before(:each) do
    Persistence::Repositories::RepositorioOfertas.new.delete_all
    Persistence::Repositories::RepositorioPublicaciones.new.delete_all
    Persistence::Repositories::RepositorioUsuarios.new.delete_all
    Persistence::Repositories::RepositorioUsuarios.new.save(oferente)
    Persistence::Repositories::RepositorioPublicaciones.new.save(publicacion)
    Persistence::Repositories::RepositorioOfertas.new.save(oferta)
  end

  context 'Aceptar una oferta FIUBAK ' do
    it 'marca la publicación como vendida' do
      aceptar_oferta = described_class.new.ejecutar(oferta)
      expect(aceptar_oferta.publicacion.estado).to eq EstadoVendido.new
    end

    it 'guarda los cambios correctamente' do
      aceptar_oferta = described_class.new.ejecutar(oferta)
      oferta = Persistence::Repositories::RepositorioOfertas.new.find(aceptar_oferta.id)
      publicacion = oferta.publicacion
      expect(publicacion.estado).to eq EstadoVendido.new
    end

    it 'crea una publicacion nueva con incremento de precio' do
      described_class.new.ejecutar(oferta)
      publicaciones = Persistence::Repositories::RepositorioPublicaciones.new.all
      expect(publicaciones.length).to eq 2
      expect(publicaciones[0].precio < publicaciones[1].precio).to eq true
    end
  end
end
