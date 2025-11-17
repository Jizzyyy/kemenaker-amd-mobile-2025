import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/currency_input_formatter.dart';
import '../controllers/add_transaction_controller.dart';

class AddTransactionView extends GetView<AddTransactionController> {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.editingTransaction != null
              ? 'Edit Transaksi'
              : 'Tambah Transaksi',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selection
              const Text(
                'Tipe Transaksi',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      'Pengeluaran',
                      'expense',
                      Icons.arrow_upward,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeButton(
                      'Pemasukan',
                      'income',
                      Icons.arrow_downward,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title Input
              const Text(
                'Judul',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.titleController,
                style: const TextStyle(fontFamily: 'SFMedium', fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Masukkan judul transaksi',
                  hintStyle: const TextStyle(fontFamily: 'SFMedium'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Amount Input
              const Text(
                'Jumlah',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontFamily: 'SFMedium', fontSize: 16),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah',
                  hintStyle: const TextStyle(fontFamily: 'SFMedium'),
                  prefixText: 'Rp ',
                  prefixStyle: const TextStyle(fontFamily: 'SFMedium'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Category Selection
              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value,
                style: const TextStyle(
                  fontFamily: 'SFBold',
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: controller.currentCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(fontFamily: 'SFMedium', fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.setCategory(value);
                  }
                },
              ),
              const SizedBox(height: 20),

              // Date Picker
              const Text(
                'Tanggal',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => controller.pickDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMMM yyyy')
                            .format(controller.selectedDate.value),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFSemibold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description Input
              const Text(
                'Deskripsi (Opsional)',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                style: const TextStyle(fontFamily: 'SFMedium', fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi',
                  hintStyle: const TextStyle(fontFamily: 'SFMedium'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Image Attachment
              const Text(
                'Lampiran Gambar (Opsional)',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'SFSemibold',
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.selectedImage.value != null) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          controller.selectedImage.value!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: controller.removeImage,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return InkWell(
                    onTap: controller.showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!, width: 2, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk menambah gambar',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontFamily: 'SFSemibold',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nota belanja atau bukti pembayaran',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontFamily: 'SFSemibold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    controller.editingTransaction != null
                        ? 'Update Transaksi'
                        : 'Simpan Transaksi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'SFSemibold',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTypeButton(
      String label, String type, IconData icon, Color color) {
    return Obx(() {
      final isSelected = controller.selectedType.value == type;
      return InkWell(
        onTap: () => controller.setType(type),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontFamily: 'SFSemibold',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
