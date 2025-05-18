import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/features/shop/screens/cart/cart.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/features/shop/screens/chat/chat_screen.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class CHomeAppBar extends StatelessWidget {
  final void Function(Map<String, dynamic> filter)? onCategorySelected;
  final void Function(String)? onSearchCompleted;
  final TextEditingController? controller;
  CHomeAppBar({
    super.key, 
    this.isBack = false, 
    this.onCategorySelected,
    this.controller,
    this.onSearchCompleted
  });

  final bool isBack;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CartModel cart = CartModel();
    cart = Provider.of<CartModel>(context);

    return CAppBar(
      isTranfer: true,
      showBackArrows: isBack,
      title: Column(
        children: [
          // Search bar:
          TextFormField(
            controller: controller ?? searchController,
            onEditingComplete: () {
              if (onCategorySelected != null){
                onCategorySelected?.call({
                  // 'name': searchController.text,
                });
                Provider.of<CategoryFilterProvider>(context, listen: false).setSearchText(searchController.text);
              }
              else {
                onSearchCompleted?.call(searchController.text);
              }
            },
            decoration: InputDecoration(
              hintText: 'Search in store',
              filled: true,
              fillColor: CColors.textWhite,
              prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 23, 22, 22)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSizes.borderRadiusLg),
                // borderSide: BorderSide(color: CColors.grey)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CColors.grey.withValues(alpha: 0.2),
                ),
                // borderRadius: BorderRadius.circular(CSizes.borderRadiusMd),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            // Chat icon: only display when user login
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatScreen()),
                );
              },
              icon: Icon(Icons.chat, color: CColors.textWhite),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: CColors.dark.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: CColors.textWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartScreen()),
                );
              },
              icon: Icon(Iconsax.shopping_cart, color: CColors.textWhite),
            ),
            Positioned(
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: CColors.dark.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    cart.items.length.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: CColors.textWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
