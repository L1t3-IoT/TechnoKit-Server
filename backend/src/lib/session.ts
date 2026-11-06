import { createHash, randomBytes } from 'node:crypto';
import { and, eq, gt } from 'drizzle-orm';
import type { FastifyReply, FastifyRequest } from 'fastify';
import { db } from '../db/index.js';
import { sessions, users } from '../db/schema.js';
import { config } from '../config.js';

export const COOKIE = 'sid';
const TTL_MS = 1000 * 60 * 60 * 24 * 30; // 30 днів

const hash = (token: string) => createHash('sha256').update(token).digest('hex');

export async function createSession(userId: string, reply: FastifyReply) {
  const token = randomBytes(32).toString('base64url');
  const expiresAt = new Date(Date.now() + TTL_MS);
  await db.insert(sessions).values({ tokenHash: hash(token), userId, expiresAt });
  reply.setCookie(COOKIE, token, {
    httpOnly: true, sameSite: 'lax', secure: config.COOKIE_SECURE, path: '/', expires: expiresAt,
  });
}

export async function destroySession(req: FastifyRequest, reply: FastifyReply) {
  const token = req.cookies[COOKIE];
  if (token) await db.delete(sessions).where(eq(sessions.tokenHash, hash(token)));
  reply.clearCookie(COOKIE, { path: '/' });
}

export async function getUser(req: FastifyRequest) {
  const token = req.cookies[COOKIE];
  if (!token) return null;
  const [row] = await db
    .select({ id: users.id, email: users.email })
    .from(sessions)
    .innerJoin(users, eq(users.id, sessions.userId))
    .where(and(eq(sessions.tokenHash, hash(token)), gt(sessions.expiresAt, new Date())));
  return row ?? null;
}

declare module 'fastify' {
  interface FastifyRequest { user: { id: string; email: string } | null }
}

export async function requireUser(req: FastifyRequest, reply: FastifyReply) {
  req.user = await getUser(req);
  if (!req.user) return reply.code(401).send({ error: 'Потрібен вхід в акаунт' });
}
