import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CBillingAddressSection extends StatelessWidget {
  const CBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CSectorHeading(
          title: 'Shipping Address',
          textColor: dark ? CColors.lightGrey : CColors.grey,
          buttonTitle: 'Change',
          padding: 0,
          showActionButton: true,
          onPressed: () {},
        ),
        SizedBox(width: CSizes.spaceBtwItems / 2),

        Text('Your Name', style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(width: CSizes.spaceBtwItems / 2),
        Row(
          children: [
            Icon(
              Icons.phone,
              color: dark ? CColors.lightGrey : CColors.grey,
              size: CSizes.iconSm,
            ),
            SizedBox(width: CSizes.spaceBtwItems),
            Text(
              '+84 123 456 789',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        SizedBox(width: CSizes.spaceBtwItems / 2),
        Row(
          children: [
            Icon(
              Icons.location_history,
              color: dark ? CColors.lightGrey : CColors.grey,
              size: CSizes.iconSm,
            ),
            SizedBox(width: CSizes.spaceBtwItems),
            Text(
              '19 Nguyen Huu Tho, Q.7, HCM',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        SizedBox(width: CSizes.spaceBtwItems / 2),
      ],
    );
  }
}
