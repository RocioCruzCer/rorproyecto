# config/puma.rb

# Puma configuration file.
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
workers ENV.fetch("WEB_CONCURRENCY", 0)

# Use the `preload_app!` method when specifying a `workers` number.
preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart unless Gem.win_platform?

# Special configuration for Windows
if Gem.win_platform?
  # Deshabilita workers en Windows (no son compatibles)
  workers 0

  # Deshabilita señales de reinicio
  puts "Running on Windows - hot reload disabled"

  # Monkey patch para evitar el error de restart
  module Puma
    class Launcher
      def restart!
        puts "Hot restart not available on Windows. Please stop and start the server manually."
      end
    end
  end
end
