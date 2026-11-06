# TechnoKit

Каталог FPV-компонентів з перевіркою сумісності збірки.

**Стек:** React + Vite + TypeScript · Fastify + TypeScript · PostgreSQL · Drizzle ORM · Docker Compose

```
technokit/
├── backend/      API (Fastify), схема БД, міграції, seed
├── frontend/     React-застосунок (Vite)
├── docker-compose.yml
└── .env.example
```

## 1. Локальна розробка (ноутбук)

Потрібно: Node.js 22+ і Docker.

```bash
cp .env.example .env            # змініть POSTGRES_PASSWORD (і той самий пароль у DATABASE_URL)
docker compose up -d db         # лише база даних

cd backend
npm install
npm run db:migrate              # створює таблиці
npm run db:seed                 # тестові категорії та деталі
npm run dev                     # API на http://localhost:3000

# в іншому терміналі
cd frontend
npm install
npm run dev                     # сайт на http://localhost:5173
```

Vite проксує `/api` на бекенд, тому cookie працюють без налаштування CORS.

### Зміна схеми БД
1. Редагуєте `backend/src/db/schema.ts`
2. `npm run db:generate` — створює SQL-міграцію в `backend/drizzle/` (комітьте її в git)
3. `npm run db:migrate` — застосовує

## 2. Запуск на сервері (Orange Pi 3B)

Усі образи (`postgres`, `node`, `nginx`) мають ARM64-версії.

```bash
# на Pi встановіть Docker, клонуйте репозиторій, створіть .env
cp .env.example .env
nano .env                        # СИЛЬНИЙ пароль; NODE_ENV=production

docker compose --profile app up -d --build
docker compose exec backend node dist/db/seed.js    # лише для тестових даних
```

Сайт буде на порту 80. Міграції застосовуються автоматично при старті бекенду.

Поради для Pi:
- **База даних не на SD-картці.** Постійні записи швидко її зношують. Краще eMMC, SSD через USB або NVMe. Том `pgdata` можна замапити на диск: `- /mnt/ssd/pgdata:/var/lib/postgresql/data`.
- **Доступ з інтернету:** найпростіше й найбезпечніше — Cloudflare Tunnel (не потрібні білий IP і відкриті порти). Альтернатива — прокидання портів 80/443 на роутері + DDNS і Caddy для HTTPS.
- Коли сайт працює по HTTPS, встановіть `COOKIE_SECURE=true`.
- Бекап БД: `docker compose exec db pg_dump -U technokit technokit > backup.sql`

## API

| Метод | Шлях | Опис |
|---|---|---|
| GET | `/api/health` | перевірка живості та з'єднання з БД |
| GET | `/api/categories` | категорії з кількістю деталей |
| GET | `/api/products` | `category, q, cells, minPrice, maxPrice, inStock, sort, page, limit` |
| GET | `/api/products/:id` | одна деталь |
| POST | `/api/auth/register` · `/login` · `/logout` | акаунти (сесії в httpOnly-cookie) |
| GET | `/api/auth/me` | поточний користувач |
| GET/POST | `/api/builds` | збірки користувача |
| GET/DELETE | `/api/builds/:id` | збірка з деталями |
| PUT | `/api/builds/:id/items` | замінити склад збірки |

Характеристики деталей зберігаються в `products.specs` (jsonb): напруга як `cells: [4,6]`, кріплення, струм тощо. Це основа для майбутньої перевірки сумісності.

## Що далі
- Правила сумісності (напруга, кріплення стеку, струм ESC/акумулятора)
- Форми входу/реєстрації та кошик «Моя збірка» на фронтенді
- Графіка, шрифти та точні стилі з Figma
- Сторінки «Навчання» та «Нотатки»
