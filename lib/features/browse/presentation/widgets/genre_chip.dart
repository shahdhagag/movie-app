import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class GenreChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const GenreChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color:AppColors.primary),
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.primary,
          ),
        ),
      ),
    );
  }
}