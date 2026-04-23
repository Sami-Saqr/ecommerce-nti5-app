import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == null
        ? MockData.products
        : MockData.getProductsByCategory(_selectedCategory!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF83758), Color(0xFF3B5998)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.trending_up,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Stylish',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3B5998),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'All Featured',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Category List
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: MockData.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final category = MockData.categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedCategory == category.id) {
                            _selectedCategory = null;
                          } else {
                            _selectedCategory = category.id;
                          }
                        });
                      },
                      child: CategoryItem(
                        category: category,
                        isSelected: _selectedCategory == category.id,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Products Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Products Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(product: product);
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
