import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CBillingPaymentSection extends StatelessWidget {
  const CBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment Method
        CSectorHeading(
          title: 'Payment Method',
          textColor: dark ? CColors.lightGrey : CColors.grey,
          buttonTitle: 'Change',
          padding: 0,
          showActionButton: true,
          onPressed: () {},
        ),
        SizedBox(width: CSizes.spaceBtwItems / 2),
        Row(
          children: [
            CRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? CColors.lightGrey : CColors.grey,
              padding: EdgeInsets.all(CSizes.sm),
              child: const Image(
                image: AssetImage('assets/images/payments/visa.png'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: CSizes.spaceBtwItems / 2),
            Text(
              'Visa **** 1234',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
