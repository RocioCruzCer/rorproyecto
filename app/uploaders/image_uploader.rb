# app/uploaders/image_uploader.rb
class ImageUploader < CarrierWave::Uploader::Base
  # Intenta cargar MiniMagick, si no está disponible, no pasa nada
  begin
    require 'mini_magick'
    include CarrierWave::MiniMagick
    
    # Solo si MiniMagick está disponible
    version :thumb do
      process resize_to_fill: [200, 150]
    end

    version :carousel do
      process resize_to_fill: [1200, 600]
    end
    
    MiniMagickAvailable = true
  rescue LoadError => e
    puts "MiniMagick no disponible: #{e.message}. Continuando sin redimensionamiento."
    MiniMagickAvailable = false
  end

  # Configuración básica que siempre funciona
  storage :file
  
  def store_dir
    if Rails.env.production?
      "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def extension_allowlist
    %w(jpg jpeg png gif webp)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end