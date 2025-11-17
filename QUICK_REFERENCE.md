# 🚀 Quick Reference - Fitur Baru

## ✨ 2 Fitur Baru Telah Ditambahkan!

---

## 1️⃣ **ONBOARDING SCREEN**

### 📍 Lokasi
- File: `lib/app/modules/onboarding/`
- Route: `/onboarding`
- Initial route: `/` (Splash) → Auto redirect

### 🎯 Fungsi
Memperkenalkan aplikasi kepada pengguna pertama kali menggunakannya.

### 📱 3 Halaman Onboarding:

#### Page 1: Kelola Keuangan
- Icon: Wallet (Blue)
- Pesan: "Catat semua transaksi pemasukan dan pengeluaran Anda dengan mudah"

#### Page 2: Pantau Pengeluaran
- Icon: Analytics (Green)
- Pesan: "Lihat ringkasan keuangan dan kontrol pengeluaran Anda setiap saat"

#### Page 3: Lampirkan Bukti
- Icon: Camera (Orange)
- Pesan: "Simpan foto nota atau bukti pembayaran untuk setiap transaksi"

### 🎮 Kontrol
- **Lewati** - Skip langsung ke home
- **Selanjutnya** - Ke halaman berikutnya
- **Mulai** - Mulai gunakan aplikasi (halaman terakhir)
- **Swipe** - Geser ke kiri/kanan

### 💾 Status Penyimpanan
```dart
SharedPreferences: 'onboarding_complete' = true
```

### 🔄 Reset Onboarding (untuk testing)
```dart
// Di Dart console atau debug
final prefs = await SharedPreferences.getInstance();
await prefs.remove('onboarding_complete');
// Restart app
```

---

## 2️⃣ **UPLOAD GAMBAR TRANSAKSI**

### 📍 Lokasi
- Controller: `AddTransactionController`
- View: `AddTransactionView`
- Detail: `TransactionDetailView`

### 🎯 Fungsi
Menambahkan foto nota belanja atau bukti pembayaran ke transaksi.

### 📸 Cara Upload:

#### Step 1: Tambah Transaksi
1. Tap FAB (+) di home
2. Isi form transaksi
3. Scroll ke bawah ke section "Lampiran Gambar"

#### Step 2: Pilih Sumber
Tap area "Tambah gambar" → Pilih:
- **📷 Kamera** - Foto langsung
- **🖼️ Galeri** - Pilih dari galeri

#### Step 3: Preview & Save
- Preview gambar muncul
- Tap **X merah** untuk hapus
- Tap **Simpan** untuk save transaksi

### 🖼️ Spesifikasi Gambar:
- **Max Width:** 1920px
- **Max Height:** 1080px
- **Quality:** 85%
- **Format:** JPG, PNG
- **Storage:** Local device

### 👁️ Lihat Gambar:
1. Tap transaksi di list
2. Scroll ke bawah di detail
3. Gambar tampil full width (jika ada)

### 🗑️ Hapus Gambar:
- **Sebelum save:** Tap X merah di preview
- **Setelah save:** Edit transaksi → Tap X merah

---

## 🛠️ **Technical Details**

### Database Schema V2
```sql
-- New column
imagePath TEXT
```

### Model Update
```dart
class TransactionModel {
  final String? imagePath; // NEW!
  // ... other fields
}
```

### Controller Methods
```dart
// Pick image
controller.showImageSourceDialog()
controller.pickImage(ImageSource.camera)
controller.pickImage(ImageSource.gallery)

// Remove image
controller.removeImage()

// Observable
controller.selectedImage  // Rx<File?>
controller.selectedImagePath  // RxString
```

---

## 📝 **Testing Scenarios**

### ✅ Onboarding Test:
```
1. Fresh install → Onboarding muncul ✓
2. Complete onboarding → Home screen ✓
3. Second launch → Skip onboarding ✓
4. Tap "Lewati" → Langsung home ✓
5. Swipe gestures → Smooth ✓
```

### ✅ Image Upload Test:
```
1. Choose camera → Permission request ✓
2. Take photo → Preview muncul ✓
3. Choose gallery → Image picker open ✓
4. Select image → Preview muncul ✓
5. Tap X → Image hilang ✓
6. Save transaction → Image tersimpan ✓
7. View detail → Image tampil ✓
8. Edit transaction → Image tetap ada ✓
9. Close & reopen app → Image persist ✓
```

---

## 🎨 **UI Components**

### Splash Screen
```dart
Duration: 2 seconds
Background: Blue gradient
Icon: Wallet icon in white circle
Loading: CircularProgressIndicator
```

### Onboarding
```dart
PageView: 3 pages
Indicator: Smooth dots (WormEffect)
Skip button: Top right
CTA button: Bottom (full width)
```

### Image Upload
```dart
Empty state: Dashed border, icon, hint text
With image: Full preview, delete button
Error state: Broken image icon
```

---

## 🔧 **Configuration**

### Permissions (Android)
```xml
CAMERA - Untuk foto langsung
READ_EXTERNAL_STORAGE - Baca galeri
WRITE_EXTERNAL_STORAGE - Simpan foto
READ_MEDIA_IMAGES - Android 13+
```

### Permissions (iOS)
Tambahkan di `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Untuk mengambil foto nota/bukti</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Untuk memilih gambar dari galeri</string>
```

---

## 💡 **Tips & Tricks**

### Performance:
- Gambar auto-resize ke max 1920x1080
- Quality 85% untuk balance size/quality
- Lazy loading di list (hanya load saat buka detail)

### UX:
- Preview sebelum save
- Easy delete dengan X merah
- Clear placeholder ketika kosong
- Error handling jika file hilang

### Storage:
- Path gambar tersimpan di DB
- File gambar di local storage
- Tetap ada setelah app restart

---

## 🎯 **Quick Commands**

### Reset semua data (fresh start):
```bash
flutter clean
flutter pub get
flutter run
```

### Clear onboarding status:
```dart
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

### Check database version:
```dart
final db = await DatabaseProvider.instance.database;
print('DB Version: ${await db.getVersion()}'); // Should be 2
```

---

## 🚨 **Troubleshooting**

### Issue: Onboarding selalu muncul
**Fix:** Check SharedPreferences, pastikan `onboarding_complete` saved

### Issue: Camera tidak bisa diakses
**Fix:** 
1. Check permissions di AndroidManifest.xml
2. Grant permission manual di Settings → Apps

### Issue: Gambar tidak muncul di detail
**Fix:**
1. Check file path masih valid
2. Check file belum dihapus manual
3. Check permission READ_EXTERNAL_STORAGE

### Issue: Database error setelah update
**Fix:**
1. Uninstall app
2. Install ulang
3. Database akan create fresh dengan schema v2

---

## 📚 **Related Files**

### Onboarding:
```
lib/app/modules/splash/
├── bindings/splash_binding.dart
├── controllers/splash_controller.dart
└── views/splash_view.dart

lib/app/modules/onboarding/
├── bindings/onboarding_binding.dart
├── controllers/onboarding_controller.dart
└── views/onboarding_view.dart
```

### Image Upload:
```
lib/app/data/models/transaction_model.dart
lib/app/data/providers/database_provider.dart
lib/app/modules/add_transaction/
└── controllers/add_transaction_controller.dart
    └── views/add_transaction_view.dart
lib/app/modules/transaction_detail/
└── views/transaction_detail_view.dart
```

---

## ✅ **Checklist Completion**

| Feature | Status | Notes |
|---------|--------|-------|
| Splash Screen | ✅ | 2s loading + redirect |
| Onboarding 3 pages | ✅ | With indicators |
| Skip onboarding | ✅ | Button + auto-skip |
| Camera upload | ✅ | With permissions |
| Gallery upload | ✅ | Image picker |
| Image preview | ✅ | Before save |
| Image display | ✅ | In detail screen |
| Image delete | ✅ | X button |
| Database migration | ✅ | V1 → V2 |
| Local storage | ✅ | SQLite + SharedPref |

**All Features: 10/10 Complete! ✅**

---

**Aplikasi siap digunakan dengan semua fitur lengkap!** 🎉

Tinggal tambahkan **Icon Aplikasi** secara manual dan aplikasi ready untuk production! 🚀
