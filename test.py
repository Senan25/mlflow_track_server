import pyodbc

server = 'mlflow-sql-server-senan.database.windows.net'
database = 'mlflow_db
username = 'azurevmsenan25'
password = 'Azurevmpass25'
driver = '{ODBC Driver 17 for SQL Server}'

try:
    conn = pyodbc.connect(
        f'DRIVER={driver};SERVER={server};PORT=1433;DATABASE={database};UID={username};PWD={password}'
    )
    cursor = conn.cursor()
    cursor.execute("SELECT 1")
    print("SQL Server connection successful.")
except Exception as e:
    print("Connection failed:", e)
