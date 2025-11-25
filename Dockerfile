# ========================================
# Base: Python
# ========================================
FROM python:3.11-slim

# Evita mensagens interativas
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Atualiza o sistema e instala dependências úteis
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Cria diretório de trabalho
WORKDIR /app

# Copia os requisitos
COPY requirements.txt /app/

# Instala dependências Python
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copia o código para o container
COPY . /app/

# Coleta arquivos estáticos (STATIC_ROOT)
RUN python manage.py collectstatic --noinput

# Exposição da porta (Collfy detecta automaticamente)
EXPOSE 8000

# Entrypoint com Gunicorn
CMD ["gunicorn", "incidentes.wsgi:application", "--bind", "0.0.0.0:8000"]
