import 'package:flutter/material.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/common/widgets/icons/circular_icon.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class CQuantityItem extends StatelessWidget {
  final int quantity;
  final bool isOutStock;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CQuantityItem({
    super.key,
    required this.quantity,
    required this.isOutStock,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 80),
        TCircularIcon(
          icon: Icons.remove,
          width: 32,
          height: 32,
          backgroundColor:
              CHelperFunctions.isDarkMode(context)
                  ? CColors.grey
                  : CColors.lightGrey,
          onPressed: onDecrement,
        ),
        const SizedBox(width: CSizes.spaceBtwItems),
        Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: CSizes.spaceBtwItems),
        isOutStock
            ? SizedBox.shrink()
            : TCircularIcon(
              icon: Icons.add,
              width: 32,
              height: 32,
              color: CColors.textWhite,
              backgroundColor: CColors.primary,
              onPressed: onIncrement,
            ),
      ],
    );
  }
}
