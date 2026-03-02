# config/environments/production.rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # ===== RAILWAY: Configuración para archivos estáticos =====
  # Railway necesita esto para servir assets
  config.public_file_server.enabled = true
  
  # ===== RAILWAY: Configuración para Active Storage con S3 =====
  # Usamos el servicio :local en desarrollo, pero en producción queremos S3
  # Asegúrate de tener config/storage.yml configurado con :amazon
  config.active_storage.service = :amazon  # Cambiado de :local a :amazon

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" || request.path == "/healthcheck" } } }

  # ===== RAILWAY: Log a STDOUT =====
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # ===== RAILWAY: Prevent health checks from clogging logs =====
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # ===== RAILWAY: Configuración de caché =====
  # Para Railway, podemos usar memory_store inicialmente
  # Si necesitas caché persistente, considera usar Redis o solid_cache
  config.cache_store = :memory_store, { size: 64.megabytes }

  # ===== RAILWAY: Active Job =====
  # Usamos async para simplicidad inicial
  config.active_job.queue_adapter = :async

  # Ignore bad email addresses and do not raise email delivery errors.
  config.action_mailer.raise_delivery_errors = false

  # ===== RAILWAY: Configuración de Action Mailer =====
  # IMPORTANTE: Configura el host cuando tengas tu dominio
  host = ENV.fetch("RAILS_HOST", "localhost:3000")
  config.action_mailer.default_url_options = { host: host, protocol: "https" }

  # Specify outgoing SMTP server if needed
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Enable locale fallbacks for I18n
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # ===== RAILWAY: Configuración de hosts permitidos =====
  # Importante para seguridad, permite el dominio de Railway
  config.hosts = [
    IPAddr.new("0.0.0.0/0"),        # Permite todas las IPs (necesario para Railway)
    IPAddr.new("::/0"),              # Permite IPv6
    /.*\.railway\.app/,              # Permite subdominios de railway.app
    ENV["RAILS_HOST"].presence,      # Tu dominio personalizado si existe
    "localhost",                     # Para healthchecks locales
    "127.0.0.1"                      # Para healthchecks locales
  ].compact

  # Skip DNS rebinding protection for health check endpoints
  config.host_authorization = { 
    exclude: ->(request) {
      request.path == "/up" || 
      request.path == "/healthcheck" ||
      request.path.start_with?("/rails/active_storage")  # Permitir acceso a imágenes
    }
  }
end