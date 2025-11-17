import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String value;
  final RxString selectedFilter;
  final Function(String) onFilterChanged;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.value,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = selectedFilter.value == value;
      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onFilterChanged(value),
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          fontFamily: 'SFBold',
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      );
    });
  }
}
