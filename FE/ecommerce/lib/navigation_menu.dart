import 'package:ecommerce/features/personalization/screens/settings/settings.dart';
import 'package:ecommerce/features/shop/screens/cart/cart.dart';
import 'package:ecommerce/features/shop/screens/category/category.dart';
import 'package:ecommerce/features/shop/screens/home/home.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => NavigationMenuState();
}

class NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(NavigationController());
    final darkMode = CHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          backgroundColor: darkMode ? Colors.black : Colors.white,
          indicatorColor: darkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.category), label: 'Category'),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
            NavigationDestination(
                icon: Icon(Icons.account_box), label: 'Profile'),
          ]),
      body: SafeArea(child: _getBody()),
    );
  }

  Widget _getBody() {
    switch (selectedIndex) {
      case 0:
        return HomeScreen(
          onCategorySelected: (filter) {
            Provider.of<CategoryFilterProvider>(context, listen: false).setFilter(filter);
            setState(() => selectedIndex = 1);
          },
          onSortSelected: (sortBy) {
            Provider.of<CategoryFilterProvider>(context, listen: false).setSortby(sortBy);
            setState(() => selectedIndex = 1);
          },
        ); // Màn hình chính
      case 1:
        return CategoryHomeScreen(); // Màn hình danh mục
      case 2:
        return CartScreen(); // Màn hình giỏ hàng
      case 3:
        return SettingsScreen(); // Màn hình hồ sơ
      default:
        return Container();
    }
  }

  void setTab(int i) {
    setState(() {
      selectedIndex = i;
    });
  }
}
