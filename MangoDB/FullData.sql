------------------ CREATE TABLE ------------------------
-- (0) Tạo schema rõ ràng

DROP VIEW  IF EXISTS agri.v_qr_lookup;
DROP TABLE IF EXISTS agri.qrcode        CASCADE;
DROP TABLE IF EXISTS agri.price_history CASCADE;
DROP TABLE IF EXISTS agri.batch         CASCADE;
DROP TABLE IF EXISTS agri.farm          CASCADE;
DROP TABLE IF EXISTS agri.variety       CASCADE;
DROP TABLE IF EXISTS agri.product       CASCADE;
CREATE SCHEMA IF NOT EXISTS agri;

-- (1) Dòng sản phẩm (xoài)
CREATE TABLE agri.product (
  product_id   SERIAL PRIMARY KEY,
  name         VARCHAR(80) NOT NULL,        -- "Mango"
  category     VARCHAR(40) NOT NULL DEFAULT 'fruit',
  description  TEXT
);

-- (2) Giống xoài (Cát Hòa Lộc, Cát Chu, Keo, R2E2...)
CREATE TABLE agri.variety (
  variety_id        SERIAL PRIMARY KEY,
  product_id        INT NOT NULL REFERENCES agri.product(product_id),
  name              VARCHAR(120) NOT NULL,
  seed_type         VARCHAR(20)  CHECK (seed_type IN ('có hột','ít hột','không hột')),
  color   VARCHAR(40),             -- vàng, xanh vàng...
  brix_from          NUMERIC(4,1),
  brix_to          NUMERIC(4,1),
  origin     VARCHAR(120)
);

-- (3) Nông trại
CREATE TABLE agri.farm (
  farm_id     SERIAL PRIMARY KEY,
  name        VARCHAR(160) NOT NULL,
  address     VARCHAR(255),
  phone       VARCHAR(30),
  website     VARCHAR(255),
  certification VARCHAR(160)                -- VietGAP/GlobalG.A.P/Organic,...
);

-- (4) Lô thu hoạch
CREATE TABLE agri.batch (
  batch_id     SERIAL PRIMARY KEY,
  variety_id   INT NOT NULL REFERENCES agri.variety(variety_id),
  farm_id      INT NOT NULL REFERENCES agri.farm(farm_id),
  harvest_date DATE NOT NULL,
  expiry_date  DATE NOT NULL,
  grade        VARCHAR(2)  CHECK (grade IN ('A','B','C')),
  size   VARCHAR(4)  CHECK (size IN ('S','M','L','XL')),
  ripeness     VARCHAR(16) CHECK (ripeness IN ('xanh','ương','chín')),
  postharvest_treatment VARCHAR(160),        -- rửa, xử lý nhiệt, khử trùng,...
  weight_kg    NUMERIC(10,2) CHECK (weight_kg >= 0)              -- mã chứng nhận áp cho lô
);

-- (5) QR code gắn lô
CREATE TABLE agri.qrcode (
  qr_id     SERIAL PRIMARY KEY,
  batch_id  INT NOT NULL REFERENCES agri.batch(batch_id),
  code      VARCHAR(128) NOT NULL UNIQUE,    -- nội dung QR
  status    VARCHAR(16) NOT NULL DEFAULT 'active',  -- active|used|revoked
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- (6) Lịch sử giá theo giống (có thể thêm cột market nếu cần)
CREATE TABLE agri.price_history (
  price_id   SERIAL PRIMARY KEY,
  variety_id INT NOT NULL REFERENCES agri.variety(variety_id),
  price_type VARCHAR(16) NOT NULL CHECK (price_type IN ('original','selling','promo')),
  currency   VARCHAR(8)  NOT NULL DEFAULT 'VND',
  amount     NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
  valid_from DATE NOT NULL,
  valid_to   DATE,
  CONSTRAINT ck_valid_range CHECK (valid_to IS NULL OR valid_to >= valid_from)
);

-- (7) Indexes quan trọng
CREATE INDEX idx_qrcode_code ON agri.qrcode(code);
CREATE INDEX idx_batch_variety ON agri.batch(variety_id, harvest_date DESC);
CREATE INDEX idx_batch_farm ON agri.batch(farm_id, harvest_date DESC);
CREATE INDEX idx_price_variety_type_from ON agri.price_history(variety_id, price_type, valid_from DESC);

-- (8) View tra cứu nhanh khi quét QR
CREATE OR REPLACE VIEW agri.v_qr_lookup AS
SELECT
  q.code, q.status, q.created_at,
  b.batch_id, b.harvest_date, b.expiry_date, b.grade, b.size, b.ripeness,
  b.weight_kg, b.postharvest_treatment,
  v.variety_id, v.name AS variety_name, v.seed_type, v.color,
  v.brix_from, v.brix_to, v.origin,
  p.product_id, p.name AS product_name, p.category,
  f.farm_id, f.name AS farm_name, f.address, f.phone, f.website,
  ph.amount AS current_price, ph.currency
FROM agri.qrcode q
JOIN agri.batch b   ON b.batch_id = q.batch_id
JOIN agri.variety v ON v.variety_id = b.variety_id
JOIN agri.product p ON p.product_id = v.product_id
JOIN agri.farm f    ON f.farm_id = b.farm_id
LEFT JOIN LATERAL (
  SELECT amount, currency
  FROM agri.price_history
  WHERE variety_id = v.variety_id
    AND price_type = 'selling'
    AND (valid_to IS NULL OR valid_to >= CURRENT_DATE)
  ORDER BY valid_from DESC
  LIMIT 1
) ph ON TRUE;

-------------------- INSERT DATA --------------------------- 
-- Product
INSERT INTO agri.product (product_id, name, category, description) VALUES
(1,'Mango','Trái cây','Sản phẩm xoài các giống tại VN');

-- Variety
INSERT INTO agri.variety (product_id, name, seed_type, color, brix_from, brix_to, origin) VALUES
(1,'Xoài Cát Hòa Lộc','có hột','vàng',18.0,22.0,'Tiền Giang'),
(1,'Xoài Cát Chu','có hột','vàng nhạt',17.0,21.0,'Đồng Tháp'),
(1,'Xoài Keo','ít hột','xanh-vàng',16.0,19.0,'An Giang');

-- Farm		
INSERT INTO agri.farm (name, address, phone, website, certification) VALUES
('Trang trại A','Tiền Giang','0901111222','https://farm-a.example','VietGAP'),
('Trang trại B','Đồng Tháp','0903333444','https://farm-b.example','GlobalG.A.P'),
('Trang trại C','An Giang','0905555666','https://farm-c.example','VietGAP');

-- Batch
INSERT INTO agri.batch (variety_id, farm_id, harvest_date, expiry_date, grade, size, ripeness,
                        postharvest_treatment, weight_kg) VALUES
(1,1,'2025-11-20','2025-12-10','A','L','chín','rửa & xử lý nhiệt',1200),
(2,2,'2025-11-25','2025-12-15','A','M','ương','khử trùng',900),
(3,3,'2025-12-01','2025-12-22','B','XL','xanh','rửa',700);

-- QR codes
INSERT INTO agri.qrcode (batch_id, code, status) VALUES
(1,'QR-MANGO-CHL-20251120-0001','active'),
(1,'QR-MANGO-CHL-20251120-0002','active'),
(2,'QR-MANGO-CC-20251125-0001','active');

-- Price history
INSERT INTO agri.price_history (variety_id, price_type, currency, amount, valid_from, valid_to) VALUES
(1,'original','VND',60000,'2025-11-01','2025-12-31'),
(1,'selling','VND',95000,'2025-11-15',NULL),
(2,'promo','VND',70000,'2025-11-01','2025-12-31'),
(2,'selling','VND',90000,'2025-11-12',NULL),
(3,'original','VND',50000,'2025-12-01',NULL),
(3,'promo','VND',40000,'2025-12-05',NULL);


SELECT setval('agri.product_product_id_seq',       (SELECT max(product_id)  FROM agri.product));
SELECT setval('agri.variety_variety_id_seq',       (SELECT max(variety_id)  FROM agri.variety));
SELECT setval('agri.farm_farm_id_seq',             (SELECT max(farm_id)     FROM agri.farm));
SELECT setval('agri.batch_batch_id_seq',           (SELECT max(batch_id)    FROM agri.batch));
SELECT setval('agri.qrcode_qr_id_seq',             (SELECT max(qr_id)       FROM agri.qrcode));
SELECT setval('agri.price_history_price_id_seq',   (SELECT max(price_id)    FROM agri.price_history));

