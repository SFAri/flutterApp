// import 'package:ecommerce/utils/constants/colors.dart';
// import 'package:ecommerce/features/shop/screens/home/home.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/utils/theme/theme.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: CAppTheme.darkTheme,
      home: NavigationMenu(),
    );
  }
}