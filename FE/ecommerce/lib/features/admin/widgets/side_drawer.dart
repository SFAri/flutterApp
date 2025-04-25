import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/screens/couponManagement/allCoupons/coupon_screen.dart';
import 'package:ecommerce/features/admin/screens/dashboard/dashboard.dart';
import 'package:ecommerce/features/admin/screens/userManagement/allUsers/users.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key, required this.onSelectScreen});

  final Function(Widget) onSelectScreen; // Tham số để nhận hàm chọn trang

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(CImages.darkAppLogo)
          ),
          ListTile(
            onTap: (){
              onSelectScreen(DashboardScreen());
            },
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.laptop_mac),
            title: Text('Product'),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.color_lens),
            title: Text('Variant'),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.local_shipping_outlined),
            title: Text('Order'),
          ),
          ListTile(
            onTap: (){
              onSelectScreen(UserScreen());
            },
            leading: Icon(Icons.supervised_user_circle_rounded),
            title: Text('User'),
          ),
          ListTile(
            onTap: (){
              onSelectScreen(CouponScreen());
            },
            leading: Icon(Icons.trending_down_sharp),
            title: Text('Coupon'),
          ),
          ListTile(
            onTap: (){},
            leading: Icon(Icons.settings),
            title: Text('Setting'),
          ),
        ],
      ),
    );
  }
}