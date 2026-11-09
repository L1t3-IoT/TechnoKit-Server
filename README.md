# TechnoKit

Каталог FPV-компонентів з перевіркою сумісності збірки.

**Стек:** React + Vite + TypeScript · Fastify + TypeScript · PostgreSQL · Drizzle ORM · Docker Compose

```
technokit/
├── backend/          API (Fastify), схема БД, міграції, seed
├── frontend/         React-застосунок (Vite)
├── db/migrations/    SQL-міграції початкових даних
├── app/              Python-утиліти та скрипти роботи з БД
├── docker-compose.yml
└── .env.example
```

---

## 1. Локальна розробка (веб-сайт)

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

### Зміна схеми БД (Drizzle ORM)
1. Редагуєте `backend/src/db/schema.ts`
2. `npm run db:generate` — створює SQL-міграцію в `backend/drizzle/`
3. `npm run db:migrate` — застосовує

---

## 2. Запуск на сервері (Orange Pi 3B / Продакшн)

Усі образи (`postgres`, `node`, `nginx`) мають ARM64-версії.

```bash
# Клонуйте репозиторій або підтягніть зміни:
git pull origin main

# Запуск або перезбірка веб-сайту:
docker compose --profile app up -d --build
```

Сайт буде доступний на порту 80. Міграції бази даних застосовуються автоматично при старті бекенду.

---

## 3. Робота з базою даних через Python (Скрипти та тести)

Python + PostgreSQL (Docker).

```bash
python -m venv .venv
source .venv/bin/activate          # Windows PowerShell: .venv\Scripts\Activate.ps1
pip install -r requirements.txt

docker compose up -d db
docker compose ps                  # чекаємо статус "healthy"

python -m pytest                   # тести валідації схеми та даних
python -m app.main                 # кількість записів у таблицях
```

### Додавання даних:
Відредагуйте `app/example_add.py` і запустіть:
```bash
python -m app.example_add
```
Доступні функції в `app/add_data.py`: `add_motor`, `add_battery`, `add_other`.

---

## 4. API Ендпоінти

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

---

## 5. Дизайн (з Figma)

Фронтенд перенесено з Figma-файлу:
Головна, Каталог, Перевірка збірки, Навчання.

- **Теми:** CSS-змінні в `frontend/src/styles.css` (`:root` — темна, `[data-theme='light']` — світла).
- **Шрифт:** Inter (`@fontsource/inter`).
- **Іконки:** SVG з Figma (`frontend/src/icons.tsx`).
- **Зображення:** зібрано в `frontend/src/assets/images.ts`.
