/**
 * Framework-free tests for the data + service layer (node:test).
 * These exercise the real query logic without needing Express installed.
 * Run: npm test
 */
import { test, before } from 'node:test';
import assert from 'node:assert/strict';

import { loadLevels } from '../src/db/loadLevels.js';
import { levelService } from '../src/services/levelService.js';
import { progressService } from '../src/services/progressService.js';
import { JsonProgressRepository } from '../src/db/progressRepository.js';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

before(async () => {
  await loadLevels();
});

test('loads 60+ levels', () => {
  const total = levelService.count();
  assert.ok(total >= 60, `expected >= 60 levels, got ${total}`);
});

test('every level has a valid, answer-containing option set', () => {
  const { data } = levelService.listLevels({ mode: 'country' }, { page: 1, limit: 1000, offset: 0 });
  for (const lvl of data) {
    assert.equal(lvl.options.length, 4);
    assert.ok(lvl.options.includes(lvl.correctAnswer));
    assert.equal(new Set(lvl.options).size, 4, `duplicate options in ${lvl.id}`);
    assert.equal(lvl.imageUrls.length, 3);
    assert.equal(lvl.imageCredits.length, 3);
  }
});

test('pagination returns the right slice + meta', () => {
  const p1 = levelService.listLevels({ mode: 'country' }, { page: 1, limit: 10, offset: 0 });
  assert.equal(p1.data.length, 10);
  assert.equal(p1.meta.page, 1);
  assert.equal(p1.meta.hasPrevPage, false);
  assert.equal(p1.meta.hasNextPage, true);

  const p2 = levelService.listLevels({ mode: 'country' }, { page: 2, limit: 10, offset: 10 });
  assert.equal(p2.data.length, 10);
  assert.notEqual(p1.data[0].id, p2.data[0].id);
});

test('continent filter narrows results', () => {
  const europe = levelService.listLevels(
    { mode: 'country', continent: 'Europe' },
    { page: 1, limit: 1000, offset: 0 },
  );
  assert.ok(europe.data.length > 0);
  assert.ok(europe.data.every((l) => l.continent === 'Europe'));
});

test('getLevel throws ApiError for unknown id', () => {
  assert.throws(() => levelService.getLevel('country_nope'), /not found/);
});

test('progress round-trips through the repository', async () => {
  // Point the store at a temp file so the test is isolated.
  const repo = new JsonProgressRepository(join(tmpdir(), `ventur-test-${Date.now()}.json`));
  const userId = 'test-user-1';
  const empty = await repo.get(userId);
  assert.equal(empty, null);

  const saved = await repo.put(userId, { user: { coins: 50 }, progress: [], session: null });
  assert.equal(saved.user.coins, 50);
  assert.ok(saved.updatedAt);

  const again = await repo.get(userId);
  assert.equal(again.user.coins, 50);
});

test('progressService rejects a missing userId', async () => {
  await assert.rejects(() => progressService.get(''), /userId/);
});
