import { config } from '../config.js';
import { ApiError } from './ApiError.js';

/**
 * Parse & clamp page/limit query params into safe integers.
 * @returns {{ page: number, limit: number, offset: number }}
 */
export function parsePagination(query) {
  const { defaultLimit, maxLimit } = config.pagination;

  const page = clampInt(query.page, 1, Number.MAX_SAFE_INTEGER, 1, 'page');
  const limit = clampInt(query.limit, 1, maxLimit, defaultLimit, 'limit');

  return { page, limit, offset: (page - 1) * limit };
}

function clampInt(raw, min, max, fallback, name) {
  if (raw === undefined) return fallback;
  const n = Number(raw);
  if (!Number.isInteger(n)) {
    throw ApiError.badRequest(`Query param "${name}" must be an integer.`);
  }
  if (n < min) throw ApiError.badRequest(`Query param "${name}" must be >= ${min}.`);
  return Math.min(n, max);
}

/**
 * Wrap a page of items in a consistent envelope with navigation metadata.
 */
export function paginated(items, total, { page, limit }) {
  const totalPages = Math.max(1, Math.ceil(total / limit));
  return {
    data: items,
    meta: {
      page,
      limit,
      total,
      totalPages,
      hasNextPage: page < totalPages,
      hasPrevPage: page > 1,
    },
  };
}
