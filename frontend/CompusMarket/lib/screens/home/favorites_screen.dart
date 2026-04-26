import 'dart:io';
import 'package:flutter/material.dart';
import 'package:compusmarket/screens/home/home_search_bar.dart';
import 'package:compusmarket/screens/home/filter_state.dart';
import 'package:compusmarket/screens/home/home_products_grid.dart';
import 'package:compusmarket/services/favorite_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> _apiFavorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final data = await FavoriteService.getFavorites();
      if (!mounted) return;
      final favorites = data.map((item) {
        final announcement = item['announcement'];
        return {
          'favoriteId': item['id'],
          'id': announcement['id'],
          'name': announcement['title'] ?? '',
          'price': '${announcement['price']} DA',
          'priceValue': double.tryParse(announcement['price'].toString()) ?? 0.0,
          'category': announcement['category'] ?? '',
          'rating': (announcement['average_rating'] ?? 0.0).toDouble(),
          'isRated': false,
          'image': announcement['photo'] ?? '',
          'isReal': true,
        };
      }).toList();

      if (mounted) {
        setState(() {
          _apiFavorites = List<Map<String, dynamic>>.from(favorites);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Failed to load favorites: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeApiFavorite(Map<String, dynamic> product) async {
    try {
      final int favoriteId = product['favoriteId'];
      await FavoriteService.removeFavorite(favoriteId);
      if (mounted) {
        setState(() {
          _apiFavorites.removeWhere((p) => p['favoriteId'] == favoriteId);
        });
      }
    } catch (e) {
      print('❌ Failed to remove favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove from favorites')),
        );
      }
    }
  }

  void _removeLocalFavorite(Map<String, dynamic> product) {
    if (mounted) {
      setState(() {
        globalFavoriteProducts.removeWhere((p) => p['name'] == product['name']);
      });
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const HomeSearchBar(showFilter: false),
              const SizedBox(height: 20),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Color(0xff2853af)),
                      )
                    : ValueListenableBuilder<FilterData>(
                        valueListenable: globalFilterState,
                        builder: (context, filter, child) {
                          final List<Map<String, dynamic>> allFavorites = [
                            ..._apiFavorites,
                            ...globalFavoriteProducts,
                          ];

                          final filteredFavorites = allFavorites.where((product) {
                            if (filter.searchQuery.isNotEmpty) {
                              final String productName = product['name'].toLowerCase();
                              final String query = filter.searchQuery.toLowerCase();
                              if (!productName.contains(query)) return false;
                            }
                            return true;
                          }).toList();

                          if (allFavorites.isEmpty) {
                            return const Center(
                              child: Text(
                                'No favorites yet',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            );
                          }

                          if (filteredFavorites.isEmpty) {
                            return const Center(
                              child: Text(
                                'No favorites match the search',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                              final bool isReal = product['isReal'] == true;
                              final bool isRated = globalRatedProducts.any(
                                (p) => p['name'] == product['name'],
                              );

                              return ProductCard(
                                product: product,
                                isFavorite: true,
                                isRated: isRated,
                                onFavoriteToggle: () {
                                  if (isReal) {
                                    _removeApiFavorite(product);
                                  } else {
                                    _removeLocalFavorite(product);
                                  }
                                },
                                onRatingToggle: () {
                                  if (mounted) {
                                    setState(() {
                                      if (isRated) {
                                        globalRatedProducts.removeWhere(
                                          (p) => p['name'] == product['name'],
                                        );
                                      } else {
                                        globalRatedProducts.add(product);
                                      }
                                    });
                                  }
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
      ),
    );
  }
}