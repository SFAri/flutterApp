import 'dart:ui';

import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/dashboard/dashboard.dart';
import 'package:ecommerce/features/admin/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class AdminHome extends StatefulWidget {
  const AdminHome( this.stream, {super.key});

  final Stream<Widget> stream;
  @override
  State<AdminHome> createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {

  Widget _currentScreen = DashboardScreen();

  void _selectScreen(Widget screen) {
    setState(() {
      _currentScreen = screen; // Cập nhật trang hiện tại
    });
  }

  void showUserDetailScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }
  @override void initState() {
    super.initState();
    widget.stream.listen((screen) {
      showUserDetailScreen(screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuController = Provider.of<MenuAppController>(context);
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF212332),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF212332),
          // key: context.read<MenuAppController>().scaffoldKey,
        key: menuController.scaffoldKey,
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
                child: SafeArea(
                  child: SingleChildScrollView(
                    primary: false,
                    padding: EdgeInsets.all(10),
                    child: _currentScreen,
                  )
                )
              ),
            ],
          )
        ),
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