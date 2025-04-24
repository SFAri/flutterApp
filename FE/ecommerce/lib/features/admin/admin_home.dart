import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/dashboard/dashboard.dart';
import 'package:ecommerce/features/admin/widgets/side_drawer.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  Widget _currentScreen = DashboardScreen();

  void _selectScreen(Widget screen) {
    setState(() {
      _currentScreen = screen; // Cập nhật trang hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideDrawer(onSelectScreen: _selectScreen),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideDrawer(onSelectScreen: _selectScreen),
              ),
            Expanded(
              flex: 5,
              child: _currentScreen
            ),
          ],
        )
      ),
    );
  }
}