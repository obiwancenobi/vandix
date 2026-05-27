import uuid
import secrets
import string

import httpx
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.config import get_settings
from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
    create_refresh_token,
    decode_token,
    get_current_user,
)
from app.models.user import User
from app.models.credit import CreditTransaction, CreditTransactionType
from app.schemas.auth import (
    RegisterRequest,
    LoginRequest,
    GoogleAuthRequest,
    TokenResponse,
    RefreshRequest,
    UserResponse,
)

router = APIRouter(prefix="/api/auth", tags=["auth"])
settings = get_settings()


def generate_referral_code(length: int = 8) -> str:
    chars = string.ascii_uppercase + string.digits
    return "".join(secrets.choice(chars) for _ in range(length))


@router.post("/register", response_model=TokenResponse)
async def register(req: RegisterRequest, db: AsyncSession = Depends(get_db)):
    existing = await db.execute(select(User).where(User.email == req.email))
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Email already registered")

    user = User(
        name=req.name,
        email=req.email,
        password_hash=hash_password(req.password),
        referral_code=generate_referral_code(),
        credits=5,
    )

    if req.referral_code:
        ref_result = await db.execute(
            select(User).where(User.referral_code == req.referral_code)
        )
        referrer = ref_result.scalar_one_or_none()
        if referrer:
            user.referred_by = referrer.id

    db.add(user)
    await db.flush()

    # signup bonus transaction
    bonus = CreditTransaction(
        user_id=user.id,
        amount=5,
        type=CreditTransactionType.SIGNUP_BONUS,
        reference_id=str(user.id),
    )
    db.add(bonus)

    # handle referral reward
    if user.referred_by:
        referrer_result = await db.execute(select(User).where(User.id == user.referred_by))
        referrer = referrer_result.scalar_one_or_none()
        if referrer:
            referrer.credits += 5
            ref_bonus = CreditTransaction(
                user_id=referrer.id,
                amount=5,
                type=CreditTransactionType.REFERRAL,
                reference_id=str(user.id),
            )
            db.add(ref_bonus)
            from app.models.credit import Referral, ReferralStatus
            from datetime import datetime, timezone
            referral = Referral(
                referrer_id=referrer.id,
                referred_id=user.id,
                status=ReferralStatus.COMPLETED,
                rewarded_at=datetime.now(timezone.utc),
            )
            db.add(referral)

    access = create_access_token({"sub": str(user.id)})
    refresh = create_refresh_token({"sub": str(user.id)})

    return TokenResponse(access_token=access, refresh_token=refresh)


@router.post("/login", response_model=TokenResponse)
async def login(req: LoginRequest, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.email == req.email))
    user = result.scalar_one_or_none()
    if not user or not user.password_hash:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")

    access = create_access_token({"sub": str(user.id)})
    refresh = create_refresh_token({"sub": str(user.id)})

    return TokenResponse(access_token=access, refresh_token=refresh)


@router.post("/google", response_model=TokenResponse)
async def google_auth(req: GoogleAuthRequest, db: AsyncSession = Depends(get_db)):
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            "https://www.googleapis.com/oauth2/v3/userinfo",
            headers={"Authorization": f"Bearer {req.token}"},
        )
    if resp.status_code != 200:
        raise HTTPException(status_code=401, detail="Invalid Google token")

    google_user = resp.json()
    google_id = google_user["sub"]
    email = google_user["email"]
    name = google_user.get("name", email.split("@")[0])
    avatar = google_user.get("picture")

    result = await db.execute(select(User).where(User.google_id == google_id))
    user = result.scalar_one_or_none()

    if not user:
        # check if email already exists (registered via password)
        email_result = await db.execute(select(User).where(User.email == email))
        user = email_result.scalar_one_or_none()
        if user:
            user.google_id = google_id
            if avatar:
                user.avatar_url = avatar
        else:
            user = User(
                name=name,
                email=email,
                google_id=google_id,
                avatar_url=avatar,
                referral_code=generate_referral_code(),
                credits=5,
            )
            db.add(user)
            await db.flush()

            bonus = CreditTransaction(
                user_id=user.id,
                amount=5,
                type=CreditTransactionType.SIGNUP_BONUS,
                reference_id=str(user.id),
            )
            db.add(bonus)

    access = create_access_token({"sub": str(user.id)})
    refresh = create_refresh_token({"sub": str(user.id)})

    return TokenResponse(access_token=access, refresh_token=refresh)


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(req: RefreshRequest, db: AsyncSession = Depends(get_db)):
    payload = decode_token(req.refresh_token)
    if payload.get("type") != "refresh":
        raise HTTPException(status_code=401, detail="Invalid token type")

    user_id = payload.get("sub")
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    access = create_access_token({"sub": str(user.id)})
    refresh = create_refresh_token({"sub": str(user.id)})

    return TokenResponse(access_token=access, refresh_token=refresh)


@router.get("/me", response_model=UserResponse)
async def get_me(user: User = Depends(get_current_user)):
    return user
