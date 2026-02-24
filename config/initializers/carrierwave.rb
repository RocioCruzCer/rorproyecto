CarrierWave.configure do |config|
  config.root = Rails.root.join('C:/Projects/ProjectROR')
  
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :file
  end
end