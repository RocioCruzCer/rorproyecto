# config/initializers/healthcheck.rb
Rails.application.routes.prepend do
  get "healthcheck", to: proc { [200, {}, ["OK"]] }
  get "up", to: proc { [200, {}, ["OK"]] }
  get "db-check", to: proc { 
    begin
      ActiveRecord::Base.connection.active? ? [200, {}, ["DB OK"]] : [500, {}, ["DB Failed"]]
    rescue => e
      [500, {}, ["DB Error: #{e.message}"]]
    end
  }
end