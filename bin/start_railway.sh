#!/bin/bash
# bin/start_railway.sh
set -e

# Railway proporciona PORT automáticamente
# Si no existe, usa 3000
PORT=${PORT:-3000}

echo "=== Iniciando Rails en Railway ==="
echo "PORT: $PORT"
echo "RAILS_ENV: ${RAILS_ENV:-production}"

# Verificar que PORT sea numérico
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
  echo "ERROR: PORT debe ser numérico. Valor actual: '$PORT'"
  echo "Usando puerto 3000 por defecto"
  PORT=3000
fi

# Ejecutar Rails
exec bundle exec rails server -p $PORT -b 0.0.0.0