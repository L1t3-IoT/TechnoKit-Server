import Fastify from 'fastify';
import cookie from '@fastify/cookie';
import rateLimit from '@fastify/rate-limit';
import { ZodError } from 'zod';
import { config } from './config.js';
import { pool } from './db/index.js';
import { authRoutes } from './routes/auth.js';
import { catalogRoutes } from './routes/catalog.js';
import { buildRoutes } from './routes/builds.js';

const app = Fastify({
  logger: { level: config.NODE_ENV === 'production' ? 'info' : 'debug' },
  trustProxy: true, // за nginx / Cloudflare
});

await app.register(cookie);
await app.register(rateLimit, { global: false });

app.setErrorHandler((err, _req, reply) => {
  if (err instanceof ZodError) return reply.code(400).send({ error: 'Некоректні дані' });
  app.log.error(err);
  const status = (err as { statusCode?: number }).statusCode ?? 500;
  reply.code(status).send({ error: status === 500 ? 'Внутрішня помилка сервера' : (err as Error).message });
});

app.get('/api/health', async () => {
  await pool.query('select 1');
  return { ok: true };
});

await app.register(authRoutes, { prefix: '/api/auth' });
await app.register(catalogRoutes, { prefix: '/api' });
await app.register(buildRoutes, { prefix: '/api/builds' });

const close = async () => { await app.close(); await pool.end(); process.exit(0); };
process.on('SIGTERM', close);
process.on('SIGINT', close);

await app.listen({ port: config.PORT, host: '0.0.0.0' });
