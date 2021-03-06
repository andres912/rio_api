require 'spec_helper'
require_relative '../../../app/comandos/realizar_oferta'
require_relative '../../../app/models/errors/errores'

describe RealizarOferta do
  let(:monto) {300000}
  let(:auto) {Auto.new("AAA000", "FORD", "AMAROK", 2019, 1)}
  let(:vendedor) { Usuario.new('vendedor', 'vendedor@gmail.com', '001') }
  let(:oferente) { Usuario.new('nombre', 'mail', '100') }
  let(:publicacion) {PublicacionP2P.new(monto, vendedor, auto, 1)}
  let(:repo_ofertas) {Persistence::Repositories::RepositorioOfertas.new}

  before(:each) do
    allow_any_instance_of(NotificadorDeOferta).to receive(:notificar)
    Persistence::Repositories::RepositorioAutos.new.save(auto)
    Persistence::Repositories::RepositorioUsuarios.new.save(oferente)
    Persistence::Repositories::RepositorioUsuarios.new.save(vendedor)
    Persistence::Repositories::RepositorioPublicaciones.new.save(publicacion)
  end

  context 'Realizar una oferta por una publicación p2p activa' do
    it 'crea la oferta correctamente' do
      realizar_oferta = described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)
      expect(realizar_oferta.monto).to eq monto
      expect(realizar_oferta.oferente).to eq oferente
      expect(realizar_oferta.publicacion.id).to eq publicacion.id
    end

    it 'agrega la oferta a la publicación' do
      realizar_oferta = described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)
      ofertas_de_publicacion = repo_ofertas.buscar_por_publicacion(publicacion.id)
      expect(ofertas_de_publicacion.length).to eq 1
      expect(ofertas_de_publicacion[0].id).to eq realizar_oferta.id
      expect(ofertas_de_publicacion[0].oferente).to eq realizar_oferta.oferente
    end

    it 'no modifica el estado de la publicación' do
      realizar_oferta = described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)
      expect(publicacion.estado).to eq realizar_oferta.publicacion.estado
    end

    it 'se envia una notificacion de la oferta' do
      expect_any_instance_of(NotificadorDeOferta).to receive(:notificar)
      described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)
    end
  end

  context 'Realizar una oferta por una publicación p2p vendida' do

    before(:each) do
      publicacion.vendida
    end

    it 'lanza un error al crear la oferta' do
      expect{described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)}.to raise_error(PublicacionVendidaError)
    end

    it 'no agrega la oferta a la publicación' do
      begin
        described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)
      rescue PublicacionVendidaError
        ofertas_de_publicacion = repo_ofertas.buscar_por_publicacion(publicacion.id)
        expect(ofertas_de_publicacion.length).to eq 0
      end
    end

    it 'no modifica el estado de la publicación' do
      begin
        described_class.new(repo_ofertas).ejecutar(monto, oferente, publicacion)
      rescue PublicacionVendidaError
        expect(publicacion.estado).to eq EstadoVendido.new
      end
    end
  end
end
