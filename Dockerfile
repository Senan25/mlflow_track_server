FROM ubuntu:latest

# Gerekli paketleri yükleyin
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unixodbc \
    unixodbc-dev \
    gnupg \
    python3 \
    python3-pip \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizinini ayarlayın
WORKDIR /app

# Uygulama dosyalarını kopyalayın
COPY . /app

# Python bağımlılıklarını yükleyin
RUN pip3 install mlflow==2.17.2

# Portu açın
EXPOSE 5000

# mlflow server'ı başlatın
CMD ["mlflow", "server", \
    "--backend-store-uri", "$salary-project-bsu", \
    "--default-artifact-root", "$salary-project-dar", \
    "--host", "0.0.0.0", \
    "--port", "5000"]
