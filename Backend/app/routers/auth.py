from passlib.context import CryptContext
from datetime import datetime
from fastapi import APIRouter, HTTPException, status, Depends, Header
from app.db import get_db
from app.models_user import UserCreate, UserLogin, UserDetails, UserResponse
from pymongo.errors import DuplicateKeyError
from motor.motor_asyncio import AsyncIOMotorDatabase
import uuid
from typing import Optional

router = APIRouter(prefix="/auth", tags=["auth"])
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def get_user_by_email(db: AsyncIOMotorDatabase, email: str):
    return await db.users.find_one({"email": email})

async def get_user_by_id(db: AsyncIOMotorDatabase, user_id: str):
    return await db.users.find_one({"_id": user_id})

async def verify_token(authorization: Optional[str] = Header(None)):
    """Simple token verification - in production, use proper JWT"""
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="No valid token provided")
    # For now, we'll extract user_id from token (in real app, decode JWT)
    token = authorization.replace("Bearer ", "")
    # Simple token format: "user_id" (in production, use proper JWT)
    return token

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
        "phone": None,
        "address": None,
        "city": None,
        "age": None,
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
    # Return simple token (user_id) - in production, use proper JWT
    token = db_user["_id"]
    return {
        "msg": "Login successful", 
        "token": token,
        "user": {
            "id": db_user["_id"],
            "email": db_user["email"], 
            "name": db_user.get("name")
        }
    }

@router.get("/user-details", response_model=UserResponse)
async def get_user_details(
    user_id: str = Depends(verify_token),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    user = await get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return UserResponse(
        id=user["_id"],
        email=user["email"],
        name=user.get("name"),
        phone=user.get("phone"),
        address=user.get("address"),
        city=user.get("city"),
        age=user.get("age")
    )

@router.put("/user-details", response_model=UserResponse)
async def update_user_details(
    details: UserDetails,
    user_id: str = Depends(verify_token),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    user = await get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Update only provided fields
    update_data = {}
    if details.name is not None:
        update_data["name"] = details.name
    if details.phone is not None:
        update_data["phone"] = details.phone
    if details.address is not None:
        update_data["address"] = details.address
    if details.city is not None:
        update_data["city"] = details.city
    if details.age is not None:
        update_data["age"] = details.age
    
    if update_data:
        await db.users.update_one({"_id": user_id}, {"$set": update_data})
        # Fetch updated user
        updated_user = await get_user_by_id(db, user_id)
        return UserResponse(
            id=updated_user["_id"],
            email=updated_user["email"],
            name=updated_user.get("name"),
            phone=updated_user.get("phone"),
            address=updated_user.get("address"),
            city=updated_user.get("city"),
            age=updated_user.get("age")
        )
    
    # Return current user if no updates
    return UserResponse(
        id=user["_id"],
        email=user["email"],
        name=user.get("name"),
        phone=user.get("phone"),
        address=user.get("address"),
        city=user.get("city"),
        age=user.get("age")
    )
