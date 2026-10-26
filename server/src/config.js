// Load a .env file if dotenv is installed. Optional so scripts/tests can run
// before `npm install` (dotenv is only needed to read a local .env file).
try {
  await import('dotenv/config');
} catch {
  /* dotenv not installed — rely on real process.env */
}

/**
 * Centralised, validated runtime configuration.
 * Everything that varies between environments lives here and nowhere else.
 */
function toInt(value, fallback) {
  const n = Number.parseInt(value ?? '', 10);
  return Number.isFinite(n) ? n : fallback;
}

function toList(value, fallback) {
  if (!value) return fallback;
  return value
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean);
}

export const config = {
  env: process.env.NODE_ENV ?? 'development',
  host: process.env.HOST ?? '0.0.0.0',
  port: toInt(process.env.PORT, 3000),

  // API surface
  apiPrefix: process.env.API_PREFIX ?? '/api/v1',

  // CORS: '*' in dev, lock to a comma-separated list in production.
  corsOrigins: toList(process.env.CORS_ORIGINS, ['*']),

  // Pagination guards so a client can never ask for an unbounded page.
  pagination: {
    defaultLimit: toInt(process.env.PAGE_DEFAULT_LIMIT, 20),
    maxLimit: toInt(process.env.PAGE_MAX_LIMIT, 100),
  },

  // Rate limiting (per IP, sliding window).
  rateLimit: {
    windowMs: toInt(process.env.RATE_LIMIT_WINDOW_MS, 60_000),
    max: toInt(process.env.RATE_LIMIT_MAX, 120),
  },

  // Data locations (relative to server/).
  paths: {
    levelsSeed: process.env.LEVELS_SEED_PATH ?? 'data/levels.seed.json',
    progressStore: process.env.PROGRESS_STORE_PATH ?? 'data/progress.json',
  },

  // Default width requested from image CDNs.
  imageWidth: toInt(process.env.IMAGE_WIDTH, 1000),
};

export const isProd = config.env === 'production';
