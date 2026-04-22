import 'package:flutter/material.dart';
import 'add_new_product.dart';
import 'notifications_screen.dart';

class HomeHeader extends StatelessWidget {
  //Creates your header widget. StatelessWidget because the header doesn't change by itself.

  final String userName;
  final String university;
  final String? profileImageUrl;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.university,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth * 0.13; // 13% of screen width
    final nameFontSize = screenWidth * 0.042;
    final locationFontSize = screenWidth * 0.033;
    final buttonSize = screenWidth * 0.11;
    final iconSize = screenWidth * 0.057;

    return Row(
      //puts everything side by side horizontally
      children: [
        // Profile photo
        ClipOval(
          child: profileImageUrl != null
              ? Image.network(
                  profileImageUrl!,
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _defaultAvatar(avatarSize),
                )
              : _defaultAvatar(avatarSize),
        ),
        SizedBox(width: screenWidth * 0.03),

        // Name + university
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userName.isEmpty ? "Welcome!" : "Welcome $userName",
                style: TextStyle(
                  fontSize: nameFontSize,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                university.isEmpty ? "" : university,
                style: TextStyle(
                  fontSize: locationFontSize,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Bell button
        _RoundIconButton(
          icon: Icons.notifications_outlined,
          iconColor: Colors.black87,
          buttonSize: buttonSize,
          iconSize: iconSize,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
        // Add button
        _RoundIconButton(
          icon: Icons.add,
          iconColor: Colors.blue,
          buttonSize: buttonSize,
          iconSize: iconSize,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewProductScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _defaultAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(Icons.person, color: Colors.grey, size: size * 0.5),
    );
  }
}



class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final double buttonSize;
  final double iconSize;

  const _RoundIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
    required this.buttonSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
