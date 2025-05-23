import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CHelperFunctions {
  static Color? getColor(String value){
    // if (value == 'Green'){

    // }
    switch (value) {
      case 'Green':
        return Colors.green;
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Pink':
        return Colors.pink;
      case 'Grey':
        return Colors.grey;
      case 'Purple':
        return Colors.purple;
      case 'White':
        return Colors.white;
      default: 
        return Colors.black;
    }
  }
  static void showSnackBar(String message, {required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message, {required BuildContext context}){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
  }

  static void NavigateToScreen(BuildContext context, Widget screen){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength){
      return text;
    }
    else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize(){
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight(){
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth(){
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicate<T>(List<T> list){
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize){
    final wrappedList = <Widget>[];
    for (var i=0; i<widgets.length; i += rowSize){
      final rowChildren = widgets.sublist(i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren,));
    }
    return wrappedList;
  }
}