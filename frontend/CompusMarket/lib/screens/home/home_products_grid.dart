import 'package:flutter/material.dart';
import 'filter_state.dart';
import 'product_details_screen.dart';
import '../../services/announcement_service.dart';

// ── GLOBAL VARIABLES FOR MEMORY ──
List<Map<String, dynamic>> globalFavoriteProducts = [];
List<Map<String, dynamic>> globalRatedProducts = [];

// ── 15 FIXED FAKE PRODUCTS ──
const List<Map<String, dynamic>> _fakeProducts = [
  {
    'name': 'AirPods',
    'price': '4500.00 DA',
    'priceValue': 4500.00,
    'category': 'Electronics',
    'rating': 4.5,
    'isRated': false,
    'image': 'assets/images/products/airpods.jpg',
  },
  {
    'name': 'Skate Board',
    'price': '3000.00 DA',
    'priceValue': 3000.00,
    'category': 'Accessories',
    'rating': 4.0,
    'isRated': false,
    'image': 'assets/images/products/skate.jpg',
  },
  {
    'name': 'Apple Watch',
    'price': '15500.00 DA',
    'priceValue': 15500.00,
    'category': 'Electronics',
    'rating': 3.5,
    'isRated': false,
    'image': 'assets/images/products/applewatch.jpg',
  },
  {
    'name': 'Longhchamp Bag',
    'price': '3500.00 DA',
    'priceValue': 3500.00,
    'category': 'Clothes',
    'rating': 5.0,
    'isRated': false,
    'image': 'assets/images/products/bag.jpg',
  },
  {
    'name': 'Bike',
    'price': '22500.00 DA',
    'priceValue': 22500.00,
    'category': 'Accessories',
    'rating': 4.0,
    'isRated': false,
    'image': 'assets/images/products/bike.jpg',
  },
  {
    'name': 'Black Airpods',
    'price': '2500.00 DA',
    'priceValue': 2500.00,
    'category': 'Electronics',
    'rating': 3.5,
    'isRated': false,
    'image': 'assets/images/products/blackairpods.jpg',
  },
  {
    'name': 'Sport Water Bottle',
    'price': '1000.00 DA',
    'priceValue': 1000.00,
    'category': 'Accessories',
    'rating': 4.0,
    'isRated': false,
    'image': 'assets/images/products/bottle.jpg',
  },
  {
    'name': 'Casio Vintage Watch',
    'price': '2000.00 DA',
    'priceValue': 2000.00,
    'category': 'Accessories',
    'rating': 5.0,
    'isRated': false,
    'image': 'assets/images/products/casiowatch.jpg',
  },
  {
    'name': 'Go Pro Camera',
    'price': '345000.00 DA',
    'priceValue': 345000.00,
    'category': 'Electronics',
    'rating': 3.5,
    'isRated': false,
    'image': 'assets/images/products/gopro.jpg',
  },
  {
    'name': 'Apple Ipad',
    'price': '900000.00 DA',
    'priceValue': 900000.00,
    'category': 'Electronics',
    'rating': 4.0,
    'isRated': false,
    'image': 'assets/images/products/ipad.jpg',
  },
  {
    'name': 'Iphone 17 Pro Max',
    'price': '300000.00 DA',
    'priceValue': 300000.00,
    'category': 'Electronics',
    'rating': 5.0,
    'isRated': false,
    'image': 'assets/images/products/iphone17promax.jpg',
  },
  {
    'name': 'Macbook Air',
    'price': '114500.00 DA',
    'priceValue': 114500.00,
    'category': 'Electronics',
    'rating': 4.0,
    'isRated': false,
    'image': 'assets/images/products/macbookair.jpg',
  },
  {
    'name': 'Microphone Professional',
    'price': '9000.00 DA',
    'priceValue': 9000.00,
    'category': 'Electronics',
    'rating': 3.5,
    'isRated': false,
    'image': 'assets/images/products/mic.jpg',
  },
  {
    'name': 'Nintendo',
    'price': '52500.00 DA',
    'priceValue': 52500.00,
    'category': 'Electronics',
    'rating': 5.0,
    'isRated': false,
    'image': 'assets/images/products/nintendo.jpg',
  },
  {
    'name': 'Play Station 5',
    'price': '114500.00 DA',
    'priceValue': 114500.00,
    'category': 'Electronics',
    'rating': 4.5,
    'isRated': false,
    'image': 'assets/images/products/ps5.jpg',
  },
];

class HomeProductsGrid extends StatefulWidget {
  const HomeProductsGrid({super.key});
  @override
  State<HomeProductsGrid> createState() => _HomeProductsGridState();
}

class _HomeProductsGridState extends State<HomeProductsGrid> {
  // Real products from API (max 5)
  List<Map<String, dynamic>> _realProducts = [];
  bool _loadingReal = true;

  @override
  void initState() {
    super.initState();
    _loadRealProducts();
  }

  Future<void> _loadRealProducts() async {
    try {
      final data = await AnnouncementService.getAnnouncements(page: 1);
      final List results = data['results'] ?? [];
      final real = results.take(5).map((item) {
        return {
          'id': item['id'],
          'name': item['title'] ?? '',
          'price': '${item['price']} DA',
          'priceValue': double.tryParse(item['price'].toString()) ?? 0.0,
          'category': item['category'] ?? '',
          'rating': (item['average_rating'] ?? 0.0).toDouble(),
          'isRated': false,
          'image': item['photo'] ?? '', // network image URL
          'isReal': true, // flag to know it's from API
        };
      }).toList();

      setState(() {
        _realProducts = real;
        _loadingReal = false;
      });
    } catch (e) {
      print('❌ Failed to load real products: $e');
      setState(() => _loadingReal = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Combine: real products (top, max 5) + fake products (bottom, fixed 15)
    final List<Map<String, dynamic>> allProducts = [
      ..._realProducts,
      ..._fakeProducts,
    ];

    return ValueListenableBuilder<FilterData>(
      valueListenable: globalFilterState,
      builder: (context, filter, child) {
        final filteredProducts = allProducts.where((product) {
          if (filter.searchQuery.isNotEmpty) {
            final String productName = product['name'].toLowerCase();
            final String query = filter.searchQuery.toLowerCase();
            if (!productName.contains(query)) return false;
          }
          if (filter.selectedMainCategory != 'All' &&
              product['category'] != filter.selectedMainCategory) {
            return false;
          }
          if (filter.selectedCategories.isNotEmpty &&
              !filter.selectedCategories.contains(product['category'])) {
            return false;
          }
          final double price = product['priceValue'] as double;
          if (price < filter.priceRange.start ||
              price > filter.priceRange.end) {
            return false;
          }
          return true;
        }).toList();

        if (filteredProducts.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.1),
            child: Center(
              child: Text(
                'No products match these filters.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenWidth * 0.03,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final bool isFavorite = globalFavoriteProducts.any(
              (p) => p['name'] == product['name'],
            );
            final bool isRated = globalRatedProducts.any(
              (p) => p['name'] == product['name'],
            );

            return ProductCard(
              product: product,
              isFavorite: isFavorite,
              isRated: isRated,
              onFavoriteToggle: () {
                setState(() {
                  if (isFavorite) {
                    globalFavoriteProducts.removeWhere(
                      (p) => p['name'] == product['name'],
                    );
                  } else {
                    globalFavoriteProducts.add(product);
                  }
                });
              },
              onRatingToggle: () {
                setState(() {
                  if (isRated) {
                    globalRatedProducts.removeWhere(
                      (p) => p['name'] == product['name'],
                    );
                  } else {
                    globalRatedProducts.add(product);
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}

// ── PRODUCT CARD WIDGET ──
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isFavorite;
  final bool isRated;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onRatingToggle;
  final VoidCallback? onEdit;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.isRated,
    required this.onFavoriteToggle,
    required this.onRatingToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isReal = product['isReal'] == true;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailsScreen(product: product),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(screenWidth * 0.05),
                        topRight: Radius.circular(screenWidth * 0.05),
                      ),
                    ),
                    // ── show network image for real, asset for fake ──
                    child: isReal
                        ? Image.network(
                            product['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: screenWidth * 0.12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                          )
                        : Image.asset(
                            product['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: screenWidth * 0.12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onEdit ?? onFavoriteToggle,
                      child: Container(
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: onEdit != null
                              ? Icon(
                                  Icons.edit_outlined,
                                  color: const Color(0xff2853af),
                                  size: screenWidth * 0.05,
                                )
                              : Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                  size: screenWidth * 0.05,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.033,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product['price'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A73E8),
                        ),
                      ),
                      GestureDetector(
                        onTap: onRatingToggle,
                        child: Row(
                          children: [
                            Icon(
                              isRated ? Icons.star : Icons.star_border,
                              color: isRated ? Colors.amber : Colors.grey,
                              size: screenWidth * 0.055 * 0.7,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              '${product['rating']}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.028,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
