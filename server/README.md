# Ventur Server

A scalable REST API for the Ventur **Guess the Country** quiz game (Node + Express).

It serves game modes, Classic levels (country quiz) with images + attribution, and
durably syncs per-user progress so a player's game follows them across installs.

## Why it's built this way

- **Layered**: `routes → controllers → services → repositories`. Business logic
  never touches storage directly, so swapping the data store is a localised change.
- **Read-heavy content is in memory**: levels are static, so they're loaded once,
  indexed, and served without a database round-trip. This is fast, cache/CDN
  friendly, and horizontally scalable.
- **Storage is pluggable**: `levelRepository` and `progressRepository` are plain
  objects behind an interface. Moving progress to Postgres/Redis means
  re-implementing one file; nothing above it changes.
- **Safe by default**: Helmet, CORS allow-list, gzip, per-IP rate limiting, body
  size limits, pagination caps, input validation, and a single consistent error
  envelope.

## Quick start

```bash
cd server
cp .env.example .env        # optional — defaults work out of the box
npm install
npm run seed                # generate data/levels.seed.json from the source
npm start                   # http://localhost:3000
```

Dev mode with auto-reload: `npm run dev`. Tests: `npm test`.

## Data

Edit **`data/countries.source.js`** (the only file you touch to add levels), then
run `npm run seed`. It regenerates `data/levels.seed.json` and `CREDITS.md`.

Images: landmark photos come from **Wikimedia Commons** (`Special:FilePath`), flags
from **flagcdn.com** (public domain). Every image carries a credit object; see
`CREDITS.md`. The app falls back to the country flag if a URL ever fails, so a bad
link degrades gracefully and is a one-line fix in the source file.

## API

Base URL: `http://<host>:<port>/api/v1`

| Method | Path | Description |
| --- | --- | --- |
| GET | `/health` | Liveness probe (unversioned). |
| GET | `/api/v1/modes` | Distinct game modes. |
| GET | `/api/v1/continents` | Distinct continents. |
| GET | `/api/v1/levels` | List levels. Query: `mode`, `continent`, `page`, `limit`. |
| GET | `/api/v1/levels/count` | Count (respects `mode`/`continent`). |
| GET | `/api/v1/levels/:id` | A single level by id (e.g. `country_fr`). |
| GET | `/api/v1/users/:userId/progress` | Fetch a user's saved progress. |
| PUT | `/api/v1/users/:userId/progress` | Upsert a user's progress. |

### List response envelope

```json
{
  "data": [ { "id": "country_fr", "...": "..." } ],
  "meta": { "page": 1, "limit": 20, "total": 60, "totalPages": 3,
            "hasNextPage": true, "hasPrevPage": false }
}
```

### Level shape

```json
{
  "id": "country_fr",
  "mode": "country",
  "level": 1,
  "correctAnswer": "France",
  "continent": "Europe",
  "description": "A Western European nation ...",
  "funfact": "France is the most visited country ...",
  "options": ["France", "Ireland", "Russia", "United Kingdom"],
  "imageUrls": ["https://.../Eiffel_Tower...", "https://.../Louvre...", "https://flagcdn.com/w1280/fr.png"],
  "imageCredits": [ { "title": "...", "source": "...", "author": "...", "license": "...", "sourceUrl": "..." } ]
}
```

### Progress body (PUT)

```json
{ "user": { "...": "..." }, "progress": [ { "...": "..." } ], "session": { "...": "..." } }
```

### Error envelope

```json
{ "error": { "code": "NOT_FOUND", "message": "Level \"country_xx\" not found." } }
```

## Docker

```bash
docker build -t ventur-server .
docker run -p 3000:3000 ventur-server
```

## Scaling notes

- Levels are stateless and in-memory → run as many instances behind a load
  balancer as you like; cache `GET /levels*` at a CDN.
- For multi-instance progress, swap `progressRepository` for a shared store
  (Postgres/Redis). The service/controller/route layers are already agnostic.
