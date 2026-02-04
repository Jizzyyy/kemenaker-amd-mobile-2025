import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/gradient_theme.dart';

/// Modern, smooth text field with subtle shadows and animations
class ModernTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.obscureText = false,
    this.validator,
    this.onChanged,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: (isDark
                          ? GradientTheme.darkPrimary
                          : const Color(0xFF667eea))
                      .withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: TextStyle(
            fontFamily: 'SFMedium',
            fontSize: 16,
            height: 1.5,
            color: isDark ? GradientTheme.darkTextPrimary : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            hintStyle: TextStyle(
              fontFamily: 'SFRegular',
              color:
                  isDark ? GradientTheme.darkTextSecondary : Colors.grey[400],
              fontSize: 15,
            ),
            labelStyle: TextStyle(
              fontFamily: 'SFSemibold',
              color: _isFocused
                  ? (isDark
                      ? GradientTheme.darkPrimary
                      : const Color(0xFF667eea))
                  : (isDark
                      ? GradientTheme.darkTextSecondary
                      : Colors.grey[600]),
              fontSize: 14,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? (isDark
                            ? GradientTheme.darkPrimary
                            : const Color(0xFF667eea))
                        : (isDark
                            ? GradientTheme.darkTextSecondary
                            : Colors.grey[400]),
                    size: 22,
                  )
                : null,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: isDark ? GradientTheme.darkSurface : Colors.grey[50],
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
                color: isDark ? GradientTheme.darkBorder : Colors.grey[200]!,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color:
                    isDark ? GradientTheme.darkAccent : const Color(0xFFf5576c),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color:
                    isDark ? GradientTheme.darkAccent : const Color(0xFFf5576c),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
