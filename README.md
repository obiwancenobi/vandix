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

# Run in development flavor (localhost:8000)
flutter run --flavor dev --target lib/main_dev.dart

# Run in production flavor (api.vandix.app)
flutter run --flavor prod --target lib/main_prod.dart
```

**Flavor shortcuts:**

| Flavor | Command | API Endpoint | App Name | Bundle ID |
|---|---|---|---|---|
| dev | `flutter run --flavor dev --target lib/main_dev.dart` | `http://localhost:8000` | Vandix Dev | `com.beetlix.vandix.dev` |
| prod | `flutter run --flavor prod --target lib/main_prod.dart` | `https://api.vandix.app` | Vandix | `com.beetlix.vandix` |

**Platform-specific:**

```bash
# iOS Simulator (dev)
flutter run --flavor dev --target lib/main_dev.dart -d iPhone

# Android Emulator (dev)
flutter run --flavor dev --target lib/main_dev.dart -d android

# Build APK (production)
flutter build apk --flavor prod --target lib/main_prod.dart

# Build iOS (production)
flutter build ios --flavor prod --target lib/main_prod.dart
```

**API base URL per flavor** is configured in `lib/config/app_config.dart`. To point dev at a different backend (e.g. physical device on LAN):

```dart
// lib/config/app_config.dart
static AppConfig dev() => const AppConfig._(
      // ...
      apiBaseUrl: 'http://192.168.1.100:8000', // your local IP
    );
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

## Testing Locally

### 1. Start the backend

```bash
cd backend

# Start PostgreSQL + Redis
docker compose up -d db redis

# Activate venv
source .venv/bin/activate

# Run migrations (if not done yet)
alembic upgrade head

# Start API with hot reload
uvicorn app.main:app --reload --port 8000
```

API is now at `http://localhost:8000`. Swagger docs at `http://localhost:8000/docs`.

### 2. Test the API with curl

**Register a user:**
```bash
curl -s http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@test.com","password":"password123"}' | python3 -m json.tool
```

Response:
```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "token_type": "bearer"
}
```

**Save the token for next requests:**
```bash
TOKEN="paste-access-token-here"
```

**Get current user:**
```bash
curl -s http://localhost:8000/api/auth/me \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```

**Upload a material (image):**
```bash
curl -s http://localhost:8000/api/materials \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@/path/to/notes.jpg" \
  -F "title=Biology Chapter 3" \
  -F "file_type=image" \
  -F "grade_level=SMP Kelas 8" | python3 -m json.tool
```

**Upload a material (PDF):**
```bash
curl -s http://localhost:8000/api/materials \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@/path/to/textbook.pdf" \
  -F "title=Math Chapter 5" \
  -F "file_type=pdf" \
  -F "grade_level=SMA Kelas 10" | python3 -m json.tool
```

**List materials:**
```bash
curl -s http://localhost:8000/api/materials \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```

**Generate activities from a material:**
```bash
MATERIAL_ID="paste-material-id-here"

curl -s http://localhost:8000/api/topics \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"material_id\":\"$MATERIAL_ID\",\"types\":[\"flashcard\",\"quiz\",\"matching\"]}" | python3 -m json.tool
```

**List topics:**
```bash
curl -s http://localhost:8000/api/topics \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```

**Get topic with activities:**
```bash
TOPIC_ID="paste-topic-id-here"

curl -s http://localhost:8000/api/topics/$TOPIC_ID \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```

**Publish a topic (parent review → live):**
```bash
curl -s -X PATCH http://localhost:8000/api/topics/$TOPIC_ID/publish \
  -H "Authorization: Bearer $TOKEN" | python3 -m json.tool
```

**Access shared topic (no auth needed):**
```bash
SHARE_CODE="paste-share-code-here"

curl -s http://localhost:8000/api/topics/share/$SHARE_CODE | python3 -m json.tool
```

### 3. Test with Flutter

```bash
cd mobile

# Install deps + codegen
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run dev flavor on iOS Simulator
flutter run --flavor dev --target lib/main_dev.dart -d iPhone

# Run dev flavor on Android Emulator
flutter run --flavor dev --target lib/main_dev.dart -d android
```

The dev flavor connects to `http://localhost:8000` by default.

**Android Emulator** can't reach `localhost` — update the dev API URL in `lib/config/app_config.dart`:
```dart
static AppConfig dev() => const AppConfig._(
      // ...
      apiBaseUrl: 'http://10.0.2.2:8000',  // Android emulator host
    );
```

**iOS Simulator** — `localhost` works as-is.

**Physical device** — use your machine's LAN IP:
```dart
apiBaseUrl: 'http://192.168.x.x:8000',
```

### 4. Full flow test

```bash
# Terminal 1: Backend
cd backend && source .venv/bin/activate && uvicorn app.main:app --reload --port 8000

# Terminal 2: Flutter (dev flavor)
cd mobile && flutter run --flavor dev --target lib/main_dev.dart

# In the app:
# 1. Sign up → get 5 free credits
# 2. Upload a photo of school notes
# 3. Generate activities (flashcard + quiz)
# 4. Review generated activities
# 5. Publish → share link
```

### 5. Using the full Docker stack

```bash
cd backend

# Copy and edit env
cp .env.example .env
# Set your OPENAI_API_KEY in .env

# Build and start everything
docker compose up --build

# API at http://localhost:8000
# PostgreSQL at localhost:5433
# Redis at localhost:6379
```

### 6. Troubleshooting

**Port 5432 already in use:**
The docker-compose.yml uses port 5433 to avoid conflicts. Update `.env` if needed.

**Migration errors:**
```bash
cd backend
source .venv/bin/activate
alembic upgrade head
alembic current    # check current version
alembic history    # see all migrations
```

**Flutter codegen errors:**
```bash
cd mobile
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Backend import errors:**
```bash
cd backend
source .venv/bin/activate
pip install -r requirements.txt
python -c "from app.main import app; print('OK')"
```

## Bundle ID

`com.beetlix.vandix`

## License

Private
