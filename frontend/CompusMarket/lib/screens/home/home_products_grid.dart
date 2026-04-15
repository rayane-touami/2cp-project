import 'package:flutter/material.dart';
class HomeProductsGrid extends StatefulWidget {
const HomeProductsGrid({super.key});
@override
State<HomeProductsGrid> createState() => _HomeProductsGridState();
}
class _HomeProductsGridState extends State<HomeProductsGrid> {
//list.generate -> creates 20 items automatically
//index -> the number of each item (0,1,2,...19)
final List<Map<String, dynamic>> _products = [ // crating list of 20 fake products 
  {'name': 'AirPods',    'price': '4500,0 DA', 'rating': 4.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/airpods.jpg'},
  {'name': 'Skate Board',    'price': '3000.0 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/skate.jpg'},
  {'name': 'Apple Watch',    'price': '15500.0 DA', 'rating': 3.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/applewatch.jpg'},
  {'name': 'Longhchamp Bag',    'price': '3500.0 DA', 'rating': 5.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/bag.jpg'},
  {'name': 'Bike',    'price': '22500.0 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/bike.jpg'},
  {'name': 'Black Airpods',    'price': '2500.0 DA', 'rating': 3.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/blackairpods.jpg'},
  {'name': 'Sport Water Bottle',    'price': '1000.0 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/bottle.jpg'},
  {'name': 'Casio Vintage Watch',    'price': '2000.0 DA', 'rating': 5.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/casiowatch.jpg'},
  {'name': 'Go Pro Camera',    'price': '345000.0 DA', 'rating': 3.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/gopro.jpg'},
  {'name': 'Apple Ipad ',    'price': '900000.0 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/ipad.jpg'},
  {'name': 'Iphon 17 Pro Max',    'price': '300000.0 DA', 'rating': 5.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/iphone17promax.jpg'},
  {'name': 'Macbook Air ',    'price': '114500.0 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/macbookair.jpg'},
  {'name': 'Microphone Professional',    'price': '9000.0 DA', 'rating': 3.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/mic.jpg'},
  {'name': 'Acer Monitor',    'price': '445000 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/monitor.jpg'},
  {'name': 'Nintendo',    'price': '52500.0 DA', 'rating': 5.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/nintendo.jpg'},
  {'name': 'Pc Support ',    'price': '1000.0 DA', 'rating': 4.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/supportpc.jpg'},
  {'name': 'Play Station 5',    'price': '114500.0 DA', 'rating': 4.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/ps5.jpg'},
  {'name': 'rhode Lip Gloss ',    'price': '4500.0 DA', 'rating': 5.0, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/rhode.jpg'},
  {'name': 'Adidas Blue Samba Shoes',    'price': '14500.0 DA', 'rating': 4.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/sambashoes.jpg'},
  {'name': 'Tom Ford Parfum',    'price': '15500.0 DA', 'rating': 3.5, 'isFavorite': false, 'isRated': false, 'image': 'assets/images/products/tomfordparfum.jpg'},

];
@override
Widget build(BuildContext context) { //This function = what appears on screen
final screenWidth = MediaQuery.of(context).size.width;
return GridView.builder( // scrollable grid of items
shrinkWrap: true,  // takes only space it needs inside the Column
physics: const NeverScrollableScrollPhysics(), //Don't scroll here , Parent widget handles scrolling
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( //fixed number of columns
crossAxisCount: 2,                    // 2 cards per row
crossAxisSpacing: screenWidth * 0.03, // space between columns
mainAxisSpacing: screenWidth * 0.03,  // space between rows
childAspectRatio: 0.75,  
      ),
itemCount: _products.length, //20 cards
itemBuilder: (context, index) {
  return _ProductCard(
    product: _products[index],
    onFavoriteToggle: () {
      setState(() {
        // ! flips true to false and false to true
        _products[index]['isFavorite'] = !_products[index]['isFavorite'];
      });
    },
    onRatingToggle: () {
      setState(() {
        _products[index]['isRated'] = !_products[index]['isRated'];
      });
    },
  );
},
    );
  }                                     
}


// ── PRODUCT CARD WIDGET ──
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onRatingToggle;

  const _ProductCard({
    required this.product,
    required this.onFavoriteToggle,
    required this.onRatingToggle,
  });

  @override
  Widget build(BuildContext context) {
final screenWidth = MediaQuery.of(context).size.width;
return AnimatedContainer( //Create a card with animation + shadow + rounded corners
duration: const Duration(milliseconds: 300),
curve: Curves.easeInOut,
decoration: BoxDecoration( //his is what gives the card look
color: Colors.white,
borderRadius: BorderRadius.circular(screenWidth * 0.05), // rounded corners
// shadow below the card = looks like it pops out of the screen
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.08), // very light black shadow
blurRadius: 12, // how spread/soft the shadow is
offset: const Offset(0, 6), // 0 = no left/right, 6 = 6px downward
spreadRadius: 1, //how big the shadow grows
        ),
    ],
    ),
//Add the image placeholder + heart button
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

// ── IMAGE SECTION (takes all available space above) ──
       Expanded(
        child: Stack( // lets us put heart button ON TOP of the image
        children: [
 // ── IMAGE PLACEHOLDER ──
         Container( 
          width: double.infinity, //full width of the card
           decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),  // light grey
           borderRadius: BorderRadius.only(
            topLeft: Radius.circular(screenWidth * 0.05),
            topRight: Radius.circular(screenWidth * 0.05),
           ),
         ),
         child: Image.asset(
          product['image'],
          fit: BoxFit.cover, //// fills the space without stretching
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon( 
            
            Icons.image_outlined, //shows icon if image fails to load
            size: screenWidth * 0.12,
            color: Colors.grey[400],
          ),
          ),
         ),
         ),
        
// ── HEART BUTTON (floating on top right of image) ──
 Positioned( // Positioned inside Stack = exact position
  top: 8,
  right: 8,
  child: GestureDetector(             // ✅ tapping heart calls onFavoriteToggle
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
        product['isFavorite'] ? Icons.favorite : Icons.favorite_border, // ✅ toggled
        color: product['isFavorite'] ? Colors.red : Colors.grey,        // ✅ toggled
        size: screenWidth * 0.05,        
      ),
    ),
  ),
  ),
 ), 

        ],
        ),
        ),

//Add name + price + star below the image
        // ── INFO SECTION ──
Padding(
  padding: EdgeInsets.all(screenWidth * 0.025),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      // ── PRODUCT NAME ──
      Text(
        product['name'],
        style: TextStyle(
          fontSize: screenWidth * 0.033,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,  // too long → shows ...
      ),

      SizedBox(height: screenWidth * 0.01),

      // ── PRICE + STAR ROW ──
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // price
          Text(
            product['price'],
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A73E8),  // blue
            ),
          ),

          // star + rating number
          GestureDetector(              // ✅ tapping star calls onRatingToggle
            onTap: onRatingToggle,
            child: Row(
            children: [
              Icon(
                product['isRated'] ? Icons.star : Icons.star_border,  // outline star for now
                color: product['isRated'] ? Colors.amber : Colors.grey, // ✅ toggled
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
