import { progressRepository } from '../db/progressRepository.js';
import { ApiError } from '../utils/ApiError.js';

/**
 * Business logic for user progress sync. The client is the source of truth for
 * gameplay; the server durably stores the latest snapshot so progress follows
 * the player across installs/devices.
 */
export const progressService = {
  async get(userId) {
    assertUserId(userId);
    return (await progressRepository.get(userId)) ?? emptyProgress(userId);
  },

  async save(userId, body) {
    assertUserId(userId);
    const record = sanitize(body);
    return progressRepository.put(userId, record);
  },
};

function assertUserId(userId) {
  if (typeof userId !== 'string' || userId.trim().length === 0) {
    throw ApiError.badRequest('A non-empty userId is required.');
  }
  if (userId.length > 128) {
    throw ApiError.badRequest('userId is too long.');
  }
}

function emptyProgress(userId) {
  return {
    userId,
    user: null,
    progress: [],
    session: null,
    updatedAt: null,
  };
}

/** Keep only known fields; reject obviously bad shapes. */
function sanitize(body) {
  if (typeof body !== 'object' || body === null) {
    throw ApiError.badRequest('Request body must be a JSON object.');
  }
  const { user = null, progress = [], session = null } = body;

  if (!Array.isArray(progress)) {
    throw ApiError.badRequest('"progress" must be an array.');
  }
  if (user !== null && typeof user !== 'object') {
    throw ApiError.badRequest('"user" must be an object or null.');
  }
  if (session !== null && typeof session !== 'object') {
    throw ApiError.badRequest('"session" must be an object or null.');
  }

  return { user, progress, session };
}
