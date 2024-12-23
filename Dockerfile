FROM python:3.9-slim

# Set environment variables to prevent Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unixodbc \
    unixodbc-dev \
    gnupg \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install  -r requirements.txt


# Portu açın
EXPOSE 5000

# mlflow server'ı başlatın
CMD ["mlflow", "server", \
    "--backend-store-uri", "$salary-project-bsu", \
    "--default-artifact-root", "$salary-project-dar", \
    "--host", "0.0.0.0", \
    "--port", "5000"]
