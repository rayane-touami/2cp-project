//import 'package:compusmarket/screens/home/add_new_product.dart';
//import 'package:compusmarket/screens/profiles/Edit_profil.dart';
//import 'package:compusmarket/services/profile_api_service.dart';
//import 'package:compusmarket/services/auth_services.dart';
import 'package:compusmarket/widgets/standard_Button.dart';
import 'package:flutter/material.dart';
//import 'package:compusmarket/screens/home/home_products_grid.dart';

class HisProfileScreen extends StatefulWidget {
  const HisProfileScreen({super.key});

  @override
  State<HisProfileScreen> createState() => _HisProfileScreenState();
}

class _HisProfileScreenState extends State<HisProfileScreen> {
  bool _showAll = false;
  final List<Map<String, dynamic>> _fakeListings = [
    {'title': 'Calculus Textbook', 'price': '1500', 'category': 'Books', 'image': 'assets/images/products/airpods.jpg'},
    {'title': 'Laptop Stand', 'price': '2000', 'category': 'Electronics', 'image': 'assets/images/products/airpods.jpg'},
    {'title': 'Backpack', 'price': '3500', 'category': 'Accessories', 'image': 'assets/images/products/airpods.jpg'},
    {'title': 'Physics Notes', 'price': '500', 'category': 'Books', 'image': 'assets/images/products/airpods.jpg'},
  ];
  @override
  Widget build(BuildContext context) {
     final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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

        child: SingleChildScrollView(
          child:  Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               SizedBox(height: screenHeight * 0.05),

                 Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Row(
                        children: [
                         IconButton(
                  onPressed: () => Navigator.pop(context),
                  iconSize: screenWidth * 0.065,
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                          const Spacer(),
                          IconButton(
                            onPressed: _openSettings,
                            icon: Icon(Icons.settings_outlined, size: screenWidth * 0.075),
                          ),
                        ],
                      ),
                    ),


              
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
                                  "amina",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                // Show email only if toggle is on
                               // if (_showEmail)
                                  Text(
                                    "amina@gmail.com",
                                    style: TextStyle(
                                      color: const Color(0xff808897),
                                      fontSize: screenWidth * 0.033,
                                    ),
                                  ),
                                    SizedBox(height: screenHeight * 0.005),

                                  Text(
                            "hello", // _userBio,
                              softWrap: true,
                              style: TextStyle(
                                color: const Color(0xff808897),
                                fontSize: screenWidth * 0.035,
                                height: 1.6,
                              ),
                            ),
                                  
                                SizedBox(height: screenHeight * 0.01),
                                Container(
                                  height: screenHeight * 0.001,
                                  width: screenWidth * 0.7,
                                  color: const Color(0xffdfe1e6),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _statItem("Items","6"),// "$_itemsCount"),
                                    _divider(),
                                    _statItem("Deals","4"),// "$_dealsCount"),
                                    _divider(),
                                    _statItem("Rating","5"), //_averageRating > 0
                                        //? _averageRating.toStringAsFixed(1)
                                       // : "N/A"),
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
      color: Colors.grey[400],
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

                     SizedBox(height: screenHeight * 0.04),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Bio",
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           color: const Color(0xff808897),
                      //           fontSize: screenWidth * 0.05,
                      //         ),
                      //       ),
                      //       SizedBox(height: screenHeight * 0.005),
                      //       Text(
                      //       "hello", // _userBio,
                      //         softWrap: true,
                      //         style: TextStyle(
                      //           color: const Color(0xff808897),
                      //           fontSize: screenWidth * 0.035,
                      //           height: 1.6,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      

                       Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                        child:Row(
  children: [
    Expanded(child: StandardButton(text: "Message", onPressed: () {})),
    SizedBox(width: 10),
    Expanded(child: StandardButton(text: "Report", onPressed: () {},color: Color(0xffdfe1e6) ,  textColor: Colors.black , )),
  ],
)
                       ),

                        SizedBox(height: screenHeight * 0.02),

                      Padding(
  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
  child: Text(
    "Listings",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screenWidth * 0.055,
    ),
  ),
),
SizedBox(height: screenHeight * 0.02),

if (_fakeListings.isEmpty)
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
      itemCount: _showAll ? _fakeListings.length : (_fakeListings.length > 2 ? 2 : _fakeListings.length),
      itemBuilder: (context, index) {
        final listing = _fakeListings[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      listing['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${listing['price']} DA',
                          style: const TextStyle(color: Color(0xff2853af), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  ),

if (_fakeListings.length > 2)
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
                    //leading: const Icon(Icons.edit_outlined),
                    title: const Text("Report",
                        style: TextStyle(fontWeight: FontWeight.bold , color: Colors.red)),
                   
                    onTap: () async {},
                  ),
                  const Divider(height: 1, color: Color(0xffdfe1e6)),

                 const Divider(height: 1, color: Color(0xffdfe1e6)),

               
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