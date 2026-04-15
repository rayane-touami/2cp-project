import 'package:flutter/material.dart';
import 'package:compusmarket/widgets/home_floating_navigation_bar.dart';
import 'package:compusmarket/screens/home/home_search_bar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentNavIndex = 1; // favorites

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      // ── TOP APP BAR ──
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // ✅ centers the title
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            // ── CONTENT ──
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── SEARCH BAR (NO FILTER) ──
                  const HomeSearchBar(showFilter: false),

                  const SizedBox(height: 20),

                  // ── CONTENT ──
                  const Expanded(
                    child: Center(
                      child: Text('Favorites Page'),
                    ),
                  ),
                ],
              ),
            ),

            // ── FLOATING NAV BAR ──
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