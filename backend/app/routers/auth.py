from fastapi import APIRouter, HTTPException
from app.models.schemas import SignupRequest, LoginRequest, AuthResponse
from app.services.supabase_client import get_supabase

router = APIRouter()

@router.post("/signup", response_model=AuthResponse)
async def signup(payload: SignupRequest):
    supabase = get_supabase()

    try:
        auth_result = supabase.auth.sign_up({
            "email": payload.email,
            "password": payload.password,
        })
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Signup failed: {str(e)}")

    if not auth_result.user:
        raise HTTPException(status_code=400, detail="Could not create user")

    user_id = auth_result.user.id

    try:
        supabase.table("profiles").insert({
            "id": user_id,
            "display_name": payload.display_name,
            "age": payload.age,
        }).execute()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Profile creation failed: {str(e)}")

    return AuthResponse(
        access_token=auth_result.session.access_token,
        refresh_token=auth_result.session.refresh_token,
        user_id=user_id,
        display_name=payload.display_name,
    )

@router.post("/login", response_model=AuthResponse)
async def login(payload: LoginRequest):
    supabase = get_supabase()

    try:
        auth_result = supabase.auth.sign_in_with_password({
            "email": payload.email,
            "password": payload.password,
        })
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Login failed: {str(e)}")

    if not auth_result.user or not auth_result.session:
        raise HTTPException(status_code=401, detail="Invalid credentials")

    profile = supabase.table("profiles").select("display_name").eq("id", auth_result.user.id).single().execute()

    return AuthResponse(
        access_token=auth_result.session.access_token,
        refresh_token=auth_result.session.refresh_token,
        user_id=auth_result.user.id,
        display_name=profile.data["display_name"],
    )