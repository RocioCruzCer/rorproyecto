source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.2"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# ===== CONFIGURACIÓN DE BASE DE DATOS =====
# SQLite para desarrollo y test
group :development, :test do
  gem "sqlite3"
end

# PostgreSQL para producción (Railway)
group :production do
gem "pg"
  gem "aws-sdk-s3", require: false # Para almacenar archivos en AWS S3 en producción
  gem "fog-aws"
end

# ===== GEMAS PARA EL CARRUSEL DE IMÁGENES =====
gem "carrierwave", "~> 3.0"
# mini_magick para procesamiento de imágenes (requiere ImageMagick)
gem "mini_magick", "~> 4.12", require: false

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Paginación
gem "kaminari"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# reCAPTCHA para seguridad
gem "recaptcha", require: "recaptcha/rails"

# Para ordenar elementos (drag & drop)
gem "acts_as_list", "~> 1.1"

# Para Action Cable (WebSockets) - disponible en todos los entornos
gem "solid_cable"

# Use the database-backed adapters for Rails.cache and Active Job
# Comentados por ahora, descomenta si los necesitas
# gem "solid_cache"
# gem "solid_queue"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end