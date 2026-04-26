import 'package:flutter/material.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';
import '../../services/profile_api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String universityId;
  final List<dynamic> universities;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.universityId,
    required this.universities,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController numberController;
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController bioController;

  String? _selectedUniversityId;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    numberController = TextEditingController(text: widget.phone);
    bioController = TextEditingController(text: widget.bio);
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    _selectedUniversityId = widget.universityId;

    for (final c in [nameController, emailController, numberController,
        bioController, currentPasswordController, newPasswordController]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    bioController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  iconSize: screenWidth * 0.065,
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              Center(
  child: GestureDetector(
    onTap: () => _showImagePickerOptions(context),
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[350],
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ClipOval(
        child: Icon(
          Icons.person,
          size: 55,
          color: Colors.grey[600],
        ),
      ),
    ),
  ),
),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StandardTextfield(
                      title: "Full Name",
                      hint: "Enter your name",
                      controller: nameController,
                      isError: _submitted && nameController.text.isEmpty,
                      fillColor: Colors.white,
                      hasShadow: true,
                    ),
                    StandardTextfield(
                      title: "E-mail",
                      hint: "Enter your email",
                      isEmail: true,
                      controller: emailController,
                      isError: _submitted && emailController.text.isEmpty,
                      hasShadow: true,
                      fillColor: Colors.white,
                    ),
                    StandardTextfield(
                      title: "Phone Number",
                      hint: "Enter your phone number",
                      isPhone: true,
                      controller: numberController,
                      isError: _submitted && numberController.text.isEmpty,
                      hasShadow: true,
                      fillColor: Colors.white,
                    ),
                    StandardTextfield(
                      title: "Bio",
                      hint: "Tell others about yourself...",
                      controller: bioController,
                      isError: false,
                      hasShadow: true,
                      fillColor: Colors.white,
                      maxLines: 4,
                    ),

                   
                    
                    // ── University Dropdown ─────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "University",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.037,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.0074),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenWidth * 0.035),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(screenWidth * 0.035),
                              border: Border.all(
                                color: (_submitted && _selectedUniversityId == null)
                                    ? Colors.red
                                    : Colors.transparent,
                                width: screenWidth * 0.0047,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.01),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  "Select your university",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: const Color(0xffa4abb8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                                value: _selectedUniversityId,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                dropdownColor: Colors.white,
                                items: widget.universities.map((uni) {
                                  return DropdownMenuItem<String>(
                                    value: uni['id'].toString(),
                                    child: Text(uni['name'].toString()),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedUniversityId = val),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),
                    StandardButton(
                      text: _isLoading ? "Saving..." : "Save Changes",
                      onPressed: _isLoading ? null : () => _saveChanges(context),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // little bar on top
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.photo_library, color: Colors.blue),
            title: Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              // TODO: open gallery
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: Colors.blue),
            title: Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              // TODO: open camera
            },
          ),
        ],
      ),
    ),
  );
}

  void _saveChanges(BuildContext context) async {
    setState(() => _submitted = true);

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        numberController.text.isEmpty) {
      return;
    }

    // Password: either both filled or both empty
    final hasPasswordChange = currentPasswordController.text.isNotEmpty ||
        newPasswordController.text.isNotEmpty;
    if (hasPasswordChange &&
        (currentPasswordController.text.isEmpty ||
            newPasswordController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill both current and new password fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Update account (name + optional password)
      await ProfileApiService.updateAccount(
        fullName: nameController.text.trim(),
        currentPassword: hasPasswordChange
            ? currentPasswordController.text
            : null,
        newPassword: hasPasswordChange
            ? newPasswordController.text
            : null,
      );

      // 2. Update profile fields (bio, etc.)
      await ProfileApiService.updateMyProfile(
       bio: bioController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated! ✅')),
        );
        // Return true so MyProfileScreen knows to reload
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Update failed: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}