#language: es
@wip
Característica: Registro de un usuario
  Antecedentes:
    Dado que estoy registrado

  Escenario: MP001B - Listado de mis publicaciones cuando no tengo ninguna
    Dado que no tengo publicaciones
    Cuando escribo el comando /misPublicaciones
    Entonces el bot me contesta “No tiene autos publicados”

  Escenario: MP002B - Listado de mis publicaciones cuando tengo un auto publicado
    Dado que tengo un auto publicado marca “VW”, modelo “Suran”, año 2016 y precio $550000
    Cuando escribo el comando /misPublicaciones
    Entonces el bot me contesta mostrándome los datos de mi publicación

  Escenario: MP001 - Listado de mis publicaciones cuando no tengo ninguna
  Dado que no tengo publicaciones
  Cuando consulto por mis publicaciones
  Entonces recibo 0 publicaciones

  Escenario: MP002 - Listado de mis publicaciones cuando tengo un auto publicado
  Dado que tengo un auto publicado marca “VW”, modelo “Suran”, año 2016 y precio $550000
  Cuando consulto por mis publicaciones
  Entonces recibo 1 publicaciones
  Y los datos de mi publicación son los correctos

  Escenario: MP002 - Listar mis publicaciones no muestra publicaciones de otros usuarios
  Dado que hay un auto publicado marca “VW”, modelo “Suran”, año 2016 y precio $550000 por el usuario con id de telegram “otro”
  Cuando consulto por mis publicaciones
  Entonces recibo 0 publicaciones