# Aplikasi Pencatatan Keuangan

Aplikasi pencatatan keuangan pribadi berbasis Flutter dengan state management GetX. Aplikasi ini dibuat sebagai bagian dari Skill Test Magang Hub Kemnaker - Mobile Flutter Developer.

## ✨ Fitur Utama

- ✅ **Dashboard Keuangan** - Menampilkan ringkasan total saldo, pemasukan, dan pengeluaran
- ✅ **Tambah Transaksi** - Mencatat transaksi pemasukan dan pengeluaran
- ✅ **Edit Transaksi** - Mengubah data transaksi yang sudah ada
- ✅ **Hapus Transaksi** - Menghapus transaksi yang tidak diperlukan
- ✅ **Detail Transaksi** - Melihat detail lengkap dari setiap transaksi
- ✅ **Filter Transaksi** - Filter berdasarkan tipe (Semua, Pemasukan, Pengeluaran)
- ✅ **Kategori Transaksi** - Kategorisasi transaksi untuk pemasukan dan pengeluaran
- ✅ **Penyimpanan Lokal** - Data disimpan menggunakan SQLite
- ✅ **Format Rupiah** - Tampilan mata uang dalam format Rupiah (Rp)

## 🏗️ Arsitektur

Aplikasi ini menggunakan arsitektur **GetX Pattern** dengan struktur folder sebagai berikut:

```
lib/
├── main.dart
└── app/
    ├── data/
    │   ├── models/           # Model data (TransactionModel)
    │   ├── providers/        # Database provider (SQLite)
    │   └── repositories/     # Repository layer
    ├── modules/
    │   ├── home/            # Module halaman utama
    │   ├── add_transaction/ # Module tambah/edit transaksi
    │   └── transaction_detail/ # Module detail transaksi
    └── routes/              # Route management
```

## 🛠️ Teknologi yang Digunakan

- **Flutter SDK** - Framework untuk membuat aplikasi mobile
- **GetX** (^4.6.6) - State Management, Dependency Injection, dan Route Management
- **SQLite** (sqflite ^2.3.0) - Database lokal
- **Intl** (^0.19.0) - Format tanggal dan mata uang

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.6.6
  sqflite: ^2.3.0
  path: ^1.9.0
  path_provider: ^2.1.1
  intl: ^0.19.0
```

## 🚀 Cara Menjalankan

1. **Clone repository** (jika dari Git):
   ```bash
   git clone <repository-url>
   cd aplikasi_pencatatan_keuangan
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

## 📱 Screenshot & Fitur Detail

### 1. Home Screen (Dashboard)
- Menampilkan total saldo
- Card untuk pemasukan dan pengeluaran
- Filter transaksi (Semua, Pemasukan, Pengeluaran)
- List semua transaksi
- Pull to refresh untuk update data
- Floating action button untuk tambah transaksi

### 2. Add/Edit Transaction Screen
- Form input judul transaksi
- Input jumlah dalam format Rupiah
- Pilihan tipe (Pemasukan/Pengeluaran)
- Dropdown kategori dinamis berdasarkan tipe
- Date picker untuk memilih tanggal
- Field deskripsi opsional
- Validasi form

### 3. Transaction Detail Screen
- Tampilan detail transaksi
- Icon untuk edit dan hapus transaksi
- Konfirmasi dialog sebelum hapus

## 🎯 Kategori Transaksi

### Pemasukan:
- Gaji
- Bonus
- Investasi
- Hadiah
- Lainnya

### Pengeluaran:
- Makanan
- Transportasi
- Belanja
- Hiburan
- Kesehatan
- Pendidikan
- Tagihan
- Lainnya

## 💾 Database Schema

```sql
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  amount REAL NOT NULL,
  type TEXT NOT NULL,
  category TEXT NOT NULL,
  date TEXT NOT NULL,
  description TEXT
);
```

## 🎨 Design Pattern

Aplikasi ini mengikuti **GetX Pattern** dengan pemisahan:
- **Model** - Representasi data
- **Provider** - Database operations
- **Repository** - Business logic layer
- **Controller** - State management
- **View** - UI layer
- **Binding** - Dependency injection

## 📝 Fitur GetX yang Digunakan

1. **State Management**
   - Reactive programming dengan `.obs`
   - Auto rebuild dengan `Obx()`
   - GetX Controller lifecycle

2. **Route Management**
   - Named routes
   - Route binding
   - Parameter passing
   - Result handling

3. **Dependency Injection**
   - Lazy instantiation dengan `Get.lazyPut()`
   - Auto dispose
   - Binding classes

## 🔄 CRUD Operations

- **Create** - Tambah transaksi baru
- **Read** - Tampilkan semua transaksi, filter by type
- **Update** - Edit transaksi existing
- **Delete** - Hapus transaksi dengan konfirmasi

## 🌐 Localization

- Format tanggal: Indonesia (dd MMM yyyy)
- Format mata uang: Rupiah (Rp)
- Locale: id_ID

## 📈 Future Improvements

- [ ] Export data ke Excel/PDF
- [ ] Grafik statistik pengeluaran
- [ ] Budget planning
- [ ] Reminder untuk tagihan
- [ ] Multi-currency support
- [ ] Dark mode
- [ ] Backup & restore data
- [ ] Biometric authentication

## 👨‍💻 Developer

**Kadha**

Aplikasi ini dibuat sebagai bagian dari **Skill Test Magang Hub Kemnaker - Mobile Flutter Developer**.

## 📄 License

This project is for educational purposes.

