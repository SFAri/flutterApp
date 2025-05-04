import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  Locale _appLocale = const Locale('en'); // Ngôn ngữ mặc định
  String _selectedCurrency = 'USD'; // Tiền tệ mặc định
  // Định dạng ngày giờ mặc định
  String _selectedDateFormatPattern = 'MM/dd/yyyy HH:mm';
  String _selectedTheme = 'System';

  // Tạo các key để lưu SharedPreferences
  static const String _currencyKey = 'selected_currency';
  static const String _localeKey = 'selected_locale';
  static const String _dateFormatKey = 'dateFormatPattern';
  static const String _themeKey = 'selected_theme';

  Locale get appLocale => _appLocale;
  String get selectedCurrency => _selectedCurrency;
  String get selectedDateFormatPattern => _selectedDateFormatPattern;
  String get selectedTheme => _selectedTheme;

  SettingsProvider() {
    _loadSettings(); // Tải các setting khi khởi tạo
  }

  // Tải các setting từ SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Tải tiền tệ
    _selectedCurrency =
        prefs.getString(_currencyKey) ?? 'USD'; // Mặc định là USD
    // Tải ngôn ngữ
    String langCode = prefs.getString(_localeKey) ?? 'en'; // Mặc định là 'vi'
    _appLocale = Locale(langCode);

    _selectedDateFormatPattern =
        prefs.getString(_dateFormatKey) ?? 'MM/dd/yyyy HH:mm';

    _selectedTheme = prefs.getString(_themeKey) ?? 'System';
    notifyListeners();
  }

  // Lưu cài đặt vào SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, _selectedCurrency);
    await prefs.setString(_localeKey, _appLocale.languageCode);
    await prefs.setString(_dateFormatKey, _selectedDateFormatPattern);
    await prefs.setString(_themeKey, _selectedTheme);
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
}
