// ignore: file_names
import 'package:compusmarket/screens/home/add_new_product.dart';
import 'package:compusmarket/screens/profiles/Edit_profil.dart';
import 'package:compusmarket/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:compusmarket/screens/home/home_products_grid.dart';

class MyProfileScreen extends StatefulWidget{
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
  }

   class _MyProfileScreenState extends State<MyProfileScreen>{
    String _userName = "Malak Samai";        // ideally fetched from your AuthService
String _userEmail = "malak@example.com";
String _userPhone = "0555123456";
String _userUniversityId = "1";
List<dynamic> _universities = [];
    final List<Map<String, dynamic>> _myListings = [
  {
    'name': 'SONY Premium Wireless',
    'price': '3500.00 DA',
    'priceValue': 3500.00,
    'category': 'Electronics',
    'rating': 4.5,
    'isRated': false,
    'image': 'assets/images/products/airpods.jpg',
  },
  {
    'name': 'SONY Premium Casque',
    'price': '3500.00 DA',
    'priceValue': 3500.00,
    'category': 'Electronics',
    'rating': 4.0,
    'isRated': false,
    'image': 'assets/images/products/blackairpods.jpg',
  },
  {
    'name': 'SONY Premium Wireless',
    'price': '3500.00 DA',
    'priceValue': 3500.00,
    'category': 'Electronics',
    'rating': 4.5,
    'isRated': false,
    'image': 'assets/images/products/airpods.jpg',
  },
  {
    'name': 'SONY Premium Wireless',
    'price': '3500.00 DA',
    'priceValue': 3500.00,
    'category': 'Electronics',
    'rating': 4.5,
    'isRated': false,
    'image': 'assets/images/products/airpods.jpg',
  },
];

bool _showAll = false;
bool _notificationsEnabled = false;
bool _showEmail = false;
bool _sellerMode = false;

@override
void initState() {
  super.initState();
  _loadUniversities();
}

Future<void> _loadUniversities() async {
  try {
    final unis = await AuthService.getUniversities();
    setState(() => _universities = unis);
  } catch (e) {
    print('Error: $e');
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/blue_background.jfif'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.06),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child:Row(
                children: [
                   Text(
                "Profil",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.07,
                ),
              ),
              Spacer(),
              IconButton(onPressed: (){
                showModalBottomSheet(
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
  ),
  builder: (context) {
    return StatefulBuilder( 
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
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
              SizedBox(height: 5),
              Divider(height: 1, color: Color(0xffdfe1e6)),

              // Edit Profile
              ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(">", style: TextStyle(fontSize: screenWidth * 0.04)),
                onTap: () {
  Navigator.pop(context); // close bottom sheet first
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfileScreen(
        name: _userName,
        email: _userEmail,
        phone: _userPhone,
        universityId: _userUniversityId,
        universities: _universities,
      ),
    ),
  );
},
              ),
              Divider(height: 1, color: Color(0xffdfe1e6)),

              // Notifications with switch
              SwitchListTile(
                secondary: Icon(Icons.notifications_outlined),
                title: Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
                value: _notificationsEnabled,
                activeThumbColor: Color(0xff2853af),
                onChanged: (value) {
                  setModalState(() => _notificationsEnabled = value);
                  setState(() => _notificationsEnabled = value);
                },
              ),
              Divider(height: 1, color: Color(0xffdfe1e6)),

              // Show Email with switch
              SwitchListTile(
                secondary: Icon(Icons.email_outlined),
                title: Text("Show Email", style: TextStyle(fontWeight: FontWeight.bold)),
                value: _showEmail,
                activeThumbColor: Color(0xff2853af), 
                onChanged: (value) {
                  setModalState(() => _showEmail = value);
                  setState(() => _showEmail = value);
                },
              ),
              Divider(height: 1, color: Color(0xffdfe1e6)),

              // Active Seller Mode with switch
              // SwitchListTile(
              //   secondary: Icon(Icons.storefront),
              //   title: Text("Active Seller Mode", style: TextStyle(fontWeight: FontWeight.bold)),
              //   value: _sellerMode,
              //   activeThumbColor: Color(0xff2853af),
              //   onChanged: (value) {
              //     setModalState(() => _sellerMode = value);
              //     setState(() => _sellerMode = value);
              //   },
              // ),
              // Divider(height: 1, color: Color(0xffdfe1e6)),

              // Logout
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  },
);
              },
               icon:Icon(Icons.settings_outlined , size: screenWidth*0.075,) )
                ],
              )
            ),

            // Avatar + Card Stack
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // White card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    margin: EdgeInsets.only(top: 90),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 35),
                        Text(
                          "Malak Samai",
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          height: screenHeight * 0.001,
                          width: screenWidth * 0.7,
                          color: Color(0xffdfe1e6),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _statItem("Items", "6"),
                            _divider(),
                            _statItem("Deals", "2"),
                            _divider(),
                            _statItem("Feedback", "5.2 H"),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          height: screenHeight * 0.001,
                          width: screenWidth * 0.7,
                          color: Color(0xffdfe1e6),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),

                // Avatar
                Positioned(
                  top: 0,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/images/malak's_pic.jpg"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.025),

            // About section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff808897),
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Computer Science senior at UO. Selling textbooks and tech gadgets from my previous semesters. All items are well-maintained and open for reasonable offers.",
                    softWrap: true,
                    style: TextStyle(
                      color: Color(0xff808897),
                      fontSize: screenWidth * 0.035,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            
           Padding(
            padding:EdgeInsets.symmetric(horizontal: screenWidth*0.06),
            child: Text(
                    "My Listings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                    ), ),
            ),
            SizedBox(height: screenHeight*0.02,),
            Padding(
              padding:EdgeInsets.symmetric(horizontal: screenWidth*0.04), 
              child:GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenWidth * 0.03,
                  childAspectRatio: 0.75,
                ),
                itemCount: visibleListings.length,
                itemBuilder: (context, index) {
                  final product = visibleListings[index];
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.18),
          blurRadius: 15,
          spreadRadius: 1,
          offset: Offset(0, 0),
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
        onEdit: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewProductScreen()));
        },
      ),
    ),
  );
                },
              ),),

// 👇 Only show the button if there are more than 2 listings
if (_myListings.length > 2)
  Center(
    child: TextButton(
      onPressed: () {
        setState(() {
          _showAll = !_showAll;
        });
      },
      child: Text(
        _showAll ? "View less <" : "View more >",
        style: TextStyle(
          color: Color(0xff2853af),
          fontWeight: FontWeight.bold,
          fontSize: screenWidth*0.035,
        ),
      ),
    ),
  ),



          


          ],
        ),
      ),
    ),
  );
}

   Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Color(0xff808897),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: 1,
      height: 50,
      color: Color(0xffdfe1e6),
    );
  }

   }

   