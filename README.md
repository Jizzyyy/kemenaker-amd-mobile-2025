# Aplikasi Pencatatan Keuangan

Aplikasi pencatatan keuangan pribadi berbasis Flutter dengan state management GetX.

## Fitur Utama

- ✅ **Dashboard Keuangan** - Menampilkan ringkasan total saldo, pemasukan, dan pengeluaran
- ✅ **Tambah Transaksi** - Mencatat transaksi pemasukan dan pengeluaran
- ✅ **Edit Transaksi** - Mengubah data transaksi yang sudah ada
- ✅ **Hapus Transaksi** - Menghapus transaksi yang tidak diperlukan
- ✅ **Detail Transaksi** - Melihat detail lengkap dari setiap transaksi
- ✅ **Filter Transaksi** - Filter berdasarkan tipe (Semua, Pemasukan, Pengeluaran)
- ✅ **Kategori Transaksi** - Kategorisasi transaksi untuk pemasukan dan pengeluaran
- ✅ **Penyimpanan Lokal** - Data disimpan menggunakan SQLite
- ✅ **Format Rupiah** - Tampilan mata uang dalam format Rupiah (Rp)

## Teknologi yang Digunakan

- **Flutter SDK** - Framework untuk membuat aplikasi mobile
- **GetX** (^4.6.6) - State Management, Dependency Injection, dan Route Management
- **SQLite** (sqflite ^2.3.0) - Database lokal
- **Intl** (^0.19.0) - Format tanggal dan mata uang

## CRUD Operations

- **Create** - Tambah transaksi baru
- **Read** - Tampilkan semua transaksi, filter by type
- **Update** - Edit transaksi existing
- **Delete** - Hapus transaksi dengan konfirmasi

## Localization

- Format tanggal: Indonesia (dd MMM yyyy)
- Format mata uang: Rupiah (Rp)
- Locale: id_ID
