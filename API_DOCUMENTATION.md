# API & Functions Documentation

## 📖 Dokumentasi Lengkap Fungsi dan API Aplikasi

---

## 1. TransactionModel

Model data untuk transaksi keuangan.

### Properties

```dart
class TransactionModel {
  final int? id;              // ID unik (auto increment)
  final String title;         // Judul transaksi
  final double amount;        // Jumlah uang
  final String type;          // 'income' atau 'expense'
  final String category;      // Kategori transaksi
  final DateTime date;        // Tanggal transaksi
  final String? description;  // Deskripsi (opsional)
}
```

### Methods

**toMap()** - Convert model ke Map untuk database
```dart
Map<String, dynamic> toMap()
```

**fromMap()** - Create model dari Map
```dart
factory TransactionModel.fromMap(Map<String, dynamic> map)
```

**copyWith()** - Create copy dengan perubahan tertentu
```dart
TransactionModel copyWith({...})
```

---

## 2. DatabaseProvider

Provider untuk operasi database SQLite.

### Singleton Instance

```dart
DatabaseProvider.instance
```

### Methods

#### create()
Menambah transaksi baru ke database.

```dart
Future<int> create(TransactionModel transaction)
```
**Returns:** ID transaksi yang baru ditambahkan

**Example:**
```dart
final id = await DatabaseProvider.instance.create(transaction);
```

#### read()
Membaca satu transaksi berdasarkan ID.

```dart
Future<TransactionModel?> read(int id)
```
**Parameters:**
- `id`: ID transaksi

**Returns:** TransactionModel atau null jika tidak ditemukan

#### readAll()
Membaca semua transaksi (diurutkan dari terbaru).

```dart
Future<List<TransactionModel>> readAll()
```
**Returns:** List semua transaksi

#### readByType()
Membaca transaksi berdasarkan tipe.

```dart
Future<List<TransactionModel>> readByType(String type)
```
**Parameters:**
- `type`: 'income' atau 'expense'

**Returns:** List transaksi sesuai tipe

#### update()
Mengupdate transaksi yang sudah ada.

```dart
Future<int> update(TransactionModel transaction)
```
**Returns:** Jumlah row yang di-update

#### delete()
Menghapus transaksi berdasarkan ID.

```dart
Future<int> delete(int id)
```
**Returns:** Jumlah row yang dihapus

---

## 3. TransactionRepository

Repository layer untuk business logic.

### Methods

#### addTransaction()
```dart
Future<int> addTransaction(TransactionModel transaction)
```
Menambah transaksi baru.

#### getAllTransactions()
```dart
Future<List<TransactionModel>> getAllTransactions()
```
Mendapatkan semua transaksi.

#### getTransactionsByType()
```dart
Future<List<TransactionModel>> getTransactionsByType(String type)
```
Filter transaksi berdasarkan tipe (income/expense).

#### getTransactionById()
```dart
Future<TransactionModel?> getTransactionById(int id)
```
Mendapatkan detail satu transaksi.

#### updateTransaction()
```dart
Future<int> updateTransaction(TransactionModel transaction)
```
Update transaksi existing.

#### deleteTransaction()
```dart
Future<int> deleteTransaction(int id)
```
Hapus transaksi.

#### getTotalIncome()
```dart
Future<double> getTotalIncome()
```
Hitung total pemasukan.

#### getTotalExpense()
```dart
Future<double> getTotalExpense()
```
Hitung total pengeluaran.

#### getBalance()
```dart
Future<double> getBalance()
```
Hitung saldo (pemasukan - pengeluaran).

---

## 4. HomeController

Controller untuk halaman utama.

### Observable Variables

```dart
final transactions = <TransactionModel>[].obs;
final filteredTransactions = <TransactionModel>[].obs;
final totalIncome = 0.0.obs;
final totalExpense = 0.0.obs;
final balance = 0.0.obs;
final isLoading = false.obs;
final selectedFilter = 'all'.obs;
```

### Methods

#### loadTransactions()
```dart
Future<void> loadTransactions()
```
Memuat semua transaksi dari database dan menghitung total.

**Usage:**
```dart
await controller.loadTransactions();
```

#### calculateTotals()
```dart
Future<void> calculateTotals()
```
Menghitung total income, expense, dan balance.

#### filterTransactions()
```dart
void filterTransactions(String filter)
```
Filter transaksi berdasarkan tipe.

**Parameters:**
- `filter`: 'all', 'income', atau 'expense'

**Usage:**
```dart
controller.filterTransactions('income');
```

#### deleteTransaction()
```dart
Future<void> deleteTransaction(int id)
```
Menghapus transaksi dan reload data.

#### goToAddTransaction()
```dart
void goToAddTransaction()
```
Navigasi ke halaman tambah transaksi.

#### goToTransactionDetail()
```dart
void goToTransactionDetail(TransactionModel transaction)
```
Navigasi ke halaman detail transaksi.

---

## 5. AddTransactionController

Controller untuk tambah/edit transaksi.

### Text Controllers

```dart
final titleController = TextEditingController();
final amountController = TextEditingController();
final descriptionController = TextEditingController();
```

### Observable Variables

```dart
final selectedType = 'expense'.obs;
final selectedCategory = ''.obs;
final selectedDate = DateTime.now().obs;
final isLoading = false.obs;
```

### Properties

```dart
TransactionModel? editingTransaction;  // Null jika mode tambah
final List<String> incomeCategories;   // List kategori pemasukan
final List<String> expenseCategories;  // List kategori pengeluaran
```

### Computed Properties

```dart
List<String> get currentCategories
```
Return kategori sesuai dengan tipe yang dipilih.

### Methods

#### setType()
```dart
void setType(String type)
```
Set tipe transaksi ('income' atau 'expense').

#### setCategory()
```dart
void setCategory(String category)
```
Set kategori transaksi.

#### setDate()
```dart
void setDate(DateTime date)
```
Set tanggal transaksi.

#### pickDate()
```dart
Future<void> pickDate(BuildContext context)
```
Menampilkan date picker.

#### saveTransaction()
```dart
Future<void> saveTransaction()
```
Validasi dan simpan transaksi (create atau update).

**Validation:**
- Title tidak boleh kosong
- Amount harus valid number > 0
- Category tidak boleh kosong

---

## 6. TransactionDetailController

Controller untuk detail transaksi.

### Properties

```dart
late TransactionModel transaction;
final isLoading = false.obs;
```

### Methods

#### deleteTransaction()
```dart
Future<void> deleteTransaction()
```
Menampilkan konfirmasi dan menghapus transaksi.

**Flow:**
1. Tampilkan dialog konfirmasi
2. Jika user konfirmasi, hapus transaksi
3. Kembali ke halaman sebelumnya
4. Tampilkan snackbar sukses/error

#### editTransaction()
```dart
void editTransaction()
```
Navigasi ke halaman edit dengan membawa data transaksi.

---

## 7. Routes

### Available Routes

```dart
Routes.HOME                 // '/home'
Routes.ADD_TRANSACTION      // '/add-transaction'
Routes.TRANSACTION_DETAIL   // '/transaction-detail'
Routes.EDIT_TRANSACTION     // '/edit-transaction'
```

### Navigation Examples

```dart
// Ke halaman tambah
Get.toNamed(Routes.ADD_TRANSACTION);

// Ke detail dengan data
Get.toNamed(
  Routes.TRANSACTION_DETAIL,
  arguments: transaction,
);

// Ke edit dengan data
Get.toNamed(
  Routes.EDIT_TRANSACTION,
  arguments: transaction,
);

// Kembali dengan result
Get.back(result: true);
```

---

## 8. Bindings

### HomeBinding
```dart
Get.lazyPut<HomeController>(() => HomeController());
```

### AddTransactionBinding
```dart
Get.lazyPut<AddTransactionController>(() => AddTransactionController());
```

### TransactionDetailBinding
```dart
Get.lazyPut<TransactionDetailController>(() => TransactionDetailController());
```

---

## 9. Utilities & Helpers

### Currency Formatting

```dart
String _formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
```

**Example:**
```dart
_formatCurrency(1000000)  // Output: "Rp 1.000.000"
```

### Date Formatting

```dart
DateFormat('dd MMM yyyy').format(date)      // "17 Nov 2025"
DateFormat('dd MMMM yyyy').format(date)     // "17 November 2025"
```

---

## 10. Database Schema

### Table: transactions

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT | ID unik |
| title | TEXT | NOT NULL | Judul transaksi |
| amount | REAL | NOT NULL | Jumlah uang |
| type | TEXT | NOT NULL | 'income' atau 'expense' |
| category | TEXT | NOT NULL | Kategori |
| date | TEXT | NOT NULL | ISO 8601 format |
| description | TEXT | NULL | Deskripsi opsional |

---

## 11. Error Handling

Semua operasi async menggunakan try-catch dengan snackbar feedback:

```dart
try {
  isLoading.value = true;
  await _repository.deleteTransaction(id);
  Get.snackbar('Sukses', 'Transaksi berhasil dihapus');
} catch (e) {
  Get.snackbar('Error', 'Gagal menghapus transaksi');
} finally {
  isLoading.value = false;
}
```

---

## 12. State Management Flow

### Data Flow Diagram

```
User Action → Controller Method → Repository → Database Provider → SQLite
                    ↓                              ↓
              Update State ← Return Data ← Return Result
                    ↓
              UI Auto Rebuild (Obx)
```

### Example Flow: Add Transaction

1. User tap FAB
2. `HomeController.goToAddTransaction()` dipanggil
3. Navigate ke `AddTransactionView`
4. User isi form dan tap save
5. `AddTransactionController.saveTransaction()` dipanggil
6. Validasi form
7. `TransactionRepository.addTransaction()` dipanggil
8. `DatabaseProvider.create()` insert ke SQLite
9. Return ke `HomeView` dengan result
10. `HomeController.loadTransactions()` refresh data
11. UI auto rebuild dengan data baru

---

## 13. Testing Endpoints

### Manual Testing Checklist

#### Home Screen
- [ ] Tampil total saldo, income, expense dengan benar
- [ ] Filter 'Semua' menampilkan semua transaksi
- [ ] Filter 'Pemasukan' hanya menampilkan income
- [ ] Filter 'Pengeluaran' hanya menampilkan expense
- [ ] Pull to refresh berfungsi
- [ ] Tap transaksi membuka detail

#### Add Transaction Screen
- [ ] Form validation berfungsi
- [ ] Type selection mengubah kategori
- [ ] Date picker berfungsi
- [ ] Save berhasil dan kembali ke home
- [ ] Data baru muncul di home

#### Edit Transaction Screen
- [ ] Data lama ter-load dengan benar
- [ ] Update berhasil
- [ ] Data ter-update di home

#### Transaction Detail Screen
- [ ] Detail tampil lengkap
- [ ] Edit button membuka edit screen
- [ ] Delete dengan konfirmasi berfungsi
- [ ] Data terhapus dari home

---

## 📊 Performance Metrics

- **Startup time:** < 2 detik
- **Database query:** < 100ms untuk < 1000 records
- **UI rebuild:** Hanya widget yang berubah (optimized dengan Obx)
- **Memory usage:** Efficient dengan auto dispose controller

---

## 🔒 Data Persistence

Data disimpan secara lokal menggunakan SQLite dan akan persist meskipun aplikasi ditutup. Path database:

- **Android:** `/data/data/<package>/databases/transactions.db`
- **iOS:** `Library/Application Support/transactions.db`

---

## 💡 Tips Development

1. **Debugging:** Gunakan `Get.printInfo()` untuk logging
2. **State inspection:** Install GetX Dev Tools
3. **Database inspection:** Gunakan SQLite browser untuk cek database
4. **Hot reload:** GetX support full hot reload tanpa lose state

---

**Last Updated:** November 2025
