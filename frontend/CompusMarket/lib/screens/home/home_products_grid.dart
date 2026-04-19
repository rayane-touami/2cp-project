import 'package:flutter/material.dart';
import 'filter_state.dart';

// ── GLOBAL VARIABLES FOR MEMORY ──
// These list hold the memory for hearts AND stars across all pages!
List<Map<String, dynamic>> globalFavoriteProducts = [];
List<Map<String, dynamic>> globalRatedProducts = []; // <-- NEW! Rating memory!

class HomeProductsGrid extends StatefulWidget {
  const HomeProductsGrid({super.key});
  @override
  State<HomeProductsGrid> createState() => _HomeProductsGridState();
}

class _HomeProductsGridState extends State<HomeProductsGrid> {
  final List<Map<String, dynamic>> _products = [
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
      'name': 'Apple Ipad ',
      'price': '900000.00 DA',
      'priceValue': 900000.00,
      'category': 'Electronics',
      'rating': 4.0,
      'isRated': false,
      'image': 'assets/images/products/ipad.jpg',
    },
    {
      'name': 'Iphon 17 Pro Max',
      'price': '300000.00 DA',
      'priceValue': 300000.00,
      'category': 'Electronics',
      'rating': 5.0,
      'isRated': false,
      'image': 'assets/images/products/iphone17promax.jpg',
    },
    {
      'name': 'Macbook Air ',
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
      'name': 'Acer Monitor',
      'price': '445000.00 DA',
      'priceValue': 445000.00,
      'category': 'Electronics',
      'rating': 4.0,
      'isRated': false,
      'image': 'assets/images/products/monitor.jpg',
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
      'name': 'Pc Support ',
      'price': '1000.00 DA',
      'priceValue': 1000.00,
      'category': 'Accessories',
      'rating': 4.0,
      'isRated': false,
      'image': 'assets/images/products/supportpc.jpg',
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
    {
      'name': 'rhode Lip Gloss ',
      'price': '4500.00 DA',
      'priceValue': 4500.00,
      'category': 'Accessories',
      'rating': 5.0,
      'isRated': false,
      'image': 'assets/images/products/rhode.jpg',
    },
    {
      'name': 'Adidas Blue Samba Shoes',
      'price': '14500.00 DA',
      'priceValue': 14500.00,
      'category': 'Clothes',
      'rating': 4.5,
      'isRated': false,
      'image': 'assets/images/products/sambashoes.jpg',
    },
    {
      'name': 'Tom Ford Parfum',
      'price': '15500.00 DA',
      'priceValue': 15500.00,
      'category': 'Accessories',
      'rating': 3.5,
      'isRated': false,
      'image': 'assets/images/products/tomfordparfum.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<FilterData>(
      valueListenable: globalFilterState,
      builder: (context, filter, child) {
        final filteredProducts = _products.where((product) {
          // rule: Search Query
          if (filter.searchQuery.isNotEmpty) {
            final String productName = product['name'].toLowerCase();
            final String query = filter.searchQuery.toLowerCase();
            if (!productName.contains(query)) {
              return false;
            }
          }

          // rule: Main Category from pills
          if (filter.selectedMainCategory != 'All' &&
              product['category'] != filter.selectedMainCategory) {
            return false;
          }

          // rule: Categories selected from the bottom sheet
          if (filter.selectedCategories.isNotEmpty &&
              !filter.selectedCategories.contains(product['category'])) {
            return false;
          }

          // rule: Price Range
          final double price = product['priceValue'] as double;
          if (price < filter.priceRange.start ||
              price > filter.priceRange.end) {
            return false;
          }

          // if it passed all checks, include it!
          return true;
        }).toList();

        // Optional: show a message if NO products match
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
            // Check our memory lists to see if they were clicked before
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
  final bool isRated; // <--- The card now uses this
  final VoidCallback onFavoriteToggle;
  final VoidCallback onRatingToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.isRated, // <--- required here
    required this.onFavoriteToggle,
    required this.onRatingToggle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
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
                  child: Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
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
                    onTap: onFavoriteToggle,
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
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
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
                      // <--- Tapping triggers the star UI
                      onTap: onRatingToggle,
                      child: Row(
                        children: [
                          Icon(
                            isRated
                                ? Icons.star
                                : Icons.star_border, // Tied to our memory list
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
    );
  }
}
