import { progressService } from '../services/progressService.js';
import { asyncHandler } from '../middleware/asyncHandler.js';

export const progressController = {
  get: asyncHandler(async (req, res) => {
    const record = await progressService.get(req.params.userId);
    res.json({ data: record });
  }),

  save: asyncHandler(async (req, res) => {
    const record = await progressService.save(req.params.userId, req.body);
    res.json({ data: record });
  }),
};
