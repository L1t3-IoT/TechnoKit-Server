# База даних комплектуючих для дронів

Python + PostgreSQL (Docker). Таблиці порожні, дані додаєте самі.

## Запуск

```bash
python -m venv .venv
source .venv/bin/activate          # Windows PowerShell: .venv\Scripts\Activate.ps1
pip install -r requirements.txt

cp .env.example .env               # Windows PowerShell: Copy-Item .env.example .env

docker compose up -d
docker compose ps                  # чекаємо статус "healthy"

python -m pytest                   # 2 тести
python -m app.main                 # кількість записів у таблицях
```

## Додавання даних

**Python.** Відредагуйте `app/example_add.py` і запустіть:

```bash
python -m app.example_add
```

Доступні функції в `app/add_data.py`: `add_motor`, `add_battery`, `add_other`
(камери, VTX, GPS, приймачі: характеристики передаються в `specs`).

**SQL-консоль:**

```bash
docker compose exec db psql -U app -d app_test
```

**Графічний клієнт (DBeaver, pgAdmin):** host `localhost`, port `5432`,
database `app_test`, user `app`, пароль з файлу `.env`.

Порядок додавання: `manufacturers` → `components` → специфічна таблиця
(`motors`, `batteries`, ...) з тим самим `component_id`.

## Керування базою

```bash
docker compose down        # зупинити, дані ЗБЕРЕЖУТЬСЯ
docker compose down -v     # зупинити і ВИДАЛИТИ всі дані (повне скидання)
docker compose logs -f db  # логи
```

Міграції з `db/migrations` виконуються лише при першому створенні бази.
Якщо змінюєте структуру таблиць, потрібен `down -v` (дані при цьому зникнуть).

## Структура

```
app/
  config.py        читає .env
  db.py            підключення до PostgreSQL
  components.py    запити (пошук, сумісність, вага збірки)
  add_data.py      функції додавання деталей
  example_add.py   приклад додавання
  main.py          кількість записів у таблицях
db/migrations/
  001_init.sql        структура таблиць
  002_categories.sql  довідник типів деталей
tests/
  test_schema.py   перевірка таблиць
```
