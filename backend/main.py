from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

load_dotenv()

from app.services.supabase_client import get_supabase
from app.routers import auth, profiles

app = FastAPI(title="Synq API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(profiles.router, prefix="/profiles", tags=["profiles"])

@app.get("/")
async def root():
    return {"status": "ok", "service": "Synq API"}

@app.get("/health")
async def health():
    return {"healthy": True}

@app.get("/health/db")
async def health_db():
    supabase = get_supabase()
    result = supabase.table("profiles").select("id").limit(1).execute()
    return {"db": "connected", "rows": len(result.data)}