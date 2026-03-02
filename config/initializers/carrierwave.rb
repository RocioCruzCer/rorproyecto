# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  # Configuración para producción (Railway)
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'] || 'us-east-1'
    }
    config.fog_directory = ENV['S3_BUCKET_NAME']
    config.fog_public = true
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
  else
    # Desarrollo y test: almacenamiento local
    config.storage = :file
    config.enable_processing = false if Rails.env.test?
  end
  
  # Directorio para caché (importante para Railway)
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.root = Rails.root
end