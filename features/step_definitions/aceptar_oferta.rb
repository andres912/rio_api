Cuando('acepto la oferta {int}') do |id_oferta|
  body = {estado: 'aceptada'}.to_json
  @response = Faraday.patch(aceptar_oferta_url(id_oferta), body, header)
end

Entonces('la oferta {int} está con estado {string}') do |_id_oferta, _estado_oferta|
  expect(@response.status).to eq 204
end