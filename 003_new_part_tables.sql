-- Нові таблиці для деталей, яких раніше не було:
-- стеки (FC + ESC), камери, відеопередавачі, антени, приймачі, GPS.
-- Кожна таблиця звʼязана з components через component_id (як motors, batteries ...).

-- ============ Стек: польотний контролер + регулятори ============
CREATE TABLE stacks (
    component_id      INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    variant           TEXT NOT NULL CHECK (variant IN ('stack', 'wing_fc_esc', 'mainboard')),
                      -- stack = FC+ESC для FPV, wing_fc_esc = для літаків,
                      -- mainboard = рідна плата готового дрона (DJI, Autel)
    mcu               TEXT,                 -- F405, F722 ...
    esc_current_a     INT,                  -- тривалий струм ESC, А
    esc_current_a_max INT,                  -- верхня межа, якщо вказано діапазон (55–65 А)
    esc_peak_a        INT,                  -- піковий струм, А
    mount_mm          TEXT,                 -- 30x30, 20x20 ...
    firmware          TEXT,                 -- Betaflight / INAV ...
    esc_firmware      TEXT                  -- BLHeli_S, BLHeli_32 ...
);

-- ============ Камери ============
CREATE TABLE cameras (
    component_id   INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    camera_type    TEXT NOT NULL CHECK (camera_type IN ('analog', 'digital_unit', 'gimbal')),
    signal         TEXT,                    -- Analog, Digital, Analog / Digital
    resolution_tvl INT,
    lens_mm        NUMERIC(4,2),
    form_factor    TEXT,                    -- 'Micro 19x19', 'Nano 14x14'
    has_thermal    BOOLEAN NOT NULL DEFAULT false,
    has_gimbal     BOOLEAN NOT NULL DEFAULT false
);

-- ============ Відеопередавачі (VTX) ============
CREATE TABLE vtx (
    component_id  INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    link_type     TEXT NOT NULL CHECK (link_type IN ('analog', 'digital', 'anti_jam')),
    power_min_mw  INT,
    power_max_mw  INT,
    frequency_ghz TEXT,                     -- '5.8' або '1.2 / 5.8'
    channels      TEXT,                     -- '48' або '9/48'
    protocol      TEXT,                     -- SmartAudio / Tramp ...
    connector     TEXT                      -- MMCX, SMA, U.FL
);

-- ============ Антени VTX ============
CREATE TABLE antennas (
    component_id  INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    frequency_ghz TEXT,
    polarization  TEXT,                     -- RHCP, dual
    gain_dbi      NUMERIC(3,1),
    length_mm     INT,
    connector     TEXT
);

-- ============ Приймачі керування ============
CREATE TABLE receivers (
    component_id   INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    frequency      TEXT,                    -- '868/915 MHz; 2.4 GHz'
    protocol       TEXT,                    -- CRSF / ExpressLRS ...
    update_rate_hz INT,
    diversity      BOOLEAN NOT NULL DEFAULT false
);

-- ============ GPS та навігаційні модулі ============
CREATE TABLE gps_modules (
    component_id   INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    chip           TEXT,                    -- U-blox M10
    compass        TEXT,                    -- QMC5883L
    constellations TEXT,                    -- GPS + Galileo + BeiDou + GLONASS
    rtk            BOOLEAN NOT NULL DEFAULT false,
    visual_nav     BOOLEAN NOT NULL DEFAULT false,   -- навігація без GPS (VIO)
    protocol       TEXT
);
