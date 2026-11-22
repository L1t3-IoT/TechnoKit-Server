-- Конкретні збірки дронів із таблиці «Детали+дрони»: 19 блоків по 10 деталей.
-- drone_parts.quantity = кількість деталі на 1 дрон («4 шт.» -> 4, «1 комплект» -> 1).
-- Якщо назва блоку в таблиці не відповідає рамі, це зазначено в drones.notes.

-- DarwinFPV BabyApe II (3.5") #1
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('DarwinFPV BabyApe II (3.5") #1', 'компактний дрон для розвідки та тренувань. Увага: у таблиці назва вказує 3.5", але рама в цьому блоці "GEPRC Mark4 7"" (7")',
        (SELECT id FROM use_cases WHERE code = 'small_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-GEPRC-MARK4-7', 1),
    ('MOTOR-EMAX-ECO-II-2807', 4),
    ('PROP-HQPROP-7X3-5X3', 1),
    ('STACK-SPEEDYBEE-F405-V4-55A', 1),
    ('CAMERA-CADDX-RATEL-2', 1),
    ('VTX-RUSH-TANK-SOLO-5-8G', 1),
    ('ANTENNA-FOXEER-LOLLIPOP-4-STUBBY', 1),
    ('RX-HAPPYMODEL-ES900RX', 1),
    ('GPS-HGLRC-M100-5883', 1),
    ('BATTERY-MOLICEL-P42A-6S2P-6000MAH', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- DarwinFPV BabyApe II (3.5") #2
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('DarwinFPV BabyApe II (3.5") #2', 'компактний дрон для розвідки та тренувань. Увага: у таблиці назва вказує 3.5", але рама в цьому блоці "GEPRC GEP-MK5" (5")',
        (SELECT id FROM use_cases WHERE code = 'small_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-GEPRC-GEP-MK5', 1),
    ('MOTOR-GEPRC-SPEEDX2-2107-5', 4),
    ('PROP-HQPROP-ETHIX-S5', 1),
    ('STACK-SPEEDYBEE-F405-V4-55A', 1),
    ('CAMERA-CADDX-RATEL-2', 1),
    ('VTX-RUSH-TANK-SOLO-5-8G', 1),
    ('ANTENNA-FOXEER-LOLLIPOP-4-STUBBY', 1),
    ('RX-HAPPYMODEL-EXPRESSLRS-EP1', 1),
    ('GPS-HGLRC-M100-5883', 1),
    ('BATTERY-TATTU-R-LINE-6S-1300MAH-120C', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- iFlight Nazgul Evoque F5 V2 (5")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('iFlight Nazgul Evoque F5 V2 (5")', 'популярна 5" платформа з цифровою/аналоговою системою',
        (SELECT id FROM use_cases WHERE code = 'small_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-IFLIGHT-EVOQUE-F5-V2-SQUASHED-X', 1),
    ('MOTOR-IFLIGHT-XING2-2207', 4),
    ('PROP-NAZGUL-F5-TRIMBLADE-HQ-IFLIGHT', 1),
    ('STACK-IFLIGHT-BLITZ-F7-V1-1-STACK-F7-FC-55A-ESC', 1),
    ('CAMERA-CADDX-RATEL-2-DJI-O3-AIR-UNIT', 1),
    ('VTX-IFLIGHT-BLITZ-ULTIMATE-VTX-1-6W', 1),
    ('ANTENNA-IFLIGHT-ALBATROSS-5-8GHZ-ANTENNA', 1),
    ('RX-IFLIGHT-ELRS-915MHZ-2-4GHZ-RX', 1),
    ('GPS-IFLIGHT-BLITZ-M10-GPS', 1),
    ('BATTERY-FULLSEND-6S-1300MAH-120C-LIPO', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- Flywoo Explorer LR 4 (4")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('Flywoo Explorer LR 4 (4")', 'легкий ультра-дальноліт (Long Range) з високою автономністю',
        (SELECT id FROM use_cases WHERE code = 'small_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-FLYWOO-EXPLORER-LR-4-V2-FRAME-KIT', 1),
    ('MOTOR-FLYWOO-NIN-V2-1404', 4),
    ('PROP-GEMFAN-4024-2-CLEAR-GRAY', 1),
    ('STACK-FLYWOO-GOKU-GN405-NANO-13A-STACK', 1),
    ('CAMERA-FLYWOO-FLYLENS-CAM-CADDX-ANT-BABY-RATEL-2', 1),
    ('VTX-FLYWOO-GOKU-HM600-VTX', 1),
    ('ANTENNA-FLYWOO-ATOMIC-5-8GHZ-ANTENNA', 1),
    ('RX-FLYWOO-ELRS-2-4GHZ-915MHZ-NANO-RX', 1),
    ('GPS-FLYWOO-GOKU-GM10-NANO-V3-GPS', 1),
    ('BATTERY-FLYWOO-EXPLORER-4S-3000MAH-LI-ION-18650', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- GEPRC Mark4 7"
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('GEPRC Mark4 7"', 'одна з найпопулярніших рам/моделей для ударних 7-дюймових FPV',
        (SELECT id FROM use_cases WHERE code = 'medium_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-GEPRC-GEP-MK4-7', 1),
    ('MOTOR-EMAX-ECO-II-2807', 4),
    ('PROP-HQPROP-7X3-5X3', 1),
    ('STACK-SPEEDYBEE-F405-V4-55A', 1),
    ('CAMERA-CADDX-RATEL-2', 1),
    ('VTX-RUSH-TANK-SOLO-5-8G', 1),
    ('ANTENNA-FOXEER-LOLLIPOP-4-STUBBY', 1),
    ('RX-HAPPYMODEL-ES900RX', 1),
    ('GPS-HGLRC-M100-5883', 1),
    ('BATTERY-6S2P-LI-ION-6000MAH-MOLICEL-P42A', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- SpeedyBee Bee35
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('SpeedyBee Bee35', 'надійний 7" ударний FPV-коптер. Увага: у таблиці назва вказує 7", але рама в цьому блоці "SpeedyBee Bee35 Frame Kit" (3.5")',
        (SELECT id FROM use_cases WHERE code = 'medium_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-SPEEDYBEE-BEE35-FRAME-KIT', 1),
    ('MOTOR-EMAX-ECO-II-2004-SPEEDYBEE-2004', 4),
    ('PROP-GEMFAN-D90-3-3-5-CINEWHOOP-PROPS', 1),
    ('STACK-SPEEDYBEE-F405-MINI-35A-STACK', 1),
    ('CAMERA-CADDX-RATEL-2-MICRO', 1),
    ('VTX-SPEEDYBEE-TX800-VTX', 1),
    ('ANTENNA-FOXEER-LOLLIPOP-4-MICRO', 1),
    ('RX-HAPPYMODEL-EXPRESSLRS-EP1-RX', 1),
    ('GPS-HGLRC-M100-MINI-GPS', 1),
    ('BATTERY-TATTU-R-LINE-4S-1300MAH-6S-1050MAH', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- BlueBird Zhakh 7"
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('BlueBird Zhakh 7"', 'легкий ударний дрон тактичного радіуса',
        (SELECT id FROM use_cases WHERE code = 'medium_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-BLUEBIRD-ZHAKH-7-FRAME-KIT', 1),
    ('MOTOR-EMAX-ECO-II-2807-FLASHHOBBY-2807', 4),
    ('PROP-HQPROP-7X3-5X3-GEMFAN-7040', 1),
    ('STACK-SPEEDYBEE-F405-V4-55A-STACK', 1),
    ('CAMERA-CADDX-RATEL-2-FOXEER-CAT-3', 1),
    ('VTX-RUSH-TANK-SOLO-READYTOSKY-1-6W-VTX', 1),
    ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-1-2GHZ-ANTENNA', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX', 1),
    ('GPS-HGLRC-M100-5883-GPS', 1),
    ('BATTERY-6S2P-LI-ION-8000MAH-MOLICEL-P42A-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- BlueBird Zhakh 8"
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('BlueBird Zhakh 8"', '8-дюймовий FPV для середньої ваги вантажів',
        (SELECT id FROM use_cases WHERE code = 'medium_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-BLUEBIRD-ZHAKH-8-FRAME-KIT', 1),
    ('MOTOR-EMAX-ECO-II-2809-EMAX-3110', 4),
    ('PROP-HQPROP-8X4X3-GEMFAN-8046', 1),
    ('STACK-SPEEDYBEE-F405-V4-55A-STACK', 1),
    ('CAMERA-RUNCAM-PHOENIX-2-SE-CADDX-RATEL-2', 1),
    ('VTX-RUSH-TANK-SOLO-1-6W-READYTOSKY-2-5W', 1),
    ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-HIGH-GAIN', 1),
    ('RX-HAPPYMODEL-ES900RX-EMAX-AERIS-915MHZ', 1),
    ('GPS-HGLRC-M100-5883-GPS', 1),
    ('BATTERY-6S2P-LI-ION-8400MAH-MOLICEL-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- iFlight Chimera7 Pro V2 (7.5")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('iFlight Chimera7 Pro V2 (7.5")', 'дальнолітній квадрокоптер підвищеної стійкості до вітру',
        (SELECT id FROM use_cases WHERE code = 'medium_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-IFLIGHT-CHIMERA7-PRO-V2-FRAME-KIT', 1),
    ('MOTOR-IFLIGHT-XING2-2809', 4),
    ('PROP-HQPROP-7-5X3-7X3', 1),
    ('STACK-IFLIGHT-BLITZ-F7-V1-1-STACK-F7-FC-55A-ESC', 1),
    ('CAMERA-CADDX-RATEL-2-DJI-O3-AIR-UNIT', 1),
    ('VTX-IFLIGHT-BLITZ-1-6W-VTX', 1),
    ('ANTENNA-IFLIGHT-ALBATROSS-5-8GHZ-150MM-ANTENNA', 1),
    ('RX-IFLIGHT-EXPRESSLRS-915MHZ-2-4GHZ-RX', 1),
    ('GPS-IFLIGHT-BLITZ-M10-GPS-Z', 1),
    ('BATTERY-FULLSEND-6S2P-LI-ION-8000MAH-MOLICEL-P42A', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- DarwinFPV X9 (9")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('DarwinFPV X9 (9")', 'вантажний 9-дюймовий FPV-коптер',
        (SELECT id FROM use_cases WHERE code = 'heavy_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-DARWINFPV-X9-FRAME-KIT', 1),
    ('MOTOR-DARWINFPV-EMAX-2812', 4),
    ('PROP-GEMFAN-9045-3', 1),
    ('STACK-SPEEDYBEE-F405-V4-55A-STACK-F7-65A', 1),
    ('CAMERA-CADDX-RATEL-2', 1),
    ('VTX-DARWINFPV-CEMENT-1-6W-RUSH-TANK-SOLO-5-8G', 1),
    ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-1-2GHZ-HIGH-GAIN', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX-2', 1),
    ('GPS-HGLRC-M100-5883-GPS', 1),
    ('BATTERY-6S2P-LI-ION-8400MAH-10500MAH-MOLICEL-P45B-P42A', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- SKIF-10D (10")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('SKIF-10D (10")', '10-дюймовий ударний FPV-камікадзе великого радіуса дії',
        (SELECT id FROM use_cases WHERE code = 'heavy_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-SKIF-10D-FRAME-KIT', 1),
    ('MOTOR-EMAX-ECO-II-3110-BROTHERHOBBY-3115', 4),
    ('PROP-HQPROP-10X4-5X3-GEMFAN-1050', 1),
    ('STACK-SPEEDYBEE-F405-V3-V4-60A-STACK-F7-65A', 1),
    ('CAMERA-RUNCAM-PHOENIX-2-SE-CADDX-RATEL-2-2', 1),
    ('VTX-READYTOSKY-5-8G-2-5W-RUSH-TANK-SOLO', 1),
    ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-1-2GHZ-HIGH-GAIN-2', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX-2', 1),
    ('GPS-HGLRC-M100-5883-GPS', 1),
    ('BATTERY-6S3P-LI-ION-12600MAH-MOLICEL-P42A-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- BlueBird Zhakh 10"
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('BlueBird Zhakh 10"', 'тактичний 10" дрон з вантажопідйомністю до 3 кг',
        (SELECT id FROM use_cases WHERE code = 'heavy_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-BLUEBIRD-ZHAKH-10-FRAME-KIT', 1),
    ('MOTOR-BROTHERHOBBY-AVENGER-3115-EMAX-3110', 4),
    ('PROP-HQPROP-10X4-5X3-GEMFAN-1050-2', 1),
    ('STACK-SKYSTARS-SPEEDYBEE-F722-65A-STACK', 1),
    ('CAMERA-RUNCAM-PHOENIX-2-SE-CADDX-RATEL-2-2', 1),
    ('VTX-READYTOSKY-5-8G-2-5W-VTX-1-2GHZ-1-5W', 1),
    ('ANTENNA-FOXEER-PAGEANT-HIGH-GAIN-ANTENNA', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX-2', 1),
    ('GPS-HGLRC-M100-5883-GPS-Z', 1),
    ('BATTERY-6S3P-LI-ION-12600MAH-15000MAH-MOLICEL-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- SKIF-13D (13")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('SKIF-13D (13")', 'важка 13-дюймова платформа для дальніх дистанцій',
        (SELECT id FROM use_cases WHERE code = 'heavy_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-SKIF-13D-FRAME-KIT', 1),
    ('MOTOR-BROTHERHOBBY-T5-3115-XING2-3110', 4),
    ('PROP-HQPROP-13X12X3-MASTER-AIRSCREW-13', 1),
    ('STACK-SKYSTARS-SPEEDYBEE-F722-PRO-65A-80A-STACK', 1),
    ('CAMERA-RUNCAM-PHOENIX-2-SE-FOXEER-CAT-3', 1),
    ('VTX-READYTOSKY-1-2GHZ-1-5W-5-8G-2-5W-VTX', 1),
    ('ANTENNA-FOXEER-PAGEANT-1-2GHZ-5-8GHZ-HIGH-GAIN', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-DIVERSITY-RX', 1),
    ('GPS-HGLRC-M100-5883-GPS-Z', 1),
    ('BATTERY-6S4P-8S3P-LI-ION-16800MAH-20000MAH', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- BlueBird Zhakh 15"
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('BlueBird Zhakh 15"', 'важкий FPV-дрони (до 7 кг корисного навантаження). Увага: у таблиці назва вказує 15", але рама в цьому блоці "iFlight XL10 V6 Frame Kit" (10")',
        (SELECT id FROM use_cases WHERE code = 'heavy_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-IFLIGHT-XL10-V6-FRAME-KIT', 1),
    ('MOTOR-IFLIGHT-XING2-3110-BROTHERHOBBY-3115', 4),
    ('PROP-HQPROP-10X4-5X3', 1),
    ('STACK-IFLIGHT-BLITZ-F7-PRO-65A-STACK', 1),
    ('CAMERA-CADDX-RATEL-2-MICRO', 1),
    ('VTX-READYTOSKY-5-8G-2-5W-RUSH-TANK-SOLO-VTX', 1),
    ('ANTENNA-FOXEER-PAGEANT-5-8GHZ-HIGH-GAIN-2', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX-2', 1),
    ('GPS-HGLRC-M100-5883-GPS-Z', 1),
    ('BATTERY-6S3P-LI-ION-12600MAH-MOLICEL-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- Flywoo Chimera10 LR (10")
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('Flywoo Chimera10 LR (10")', 'спеціалізований дальноліт для важких батарей',
        (SELECT id FROM use_cases WHERE code = 'heavy_fpv'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-FLYWOO-CHIMERA10-LR-FRAME-KIT', 1),
    ('MOTOR-FLYWOO-NIN-V2-3110-BROTHERHOBBY-3115', 4),
    ('PROP-HQPROP-10X4-5X3-GEMFAN-1050-2', 1),
    ('STACK-FLYWOO-GOKU-F722-PRO-65A-STACK', 1),
    ('CAMERA-CADDX-RATEL-2-MICRO', 1),
    ('VTX-FLYWOO-GOKU-1-2G-1-5W-5-8G-2-5W-VTX', 1),
    ('ANTENNA-FOXEER-PAGEANT-1-2GHZ-5-8GHZ-HIGH-GAIN-2', 1),
    ('RX-FLYWOO-ELRS-915MHZ-DUAL-RECEIVER', 1),
    ('GPS-FLYWOO-GOKU-GM10-V3-GPS-Z', 1),
    ('BATTERY-6S4P-LI-ION-16800MAH-MOLICEL-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- DJI Mavic 3 (Mavic 3 / 3E / 3T)
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('DJI Mavic 3 (Mavic 3 / 3E / 3T)', 'еталонний розвідувальний дрон із зумом та тепловізором',
        (SELECT id FROM use_cases WHERE code = 'recon_quad'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-DJI-MAVIC-3-3E-3T-OEM-FRAME-SHELL-KIT', 1),
    ('MOTOR-DJI-MAVIC-3-BRUSHLESS-MOTORS-2008-SIZE', 4),
    ('PROP-DJI-6540F-LOW-NOISE-PROPELLERS', 1),
    ('STACK-DJI-MAVIC-3-MAINBOARD-ESC-ALL-IN-ONE-CONTROLLER', 1),
    ('CAMERA-DJI-MAVIC-3T-THERMAL-ZOOM-3-AXIS-GIMBAL-CAMERA', 1),
    ('VTX-DJI-O3-O3-ENTERPRISE-DIGITAL-TRANSCEIVER', 1),
    ('ANTENNA-DJI-INTERNAL-MULTI-BAND-ANTENNA-ARRAY', 1),
    ('RX-INTEGRATED-O3-ENTERPRISE-CONTROL-RX-MODULE', 1),
    ('GPS-DJI-GNSS-DUAL-FREQUENCY-RTK-READY-GPS-MODULE', 1),
    ('BATTERY-DJI-INTELLIGENT-FLIGHT-BATTERY-BWX260-5000-15-4', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- Autel EVO II Pro
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('Autel EVO II Pro', 'розвідувальний квадрокоптер зі стійкістю до РЕБ та якісною оптикою',
        (SELECT id FROM use_cases WHERE code = 'recon_quad'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-AUTEL-EVO-II-PRO-MAX-4T-HEAVY-FRAME-KIT', 1),
    ('MOTOR-AUTEL-EVO-II-HIGH-TORQUE-BRUSHLESS-MOTORS', 4),
    ('PROP-AUTEL-QUICK-RELEASE-PROPELLERS-EVO-II-MAX', 1),
    ('STACK-AUTEL-MAINBOARD-DUAL-ECU-ANTI-JAMMING-ESC-BOARD', 1),
    ('CAMERA-AUTEL-MAX-4T-GIMBAL-THERMAL-8K-10X-OPTICAL-ZOOM-LASER', 1),
    ('VTX-AUTEL-SKYLINK-3-0-A-MESH-ANTI-JAMMING-VTX', 1),
    ('ANTENNA-INTERNAL-MULTI-BAND-HIGH-GAIN-ANTENNA-SYSTEM', 1),
    ('RX-AUTEL-SKYLINK-CONTROL-MESH-NETWORK-RECEIVER', 1),
    ('GPS-AUTEL-ANTI-JAMMING-GNSS-GPS-GALILEO-BEIDOU-VISUAL-NAVIGATION', 1),
    ('BATTERY-AUTEL-EVO-II-MAX-SMART-BATTERY-7100-MAH-8071-MAH', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- Hee Wing T1 Ranger FPV
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('Hee Wing T1 Ranger FPV', 'двомоторне FPV-крило для тривалої розвідки',
        (SELECT id FROM use_cases WHERE code = 'fixed_wing'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-HEE-WING-T1-RANGER-PNP-KIT-FRAME-KIT', 1),
    ('MOTOR-FX-1404-BRUSHLESS-MOTORS-HEE-WING-FX-1404', 2),
    ('PROP-FX-3830PROPELLERS-3-8X3-0', 1),
    ('STACK-FX-25A-ESC-TWIN-PACK-MATEK-F405-WING-SPEEDYBEE-F405-WING-FC', 1),
    ('CAMERA-CADDX-RATEL-2-MICRO-RUNCAM-PHOENIX-2', 1),
    ('VTX-RUSH-TANK-SOLO-5-8G-1-6W-READYTOSKY-1-2G-VTX', 1),
    ('ANTENNA-FOXEER-PAGEANT-CHERRY-HIGH-GAIN-ANTENNA', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-NANO-RX-2', 1),
    ('GPS-HGLRC-M100-5883-MATEK-M10Q-5883-GPS', 1),
    ('BATTERY-4S2P-LI-ION-6000MAH-7000MAH-MOLICEL-P35B-18650', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;

-- Sonicmodell AR Wing Pro
WITH d AS (
    INSERT INTO drones (name, notes, use_case_id)
    VALUES ('Sonicmodell AR Wing Pro', 'швидкісне FPV-крило для польотів на великі відстані',
        (SELECT id FROM use_cases WHERE code = 'fixed_wing'))
    RETURNING id
)
INSERT INTO drone_parts (drone_id, component_id, quantity)
SELECT d.id, c.id, v.qty FROM d, (VALUES
    ('FRAME-SONICMODELL-AR-WING-PRO-WHITE-BLACK-EPP-KIT', 1),
    ('MOTOR-SUNNYSKY-X2814-BROTHERHOBBY-FX2808', 1),
    ('PROP-HQPROP-8X6-GEMFAN-8060', 1),
    ('STACK-FLYWOO-GOKU-F405-WING-MATEK-F405-WING-FLYWOO-50A-60A-ESC', 1),
    ('CAMERA-CADDX-RATEL-2-MICRO-RUNCAM-PHOENIX-2-SE', 1),
    ('VTX-RUSH-TANK-SOLO-5-8G-1-6W-READYTOSKY-1-2G-1-5W-VTX', 1),
    ('ANTENNA-FOXEER-PAGEANT-CHERRY-HIGH-GAIN-ANTENNA', 1),
    ('RX-HAPPYMODEL-ES900RX-TBS-CROSSFIRE-DIVERSITY-RX-2', 1),
    ('GPS-HGLRC-M100-5883-MATEK-M10Q-5883-GPS-Z', 1),
    ('BATTERY-4S3P-6S2P-LI-ION-10500MAH-12600MAH-MOLICEL-P45B', 1)
) AS v(sku, qty) JOIN components c ON c.sku = v.sku;
