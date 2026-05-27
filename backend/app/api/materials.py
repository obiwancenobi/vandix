import os
import uuid
import aiofiles
from pathlib import Path

from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.security import get_current_user
from app.core.config import get_settings
from app.models.user import User
from app.models.material import Material, MaterialFileType, MaterialStatus

router = APIRouter(prefix="/api/materials", tags=["materials"])
settings = get_settings()


@router.post("")
async def upload_material(
    file: UploadFile = File(...),
    title: str = Form(...),
    file_type: str = Form(...),
    grade_level: str = Form(None),
    subject: str = Form(None),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    upload_dir = Path(settings.upload_dir) / str(user.id)
    upload_dir.mkdir(parents=True, exist_ok=True)

    ext = Path(file.filename).suffix if file.filename else ".bin"
    filename = f"{uuid.uuid4()}{ext}"
    file_path = upload_dir / filename

    async with aiofiles.open(file_path, "wb") as f:
        while chunk := await file.read(1024 * 1024):
            await f.write(chunk)

    ft = MaterialFileType(file_type)
    material = Material(
        user_id=user.id,
        title=title,
        file_type=ft,
        file_path=str(file_path),
        grade_level=grade_level,
        subject=subject,
        status=MaterialStatus.UPLOADED,
    )
    db.add(material)
    await db.flush()

    return {
        "id": str(material.id),
        "title": material.title,
        "file_type": material.file_type.value,
        "status": material.status.value,
        "created_at": material.created_at.isoformat(),
    }


@router.get("")
async def list_materials(
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(Material)
        .where(Material.user_id == user.id)
        .order_by(Material.created_at.desc())
    )
    materials = result.scalars().all()
    return [
        {
            "id": str(m.id),
            "title": m.title,
            "file_type": m.file_type.value,
            "status": m.status.value,
            "grade_level": m.grade_level,
            "subject": m.subject,
            "created_at": m.created_at.isoformat(),
        }
        for m in materials
    ]


@router.get("/{material_id}")
async def get_material(
    material_id: str,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(Material).where(Material.id == material_id, Material.user_id == user.id)
    )
    material = result.scalar_one_or_none()
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")
    return {
        "id": str(material.id),
        "title": material.title,
        "file_type": material.file_type.value,
        "status": material.status.value,
        "grade_level": material.grade_level,
        "subject": material.subject,
        "extracted_text": material.extracted_text,
        "created_at": material.created_at.isoformat(),
    }


@router.delete("/{material_id}")
async def delete_material(
    material_id: str,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(get_current_user),
):
    result = await db.execute(
        select(Material).where(Material.id == material_id, Material.user_id == user.id)
    )
    material = result.scalar_one_or_none()
    if not material:
        raise HTTPException(status_code=404, detail="Material not found")

    # delete file from disk
    try:
        os.remove(material.file_path)
    except FileNotFoundError:
        pass

    await db.delete(material)
    return {"ok": True}
