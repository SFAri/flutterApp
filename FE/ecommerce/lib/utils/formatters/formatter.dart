import 'package:intl/intl.dart';

class CFormatter {
  static String formatDate(DateTime? date){
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatCurrency(double amount){
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber){
    if (phoneNumber.length == 10){
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3,6)} ${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }

  static String formatMoney(String amount){
    final formatter = NumberFormat('#,##0');
    return '${formatter.format(double.parse(amount))} VND';
  }
}