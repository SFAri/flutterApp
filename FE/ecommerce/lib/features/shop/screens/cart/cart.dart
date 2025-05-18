import 'package:ecommerce/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/shop/screens/checkout/checkout.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: Navigator.canPop(context),
        isCenter: !Navigator.canPop(context),
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CSizes.defaultSpace),
          child:
              cart.items.isEmpty
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/order/empty_cart.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: CSizes.spaceBtwItems),
                      Text(
                        'Your cart is empty',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: CSizes.spaceBtwItems),

                      // Navigator to homepage
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NavigationMenu(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            double.infinity,
                            CSizes.buttonHeight,
                          ),
                        ),
                        child: const Text('Go to Homepage'),
                      ),
                    ],
                  )
                  : Column(
                    children: [
                      CCartItems(cart: cart, showButtonRemove: true),
                      const SizedBox(height: CSizes.spaceBtwSections),
                    ],
                  ),
        ),
      ),

      // Bottom Navigation Bar
      // Elevated Button for Checkout
      bottomNavigationBar:
          cart.items.isEmpty
              ? null
              : Padding(
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
                          'Total Price:',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${CFormatFunction.formatCurrency(cart.totalPrice)}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: CColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CSizes.spaceBtwItems),
                    ElevatedButton(
                      onPressed:
                          cart.items.isNotEmpty
                              ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CheckoutScreen(
                                          cart: cart,
                                          totalPrice: cart.totalPrice,
                                        ),
                                  ),
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, CSizes.buttonHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            CSizes.buttonRadius,
                          ),
                        ),
                        backgroundColor: CColors.primary,
                        elevation: CSizes.buttonElevation,
                      ),
                      child: Text(
                        'Checkout',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: CColors.textWhite),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
