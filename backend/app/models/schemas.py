from pydantic import BaseModel, EmailStr, Field
from typing import Optional

class SignupRequest(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8)
    display_name: str = Field(..., min_length=1, max_length=50)
    age: int = Field(..., ge=18, le=100)

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class AuthResponse(BaseModel):
    access_token: str
    refresh_token: str
    user_id: str
    display_name: str

class ProfileResponse(BaseModel):
    id: str
    display_name: str
    age: int
    bio: Optional[str] = None
    mode: str
    tier: str