# GetX Implementation Guide

## Panduan Implementasi GetX di Aplikasi Pencatatan Keuangan

### 📚 Konsep Dasar GetX

GetX adalah salah satu state management paling populer di Flutter yang menyediakan 3 fitur utama:
1. **State Management** - Mengelola state aplikasi
2. **Route Management** - Navigasi tanpa context
3. **Dependency Management** - Injeksi dependencies

---

## 1. State Management dengan GetX

### Reactive Variables (.obs)

```dart
// Deklarasi variable reaktif
final totalIncome = 0.0.obs;
final transactions = <TransactionModel>[].obs;
final isLoading = false.obs;

// Update value
totalIncome.value = 1000000;
transactions.add(newTransaction);
isLoading.value = true;
```

### GetX Controller

Controller adalah tempat business logic dan state management:

```dart
class HomeController extends GetxController {
  // Observable variables
  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions(); // Auto dipanggil saat controller dibuat
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    // Load data from repository
    transactions.value = await repository.getAllTransactions();
    isLoading.value = false;
  }

  @override
  void onClose() {
    // Cleanup resources
    super.onClose();
  }
}
```

### Reactive UI dengan Obx()

Widget yang auto rebuild ketika observable berubah:

```dart
Obx(() => Text('Total: ${controller.totalIncome.value}'))

// Atau untuk widget lebih kompleks
Obx(() {
  if (controller.isLoading.value) {
    return CircularProgressIndicator();
  }
  return ListView.builder(...);
})
```

### GetView untuk efisiensi

```dart
class HomeView extends GetView<HomeController> {
  // 'controller' otomatis tersedia tanpa perlu Get.find()
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.totalIncome.value));
  }
}
```

---

## 2. Route Management

### Setup Routes

**app_routes.dart:**
```dart
abstract class Routes {
  static const HOME = '/home';
  static const ADD_TRANSACTION = '/add-transaction';
  static const TRANSACTION_DETAIL = '/transaction-detail';
}
```

**app_pages.dart:**
```dart
class AppPages {
  static const INITIAL = Routes.HOME;
  
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    // ... routes lainnya
  ];
}
```

### Navigasi

```dart
// Navigate ke page baru
Get.toNamed('/add-transaction');

// Navigate dengan arguments
Get.toNamed('/transaction-detail', arguments: transaction);

// Navigate dan replace
Get.offNamed('/home');

// Navigate dan hapus semua route sebelumnya
Get.offAllNamed('/home');

// Kembali ke page sebelumnya
Get.back();

// Kembali dengan result
Get.back(result: true);

// Handle result dari page
Get.toNamed('/add-transaction')?.then((result) {
  if (result == true) {
    loadTransactions();
  }
});
```

### Menerima Arguments

```dart
class TransactionDetailController extends GetxController {
  late TransactionModel transaction;
  
  @override
  void onInit() {
    super.onInit();
    transaction = Get.arguments as TransactionModel;
  }
}
```

---

## 3. Dependency Injection & Binding

### Binding Class

Mengelola lifecycle dan dependencies:

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy load - dibuat saat pertama kali dibutuhkan
    Get.lazyPut<HomeController>(() => HomeController());
    
    // Atau permanent (tidak dihapus)
    // Get.put<HomeController>(HomeController(), permanent: true);
  }
}
```

### Manual Dependency Injection

```dart
// Put - langsung membuat instance
final controller = Get.put(HomeController());

// Lazy Put - buat saat pertama kali diakses
Get.lazyPut(() => HomeController());

// Find - ambil instance yang sudah ada
final controller = Get.find<HomeController>();

// Delete - hapus instance
Get.delete<HomeController>();
```

---

## 4. Snackbar & Dialog dengan GetX

### Snackbar

```dart
Get.snackbar(
  'Sukses',
  'Transaksi berhasil ditambahkan',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.green,
  colorText: Colors.white,
);
```

### Dialog

```dart
final confirmed = await Get.dialog<bool>(
  AlertDialog(
    title: Text('Konfirmasi'),
    content: Text('Apakah Anda yakin?'),
    actions: [
      TextButton(
        onPressed: () => Get.back(result: false),
        child: Text('Batal'),
      ),
      TextButton(
        onPressed: () => Get.back(result: true),
        child: Text('Ya'),
      ),
    ],
  ),
);

if (confirmed == true) {
  // Lakukan sesuatu
}
```

### Bottom Sheet

```dart
Get.bottomSheet(
  Container(
    child: Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit'),
          onTap: () {
            Get.back();
            editTransaction();
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () {
            Get.back();
            deleteTransaction();
          },
        ),
      ],
    ),
  ),
);
```

---

## 5. Best Practices

### ✅ Do's

1. **Gunakan GetView untuk widget yang membutuhkan controller**
```dart
class HomeView extends GetView<HomeController> {
  // controller sudah tersedia
}
```

2. **Gunakan Binding untuk dependency injection**
```dart
// Lebih baik daripada Get.put() di initState
GetPage(
  name: '/home',
  page: () => HomeView(),
  binding: HomeBinding(),
)
```

3. **Cleanup di onClose()**
```dart
@override
void onClose() {
  textController.dispose();
  super.onClose();
}
```

4. **Gunakan Workers untuk listen perubahan**
```dart
@override
void onInit() {
  super.onInit();
  
  // Ever - trigger setiap kali berubah
  ever(transactions, (_) => calculateTotal());
  
  // Once - trigger sekali
  once(isLoading, (_) => print('Loading changed'));
  
  // Debounce - delay sebelum trigger
  debounce(searchQuery, (_) => search(), time: Duration(seconds: 1));
}
```

### ❌ Don'ts

1. **Jangan gunakan Get.put() di dalam build method**
2. **Jangan lupa dispose TextEditingController**
3. **Jangan nested Obx() yang tidak perlu**
4. **Jangan panggil Get.find() sebelum controller dibuat**

---

## 6. Performance Tips

### 1. Gunakan GetBuilder untuk update yang tidak sering
```dart
// Untuk performa lebih baik jika tidak perlu reaktif
GetBuilder<HomeController>(
  builder: (controller) => Text(controller.title),
)
```

### 2. Scope Obx() seminimal mungkin
```dart
// ❌ Bad - rebuild seluruh Column
Obx(() => Column(
  children: [
    Text('Static'),
    Text(controller.name.value),
  ],
))

// ✅ Good - hanya rebuild yang perlu
Column(
  children: [
    Text('Static'),
    Obx(() => Text(controller.name.value)),
  ],
)
```

### 3. Gunakan .obs hanya untuk yang perlu reaktif
```dart
// Jika tidak perlu reaktif, gunakan variable biasa
final String title = 'Title'; // Tidak perlu .obs
final count = 0.obs; // Perlu .obs karena akan berubah
```

---

## 7. Testing dengan GetX

```dart
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  // Setup
  Get.put(CounterController());
  
  await tester.pumpWidget(GetMaterialApp(home: CounterView()));
  
  // Test
  expect(find.text('0'), findsOneWidget);
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('1'), findsOneWidget);
  
  // Cleanup
  Get.delete<CounterController>();
});
```

---

## 8. Struktur Project yang Direkomendasikan

```
lib/
├── main.dart
└── app/
    ├── data/
    │   ├── models/
    │   ├── providers/
    │   └── repositories/
    ├── modules/
    │   └── [module_name]/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    ├── routes/
    │   ├── app_pages.dart
    │   └── app_routes.dart
    └── core/
        ├── utils/
        ├── values/
        └── widgets/
```

---

## 9. Lifecycle GetX Controller

```dart
class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Dipanggil 1 kali saat controller dibuat
    // Gunakan untuk inisialisasi
  }

  @override
  void onReady() {
    super.onReady();
    // Dipanggil setelah widget di-render
    // Gunakan untuk API calls
  }

  @override
  void onClose() {
    // Dipanggil sebelum controller dihapus
    // Gunakan untuk cleanup
    super.onClose();
  }
}
```

---

## 📚 Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [GetX GitHub](https://github.com/jonataslaw/getx)
- [GetX Pattern](https://github.com/kauemurakami/getx_pattern)

---

**Catatan:** Dokumentasi ini menjelaskan implementasi GetX yang digunakan di aplikasi Pencatatan Keuangan. Untuk informasi lebih detail, lihat source code di folder `lib/app/modules/`.
