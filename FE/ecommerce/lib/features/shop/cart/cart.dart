import 'package:ecommerce/features/shop/cart/widgets/cart_items.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/shop/checkout/checkout.dart';
import 'package:ecommerce/features/shop/cart/models/Cart.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

import 'package:ecommerce/features/shop/cart/models/Product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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

  CartModel cart = CartModel();
  @override
  Widget build(BuildContext context) {
    // Initialize CartModel with sample data
    cart.initialize(products);
    // final cart = Provider.of<CartModel>(context);

    return Scaffold(
        appBar: CAppBar(
          leadingIcon: Icons.arrow_back,
          leadingOnPressed: () => Navigator.pop(context),
          title: Text('Cart',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(CSizes.defaultSpace),
              child: Column(children: [
                // Cart Items
                CCartItems(
                  cart: cart,
                  showButtonRemove: true,
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
                      '\$${CFormatFunction.formatCurrency(cart.totalPrice)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: CColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: CSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutScreen(
                          cart: cart,
                          totalPrice: cart.totalPrice,
                        ),
                      ),
                    );
                  },
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
