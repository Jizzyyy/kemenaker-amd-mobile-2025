import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../routes/app_pages.dart';

class AddTransactionController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();
  final ImagePicker _picker = ImagePicker();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedType = 'expense'.obs;
  final selectedCategory = ''.obs;
  final selectedDate = DateTime.now().obs;
  final isLoading = false.obs;
  final selectedImage = Rx<File?>(null);
  final selectedImagePath = ''.obs;

  TransactionModel? editingTransaction;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  final List<String> incomeCategories = [
    'Gaji',
    'Bonus',
    'Investasi',
    'Hadiah',
    'Lainnya',
  ];

  final List<String> expenseCategories = [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Hiburan',
    'Kesehatan',
    'Pendidikan',
    'Tagihan',
    'Lainnya',
  ];

  @override
  void onInit() {
    super.onInit();
    // Check if editing existing transaction
    if (Get.arguments != null && Get.arguments is TransactionModel) {
      editingTransaction = Get.arguments;
      _loadTransactionData();
    } else {
      selectedCategory.value = expenseCategories[0];
    }
  }

  void _loadTransactionData() {
    if (editingTransaction != null) {
      titleController.text = editingTransaction!.title;
      amountController.text = _formatCurrencyInput(editingTransaction!.amount);
      descriptionController.text = editingTransaction!.description ?? '';
      selectedType.value = editingTransaction!.type;
      selectedCategory.value = editingTransaction!.category;
      selectedDate.value = editingTransaction!.date;
      
      // Load existing image if available
      if (editingTransaction!.imagePath != null && editingTransaction!.imagePath!.isNotEmpty) {
        selectedImagePath.value = editingTransaction!.imagePath!;
        selectedImage.value = File(editingTransaction!.imagePath!);
      }
    }
  }

  List<String> get currentCategories {
    return selectedType.value == 'income'
        ? incomeCategories
        : expenseCategories;
  }

  String _formatCurrencyInput(double amount) {
    return _currencyFormat.format(amount).replaceAll(',', '.');
  }

  double _parseCurrencyInput(String input) {
    // Remove all non-digit characters except comma and dot
    String cleanInput = input.replaceAll(RegExp(r'[^0-9,.]'), '');
    // Replace dot (thousand separator) with empty string
    cleanInput = cleanInput.replaceAll('.', '');
    // Replace comma (decimal separator) with dot for parsing
    cleanInput = cleanInput.replaceAll(',', '.');
    return double.tryParse(cleanInput) ?? 0;
  }

  void setType(String type) {
    selectedType.value = type;
    // Reset category when type changes
    selectedCategory.value = currentCategories[0];
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setDate(picked);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
    selectedImagePath.value = '';
  }

  void showImageSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveTransaction() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      final transaction = TransactionModel(
        id: editingTransaction?.id,
        title: titleController.text.trim(),
        amount: _parseCurrencyInput(amountController.text),
        type: selectedType.value,
        category: selectedCategory.value,
        date: selectedDate.value,
        description: descriptionController.text.trim(),
        imagePath: selectedImagePath.value.isEmpty ? null : selectedImagePath.value,
      );

      if (editingTransaction != null) {
        await _repository.updateTransaction(transaction);
        Get.snackbar(
          'Sukses',
          'Transaksi berhasil diupdate',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        await _repository.addTransaction(transaction);
        Get.snackbar(
          'Sukses',
          'Transaksi berhasil ditambahkan',
          snackPosition: SnackPosition.TOP,
        );
      }

      // Navigate to home page
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan transaksi',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi',
        'Judul tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (amountController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi',
        'Jumlah tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    final amount = _parseCurrencyInput(amountController.text);
    if (amount <= 0) {
      Get.snackbar(
        'Validasi',
        'Jumlah harus berupa angka yang valid',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        'Validasi',
        'Kategori tidak boleh kosong',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
