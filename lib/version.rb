class Version
  MAYOR = 2 # Iteracion
  MINOR = 3 # Historia de usuario
  PATCH = 4

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
