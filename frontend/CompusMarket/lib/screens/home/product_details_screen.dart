import 'dart:io';
import 'package:flutter/material.dart';
import 'home_products_grid.dart';
import '../../services/announcement_service.dart';

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
  List<Map<String, dynamic>> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  int selectedImageIndex = 0;
  late List<String> galleryImages;

  @override
  void initState() {
    super.initState();

    final productName = widget.product['name'] ?? widget.product['title'] ?? '';

    isFavorite = globalFavoriteProducts.any(
      (p) => (p['name'] ?? p['title']) == productName,
    );
    isRated = globalRatedProducts.any(
      (p) => (p['name'] ?? p['title']) == productName,
    );

    // ── Handle images from API (photos list) or fallback to single image ──
    final photos = widget.product['photos'];
    if (photos != null && photos is List && photos.isNotEmpty) {
      galleryImages = photos
          .map((p) => p is Map ? (p['url'] ?? '').toString() : p.toString())
          .where((url) => url.isNotEmpty)
          .toList();
    } else {
      final image = widget.product['photo']?.toString() ??
          widget.product['image']?.toString() ?? '';
      galleryImages = image.isNotEmpty ? [image] : [];
    }

    if (galleryImages.isEmpty) galleryImages = [''];
  }

  String get _productName =>
      widget.product['name'] ?? widget.product['title'] ?? '';

  String get _productPrice =>
      widget.product['price']?.toString() ?? '';

  String get _productDescription =>
      widget.product['description'] ?? '';

  double get _productRating =>
      (widget.product['average_rating'] ?? widget.product['rating'] ?? 0.0)
          .toDouble();

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        globalFavoriteProducts.add(widget.product);
      } else {
        globalFavoriteProducts.removeWhere(
          (p) => (p['name'] ?? p['title']) == _productName,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
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
          (p) => (p['name'] ?? p['title']) == _productName,
        );
      }
    });
  }

  // ── Build image widget based on product type ──
  Widget _buildImage(String imagePath, {BoxFit fit = BoxFit.cover}) {
    final bool isUserAdded = widget.product['isUserAdded'] == true;
    final bool isReal = widget.product['isReal'] == true;
    final screenWidth = MediaQuery.of(context).size.width;

    if (imagePath.isEmpty) {
      return Center(
        child: Icon(Icons.image_outlined,
            size: screenWidth * 0.2, color: Colors.grey[400]),
      );
    }

    // User added product → local file
    if (isUserAdded) {
      return Image.file(
        File(imagePath),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(Icons.image_outlined,
              size: screenWidth * 0.2, color: Colors.grey[400]),
        ),
      );
    }

    // Real API product OR starts with http → network image
    if (isReal || imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFF1A73E8),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(Icons.image_outlined,
              size: screenWidth * 0.2, color: Colors.grey[400]),
        ),
      );
    }

    // Fake/local asset
    return Image.asset(
      imagePath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(Icons.image_outlined,
            size: screenWidth * 0.2, color: Colors.grey[400]),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            itemCount: galleryImages.length,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.1,
                maxScale: 4.0,
                child: _buildImage(galleryImages[index], fit: BoxFit.contain),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context) {
    bool isFetching = false;
    bool localIsLoading = widget.product['isReal'] == true;
    String errorMessage = '';

    void loadData(StateSetter setStateBottomSheet) async {
      if (isFetching) return;
      isFetching = true;
      try {
        final commentsData =
            await AnnouncementService.getComments(widget.product['id']);
        if (mounted) {
          setState(() {
            _comments = List<Map<String, dynamic>>.from(
              commentsData.map((e) => {
                'text': e['content'] ?? e['text'] ?? '',
                'user': e['user']?['username'] ?? e['author'] ?? 'User',
              }),
            );
          });
          setStateBottomSheet(() {
            localIsLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setStateBottomSheet(() {
            localIsLoading = false;
            errorMessage = 'Failed to load comments.';
          });
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            if (localIsLoading && !isFetching) {
              loadData(setStateBottomSheet);
            }
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
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: localIsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : errorMessage.isNotEmpty
                              ? Center(
                                  child: Text(errorMessage,
                                      style: const TextStyle(
                                          color: Colors.red)))
                              : _comments.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No comments yet. Be the first!',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _comments.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xFF1A73E8),
                                                  child: Icon(Icons.person,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _comments[index]
                                                                ['user'] ??
                                                            'User',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(_comments[index]
                                                              ['text'] ??
                                                          ''),
                                                    ],
                                                  ),
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            if (_commentController.text.trim().isNotEmpty) {
                              final text = _commentController.text.trim();
                              _commentController.clear();

                              if (widget.product['isReal'] == true) {
                                try {
                                  await AnnouncementService.createComment(
                                      widget.product['id'], text);
                                  if (mounted) {
                                    setState(() {
                                      _comments.add(
                                          {'text': text, 'user': 'You'});
                                    });
                                    setStateBottomSheet(() {});
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Failed to post comment')),
                                    );
                                  }
                                }
                              } else {
                                setState(() {
                                  _comments
                                      .add({'text': text, 'user': 'You'});
                                });
                                setStateBottomSheet(() {});
                              }
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final modelText = widget.product['model'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE SLIDESHOW + HEADER ──
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenWidth * 1.1,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: GestureDetector(
                    onTap: () =>
                        _showFullScreenImage(context, selectedImageIndex),
                    child: Stack(
                      children: [
                        // ── PageView for swipeable images ──
                        PageView.builder(
                          itemCount: galleryImages.length,
                          onPageChanged: (index) =>
                              setState(() => selectedImageIndex = index),
                          itemBuilder: (context, index) {
                            return _buildImage(galleryImages[index],
                                fit: BoxFit.cover);
                          },
                        ),
                        // ── Page indicator dots ──
                        if (galleryImages.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                galleryImages.length,
                                (index) => AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  width:
                                      selectedImageIndex == index ? 20 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: selectedImageIndex == index
                                        ? const Color(0xFF1A73E8)
                                        : Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Back + Favorite ──
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05, vertical: 10),
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
                                    blurRadius: 5)
                              ],
                            ),
                            child: const Icon(Icons.arrow_back,
                                color: Colors.black),
                          ),
                        ),
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
                                    blurRadius: 5)
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite ? Colors.red : Colors.grey,
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

            // ── THUMBNAILS ──
            if (galleryImages.length > 1)
              SizedBox(
                height: 70,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  scrollDirection: Axis.horizontal,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedImageIndex = index),
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
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: _buildImage(galleryImages[index],
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),

            SizedBox(height: screenWidth * 0.05),

            // ── SELLER PROFILE ──
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF1A73E8),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['seller'] ??
                              widget.product['sellerName'] ??
                              'Campus Seller',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          widget.product['university']?.toString() ??
                              'Verified User',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Navigating to Seller Profile...')),
                      );
                    },
                    child: const Text('View Profile'),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenWidth * 0.05),

            // ── PRODUCT INFO ──
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _productName,
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (modelText.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                modelText,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        _productPrice.contains('DA')
                            ? _productPrice
                            : '$_productPrice DA',
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenWidth * 0.05),

                  // ── RATING & COMMENTS ──
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleRating,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.amber.withOpacity(0.5)),
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
                                '$_productRating Rate',
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
                      GestureDetector(
                        onTap: () => _showCommentsSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.comment_outlined,
                                  color: Colors.black87, size: 20),
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

                  // ── DESCRIPTION ──
                  const Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _productDescription.isEmpty
                      ? Text(
                          'No description available.',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500],
                              height: 1.5),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _productDescription,
                              maxLines:
                                  isDescriptionExpanded ? null : 3,
                              overflow: isDescriptionExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => setState(() =>
                                  isDescriptionExpanded =
                                      !isDescriptionExpanded),
                              child: Text(
                                isDescriptionExpanded
                                    ? 'Show less'
                                    : 'Learn more',
                                style: const TextStyle(
                                  color: Color(0xFF1A73E8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 15),
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