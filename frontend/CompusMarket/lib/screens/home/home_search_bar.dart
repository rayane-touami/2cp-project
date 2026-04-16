import 'package:flutter/material.dart';

import 'filter_bottom_sheet.dart';

class HomeSearchBar extends StatelessWidget {
  final bool showFilter;

  const HomeSearchBar({
    super.key,
    this.showFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    // ── RESPONSIVE SIZES ──
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.038;       // text size
    final iconSize = screenWidth * 0.055;       // icon size
    final barHeight = screenHeight * 0.065;     // height of the search bar
    final borderRadius = screenWidth * 0.08;    // how oval the bar is

    return Row(
      children: [

        // ── SEARCH BAR (oval shape) ──
        Expanded(
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),   // light grey background
              borderRadius: BorderRadius.circular(borderRadius), // oval shape
            ),
            child: Row(
              children: [

                // ── SEARCH ICON (left side inside bar) ──
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: iconSize,
                  ),
                ),

                // ── TEXT INPUT ──
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: fontSize),
                    decoration: InputDecoration(

                      // placeholder text — disappears when user starts typing
                      hintText: 'Search product',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: fontSize,
                      ),

                      // removes default underline border
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── SPACE BETWEEN BAR AND FILTER BUTTON ──
        if (showFilter) ...[
  SizedBox(width: screenWidth * 0.03),

  GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const FilterBottomSheet(),
      );
    },
    child: Container(
      width: barHeight,
      height: barHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.tune,
          color: Colors.black87,
          size: iconSize,
        ),
      ),
    ),
  ),
],
      ],
    );
  }
}