import enum
import uuid
from datetime import datetime, timezone

from sqlalchemy import String, Text, Enum, ForeignKey, DateTime, Integer
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID

from app.core.database import Base


def utcnow():
    return datetime.now(timezone.utc)


class TopicStatus(str, enum.Enum):
    GENERATING = "generating"
    REVIEW = "review"
    PUBLISHED = "published"
    ARCHIVED = "archived"


class ActivityType(str, enum.Enum):
    FLASHCARD = "flashcard"
    QUIZ = "quiz"
    MATCHING = "matching"
    ESSAY = "essay"


class Topic(Base):
    __tablename__ = "topics"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    material_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("materials.id"), index=True)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id"), index=True)
    child_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("children.id"), nullable=True)
    title: Mapped[str] = mapped_column(String(255))
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    status: Mapped[TopicStatus] = mapped_column(Enum(TopicStatus), default=TopicStatus.GENERATING)
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    share_code: Mapped[str | None] = mapped_column(String(10), unique=True, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)

    material: Mapped["Material"] = relationship(back_populates="topics")
    user: Mapped["User"] = relationship(back_populates="topics")
    activities: Mapped[list["Activity"]] = relationship(back_populates="topic", order_by="Activity.order")


class Activity(Base):
    __tablename__ = "activities"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    topic_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("topics.id"), index=True)
    type: Mapped[ActivityType] = mapped_column(Enum(ActivityType))
    order: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=utcnow)

    topic: Mapped["Topic"] = relationship(back_populates="activities")
    progress: Mapped[list["ChildProgress"]] = relationship(back_populates="activity")

    # content stored as JSONB via raw SQL or separate table — using a Text column for simplicity
    # In production, use SQLAlchemy JSONB type
    content_json: Mapped[str | None] = mapped_column(Text, nullable=True)
