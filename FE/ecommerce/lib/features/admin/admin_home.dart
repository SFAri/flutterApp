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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideDrawer(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideDrawer(),
              ),
            Expanded(
              flex: 5,
              child: DashboardScreen()
            ),
          ],
        )
      ),
    );
  }
}