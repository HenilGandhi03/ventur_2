import { ApiError } from '../utils/ApiError.js';
import { isProd } from '../config.js';

/** 404 for any unmatched route. */
export function notFound(req, res, next) {
  next(ApiError.notFound(`Route ${req.method} ${req.originalUrl} not found.`));
}

/** Final error translator: every error leaves as a consistent JSON envelope. */
// eslint-disable-next-line no-unused-vars
export function errorHandler(err, req, res, next) {
  const isApiError = err instanceof ApiError;
  const status = isApiError ? err.status : 500;

  if (status >= 500) {
    // Log the real error server-side; never expose internals to clients.
    console.error('[error]', err);
  }

  const body = {
    error: {
      code: isApiError ? err.code : 'INTERNAL',
      message:
        isApiError && err.expose ? err.message : 'Internal server error.',
    },
  };
  if (isApiError && err.details) body.error.details = err.details;
  if (!isProd && status >= 500) body.error.stack = err.stack;

  res.status(status).json(body);
}
