import { loadLevels } from './src/db/loadLevels.js';
import { levelController } from './src/controllers/levelController.js';
import { progressController } from './src/controllers/progressController.js';
import { config } from './src/config.js';

await loadLevels(config.paths.levelsSeed);

function mockRes() {
  return {
    statusCode: 200,
    body: null,
    status(c) { this.statusCode = c; return this; },
    json(b) { this.body = b; return this; },
  };
}
const run = (fn, req) => new Promise((resolve, reject) => {
  const res = mockRes();
  Promise.resolve(fn(req, res, (e) => e ? reject(e) : resolve(res)))
    .then(() => resolve(res)).catch(reject);
});

let fails = 0;
const check = (name, cond) => { console.log((cond ? 'PASS' : 'FAIL') + ' ' + name); if (!cond) fails++; };

// modes
let r = await run(levelController.listModes, { query: {} });
check('listModes returns country', r.body.data.includes('country'));

// continents
r = await run(levelController.listContinents, { query: {} });
check('listContinents non-empty', Array.isArray(r.body.data) && r.body.data.length > 0);

// list page 1
r = await run(levelController.list, { query: { mode: 'country', page: '1', limit: '10' } });
check('list returns 10 items', r.body.data.length === 10);
check('list meta total >= 60', r.body.meta.total >= 60);
check('list hasNextPage true', r.body.meta.hasNextPage === true);
check('each level has imageUrls+options', r.body.data.every(l => l.imageUrls.length && l.options.includes(l.correctAnswer)));

// count
r = await run(levelController.count, { query: { mode: 'country' } });
check('count >= 60', r.body.data.count >= 60);

// getById valid
const firstId = r.body ? null : null;
let r2 = await run(levelController.list, { query: { mode: 'country', page: '1', limit: '1' } });
const id = r2.body.data[0].id;
r = await run(levelController.getById, { params: { id } });
check('getById returns level', r.body.data.id === id);

// getById invalid -> ApiError
try {
  await run(levelController.getById, { params: { id: 'nope_xyz' } });
  check('getById invalid throws', false);
} catch (e) {
  check('getById invalid throws 404', e.status === 404);
}

// progress get (fresh user) then save then get
const uid = 'mock-user-123';
r = await run(progressController.get, { params: { userId: uid } });
check('progress get fresh ok', r.body.data && r.body.data.user === null || r.body.data.user !== undefined);

const save = { user: { id: uid, coins: 50, hints: 3, lives: 3, currentLevel: 5, highestLevel: 5, statistics: {} }, progress: [], session: {} };
r = await run(progressController.save, { params: { userId: uid }, body: save });
check('progress save ok', r.statusCode === 200);

r = await run(progressController.get, { params: { userId: uid } });
check('progress get after save returns level 5', r.body.data.user && r.body.data.user.currentLevel === 5);

console.log(fails === 0 ? '\nALL MOCK CONTROLLER CHECKS PASSED' : `\n${fails} CHECK(S) FAILED`);
process.exit(fails === 0 ? 0 : 1);
