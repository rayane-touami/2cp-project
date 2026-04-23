import 'package:compusmarket/screens/profiles/My_profile.dart';
import 'package:flutter/material.dart';
import 'home_header.dart';
import 'home_search_bar.dart';
import 'home_categories.dart';
import 'home_products_grid.dart';
import '../../widgets/home_floating_navigation_bar.dart';
import 'favorites_screen.dart';
import '../chats/chats_out.dart';
import '../../services/profile_api_service.dart';
import '../../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── tracks which nav icon is currently selected ──
  int _currentNavIndex = 0; // 0=home, 1=favorites, 2=chat, 3=profile

  Widget _buildCurrentScreen() {
    switch (_currentNavIndex) {
      case 0:
        return _HomeContent(
          onGoToFavorites: () {
            setState(() {
              _currentNavIndex = 1;
            });
          },
        );
      case 1:
        return const FavoritesScreen();
      case 2:
        return const ChatsOutScreen();
      case 3:
        return const MyProfileScreen();
      default:
        return const Scaffold(
          body: Center(child: Text("Under Construction")),
        ); // Fallback for profile or placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── SWITCH SCREENS ──
            _buildCurrentScreen(),

            // ── FLOATING NAV BAR ──
            HomeFloatingNavigationBar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() => _currentNavIndex = index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── HOME CONTENT ──
class _HomeContent extends StatefulWidget {
  final VoidCallback onGoToFavorites;
  const _HomeContent({required this.onGoToFavorites});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  String _userName = '';
  String _university = '';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
  try {
    final me = await AuthService.getMe();
    setState(() {
      _userName = me['full_name'] ?? '';
      // university is an object {id: ..., name: ...}
      _university = me['university']?['name'] ?? '';
      _profileImageUrl = me['profile_picture'];
    });
  } catch (e) {
    print('❌ Error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(
              userName: _userName,
              university: _university,
              profileImageUrl: _profileImageUrl,
            ),
            SizedBox(height: screenHeight * 0.02),
            const HomeSearchBar(),
            SizedBox(height: screenHeight * 0.02),
            const HomeCategories(),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Latest Products',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const HomeProductsGrid(),
            SizedBox(height: screenHeight * 0.015),
          ],
        ),
      ),
    );
  }
}
