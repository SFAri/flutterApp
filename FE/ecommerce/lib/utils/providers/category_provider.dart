import 'package:flutter/material.dart';

class CategoryFilterProvider extends ChangeNotifier {
  Map<String, dynamic>? _filter;
  Map<String, dynamic>? get filter => _filter;
  Map<String, dynamic>? _sortBy;
  Map<String, dynamic>? get sortBy => _sortBy;

  void setFilter(Map<String, dynamic> filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearFilter() {
    _filter = null;
    notifyListeners();
  }

  void setSortby(Map<String, dynamic> sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void clearSortby() {
    _sortBy = null;
    notifyListeners();
  }
}