import type { FastifyPluginAsync } from 'fastify';
import { eq } from 'drizzle-orm';
import { z } from 'zod';
import { db } from '../db/index.js';
import { users } from '../db/schema.js';
import { hashPassword, verifyPassword } from '../lib/password.js';
import { createSession, destroySession, getUser } from '../lib/session.js';

const credentials = z.object({
  email: z.string().email().max(254).transform((e) => e.toLowerCase()),
  password: z.string().min(8).max(128),
});

// обмеження спроб, щоб не підбирали паролі
const limit = { config: { rateLimit: { max: 10, timeWindow: '1 minute' } } };

export const authRoutes: FastifyPluginAsync = async (app) => {
  app.post('/register', limit, async (req, reply) => {
    const body = credentials.safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Некоректний email або пароль (мін. 8 символів)' });

    const [exists] = await db.select({ id: users.id }).from(users).where(eq(users.email, body.data.email));
    if (exists) return reply.code(409).send({ error: 'Цей email уже зареєстровано' });

    const [user] = await db.insert(users)
      .values({ email: body.data.email, passwordHash: await hashPassword(body.data.password) })
      .returning({ id: users.id, email: users.email });
    await createSession(user.id, reply);
    return reply.code(201).send({ user });
  });

  app.post('/login', limit, async (req, reply) => {
    const body = credentials.safeParse(req.body);
    if (!body.success) return reply.code(400).send({ error: 'Некоректні дані' });

    const [user] = await db.select().from(users).where(eq(users.email, body.data.email));
    const ok = user && (await verifyPassword(body.data.password, user.passwordHash));
    if (!user || !ok) return reply.code(401).send({ error: 'Невірний email або пароль' });

    await createSession(user.id, reply);
    return { user: { id: user.id, email: user.email } };
  });

  app.post('/logout', async (req, reply) => {
    await destroySession(req, reply);
    return { ok: true };
  });

  app.get('/me', async (req) => ({ user: await getUser(req) }));
};
