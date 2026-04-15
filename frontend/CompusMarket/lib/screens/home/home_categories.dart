import 'package:flutter/material.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({super.key});

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State <HomeCategories> {
    // ── SELECTED CATEGORY (All is selected by default) ──
  String _selected = 'All';

  //list of all categories 
  final List<Map<String, dynamic>> _categories = [
    {'label': 'All',               'icon': Icons.apps},
    {'label': 'Books',             'icon': Icons.menu_book},
    {'label': 'Electronics',       'icon': Icons.devices},
    {'label': 'Accessories',       'icon': Icons.watch},
    {'label': 'Clothes',           'icon': Icons.checkroom},
    {'label': 'Furniture',         'icon': Icons.chair},
    
  ];

  @override
  Widget build(BuildContext context) {
    //responsive sizes 
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth *0.035;
    final iconSize = screenWidth *0.045;

    return SizedBox(
      height: screenWidth * 0.13, //height of the row
      child: ListView.builder(
        scrollDirection: Axis.horizontal, //horizontal scroll
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category['label'] == _selected;

          return GestureDetector(
            onTap: () {
              setState (() {
                _selected = category['label']; //update selected category

              });
                            // TODO: later → filter products by category

            },
            child: AnimatedContainer(
               duration: const Duration(milliseconds: 250), // speed of animation
               curve: Curves.easeInOut,   
               
               margin: EdgeInsets.only(right: screenWidth * 0.025),
               padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenWidth * 0.02,
               ),        
// ── STYLE changes based on selected or not ──
               decoration: BoxDecoration(
                color: isSelected? const Color(0xFF1A73E8) //blue when selected
                : const Color(0xFFF2F2F2), //grey when selected
                borderRadius: BorderRadius.circular(screenWidth * 0.05), //oval shape
                boxShadow: isSelected
                ? [
                  BoxShadow(
                    color: const Color(0xFF1A73E8).withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0,4), //shadow goes down = pop toward
                   )
                ]
                :[], //no shadow when no selected 
                ) ,

 // ── SCALE ANIMATION (pops toward screen when selected) ──
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0, //slightly bigger when selected
        duration:const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            //icon
            Icon(
              category['icon'],
              size: iconSize,
              color: isSelected ? Colors.white :Colors.grey,

            ),
            SizedBox(width: screenWidth * 0.015),

            //label
            Text(
              category['label'],
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
          ),
      ),
            ),
          ) ; 
          },
      )
    );
  
  }
}