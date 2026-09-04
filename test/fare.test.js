const test = require('node:test');
const assert = require('node:assert/strict');
const { calculateFare } = require('../src/fare');

test('calculates base plus distance and time fare', () => {
  assert.equal(calculateFare({ base: 4, perKm: 1.5, perMinute: 0.25, km: 10, minutes: 20 }), 24);
});

test('never returns a negative fare', () => {
  assert.equal(calculateFare({ base: 4, perKm: 1.5, perMinute: 0.25, km: -2, minutes: -5 }), 4);
});
