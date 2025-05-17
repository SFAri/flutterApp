import 'dart:async';
import 'dart:ui';

import 'package:ecommerce/features/admin/admin_home.dart';
import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/helpers/role_function.dart';
import 'package:ecommerce/utils/local_storage/storage_utility.dart';
import 'package:ecommerce/utils/providers/category_provider.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:ecommerce/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// For cloudinary package:
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
StreamController<Widget> streamController = StreamController<Widget>.broadcast();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CLocalStorage.init('user_bucket');
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: "dfgfyxjfx");
  runApp(
    // For cloudinary:
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(), // Tạo instance của provider
        ),
        ChangeNotifierProvider(
          create: (context) => MenuAppController()
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryFilterProvider(),
        ),
      ],
      child: const MyApp(),
    )
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
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      darkTheme: CAppTheme.darkTheme,
      // home: NavigationMenu(),
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return snapshot.data as Widget;
          } else {
            return NavigationMenu(); // Màn hình mặc định nếu không có dữ liệu
          }
        },
      ),
    );
  }

  Future<Widget> _checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final token = await AuthService.getToken(); // Lấy token từ LocalStorage
      final role = getRoleFromToken(token!); // Giải mã token để lấy vai trò
      if (role == 1) { // Nếu vai trò là admin
        return AdminHome(streamController.stream);
      } else {
        return NavigationMenu(); // Nếu không phải admin
      }
    }
    return NavigationMenu(); // Nếu không có token
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}