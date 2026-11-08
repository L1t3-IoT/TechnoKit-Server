-- Деталі з таблиці «Детали+дрони» (5 аркушів).
-- Однакові деталі, що повторювались у різних дронах, занесено один раз.
-- Ціни в гривнях (UAH). Ваги й ціни комплектів вказано за 1 штуку, де в таблиці було «4x…».
-- Порожні поля = у таблиці значення не вказано.

INSERT INTO manufacturers (name) VALUES
    ('Autel'),
    ('BlueBird'),
    ('BrotherHobby'),
    ('Caddx'),
    ('DJI'),
    ('DarwinFPV'),
    ('EMAX'),
    ('Flywoo'),
    ('Foxeer'),
    ('Fullsend'),
    ('GEPRC'),
    ('Gemfan'),
    ('HGLRC'),
    ('HQProp'),
    ('HappyModel'),
    ('Hee Wing'),
    ('Molicel'),
    ('Readytosky'),
    ('RunCam'),
    ('Rush'),
    ('SKIF'),
    ('Skystars'),
    ('Sonicmodell'),
    ('SpeedyBee'),
    ('Sunnysky'),
    ('Tattu'),
    ('iFlight')
ON CONFLICT (name) DO NOTHING;

-- ============ Рами, корпуси та планери (frames): 19 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-GEPRC-MARK4-7', 'GEPRC Mark4 7"',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'GEPRC'),
        121.0, 1200.0, 'UAH', 'Розмір: 7 дюймів, карбон 3K, промені 5 мм', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 7.0, NULL, 7.0, '30x30 / 20x20', 'Carbon fiber 3K', 5.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-GEPRC-GEP-MK5', 'GEPRC GEP-MK5',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'GEPRC'),
        130.0, 2100.0, 'UAH', 'Розмір: 5 дюймів, карбон 3K, промені 5 мм, база 225 мм', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 5.0, 225, 5.0, '30x30 / 20x20', 'Carbon fiber 3K', 5.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-IFLIGHT-EVOQUE-F5-V2-SQUASHED-X', 'iFlight Evoque F5 V2 (Squashed X)',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        150.0, 2900.0, 'UAH', 'Розмір: 5 дюймів, карбон 3K, промені 6 мм, бази 223 мм', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм, захисні бічні панелі"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 5.0, 223, 5.0, '30x30 / 20x20', 'Carbon fiber 3K', 6.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-FLYWOO-EXPLORER-LR-4-V2-FRAME-KIT', 'Flywoo Explorer LR 4 V2 Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        41.0, 1650.0, 'UAH', 'Розмір: 4 дюйми, карбон 3K, промені 1.5 мм, легкий каркас', '{"source_category": "Рама", "compatibility": "Монтаж 16x16 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 4.0, NULL, 4.0, '16x16 / 20x20', 'Carbon fiber 3K', 1.5, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-GEPRC-GEP-MK4-7', 'GEPRC GEP-MK4-7',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'GEPRC'),
        121.0, 1200.0, 'UAH', 'Розмір: 7 дюймів, карбон 3K, промені 5 мм, база 295 мм', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 7.0, 295, 7.0, '30x30 / 20x20', 'Carbon fiber 3K', 5.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-SPEEDYBEE-BEE35-FRAME-KIT', 'SpeedyBee Bee35 Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        138.0, 1950.0, 'UAH', 'Розмір: 3.5", карбон 3K + розширювані захисні дакти (ABS), база 153 мм', '{"source_category": "Рама з дактами (захистом)", "compatibility": "Монтаж 30x30 / 20x20 / 25.5x25.5 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 3.5, 153, 3.5, '30x30 / 20x20 / 25.5x25.5', 'Carbon fiber 3K', NULL, NULL, 'ducted' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-BLUEBIRD-ZHAKH-7-FRAME-KIT', 'BlueBird Zhakh 7" Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'BlueBird'),
        145.0, 1600.0, 'UAH', 'Розмір: 7", карбон 3K, промені 5.5 мм, підпружинений скид/кріплення', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 7.0, NULL, 7.0, '30x30 / 20x20', 'Carbon fiber 3K', 5.5, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-BLUEBIRD-ZHAKH-8-FRAME-KIT', 'BlueBird Zhakh 8" Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'BlueBird'),
        175.0, 1900.0, 'UAH', 'Розмір: 8", карбон 3K, посилені промені 6 мм, збільшена польотна палуба', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 8.0, NULL, 8.0, '30x30 / 20x20', 'Carbon fiber 3K', 6.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-IFLIGHT-CHIMERA7-PRO-V2-FRAME-KIT', 'iFlight Chimera7 Pro V2 Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        172.0, 3100.0, 'UAH', 'Розмір: 7.5", карбон 3K, промені 6 мм, база 327 мм, антивібраційне силіконове кріплення', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 7.5, 327, 7.5, '30x30 / 20x20', 'Carbon fiber 3K', 6.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-DARWINFPV-X9-FRAME-KIT', 'DarwinFPV X9 Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'DarwinFPV'),
        210.0, 2300.0, 'UAH', 'Розмір: 9", карбон 3K, посилені промені 6 мм, база 380 мм', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 9.0, 380, 9.0, '30x30 / 20x20', 'Carbon fiber 3K', 6.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-SKIF-10D-FRAME-KIT', 'SKIF-10D Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'SKIF'),
        260.0, 2800.0, 'UAH', 'Розмір: 10", карбон 3K, посилені промені 7 мм, база 450 мм', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 10.0, 450, 10.0, '30x30', 'Carbon fiber 3K', 7.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-BLUEBIRD-ZHAKH-10-FRAME-KIT', 'BlueBird Zhakh 10" Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'BlueBird'),
        275.0, 2950.0, 'UAH', 'Розмір: 10", карбон 3K, посилені промені 7 мм, розширена польотна палуба', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 10.0, NULL, 10.0, '30x30', 'Carbon fiber 3K', 7.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-SKIF-13D-FRAME-KIT', 'SKIF-13D Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'SKIF'),
        360.0, 3800.0, 'UAH', 'Розмір: 13", карбон 3K, посилені промені 8 мм, розширена база', '{"source_category": "Рама", "compatibility": "Монтаж 30x30 / 30.5x30.5 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 13.0, NULL, 13.0, '30x30 / 30.5x30.5', 'Carbon fiber 3K', 8.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-IFLIGHT-XL10-V6-FRAME-KIT', 'iFlight XL10 V6 Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        290.0, 3200.0, 'UAH', 'Розмір: 10", карбон 3K, промені 7-8 мм, геометрія True-X / Extended', '{"source_category": "Рама", "compatibility": "Монтаж 30.5x30.5 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 10.0, NULL, 10.0, '30.5x30.5 / 20x20', 'Carbon fiber 3K', 7.0, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-FLYWOO-CHIMERA10-LR-FRAME-KIT', 'Flywoo Chimera10 LR Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        285.0, 3400.0, 'UAH', 'Розмір: 10", карбон 3K, посилені промені 7.5 мм, подовжена верхня палуба', '{"source_category": "Рама", "compatibility": "Монтаж 30.5x30.5 / 20x20 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, 10.0, NULL, 10.0, '30.5x30.5 / 20x20', 'Carbon fiber 3K', 7.5, NULL, 'quad_frame' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-DJI-MAVIC-3-3E-3T-OEM-FRAME-SHELL-KIT', 'DJI Mavic 3 / 3E / 3T OEM Frame & Shell Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        260.0, 6500.0, 'UAH', 'Магнієво-алюмінієвий каркас, складна конструкція, складні промені', '{"source_category": "Корпус та промені", "compatibility": "Оригінальний корпус Mavic 3 Series", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, NULL, NULL, NULL, NULL, 'Magnesium-aluminium', NULL, NULL, 'shell' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-AUTEL-EVO-II-PRO-MAX-4T-HEAVY-FRAME-KIT', 'Autel EVO II Pro / Max 4T Heavy Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        410.0, 8900.0, 'UAH', 'Посилений карбоново-полімерний каркас, складні промені, захист IP43/IP55', '{"source_category": "Корпус та складні промені", "compatibility": "Серія Autel EVO II / Max", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, NULL, NULL, NULL, NULL, 'Carbon-polymer', NULL, NULL, 'shell' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-HEE-WING-T1-RANGER-PNP-KIT-FRAME-KIT', 'Hee Wing T1 Ranger PNP/KIT Frame Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'Hee Wing'),
        240.0, 4200.0, 'UAH', 'Розмах крил 730 мм, довжина 645 мм, матеріал EPP з вуглепластиковими підсиленнями', '{"source_category": "Планер (корпус та крила)", "compatibility": "Складана конструкція, відсіки 20x20 / 30.5x30.5 мм", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, NULL, NULL, NULL, '20x20 / 30.5x30.5', 'EPP + carbon', NULL, 730, 'airframe' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('FRAME-SONICMODELL-AR-WING-PRO-WHITE-BLACK-EPP-KIT', 'Sonicmodell AR Wing Pro White/Black EPP Kit',
        (SELECT id FROM categories WHERE code = 'frame'), (SELECT id FROM manufacturers WHERE name = 'Sonicmodell'),
        380.0, 4500.0, 'UAH', 'Розмах крил 1000 мм, довжина 450 мм, міцний EPP з вуглепластиковими лонжеронами', '{"source_category": "Планер (корпус та крила)", "compatibility": "Знімні крила, відсіки під FPV, FC (30.5x30.5 / 20x20) та HD-камеру", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO frames (component_id, size_in, wheelbase_mm, max_prop_in, stack_mount_mm, material, arm_thickness_mm, wingspan_mm, frame_type)
SELECT id, NULL, NULL, NULL, '30.5x30.5 / 20x20', 'EPP + carbon', NULL, 1000, 'airframe' FROM c;

-- ============ Мотори (motors): 18 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-EMAX-ECO-II-2807', 'EMAX ECO II 2807',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'EMAX'),
        48.0, 800.0, 'UAH', '1300KV (під 6S), розмір 2807, струм до 52A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 192.0, "set_size": 4, "price_set": 3200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2807', 1300, NULL, 52.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-GEPRC-SPEEDX2-2107-5', 'GEPRC SPEEDX2 2107.5',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'GEPRC'),
        37.0, 900.0, 'UAH', '1960KV (під 6S), розмір 2107.5, струм до 45A', '{"source_category": "Мотор", "compatibility": "6S LiPo, кріплення 16x16 мм", "weight_set_g": 148.0, "set_size": 4, "price_set": 3600.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2107.5', 1960, NULL, 45.0, '16x16', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-IFLIGHT-XING2-2207', 'iFlight XING2 2207',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        34.0, 1100.0, 'UAH', '1850KV (під 6S), розмір 2207, цельноточений ротор, вал титан', '{"source_category": "Мотор", "compatibility": "6S LiPo, кріплення 16x16 мм", "weight_set_g": 136.0, "set_size": 4, "price_set": 4400.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2207', 1850, NULL, NULL, '16x16', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-FLYWOO-NIN-V2-1404', 'Flywoo Nin V2 1404',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        15.6, 800.0, 'UAH', '2750KV (під 4S), розмір 1404, ультралегкі', '{"source_category": "Мотор", "compatibility": "4S LiPo / Li-Ion, кріплення 9x9 мм", "weight_set_g": 62.4, "set_size": 4, "price_set": 3200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '1404', 2750, NULL, NULL, '9x9', '4S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-EMAX-ECO-II-2004-SPEEDYBEE-2004', 'EMAX ECO II 2004 / SpeedyBee 2004',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'EMAX'),
        16.0, 800.0, 'UAH', '3000KV (під 4S/6S), розмір 2004, струм до 30A', '{"source_category": "Мотор", "compatibility": "4S–6S LiPo, кріплення 12x12 мм", "weight_set_g": 64.0, "set_size": 4, "price_set": 3200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2004', 3000, NULL, 30.0, '12x12', '4S–6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-EMAX-ECO-II-2807-FLASHHOBBY-2807', 'EMAX ECO II 2807 / FlashHobby 2807',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'EMAX'),
        48.0, 800.0, 'UAH', '1300KV (під 6S), розмір 2807, макс. струм 52A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 192.0, "set_size": 4, "price_set": 3200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2807', 1300, NULL, 52.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-EMAX-ECO-II-2809-EMAX-3110', 'EMAX ECO II 2809 / EMAX 3110',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'EMAX'),
        60.0, 950.0, 'UAH', '1300KV (або 900KV під 6S), розмір 2809/3110, макс. струм ~60A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 240.0, "set_size": 4, "price_set": 3800.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2809', 900, 1300, 60.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-IFLIGHT-XING2-2809', 'iFlight XING2 2809',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        60.0, 1300.0, 'UAH', '1250KV (під 6S), розмір 2809, цельноточений ротор, макс. струм 60A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 240.0, "set_size": 4, "price_set": 5200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2809', 1250, NULL, 60.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-DARWINFPV-EMAX-2812', 'DarwinFPV / EMAX 2812',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'DarwinFPV'),
        74.0, 1100.0, 'UAH', '1100KV (під 6S), розмір 2812, струм до 65A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 296.0, "set_size": 4, "price_set": 4400.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2812', 1100, NULL, 65.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-EMAX-ECO-II-3110-BROTHERHOBBY-3115', 'EMAX ECO II 3110 / BrotherHobby 3115',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'EMAX'),
        100.0, 1300.0, 'UAH', '900KV (під 6S), розмір 3110/3115, макс. струм до 75A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 400.0, "set_size": 4, "price_set": 5200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '3110', 900, NULL, 75.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-BROTHERHOBBY-AVENGER-3115-EMAX-3110', 'BrotherHobby Avenger 3115 / EMAX 3110',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'BrotherHobby'),
        110.0, 1450.0, 'UAH', '900KV (під 6S), розмір 3115, струм до 80A, сталевий вал', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 440.0, "set_size": 4, "price_set": 5800.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '3115', 900, NULL, 80.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-BROTHERHOBBY-T5-3115-XING2-3110', 'BrotherHobby T5 3115 / XING2 3110',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'BrotherHobby'),
        120.0, 1600.0, 'UAH', '700KV–900KV (під 6S–8S), розмір 3115, струм до 85A', '{"source_category": "Мотор", "compatibility": "6S–8S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 480.0, "set_size": 4, "price_set": 6400.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '3115', 700, 900, 85.0, '19x19', '6S–8S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-IFLIGHT-XING2-3110-BROTHERHOBBY-3115', 'iFlight XING2 3110 / BrotherHobby 3115',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        110.0, 1400.0, 'UAH', '900KV (під 6S), розмір 3110/3115, струм до 75A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 440.0, "set_size": 4, "price_set": 5600.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '3110', 900, NULL, 75.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-FLYWOO-NIN-V2-3110-BROTHERHOBBY-3115', 'Flywoo Nin V2 3110 / BrotherHobby 3115',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        109.0, 1400.0, 'UAH', '900KV (під 6S), розмір 3110/3115, макс. струм 75A', '{"source_category": "Мотор", "compatibility": "6S LiPo/Li-Ion, кріплення 19x19 мм", "weight_set_g": 436.0, "set_size": 4, "price_set": 5600.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '3110', 900, NULL, 75.0, '19x19', '6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-DJI-MAVIC-3-BRUSHLESS-MOTORS-2008-SIZE', 'DJI Mavic 3 Brushless Motors (2008 size)',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        28.0, 1300.0, 'UAH', 'Безколекторні мотори високої ефективності, KV ~1400', '{"source_category": "Мотори", "compatibility": "Живлення 4S, фіксація Quick-Release", "weight_set_g": 112.0, "set_size": 4, "price_set": 5200.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2008', 1400, NULL, NULL, NULL, '4S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-AUTEL-EVO-II-HIGH-TORQUE-BRUSHLESS-MOTORS', 'Autel EVO II High-Torque Brushless Motors',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        55.0, 1900.0, 'UAH', 'Високоефективні моторні вузли, підвищена стійкість до вітру (до 12 м/с)', '{"source_category": "Мотори", "compatibility": "Живлення 4S–6S, кріплення Quick-Release", "weight_set_g": 220.0, "set_size": 4, "price_set": 7600.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, NULL, NULL, NULL, NULL, NULL, '4S–6S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-FX-1404-BRUSHLESS-MOTORS-HEE-WING-FX-1404', 'FX-1404 Brushless Motors (Hee Wing FX-1404)',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'Hee Wing'),
        12.0, 800.0, 'UAH', '3700KV (під 4S) / 2900KV (під 4S–6S), розмір 1404, струм до 15A', '{"source_category": "Мотори", "compatibility": "4S LiPo / 4S Li-Ion, кріплення 9x9 мм", "weight_set_g": 24.0, "set_size": 2, "price_set": 1600.0}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '1404', 2900, 3700, 15.0, '9x9', '4S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('MOTOR-SUNNYSKY-X2814-BROTHERHOBBY-FX2808', 'Sunnysky X2814 / BrotherHobby FX2808',
        (SELECT id FROM categories WHERE code = 'motor'), (SELECT id FROM manufacturers WHERE name = 'Sunnysky'),
        108.0, 2100.0, 'UAH', '1100KV–1400KV (під 4S–6S), розмір 2814/2808, струм до 55A', '{"source_category": "Мотор", "compatibility": "4S–6S LiPo/Li-Ion, кріплення 19x19 / 25x25 мм"}'::jsonb)
    RETURNING id
)
INSERT INTO motors (component_id, stator_size, kv, kv_max, max_current_a, mount_mm, voltage_cells)
SELECT id, '2814', 1100, 1400, 55.0, '19x19 / 25x25', '4S–6S' FROM c;

-- ============ Гвинти (propellers): 17 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-7X3-5X3', 'HQProp 7x3.5x3',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        36.0, 250.0, 'UAH', '7 дюймів, 3 лопаті, крок 3.5', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 7.0, 3.5, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-ETHIX-S5', 'HQProp Ethix S5',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        17.0, 180.0, 'UAH', '5 дюймів, 3 лопаті, крок 4.0', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 5.0, 4.0, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-NAZGUL-F5-TRIMBLADE-HQ-IFLIGHT', 'Nazgul F5 Trimblade (HQ/iFlight)',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        18.0, 200.0, 'UAH', '5 дюймів, 3 лопаті, крок 4.3', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 5.0, 4.3, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-GEMFAN-4024-2-CLEAR-GRAY', 'Gemfan 4024-2 (Clear Gray)',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'Gemfan'),
        6.4, 160.0, 'UAH', '4 дюйми, 2 лопаті, крок 2.4 (для високої ефективності)', '{"source_category": "Пропелери", "compatibility": "Вал 1.5 мм (T-mount)", "sold_as": "комплект", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 4.0, 2.4, 2, 1.5 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-GEMFAN-D90-3-3-5-CINEWHOOP-PROPS', 'Gemfan D90-3 (3.5" CineWhoop Props)',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'Gemfan'),
        16.0, 190.0, 'UAH', '3.5 дюйми (90 мм), 3 лопаті, крок 3.0', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5) / T-mount", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 3.5, 3.0, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-7X3-5X3-GEMFAN-7040', 'HQProp 7x3.5x3 / Gemfan 7040',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        34.0, 240.0, 'UAH', '7 дюймів, 3 лопаті, крок 3.5', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 7.0, 3.5, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-8X4X3-GEMFAN-8046', 'HQProp 8x4x3 / Gemfan 8046',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        44.0, 290.0, 'UAH', '8 дюймів, 3 лопаті, крок 4.0', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 8.0, 4.0, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-7-5X3-7X3', 'HQProp 7.5x3.7x3',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        38.0, 270.0, 'UAH', '7.5 дюймів, 3 лопаті, крок 3.7', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 7.5, 3.7, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-GEMFAN-9045-3', 'Gemfan 9045-3',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'Gemfan'),
        52.0, 320.0, 'UAH', '9 дюймів, 3 лопаті, крок 4.5', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 9.0, 4.5, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-10X4-5X3-GEMFAN-1050', 'HQProp 10x4.5x3 / Gemfan 1050',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        72.0, 380.0, 'UAH', '10 дюймів, 3 лопаті, крок 4.5', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 10.0, 4.5, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-10X4-5X3-GEMFAN-1050-2', 'HQProp 10x4.5x3 / Gemfan 1050',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        72.0, 390.0, 'UAH', '10 дюймів, 3 лопаті, крок 4.5', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект", "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 10.0, 4.5, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-13X12X3-MASTER-AIRSCREW-13', 'HQProp 13x12x3 / Master Airscrew 13"',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        110.0, 580.0, 'UAH', '13 дюймів, 3 лопаті, крок 12.0', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 13.0, 12.0, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-10X4-5X3', 'HQProp 10x4.5x3',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        72.0, 390.0, 'UAH', '10 дюймів, 3 лопаті, крок 4.5', '{"source_category": "Пропелери", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 10.0, 4.5, 3, 5.0 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-DJI-6540F-LOW-NOISE-PROPELLERS', 'DJI 6540F Low-Noise Propellers',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        20.0, 850.0, 'UAH', 'Складні малошумні пропелери, 8.5 дюймів', '{"source_category": "Пропелери", "compatibility": "Кріплення Quick-Release (Mavic 3)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 8.5, NULL, NULL, NULL FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-AUTEL-QUICK-RELEASE-PROPELLERS-EVO-II-MAX', 'Autel Quick-Release Propellers (EVO II / Max)',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        32.0, 1100.0, 'UAH', 'Складні малошумні пропелери, посилений полімер', '{"source_category": "Пропелери", "compatibility": "Швидкознімне кріплення Autel", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, NULL, NULL, NULL, NULL FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-FX-3830PROPELLERS-3-8X3-0', 'FX 3830Propellers (3.8x3.0)',
        (SELECT id FROM categories WHERE code = 'prop'), NULL,
        4.0, 180.0, 'UAH', '3.8 дюйма, 2 лопаті (обертання CW + CCW)', '{"source_category": "Пропелери", "compatibility": "Вал 1.5 мм (T-mount)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 3.8, 3.0, 2, 1.5 FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('PROP-HQPROP-8X6-GEMFAN-8060', 'HQProp 8x6 / Gemfan 8060',
        (SELECT id FROM categories WHERE code = 'prop'), (SELECT id FROM manufacturers WHERE name = 'HQProp'),
        12.0, 160.0, 'UAH', '8 дюймів, 2 лопаті (штовхаючий гвинт, Pusher)', '{"source_category": "Пропелер", "compatibility": "Вал 5 мм (M5)", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO propellers (component_id, diameter_in, pitch_in, blades, hole_mm)
SELECT id, 8.0, 6.0, 2, 5.0 FROM c;

-- ============ Акумулятори (batteries): 19 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-MOLICEL-P42A-6S2P-6000MAH', 'Molicel P42A 6S2P 6000mAh',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        840.0, 3100.0, 'UAH', 'Напруга 22.2V (6S), 6000mAh, струм до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 6000, NULL, NULL, 90, 'Li-Ion', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-TATTU-R-LINE-6S-1300MAH-120C', 'Tattu R-Line 6S 1300mAh 120C',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Tattu'),
        225.0, 1700.0, 'UAH', 'Напруга 22.2V (6S), ємність 1300mAh, розряд 120C', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 1300, NULL, 120, NULL, 'LiPo', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-FULLSEND-6S-1300MAH-120C-LIPO', 'Fullsend 6S 1300mAh 120C LiPo',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Fullsend'),
        220.0, 1850.0, 'UAH', 'Напруга 22.2V (6S), ємність 1300mAh, розряд 120C', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 1300, NULL, 120, NULL, 'LiPo', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-FLYWOO-EXPLORER-4S-3000MAH-LI-ION-18650', 'Flywoo Explorer 4S 3000mAh Li-Ion (18650)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        198.0, 1650.0, 'UAH', 'Напруга 14.8V (4S), ємність 3000mAh, тривалість до 30 хв', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT30"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 4, NULL, 3000, NULL, NULL, NULL, 'Li-Ion', 'XT30' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S2P-LI-ION-6000MAH-MOLICEL-P42A', '6S2P Li-Ion 6000mAh (Molicel P42A)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        840.0, 3100.0, 'UAH', 'Напруга 22.2V (6S), ємність 6000mAh, розряд до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 6000, NULL, NULL, 90, 'Li-Ion', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-TATTU-R-LINE-4S-1300MAH-6S-1050MAH', 'Tattu R-Line 4S 1300mAh або 6S 1050mAh',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Tattu'),
        155.0, 1400.0, 'UAH', 'Напруга 14.8V (4S) або 22.2V (6S), 1300mAh, розряд 100C', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 4, 6, 1300, NULL, 100, NULL, 'LiPo', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S2P-LI-ION-8000MAH-MOLICEL-P42A-P45B', '6S2P Li-Ion 8000mAh (Molicel P42A/P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        890.0, 3400.0, 'UAH', 'Напруга 22.2V (6S), ємність 8000mAh, струм розряду до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 8000, NULL, NULL, 90, 'Li-Ion', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S2P-LI-ION-8400MAH-MOLICEL-P45B', '6S2P Li-Ion 8400mAh (Molicel P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        910.0, 3800.0, 'UAH', 'Напруга 22.2V (6S), ємність 8400mAh, високий розрядний струм до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60 / XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 8400, NULL, NULL, 90, 'Li-Ion', 'XT60 / XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-FULLSEND-6S2P-LI-ION-8000MAH-MOLICEL-P42A', 'Fullsend 6S2P Li-Ion 8000mAh (Molicel P42A)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Fullsend'),
        890.0, 3700.0, 'UAH', 'Напруга 22.2V (6S), ємність 8000mAh, розряд до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60 / XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 8000, NULL, NULL, 90, 'Li-Ion', 'XT60 / XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S2P-LI-ION-8400MAH-10500MAH-MOLICEL-P45B-P42A', '6S2P Li-Ion 8400mAh–10500mAh (Molicel P45B/P42A)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        980.0, 4200.0, 'UAH', 'Напруга 22.2V (6S), ємність 8400–10500mAh, розряд до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 8400, 10500, NULL, 90, 'Li-Ion', 'XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S3P-LI-ION-12600MAH-MOLICEL-P42A-P45B', '6S3P Li-Ion 12600mAh (Molicel P42A/P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        1420.0, 5400.0, 'UAH', 'Напруга 22.2V (6S), ємність 12600mAh, розряд до 120A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 12600, NULL, NULL, 120, 'Li-Ion', 'XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S3P-LI-ION-12600MAH-15000MAH-MOLICEL-P45B', '6S3P Li-Ion 12600mAh–15000mAh (Molicel P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        1480.0, 5900.0, 'UAH', 'Напруга 22.2V (6S), ємність 12600–15000mAh, розряд до 135A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 12600, 15000, NULL, 135, 'Li-Ion', 'XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S4P-8S3P-LI-ION-16800MAH-20000MAH', '6S4P / 8S3P Li-Ion 16800mAh–20000mAh',
        (SELECT id FROM categories WHERE code = 'battery'), NULL,
        1950.0, 7800.0, 'UAH', 'Напруга 22.2V–29.6V (6S–8S), ємність до 20000mAh, розряд 140A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT90 / AS150"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, 8, 16800, 20000, NULL, 140, 'Li-Ion', 'XT90 / AS150' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S3P-LI-ION-12600MAH-MOLICEL-P45B', '6S3P Li-Ion 12600mAh (Molicel P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        1450.0, 5800.0, 'UAH', 'Напруга 22.2V (6S), ємність 12600mAh, розряд до 135A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 12600, NULL, NULL, 135, 'Li-Ion', 'XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-6S4P-LI-ION-16800MAH-MOLICEL-P45B', '6S4P Li-Ion 16800mAh (Molicel P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        1920.0, 7400.0, 'UAH', 'Напруга 22.2V (6S), ємність 16800mAh, розряд до 180A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 6, NULL, 16800, NULL, NULL, 180, 'Li-Ion', 'XT90' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-DJI-INTELLIGENT-FLIGHT-BATTERY-BWX260-5000-15-4', 'DJI Intelligent Flight Battery (BWX260-5000-15.4)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        335.0, 7200.0, 'UAH', '4S LiPo 15.4V, 5000 mAh (77 Wh), інтелектуальний BMS контролер', '{"source_category": "Акумулятор", "compatibility": "Оригінальний відсік Mavic 3"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 4, NULL, 5000, NULL, NULL, NULL, 'LiPo', NULL FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-AUTEL-EVO-II-MAX-SMART-BATTERY-7100-MAH-8071-MAH', 'Autel EVO II / Max Smart Battery (7100 mAh / 8071 mAh)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        590.0, 10500.0, 'UAH', 'LiPo 4S (14.8V) / 6S, ємність 7100–8071 mAh, самообігрів для морозів', '{"source_category": "Акумулятор", "compatibility": "Засувний відсік Autel Smart Battery"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 4, 6, 7100, 8071, NULL, NULL, 'LiPo', NULL FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-4S2P-LI-ION-6000MAH-7000MAH-MOLICEL-P35B-18650', '4S2P Li-Ion 6000mAh–7000mAh (Molicel P35B / 18650)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        390.0, 2800.0, 'UAH', 'Напруга 14.8V (4S), ємність 6000–7000mAh, розряд до 60A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 4, NULL, 6000, 7000, NULL, 60, 'Li-Ion', 'XT60' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('BATTERY-4S3P-6S2P-LI-ION-10500MAH-12600MAH-MOLICEL-P45B', '4S3P / 6S2P Li-Ion 10500mAh–12600mAh (Molicel P45B)',
        (SELECT id FROM categories WHERE code = 'battery'), (SELECT id FROM manufacturers WHERE name = 'Molicel'),
        680.0, 4900.0, 'UAH', 'Напруга 14.8V–22.2V (4S–6S), ємність 10500–12600mAh, розряд до 90A', '{"source_category": "Акумулятор", "compatibility": "Роз''єм XT60 / XT90"}'::jsonb)
    RETURNING id
)
INSERT INTO batteries (component_id, cells_s, cells_s_max, capacity_mah, capacity_mah_max, c_rating, max_discharge_a, chemistry, connector)
SELECT id, 4, 6, 10500, 12600, NULL, 90, 'Li-Ion', 'XT60 / XT90' FROM c;

-- ============ Стеки FC + ESC (stacks): 15 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SPEEDYBEE-F405-V4-55A', 'SpeedyBee F405 V4 55A',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        30.5, 3800.0, 'UAH', 'MCU: F405, струм ESC: 55A Continuous (пік 70A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_S", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F405', 55, NULL, 70, '30x30', 'Betaflight / INAV', 'BLHeli_S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-IFLIGHT-BLITZ-F7-V1-1-STACK-F7-FC-55A-ESC', 'iFlight BLITZ F7 V1.1 Stack (F7 FC + 55A ESC)',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        32.0, 4900.0, 'UAH', 'MCU: F722, струм ESC: 55A Continuous (пік 65A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_32 / Telemetry"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F722', 55, NULL, 65, '30x30', 'Betaflight / INAV', 'BLHeli_32 / Telemetry' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-FLYWOO-GOKU-GN405-NANO-13A-STACK', 'Flywoo GOKU GN405 Nano 13A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        8.2, 3600.0, 'UAH', 'MCU: F405, струм ESC: 13A Continuous (пік 15A), 16x16 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_S", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F405', 13, NULL, 15, '16x16', 'Betaflight / INAV', 'BLHeli_S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SPEEDYBEE-F405-MINI-35A-STACK', 'SpeedyBee F405 Mini 35A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        13.5, 3200.0, 'UAH', 'MCU: F405, струм ESC: 35A Continuous (пік 45A), 20x20 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_S, Bluetooth налаштування", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F405', 35, NULL, 45, '20x20', 'Betaflight / INAV', 'BLHeli_S, Bluetooth налаштування' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SPEEDYBEE-F405-V4-55A-STACK', 'SpeedyBee F405 V4 55A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        30.5, 3800.0, 'UAH', 'MCU: F405, струм ESC: 55A Continuous (пік 70A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_S", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F405', 55, NULL, 70, '30x30', 'Betaflight / INAV', 'BLHeli_S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SPEEDYBEE-F405-V4-55A-STACK-F7-65A', 'SpeedyBee F405 V4 55A Stack (або F7 65A)',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        32.0, 4200.0, 'UAH', 'MCU: F405/F7, струм ESC: 55A–65A Continuous (пік 75A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_S / BLHeli_32"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F405/F7', 55, 65, 75, '30x30', 'Betaflight / INAV', 'BLHeli_S / BLHeli_32' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SPEEDYBEE-F405-V3-V4-60A-STACK-F7-65A', 'SpeedyBee F405 V3/V4 60A Stack (або F7 65A)',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        34.0, 4500.0, 'UAH', 'MCU: F405/F7, струм ESC: 60A–65A Continuous (пік 80A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_32 / BLHeli_S"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F405/F7', 60, 65, 80, '30x30', 'Betaflight / INAV', 'BLHeli_32 / BLHeli_S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SKYSTARS-SPEEDYBEE-F722-65A-STACK', 'Skystars / SpeedyBee F722 65A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'Skystars'),
        35.0, 4800.0, 'UAH', 'MCU: F722, струм ESC: 65A Continuous (пік 80A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_32 / BLHeli_S"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F722', 65, NULL, 80, '30x30', 'Betaflight / INAV', 'BLHeli_32 / BLHeli_S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-SKYSTARS-SPEEDYBEE-F722-PRO-65A-80A-STACK', 'Skystars / SpeedyBee F722 Pro 65A/80A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'Skystars'),
        38.0, 5400.0, 'UAH', 'MCU: F722, струм ESC: 65A–80A Continuous (пік 100A), 30x30 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_32"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F722', 65, 80, 100, '30x30', 'Betaflight / INAV', 'BLHeli_32' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-IFLIGHT-BLITZ-F7-PRO-65A-STACK', 'iFlight BLITZ F7 Pro 65A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        36.0, 5100.0, 'UAH', 'MCU: F722, струм ESC: 65A Continuous (пік 75A), 30.5x30.5 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_32"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F722', 65, NULL, 75, '30.5x30.5', 'Betaflight / INAV', 'BLHeli_32' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-FLYWOO-GOKU-F722-PRO-65A-STACK', 'Flywoo GOKU F722 PRO 65A Stack',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        35.0, 5200.0, 'UAH', 'MCU: F722, струм ESC: 65A Continuous (пік 75A), 30.5x30.5 мм', '{"source_category": "Стек (FC + ESC)", "compatibility": "Betaflight / INAV, BLHeli_32"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'stack', 'F722', 65, NULL, 75, '30.5x30.5', 'Betaflight / INAV', 'BLHeli_32' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-DJI-MAVIC-3-MAINBOARD-ESC-ALL-IN-ONE-CONTROLLER', 'DJI Mavic 3 Mainboard + ESC All-in-One Controller',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        95.0, 18500.0, 'UAH', 'Процесор обробки відео/AI, ESC 4-в-1, модулі датчиків запобігання зіткненням', '{"source_category": "Материнська плата та регулятори", "compatibility": "Вбудоване ПЗ DJI, O3+ / O3 Enterprise"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'mainboard', NULL, NULL, NULL, NULL, NULL, 'Вбудоване ПЗ DJI', 'O3+ / O3 Enterprise' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-AUTEL-MAINBOARD-DUAL-ECU-ANTI-JAMMING-ESC-BOARD', 'Autel Mainboard + Dual ECU / Anti-Jamming ESC Board',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        125.0, 24500.0, 'UAH', 'Процесор обробки штучного інтелекту Engine 4.0, завадозахищені ESC 4-в-1', '{"source_category": "Материнська плата та ESC", "compatibility": "Вбудоване ПЗ Autel, A-Mesh Networking"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'mainboard', NULL, NULL, NULL, NULL, NULL, 'Вбудоване ПЗ Autel', 'A-Mesh Networking' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-FX-25A-ESC-TWIN-PACK-MATEK-F405-WING-SPEEDYBEE-F405-WING-FC', 'FX-25A ESC Twin Pack + Matek F405-WING / SpeedyBee F405 WING FC',
        (SELECT id FROM categories WHERE code = 'stack'), NULL,
        38.0, 3900.0, 'UAH', 'ESC: 2x 25A Continuous (пік 35A); FC: MCU F405, вбудований PDB, BEC 5V/9V/Vx', '{"source_category": "Регулятори та польотний контролер", "compatibility": "INAV / ArduPilot, BLHeli_S", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'wing_fc_esc', 'F405', 25, NULL, 35, NULL, 'INAV / ArduPilot', 'BLHeli_S' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('STACK-FLYWOO-GOKU-F405-WING-MATEK-F405-WING-FLYWOO-50A-60A-ESC', 'Flywoo GOKU F405-WING / Matek F405-WING + Flywoo 50A/60A ESC',
        (SELECT id FROM categories WHERE code = 'stack'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        42.0, 4200.0, 'UAH', 'ESC: 50A–60A Continuous (пік 70A); FC: MCU F405, вбудований PDB, потужні BEC 5V/9V/Vx', '{"source_category": "Регулятор та польотний контролер", "compatibility": "INAV / ArduPilot / Betaflight, BLHeli_32 / BLHeli_S", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO stacks (component_id, variant, mcu, esc_current_a, esc_current_a_max, esc_peak_a, mount_mm, firmware, esc_firmware)
SELECT id, 'wing_fc_esc', 'F405', 50, 60, 70, NULL, 'INAV / ArduPilot / Betaflight', 'BLHeli_32 / BLHeli_S' FROM c;

-- ============ Камери (cameras): 12 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-CADDX-RATEL-2', 'Caddx Ratel 2',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Caddx'),
        8.5, 1450.0, 'UAH', '1200TVL, 1.66mm lens, Starlight Day/Night', '{"source_category": "FPV-камера", "compatibility": "Analog, Micro (19x19 мм)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1200, 1.66, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-CADDX-RATEL-2-DJI-O3-AIR-UNIT', 'Caddx Ratel 2 (або DJI O3 Air Unit)',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Caddx'),
        8.5, 1500.0, 'UAH', 'Analog 1200TVL, 1.66mm Starlight (або 4K/60fps Digital)', '{"source_category": "FPV-камера / Цифровий юніт", "compatibility": "Analog Micro / DJI Digital Protocol", "weight_note": "Digital ~36g", "price_note": "Digital ~9800"}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'digital_unit', 'Analog / Digital', 1200, 1.66, 'Micro', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-FLYWOO-FLYLENS-CAM-CADDX-ANT-BABY-RATEL-2', 'Flywoo FlyLens Cam (Caddx Ant / Baby Ratel 2)',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        2.0, 950.0, 'UAH', '1200TVL, 1.8mm lens, Nano формат (14x14 мм)', '{"source_category": "FPV-камера", "compatibility": "Analog Nano"}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1200, 1.8, 'Nano 14x14', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-CADDX-RATEL-2-MICRO', 'Caddx Ratel 2 Micro',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Caddx'),
        8.5, 1450.0, 'UAH', '1200TVL, 1.66mm lens, Starlight Day/Night', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1200, 1.66, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-CADDX-RATEL-2-FOXEER-CAT-3', 'Caddx Ratel 2 / Foxeer Cat 3',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Caddx'),
        8.5, 1450.0, 'UAH', '1200TVL, 1.66mm lens, Starlight (для низького освітлення)', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1200, 1.66, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-RUNCAM-PHOENIX-2-SE-CADDX-RATEL-2', 'RunCam Phoenix 2 SE / Caddx Ratel 2',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'RunCam'),
        9.0, 1400.0, 'UAH', '1000TVL, 1/2" Starlight sensor, f/2.0 lens', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)"}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1000, NULL, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-RUNCAM-PHOENIX-2-SE-CADDX-RATEL-2-2', 'RunCam Phoenix 2 SE / Caddx Ratel 2',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'RunCam'),
        9.0, 1450.0, 'UAH', '1000TVL, 1/2" Starlight sensor, f/2.0 lens', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)", "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1000, NULL, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-RUNCAM-PHOENIX-2-SE-FOXEER-CAT-3', 'RunCam Phoenix 2 SE / Foxeer Cat 3',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'RunCam'),
        9.5, 1500.0, 'UAH', '1000TVL, 1/2" Starlight sensor (для сутінок), f/2.0 lens', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1000, NULL, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-DJI-MAVIC-3T-THERMAL-ZOOM-3-AXIS-GIMBAL-CAMERA', 'DJI Mavic 3T Thermal & Zoom 3-Axis Gimbal Camera',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        135.0, 85000.0, 'UAH', '4/3 CMOS (3E) / Thermal 640x512 30Hz + 56x Zoom (3T), 3-осьовий гіростабілізатор', '{"source_category": "Камера та підвіс", "compatibility": "Внутрішній шлейф DJI Coaxial"}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'gimbal', 'Digital', NULL, NULL, NULL, true, true FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-AUTEL-MAX-4T-GIMBAL-THERMAL-8K-10X-OPTICAL-ZOOM-LASER', 'Autel Max 4T Gimbal (Thermal + 8K + 10x Optical Zoom + Laser)',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        320.0, 145000.0, 'UAH', 'Тепловізор 640x512, 8K зум-камера, оптичний зум 10x (цифровий 160x), лазерний дальномір 1.2 км', '{"source_category": "Камера та оптичний підвіс", "compatibility": "Багатопіновий коаксіальний інтерфейс Autel"}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'gimbal', 'Digital', NULL, NULL, NULL, true, true FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-CADDX-RATEL-2-MICRO-RUNCAM-PHOENIX-2', 'Caddx Ratel 2 Micro / RunCam Phoenix 2',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Caddx'),
        8.5, 1450.0, 'UAH', '1200TVL, 1.66mm Starlight lens (день/ніч)', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1200, 1.66, 'Micro 19x19', false, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('CAMERA-CADDX-RATEL-2-MICRO-RUNCAM-PHOENIX-2-SE', 'Caddx Ratel 2 Micro / RunCam Phoenix 2 SE',
        (SELECT id FROM categories WHERE code = 'camera'), (SELECT id FROM manufacturers WHERE name = 'Caddx'),
        8.5, 1450.0, 'UAH', '1200TVL, 1.66mm Starlight lens (день/ніч)', '{"source_category": "FPV-камера", "compatibility": "Analog Micro (19x19 мм)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO cameras (component_id, camera_type, signal, resolution_tvl, lens_mm, form_factor, has_thermal, has_gimbal)
SELECT id, 'analog', 'Analog', 1200, 1.66, 'Micro 19x19', false, false FROM c;

-- ============ Відеопередавачі (vtx): 17 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-RUSH-TANK-SOLO-5-8G', 'Rush Tank Solo 5.8G',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Rush'),
        28.5, 2100.0, 'UAH', 'Потужність: 25–1600 mW, 48CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / IRC Tramp, MMCX", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, 25, '5.8', '48', 'SmartAudio / IRC Tramp', 'MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-IFLIGHT-BLITZ-ULTIMATE-VTX-1-6W', 'iFlight BLITZ Ultimate VTX 1.6W',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        18.5, 2300.0, 'UAH', 'Потужність: 25–1600 mW, 40CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "IRC Tramp / SmartAudio, MMCX", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, 25, '5.8', '40', 'IRC Tramp / SmartAudio', 'MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-FLYWOO-GOKU-HM600-VTX', 'Flywoo GOKU HM600 VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        4.0, 1250.0, 'UAH', 'Потужність: 25–600 mW, 48CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "IRC Tramp, U.FL (IPEX)"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 600, 25, '5.8', '48', 'IRC Tramp', 'U.FL (IPEX)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-SPEEDYBEE-TX800-VTX', 'SpeedyBee TX800 VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'SpeedyBee'),
        5.6, 1100.0, 'UAH', 'Потужність: 25–800 mW, 48CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "IRC Tramp, роз''єм MMCX", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 800, 25, '5.8', '48', 'IRC Tramp', 'MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-RUSH-TANK-SOLO-READYTOSKY-1-6W-VTX', 'Rush Tank Solo / Readytosky 1.6W VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Rush'),
        28.5, 2100.0, 'UAH', 'Потужність: 25–1600 mW, 48CH, частота 5.8 GHz (або 1.2 GHz)', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX/SMA", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, 25, '1.2 / 5.8', '48', 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-RUSH-TANK-SOLO-1-6W-READYTOSKY-2-5W', 'Rush Tank Solo 1.6W / Readytosky 2.5W',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Rush'),
        32.0, 2400.0, 'UAH', 'Потужність: 25mW–2500mW (2.5W), 48CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX / SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 2500, 25, '5.8', '48', 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-IFLIGHT-BLITZ-1-6W-VTX', 'iFlight BLITZ 1.6W VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        18.5, 2300.0, 'UAH', 'Потужність: 25–1600 mW, 40CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "IRC Tramp / SmartAudio, MMCX", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, 25, '5.8', '40', 'IRC Tramp / SmartAudio', 'MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-DARWINFPV-CEMENT-1-6W-RUSH-TANK-SOLO-5-8G', 'DarwinFPV Cement 1.6W / Rush Tank Solo 5.8G',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'DarwinFPV'),
        29.0, 2200.0, 'UAH', 'Потужність: 25–1600 mW, 48CH, частота 5.8 GHz (або 1.2 GHz)', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, 25, '1.2 / 5.8', '48', 'SmartAudio / Tramp', 'MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-READYTOSKY-5-8G-2-5W-RUSH-TANK-SOLO', 'Readytosky 5.8G 2.5W / Rush Tank Solo',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Readytosky'),
        32.0, 2400.0, 'UAH', 'Потужність: 25mW–2500mW (2.5W), 48CH, частота 5.8 GHz (або 1.2 GHz)', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX / SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 2500, 25, '1.2 / 5.8', '48', 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-READYTOSKY-5-8G-2-5W-VTX-1-2GHZ-1-5W', 'Readytosky 5.8G 2.5W VTX (або 1.2GHz 1.5W)',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Readytosky'),
        34.0, 2500.0, 'UAH', 'Потужність: 25mW–2500mW (2.5W), 48CH, частота 5.8 GHz / 1.2 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX / SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 2500, 25, '1.2 / 5.8', '48', 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-READYTOSKY-1-2GHZ-1-5W-5-8G-2-5W-VTX', 'Readytosky 1.2GHz 1.5W / 5.8G 2.5W VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Readytosky'),
        38.0, 2800.0, 'UAH', 'Потужність: 1.5W–2.5W, частота 1.2 GHz або 5.8 GHz, 9CH/48CH', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, SMA / MMCX"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 2500, 1500, '1.2 / 5.8', '9/48', 'SmartAudio / Tramp', 'SMA / MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-READYTOSKY-5-8G-2-5W-RUSH-TANK-SOLO-VTX', 'Readytosky 5.8G 2.5W / Rush Tank Solo VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Readytosky'),
        32.0, 2400.0, 'UAH', 'Потужність: 25mW–2500mW (2.5W), 48CH, частота 5.8 GHz', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX / SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 2500, 25, '5.8', '48', 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-FLYWOO-GOKU-1-2G-1-5W-5-8G-2-5W-VTX', 'Flywoo GOKU 1.2G 1.5W / 5.8G 2.5W VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        34.0, 2600.0, 'UAH', 'Потужність: 1.5W–2.5W, частота 1.2 GHz або 5.8 GHz, з радіатором', '{"source_category": "Відеопередавач (VTX)", "compatibility": "IRC Tramp / SmartAudio, SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 2500, 1500, '1.2 / 5.8', NULL, 'IRC Tramp / SmartAudio', 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-DJI-O3-O3-ENTERPRISE-DIGITAL-TRANSCEIVER', 'DJI O3+ / O3 Enterprise Digital Transceiver',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        25.0, 9800.0, 'UAH', 'Передача 1080p/60fps до 15 км, шифрування AES-256, частоти 2.4 / 5.8 GHz', '{"source_category": "Цифровий відеопередавач (VTX)", "compatibility": "Протокол DJI O3 Enterprise (OcuSync 3+)"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'digital', NULL, NULL, '2.4 / 5.8', NULL, 'DJI O3 Enterprise (OcuSync 3+)', NULL FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-AUTEL-SKYLINK-3-0-A-MESH-ANTI-JAMMING-VTX', 'Autel SkyLink 3.0 / A-Mesh Anti-Jamming VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        45.0, 14200.0, 'UAH', 'Робота в умовах РЕБ, псевдовипадкове перескокування частот (FHSS), 2.4/5.2/5.8 GHz, до 20 км', '{"source_category": "Завадозахищений відеопередавач (VTX)", "compatibility": "Протокол SkyLink 3.0"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'anti_jam', NULL, NULL, '2.4 / 5.2 / 5.8', NULL, 'SkyLink 3.0', NULL FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-RUSH-TANK-SOLO-5-8G-1-6W-READYTOSKY-1-2G-VTX', 'Rush Tank Solo 5.8G 1.6W / Readytosky 1.2G VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Rush'),
        29.0, 2300.0, 'UAH', 'Потужність: 1.6W (5.8 GHz) або 1.5W (1.2 GHz), з алюмінієвим радіатором', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX / SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, NULL, '1.2 / 5.8', NULL, 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('VTX-RUSH-TANK-SOLO-5-8G-1-6W-READYTOSKY-1-2G-1-5W-VTX', 'Rush Tank Solo 5.8G 1.6W / Readytosky 1.2G 1.5W VTX',
        (SELECT id FROM categories WHERE code = 'vtx'), (SELECT id FROM manufacturers WHERE name = 'Rush'),
        29.0, 2300.0, 'UAH', 'Потужність: 1.6W (5.8 GHz) або 1.5W (1.2 GHz), алюмінієвий радіатор', '{"source_category": "Відеопередавач (VTX)", "compatibility": "SmartAudio / Tramp, MMCX / SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO vtx (component_id, link_type, power_max_mw, power_min_mw, frequency_ghz, channels, protocol, connector)
SELECT id, 'analog', 1600, NULL, '1.2 / 5.8', NULL, 'SmartAudio / Tramp', 'MMCX / SMA' FROM c;

-- ============ Антени (antennas): 16 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-LOLLIPOP-4-STUBBY', 'Foxeer Lollipop 4 Stubby',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        10.0, 450.0, 'UAH', 'Частота 5.8 GHz, RHCP, посилення 2.6dBi', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA / MMCX"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', 2.6, NULL, 'SMA / MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-IFLIGHT-ALBATROSS-5-8GHZ-ANTENNA', 'iFlight Albatross 5.8GHz Antenna',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        12.0, 550.0, 'UAH', 'Довжина 90мм, RHCP, 5.8 GHz, посилення 3dBi', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA / MMCX"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', 3.0, 90, 'SMA / MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FLYWOO-ATOMIC-5-8GHZ-ANTENNA', 'Flywoo Atomic 5.8GHz Antenna',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        2.2, 380.0, 'UAH', 'Довжина 75мм, RHCP, 5.8 GHz, ультралегка', '{"source_category": "Антена VTX", "compatibility": "Роз''єм U.FL (IPEX)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', NULL, 75, 'U.FL (IPEX)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-LOLLIPOP-4-MICRO', 'Foxeer Lollipop 4 Micro',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        4.8, 400.0, 'UAH', 'Частота 5.8 GHz, RHCP, посилення 2.6dBi, компактна', '{"source_category": "Антена VTX", "compatibility": "Роз''єм MMCX / U.FL", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', 2.6, NULL, 'MMCX / U.FL' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-1-2GHZ-ANTENNA', 'Foxeer Pageant 5.8GHz / 1.2GHz Antenna',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        14.0, 480.0, 'UAH', 'Посилення 2.5dBi, RHCP, подовжена ніжка', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '1.2 / 5.8', 'RHCP', 2.5, NULL, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-HIGH-GAIN', 'Foxeer Pageant 5.8GHz High-Gain',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        16.0, 520.0, 'UAH', 'RHCP, посилення 3dBi, подовжена ніжка (150 мм)', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', 3.0, 150, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-IFLIGHT-ALBATROSS-5-8GHZ-150MM-ANTENNA', 'iFlight Albatross 5.8GHz 150mm Antenna',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        14.0, 600.0, 'UAH', 'Довжина 150мм, RHCP, 5.8 GHz, посилення 3dBi', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA / MMCX"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', 3.0, 150, 'SMA / MMCX' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-1-2GHZ-HIGH-GAIN', 'Foxeer Pageant 5.8GHz / 1.2GHz High-Gain',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        16.0, 550.0, 'UAH', 'Посилення 3dBi, RHCP, подовжена ніжка 150 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '1.2 / 5.8', 'RHCP', 3.0, 150, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-1-2GHZ-HIGH-GAIN-2', 'Foxeer Pageant 5.8GHz / 1.2GHz High-Gain',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        18.0, 580.0, 'UAH', 'Посилення 3dBi, RHCP, подовжена ніжка 170 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA", "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '1.2 / 5.8', 'RHCP', 3.0, 170, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-HIGH-GAIN-ANTENNA', 'Foxeer Pageant High-Gain Antenna',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        18.0, 580.0, 'UAH', 'Посилення 3dBi, RHCP, подовжена гнучка ніжка 170 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, NULL, 'RHCP', 3.0, 170, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-1-2GHZ-5-8GHZ-HIGH-GAIN', 'Foxeer Pageant 1.2GHz / 5.8GHz High-Gain',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        22.0, 650.0, 'UAH', 'Посилення 3dBi, RHCP, подовжена ніжка 200 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '1.2 / 5.8', 'RHCP', 3.0, 200, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-HIGH-GAIN-2', 'Foxeer Pageant 5.8GHz High-Gain',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        18.0, 580.0, 'UAH', 'Посилення 3dBi, RHCP, подовжена ніжка 170 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA", "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '5.8', 'RHCP', 3.0, 170, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-1-2GHZ-5-8GHZ-HIGH-GAIN-2', 'Foxeer Pageant 1.2GHz / 5.8GHz High-Gain',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        20.0, 620.0, 'UAH', 'Посилення 3.5dBi, RHCP, подовжена ніжка 180 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA", "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '1.2 / 5.8', 'RHCP', 3.5, 180, 'SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-DJI-INTERNAL-MULTI-BAND-ANTENNA-ARRAY', 'DJI Internal Multi-band Antenna Array',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        18.0, 1400.0, 'UAH', 'Вбудовані дубльовані антени в ногах/палубі, 2.4/5.8 GHz', '{"source_category": "Антени VTX / RX", "compatibility": "Внутрішні U.FL / Coax", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, '2.4 / 5.8', NULL, NULL, NULL, 'U.FL / Coax' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-INTERNAL-MULTI-BAND-HIGH-GAIN-ANTENNA-SYSTEM', 'Internal Multi-Band High-Gain Antenna System',
        (SELECT id FROM categories WHERE code = 'antenna'), NULL,
        28.0, 2100.0, 'UAH', 'Дуополярні антени з підвищеним посиленням, стійкість до придушення', '{"source_category": "Антени VTX / RX", "compatibility": "Внутрішні U.FL / SMA", "sold_as": "комплект"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, NULL, 'dual', NULL, NULL, 'U.FL / SMA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('ANTENNA-FOXEER-PAGEANT-CHERRY-HIGH-GAIN-ANTENNA', 'Foxeer Pageant / Cherry High-Gain Antenna',
        (SELECT id FROM categories WHERE code = 'antenna'), (SELECT id FROM manufacturers WHERE name = 'Foxeer'),
        14.0, 520.0, 'UAH', 'Посилення 3dBi, RHCP, подовжена ніжка 150 мм', '{"source_category": "Антена VTX", "compatibility": "Роз''єм SMA"}'::jsonb)
    RETURNING id
)
INSERT INTO antennas (component_id, frequency_ghz, polarization, gain_dbi, length_mm, connector)
SELECT id, NULL, 'RHCP', 3.0, 150, 'SMA' FROM c;

-- ============ Приймачі керування (receivers): 14 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-ES900RX', 'HappyModel ES900RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        0.6, 750.0, 'UAH', 'Частота: 868/915 MHz, поновлення до 200Hz, T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', 200, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-EXPRESSLRS-EP1', 'HappyModel ExpressLRS EP1',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        0.6, 650.0, 'UAH', 'Частота: 2.4 GHz, оновлення до 500Hz', '{"source_category": "Приймач керування", "compatibility": "CRSF / ELRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '2.4 GHz', 'CRSF / ELRS (UART)', 500, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-IFLIGHT-ELRS-915MHZ-2-4GHZ-RX', 'iFlight ELRS 915MHz / 2.4GHz RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        0.8, 800.0, 'UAH', 'Частота: 868/915 MHz або 2.4 GHz, T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz; 2.4 GHz', 'CRSF / ExpressLRS (UART)', NULL, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-FLYWOO-ELRS-2-4GHZ-915MHZ-NANO-RX', 'Flywoo ELRS 2.4GHz / 915MHz Nano RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        0.8, 750.0, 'UAH', 'Частота: 2.4 GHz або 868/915 MHz, SMD/T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '2.4 GHz; 868/915 MHz', 'CRSF / ExpressLRS (UART)', NULL, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-EXPRESSLRS-EP1-RX', 'HappyModel ExpressLRS EP1 RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        0.6, 650.0, 'UAH', 'Частота: 2.4 GHz, оновлення до 500Hz, дипольна антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '2.4 GHz', 'CRSF / ExpressLRS (UART)', 500, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX', 'HappyModel ES900RX / TBS Crossfire Nano RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        0.8, 800.0, 'UAH', 'Частота: 868/915 MHz, дипольна T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', NULL, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-ES900RX-EMAX-AERIS-915MHZ', 'HappyModel ES900RX / EMAX Aeris 915MHz',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        1.2, 850.0, 'UAH', 'Частота: 868/915 MHz, поновлення до 200Hz, дипольна T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', 200, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-IFLIGHT-EXPRESSLRS-915MHZ-2-4GHZ-RX', 'iFlight ExpressLRS 915MHz / 2.4GHz RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        0.9, 850.0, 'UAH', 'Частота: 868/915 MHz або 2.4 GHz, подовжена T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz; 2.4 GHz', 'CRSF / ExpressLRS (UART)', NULL, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX-2', 'HappyModel ES900RX / TBS Crossfire Nano RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        1.2, 850.0, 'UAH', 'Частота: 868/915 MHz, поновлення до 200Hz, дипольна T-антена', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)", "weight_restored_from_date": true, "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', 200, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-DIVERSITY-RX', 'HappyModel ES900RX / TBS Crossfire Diversity RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        3.2, 1200.0, 'UAH', 'Частота: 868/915 MHz, подвійний прийом (Diversity), T-антени', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', NULL, true FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-FLYWOO-ELRS-915MHZ-DUAL-RECEIVER', 'Flywoo ELRS 915MHz Dual Receiver',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        3.2, 1100.0, 'UAH', 'Частота: 868/915 MHz, подвійний прийом (Diversity), T-антени', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', NULL, true FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-INTEGRATED-O3-ENTERPRISE-CONTROL-RX-MODULE', 'Integrated O3 Enterprise Control RX Module',
        (SELECT id FROM categories WHERE code = 'rx'), NULL,
        8.0, 2500.0, 'UAH', 'Двочастотний прийом, висока завадозахищеність', '{"source_category": "Приймач керування", "compatibility": "Протокол DJI RC Pro / RC N1"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, NULL, 'DJI RC Pro / RC N1', NULL, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-AUTEL-SKYLINK-CONTROL-MESH-NETWORK-RECEIVER', 'Autel SkyLink Control & Mesh Network Receiver',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        14.0, 3800.0, 'UAH', 'Багаточастотний прийом, підтримка сіткової топології A-Mesh (дрон-ретранслятор)', '{"source_category": "Приймач керування", "compatibility": "Протокол Autel Smart Controller V3"}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, NULL, 'Autel Smart Controller V3', NULL, false FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-DIVERSITY-RX-2', 'HappyModel ES900RX / TBS Crossfire Diversity RX',
        (SELECT id FROM categories WHERE code = 'rx'), (SELECT id FROM manufacturers WHERE name = 'HappyModel'),
        3.2, 1100.0, 'UAH', 'Частота: 868/915 MHz, подвійний прийом (Diversity), T-антени', '{"source_category": "Приймач керування", "compatibility": "CRSF / ExpressLRS (UART)", "weight_restored_from_date": true, "same_name_variant": 2}'::jsonb)
    RETURNING id
)
INSERT INTO receivers (component_id, frequency, protocol, update_rate_hz, diversity)
SELECT id, '868/915 MHz', 'CRSF / ExpressLRS (UART)', NULL, true FROM c;

-- ============ GPS та навігація (gps_modules): 12 шт. ============

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-HGLRC-M100-5883', 'HGLRC M100-5883',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'HGLRC'),
        7.7, 850.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль", "compatibility": "Протокол UBLOX / NMEA", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-IFLIGHT-BLITZ-M10-GPS', 'iFlight BLITZ M10 GPS',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        4.9, 950.0, 'UAH', 'Чіп U-blox M10, керамічна антена', '{"source_category": "GPS-модуль", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', NULL, NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-FLYWOO-GOKU-GM10-NANO-V3-GPS', 'Flywoo GOKU GM10 Nano V3 GPS',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        4.1, 850.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L, мікроформат', '{"source_category": "GPS-модуль з компасом", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-HGLRC-M100-MINI-GPS', 'HGLRC M100 Mini GPS',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'HGLRC'),
        2.7, 750.0, 'UAH', 'Чіп U-blox M10, керамічна антена', '{"source_category": "GPS-модуль", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', NULL, NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-HGLRC-M100-5883-GPS', 'HGLRC M100-5883 GPS',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'HGLRC'),
        7.7, 850.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-IFLIGHT-BLITZ-M10-GPS-Z', 'iFlight BLITZ M10 GPS z компасом',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'iFlight'),
        8.2, 1100.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-HGLRC-M100-5883-GPS-Z', 'HGLRC M100-5883 GPS z компасом',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'HGLRC'),
        7.7, 850.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-FLYWOO-GOKU-GM10-V3-GPS-Z', 'Flywoo GOKU GM10 V3 GPS z компасом',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'Flywoo'),
        8.0, 950.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль", "compatibility": "UBLOX / NMEA (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-DJI-GNSS-DUAL-FREQUENCY-RTK-READY-GPS-MODULE', 'DJI GNSS Dual-Frequency + RTK Ready GPS Module',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'DJI'),
        12.0, 3200.0, 'UAH', 'GPS + Galileo + BeiDou + GLONASS (опціонально підключення RTK)', '{"source_category": "Навігаційний модуль", "compatibility": "Внутрішній шинний протокол DJI"}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, NULL, NULL, 'GPS + Galileo + BeiDou + GLONASS', true, false, 'Внутрішній шинний протокол DJI' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-AUTEL-ANTI-JAMMING-GNSS-GPS-GALILEO-BEIDOU-VISUAL-NAVIGATION', 'Autel Anti-Jamming GNSS (GPS/Galileo/BeiDou) + Visual Navigation Module',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'Autel'),
        22.0, 5400.0, 'UAH', 'GPS/GLONASS/Galileo/BeiDou + автономна візуальна навігація без GPS (VIO system)', '{"source_category": "Навігаційний модуль", "compatibility": "Внутрішній шинний протокол Autel"}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, NULL, NULL, 'GPS/GLONASS/Galileo/BeiDou', false, true, 'Внутрішній шинний протокол Autel' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-HGLRC-M100-5883-MATEK-M10Q-5883-GPS', 'HGLRC M100-5883 / Matek M10Q-5883 GPS',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'HGLRC'),
        7.7, 950.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль з компасом", "compatibility": "UBLOX / NMEA (UART)", "weight_restored_from_date": true}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;

WITH c AS (
    INSERT INTO components
        (sku, name, category_id, manufacturer_id, weight_g, price, currency, description, specs)
    VALUES ('GPS-HGLRC-M100-5883-MATEK-M10Q-5883-GPS-Z', 'HGLRC M100-5883 / Matek M10Q-5883 GPS z компасом',
        (SELECT id FROM categories WHERE code = 'gps'), (SELECT id FROM manufacturers WHERE name = 'HGLRC'),
        8.0, 950.0, 'UAH', 'Чіп U-blox M10, компас QMC5883L', '{"source_category": "GPS-модуль з компасом", "compatibility": "UBLOX / NMEA (UART)"}'::jsonb)
    RETURNING id
)
INSERT INTO gps_modules (component_id, chip, compass, constellations, rtk, visual_nav, protocol)
SELECT id, 'U-blox M10', 'QMC5883L', NULL, false, false, 'UBLOX / NMEA (UART)' FROM c;
