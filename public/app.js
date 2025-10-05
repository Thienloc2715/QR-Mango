document.addEventListener('DOMContentLoaded', () => {
    const statusMessageEl = document.getElementById('status-message');
    const productInfoEl = document.getElementById('product-info');
    const qrReaderEl = document.getElementById('qr-reader');

    // --- Hàm hiển thị thông báo trạng thái ---
    function showStatus(message, isError = false) {
        statusMessageEl.textContent = message;
        statusMessageEl.className = isError ? 'status-error' : 'status-info';
    }
    
    // --- Hàm gọi API để lấy thông tin sản phẩm ---
    async function fetchProductInfo(productCode) {
        showStatus('Đã quét thành công. Đang tải dữ liệu...');
        console.log(`Bắt đầu gọi API cho mã: ${productCode}`);

        try {
            const response = await fetch(`http://localhost:3000/api/products/${productCode}`);
            
            console.log('Trạng thái phản hồi:', response.status, response.statusText);

            if (!response.ok) {
                const errorData = await response.json();
                // Ném lỗi với thông điệp từ server nếu có
                throw new Error(errorData.message || `Lỗi ${response.status}`);
            }

            const product = await response.json();
            console.log('Dữ liệu nhận được:', product);
            displayProductInfo(product);

        } catch (error) {
            console.error('Đã xảy ra lỗi khi fetch dữ liệu:', error);
            showStatus(`Lỗi: ${error.message}. Vui lòng kiểm tra lại mã QR hoặc đảm bảo server đang chạy.`, true);
        }
    }

    // --- Hàm hiển thị thông tin sản phẩm lên trang web ---
    function displayProductInfo(product) {
        showStatus('Tải dữ liệu thành công!', false);
        
        document.getElementById('product-name').textContent = product.product_name;
        document.getElementById('product-price').textContent = product.current_price;
        document.getElementById('product-currency').textContent = product.currency;
        document.getElementById('variety-name').textContent = product.variety_name;
        document.getElementById('variety-origin').textContent = product.origin;
        document.getElementById('farm-name').textContent = product.farm_name;
        document.getElementById('farm-address').textContent = product.address;
        document.getElementById('harvest-date').textContent = new Date(product.harvest_date).toLocaleDateString('vi-VN');
        document.getElementById('expiry-date').textContent = new Date(product.expiry_date).toLocaleDateString('vi-VN');
        
        productInfoEl.classList.remove('hidden');
    }
    
    // --- Logic quét mã QR ---
    function onScanSuccess(decodedText, decodedResult) {
        html5QrcodeScanner.clear(); // Dừng camera
        qrReaderEl.classList.add('hidden'); // Ẩn khung camera
        fetchProductInfo(decodedText);
    }

    // Khởi tạo trình quét mã
    let html5QrcodeScanner = new Html5QrcodeScanner(
        "qr-reader", 
        { fps: 10, qrbox: { width: 250, height: 250 } },
        /* verbose= */ false
    );
    html5QrcodeScanner.render(onScanSuccess);
});

// document.addEventListener('DOMContentLoaded', () => {
//     const scanResultEl = document.getElementById('scan-result');
//     const productInfoEl = document.getElementById('product-info');

//     // --- Hàm gọi API để lấy thông tin sản phẩm ---
//     async function fetchProductInfo(productCode) {
//         try {
//             // Nhớ đảm bảo backend của bạn đang chạy ở port 3000
//             const response = await fetch(`http://localhost:3000/api/products/${productCode}`);
            
//             if (!response.ok) {
//                 const errorData = await response.json();
//                 throw new Error(errorData.message || 'Không tìm thấy sản phẩm.');
//             }

//             const product = await response.json();
//             displayProductInfo(product);

//         } catch (error) {
//             scanResultEl.textContent = `Lỗi: ${error.message}`;
//             scanResultEl.classList.remove('hidden');
//             productInfoEl.classList.add('hidden');
//         }
//     }

//     // --- Hàm hiển thị thông tin sản phẩm lên trang web ---
//     function displayProductInfo(product) {
//         document.getElementById('product-name').textContent = product.name;
//         document.getElementById('product-price').textContent = product.price;
//         document.getElementById('product-description').textContent = product.description;
//         document.getElementById('farm-name').textContent = product.farm_name;
//         document.getElementById('category-name').textContent = product.category_name;
        
//         productInfoEl.classList.remove('hidden');
//     }
    
//     // --- Logic quét mã QR ---
//     function onScanSuccess(decodedText, decodedResult) {
//         // decodedText chính là ID sản phẩm
//         console.log(`Scan thành công, ID sản phẩm: ${decodedText}`);
        
//         // Dừng camera
//         html5QrcodeScanner.clear();

//         // Ẩn khung camera và hiển thị kết quả
//         document.getElementById('qr-reader').classList.add('hidden');
//         scanResultEl.textContent = `Đã quét thành công ID: ${decodedText}. Đang tải dữ liệu...`;
//         scanResultEl.classList.remove('hidden');

//         // Gọi API để lấy thông tin
//         fetchProductInfo(decodedText);
//     }

//     function onScanFailure(error) {
//         // Bỏ qua lỗi, không cần làm gì cả
//     }

//     // Khởi tạo trình quét mã
//     let html5QrcodeScanner = new Html5QrcodeScanner(
//         "qr-reader", 
//         { fps: 10, qrbox: { width: 250, height: 250 } }
//     );
//     html5QrcodeScanner.render(onScanSuccess, onScanFailure);
// });