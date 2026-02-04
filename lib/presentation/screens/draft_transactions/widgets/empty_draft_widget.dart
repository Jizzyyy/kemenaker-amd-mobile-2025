import 'package:flutter/material.dart';
import '../../../../core/theme/gradient_theme.dart';

class EmptyDraftWidget extends StatelessWidget {
  const EmptyDraftWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: GradientTheme.subtleGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox,
              size: 60,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum ada draft',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'SFBold',
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi pembayaran akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'SFRegular',
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
