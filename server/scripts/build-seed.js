/**
 * Expand server/data/countries.source.js into server/data/levels.seed.json
 * (the file the API serves) and regenerate CREDITS.md.
 *
 * Run: npm run seed
 */
import { writeFile } from 'node:fs/promises';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { countries } from '../data/countries.source.js';
import { config } from '../src/config.js';

const __dirname = dirname(fileURLToPath(import.meta.url));
const serverRoot = resolve(__dirname, '..');

const MODE = 'country';
const IMAGE_WIDTH = config.imageWidth;

// --- URL + credit builders -------------------------------------------------

const commonsImageUrl = (file) =>
  `https://commons.wikimedia.org/wiki/Special:FilePath/${encodeURIComponent(file)}?width=${IMAGE_WIDTH}`;

const commonsFilePage = (file) =>
  `https://commons.wikimedia.org/wiki/File:${encodeURIComponent(file)}`;

const flagUrl = (iso2) => `https://flagcdn.com/w1280/${iso2}.png`;

const commonsCredit = (landmark) => ({
  title: landmark.title,
  source: 'Wikimedia Commons',
  author: 'See source page',
  license: 'Free licence — see source page',
  sourceUrl: commonsFilePage(landmark.file),
});

const flagCredit = (name) => ({
  title: `Flag of ${name}`,
  source: 'flagcdn.com',
  author: 'flagcdn.com',
  license: 'Public domain',
  sourceUrl: 'https://flagcdn.com',
});

// --- Deterministic option generation ---------------------------------------
// A tiny seeded PRNG so options are stable across rebuilds (no surprise diffs).
function mulberry32(seed) {
  return function () {
    seed |= 0;
    seed = (seed + 0x6d2b79f5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function shuffle(arr, rand) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(rand() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

/** Build 4 options: the answer + 3 distractors, preferring same continent. */
function buildOptions(index, all) {
  const me = all[index];
  const rand = mulberry32(index + 1);

  const sameContinent = all
    .filter((c, i) => i !== index && c.continent === me.continent)
    .map((c) => c.name);
  const otherContinent = all
    .filter((c, i) => i !== index && c.continent !== me.continent)
    .map((c) => c.name);

  const pool = [...shuffle(sameContinent, rand), ...shuffle(otherContinent, rand)];
  const distractors = pool.slice(0, 3);

  return shuffle([me.name, ...distractors], rand);
}

// --- Expand -----------------------------------------------------------------

function toLevel(country, index, all) {
  const [a, b] = country.landmarks;
  return {
    id: `${MODE}_${country.iso2}`,
    mode: MODE,
    level: index + 1,
    correctAnswer: country.name,
    continent: country.continent,
    description: country.description,
    funfact: country.funfact,
    options: buildOptions(index, all),
    imageUrls: [commonsImageUrl(a.file), commonsImageUrl(b.file), flagUrl(country.iso2)],
    imageCredits: [commonsCredit(a), commonsCredit(b), flagCredit(country.name)],
  };
}

function buildCreditsMarkdown(levels) {
  const lines = [
    '# Image Credits',
    '',
    'All imagery used in the Ventur quiz is free to use. Landmark photographs are',
    'served from **Wikimedia Commons** via its stable `Special:FilePath` endpoint;',
    'each links to its Commons file page, which carries the exact author and',
    'licence (CC BY, CC BY-SA, CC0 or public domain). Country flags are served from',
    '**flagcdn.com** and are in the public domain.',
    '',
    'Please retain this attribution when distributing the app.',
    '',
    '| Country | Image | Source | Licence | Link |',
    '| --- | --- | --- | --- | --- |',
  ];
  for (const lvl of levels) {
    lvl.imageCredits.forEach((c) => {
      lines.push(
        `| ${lvl.correctAnswer} | ${c.title} | ${c.source} | ${c.license} | ${c.sourceUrl} |`,
      );
    });
  }
  lines.push('');
  return lines.join('\n');
}

async function main() {
  const levels = countries.map(toLevel);

  const seedPath = resolve(serverRoot, config.paths.levelsSeed);
  await writeFile(
    seedPath,
    JSON.stringify({ mode: MODE, generatedAt: new Date().toISOString(), levels }, null, 2),
    'utf8',
  );

  const creditsPath = resolve(serverRoot, 'CREDITS.md');
  await writeFile(creditsPath, buildCreditsMarkdown(levels), 'utf8');

  console.log(`Wrote ${levels.length} levels -> ${seedPath}`);
  console.log(`Wrote credits -> ${creditsPath}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
