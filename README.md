# NeuraLynkr

**A multi-modal matching platform — friendships, networking, and dating — built on how you actually feel, not how you look on a profile.**

NeuraLynkr moves beyond profile pictures and curated bios. Instead of asking you to sell yourself in a paragraph, it measures the signals that actually predict connection: how you react to things, how your body responds, where your eyes linger, and how you describe yourself when you think no one's watching.

---

## The core idea

Every existing dating and social app suffers from the same problem — people perform. Profiles are marketing. Photos are filtered. Bios are edited. The result is a shallow, often misleading basis for matching two humans.

NeuraLynkr asks a different question: **what if compatibility could be measured from the signals you can't fake?**

We combine four signal types into a single compatibility score:

| Signal | Dating | Friendship | Networking |
|---|---|---|---|
| Emotion / value reactions | 35% | 55% | 55% |
| Heart rate / physiology | 25% | 10% | 5% |
| Eye gaze patterns | 20% | 15% | 15% |
| LLM personality traits | 20% | 20% | 25% |

The weighting shifts by mode — dating leans more on physiological attraction; friendship leans on shared emotional reactions and values; networking leans on personality and thought patterns.

---

## Why neural and physiological similarity matters

The scientific grounding for NeuraLynkr comes from a landmark 2018 study:

> **Parkinson, C., Kleinbaum, A. M., & Wheatley, T. (2018). Similar neural responses predict friendship. *Nature Communications*, 9(1), 332.**
> DOI: [10.1038/s41467-017-02722-7](https://doi.org/10.1038/s41467-017-02722-7)

The researchers at Dartmouth and UCLA scanned the brains of 42 graduate students (from a cohort of 279) using fMRI while they watched a range of naturalistic video clips. They then mapped this against the students' real-world friendship network.

The findings were striking: **the more similar two people's neural responses were to the same videos, the more likely they were to be friends.** Neural similarity decreased systematically as social distance increased — close friends were the most neurally similar, friends-of-friends less so, and so on. This effect persisted even after controlling for demographic similarity like age and gender.

The authors described this as **neural homophily** — the tendency for friends to perceive and interpret the world in measurably similar ways, not just to share surface-level traits.

This paper is the scientific backbone of NeuraLynkr. If neural responses to shared stimuli can predict friendship after the fact, they can also *prospectively* guide who to introduce to whom. That's what NeuraLynkr is trying to do — operationalize neural homophily into a matching algorithm.

---

## How NeuraLynkr measures these signals

Direct fMRI isn't feasible for a consumer app. NeuraLynkr instead uses a layered set of proxies that correlate with the same underlying phenomenon:

**Emotion and value reactions.** Users watch short video clips covering a range of themes — humor, conflict, beauty, moral dilemmas. Facial expression recognition via the front camera captures real-time emotional responses. Similarity of reaction patterns stands in for similarity of neural response to the same stimuli.

**Heart rate and physiology.** Using phone-based photoplethysmography or a paired wearable (HealthKit / Google Fit), NeuraLynkr tracks heart rate changes during the same video stimuli. Similar physiological arousal patterns further reinforce the emotion signal.

**Eye gaze patterns.** Where you look, how long you fixate, and what draws your attention are deeply personal. Using the front camera and established gaze-estimation techniques, NeuraLynkr captures a user's gaze trajectory across the same stimuli. Matching gaze patterns correlate with shared attentional priorities and interpretive frames.

**LLM-driven personality modeling.** Traditional quizzes give coarse personality categories. NeuraLynkr uses a short, open-ended quiz whose answers are embedded by a large language model (Anthropic's Claude) into a high-dimensional personality vector. Cosine similarity between vectors gives a nuanced personality-match score.

---

## Three modes, one engine

NeuraLynkr supports three distinct use cases, each with its own weighting and its own feature set:

**Friendship** — Algorithmic matching with captions explaining why ("you both found this book meaningful"). Group chat mode to match 3–5 similar friends at once. Outing suggestions. Larger communities for events.

**Networking** — Matching based on shared intellectual interests. Mentor/mentee mode. Peer mode. A LinkedIn-style landing page for each user.

**Dating** — One-on-one algorithmic matching with compatibility breakdowns. Place suggestions for meeting up.

---

## Freemium and Premium

**Freemium** gives full access to the four core signals — quizzes, eye gaze, video reactions, heart rate, and LLM personality traits. This is the full NeuraLynkr experience for most users.

**Premium** adds actual fMRI scan compatibility for users who want the deepest possible match. This requires partnering with fMRI labs and is a Phase 3 product concern — not shipping at launch.

---

## Tech stack

- **Frontend** — Flutter (Dart), targeting Android, iOS, and web
- **Backend API** — FastAPI (Python)
- **Auth + Database + Realtime + Storage** — Supabase (PostgreSQL with Row-Level Security)
- **Vector database** — Pinecone (for personality and signal embedding search)
- **ML microservice** — Separate Python service for the matching algorithm, signal scoring, and LLM calls
- **LLM** — Anthropic Claude API for personality embedding and match captions

---

## Project structure

```
NeuraLynkr/
├── lib/                    → Flutter app
│   ├── main.dart
│   ├── theme.dart
│   ├── data/               → mock data and quiz questions
│   ├── models/
│   ├── screens/
│   │   └── onboarding/     → welcome, name/age, quiz, permissions
│   ├── services/           → API client, token storage
│   └── widgets/            → reusable UI components
│
├── backend/                → FastAPI server
│   ├── main.py
│   ├── app/
│   │   ├── routers/        → auth, profiles, signals, matches
│   │   ├── middleware/     → JWT verification
│   │   ├── models/         → Pydantic schemas
│   │   └── services/       → Supabase client, Pinecone, Anthropic
│   └── requirements.txt
│
└── README.md
```

---

## Running locally

**Backend:**
```bash
cd backend
python -m venv venv
.\venv\Scripts\Activate.ps1     # Windows PowerShell
pip install -r requirements.txt
uvicorn main:app --reload
```

Backend runs at `http://127.0.0.1:8000`. Interactive API docs at `/docs`.

**Frontend:**
```bash
flutter pub get
flutter run -d chrome           # or an emulator / device
```

You'll need a `backend/.env` file with your own Supabase credentials — see `.env.example` (not committed for security).

---

## Status

NeuraLynkr is in active early development. Current state: onboarding flow, swipe UI with gesture support, real authentication against Supabase, and protected API endpoints. Next milestones are quiz persistence, signal ingestion, and the matching microservice.

---

## License

TBD.
