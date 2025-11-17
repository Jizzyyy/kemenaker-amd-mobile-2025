import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse the number
    final number = int.tryParse(digitsOnly);
    if (number == null) {
      return oldValue;
    }

    // Format with thousand separators
    final formatted = _formatter.format(number);

    // Calculate new cursor position
    int newOffset = formatted.length;
    
    // Try to maintain cursor position relative to the number
    if (oldValue.text.isNotEmpty) {
      final oldCursorPos = oldValue.selection.baseOffset;
      final digitsBeforeCursor = oldValue.text
          .substring(0, oldCursorPos)
          .replaceAll(RegExp(r'[^0-9]'), '')
          .length;
      
      // Find the position in the new formatted string
      int count = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (formatted[i].contains(RegExp(r'[0-9]'))) {
          count++;
          if (count >= digitsBeforeCursor) {
            newOffset = i + 1;
            break;
          }
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
