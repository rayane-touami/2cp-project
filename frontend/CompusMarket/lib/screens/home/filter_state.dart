import 'package:flutter/material.dart';

class FilterData {
  final String selectedMainCategory;
  final List<String> selectedCategories;
  final List<String> selectedUniversities;
  final RangeValues priceRange;

  FilterData({
    this.selectedMainCategory = 'All',
    this.selectedCategories = const [],
    this.selectedUniversities = const [],
    this.priceRange = const RangeValues(0, 1000000), // Adjusted max for iPads etc.
  });

  FilterData copyWith({
    String? selectedMainCategory,
    List<String>? selectedCategories,
    List<String>? selectedUniversities,
    RangeValues? priceRange,
  }) {
    return FilterData(
      selectedMainCategory: selectedMainCategory ?? this.selectedMainCategory,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedUniversities: selectedUniversities ?? this.selectedUniversities,
      priceRange: priceRange ?? this.priceRange,
    );
  }
}

// Global ValueNotifier to hold the filter state
final ValueNotifier<FilterData> globalFilterState = ValueNotifier(FilterData());
