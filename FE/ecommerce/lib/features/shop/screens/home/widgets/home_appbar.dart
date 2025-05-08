import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/features/shop/screens/cart/cart.dart';
import 'package:ecommerce/features/shop/screens/chat/chat_screen.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CHomeAppBar extends StatelessWidget {
  const CHomeAppBar({super.key, this.isBack = false});

  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return CAppBar(
      isTranfer: true,
      showBackArrows: isBack,
      title: Column(
        children: [
          // Search bar:
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Search in store',
              filled: true,
              fillColor: CColors.textWhite,
              prefixIcon: Icon(Icons.search, color: CColors.grey),
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
      ],
    );
  }
}
