import { levelRepository } from '../db/levelRepository.js';
import { paginated } from '../utils/pagination.js';
import { ApiError } from '../utils/ApiError.js';

/**
 * Business logic for levels. Controllers call these; they never touch the
 * repository directly.
 */
export const levelService = {
  listModes() {
    return levelRepository.modes();
  },

  listContinents() {
    return levelRepository.continents();
  },

  /**
   * @param {{ mode?: string, continent?: string }} filter
   * @param {{ page: number, limit: number, offset: number }} page
   */
  listLevels(filter, page) {
    const all = levelRepository.find(filter);
    const slice = all.slice(page.offset, page.offset + page.limit);
    return paginated(slice, all.length, page);
  },

  getLevel(id) {
    const level = levelRepository.findById(id);
    if (!level) throw ApiError.notFound(`Level "${id}" not found.`);
    return level;
  },

  count(filter) {
    return levelRepository.count(filter);
  },
};
