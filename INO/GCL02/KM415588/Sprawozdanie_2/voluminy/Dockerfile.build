FROM python:3.11-slim

WORKDIR /src

RUN pip install --upgrade pip && pip install pytest

CMD pytest tests > /out/test_output.log
