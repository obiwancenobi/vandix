# Vandix

Turn school materials into fun learning activities using AI.

Upload notes, modules, or exam questions → AI generates flashcards, quizzes, matching games, and essay questions → Parent reviews → Child learns through gamified activities.

## Tech Stack

| Layer | Tech |
|---|---|
| Mobile | Flutter 3.x, Dart |
| State | Riverpod (riverpod_annotation + codegen) |
| Routing | GoRouter |
| HTTP | Dio + Retrofit (codegen) |
| i18n | easy_localization (EN + ID) |
| Backend | Python 3.12 + FastAPI |
| ORM | SQLAlchemy 2.0 (async) + Alembic |
| DB | PostgreSQL 16 |
| Auth | JWT (access+refresh) + Google OAuth |
| AI | OpenAI-compatible API |
| Queue | ARQ (async Redis queue) |
| Deploy | Docker + Coolify |

## Project Structure

```
vandix/
├── backend/
│   ├── app/
│   │   ├── api/              # Route handlers
│   │   │   ├── auth.py       # Register, login, Google OAuth, refresh
│   │   │   ├── materials.py  # Upload, list, get, delete materials
│   │   │   └── topics.py     # Generate, list, publish, share topics
│   │   ├── models/           # SQLAlchemy models
│   │   │   ├── user.py       # User (parent/child)
│   │   │   ├── child.py      # Child profiles
│   │   │   ├── material.py   # Uploaded materials
│   │   │   ├── topic.py      # Topics + Activities
│   │   │   ├── progress.py   # Child progress tracking
│   │   │   └── credit.py     # Credits + Referrals
│   │   ├── schemas/          # Pydantic request/response schemas
│   │   ├── services/         # Business logic
│   │   │   └── ai_generator.py  # OCR, PDF extraction, AI generation
│   │   ├── core/             # Config, security, database
│   │   └── tasks/            # ARQ background jobs
│   ├── alembic/              # Database migrations
│   ├── docker-compose.yml    # PG + Redis + API + Worker
│   ├── Dockerfile
│   └── requirements.txt
│
└── mobile/
    ├── lib/
    │   ├── main.dart
    │   ├── router/           # GoRouter config with auth redirects
    │   ├── features/
    │   │   ├── auth/         # Login, signup, auth provider
    │   │   ├── home/         # Dashboard
    │   │   └── materials/    # Upload, materials list
    │   └── shared/
    │       ├── widgets/      # Reusable widgets
    │       ├── theme/        # App theme (Material 3)
    │       └── utils/        # API client, helpers
    └── assets/i18n/          # EN + ID translations
```

## Getting Started

### Prerequisites

- Python 3.12+
- Flutter 3.x
- Docker & Docker Compose
- PostgreSQL 16 (or use Docker)

### Backend Setup

```bash
cd backend

# Copy env file
cp .env.example .env
# Edit .env with your settings (DB URL, OpenAI key, etc.)

# Start services
docker compose up -d db redis

# Create venv and install deps
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Run migrations
alembic upgrade head

# Start API server
uvicorn app.main:app --reload --port 8000
```

API docs at `http://localhost:8000/docs`

### Flutter Setup

```bash
cd mobile

# Install deps
flutter pub get

# Run code generation (freezed models)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### Using Docker (full stack)

```bash
cd backend
docker compose up --build
```

This starts: PostgreSQL (5433), Redis (6379), API (8000), ARQ worker.

## API Endpoints

### Auth
| Method | Path | Description |
|---|---|---|
| POST | `/api/auth/register` | Register with email/password |
| POST | `/api/auth/login` | Login → JWT tokens |
| POST | `/api/auth/google` | Google OAuth token exchange |
| POST | `/api/auth/refresh` | Refresh access token |
| GET | `/api/auth/me` | Current user profile |

### Materials
| Method | Path | Description |
|---|---|---|
| POST | `/api/materials` | Upload material (multipart: file + title + file_type) |
| GET | `/api/materials` | List user's materials |
| GET | `/api/materials/{id}` | Material detail + extracted text |
| DELETE | `/api/materials/{id}` | Delete material |

### Topics
| Method | Path | Description |
|---|---|---|
| POST | `/api/topics` | Generate activities from material (1 credit) |
| GET | `/api/topics` | List user's topics (filter by status) |
| GET | `/api/topics/{id}` | Topic detail + all activities |
| PATCH | `/api/topics/{id}/publish` | Publish topic (parent review → live) |
| GET | `/api/topics/share/{code}` | Get published topic by share code (public) |

## Monetization

| Tier | Price | Credits |
|---|---|---|
| Free (signup) | $0 | 5 credits |
| Starter | $1.99 | 10 credits |
| Family | $6.99 | 50 credits |
| Power | $19.99 | 200 credits |
| Pro (subscription) | $4.99/mo | Unlimited + ad-free |

- 1 generation = 1 credit
- Free users can watch rewarded ads for +1 credit (max 3/day)
- RevenueCat for IAP (Apple Pay / Google Pay)
- Referral: +5 credits per invite

## AI Generation Pipeline

```
1. Parent uploads material (image/PDF)
2. Backend stores file → extracts text
   - Images: OpenAI Vision API (OCR)
   - PDFs: pdfplumber
3. Parent taps "Generate" → picks activity types + grade level
4. AI generates structured JSON activities:
   - Flashcard: { front, back }
   - Quiz: { question, options[], correct_index, explanation }
   - Matching: { pairs: [{ left, right }] }
   - Essay: { question, sample_answer, rubric }
5. Parent reviews → edits → publishes
6. Child accesses published activities
```

## Bundle ID

`com.beetlix.vandix`

## License

Private
