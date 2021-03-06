# rubocop:disable all
ENV['RACK_ENV'] = 'test'
ENV['ENABLE_RESET'] = 'true'

require File.expand_path("#{File.dirname(__FILE__)}/../../config/boot")

require 'rspec/expectations'

if ENV['BASE_URL']
  BASE_URL = ENV['BASE_URL']
else
  BASE_URL = 'http://localhost:3000'.freeze
  include Rack::Test::Methods
  def app
    Padrino.application
  end
end

def header
  {'Content-Type' => 'application/json'}
end

def find_user_url(user_id)
  "#{BASE_URL}/users/#{user_id}"
end

def find_task_url(task_id)
  "#{BASE_URL}/tasks/#{task_id}"
end

def update_user_url(user_id)
  "#{BASE_URL}/users/#{user_id}"
end

def find_all_users_url
  "#{BASE_URL}/users"
end

def create_user_url
  "#{BASE_URL}/users"
end

def create_task_url
  "#{BASE_URL}/tasks"
end

def create_tag_url
  "#{BASE_URL}/tags"
end

def add_tag_to_task_url(task_id)
  "#{BASE_URL}/tasks/add_tag/#{task_id}"
end

def delete_user_url(user_id)
  "#{BASE_URL}/users/#{user_id}"
end

def reset_url
  "#{BASE_URL}/reset"
end

After do |_scenario|
  Faraday.post(reset_url)
end

def crear_usuario_url
  "#{BASE_URL}/usuarios"
end

def consultar_usuario_url
  "#{BASE_URL}/usuarios/yo"
end

def crear_publicacion_url
  "#{BASE_URL}/publicaciones"
end

def informe_de_cotizacion_url(id_publicacion)
  "#{BASE_URL}/publicaciones/#{id_publicacion}/informe_cotizacion"
end

def listar_publicaciones_url
  "#{BASE_URL}/publicaciones"
end

def listar_mis_publicaciones_url
  "#{BASE_URL}/publicaciones/yo"
end

def realizar_oferta_url(id_publicacion)
  "#{BASE_URL}/publicaciones/#{id_publicacion}/oferta"
end

def aceptar_oferta_url(id_oferta)
  "#{BASE_URL}/ofertas/#{id_oferta}"
end

def rechazar_oferta_url(id_oferta)
  "#{BASE_URL}/ofertas/#{id_oferta}"
end

def listar_ofertas_de_publicacion_url(id_publicacion)
  "#{BASE_URL}/publicaciones/#{id_publicacion}/ofertas"
end

def consultar_publicacion_url(id_publicacion)
  "#{BASE_URL}/publicaciones/#{id_publicacion}"
end

def reservar_publicacion_url(id_publicacion)
  "#{BASE_URL}/publicaciones/#{id_publicacion}/reservas"
end

def crear_publicacion_activa(patente, marca, modelo, anio, precio, id_telegram)
  body = {patente: patente, marca: marca, modelo: modelo, anio: anio, precio: precio, id_telegram: id_telegram}.to_json
  response = Faraday.post(crear_publicacion_url, body)
  id_publicacion = JSON.parse(response.body)['id']
  response = Faraday.post(informe_de_cotizacion_url(id_publicacion), { precio: precio / 1.3}.to_json)
  id_oferta = JSON.parse(response.body)['id']
  Faraday.patch(rechazar_oferta_url(id_oferta), {estado: 'rechazada'}.to_json)
end

def crear_publicacion_fiubak(patente, marca, modelo, anio, precio, id_telegram)
  body = {patente: patente, marca: marca, modelo: modelo, anio: anio, precio: precio, id_telegram: id_telegram}.to_json
  response = Faraday.post(crear_publicacion_url, body)
  id_publicacion = JSON.parse(response.body)['id']
  response = Faraday.post(informe_de_cotizacion_url(id_publicacion), { precio: precio / 1.3}.to_json)
  id_oferta = JSON.parse(response.body)['id']
  Faraday.patch(aceptar_oferta_url(id_oferta), {estado: 'aceptada'}.to_json)
end

def crear_publicacion_p2p(patente, marca, modelo, anio, precio, id_telegram)
  body = {patente: patente, marca: marca, modelo: modelo, anio: anio, precio: precio, id_telegram: id_telegram}.to_json
  response = Faraday.post(crear_publicacion_url, body)
  id_publicacion = JSON.parse(response.body)['id']
  response = Faraday.post(informe_de_cotizacion_url(id_publicacion), { precio: precio / 1.3}.to_json)
  id_oferta = JSON.parse(response.body)['id']
  Faraday.patch(aceptar_oferta_url(id_oferta), {estado: 'rechazada'}.to_json)
end
