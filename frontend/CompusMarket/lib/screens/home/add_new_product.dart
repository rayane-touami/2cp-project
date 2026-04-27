import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/university_service.dart';
import '../../services/category_service.dart';
import 'home_products_grid.dart';
import '../../services/announcement_service.dart';
import '../../services/api_config.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final _formKey = GlobalKey<FormState>();
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _currentImageIndex = 0;

  final List<String> _types = [
    'Books',
    'Electronics',
    'Accessories',
    'Clothing',
    'Furniture',
    'Sports',
    'Vehicles',
  ];
  String _selectedType = 'Books';

  List<dynamic> _universitiesList = [];
  List<dynamic> _categoriesList = [];
  bool _isLoadingUniversities = true;
  String? _selectedUniversity;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        UniversityService.getUniversities(),
        CategoryService.getCategories(),
      ]);
      if (mounted) {
        setState(() {
          _universitiesList = results[0];
          _categoriesList = results[1];
          _isLoadingUniversities = false;
        });
      }
    } catch (e) {
      print('❌ Failed to load data: $e');
      if (mounted) setState(() => _isLoadingUniversities = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: screenHeight * 0.065,
                        height: screenHeight * 0.065,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.08,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: screenWidth * 0.055,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenHeight * 0.065),
                  ],
                ),
                const SizedBox(height: 30),

                _buildTextField(
                  label: 'Product Name',
                  hint: 'Enter your Product Name ....',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter a correct product name';
                    if (!RegExp(r'[a-zA-Z]').hasMatch(value))
                      return 'Product name must contain letters, not just numbers';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Product model',
                  hint: 'Enter Your Product Model ...',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter the product model';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Product price',
                  hint: 'Enter Your Product Price (DA)',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter the product price';
                    if (!RegExp(r'^\d+$').hasMatch(value.trim()))
                      return 'Price must contain only numbers';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Product description',
                  hint: '',
                  controller: _descriptionController,
                  maxLines: 5,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(r'[a-zA-Z]').hasMatch(value))
                        return 'Description must contain letters, not just numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Type',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTypeSelector(),
                const SizedBox(height: 40),

                const Text(
                  'Product pictures',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildImageUploadPlaceholder(),
                const SizedBox(height: 16),
                _buildMainButton(context, 'Confirm Pictures', () {}),
                const SizedBox(height: 40),

                const Text(
                  'Contact info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Name',
                  hint: 'Enter Your Name',
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (RegExp(r'[0-9]').hasMatch(value))
                        return 'Name must be string, not numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Phone number',
                  hint: 'Enter Your Phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(r'^\d+$').hasMatch(value.trim()))
                        return 'Please enter only numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Email',
                  hint: 'Enter Your Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'University',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _buildUniversityDropdown(),
                const SizedBox(height: 16),

                // ── POST BUTTON ──
                _buildMainButton(context, 'Post product', () async {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedImages.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add at least one picture'),
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      // ── Add locally FIRST so it always appears ──
                      final newProduct = {
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'name': _nameController.text.trim(),
                        'price': '${_priceController.text.trim()} DA',
                        'priceValue':
                            double.tryParse(_priceController.text.trim()) ??
                            0.0,
                        'category': _selectedType,
                        'rating': 0.0,
                        'isRated': false,
                        'image': _selectedImages.first.path,
                        'images': _selectedImages.map((f) => f.path).toList(),
                        'description': _descriptionController.text.trim(),
                        'isReal': false,
                        'isUserAdded': true,
                      };

                      globalRealProductsNotifier.value = [
                        newProduct,
                        ...globalRealProductsNotifier.value,
                      ];

                      // ── Then try to send to API ──
                      const categoryMap = {
                        'Books': '1',
                        'Clothing': '2',
                        'Electronics': '3',
                        'Furniture': '4',
                        'Sports': '5',
                        'Vehicles': '6',
                        'Accessories': '7',
                      };
                      final categoryId = categoryMap[_selectedType] ?? '1';

                      final universityId = () {
                        final u = _universitiesList.firstWhere(
                          (u) => u['name'] == _selectedUniversity,
                          orElse: () => {'id': ''},
                        );
                        return u['id'].toString();
                      }();

                      try {
                        await AnnouncementService.createAnnouncement(
                          title: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                          price: _priceController.text.trim(),
                          categoryId: categoryId,
                          universityId: universityId,
                          location: _selectedUniversity ?? '',
                          phoneNumber: '',
                          photos: _selectedImages,
                        );
                      } catch (apiError) {
                        print(
                          '⚠️ API failed but product shown locally: $apiError',
                        );
                      }

                      Navigator.pop(context); // close loading
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product posted successfully! ✅'),
                        ),
                      );
                      Navigator.pop(context); // go back to home
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to post product: $e')),
                      );
                    }
                  }
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _types.map((type) {
          final isSelected = type == _selectedType;
          return GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withOpacity(0.15)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                ),
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          int added = 0;
          for (var xfile in pickedFiles) {
            if (_selectedImages.length < 10) {
              _selectedImages.add(File(xfile.path));
              added++;
            }
          }
          if (pickedFiles.length > added) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can only select up to 10 images.'),
              ),
            );
          }
        });
      }
    } else {
      if (_selectedImages.length >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You have already added 10 images.')),
        );
        return;
      }
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null)
        setState(() => _selectedImages.add(File(pickedFile.path)));
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomSheetOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildBottomSheetOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildImageUploadPlaceholder() {
    if (_selectedImages.isEmpty) {
      return GestureDetector(
        onTap: _showImagePickerBottomSheet,
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 70, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Tap to add pictures',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: _selectedImages.length,
                onPageChanged: (index) {
                  setState(() => _currentImageIndex = index);
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(_selectedImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentImageIndex + 1} / ${_selectedImages.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImages.removeAt(_currentImageIndex);
                      if (_currentImageIndex >= _selectedImages.length &&
                          _currentImageIndex > 0) {
                        _currentImageIndex--;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_selectedImages.length < 10) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showImagePickerBottomSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Add more pictures',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUniversityDropdown() {
    if (_isLoadingUniversities) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_universitiesList.isEmpty) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(
          child: Text('Failed to load universities or none available'),
        ),
      );
    }
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      hint: const Text('Select a University'),
      value: _selectedUniversity,
      items: _universitiesList.map((dynamic u) {
        final String name = (u is Map && u.containsKey('name'))
            ? u['name'].toString()
            : u.toString();
        return DropdownMenuItem<String>(
          value: name,
          child: Text(name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedUniversity = value),
      validator: (value) => value == null ? 'Please select a university' : null,
    );
  }

  Widget _buildMainButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.038,
          ),
        ),
      ),
    );
  }
}
