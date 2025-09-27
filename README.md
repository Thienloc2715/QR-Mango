# 📌 QR-Mango Project

Chào mừng đến với dự án **QR-Mango** 🎉  
Repo này sử dụng workflow **Fork → Branch → Pull Request (PR)** để các thành viên có thể đóng góp code.

---

## 🚀 Workflow cho Member

#### 1. Fork repo
- Vào repo gốc: [ttnguyen286/QR-Mango](https://github.com/ttnguyen286/QR-Mango)
- Bấm nút **Fork** để tạo bản sao repo về GitHub cá nhân của bạn.

#### 2. Clone fork về máy
```bash
git clone https://github.com/<your-username>/QR-Mango.git
cd QR-Mango
```
#### 3. Thêm upstream (repo gốc)
```bash
git remote add upstream https://github.com/ttnguyen286/QR-Mango.git
git fetch upstream
```

#### 4. Tạo branch mới cho mỗi thay đổi
```bash
git checkout -b feature/<ten-chuc-nang>
# ví dụ: git checkout -b feature/add-qr-decoder
```
#### 5. Push branch lên fork
```bash
git add .
git commit -m "feat: mô tả ngắn gọn thay đổi"
git push -u origin feature/<ten-chuc-nang>
```

#### 6. Tạo Pull Request (PR)
- Lên GitHub fork của bạn → bấm **Compare & Pull Request**
- Base repo: `ttnguyen286/QR-Mango` (branch: `main`)
- Head repo: `<your-username>/QR-Mango` (branch: `feature/...`)
- Điền mô tả PR theo form: mục tiêu, thay đổi, cách test.

---

### 📖 Quy tắc chung
- Mỗi **tính năng/bugfix = 1 branch + 1 PR**.
- Không commit trực tiếp vào `main`.
- Không push secrets (API keys, password).
- Nếu muốn giữ folder trống → thêm file `.gitkeep`.

## ✅ Ví dụ nhanh

```bash
# clone fork
git clone https://github.com/johndoe/QR-Mango.git
cd QR-Mango

# tạo nhánh mới
git checkout -b feature/add-docs

# chỉnh sửa file → commit
git add README.md
git commit -m "docs: cập nhật hướng dẫn workflow"

# push lên fork
git push origin feature/add-docs

# tạo PR từ fork → repo gốc
```
## 🎉 Chúc bạn code vui vẻ 💻✨



