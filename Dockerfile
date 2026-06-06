# Job Search Automation — Flask dashboard + stdlib job-board scrapers.
FROM python:3.12-slim

# No .pyc files; unbuffered stdout/stderr so `docker logs` is live.
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first so the layer caches across code changes.
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Application code (user-state files are bind-mounted at runtime).
COPY . .
RUN chmod +x docker-entrypoint.sh

EXPOSE 8080

# Treat the container as healthy only when the dashboard actually answers.
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python3 -c "import urllib.request,sys; \
sys.exit(0 if urllib.request.urlopen('http://localhost:8080/', timeout=4).status == 200 else 1)"

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["python3", "app.py"]
