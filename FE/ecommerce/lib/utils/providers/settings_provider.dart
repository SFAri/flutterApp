import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsProvider with ChangeNotifier {
  Locale _appLocale = const Locale('en');
  String _selectedCurrency = 'USD';
  String _selectedDateFormatPattern = 'MM/dd/yyyy HH:mm';
  String _selectedTheme = 'System';

  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>>? _userAddress;

  static const String _currencyKey = 'selected_currency';
  static const String _localeKey = 'selected_locale';
  static const String _dateFormatKey = 'dateFormatPattern';
  static const String _themeKey = 'selected_theme';
  static const String _userDataKey = 'user_profile';
  static const String _userAddressKey = 'user_address';

  Locale get appLocale => _appLocale;
  String get selectedCurrency => _selectedCurrency;
  String get selectedDateFormatPattern => _selectedDateFormatPattern;
  String get selectedTheme => _selectedTheme;
  Map<String, dynamic>? get userData => _userData;
  List<Map<String, dynamic>>? get userAddress => _userAddress;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _selectedCurrency = prefs.getString(_currencyKey) ?? 'USD';
    String langCode = prefs.getString(_localeKey) ?? 'en';
    _appLocale = Locale(langCode);
    _selectedDateFormatPattern =
        prefs.getString(_dateFormatKey) ?? 'MM/dd/yyyy HH:mm';
    _selectedTheme = prefs.getString(_themeKey) ?? 'System';

    final String? userDataString = prefs.getString(_userDataKey);
    if (userDataString != null && userDataString.isNotEmpty) {
      _userData = json.decode(userDataString) as Map<String, dynamic>?;
    } else {
      _userData = null;
    }

    final String? addressString = prefs.getString(_userAddressKey);
    if (addressString != null && addressString.isNotEmpty) {
      final List<dynamic> decoded = json.decode(addressString);
      _userAddress = decoded.cast<Map<String, dynamic>>();
    }

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, _selectedCurrency);
    await prefs.setString(_localeKey, _appLocale.languageCode);
    await prefs.setString(_dateFormatKey, _selectedDateFormatPattern);
    await prefs.setString(_themeKey, _selectedTheme);

    if (_userData != null) {
      await prefs.setString(_userDataKey, json.encode(_userData));
    } else {
      await prefs.remove(_userDataKey);
    }

    if (_userAddress != null) {
      await prefs.setString(_userAddressKey, json.encode(_userAddress));
    } else {
      await prefs.remove(_userAddressKey);
    }
  }

  void changeLocale(Locale newLocale) {
    if (_appLocale == newLocale) return;
    _appLocale = newLocale;
    _saveSettings();
    notifyListeners();
  }

  void changeCurrency(String newCurrency) {
    if (_selectedCurrency == newCurrency) return;
    _selectedCurrency = newCurrency;
    _saveSettings();
    notifyListeners();
  }

  void changeDateFormat(String newDateFormat) {
    if (_selectedDateFormatPattern == newDateFormat) return;
    _selectedDateFormatPattern = newDateFormat;
    _saveSettings();
    notifyListeners();
  }

  void changeTheme(String newTheme) {
    if (_selectedTheme == newTheme) return;
    _selectedTheme = newTheme;
    _saveSettings();
    notifyListeners();
  }

  Future<void> setUserData(Map<String, dynamic>? data) async {
    _userData = data;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setUserAddress(List<Map<String, dynamic>>? data) async {
    _userAddress = data;
    await _saveSettings();
    notifyListeners();
  }
}
