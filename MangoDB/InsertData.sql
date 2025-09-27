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

