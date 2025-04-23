import 'package:ecommerce/features/admin/screens/dashboard/dashboard.dart';
import 'package:ecommerce/features/admin/widgets/side_drawer.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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