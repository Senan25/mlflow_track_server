FROM python:3.9-slim

# Set environment variables to prevent Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unixodbc \
    unixodbc-dev \
    gnupg \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'export PATH="/opt/mssql-tools/bin:$PATH"' >> ~/.bashrc \
    && /bin/bash -c "source ~/.bashrc"

# Set ODBC environment variables
ENV ODBCINI=/etc/odbc.ini
ENV ODBCSYSINI=/etc

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# # Expose port
# EXPOSE 5000

# # SQL Server connection test command
# CMD sqlcmd -S mlflow-sql-server-senan.database.windows.net -U azurevmsenan25 -P Azurevmpass25 -d mlflow_db -Q "SELECT * FROM INFORMATION_SCHEMA.TABLES" || echo "SQL Server connection failed"

# Expose the port MLflow will run on
EXPOSE 5000



CMD ["mlflow", "server", \
    "--backend-store-uri", "$BACKEND_STORE_URI", \
    "--default-artifact-root", "$DEFAULT_ARTIFACT_ROOT", \
    "--host", "0.0.0.0", \
    "--port", "5000"]
