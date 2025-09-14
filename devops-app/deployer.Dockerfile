FROM python:3.13-slim

WORKDIR /app

# Skopiowanie tylko app.py
COPY flask/app.py /app

# Instalacja Flask
RUN pip install --no-cache-dir flask

EXPOSE 5000

CMD ["python", "app.py"]
