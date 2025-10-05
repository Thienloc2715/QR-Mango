// src/routes/productRoutes.js (phiên bản mới)
const express = require('express');
const router = express.Router();
// Đổi tên hàm import cho rõ ràng hơn
const { getAllProducts, getProductByCode } = require('../controllers/productController');

router.get('/products', getAllProducts);
// URL bây giờ sẽ nhận một string mã QR, ví dụ: /api/products/QR-MANGO-....
router.get('/products/:code', getProductByCode);

module.exports = router;


// // Định nghĩa các đường dẫn (URL) cho API sản phẩm
// const express = require('express');
// const router = express.Router();
// const productController = require('../controllers/productController');

// router.get('/products', productController.getAllProducts);
// router.get('/products/:id', productController.getProductById);

// module.exports = router;