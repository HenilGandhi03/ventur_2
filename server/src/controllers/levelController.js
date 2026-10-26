import { levelService } from '../services/levelService.js';
import { parsePagination } from '../utils/pagination.js';
import { asyncHandler } from '../middleware/asyncHandler.js';

export const levelController = {
  listModes: asyncHandler(async (req, res) => {
    res.json({ data: levelService.listModes() });
  }),

  listContinents: asyncHandler(async (req, res) => {
    res.json({ data: levelService.listContinents() });
  }),

  list: asyncHandler(async (req, res) => {
    const filter = {
      mode: req.query.mode,
      continent: req.query.continent,
    };
    const page = parsePagination(req.query);
    res.json(levelService.listLevels(filter, page));
  }),

  count: asyncHandler(async (req, res) => {
    const filter = { mode: req.query.mode, continent: req.query.continent };
    res.json({ data: { count: levelService.count(filter) } });
  }),

  getById: asyncHandler(async (req, res) => {
    res.json({ data: levelService.getLevel(req.params.id) });
  }),
};
