#!/bin/bash
# Espera o banco de dados ficar pronto
echo "Esperando o banco de dados..."
until python manage.py migrate --noinput; do
  sleep 5
done

# Roda o servidor Gunicorn
exec gunicorn sistema_incidentes.wsgi:application --bind 0.0.0.0:8000
