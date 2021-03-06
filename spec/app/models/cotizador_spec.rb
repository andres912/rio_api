require 'spec_helper'

describe Cotizador do
  let(:cotizador) { Cotizador.new }
  let(:vendedor) { Usuario.new('vendedor', 'vendedor@gmail.com', '001') }

  context 'Dado una publicacion con auto de 1994' do
    before(:each) do
      auto = Auto.new('AAA123', 'Peugeot', '505', 1994)
      @publicacion = PublicacionP2P.new(100_000, vendedor, auto, 1)
    end
    
    it 'Si la cotizo con un informe sin fallas entonces la cotizacion es de 800.000' do
      informe = InformeDeRevision.new
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 800_000
    end

    it 'Si la cotizo con un informe con falla estetica grave entonces la cotizacion es fallida' do
      informe = InformeDeRevision.new.con_falla_estetica(InformeDeRevision::GRAVEDAD_GRAVE)
      expect(cotizador.cotizar(@publicacion, informe).exitosa?).to eq false
    end
  end

  context 'Dado una publicacion con auto de 1995' do
    before(:each) do
      auto = Auto.new('AAA123', 'Peugeot', '505', 1995)
      @publicacion = PublicacionP2P.new(100_000, vendedor, auto, 1)
    end

    it 'Si la cotizo con un informe sin fallas entonces la cotizacion es de 1.000.000' do
      informe = InformeDeRevision.new
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 1_000_000
    end

    it 'Si lo cotizo con un informe con falla estetica leve la cotizacion es de 970.000' do
      informe = InformeDeRevision.new.con_falla_estetica(InformeDeRevision::GRAVEDAD_LEVE)
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 970_000
    end
  end

  context 'Dado un publicacion con una uto de 2005' do
    before(:each) do
      auto = Auto.new('AAA123', 'Ford', 'Fiesta', 2005)
      @publicacion = PublicacionP2P.new(100_000, vendedor, auto, 1)
    end

    it 'Si la cotizo con un informe con falla de neumaticos leve y estetica grave, entonces la cotizacion es de 890.000' do
      informe = InformeDeRevision.new.con_falla_estetica(InformeDeRevision::GRAVEDAD_GRAVE).con_falla_de_neumaticos(InformeDeRevision::GRAVEDAD_LEVE)
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 890000
    end

    it 'Si lo cotizo con informe cona falla estetica, de neumaticos y de motor con gravedad leve, entonces la cotizacion es de 910.000' do
      informe = InformeDeRevision.new.con_falla_estetica(InformeDeRevision::GRAVEDAD_LEVE).con_falla_de_neumaticos(InformeDeRevision::GRAVEDAD_LEVE).con_falla_de_motor(InformeDeRevision::GRAVEDAD_LEVE)
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 910000
    end

    it 'Si lo cotizo con un informe con falla de motor grave entonces el monto de la cotizacion es de 900.000' do
      informe = InformeDeRevision.new.con_falla_de_motor(InformeDeRevision::GRAVEDAD_GRAVE)
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 900000
    end
  end

  context 'Dada una publicacion con auto de 2010' do
    before(:each) do
      auto = Auto.new('AAA123', 'Ford', 'Fiesta', 2010)
      @publicacion = PublicacionP2P.new(100_000, vendedor, auto, 1)
    end

    it 'Si la cotizo con un informe sin fallas entonces la cotizacion es de 2.000.000' do
      informe = InformeDeRevision.new
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 2_000_000
    end    
  end

  context 'Dada una publicacion con auto de 2021' do
    before(:each) do
      auto = Auto.new('AAA123', 'Ford', 'Fiesta', 2010)
      @publicacion = PublicacionP2P.new(100_000, vendedor, auto, 1)
    end

    it 'Si la cotizo con un informe con fallas esteticas y de neumaticos leves la cotizacion es de 1.880.000' do
      informe = InformeDeRevision.new.con_falla_estetica(InformeDeRevision::GRAVEDAD_LEVE).con_falla_de_neumaticos(InformeDeRevision::GRAVEDAD_LEVE)
      expect(cotizador.cotizar(@publicacion, informe).monto).to eq 1_880_000
    end
  end
end