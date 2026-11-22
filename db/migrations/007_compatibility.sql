-- Сумісність деталей і перевірка збірок.
--
--   v_pair_checks         кожна пара деталей, для якої є правило: ok / warn / fail / unknown
--   v_drone_checks        ті самі перевірки, але лише для деталей однієї збірки (drones + drone_parts)
--   v_drone_missing_parts яких обовʼязкових деталей у збірці немає
--   v_drone_summary       підсумок по кожній збірці: verdict ok / warn / fail
--
-- Статуси:
--   ok       правило виконується
--   warn     працюватиме, але без запасу або потрібен перехідник
--   fail     не поєднується
--   unknown  у каталозі немає даних для перевірки (це НЕ означає, що не поєднується)
--
-- Це перевірка за даними каталогу, а не гарантія польоту.

-- ============ Привʼязка збірок до сценаріїв ============
ALTER TABLE drones ADD COLUMN use_case_id INT REFERENCES use_cases(id);

-- ============ Допоміжні функції ============

-- '6S' -> [6,6]; '4S–6S' -> [4,6]; NULL, якщо в тексті немає банок
CREATE FUNCTION cells_range(txt TEXT) RETURNS int4range
LANGUAGE sql IMMUTABLE AS $$
    SELECT CASE WHEN txt ~ '\d\s*S' THEN
        (SELECT int4range(min(n::int), max(n::int), '[]')
         FROM regexp_matches(txt, '(\d+)\s*S', 'g') AS m(a), unnest(m.a) AS n)
    END
$$;

-- '30x30 / 20x20 / 25.5x25.5' -> {20,25,30}: кріплення стека (30.5 вважаємо 30)
CREATE FUNCTION mount_sizes(txt TEXT) RETURNS int[]
LANGUAGE sql IMMUTABLE AS $$
    SELECT array_agg(DISTINCT floor(x::numeric)::int)
    FROM regexp_matches(txt, '(\d+(?:\.\d+)?)\s*x\s*\d', 'g') AS m(a), unnest(m.a) AS x
$$;

-- '1.2 / 5.8' -> {1.2,5.8}
CREATE FUNCTION freq_set(txt TEXT) RETURNS numeric[]
LANGUAGE sql IMMUTABLE AS $$
    SELECT array_agg(DISTINCT x::numeric)
    FROM regexp_matches(txt, '\d+(?:\.\d+)?', 'g') AS m(a), unnest(m.a) AS x
$$;

-- 'MMCX / U.FL (IPEX)' -> {mmcx,u.fl}
CREATE FUNCTION conn_set(txt TEXT) RETURNS text[]
LANGUAGE sql IMMUTABLE AS $$
    SELECT CASE WHEN txt IS NULL OR txt = '' THEN NULL
           ELSE regexp_split_to_array(lower(replace(txt, ' (IPEX)', '')), '\s*/\s*') END
$$;

-- ============ Правила для пар деталей ============
CREATE VIEW v_pair_checks AS

-- 1. Мотор і акумулятор: кількість банок (напруга)
SELECT 'motor_battery_voltage'::text AS rule, m.component_id AS a_id, b.component_id AS b_id,
    CASE
        WHEN cells_range(m.voltage_cells) IS NULL THEN 'unknown'
        WHEN cells_range(m.voltage_cells) && int4range(b.cells_s, COALESCE(b.cells_s_max, b.cells_s), '[]') THEN 'ok'
        ELSE 'fail'
    END AS status,
    CASE
        WHEN cells_range(m.voltage_cells) IS NULL THEN 'У мотора не вказано напругу'
        WHEN cells_range(m.voltage_cells) && int4range(b.cells_s, COALESCE(b.cells_s_max, b.cells_s), '[]')
            THEN format('Мотор %s, акумулятор %sS: напруга підходить', m.voltage_cells, b.cells_s)
        ELSE format('Мотор розрахований на %s, а акумулятор %sS', m.voltage_cells, b.cells_s)
    END AS message
FROM motors m CROSS JOIN batteries b

UNION ALL
-- 2. Стек і мотор: струм регулятора (ESC) проти максимального струму мотора
SELECT 'stack_motor_current', s.component_id, m.component_id,
    CASE
        WHEN s.esc_current_a IS NULL OR m.max_current_a IS NULL THEN 'unknown'
        WHEN s.esc_current_a >= m.max_current_a THEN 'ok'
        WHEN s.esc_peak_a >= m.max_current_a THEN 'warn'
        ELSE 'fail'
    END,
    CASE
        WHEN s.esc_current_a IS NULL THEN 'У стека не вказано струм ESC'
        WHEN m.max_current_a IS NULL THEN 'У мотора не вказано максимальний струм'
        WHEN s.esc_current_a >= m.max_current_a
            THEN format('ESC %s A тривало, мотор до %s A: запас є', s.esc_current_a, m.max_current_a)
        WHEN s.esc_peak_a >= m.max_current_a
            THEN format('ESC %s A тривало (пік %s A), мотор до %s A: працюватиме без запасу', s.esc_current_a, s.esc_peak_a, m.max_current_a)
        ELSE format('ESC %s A (пік %s A) слабший за мотор до %s A', s.esc_current_a, s.esc_peak_a, m.max_current_a)
    END
FROM stacks s CROSS JOIN motors m

UNION ALL
-- 3. Рама і стек: розмір кріплення
SELECT 'frame_stack_mount', f.component_id, s.component_id,
    CASE
        WHEN mount_sizes(f.stack_mount_mm) IS NULL OR mount_sizes(s.mount_mm) IS NULL THEN 'unknown'
        WHEN mount_sizes(f.stack_mount_mm) && mount_sizes(s.mount_mm) THEN 'ok'
        ELSE 'fail'
    END,
    CASE
        WHEN mount_sizes(f.stack_mount_mm) IS NULL THEN 'У рами не вказано кріплення стека'
        WHEN mount_sizes(s.mount_mm) IS NULL THEN 'У стека не вказано кріплення'
        WHEN mount_sizes(f.stack_mount_mm) && mount_sizes(s.mount_mm)
            THEN format('Кріплення збігається (рама: %s, стек: %s)', f.stack_mount_mm, s.mount_mm)
        ELSE format('Рама під %s мм, а стек %s мм', f.stack_mount_mm, s.mount_mm)
    END
FROM frames f CROSS JOIN stacks s

UNION ALL
-- 4. Рама і гвинт: діаметр гвинта не більший за розмір рами (допуск 0.5")
SELECT 'frame_prop_size', f.component_id, p.component_id,
    CASE
        WHEN f.max_prop_in IS NULL OR p.diameter_in IS NULL THEN 'unknown'
        WHEN p.diameter_in <= f.max_prop_in + 0.5 THEN 'ok'
        ELSE 'fail'
    END,
    CASE
        WHEN f.max_prop_in IS NULL THEN 'У рами не вказано максимальний розмір гвинта'
        WHEN p.diameter_in IS NULL THEN 'У гвинта не вказано діаметр'
        WHEN p.diameter_in <= f.max_prop_in + 0.5
            THEN format('Гвинт %s" підходить до рами %s"', p.diameter_in, f.max_prop_in)
        ELSE format('Гвинт %s" завеликий для рами %s"', p.diameter_in, f.max_prop_in)
    END
FROM frames f CROSS JOIN propellers p

UNION ALL
-- 5. Камера і відеопередавач: аналог / цифра
SELECT 'camera_vtx_signal', k.component_id, v.component_id,
    CASE
        WHEN k.signal IS NULL OR v.link_type IS NULL THEN 'unknown'
        WHEN k.signal = 'Analog / Digital' THEN 'ok'
        WHEN k.signal = 'Analog'  AND v.link_type = 'analog' THEN 'ok'
        WHEN k.signal = 'Digital' AND v.link_type IN ('digital', 'anti_jam') THEN 'ok'
        ELSE 'fail'
    END,
    CASE
        WHEN k.signal IS NULL OR v.link_type IS NULL THEN 'Невідомий тип сигналу'
        WHEN k.signal = 'Analog / Digital'
            OR (k.signal = 'Analog'  AND v.link_type = 'analog')
            OR (k.signal = 'Digital' AND v.link_type IN ('digital', 'anti_jam'))
            THEN format('Камера (%s) і VTX (%s) однієї системи', k.signal, v.link_type)
        ELSE format('Камера (%s) не працює з VTX (%s)', k.signal, v.link_type)
    END
FROM cameras k CROSS JOIN vtx v

UNION ALL
-- 6. Відеопередавач і антена: частота (fail) та роз'єм (warn: потрібен перехідник)
SELECT 'vtx_antenna', v.component_id, a.component_id,
    CASE
        WHEN freq_set(v.frequency_ghz) IS NULL OR freq_set(a.frequency_ghz) IS NULL THEN 'unknown'
        WHEN NOT (freq_set(v.frequency_ghz) && freq_set(a.frequency_ghz)) THEN 'fail'
        WHEN conn_set(v.connector) IS NOT NULL AND conn_set(a.connector) IS NOT NULL
             AND NOT (conn_set(v.connector) && conn_set(a.connector)) THEN 'warn'
        ELSE 'ok'
    END,
    CASE
        WHEN freq_set(v.frequency_ghz) IS NULL THEN 'У VTX не вказано частоту'
        WHEN freq_set(a.frequency_ghz) IS NULL THEN 'У антени не вказано частоту'
        WHEN NOT (freq_set(v.frequency_ghz) && freq_set(a.frequency_ghz))
            THEN format('VTX %s ГГц, антена %s ГГц: частоти не збігаються', v.frequency_ghz, a.frequency_ghz)
        WHEN conn_set(v.connector) IS NOT NULL AND conn_set(a.connector) IS NOT NULL
             AND NOT (conn_set(v.connector) && conn_set(a.connector))
            THEN format('Частота збігається, але роз''єми різні (VTX: %s, антена: %s): потрібен перехідник', v.connector, a.connector)
        ELSE format('Частота %s ГГц збігається', a.frequency_ghz)
    END
FROM vtx v CROSS JOIN antennas a;

-- ============ Ті самі перевірки для деталей однієї збірки ============
CREATE VIEW v_drone_checks AS
SELECT d.id AS drone_id, d.name AS drone, pc.rule, pc.status, pc.message,
       pc.a_id, ca.name AS part_a, pc.b_id, cb.name AS part_b
FROM drones d
JOIN drone_parts dpa  ON dpa.drone_id = d.id
JOIN drone_parts dpb  ON dpb.drone_id = d.id
JOIN v_pair_checks pc ON pc.a_id = dpa.component_id AND pc.b_id = dpb.component_id
JOIN components ca    ON ca.id = pc.a_id
JOIN components cb    ON cb.id = pc.b_id;

-- ============ Яких обовʼязкових деталей немає у збірці ============
CREATE VIEW v_drone_missing_parts AS
SELECT d.id AS drone_id, d.name AS drone, req.code AS missing_category
FROM drones d
CROSS JOIN (VALUES ('frame'), ('motor'), ('prop'), ('stack'), ('battery'), ('rx')) AS req(code)
WHERE NOT EXISTS (
    SELECT 1 FROM drone_parts dp
    JOIN components c   ON c.id = dp.component_id
    JOIN categories cat ON cat.id = c.category_id
    WHERE dp.drone_id = d.id AND cat.code = req.code
);

-- ============ Підсумок по збірці ============
CREATE VIEW v_drone_summary AS
SELECT d.id AS drone_id, d.name AS drone, u.code AS use_case,
       (SELECT count(*) FROM drone_parts dp WHERE dp.drone_id = d.id) AS parts,
       count(*) FILTER (WHERE ch.status = 'ok')      AS ok,
       count(*) FILTER (WHERE ch.status = 'warn')    AS warn,
       count(*) FILTER (WHERE ch.status = 'fail')    AS fail,
       count(*) FILTER (WHERE ch.status = 'unknown') AS unknown,
       (SELECT count(*) FROM v_drone_missing_parts mp WHERE mp.drone_id = d.id) AS missing,
       CASE
           WHEN count(*) FILTER (WHERE ch.status = 'fail') > 0
                OR (SELECT count(*) FROM v_drone_missing_parts mp WHERE mp.drone_id = d.id) > 0 THEN 'fail'
           WHEN count(*) FILTER (WHERE ch.status = 'warn') > 0 THEN 'warn'
           ELSE 'ok'
       END AS verdict
FROM drones d
LEFT JOIN use_cases u    ON u.id = d.use_case_id
LEFT JOIN v_drone_checks ch ON ch.drone_id = d.id
GROUP BY d.id, d.name, u.code;
