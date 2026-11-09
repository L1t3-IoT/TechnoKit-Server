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
npm run db:seed                 # категорії, реальні деталі та дрони
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
docker compose exec backend node dist/db/seed.js    # категорії, деталі й дрони (безпечно повторювати)
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
| GET | `/api/products` | `category, q, brand, propInch, cells, minPrice, maxPrice, inStock, sort, page, limit` |
| GET | `/api/brands` · `/api/stats` | бренди; лічильники для головної |
| GET | `/api/drones` · `/api/drones/:slug` | дрони й готові збірки (з деталями та звітом перевірки) |
| POST | `/api/compat/check` | перевірка збірки `{items:[{productId,quantity}]}` → звіт + підказки замін |
| POST | `/api/compat/annotate` | статус сумісності карток каталогу щодо поточної збірки |
| POST | `/api/compat/hydrate` | актуальні дані деталей за id (відновлення збірки з браузера) |
| GET | `/api/products/:id` | одна деталь |
| POST | `/api/auth/register` · `/login` · `/logout` | акаунти (сесії в httpOnly-cookie) |
| GET | `/api/auth/me` | поточний користувач |
| GET/POST | `/api/builds` | збірки користувача |
| GET/PATCH/DELETE | `/api/builds/:id` | збірка з деталями; перейменування; видалення |
| PUT | `/api/builds/:id/items` | замінити склад збірки |

## Перевірка сумісності

Рушій — чиста функція `backend/src/lib/compat.ts` (тести: `cd backend && npm test`). Збірка — по одній деталі на категорію;
мотори й пропелери рахуються кількістю (4 мотори, пропелери комплектами по 4). Кожна перевірка має статус:
`ok` · `warn` (попередження) · `fail` (несумісно) · `open` (даних бракує — перевірте вручну) · `idle` (ще немає потрібних деталей).

| Перевірка | Що порівнюється |
|---|---|
| Комплектність | 4 мотори; 4 пропелери (2 CW + 2 CCW); не вистачає яких категорій |
| Схема кріплення | рама ↔ Stack FC/ESC; FC ↔ ESC; рама ↔ кріплення моторів (16×16, 19×19…) |
| Діапазон напруги | S акумулятора ↔ мотори, ESC, FC (вище межі — помилка; нижче — попередження); оберти kv×V проти діаметра пропелера |
| Струмове навантаження | піковий струм 4 моторів ↔ оцінка акумулятора (А·год × C) і ESC на канал. C-рейтинг — маркетингова оцінка, на сайті це завжди зазначено |
| Зазор пропелерів | діаметр ↔ межа рами; отвір ↔ вал мотора; діапазон пропелерів мотора |
| FC ↔ ESC | один стек виробника або однаковий роз'єм → ок; інакше `open` зі списком ручних перевірок і Betaflight target |

Принцип: якщо даних немає — це `open`, а не вигадане «пройдено». «Усуньте проблеми» перебирає каталог, підставляє кандидата у збірку
й показує лише заміни, що покращують перевірку й не створюють нових помилок. Картки каталогу показують, як деталь поводиться
у вашій збірці («Підходить» / «Перевірте: …» / «Не сумісно: …»).

### Характеристики деталей (`products.specs`, jsonb)

| Категорія | Ключі |
|---|---|
| frames | `wheelbase_mm, max_prop_inch, stack_mounts[], motor_mounts[], arm_mm, weight_g` |
| motors | `stator, kv, cells[], peak_a, motor_mount, shaft_mm, weight_g, prop_inch_range[min,max]` |
| esc | `cells[], continuous_a, burst_a, stack_mount, stack_family, protocols[], firmware, weight_g` |
| flight-controllers | `cpu, gyro, cells[], stack_mount, stack_family, betaflight_target, aio, weight_g` |
| props | `diameter_inch, pitch_inch, blades, bore_mm, pack_qty, weight_g` |
| batteries | `cells[], capacity_mah, c_rating, nominal_v, connector, chemistry, weight_g` |

Кріплення записуються як `"30.5x30.5"`, `"16x16"`. `stack_family` — спільний ідентифікатор плат з одного стека.

## Дані: деталі й дрони

- `backend/src/db/data/parts.ts` — реальні деталі; `drones.ts` — дрони. `npm run db:seed` оновлює їх (безпечно повторювати).
- `verified: true` — характеристики звірено зі сторінкою виробника/магазину (`sourceUrl`); `false` — орієнтовні, на сайті є позначка.
- Ціни орієнтовні (USD, листопад 2026): магазини їх змінюють.
- Дрони двох видів: **reference** — еталонні збірки з деталей каталогу (відкриваються у «Мою збірку» й проходять перевірку),
  **model** — серійні моделі з довідковими даними виробника.
- **Додати свої деталі масово:** заповніть CSV за зразком `backend/data/parts.template.csv` і виконайте
  `npm run db:import -- data/parts.csv` (у Docker: `docker compose exec backend node dist/db/import.js /app/parts.csv`).

## Дизайн (з Figma)

Фронтенд перенесено з Figma-файлу «Untitled» (4 сторінки у темній і світлій темах):
Головна, Каталог, Перевірка збірки, Навчання.

- **Теми.** Кольори — це CSS-змінні в `frontend/src/styles.css` (`:root` — темна, `[data-theme='light']` — світла). Перемикач теми — у футері; вибір запам'ятовується.
- **Шрифт.** Inter (пакет `@fontsource/inter`, самохостинг — працює без інтернету, зручно для Pi).
- **Іконки та лінії-виноски** — SVG, прочитані з Figma: `frontend/src/icons.tsx`.
- **Фото.** У Figma вони растрові, тож автоматично не перенеслись. Усі місця під фото зібрано в
  `frontend/src/assets/images.ts`: покладіть файли в `frontend/public/images/` і впишіть шлях, напр. `drone: '/images/drone.webp'`.
  Поки значення `null` — показується плейсхолдер.
- **Збірка (кошик)** зберігається в браузері (id і кількість; ціни підтягуються з сервера), для залогінених — можна зберегти в «Мої збірки».
- **Зображення з Figma** (`frontend/src/assets/images.ts`): поки значення `null` — плейсхолдери. Мініатюри категорій
  (`partFrame`, `partMotor`…) використовуються як запасні фото всіх деталей без власного фото (`ProductThumb`).

## Оновлення бази після змін схеми

```bash
cd backend
npm run db:migrate   # застосує нову міграцію (0002: дрони, verified/source_url)
npm run db:seed      # оновить деталі та дрони
```

## Що далі
- Фото з Figma (див. вище) та фото конкретних деталей (`products.image_url`)
- Розширення каталогу (CSV-імпорт), особливо ESC/FC, 3–3.5″ і 1S-вупи, Li-ion для далекобійних
- Дані про тягу моторів (thrust-to-weight) і вимірені струми
- Сторінки «Навчання» та «Нотатки»


---

## 8. Робота з базою даних через Python (Скрипти та тести)

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
