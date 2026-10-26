import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';

import { config, isProd } from './config.js';
import { apiRouter } from './routes/index.js';
import { notFound, errorHandler } from './middleware/errorHandler.js';

/**
 * Build the Express app. Kept free of side effects (no listen()) so it can be
 * imported directly in tests and wrapped by a serverless adapter if needed.
 */
export function createApp() {
  const app = express();

  app.disable('x-powered-by');
  app.set('trust proxy', 1); // correct client IPs behind a load balancer

  // Security, performance, parsing.
  app.use(helmet());
  app.use(compression());
  app.use(
    cors({
      origin: config.corsOrigins.includes('*') ? true : config.corsOrigins,
    }),
  );
  app.use(express.json({ limit: '256kb' }));
  if (!isProd) app.use(morgan('dev'));

  // Health check (unauthenticated, unthrottled) for load balancers/uptime.
  app.get('/health', (req, res) => {
    res.json({ status: 'ok', uptime: process.uptime(), env: config.env });
  });

  // Throttle the API surface.
  app.use(
    config.apiPrefix,
    rateLimit({
      windowMs: config.rateLimit.windowMs,
      max: config.rateLimit.max,
      standardHeaders: true,
      legacyHeaders: false,
    }),
  );

  app.use(config.apiPrefix, apiRouter());

  // 404 + centralised error handling (must be last).
  app.use(notFound);
  app.use(errorHandler);

  return app;
}
