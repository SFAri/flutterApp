import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/features/shop/screens/cart/cart.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class CDetailAppBar extends StatelessWidget {
  const CDetailAppBar({
    super.key,
    this.isBack = false,
    this.title = 'Product Detail',
  });

  final bool isBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    CartModel cart = CartModel();
    cart = Provider.of<CartModel>(context);
    return CAppBar(
      showBackArrows: isBack,
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      actions: [
        Stack(
          children: [
            // Chat icon: only display when user login
            IconButton(
              onPressed: () {},
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
