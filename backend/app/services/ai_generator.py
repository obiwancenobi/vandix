import json
import httpx
from app.core.config import get_settings

settings = get_settings()


async def extract_text_from_image(file_path: str) -> str:
    """Extract text from image using OpenAI vision API."""
    import base64
    from pathlib import Path

    ext = Path(file_path).suffix.lower()
    mime = {".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".png": "image/png", ".webp": "image/webp"}.get(ext, "image/jpeg")

    with open(file_path, "rb") as f:
        b64 = base64.b64encode(f.read()).decode()

    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(
            f"{settings.openai_base_url}/chat/completions",
            headers={"Authorization": f"Bearer {settings.openai_api_key}"},
            json={
                "model": settings.openai_model,
                "messages": [
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": "Extract all text from this image. Return only the extracted text, no commentary.",
                            },
                            {
                                "type": "image_url",
                                "image_url": {"url": f"data:{mime};base64,{b64}"},
                            },
                        ],
                    }
                ],
                "max_tokens": 4096,
            },
        )
    data = response.json()
    return data["choices"][0]["message"]["content"]


async def extract_text_from_pdf(file_path: str) -> str:
    """Extract text from PDF using pdfplumber."""
    import pdfplumber

    texts = []
    with pdfplumber.open(file_path) as pdf:
        for page in pdf.pages[:20]:  # limit to 20 pages
            text = page.extract_text()
            if text:
                texts.append(text)
    return "\n\n".join(texts)


async def extract_text(file_path: str, file_type: str) -> str:
    if file_type == "pdf":
        return await extract_text_from_pdf(file_path)
    else:
        return await extract_text_from_image(file_path)


async def generate_activities(text: str, types: list[str], grade_level: str) -> list[dict]:
    """Generate learning activities from material text using AI."""

    type_instructions = {
        "flashcard": 'Generate 5-10 flashcards. Each has "front" (term/question) and "back" (definition/answer).',
        "quiz": 'Generate 5-10 multiple choice questions. Each has "question", "options" (array of 4), "correct_index" (0-3), and "explanation".',
        "matching": 'Generate 5-8 matching pairs. Each set has "pairs" array with objects containing "left" and "right".',
        "essay": 'Generate 3-5 essay questions. Each has "question", "sample_answer", and "rubric" (grading criteria).',
    }

    instructions = []
    for t in types:
        if t in type_instructions:
            instructions.append(f"### {t.upper()}\n{type_instructions[t]}")

    prompt = f"""You are an education assistant for Indonesian students (grade: {grade_level}).
Based on the following study material, generate learning activities.

{''.join(instructions)}

IMPORTANT: Return a JSON array where each item has:
- "type": one of {json.dumps(types)}
- "content": the activity data matching the schema described above

Material:
{text[:8000]}

Return ONLY valid JSON array, no markdown."""

    async with httpx.AsyncClient(timeout=120.0) as client:
        response = await client.post(
            f"{settings.openai_base_url}/chat/completions",
            headers={"Authorization": f"Bearer {settings.openai_api_key}"},
            json={
                "model": settings.openai_model,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.7,
                "max_tokens": 4096,
            },
        )

    data = response.json()
    content = data["choices"][0]["message"]["content"]

    # strip markdown code blocks if present
    content = content.strip()
    if content.startswith("```"):
        content = content.split("\n", 1)[1]
        content = content.rsplit("```", 1)[0]

    return json.loads(content)
