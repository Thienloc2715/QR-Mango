-- user chỉ đọc
CREATE ROLE qr_reader LOGIN PASSWORD 'strong_qr_reader_pwd';
ALTER


-- cấp quyền connect vào database (điền tên DB thật)
GRANT CONNECT ON DATABASE "MangoDB" TO qr_reader;

-- cấp quyền sử dụng schema
GRANT USAGE ON SCHEMA agri TO qr_reader;

-- chỉ được SELECT
GRANT SELECT ON agri.v_qr_lookup TO qr_reader;
GRANT SELECT ON agri.qrcode, agri.batch, agri.variety, agri.product, agri.farm TO qr_reader;

-- (tuỳ chọn) Thu hẹp: app chỉ dùng view
-- REVOKE ALL ON agri.qrcode, agri.batch, agri.variety, agri.product, agri.farm FROM qr_reader;
