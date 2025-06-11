# use official python base image
FROM python:3.11-slim

# set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY ./app ./app

# Set env variable
ENV PYTHONPATH=/app

# Run the FastAPI app
CMD ["uvicron", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]