# Use official Python image for better compatibility
FROM python:3.12-slim

# Set working directory in container
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy all backend code after installing deps
COPY . .

# Set environment variable for Hugging Face Spaces to avoid cache issues
ENV HF_HOME=/tmp/huggingface

# Expose port 7860 for FastAPI
EXPOSE 7860

# Start FastAPI app using run.py
CMD ["python", "run.py"]