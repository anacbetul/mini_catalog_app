import 'package:flutter/material.dart';
import 'package:mini_catalog_app/constants/app_colors.dart';
import 'package:mini_catalog_app/constants/app_typography.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({super.key, this.message = 'Yükleniyor...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(message, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
