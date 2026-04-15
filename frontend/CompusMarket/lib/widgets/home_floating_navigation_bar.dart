import 'package:flutter/material.dart';
import 'dart:ui';

class HomeFloatingNavigationBar extends StatefulWidget {
  //inputs
  final int currentIndex;           // which icon is selected (0=home,1=fav,2=chat,3=profile)
  final ValueChanged<int> onTap;    // called when user taps an icon

  const HomeFloatingNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<HomeFloatingNavigationBar> createState() => _HomeFloatingNavigationBarState();
}

class _HomeFloatingNavigationBarState extends State<HomeFloatingNavigationBar> {

  // icons list
  final List<IconData> _icons = [
    Icons.home_rounded,         // home
    Icons.favorite_rounded,     // favorites
    Icons.chat_bubble_rounded,  // chat
    Icons.person_rounded,       // profile
  ];

  @override
  Widget build(BuildContext context) { //this return what user sees 
    final screenWidth = MediaQuery.of(context).size.width;

    // ── FIXED AT BOTTOM, CENTERED, DOESN'T SCROLL ──
    return Positioned(
      bottom: 28,               // distance from bottom of screen
      left: 0,
      right: 0,
      child: Center(
        child: ClipRRect(
  borderRadius: BorderRadius.circular(50),
  child: BackdropFilter( //blur effect
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      width: screenWidth * 0.72,              // not full width — centered pill
            height: 64,
            decoration: BoxDecoration(
              // ── TRANSPARENT FROSTED GLASS EFFECT ──
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withOpacity(0.7), // subtle white border
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_icons.length, (index) {
                final bool isSelected = widget.currentIndex == index;

                return GestureDetector(
                  onTap: () => widget.onTap(index), // tell parent which icon was tapped
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250), // smooth animation
                    curve: Curves.easeInOut,
                    width: screenWidth * 0.11,
                    height: screenWidth * 0.11,
                    decoration: BoxDecoration(
                      // ── BLUE TRANSPARENT CIRCLE when selected ──
                      color: isSelected
                          ? Colors.blueAccent.withOpacity(0.75)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _icons[index],
                        // ── selected = white, unselected = light grey ──
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                        size: screenWidth * 0.058,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    ));
  }
}