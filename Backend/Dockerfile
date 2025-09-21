# Use official Python image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy all backend code
COPY . .

# Copy .env file if present
# (Hugging Face Spaces will use environment variables from the Space settings, but this allows local dev)
COPY .env .env

# Expose port (match run.py: 8001)
EXPOSE 8001

# Set environment variable for Hugging Face Spaces
ENV HF_HOME=/app

# Start FastAPI app using run.py
CMD ["python", "run.py"]