FROM python:3.13-slim

RUN apt-get update && apt-get install -y git

WORKDIR /app
COPY . /app

RUN pip install --upgrade pip \
    && pip install flask

EXPOSE 3000
CMD ["python", "app.py"]
