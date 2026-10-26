import { createApp } from './app.js';
import { config } from './config.js';
import { loadLevels } from './db/loadLevels.js';

/**
 * Process entry point: load content into memory, then start listening.
 * Loading before listen() means the server is never "up" while unable to
 * serve levels.
 */
async function main() {
  const { all } = await loadLevels();
  console.log(`[startup] loaded ${all.length} levels from ${config.paths.levelsSeed}`);

  const app = createApp();
  const server = app.listen(config.port, config.host, () => {
    console.log(
      `[startup] Ventur API listening on http://${config.host}:${config.port}` +
        ` (env=${config.env}, prefix=${config.apiPrefix})`,
    );
  });

  const shutdown = (signal) => {
    console.log(`[shutdown] ${signal} received, closing server...`);
    server.close(() => process.exit(0));
    // Force-exit if connections hang.
    setTimeout(() => process.exit(1), 10_000).unref();
  };
  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
}

main().catch((err) => {
  console.error('[fatal] failed to start server:', err);
  process.exit(1);
});
