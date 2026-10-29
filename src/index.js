/** Grain Kit: small helpers for running a very small factory. */

/** Turns a list of grain weights into shares that add up to 1. */
export function mixGrains(weights) {
  const entries = Object.entries(weights);
  const total = entries.reduce((sum, [, w]) => sum + w, 0);
  if (total <= 0) throw new RangeError('A mix needs at least one grain with positive weight');
  return Object.fromEntries(entries.map(([grain, w]) => [grain, w / total]));
}

/** How many full boxes, and how many loose grains, `count` grains make. */
export function packBoxes(count, boxSize) {
  if (!Number.isInteger(count) || count < 0) throw new RangeError('count must be a non-negative integer');
  if (!Number.isInteger(boxSize) || boxSize <= 0) throw new RangeError('boxSize must be a positive integer');
  return { full: Math.floor(count / boxSize), loose: count % boxSize };
}

/** A shipping-label friendly slug: lowercase, dashes, no punctuation. */
export function slug(name) {
  return name
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

export const version = '0.1.0';
