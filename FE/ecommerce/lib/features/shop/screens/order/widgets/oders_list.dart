import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class COrderListItems extends StatelessWidget {
  const COrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) => SizedBox(height: CSizes.spaceBtwItems),
      itemBuilder:
          (_, index) => CRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(CSizes.md),
            backgroundColor: dark ? CColors.dark : Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Section 1
                Row(
                  children: [
                    /// 1 - Icon
                    Icon(Iconsax.ship_copy),
                    SizedBox(width: CSizes.spaceBtwItems / 2),

                    /// 2 - Status & Date
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing',
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                              color: CColors.primary,
                              fontWeightDelta: 1,
                            ),
                          ),
                          Text(
                            '03 May 2025',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),

                    /// 3 - Icon Button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Iconsax.arrow_right_3_copy,
                        size: CSizes.iconSm,
                      ),
                    ),
                  ],
                ),

                /// Section 2
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /// 1 - Icon
                          Icon(Iconsax.tag_copy),
                          SizedBox(width: CSizes.spaceBtwItems / 2),

                          /// 2 - Status & Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  '[#12345]',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          /// 1 - Icon
                          Icon(Iconsax.calendar_1_copy),
                          SizedBox(width: CSizes.spaceBtwItems / 2),

                          /// 2 - Status & Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping Date',
                                  style:
                                      Theme.of(context).textTheme.labelMedium!,
                                ),
                                Text(
                                  '18 May 2025',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
