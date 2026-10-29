import assert from 'node:assert/strict';
import { test } from 'node:test';
import { mixGrains, packBoxes, slug } from '../src/index.js';

test('mixGrains normalises weights to shares that sum to 1', () => {
  const mix = mixGrains({ rice: 2, corn: 1, wheat: 1 });
  assert.equal(mix.rice, 0.5);
  assert.equal(mix.corn, 0.25);
  assert.equal(Object.values(mix).reduce((a, b) => a + b, 0), 1);
});

test('mixGrains rejects an empty mix', () => {
  assert.throws(() => mixGrains({}), RangeError);
});

test('packBoxes splits grains into full boxes and loose ones', () => {
  assert.deepEqual(packBoxes(25, 10), { full: 2, loose: 5 });
  assert.deepEqual(packBoxes(0, 10), { full: 0, loose: 0 });
});

test('packBoxes validates its input', () => {
  assert.throws(() => packBoxes(-1, 10), RangeError);
  assert.throws(() => packBoxes(5, 0), RangeError);
});

test('slug makes label-friendly names', () => {
  assert.equal(slug('  Kepler-22b: Rice & Millet! '), 'kepler-22b-rice-millet');
});
