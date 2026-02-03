import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/gradient_theme.dart';
import '../../../../core/utils/currency_input_formatter.dart';
import '../../../../domain/entities/spending_limit.dart';

class SpendingLimitCard extends StatefulWidget {
  final LimitPeriod period;
  final SpendingLimit? currentLimit;
  final double currentSpending;
  final Future<void> Function(SpendingLimit) onSave;

  const SpendingLimitCard({
    super.key,
    required this.period,
    required this.currentLimit,
    required this.currentSpending,
    required this.onSave,
  });

  @override
  State<SpendingLimitCard> createState() => _SpendingLimitCardState();
}

class _SpendingLimitCardState extends State<SpendingLimitCard> {
  late TextEditingController _amountController;
  late bool _isEnabled;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.currentLimit?.isEnabled ?? false;
    _amountController = TextEditingController(
      text: widget.currentLimit != null
          ? widget.currentLimit!.amount.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SpendingLimitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update state when widget receives new data from database
    if (widget.currentLimit != oldWidget.currentLimit) {
      setState(() {
        // Only update if we have actual data (not null)
        if (widget.currentLimit != null) {
          _isEnabled = widget.currentLimit!.isEnabled;
          _amountController.text =
              widget.currentLimit!.amount.toStringAsFixed(0);
        }
      });
    }
  }

  double get _limitAmount => widget.currentLimit?.amount ?? 0;
  double get _percentage {
    if (_limitAmount == 0) return 0;
    return (widget.currentSpending / _limitAmount) * 100;
  }

  Color get _progressColor {
    if (_percentage >= 100) return const Color(0xFFf5576c); // Red
    if (_percentage >= 80) return const Color(0xFFFFA726); // Orange
    return const Color(0xFF56ab2f); // Green
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          gradient: _getGradient(),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          _getIcon(),
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),

                      // Title and Status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.period.displayName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'SFBold',
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _isEnabled ? 'Aktif' : 'Nonaktif',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: _isEnabled
                                    ? const Color(0xFF56ab2f)
                                    : Colors.grey[500],
                                fontFamily: 'SFSemibold',
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Toggle Switch
                      Switch(
                        value: _isEnabled,
                        onChanged: (value) async {
                          setState(() {
                            _isEnabled = value;
                          });

                          // Auto-save when toggle changes
                          final currentAmount =
                              widget.currentLimit?.amount ?? 0;
                          if (currentAmount > 0) {
                            final limit = SpendingLimit(
                              id: widget.currentLimit?.id,
                              period: widget.period,
                              amount: currentAmount,
                              isEnabled: value,
                              createdAt: widget.currentLimit?.createdAt ??
                                  DateTime.now(),
                            );
                            await widget.onSave(limit);
                          }
                        },
                        activeColor: const Color(0xFF667eea),
                      ),

                      // Expand Icon
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),

                  // Progress Bar (only if enabled and has limit)
                  if (_isEnabled && _limitAmount > 0) ...[
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatCurrency(widget.currentSpending),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SFSemibold',
                                color: _progressColor,
                              ),
                            ),
                            Text(
                              '${_percentage.toInt()}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'SFBold',
                                color: _progressColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _percentage / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(_progressColor),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Batas: ${_formatCurrency(_limitAmount)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'SFRegular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expanded Content
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 16),

                  // Amount Input
                  const Text(
                    'Jumlah Batas',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SFSemibold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    enabled: _isEnabled,
                    style: const TextStyle(
                      fontFamily: 'SFSemibold',
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan jumlah batas',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'SFRegular',
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF667eea),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isEnabled ? _handleSave : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient:
                              _isEnabled ? GradientTheme.primaryGradient : null,
                          color: _isEnabled ? null : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SFBold',
                              color:
                                  _isEnabled ? Colors.white : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _handleSave() async {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan jumlah batas'),
          backgroundColor: Color(0xFFf5576c),
        ),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah harus lebih dari 0'),
          backgroundColor: Color(0xFFf5576c),
        ),
      );
      return;
    }

    final limit = SpendingLimit(
      id: widget.currentLimit?.id,
      period: widget.period,
      amount: amount,
      isEnabled: _isEnabled,
      createdAt: widget.currentLimit?.createdAt ?? DateTime.now(),
    );

    await widget.onSave(limit);
  }

  LinearGradient _getGradient() {
    switch (widget.period) {
      case LimitPeriod.daily:
        return GradientTheme.primaryGradient;
      case LimitPeriod.weekly:
        return GradientTheme.incomeGradient;
      case LimitPeriod.monthly:
        return GradientTheme.expenseGradient;
    }
  }

  IconData _getIcon() {
    switch (widget.period) {
      case LimitPeriod.daily:
        return Icons.today;
      case LimitPeriod.weekly:
        return Icons.date_range;
      case LimitPeriod.monthly:
        return Icons.calendar_month;
    }
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}
