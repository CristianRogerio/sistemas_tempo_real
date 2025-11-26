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

# 7. Criar pasta de arquivos estáticos
RUN mkdir -p /app/staticfiles

# 8. Coletar arquivos estáticos
RUN python manage.py collectstatic --noinput

# 9. Copiar entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 10. Expor porta
EXPOSE 8000

# 11. Comando final: usar entrypoint que roda migrate + Gunicorn
CMD ["/app/entrypoint.sh"]
