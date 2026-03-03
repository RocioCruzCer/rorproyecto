# config/initializers/startup_check.rb
puts "=" * 50
puts "🚀 RAILS APP STARTING UP IN PRODUCTION MODE"
puts "=" * 50
puts "Current time: #{Time.now}"
puts "Rails env: #{Rails.env}"
puts "Database URL exists: #{ENV['DATABASE_URL'].present?}"
puts "Secret key base exists: #{ENV['SECRET_KEY_BASE'].present?}"
puts "=" * 50
