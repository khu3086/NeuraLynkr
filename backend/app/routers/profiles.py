from fastapi import APIRouter, Depends, HTTPException
from app.models.schemas import ProfileResponse
from app.middleware.auth import get_current_user
from app.services.supabase_client import get_supabase

router = APIRouter()

@router.get("/me", response_model=ProfileResponse)
async def get_my_profile(user_id: str = Depends(get_current_user)):
    supabase = get_supabase()
    result = supabase.table("profiles").select("*").eq("id", user_id).single().execute()

    if not result.data:
        raise HTTPException(status_code=404, detail="Profile not found")

    return ProfileResponse(**result.data)