import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/personalization/screens/address/add_new_address.dart';
import 'package:ecommerce/features/personalization/screens/address/address.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CBillingAddressSection extends StatelessWidget {
  final bool isLoggedIn;
  final Map<String, dynamic>? address;
  const CBillingAddressSection({
    super.key,
    required this.isLoggedIn,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);

    if (!isLoggedIn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CSectorHeading(
            title: 'Shipping Address',
            textColor: dark ? CColors.lightGrey : CColors.primary,
            buttonTitle: 'Create Address',
            padding: 0,
            showActionButton: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddNewAddressScreen()),
              );
            },
          ),
          const SizedBox(height: CSizes.spaceBtwItems / 2),
          Text(
            'No address found here. Please create a new address.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CSectorHeading(
          title: 'Shipping Address',
          textColor: dark ? CColors.lightGrey : CColors.primary,
          buttonTitle: 'Change',
          padding: 0,
          showActionButton: true,
          onPressed:
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserAddressScreen()),
                ),
              },
        ),
        SizedBox(width: CSizes.spaceBtwItems / 2),

        Text(
          address?['fullName'] ?? 'N/A',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
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
              address?['phone'] ?? 'N/A',
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
              address?['detailAddress'] ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        SizedBox(width: CSizes.spaceBtwItems / 2),
      ],
    );
  }
}
