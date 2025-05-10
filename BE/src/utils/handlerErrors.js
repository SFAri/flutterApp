export function notFound(req, res, next) {
  res.status(404);
  const error = new Error('Not Found', req.originalUrl);
  next(error);
}

export function errorHandler(err, req, res, next) {
  if (err) console.log(err);

  res.status(err.status || 500);
  res.json({
    status: 'failure',
    error_name: err.name,
    message: err.message,
  });
}
