import json
import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import Optional

from app.core.database import get_db
from app.core.security import get_current_user
from app.models.user import User
from app.models.material import Material, MaterialStatus
from app.models.topic import Topic, TopicStatus, Activity, ActivityType
from app.models.credit import CreditTransaction, CreditTransactionType
from app.services.ai_generator import generate_activities

router = APIRouter(prefix="/api/topics", tags=["topics"])


class GenerateRequest(BaseModel):
    material_id: str
    child_id: Optional[str] = None
    types: list[str]  # ["flashcard", "quiz", "matching", "essay"]


class PublishRequest(BaseModel):
    pass


@router.post("")
async def create_topic(
    req: GenerateRequest,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    # check credits
    if user.credits < 1:
        raise HTTPException(status_code=402, detail="Insufficient credits")

    # get material
    result = await db.execute(
        select(Material).where(Material.id == req.material_id, Material.user_id == user.id)
    )
    material = result.scalar_one_or_none()
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")

    if material.status != MaterialStatus.READY and not material.extracted_text:
        raise HTTPException(status_code=400, detail="Material text not extracted yet")

    # deduct credit
    user.credits -= 1
    credit_tx = CreditTransaction(
        user_id=user.id,
        amount=-1,
        type=CreditTransactionType.GENERATION_USE,
        reference_id=str(material.id),
    )
    db.add(credit_tx)

    # create topic
    share_code = uuid.uuid4().hex[:8].upper()
    topic = Topic(
        material_id=material.id,
        user_id=user.id,
        child_id=req.child_id,
        title=f"Practice: {material.title}",
        status=TopicStatus.GENERATING,
        share_code=share_code,
    )
    db.add(topic)
    await db.flush()

    # generate activities synchronously (move to ARQ background later)
    try:
        activities_data = await generate_activities(
            text=material.extracted_text or "",
            types=req.types,
            grade_level=material.grade_level or "SD Kelas 6",
        )

        for i, act_data in enumerate(activities_data):
            activity = Activity(
                topic_id=topic.id,
                type=ActivityType(act_data["type"]),
                order=i,
                content_json=json.dumps(act_data["content"]),
            )
            db.add(activity)

        topic.status = TopicStatus.REVIEW
    except Exception as e:
        topic.status = TopicStatus.REVIEW
        # log error but don't fail — topic exists in generating state

    return {
        "id": str(topic.id),
        "title": topic.title,
        "status": topic.status.value,
        "share_code": topic.share_code,
    }


@router.get("")
async def list_topics(
    status: str = None,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    query = select(Topic).where(Topic.user_id == user.id)
    if status:
        query = query.where(Topic.status == TopicStatus(status))
    query = query.order_by(Topic.created_at.desc())

    result = await db.execute(query)
    topics = result.scalars().all()
    return [
        {
            "id": str(t.id),
            "title": t.title,
            "status": t.status.value,
            "share_code": t.share_code,
            "created_at": t.created_at.isoformat(),
            "published_at": t.published_at.isoformat() if t.published_at else None,
        }
        for t in topics
    ]


@router.get("/{topic_id}")
async def get_topic(
    topic_id: str,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(Topic).where(Topic.id == topic_id, Topic.user_id == user.id)
    )
    topic = result.scalar_one_or_none()
    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")

    acts_result = await db.execute(
        select(Activity).where(Activity.topic_id == topic.id).order_by(Activity.order)
    )
    activities = acts_result.scalars().all()

    return {
        "id": str(topic.id),
        "title": topic.title,
        "status": topic.status.value,
        "share_code": topic.share_code,
        "created_at": topic.created_at.isoformat(),
        "activities": [
            {
                "id": str(a.id),
                "type": a.type.value,
                "order": a.order,
                "content": json.loads(a.content_json) if a.content_json else None,
            }
            for a in activities
        ],
    }


@router.patch("/{topic_id}/publish")
async def publish_topic(
    topic_id: str,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(Topic).where(Topic.id == topic_id, Topic.user_id == user.id)
    )
    topic = result.scalar_one_or_none()
    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")
    if topic.status != TopicStatus.REVIEW:
        raise HTTPException(status_code=400, detail="Topic not in review state")

    topic.status = TopicStatus.PUBLISHED
    topic.published_at = datetime.now(timezone.utc)
    return {"id": str(topic.id), "status": topic.status.value}


@router.get("/share/{share_code}")
async def get_shared_topic(
    share_code: str,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Topic).where(Topic.share_code == share_code, Topic.status == TopicStatus.PUBLISHED)
    )
    topic = result.scalar_one_or_none()
    if not topic:
        raise HTTPException(status_code=404, detail="Topic not found")

    acts_result = await db.execute(
        select(Activity).where(Activity.topic_id == topic.id).order_by(Activity.order)
    )
    activities = acts_result.scalars().all()

    return {
        "id": str(topic.id),
        "title": topic.title,
        "share_code": topic.share_code,
        "activities": [
            {
                "id": str(a.id),
                "type": a.type.value,
                "order": a.order,
                "content": json.loads(a.content_json) if a.content_json else None,
            }
            for a in activities
        ],
    }
