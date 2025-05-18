import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:flutter/material.dart';

class CBillingInfoSection extends StatelessWidget {
  final CartModel cart;
  final Map<String, dynamic>? coupon;
  final VoidCallback? onRemoveCoupon;

  const CBillingInfoSection({
    super.key,
    required this.cart,
    this.coupon,
    this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.titleMedium),
            Text(
              CFormatFunction.formatCurrency(cart.totalPrice),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: CSizes.spaceBtwItems / 2),
        // Shipping
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping Fee',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              CFormatFunction.formatCurrency(100000),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: CSizes.spaceBtwItems / 2),

        // Coupon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Coupon Voucher',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              CFormatFunction.formatCurrency(
                coupon != null && coupon!.isNotEmpty
                    ? coupon!['discountAmount'].toDouble() ?? 0
                    : 0,
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: CSizes.spaceBtwItems / 2),

        // Coupon Code
        if (coupon != null && coupon!.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Coupon Code',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CColors.primary),
                ),
                child: Row(
                  children: [
                    Text(
                      coupon?['code'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: onRemoveCoupon,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: CColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        SizedBox(height: CSizes.spaceBtwItems / 2),
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Total',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              CFormatFunction.formatCurrency(
                cart.totalPrice + 100000 - (coupon?['discountAmount'] ?? 0),
              ),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
