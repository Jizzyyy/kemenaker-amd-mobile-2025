import 'package:flutter/material.dart';
import '../../../../core/theme/gradient_theme.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final String value;
  final String selectedFilter;
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
    final isSelected = selectedFilter == value;

    return GestureDetector(
      onTap: () => onFilterChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? GradientTheme.primaryGradient : null,
          color: isSelected ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontFamily: 'SFSemibold',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
