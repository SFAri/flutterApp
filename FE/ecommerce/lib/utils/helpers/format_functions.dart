import 'package:intl/intl.dart';

class CFormatFunction {
  CFormatFunction._();

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> names = name.split(' ');
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0].toUpperCase()}${names[1][0].toUpperCase()}';
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
