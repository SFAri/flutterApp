import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/shop/cart/models/Cart.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/icons/circular_icon.dart';
import 'package:ecommerce/features/shop/cart/widgets/cart_item.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

import 'package:ecommerce/features/shop/cart/models/Product.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final List<Product> products = [
    Product(
        name:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA",
        image:
            "assets/images/products/hp-victus-15-fb1022ax-r5-94f19pa-170225-104741-220.png",
        price: 25490000,
        description:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA"),
    Product(
        name:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA",
        image:
            "assets/images/products/hp-victus-15-fb1022ax-r5-94f19pa-170225-104741-220.png",
        price: 25490000,
        description:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA"),
    Product(
        name:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA",
        image:
            "assets/images/products/hp-victus-15-fb1022ax-r5-94f19pa-170225-104741-220.png",
        price: 25490000,
        description:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA"),
    Product(
        name:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA",
        image:
            "assets/images/products/hp-victus-15-fb1022ax-r5-94f19pa-170225-104741-220.png",
        price: 25490000,
        description:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA"),
    Product(
        name:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA",
        image:
            "assets/images/products/hp-victus-15-fb1022ax-r5-94f19pa-170225-104741-220.png",
        price: 25490000,
        description:
            "Laptop HP Gaming Victus 16-s0173AX R5-7640HS/16GB/512GB/16 144Hz/GeForce RTX3050 6GB/Win11_A9LG9PA"),
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize CartModel with sample data
    CartModel cart = CartModel();
    cart.initialize(products);
    // final cart = Provider.of<CartModel>(context);

    return Scaffold(
        appBar: CAppBar(
          showBackArrows: true,
          title: Text('Cart',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(CSizes.defaultSpace),
              child: cart.items.isEmpty
                  ? Center(
                      child: Text(
                        'Giỏ hàng của bạn rỗng 🛒',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : Column(children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => Divider(
                          color: CColors.grey,
                          thickness: 1,
                          height: CSizes.defaultSpace,
                        ),
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (_, index) => Column(
                          children: [
                            TCartItem(product: products[index], cart: cart),
                            SizedBox(height: CSizes.spaceBtwItems),
                            // Quantity
                            Row(
                              children: [
                                SizedBox(width: 80),
                                TCircularIcon(
                                    icon: Icons.remove,
                                    width: 32,
                                    height: 32,
                                    backgroundColor:
                                        CHelperFunctions.isDarkMode(context)
                                            ? CColors.grey
                                            : CColors.lightGrey,
                                    onPressed: () {}),
                                SizedBox(width: CSizes.spaceBtwItems),
                                Text(
                                  '1',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(width: CSizes.spaceBtwItems),
                                TCircularIcon(
                                    icon: Icons.add,
                                    width: 32,
                                    height: 32,
                                    color: CColors.textWhite,
                                    backgroundColor: CColors.primary,
                                    onPressed: () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CSizes.spaceBtwSections),
                    ])),
        ),
        // Bottom Navigation Bar
        // Elevated Button for Checkout
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(CSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng cộng',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '16.990.000đ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: CColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: CSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, CSizes.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(CSizes.buttonRadius),
                    ),
                    backgroundColor: CColors.primary,
                    elevation: CSizes.buttonElevation,
                  ),
                  child: Text(
                    'Thanh toán',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: CColors.textWhite,
                        ),
                  ),
                ),
              ],
            )));
  }
}
