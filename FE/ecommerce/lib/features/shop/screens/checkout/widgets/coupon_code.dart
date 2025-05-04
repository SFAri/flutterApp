import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class CCouponCode extends StatelessWidget {
  const CCouponCode({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return CRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? CColors.grey : CColors.lightGrey,
      padding: const EdgeInsets.only(
          top: CSizes.sm, bottom: CSizes.sm, right: CSizes.sm, left: CSizes.md),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Have a promo code? Enter here',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: dark ? CColors.dark : CColors.lightGrey,
                  backgroundColor: CColors.primary,
                  side: BorderSide(color: CColors.primary),
                ),
                child: Text('Apply')),
          )
        ],
      ),
    );
  }
}
