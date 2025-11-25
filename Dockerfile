# 1. Base Python
FROM python:3.12-slim

# 2. Pasta do app
WORKDIR /app

# 3. Instalar dependências do sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. Copiar requirements
COPY requirements.txt .

# 5. Instalar libs Python
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copiar projeto
COPY . .

# 7. Coletar arquivos estáticos
RUN python manage.py collectstatic --noinput

# 8. Expor porta
EXPOSE 8000

# 9. Comando final
CMD ["gunicorn", "sistema_incidentes.wsgi:application", "-b", "0.0.0.0:8000"]
