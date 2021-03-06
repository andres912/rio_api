require 'spec_helper'

describe PublicacionFiubak do
  let(:auto) {Auto.new("AAA000", "FORD", "AMAROK", 2019)}
  let(:precio) {300000}
  let(:fiubak) { UsuarioFiubak.new}
  let(:publicacion_fiubak) { described_class.new(precio, fiubak, auto) }

  it 'Al crear la publicacion debería estar activa' do
    expect(publicacion_fiubak.estado).to eq EstadoActivo.new
  end

  it 'El tipo debería ser TipoFiubak' do
    expect(publicacion_fiubak.tipo).to eq TipoFiubak.new
  end

  it 'Al reservarla el estado cambia a Reservada' do
    publicacion_fiubak.reservar
    expect(publicacion_fiubak.estado).to eq EstadoReservado.new
  end

  it 'retorna el mail del usuario creador cuando se le pide' do
    expect(publicacion_fiubak.mail_usuario).to eq(fiubak.mail)
  end
end
