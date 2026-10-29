// "Builds" the library: copies src/ into dist/ and writes a manifest, so a real build leaves real output.
import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';

const pkg = JSON.parse(readFileSync(new URL('../package.json', import.meta.url), 'utf8'));
const dist = new URL('../dist/', import.meta.url);

rmSync(dist, { recursive: true, force: true });
mkdirSync(dist, { recursive: true });
cpSync(new URL('../src/', import.meta.url), dist, { recursive: true });
writeFileSync(new URL('manifest.json', dist), JSON.stringify({ name: pkg.name, version: pkg.version, builtAt: new Date().toISOString() }, null, 2));

console.log(`Built ${pkg.name}@${pkg.version} into dist/`);
