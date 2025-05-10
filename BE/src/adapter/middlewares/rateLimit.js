import createError from "http-errors";
const rateLimit = 50; // Max requests per 30 seconds
const windowMS = 30 * 1000; // Time window in milliseconds (30 seconds)

// Object to store request counts for each IP address
const requestCounts = {};

// Reset request count for each IP address every 'interval' milliseconds
setInterval(() => {
  Object.keys(requestCounts).forEach((ip) => {
    requestCounts[ip] = 0; // Reset request count for each IP address
  });
}, windowMS);

// Middleware function for rate limiting and timeout handling
function rateLimitIp(req, res, next) {
  const ip = req.ip; // Get client IP address

  // Update request count for the current IP
  requestCounts[ip] = (requestCounts[ip] || 0) + 1;

  // Check if request count exceeds the rate limit
  if (requestCounts[ip] > rateLimit) {
    return next(createError(429, "To many requests."));
  }
  next();
}

export default rateLimitIp;
