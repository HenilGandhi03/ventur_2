import { Router } from 'express';
import { levelController } from '../controllers/levelController.js';
import { progressController } from '../controllers/progressController.js';

/**
 * All versioned API routes. Mounted under config.apiPrefix (default /api/v1).
 */
export function apiRouter() {
  const router = Router();

  // --- Meta ---------------------------------------------------------------
  router.get('/modes', levelController.listModes);
  router.get('/continents', levelController.listContinents);

  // --- Levels -------------------------------------------------------------
  // GET /levels?mode=country&continent=Europe&page=1&limit=20
  router.get('/levels', levelController.list);
  router.get('/levels/count', levelController.count);
  router.get('/levels/:id', levelController.getById);

  // --- Progress sync ------------------------------------------------------
  router.get('/users/:userId/progress', progressController.get);
  router.put('/users/:userId/progress', progressController.save);

  return router;
}
