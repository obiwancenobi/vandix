# Vandix — Project Status

> Last updated: 2026-05-26

## Overview

Vandix is a mobile app that turns school materials into fun learning activities using AI.
Parents upload notes → AI generates flashcards/quizzes/matching/essays → Parent reviews → Child learns.

Tech: Flutter (Riverpod + GoRouter) + FastAPI + PostgreSQL + OpenAI-compatible AI

---

## What's Done

### Phase 1 — Foundation ✅
- [x] Backend scaffolding (FastAPI + async SQLAlchemy + Alembic)
- [x] Docker Compose: PostgreSQL 16 + Redis 7 + API + ARQ worker
- [x] 8 DB models: User, Child, Material, Topic, Activity, ChildProgress, CreditTransaction, Referral
- [x] Initial Alembic migration applied
- [x] Auth endpoints: register, login, Google OAuth, refresh, `/me`
- [x] JWT with access + refresh tokens
- [x] 5 free credits on signup + referral bonus (+5)
- [x] Flutter project scaffold (Riverpod + GoRouter)
- [x] Login + Signup screens with form validation
- [x] GoRouter with auth-based redirects
- [x] Dio HTTP client with auto token refresh + secure storage
- [x] Material 3 theme (purple #6C63FF primary)
- [x] CustomTextField reusable widget
- [x] i18n setup: English + Indonesian (easy_localization)
- [x] Freezed User model with codegen
- [x] GitHub repo: https://github.com/obiwancenobi/vandix

### Phase 2 — Upload & AI Generation ✅
- [x] AuthNotifier (Riverpod) wired to real backend login/register/logout
- [x] Upload screen: camera, gallery, PDF picker (image_picker + file_picker)
- [x] MaterialsRepository (upload, list, get, delete)
- [x] MaterialModel (freezed)
- [x] Backend: POST/GET/DELETE /api/materials (multipart upload, file storage)
- [x] Backend: POST /api/topics (generate activities, 1 credit)
- [x] Backend: GET /api/topics, GET /api/topics/{id}, PATCH /api/topics/{id}/publish
- [x] Backend: GET /api/topics/share/{code} (public, no auth)
- [x] AI service: OCR via vision API, PDF extraction via pdfplumber
- [x] AI service: activity generation (flashcard/quiz/matching/essay) via OpenAI-compatible
- [x] Configurable AI provider (OPENAI_BASE_URL, OPENAI_MODEL, OPENAI_VISION_MODEL)
- [x] .env.example with provider examples (OpenAI, Groq, Together, Ollama, LiteLLM)

### Extras ✅
- [x] Flutter flavors: dev + prod
  - dev: `http://localhost:8000`, app name "Vandix Dev", bundle `com.beetlix.vandix.dev`
  - prod: `https://api.vandix.app`, app name "Vandix", bundle `com.beetlix.vandix`
- [x] lib/config/app_config.dart — AppConfig with flavor settings
- [x] Android productFlavors (dev suffix .dev)
- [x] iOS xcschemes (dev.xcscheme + prod.xcscheme)
- [x] README.md with full docs: setup, API endpoints, monetization, AI pipeline, testing guide, curl examples

---

## What's Left

### Phase 3 — Review & Activity Playback 🔲
- [ ] Parent review screen (edit/remove/reorder generated activities)
- [ ] Flashcard playback (swipe + flip animation)
- [ ] Quiz playback (multiple choice, instant feedback)
- [ ] Matching game (tap-to-pair)
- [ ] Essay playback (type answer, compare with sample)
- [ ] Child progress tracking (score, completion status)

### Phase 4 — RevenueCat + AdMob 🔲
- [ ] RevenueCat Flutter SDK integration
- [ ] Credit pack IAP products (Starter $1.99/10, Family $6.99/50, Power $19.99/200)
- [ ] Pro subscription ($4.99/mo, unlimited + ad-free)
- [ ] Backend: RevenueCat webhook handler
- [ ] AdMob setup (rewarded ads only, max 3/day for free users)
- [ ] "Watch ad for 1 credit" flow
- [ ] Ad-free for Pro subscribers
- [ ] Restore purchases flow

### Phase 5 — Polish & Ship 🔲
- [ ] Child profile management (CRUD)
- [ ] Gamification (stars, streaks, animations)
- [ ] Push notifications (topic ready, payment confirmed)
- [ ] Share topic via WhatsApp deep link
- [ ] Referral code UI (share + redeem)
- [ ] Credits balance + transaction history screen
- [ ] Settings screen (language switch, account)
- [ ] App store assets (icons, screenshots, listing)
- [ ] Coolify deployment + domain setup
- [ ] Beta testing

---

## Current Config

| Setting | Value |
|---|---|
| Bundle ID | `com.beetlix.vandix` |
| Dev API | `http://localhost:8000` |
| Prod API | `https://api.vandix.app` |
| DB | PostgreSQL 16 (Docker, port 5433) |
| AI | OpenAI-compatible, configurable via .env |
| Free credits | 5 on signup |
| Referral bonus | +5 credits |

## Run Commands

```bash
# Backend
cd backend && docker compose up -d db redis
source .venv/bin/activate && uvicorn app.main:app --reload --port 8000

# Flutter (dev)
cd mobile && flutter run --flavor dev --target lib/main_dev.dart

# Flutter (prod)
cd mobile && flutter run --flavor prod --target lib/main_prod.dart

# Codegen
cd mobile && dart run build_runner build --delete-conflicting-outputs

# Migrations
cd backend && source .venv/bin/activate && alembic upgrade head
```

## Key Files

| File | Purpose |
|---|---|
| `backend/app/main.py` | FastAPI app entry, router registration |
| `backend/app/core/config.py` | All env vars (DB, AI, auth, etc.) |
| `backend/app/services/ai_generator.py` | OCR + PDF extraction + AI generation |
| `backend/.env` | Local config (gitignored) |
| `mobile/lib/config/app_config.dart` | Flavor-based settings (API URL, app name) |
| `mobile/lib/app.dart` | Shared bootstrap + VandixApp widget |
| `mobile/lib/main_dev.dart` | Dev entry point |
| `mobile/lib/main_prod.dart` | Prod entry point |
| `mobile/lib/router/app_router.dart` | GoRouter with auth redirects |
| `mobile/lib/features/auth/presentation/auth_provider.dart` | Auth state (Riverpod) |
| `mobile/lib/shared/utils/api_client.dart` | Dio client with token refresh |

## Known Issues / TODOs

- [ ] Material text extraction runs inline on upload — should be async background task (ARQ)
- [ ] Google OAuth not wired in Flutter yet (button placeholder)
- [ ] No error handling for AI generation failures in UI
- [ ] No offline support / caching
- [ ] No rate limiting on API
- [ ] No input sanitization on extracted text before sending to AI
