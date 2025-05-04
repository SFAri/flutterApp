// import 'package:ecommerce/utils/constants/colors.dart';
// import 'package:ecommerce/features/shop/screens/home/home.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:ecommerce/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(), // Tạo instance của provider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Lắng nghe thay đổi locale từ provider
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      locale: settingsProvider.appLocale,
      themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      darkTheme: CAppTheme.darkTheme,
      home: NavigationMenu(),
    );
  }
}
