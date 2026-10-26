import { getIndexedLevels } from './loadLevels.js';

/**
 * Data-access for levels. Pure query logic over the in-memory index.
 * Everything above this layer (services, controllers) is storage-agnostic:
 * to move to Postgres/SQLite, re-implement these methods and nothing else
 * changes.
 */
export const levelRepository = {
  /** @returns {string[]} distinct game modes */
  modes() {
    return getIndexedLevels().modes;
  },

  /** @returns {string[]} distinct continents */
  continents() {
    return getIndexedLevels().continents;
  },

  /**
   * Filtered + sorted list (before pagination).
   * @param {{ mode?: string, continent?: string }} filter
   */
  find({ mode, continent } = {}) {
    const idx = getIndexedLevels();
    let list = mode ? idx.byMode.get(mode) ?? [] : idx.all;
    if (continent) {
      list = list.filter(
        (l) => l.continent.toLowerCase() === continent.toLowerCase(),
      );
    }
    return list;
  },

  findById(id) {
    return getIndexedLevels().byId.get(id) ?? null;
  },

  count({ mode, continent } = {}) {
    return this.find({ mode, continent }).length;
  },
};
