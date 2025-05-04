import 'dart:ui';

import 'package:ecommerce/features/admin/admin_home.dart';
import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

StreamController<Widget> streamController = StreamController<Widget>();
void main() {
  runApp(AdminMain());
}
class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF212332),
      ),
      scrollBehavior: MyCustomScrollBehavior(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: AdminHome(streamController.stream)
      ),
    );
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