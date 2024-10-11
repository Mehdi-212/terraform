import pandas as pd
import pyarrow as pa 
import pyarrow.parquet as pq
from google.cloud import storage
import io

def hello_gcs(data, context):
    try:
        # Récupérer les informations
        bucket_name = data["bucket"]
        file_name = data["name"]
        
        # Vérifier si csv
        if not file_name.endswith('.csv'):
            print(f"Fichier ignoré : {file_name} (pas un fichier CSV)")
            return

        # Initialiser le client au bucket
        client = storage.Client()
        blob = client.bucket(bucket_name).blob(file_name)
        
        # Télécharger le fichier CSV
        print(f"Téléchargement et traitement de : {file_name}")
        content = blob.download_as_string()
        csv_data = pd.read_csv(io.BytesIO(content))

        # Convertir le CSV en Parquet
        parquet_buffer = io.BytesIO()
        table = pa.Table.from_pandas(csv_data)
        pq.write_table(table, parquet_buffer)

        # Sauvegarder le fichier Parquet dans 'silver_parquet'
        destination_blob = client.bucket('strategic-goods-437609-f8-silver-parquet').blob(file_name.replace('.csv', '.parquet'))
        destination_blob.upload_from_string(parquet_buffer.getvalue())

        print(f"Conversion et téléchargement de {file_name} vers Parquet terminés.")
    
    except Exception as e:
        print(f"Erreur : {e}")
