# 🚀 Quick Start Guide

## Panduan Cepat Menjalankan Aplikasi Pencatatan Keuangan

---

## ⚡ 3 Langkah Mudah

### 1️⃣ Check Dependencies
```bash
flutter pub get
```
✅ Sudah dilakukan! Skip step ini.

### 2️⃣ Run Application
```bash
flutter run
```

### 3️⃣ Pilih Device
Aplikasi akan menampilkan list device yang tersedia:
- Android Emulator
- iOS Simulator (jika di Mac)
- Chrome (Web)
- Windows Desktop

---

## 📱 Demo Flow - Coba Aplikasi

### ✅ Scenario 1: Tambah Pemasukan
1. **Buka aplikasi** → Muncul dashboard dengan saldo 0
2. **Tap tombol +** (Floating Action Button)
3. **Tap "Pemasukan"** (tombol hijau)
4. **Isi form:**
   - Judul: `Gaji Bulanan`
   - Jumlah: `5000000`
   - Kategori: `Gaji`
   - Tanggal: (pilih tanggal hari ini)
   - Deskripsi: `Gaji bulan November`
5. **Tap "Simpan Transaksi"**
6. **Lihat hasilnya:**
   - Saldo: Rp 5.000.000
   - Total Pemasukan: Rp 5.000.000
   - Transaksi muncul di list

### ✅ Scenario 2: Tambah Pengeluaran
1. **Tap tombol +** lagi
2. **Pilih "Pengeluaran"** (tombol merah)
3. **Isi form:**
   - Judul: `Belanja Bulanan`
   - Jumlah: `1500000`
   - Kategori: `Belanja`
   - Tanggal: (hari ini)
4. **Simpan**
5. **Lihat update:**
   - Saldo: Rp 3.500.000 (5jt - 1.5jt)
   - Total Pengeluaran: Rp 1.500.000

### ✅ Scenario 3: Filter & Detail
1. **Tap chip "Pemasukan"** → Hanya tampil gaji
2. **Tap chip "Pengeluaran"** → Hanya tampil belanja
3. **Tap chip "Semua"** → Tampil semua
4. **Tap salah satu transaksi** → Lihat detail lengkap

### ✅ Scenario 4: Edit Transaksi
1. **Tap transaksi** untuk lihat detail
2. **Tap icon Edit (✏️)** di app bar
3. **Ubah data** (misalnya jumlah)
4. **Tap "Update Transaksi"**
5. **Lihat perubahan** di dashboard

### ✅ Scenario 5: Hapus Transaksi
1. **Tap transaksi** untuk lihat detail
2. **Tap icon Delete (🗑️)** di app bar
3. **Konfirmasi** dengan tap "Hapus"
4. **Transaksi terhapus** dan saldo update

---

## 🎯 Fitur yang Bisa Dicoba

### Dashboard (Home Screen)
- ✅ Pull to refresh
- ✅ Filter transaksi
- ✅ Lihat total saldo real-time
- ✅ Tap transaksi untuk detail

### Form Transaksi
- ✅ Toggle antara Pemasukan/Pengeluaran
- ✅ Dropdown kategori berubah otomatis
- ✅ Date picker dengan calendar
- ✅ Validasi input (coba kosongkan form)
- ✅ Format angka otomatis dengan prefix "Rp"

### Detail Transaksi
- ✅ Beautiful header dengan icon
- ✅ Info lengkap (judul, kategori, tanggal, deskripsi)
- ✅ Quick action buttons (Edit & Delete)

---

## 🎨 Eksplorasi Kategori

### Coba semua kategori Pemasukan:
- [ ] Gaji - contoh: Gaji bulanan
- [ ] Bonus - contoh: Bonus kinerja
- [ ] Investasi - contoh: Dividen saham
- [ ] Hadiah - contoh: Angpao
- [ ] Lainnya - contoh: Freelance project

### Coba semua kategori Pengeluaran:
- [ ] Makanan - contoh: Makan siang
- [ ] Transportasi - contoh: Bensin motor
- [ ] Belanja - contoh: Belanja bulanan
- [ ] Hiburan - contoh: Nonton bioskop
- [ ] Kesehatan - contoh: Beli obat
- [ ] Pendidikan - contoh: Beli buku
- [ ] Tagihan - contoh: Bayar listrik
- [ ] Lainnya - contoh: Lain-lain

---

## 🔍 Testing Checklist

### Basic Operations
- [ ] Tambah transaksi pemasukan
- [ ] Tambah transaksi pengeluaran
- [ ] Edit transaksi
- [ ] Hapus transaksi
- [ ] Total saldo terhitung benar

### UI/UX
- [ ] Filter "Semua" bekerja
- [ ] Filter "Pemasukan" bekerja
- [ ] Filter "Pengeluaran" bekerja
- [ ] Pull to refresh bekerja
- [ ] Navigasi smooth tanpa lag

### Edge Cases
- [ ] Form validation (field kosong)
- [ ] Amount validation (huruf/0/negatif)
- [ ] Delete confirmation muncul
- [ ] Cancel tidak hapus data
- [ ] Back button berfungsi

### Data Persistence
- [ ] Tutup aplikasi
- [ ] Buka lagi aplikasi
- [ ] Data masih ada (tersimpan di SQLite)

---

## 💡 Tips Penggunaan

### 1. Format Angka
Cukup ketik angka saja tanpa titik/koma:
- ✅ Good: `1500000` atau `1500000`
- ❌ Avoid: `1.500.000` atau `1,500,000`

### 2. Deskripsi Opsional
Field deskripsi tidak wajib diisi, tapi berguna untuk catatan detail.

### 3. Filter Cepat
Gunakan chip filter untuk melihat kategori tertentu dengan cepat.

### 4. Pull to Refresh
Swipe down di list untuk refresh data (jika ada update dari database).

### 5. Tap untuk Detail
Semua item di list bisa di-tap untuk lihat detail lengkap.

---

## 🐛 Troubleshooting

### Issue: "No devices found"
**Solution:**
```bash
# Check available devices
flutter devices

# Start emulator
flutter emulators
flutter emulators --launch <emulator_id>
```

### Issue: "Packages not found"
**Solution:**
```bash
flutter clean
flutter pub get
```

### Issue: "Build failed"
**Solution:**
```bash
# For Android
flutter clean
cd android
./gradlew clean
cd ..
flutter run

# For iOS (Mac only)
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

### Issue: Database tidak tersimpan
**Solution:**
- Data tersimpan otomatis di SQLite
- Cek di device storage: `/data/data/<package>/databases/`
- Untuk reset: Uninstall dan install ulang app

---

## 📊 Sample Data untuk Testing

### Skenario Lengkap: Bulan November 2025

#### Pemasukan:
1. Gaji - Rp 5.000.000 (01 Nov)
2. Bonus - Rp 2.000.000 (15 Nov)
3. Freelance - Rp 3.500.000 (20 Nov)

#### Pengeluaran:
1. Belanja - Rp 1.500.000 (02 Nov)
2. Listrik - Rp 400.000 (05 Nov)
3. Bensin - Rp 300.000 (10 Nov)
4. Makan - Rp 1.200.000 (15 Nov)
5. Hiburan - Rp 500.000 (18 Nov)

**Expected Result:**
- Total Pemasukan: Rp 10.500.000
- Total Pengeluaran: Rp 3.900.000
- Saldo: Rp 6.600.000

---

## 🎓 Learning Path

### Level 1 - Basic (5 menit)
1. ✅ Jalankan aplikasi
2. ✅ Tambah 1 transaksi
3. ✅ Lihat detail
4. ✅ Edit transaksi

### Level 2 - Intermediate (10 menit)
1. ✅ Tambah 5-10 transaksi berbeda
2. ✅ Coba semua kategori
3. ✅ Test filter
4. ✅ Test hapus dengan konfirmasi

### Level 3 - Advanced (15 menit)
1. ✅ Explore code di `lib/`
2. ✅ Baca `GETX_GUIDE.md`
3. ✅ Pahami struktur controller
4. ✅ Lihat database implementation

### Level 4 - Expert (30 menit+)
1. ✅ Baca `API_DOCUMENTATION.md`
2. ✅ Modify UI/UX
3. ✅ Add new features
4. ✅ Optimize performance

---

## 🎬 Video Demo (Simulasi)

```
0:00 - Launch app, tampil splash
0:02 - Home screen dengan empty state
0:05 - Tap FAB, form muncul
0:08 - Isi form transaksi pemasukan
0:15 - Save, kembali ke home dengan data
0:18 - Dashboard update dengan animasi
0:20 - Tap transaksi, detail muncul
0:23 - Tap edit, form ter-load
0:26 - Update data
0:28 - Kembali, data ter-update
0:30 - Test filter
0:35 - Test delete dengan konfirmasi
```

---

## 🚀 Ready to Go!

Aplikasi siap digunakan! Jalankan dengan:

```bash
flutter run
```

**Selamat mencoba!** 🎉

---

## 📞 Need Help?

Cek dokumentasi lengkap:
1. `README.md` - Project overview
2. `GETX_GUIDE.md` - GetX implementation
3. `API_DOCUMENTATION.md` - API reference
4. `IMPLEMENTATION_SUMMARY.md` - Complete summary

---

**Happy Testing!** ✨
