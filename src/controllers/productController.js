// src/controllers/productController.js (phiên bản mới)
const db = require('../database');

// Lấy tất cả sản phẩm thông qua view
exports.getAllProducts = async (req, res) => {
  try {
    // Sử dụng view 'v_qr_lookup' để lấy dữ liệu đã được join sẵn
    const sql = 'SELECT * FROM agri.v_qr_lookup ORDER BY batch_id';
    const { rows } = await db.query(sql);
    res.status(200).json(rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Lấy một sản phẩm theo MÃ QR (code)
exports.getProductByCode = async (req, res) => {
  // Bây giờ chúng ta tìm theo 'code' (string) thay vì 'id' (number)
  const { code } = req.params; 
  try {
    const sql = 'SELECT * FROM agri.v_qr_lookup WHERE code = $1';
    const { rows } = await db.query(sql, [code]);

    if (rows.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy thông tin cho mã QR này' });
    }
    res.status(200).json(rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};




// // Logic xử lý cho các request liên quan đến sản phẩm
// const db = require('../database');

// // Lấy tất cả sản phẩm
// exports.getAllProducts = async (req, res) => {
//   try {
//     const sql = `
//         SELECT p.id, p.name, p.price, p.description, 
//                f.name as farm_name, c.name as category_name
//         FROM products p
//         JOIN farms f ON p.farm_id = f.id
//         JOIN categories c ON p.category_id = c.id
//         ORDER BY p.id;
//     `;
//     const { rows } = await db.query(sql);
//     res.status(200).json(rows);
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// };

// // Lấy một sản phẩm theo ID
// exports.getProductById = async (req, res) => {
//   const { id } = req.params;
//   try {
//     const sql = `
//         SELECT p.id, p.name, p.price, p.description, 
//                f.name as farm_name, f.address as farm_address, 
//                c.name as category_name
//         FROM products p
//         JOIN farms f ON p.farm_id = f.id
//         JOIN categories c ON p.category_id = c.id
//         WHERE p.id = $1;
//     `;
//     const { rows } = await db.query(sql, [id]);
//     if (rows.length === 0) {
//       return res.status(404).json({ message: 'Không tìm thấy sản phẩm' });
//     }
//     res.status(200).json(rows[0]);
//   } catch (error) {
//     res.status(500).json({ error: error.message });
//   }
// };