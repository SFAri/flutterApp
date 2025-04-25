import 'package:ecommerce/features/admin/admin_home.dart';
import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

StreamController<Map<String, dynamic>> streamController = StreamController<Map<String, dynamic>>();
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => UserProvider(), // Add UserProvider
          // ),
        ],
        child: AdminHome(streamController.stream)
      ),
    );
  }
}