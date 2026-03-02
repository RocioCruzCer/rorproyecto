# config/initializers/healthcheck.rb
Rails.application.routes.prepend do
  get "healthcheck", to: proc { [200, {}, ["OK"]] }
  get "up", to: proc { [200, {}, ["OK"]] }  # Railway usa /up por defecto
end