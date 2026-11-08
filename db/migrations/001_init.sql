-- ============ Довідники ============

CREATE TABLE manufacturers (
    id      SERIAL PRIMARY KEY,
    name    TEXT UNIQUE NOT NULL,
    country TEXT,
    website TEXT
);
 
CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL
);

-- ============ Спільна таблиця деталей ============

CREATE TABLE components (
    id              SERIAL PRIMARY KEY,
    sku             TEXT UNIQUE NOT NULL,
    name            TEXT NOT NULL,
    category_id     INT NOT NULL REFERENCES categories(id),
    manufacturer_id INT REFERENCES manufacturers(id),
    weight_g        NUMERIC(8,2) CHECK (weight_g > 0),
    price           NUMERIC(10,2) CHECK (price >= 0),
    currency        CHAR(3) NOT NULL DEFAULT 'USD',
    description     TEXT,
    specs           JSONB NOT NULL DEFAULT '{}',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_components_category ON components(category_id);
CREATE INDEX idx_components_specs ON components USING GIN (specs);

-- ============ Специфічні характеристики ============

CREATE TABLE motors (
    component_id   INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    stator_size    TEXT NOT NULL,
    kv             INT  NOT NULL CHECK (kv > 0),
    max_current_a  NUMERIC(5,1),
    max_thrust_g   INT,
    shaft_mm       NUMERIC(3,1),
    mount_mm       TEXT
);

CREATE TABLE batteries (
    component_id  INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    cells_s       INT NOT NULL CHECK (cells_s BETWEEN 1 AND 14),
    capacity_mah  INT NOT NULL CHECK (capacity_mah > 0),
    c_rating      INT,
    chemistry     TEXT NOT NULL DEFAULT 'LiPo',
    connector     TEXT
);

CREATE TABLE propellers (
    component_id  INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    diameter_in   NUMERIC(4,2) NOT NULL,
    pitch_in      NUMERIC(4,2),
    blades        INT NOT NULL DEFAULT 2 CHECK (blades > 0),
    hole_mm       NUMERIC(3,1)
);

CREATE TABLE frames (
    component_id   INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    wheelbase_mm   INT,
    max_prop_in    NUMERIC(4,2),
    stack_mount_mm TEXT,
    material       TEXT
);

CREATE TABLE escs (
    component_id  INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    max_current_a INT NOT NULL,
    min_cells_s   INT NOT NULL,
    max_cells_s   INT NOT NULL,
    protocol      TEXT,
    mount_mm      TEXT,
    CHECK (min_cells_s <= max_cells_s)
);

CREATE TABLE flight_controllers (
    component_id INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    mcu          TEXT,
    firmware     TEXT,
    mount_mm     TEXT,
    uarts        INT
);

-- ============ Склад ============

CREATE TABLE stock (
    component_id INT PRIMARY KEY REFERENCES components(id) ON DELETE CASCADE,
    quantity     INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    location     TEXT,
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============ Збірки дронів ============

CREATE TABLE drones (
    id         SERIAL PRIMARY KEY,
    name       TEXT UNIQUE NOT NULL,
    notes      TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE drone_parts (
    drone_id     INT NOT NULL REFERENCES drones(id) ON DELETE CASCADE,
    component_id INT NOT NULL REFERENCES components(id),
    quantity     INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    PRIMARY KEY (drone_id, component_id)
);
