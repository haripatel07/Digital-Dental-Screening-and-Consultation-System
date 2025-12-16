#!/usr/bin/env python3
"""
Entry point for running the Digital Dental Screening Backend.

This script starts the FastAPI application using Uvicorn server.
"""

import uvicorn

if __name__ == "__main__":
    # Run the FastAPI app with auto-reload for development
    uvicorn.run("app.main:app", host="0.0.0.0", port=8001, reload=True)
