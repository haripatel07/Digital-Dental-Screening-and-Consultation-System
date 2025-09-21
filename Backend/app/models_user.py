from pydantic import BaseModel, EmailStr, Field
from typing import Optional

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: Optional[str] = None

class UserInDB(BaseModel):
    id: str = Field(alias="_id")
    email: EmailStr
    hashed_password: str
    name: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    age: Optional[int] = None
    created_at: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserDetails(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    age: Optional[int] = None

class UserResponse(BaseModel):
    id: str
    email: str
    name: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    age: Optional[int] = None
