// app.js (phiên bản cập nhật)
const express = require('express');
const cors = require('cors'); // Thêm dòng này
const path = require('path'); // Thêm dòng này
require('dotenv').config();
const productRoutes = require('./src/routes/productRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors()); // Thêm dòng này: Cho phép các domain khác gọi API
app.use(express.json());

// Phục vụ các file tĩnh từ thư mục 'public'
app.use(express.static(path.join(__dirname, 'public'))); // Thêm dòng này

// API Routes
app.use('/api', productRoutes);

// Khởi động server
app.listen(PORT, () => {
  console.log(`✅ Server đang chạy tại http://localhost:${PORT}`);
});