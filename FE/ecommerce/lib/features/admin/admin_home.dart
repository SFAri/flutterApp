import 'dart:ui';

import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/couponManagement/detailCoupon/detail_coupon.dart';
import 'package:ecommerce/features/admin/screens/dashboard/dashboard.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/orderManagement/orderDetail/order_details.dart';
import 'package:ecommerce/features/admin/screens/productManagement/productDetail/product_detail.dart';
import 'package:ecommerce/features/admin/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AdminHome extends StatefulWidget {
  const AdminHome( this.stream, {super.key});

  final Stream<Widget> stream;
  @override
  State<AdminHome> createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  final GlobalKey<ScaffoldState> _scaffoldAdminKey = GlobalKey<ScaffoldState>();
  Widget _currentScreen = DashboardScreen();
  String _currentTitle = 'Dashboard';

  void _selectScreen(Widget screen, String title) {
    setState(() {
      _currentScreen = screen; // Cập nhật trang hiện tại
      _currentTitle = title;
    });
  }

  void showUserDetailScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }
  // @override void initState() {
  //   super.initState();
  //   widget.stream.listen((screen) {
  //     showUserDetailScreen(screen);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.stream.listen((screen) {
      String title;

      switch (screen.runtimeType) {
        case DashboardScreen:
          title = 'Dashboard';
          break;
        case OrderDetailScreen:
          title = 'Order details';
          break;
        case DetailCouponScreen:
          title = 'Coupon detail';
          break;
        case ProductDetailScreen:
          title = 'Product details';
          break;
        // Thêm các trường hợp khác nếu cần
        default:
          title = 'E-commerce shop'; // Tiêu đề mặc định
      }

      _selectScreen(screen, title);
    });
  }

  void controlMenu() {
    if (!_scaffoldAdminKey.currentState!.isDrawerOpen) {
      _scaffoldAdminKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final menuController = Provider.of<MenuAppController>(context);
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF212332),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF212332),
          // key: context.read<MenuAppController>().scaffoldKey,
        key: _scaffoldAdminKey,
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
                    child: Column(
                      children: [
                        Header(
                          title: _currentTitle, // Truyền tiêu đề cho Header
                          onMenuButtonPressed: controlMenu,
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                        _currentScreen,
                      ],
                    ),
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