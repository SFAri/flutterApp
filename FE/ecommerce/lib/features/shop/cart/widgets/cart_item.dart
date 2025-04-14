import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/icons/circular_icon.dart';
import 'package:ecommerce/common/widgets/images/rounded_image.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

import 'package:ecommerce/features/shop/cart/models/Cart.dart';
import 'package:ecommerce/features/shop/cart/models/Product.dart';

class TCartItem extends StatelessWidget {
  final Product product;
  final CartModel cart;

  const TCartItem({
    super.key,
    required this.product,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Image
        CRoundedImage(
          imageUrl: product.image,
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(CSizes.sm),
          backgroundColor: CHelperFunctions.isDarkMode(context)
              ? CColors.grey
              : CColors.lightGrey,
        ),
        SizedBox(width: CSizes.spaceBtwItems),
        // Title, Price, Quantity
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Expanded(
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Remove Button
                  TCircularIcon(
                      icon: Icons.delete_outline,
                      width: 32,
                      height: 32,
                      color: CColors.dark,
                      backgroundColor: CHelperFunctions.isDarkMode(context)
                          ? CColors.grey
                          : CColors.lightGrey,
                      onPressed: () {
                        cart.remove(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Removed from cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Màu: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CHelperFunctions.isDarkMode(context)
                              ? CColors.textWhite
                              : CColors.dark,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Show color picker or dropdown dialog here
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CHelperFunctions.isDarkMode(context)
                              ? CColors.textWhite
                              : CColors.dark,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Đen',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: CHelperFunctions.isDarkMode(context)
                                  ? CColors.textWhite
                                  : CColors.dark,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                CFormatFunction.formatCurrency(product.price),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: CColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '32.490.000đ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: CHelperFunctions.isDarkMode(context)
                          ? CColors.textWhite.withValues(alpha: 0.5)
                          : CColors.dark.withValues(alpha: 0.5),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
