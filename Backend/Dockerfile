# Use official Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy all backend code
COPY . .

# Set environment variable for Hugging Face Spaces
ENV HF_HOME=/tmp/huggingface

# Start FastAPI app using run.py
CMD ["python", "run.py"]