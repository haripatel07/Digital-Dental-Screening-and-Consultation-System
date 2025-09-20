from passlib.context import CryptContext
from datetime import datetime
from fastapi import APIRouter, HTTPException, status, Depends
from app.db import get_db
from app.models_user import UserCreate, UserLogin
from pymongo.errors import DuplicateKeyError
from motor.motor_asyncio import AsyncIOMotorDatabase
import uuid

router = APIRouter(prefix="/auth", tags=["auth"])
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def get_user_by_email(db: AsyncIOMotorDatabase, email: str):
    return await db.users.find_one({"email": email})

@router.post("/signup")
async def signup(user: UserCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    if await get_user_by_email(db, user.email):
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed = pwd_context.hash(user.password)
    doc = {
        "_id": str(uuid.uuid4()),
        "email": user.email,
        "hashed_password": hashed,
        "name": user.name,
        "created_at": datetime.utcnow().isoformat()
    }
    try:
        await db.users.insert_one(doc)
    except DuplicateKeyError:
        raise HTTPException(status_code=400, detail="Email already registered")
    return {"msg": "Signup successful"}

@router.post("/login")
async def login(user: UserLogin, db: AsyncIOMotorDatabase = Depends(get_db)):
    db_user = await get_user_by_email(db, user.email)
    if not db_user or not pwd_context.verify(user.password, db_user["hashed_password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"msg": "Login successful", "user": {"email": db_user["email"], "name": db_user.get("name")}}
