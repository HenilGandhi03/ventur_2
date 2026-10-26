import { readFile, writeFile, mkdir, rename } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { config } from '../config.js';

/**
 * Durable, per-user progress store.
 *
 * Default implementation: a single JSON document written atomically (temp file
 * + rename) so a crash mid-write can't corrupt it. This is intentionally the
 * simplest thing that is correct; it keeps the whole server dependency-free and
 * runnable anywhere.
 *
 * For horizontal scale, replace this module with a Postgres/Redis-backed
 * implementation exposing the same { get, put } interface — no caller changes.
 */
class JsonProgressRepository {
  constructor(storePath = config.paths.progressStore) {
    this.path = resolve(process.cwd(), storePath);
    this.cache = null; // userId -> record
    this.writeChain = Promise.resolve(); // serialise writes
  }

  async _ensureLoaded() {
    if (this.cache) return;
    try {
      const raw = await readFile(this.path, 'utf8');
      this.cache = new Map(Object.entries(JSON.parse(raw)));
    } catch (err) {
      if (err.code === 'ENOENT') {
        this.cache = new Map();
      } else {
        throw err;
      }
    }
  }

  async get(userId) {
    await this._ensureLoaded();
    return this.cache.get(userId) ?? null;
  }

  /**
   * Upsert a user's progress record. Returns the stored record.
   * @param {string} userId
   * @param {object} record
   */
  async put(userId, record) {
    await this._ensureLoaded();
    const stored = { ...record, userId, updatedAt: new Date().toISOString() };
    this.cache.set(userId, stored);
    await this._persist();
    return stored;
  }

  async _persist() {
    // Chain writes so concurrent requests can't interleave file writes.
    this.writeChain = this.writeChain.then(() => this._writeNow());
    return this.writeChain;
  }

  async _writeNow() {
    await mkdir(dirname(this.path), { recursive: true });
    const tmp = `${this.path}.${process.pid}.tmp`;
    const payload = JSON.stringify(Object.fromEntries(this.cache), null, 2);
    await writeFile(tmp, payload, 'utf8');
    await rename(tmp, this.path); // atomic on POSIX
  }
}

export const progressRepository = new JsonProgressRepository();
export { JsonProgressRepository };
