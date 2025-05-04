import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/billing_information.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/coupon_code.dart';
import 'package:ecommerce/features/shop/screens/checkout/widgets/success_screen.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class CheckoutScreen extends StatelessWidget {
  final double totalPrice;
  final _formKey = GlobalKey<FormState>();

  CheckoutScreen({super.key, required this.cart, required this.totalPrice});

  CartModel cart = CartModel();

  @override
  Widget build(BuildContext context) {
    final bool dark = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart Items
              CCartItems(cart: cart, showButtonRemove: false),
              const SizedBox(height: CSizes.spaceBtwSections),

              // Coupon Text Field
              CCouponCode(dark: dark),
              SizedBox(height: CSizes.spaceBtwSections),

              // Billing Section
              CRoundedContainer(
                showBorder: true,
                backgroundColor: dark ? CColors.grey : CColors.lightGrey,
                padding: EdgeInsets.all(CSizes.md),
                child: Column(
                  children: [
                    // Billing Information
                    CBillingInfoSection(cart: cart),
                    Divider(
                      color: CColors.grey,
                      thickness: 1,
                      height: CSizes.defaultSpace,
                    ),

                    // Payment Section
                    CBillingPaymentSection(),
                    SizedBox(height: CSizes.spaceBtwItems),

                    // Address Section
                    CBillingAddressSection(),
                    SizedBox(height: CSizes.spaceBtwItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      // Elevated Button for Checkout
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(CSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => SuccessScreen(
                      image: 'assets/images/order/success.png',
                      title: 'Order Placed',
                      subTitle: 'Your order has been placed successfully!',
                      onPressed:
                          () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NavigationMenu(),
                            ),
                            (route) => false,
                          ),
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
            'Đặt hàng',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: CColors.textWhite),
          ),
        ),
      ),
    );
  }
}
