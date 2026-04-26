// ignore: file_names
import 'package:compusmarket/screens/home/add_new_product.dart';
import 'package:compusmarket/screens/profiles/Edit_profil.dart';
import 'package:compusmarket/services/profile_api_service.dart';
import 'package:compusmarket/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:compusmarket/screens/home/home_products_grid.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // Profile data
  String _userName = "";
  String _userEmail = "";
  String _userPhone = "";
  String _userBio = "";
  String _userUniversityId = "";
  String _userUniversityName = "";
  int _itemsCount = 0;
  int _dealsCount = 0;
  double _averageRating = 0.0;

  List<dynamic> _myListings = [];
  List<dynamic> _universities = [];

  bool _showAll = false;
  bool _notificationsEnabled = false;
  bool _showEmail = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
  setState(() => _isLoading = true);
  try {
    final profile = await ProfileApiService.getMyProfile();
    final authMe = await AuthService.getMe();
    debugPrint('AUTH ME DATA: $authMe');
    debugPrint('PROFILE KEYS: ${profile.keys.toList()}');
    debugPrint('PROFILE DATA: $profile');

    // Fetch listings & deals separately so one failure doesn't kill everything
    List<dynamic> listings = [];
    List<dynamic> deals = [];
    List<dynamic> universities = [];

    try {
      listings = await ProfileApiService.getMyListings();
    } catch (e) {
      debugPrint('Listings error: $e'); // won't crash the whole screen
    }

    try {
  universities = await AuthService.getUniversities();
} catch (e) {
  debugPrint('Universities error: $e');
}

    try {
      deals = await ProfileApiService.getMyDeals();
    } catch (e) {
      debugPrint('Deals error: $e');
    }

    setState(() {
  _userName = profile['full_name'] ?? profile['name'] ?? '';
  _userEmail = authMe['email'] ?? '';
  _userPhone = authMe['phone'] ?? '';
  _userBio = profile['bio'] ?? '';

  
 _userUniversityId = authMe['university']?['id']?.toString() ?? '';
    _userUniversityName = authMe['university']?['name'] ?? ''; // API doesn't return university id in /me/

  _notificationsEnabled = profile['notifications_enabled'] ?? false;
  _showEmail = profile['show_email'] ?? false;
  _myListings = listings;
  _itemsCount = listings.length;
  _dealsCount = deals.length;
  _universities = universities; 

  // ✅ parse String to double safely
  _averageRating = double.tryParse(
    profile['average_rating']?.toString() ?? '0'
  ) ?? 0.0;
});

  } catch (e) {
    debugPrint('Error loading profile: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profile. Please try again.')),
      );
    }
  } finally {
    setState(() => _isLoading = false);
  }
}

  Future<void> _toggleNotifications(bool value, StateSetter setModalState) async {
    setModalState(() => _notificationsEnabled = value);
    setState(() => _notificationsEnabled = value);
    try {
      await ProfileApiService.updateMyProfile(notificationsEnabled: value);
    } catch (e) {
      // Revert on failure
      setModalState(() => _notificationsEnabled = !value);
      setState(() => _notificationsEnabled = !value);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update notifications.')),
        );
      }
    }
  }

  Future<void> _toggleShowEmail(bool value, StateSetter setModalState) async {
    setModalState(() => _showEmail = value);
    setState(() => _showEmail = value);
    try {
      await ProfileApiService.updateMyProfile(showEmail: value);
    } catch (e) {
      setModalState(() => _showEmail = !value);
      setState(() => _showEmail = !value);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update email visibility.')),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    Navigator.pop(context); // close bottom sheet
    try {
     
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final visibleListings = _showAll ? _myListings : _myListings.take(2).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blue_background.jfif'),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xff2853af)))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   SizedBox(height: MediaQuery.of(context).padding.top + 10),

                    // ── Title + Settings ──────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Row(
                        children: [
                          Text(
                            "Profil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.07,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _openSettings,
                            icon: Icon(Icons.settings_outlined, size: screenWidth * 0.075),
                          ),
                        ],
                      ),
                    ),

                    // ── Avatar + Card ─────────────────────────────────
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            margin: const EdgeInsets.only(top: 90),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 35),
                                Text(
                                  _userName,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                // Show email only if toggle is on
                                if (_showEmail)
                                  Text(
                                    _userEmail,
                                    style: TextStyle(
                                      color: const Color(0xff808897),
                                      fontSize: screenWidth * 0.033,
                                    ),
                                  ),
                                SizedBox(height: screenHeight * 0.015),
                                Container(
                                  height: screenHeight * 0.001,
                                  width: screenWidth * 0.7,
                                  color: const Color(0xffdfe1e6),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _statItem("Items", "$_itemsCount"),
                                    _divider(),
                                    _statItem("Deals", "$_dealsCount"),
                                    _divider(),
                                    _statItem("Rating", _averageRating > 0
                                        ? _averageRating.toStringAsFixed(1)
                                        : "N/A"),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Container(
                                  height: screenHeight * 0.001,
                                  width: screenWidth * 0.7,
                                  color: const Color(0xffdfe1e6),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                              ],
                            ),
                          ),
                        ),
                       Positioned(
  top: 0,
  child: Container(
    width: 120,
    height: 120,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey[350],
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ClipOval(
      child: Icon(
        Icons.person,
        size: 60,
        color: Colors.grey[600],
      ),
    ),
  ),
),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // ── About ─────────────────────────────────────────
                    if (_userBio.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff808897),
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              _userBio,
                              softWrap: true,
                              style: TextStyle(
                                color: const Color(0xff808897),
                                fontSize: screenWidth * 0.035,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.02),

                    // ── My Listings ───────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Text(
                        "My Listings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    if (_myListings.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "No listings yet.",
                            style: TextStyle(
                              color: const Color(0xff808897),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: screenWidth * 0.03,
                            mainAxisSpacing: screenWidth * 0.03,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: visibleListings.length,
                          itemBuilder: (context, index) {
                            final listing = visibleListings[index];
                            // Map API fields to the product map your ProductCard expects
                            final product = {
                              'name': listing['title'] ?? '',
                              'price': '${listing['price']} ${listing['currency'] ?? 'DA'}',
                              'priceValue': double.tryParse(listing['price'].toString()) ?? 0.0,
                              'category': listing['category'] ?? '',
                              'rating': (listing['average_rating'] ?? 0.0).toDouble(),
                              'isRated': false,
                              'image': listing['image_url'] ?? 'assets/images/products/airpods.jpg',
                              'id': listing['id'],
                            };
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ProductCard(
                                  product: product,
                                  isFavorite: false,
                                  isRated: false,
                                  onFavoriteToggle: () {},
                                  onRatingToggle: () {},
                                  onEdit: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddNewProductScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    if (_myListings.length > 2)
                      Center(
                        child: TextButton(
                          onPressed: () => setState(() => _showAll = !_showAll),
                          child: Text(
                            _showAll ? "View less <" : "View more >",
                            style: TextStyle(
                              color: const Color(0xff2853af),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
      ),
    );
  }

  void _openSettings() {
    final screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xffdfe1e6)),

                  // Edit Profile
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text("Edit Profile",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(">",
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                    onTap: () async {
                      Navigator.pop(context);
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            name: _userName,
                            email: _userEmail,
                            phone: _userPhone,
                            bio: _userBio,
                            universityId: _userUniversityId,
                            universities: _universities,
                          ),
                        ),
                      );
                      // Reload profile if changes were saved
                      if (updated == true) _loadAll();
                    },
                  ),
                  const Divider(height: 1, color: Color(0xffdfe1e6)),

                  // Notifications
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text("Notifications",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _notificationsEnabled,
                    activeThumbColor: const Color(0xff2853af),
                    onChanged: (v) => _toggleNotifications(v, setModalState),
                  ),
                  const Divider(height: 1, color: Color(0xffdfe1e6)),

                  // Show Email
                  SwitchListTile(
                    secondary: const Icon(Icons.email_outlined),
                    title: const Text("Show Email",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _showEmail,
                    activeThumbColor: const Color(0xff2853af),
                    onChanged: (v) => _toggleShowEmail(v, setModalState),
                  ),
                  const Divider(height: 1, color: Color(0xffdfe1e6)),

                  // Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout",
                        style: TextStyle(color: Colors.red)),
                    onTap: _handleLogout,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            )),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Color(0xff808897),
            )),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: 1,
      height: 50,
      color: const Color(0xffdfe1e6),
    );
  }
}