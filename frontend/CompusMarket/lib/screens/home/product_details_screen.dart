import 'package:flutter/material.dart';
import 'home_products_grid.dart'; // To access globalFavoriteProducts and globalRatedProducts

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late bool isFavorite;
  late bool isRated;
  bool isDescriptionExpanded = false;
  List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  // We'll simulate variants/gallery with duplicates of the main image since
  // our dummy data currently only has one image per product.
  int selectedImageIndex = 0;
  late List<String> galleryImages;

  @override
  void initState() {
    super.initState();
    isFavorite = globalFavoriteProducts.any(
      (p) => p['name'] == widget.product['name'],
    );
    isRated = globalRatedProducts.any(
      (p) => p['name'] == widget.product['name'],
    );
    
    // Simulate multiple thumbnail views
    final image = widget.product['image'] ?? '';
    galleryImages = [image, image, image]; 
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        globalFavoriteProducts.add(widget.product);
      } else {
        globalFavoriteProducts.removeWhere(
          (p) => p['name'] == widget.product['name'],
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleRating() {
    setState(() {
      isRated = !isRated;
      if (isRated) {
        globalRatedProducts.add(widget.product);
      } else {
        globalRatedProducts.removeWhere(
          (p) => p['name'] == widget.product['name'],
        );
      }
    });
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateBottomSheet) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _comments.isEmpty
                        ? const Center(
                            child: Text(
                              'No comments yet. Be the first to comment!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundColor: Color(0xFF1A73E8),
                                        child: Icon(Icons.person, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(_comments[index]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (_commentController.text.trim().isNotEmpty) {
                            setState(() {
                              _comments.add(_commentController.text.trim());
                            });
                            setStateBottomSheet(() {});
                            _commentController.clear();
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFF1A73E8),
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final modelText = widget.product['model'] ?? 'Standard Edition';
    final descriptionText = widget.product['description'] ?? 
        'This is an excellent product with outstanding build quality and great performance. It features the latest design language, top-tier materials, and an extensive array of functions suited for almost any scenario. An absolute must-have.';
        
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE & HEADER STACK
            Stack(
              children: [
                // Main Product Image
                Container(
                  width: double.infinity,
                  height: screenWidth * 1.1,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Hero(
                    tag: 'product_image_${widget.product['name']}',
                    child: Image.asset(
                      galleryImages[selectedImageIndex],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: screenWidth * 0.2,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Back Button
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                )
                              ]
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                        // Favorite Toggle
                        GestureDetector(
                          onTap: _toggleFavorite,
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                )
                              ]
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: screenWidth * 0.05),

            // THUMBNAILS GALLERY
            SizedBox(
              height: 70,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                scrollDirection: Axis.horizontal,
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedImageIndex = index),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: selectedImageIndex == index
                              ? const Color(0xFF1A73E8)
                              : Colors.transparent,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: AssetImage(galleryImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenWidth * 0.05),

            // PRODUCT DETAILS INFO
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Model
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product['name'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              modelText,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Price
                      Text(
                        widget.product['price'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenWidth * 0.05),

                  // RATING & COMMENTS ROW
                  Row(
                    children: [
                      // Rating Button
                      GestureDetector(
                        onTap: _toggleRating,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isRated ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.product['rating']} Rate',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Comments Button
                      GestureDetector(
                        onTap: () => _showCommentsSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                color: Colors.black87,
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Comments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenWidth * 0.08),

                  // DESCRIPTION
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    descriptionText,
                    maxLines: isDescriptionExpanded ? null : 3,
                    overflow: isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      });
                    },
                    child: Text(
                      isDescriptionExpanded ? 'Show less' : 'Learn more',
                      style: const TextStyle(
                        color: Color(0xFF1A73E8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 15),
          child: ElevatedButton(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connecting you to the seller...'),
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 0,
            ),
            child: const Text(
              'Contact seller',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
