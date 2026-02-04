import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';
import '../../../core/theme/gradient_theme.dart';
import '../../../core/utils/currency_input_formatter.dart';
import '../../../core/widgets/modern_text_field.dart';
import '../../../domain/entities/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/draft_transaction_provider.dart';
import '../../../domain/entities/draft_transaction.dart';
import '../../providers/spending_limit_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final int? transactionId;
  final int? draftId;

  const AddTransactionScreen({super.key, this.transactionId, this.draftId});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;

  final List<String> _expenseCategories = [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Hiburan',
    'Kesehatan',
    'Pendidikan',
    'Lainnya',
  ];

  final List<String> _incomeCategories = [
    'Gaji',
    'Bonus',
    'Investasi',
    'Hadiah',
    'Lainnya',
  ];

  List<String> get _currentCategories => _selectedType == TransactionType.income
      ? _incomeCategories
      : _expenseCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _currentCategories.first;

    if (widget.transactionId != null && widget.draftId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTransactionData();
      });
    }

    if (widget.draftId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDraftData();
      });
    }
  }

  void _loadTransactionData() {
    final transactions = ref.read(transactionNotifierProvider).transactions;
    final transaction = transactions.firstWhere(
      (t) => t.id == widget.transactionId,
      orElse: () => throw Exception('Transaction not found'),
    );

    setState(() {
      _titleController.text = transaction.title;
      _amountController.text = transaction.amount.toStringAsFixed(0);
      _selectedType = transaction.type;
      _selectedCategory = transaction.category;
      _selectedDate = transaction.date;
      _descriptionController.text = transaction.description ?? '';
      if (transaction.imagePath != null) {
        _selectedImage = File(transaction.imagePath!);
      }
    });
  }

  Future<void> _loadDraftData() async {
    final notifier = ref.read(draftTransactionNotifierProvider.notifier);
    final draft = await notifier.fetchDraftById(widget.draftId!);
    if (draft == null) return;

    setState(() {
      _titleController.text = draft.title;
      _amountController.text = draft.amount.toStringAsFixed(0);
      _selectedType = draft.type == DraftTransactionType.income
          ? TransactionType.income
          : TransactionType.expense;
      final categories = _selectedType == TransactionType.income
          ? _incomeCategories
          : _expenseCategories;
      _selectedCategory = categories.contains(draft.category)
          ? draft.category
          : categories.first;
      _selectedDate = draft.date;
      _descriptionController.text = draft.description ?? '';
      if (draft.imagePath != null) {
        _selectedImage = File(draft.imagePath!);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667eea),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: GradientTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white),
                ),
                title: const Text(
                  'Kamera',
                  style: TextStyle(fontFamily: 'SFSemibold'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: GradientTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.white),
                ),
                title: const Text(
                  'Galeri',
                  style: TextStyle(fontFamily: 'SFSemibold'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (_titleController.text.trim().isEmpty) {
      _showError('Judul tidak boleh kosong');
      return;
    }

    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (amountText.isEmpty) {
      _showError('Jumlah tidak boleh kosong');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Jumlah harus lebih dari 0');
      return;
    }

    final transaction = Transaction(
      id: widget.transactionId,
      title: _titleController.text.trim(),
      amount: amount,
      type: _selectedType,
      category: _selectedCategory,
      date: _selectedDate,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      imagePath: _selectedImage?.path,
    );

    final notifier = ref.read(transactionNotifierProvider.notifier);
    final isEditing = widget.transactionId != null && widget.draftId == null;
    final success = isEditing
        ? await notifier.updateExistingTransaction(transaction)
        : await notifier.addNewTransaction(transaction);

    if (!mounted) return;

    if (success) {
      if (widget.draftId != null) {
        await ref
            .read(draftTransactionNotifierProvider.notifier)
            .removeDraft(widget.draftId!);
      }

      // Check spending limits and trigger notifications if needed
      final transactions = ref.read(transactionNotifierProvider).transactions;
      await ref
          .read(spendingLimitNotifierProvider.notifier)
          .checkLimitsAndNotify(transactions);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Transaksi berhasil diupdate'
                : 'Transaksi berhasil ditambahkan',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.pop();
    } else {
      final error = ref.read(transactionNotifierProvider).errorMessage;
      _showError(error ?? 'Gagal menyimpan transaksi');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFf5576c),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: widget.transactionId == null
            ? 'Tambah Transaksi'
            : 'Edit Transaksi',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type Selection
            Text(
              'Tipe Transaksi',
              style: TextStyle(fontSize: 16.sp, fontFamily: 'SFSemibold'),
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    'Pengeluaran',
                    TransactionType.expense,
                    Icons.arrow_upward,
                    GradientTheme.expenseGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeButton(
                    'Pemasukan',
                    TransactionType.income,
                    Icons.arrow_downward,
                    GradientTheme.incomeGradient,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 24),

            // Title Input
            const Text(
              'Judul',
              style: TextStyle(fontSize: 16, fontFamily: 'SFSemibold'),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            ModernTextField(
              controller: _titleController,
              hintText: 'Masukkan judul transaksi',
              prefixIcon: Icons.title,
            )
                .animate()
                .fadeIn(delay: 250.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 20),

            // Amount Input
            const Text(
              'Jumlah',
              style: TextStyle(fontSize: 16, fontFamily: 'SFSemibold'),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            ModernTextField(
              controller: _amountController,
              hintText: 'Masukkan jumlah',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
            )
                .animate()
                .fadeIn(delay: 350.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 20),

            // Category
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 16, fontFamily: 'SFSemibold'),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            Builder(builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: isDark ? GradientTheme.darkSurface : null,
                  style: TextStyle(
                    fontFamily: 'SFSemibold',
                    color:
                        isDark ? GradientTheme.darkTextPrimary : Colors.black87,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.category,
                      size: 22,
                      color: isDark ? GradientTheme.darkTextSecondary : null,
                    ),
                    filled: true,
                    fillColor:
                        isDark ? GradientTheme.darkSurface : Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark
                            ? GradientTheme.darkBorder
                            : Colors.grey[200]!,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark
                            ? GradientTheme.darkPrimary
                            : const Color(0xFF667eea),
                        width: 2,
                      ),
                    ),
                  ),
                  items: _currentCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              );
            })
                .animate()
                .fadeIn(delay: 450.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 20),

            // Date
            const Text(
              'Tanggal',
              style: TextStyle(fontSize: 16, fontFamily: 'SFSemibold'),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            Builder(builder: (context) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: isDark ? GradientTheme.darkSurface : Colors.grey[50],
                    border: Border.all(
                      color:
                          isDark ? GradientTheme.darkBorder : Colors.grey[200]!,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: isDark
                            ? GradientTheme.darkPrimary
                            : const Color(0xFF667eea),
                        size: 22,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('dd MMMM yyyy', 'id_ID')
                            .format(_selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFSemibold',
                          color: isDark
                              ? GradientTheme.darkTextPrimary
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
                .animate()
                .fadeIn(delay: 550.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 20),

            // Description
            const Text(
              'Deskripsi (Opsional)',
              style: TextStyle(fontSize: 16, fontFamily: 'SFSemibold'),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            ModernTextField(
              controller: _descriptionController,
              hintText: 'Masukkan deskripsi',
              prefixIcon: Icons.description,
              maxLines: 3,
            )
                .animate()
                .fadeIn(delay: 650.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 20),

            // Image
            const Text(
              'Lampiran Gambar (Opsional)',
              style: TextStyle(fontSize: 16, fontFamily: 'SFSemibold'),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 8),
            if (_selectedImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: GradientTheme.expenseGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).scale()
            else
              Builder(builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return InkWell(
                  onTap: _showImageSourceDialog,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? GradientTheme.darkBorder
                            : Colors.grey[300]!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      color:
                          isDark ? GradientTheme.darkSurface : Colors.grey[50],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: isDark
                              ? GradientTheme.darkTextSecondary
                              : Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap untuk menambah gambar',
                          style: TextStyle(
                            color: isDark
                                ? GradientTheme.darkTextPrimary
                                : Colors.grey[600],
                            fontFamily: 'SFSemibold',
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nota belanja atau bukti pembayaran',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? GradientTheme.darkTextSecondary
                                : Colors.grey[500],
                            fontFamily: 'SFRegular',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
                  .animate()
                  .fadeIn(delay: 750.ms, duration: 300.ms)
                  .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 32),

            // Save Button
            GradientButton(
              text: widget.transactionId == null
                  ? 'Simpan Transaksi'
                  : 'Update Transaksi',
              onPressed: _saveTransaction,
              width: double.infinity,
              height: 56,
              borderRadius: 16,
              textStyle: const TextStyle(
                fontSize: 17,
                fontFamily: 'SFBold',
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            )
                .animate()
                .fadeIn(delay: 800.ms, duration: 300.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    String label,
    TransactionType type,
    IconData icon,
    LinearGradient gradient,
  ) {
    final isSelected = _selectedType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get dark mode gradient
    final darkGradient = type == TransactionType.expense
        ? GradientTheme.expenseGradientDark
        : GradientTheme.incomeGradientDark;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = _currentCategories.first;
        });
      },
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          gradient: isSelected ? (isDark ? darkGradient : gradient) : null,
          color: isSelected
              ? null
              : (isDark ? GradientTheme.darkSurface : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? GradientTheme.darkBorder : Colors.grey[200]!),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark
                            ? darkGradient.colors.first
                            : gradient.colors.first)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? GradientTheme.darkTextPrimary : Colors.grey[600]),
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? GradientTheme.darkTextPrimary
                        : Colors.grey[700]),
                fontFamily: 'SFSemibold',
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
