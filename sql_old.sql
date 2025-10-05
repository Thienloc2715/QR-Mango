CREATE TABLE farms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    description TEXT,
    farm_id INTEGER REFERENCES farms(id),
    category_id INTEGER REFERENCES categories(id)
);

INSERT INTO farms (name, address) VALUES
('Nông trại Tân Triều', 'Xã Tân Bình, Vĩnh Cửu, Đồng Nai'),
('Nông trại Hòa Lộc', 'Xã Hòa Hưng, Cái Bè, Tiền Giang');

INSERT INTO categories (name) VALUES
('Trái cây'),
('Rau củ');

INSERT INTO products (name, price, description, farm_id, category_id) VALUES
('Bưởi Tân Triều Da Xanh', 50000, 'Vị ngọt thanh, mọng nước, đặc sản Đồng Nai.', 1, 1),
('Xoài Cát Hòa Lộc Loại 1', 75000, 'Thơm, ngọt, hạt dẹt, nổi tiếng Tiền Giang.', 2, 1),
('Bưởi Tân Triều Đường Lá Cam', 60000, 'Vị ngọt đậm đà, vỏ mỏng.', 1, 1);