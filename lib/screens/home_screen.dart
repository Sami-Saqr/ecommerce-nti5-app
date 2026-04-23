import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../utils/constants.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchBarWidget(
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ),

              const SizedBox(height: 24),

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
                    return CategoryItem(category: category);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Promo Banner
              SizedBox(
                height: 180,
                child: PageView(
                  controller: _bannerController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBannerPage = index;
                    });
                  },
                  children: const [
                    PromoBanner(
                      title: '50-40% OFF',
                      subtitle: 'Now in (product)',
                      description: 'All colours',
                      buttonText: 'Shop Now',
                    ),
                    PromoBanner(
                      title: 'New Arrivals',
                      subtitle: 'Summer Collection',
                      description: 'Limited time',
                      buttonText: 'Shop Now',
                    ),
                    PromoBanner(
                      title: 'Flash Sale',
                      subtitle: 'Up to 70% OFF',
                      description: 'Today only',
                      buttonText: 'Shop Now',
                    ),
                  ],
                ),
              ),

              // Page Indicator
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentBannerPage == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Recommended Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recommended',
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
                  itemCount: MockData.products.length,
                  itemBuilder: (context, index) {
                    final product = MockData.products[index];
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
