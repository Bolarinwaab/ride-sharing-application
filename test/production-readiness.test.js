const test = require('node:test');
const assert = require('node:assert/strict');
const { loadConfig } = require('../src/config');
const { verifyStripeSignature, createPaymentIntent } = require('../src/integrations/stripe');
const { route } = require('../src/integrations/googleMaps');
const { createIdempotencyKey, requestRide } = require('../src/services/rideService');

test('production config fails closed when required secrets are missing', () => {
  assert.throws(() => loadConfig({ NODE_ENV: 'production', PORT: '8080' }), /Missing required configuration/);
});

test('idempotency key is deterministic and rejects short keys', () => {
  assert.equal(createIdempotencyKey('0123456789abcdef'), createIdempotencyKey('0123456789abcdef'));
  assert.throws(() => createIdempotencyKey('short'), /at least 16/);
});

test('ride request returns existing idempotent request', async () => {
  const calls=[]; const repository={ findByIdempotencyKey: async k => calls.length ? calls[0] : null, create: async x => (calls.push(x), x) };
  const first=await requestRide({key:'0123456789abcdef', riderId:'r1', pickup:'A', destination:'B', repository});
  const second=await requestRide({key:'0123456789abcdef', riderId:'r1', pickup:'A', destination:'B', repository});
  assert.deepEqual(second, first); assert.equal(calls.length, 1);
});

test('Stripe signature verification rejects stale or forged signatures', () => {
  assert.equal(verifyStripeSignature('{}','t=1,v1=bad','secret',300,1000), false);
});

test('Stripe payment intent adapter sends idempotency key', async () => {
  let request;
  const fakeFetch=async (url, options)=>{request={url,options}; return {ok:true,json:async()=>({id:'pi_test'})};};
  const result=await createPaymentIntent({amount:2500,customerId:'r1',idempotencyKey:'0123456789abcdef',secretKey:'sk_test',fetchImpl:fakeFetch});
  assert.equal(result.id,'pi_test'); assert.equal(request.options.headers['Idempotency-Key'],'0123456789abcdef');
});

test('Google Routes adapter uses field mask and API key header', async () => {
  let request;
  const fakeFetch=async (url, options)=>{request={url,options}; return {ok:true,json:async()=>({routes:[]})};};
  await route({origin:'A',destination:'B',apiKey:'key',fetchImpl:fakeFetch});
  assert.equal(request.options.headers['X-Goog-Api-Key'],'key');
  assert.match(request.options.headers['X-Goog-FieldMask'],/routes.duration/);
});
