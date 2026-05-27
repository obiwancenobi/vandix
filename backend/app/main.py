from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.api.auth import router as auth_router
from app.api.materials import router as materials_router
from app.api.topics import router as topics_router

settings = get_settings()

app = FastAPI(title=settings.app_name, version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(materials_router)
app.include_router(topics_router)


@app.get("/health")
async def health():
    return {"status": "ok"}
