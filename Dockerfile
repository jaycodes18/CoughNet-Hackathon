FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

COPY backend/requirements.txt /app/requirements.txt
RUN pip install --upgrade pip setuptools wheel && \
    pip install torch torchaudio --index-url https://download.pytorch.org/whl/cpu && \
    pip install -r /app/requirements.txt

COPY backend /app/backend
COPY best_cough_classifier.pt /app/best_cough_classifier.pt

ENV MODEL_PATH=/app/best_cough_classifier.pt
ENV PORT=10000
EXPOSE 10000

CMD ["uvicorn", "backend.api:app", "--host", "0.0.0.0", "--port", "10000"]
