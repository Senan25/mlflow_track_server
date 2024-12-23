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

WORKDIR /app

COPY . /app

RUN pip install mlflow==2.17.2

EXPOSE 5000

CMD ["mlflow", "server", \
    "--backend-store-uri", "--secret $salary-project-bsu", \
    "--default-artifact-root", "--secret $salary-project-dar", \
     "--host", "0.0.0.0", \
     "--port", "5000"]
