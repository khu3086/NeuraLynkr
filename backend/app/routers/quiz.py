from fastapi import APIRouter, Depends, HTTPException
from app.models.schemas import QuizSubmission
from app.middleware.auth import get_current_user
from app.services.supabase_client import get_supabase

router = APIRouter()

@router.post("/answers")
async def submit_answers(
    payload: QuizSubmission,
    user_id: str = Depends(get_current_user),
):
    supabase = get_supabase()

    supabase.table("quiz_answers").delete().eq("user_id", user_id).execute()

    rows = [
        {
            "user_id": user_id,
            "question_idx": a.question_idx,
            "answer_idx": a.answer_idx,
        }
        for a in payload.answers
    ]

    try:
        result = supabase.table("quiz_answers").insert(rows).execute()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Could not save answers: {str(e)}")

    return {"saved": len(result.data)}

@router.get("/answers")
async def get_answers(user_id: str = Depends(get_current_user)):
    supabase = get_supabase()
    result = (
        supabase.table("quiz_answers")
        .select("question_idx, answer_idx")
        .eq("user_id", user_id)
        .order("question_idx")
        .execute()
    )
    return {"answers": result.data}