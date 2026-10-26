/**
 * An error that carries an HTTP status code and a machine-readable code.
 * Thrown anywhere in the stack; translated to a JSON body by errorHandler.
 */
export class ApiError extends Error {
  /**
   * @param {number} status HTTP status code
   * @param {string} message Human-readable message
   * @param {string} [code] Machine-readable code (e.g. 'NOT_FOUND')
   * @param {object} [details] Optional extra context
   */
  constructor(status, message, code = undefined, details = undefined) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code ?? httpCodeFor(status);
    this.details = details;
    this.expose = status < 500; // never leak 5xx internals to clients
  }

  static badRequest(message, details) {
    return new ApiError(400, message, 'BAD_REQUEST', details);
  }

  static notFound(message = 'Resource not found') {
    return new ApiError(404, message, 'NOT_FOUND');
  }

  static internal(message = 'Internal server error') {
    return new ApiError(500, message, 'INTERNAL');
  }
}

function httpCodeFor(status) {
  switch (status) {
    case 400:
      return 'BAD_REQUEST';
    case 401:
      return 'UNAUTHORIZED';
    case 403:
      return 'FORBIDDEN';
    case 404:
      return 'NOT_FOUND';
    case 429:
      return 'RATE_LIMITED';
    default:
      return status >= 500 ? 'INTERNAL' : 'ERROR';
  }
}
