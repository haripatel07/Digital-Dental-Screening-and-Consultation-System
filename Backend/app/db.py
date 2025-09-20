import motor.motor_asyncio
from fastapi import Depends
from typing import AsyncGenerator
import os

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
DB_NAME = os.getenv("MONGO_DB", "dentalcare")

client = motor.motor_asyncio.AsyncIOMotorClient(MONGO_URI)
db = client[DB_NAME]

def get_db() -> AsyncGenerator:
    yield db
