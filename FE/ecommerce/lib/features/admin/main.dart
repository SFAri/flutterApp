import 'package:ecommerce/features/admin/admin_home.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(AdminMain());
}
class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF212332),
      ),
      home: AdminHome(),
    );
  }
}