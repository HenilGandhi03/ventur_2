import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { config } from '../config.js';

/**
 * Levels are static, read-heavy content, so we load them once into memory and
 * build lookup indexes. This serves reads in O(1)/O(log n) with no DB round
 * trips and is trivially cacheable / CDN-friendly. Swapping to Postgres later
 * only means re-implementing LevelRepository against the same interface.
 */
let cache = null;

export async function loadLevels(seedPath = config.paths.levelsSeed) {
  const absolute = resolve(process.cwd(), seedPath);
  const raw = await readFile(absolute, 'utf8');
  const parsed = JSON.parse(raw);
  const levels = Array.isArray(parsed) ? parsed : parsed.levels;

  if (!Array.isArray(levels)) {
    throw new Error(`Seed at ${absolute} is not an array of levels.`);
  }

  validate(levels);
  cache = index(levels);
  return cache;
}

export function getIndexedLevels() {
  if (!cache) {
    throw new Error('Levels not loaded. Call loadLevels() during startup.');
  }
  return cache;
}

/** Build indexes for fast lookups. */
function index(levels) {
  const byId = new Map();
  const byMode = new Map();
  const continents = new Set();
  const modes = new Set();

  for (const level of levels) {
    byId.set(level.id, level);
    modes.add(level.mode);
    if (level.continent) continents.add(level.continent);
    if (!byMode.has(level.mode)) byMode.set(level.mode, []);
    byMode.get(level.mode).push(level);
  }

  // Keep each mode's levels ordered by their level number for stable paging.
  for (const list of byMode.values()) {
    list.sort((a, b) => a.level - b.level);
  }

  return {
    all: levels,
    byId,
    byMode,
    modes: [...modes].sort(),
    continents: [...continents].sort(),
  };
}

/** Fail fast on malformed seed data rather than serving broken levels. */
function validate(levels) {
  const ids = new Set();
  levels.forEach((lvl, i) => {
    const where = `levels[${i}]`;
    requireField(lvl.id, `${where}.id`);
    if (ids.has(lvl.id)) throw new Error(`Duplicate level id: ${lvl.id}`);
    ids.add(lvl.id);

    requireField(lvl.mode, `${where}.mode`);
    requireField(lvl.correctAnswer, `${where}.correctAnswer`);
    requireField(lvl.continent, `${where}.continent`);
    if (!Number.isInteger(lvl.level)) {
      throw new Error(`${where}.level must be an integer`);
    }
    if (!Array.isArray(lvl.imageUrls) || lvl.imageUrls.length === 0) {
      throw new Error(`${where}.imageUrls must be a non-empty array`);
    }
    if (!Array.isArray(lvl.options) || lvl.options.length < 2) {
      throw new Error(`${where}.options must have at least 2 entries`);
    }
    if (!lvl.options.includes(lvl.correctAnswer)) {
      throw new Error(`${where}.options must include the correctAnswer`);
    }
  });
}

function requireField(value, name) {
  if (value === undefined || value === null || value === '') {
    throw new Error(`Missing required field: ${name}`);
  }
}
