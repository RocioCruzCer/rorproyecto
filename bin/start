#!/bin/bash
echo "===== PREPARANDO BASE DE DATOS ====="

for i in {1..5}; do
  if bin/rails db:prepare; then
    echo "¡Base de datos lista y actualizada!"
    break
  fi
  echo "Postgres aún se está despertando (Intento $i de 5). Esperando 3 segundos..."
  sleep 3
done

echo "===== INICIANDO SERVIDOR PUMA ====="
exec bin/rails server -b 0.0.0.0 -p ${PORT:-3000}