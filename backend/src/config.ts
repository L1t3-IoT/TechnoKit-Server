import { z } from 'zod';

const schema = z.object({
  DATABASE_URL: z.string().min(1),
  PORT: z.coerce.number().default(3000),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  COOKIE_SECURE: z.enum(['true', 'false']).default('false').transform((v) => v === 'true'),
});

export const config = schema.parse(process.env);
