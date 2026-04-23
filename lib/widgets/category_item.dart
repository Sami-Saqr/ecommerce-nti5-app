import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../utils/constants.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            image: DecorationImage(
              image: NetworkImage(category.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
