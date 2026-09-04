function calculateFare({ base, perKm, perMinute, km, minutes }) {
  const distance = Math.max(0, Number(km) || 0);
  const duration = Math.max(0, Number(minutes) || 0);
  return Number((Math.max(0, base) + distance * Math.max(0, perKm) + duration * Math.max(0, perMinute)).toFixed(2));
}
module.exports = { calculateFare };
