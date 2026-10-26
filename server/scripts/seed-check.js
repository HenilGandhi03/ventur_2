/**
 * Validate data/levels.seed.json without starting the server.
 * Run: npm run seed:check
 */
import { loadLevels } from '../src/db/loadLevels.js';
import { config } from '../src/config.js';

async function main() {
  const { all, modes, continents } = await loadLevels();
  const perContinent = {};
  for (const l of all) perContinent[l.continent] = (perContinent[l.continent] ?? 0) + 1;

  console.log(`OK: ${all.length} levels in ${config.paths.levelsSeed}`);
  console.log(`Modes: ${modes.join(', ')}`);
  console.log('Levels per continent:');
  for (const [k, v] of Object.entries(perContinent).sort()) {
    console.log(`  ${k.padEnd(16)} ${v}`);
  }
  console.log(`Continents: ${continents.length}`);
}

main().catch((err) => {
  console.error('SEED CHECK FAILED:', err.message);
  process.exit(1);
});
