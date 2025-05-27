# Gotowy obraz Pythona
FROM python:3.11-slim

# Katalog roboczy
WORKDIR /app

# Pliki z hosta do obrazu
COPY requirements.txt .
COPY app.py .

# Zależności
RUN pip install --no-cache-dir -r requirements.txt

# Port
EXPOSE 5000

# Domyślna komenda
CMD ["python", "app.py"]
