import 'package:flutter/material.dart';
import 'package:compusmarket/widgets/home_floating_navigation_bar.dart';
import 'package:compusmarket/screens/home/home_search_bar.dart';
import 'package:compusmarket/screens/home/filter_state.dart';

// IMPORT HOME GRID FILE SO WE GET MEMORY LISTS
import 'package:compusmarket/screens/home/home_products_grid.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const HomeSearchBar(showFilter: false),
                  const SizedBox(height: 20),

                  // ── GRID OF FAVORITES ──
                  Expanded(
                    child: ValueListenableBuilder<FilterData>(
                      valueListenable: globalFilterState,
                      builder: (context, filter, child) {
                        final filteredFavorites = globalFavoriteProducts.where((product) {
                          if (filter.searchQuery.isNotEmpty) {
                            final String productName = product['name'].toLowerCase();
                            final String query = filter.searchQuery.toLowerCase();
                            if (!productName.contains(query)) {
                              return false;
                            }
                          }
                          return true;
                        }).toList();

                        if (globalFavoriteProducts.isEmpty) {
                          return const Center(
                            child: Text(
                              'No favorites yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        
                        if (filteredFavorites.isEmpty) {
                          return const Center(
                            child: Text(
                              'No favorites match the search',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: screenWidth * 0.03,
                            mainAxisSpacing: screenWidth * 0.03,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredFavorites.length,
                          itemBuilder: (context, index) {
                            final product = filteredFavorites[index];

                            // Keep the star rating yellow if it was clicked! 🌟
                            final bool isRated = globalRatedProducts.any(
                              (p) => p['name'] == product['name'],
                            );

                            return ProductCard(
                              product: product,
                              isFavorite: true,
                              isRated: isRated, // Provide star state here
                              onFavoriteToggle: () {
                                setState(() {
                                  globalFavoriteProducts.removeWhere(
                                    (p) => p['name'] == product['name'],
                                  );
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
                    ),
                  ),
                ],
              ),
            ),
            HomeFloatingNavigationBar(
              currentIndex: _currentNavIndex,
              onTap: (index) => setState(() => _currentNavIndex = index),
            ),
          ],
        ),
      ),
    );
  }
}
