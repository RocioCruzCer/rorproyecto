# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  # Configuración para producción (Railway)
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'],
      endpoint: ENV['AWS_ENDPOINT_URL'],  # ¡IMPORTANTE para Railway!
      path_style: true                     # ¡IMPORTANTE para Railway!
    }
    config.fog_directory = ENV['S3_BUCKET_NAME']
    config.fog_public = true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
    
    # URL base para acceder a las imágenes
    config.asset_host = ENV['AWS_ENDPOINT_URL']
  else
    # Desarrollo y test: almacenamiento local
    config.storage = :file
    config.enable_processing = false if Rails.env.test?
  end
  
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.root = Rails.root
end