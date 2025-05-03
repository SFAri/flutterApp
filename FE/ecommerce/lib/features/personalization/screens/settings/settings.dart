import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/layout/primary_header_container.dart';
import 'package:ecommerce/common/widgets/list_titles/settings_menu_title.dart';
import 'package:ecommerce/common/widgets/list_titles/user_profile_title.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/cart/cart.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // -- Header
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // -- AppBar
                  CAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: CSizes.spaceBtwSections),

                  // -- Profile Card
                  CUserProfileTitle(),
                  const SizedBox(height: CSizes.spaceBtwSections),
                ],
              ),
            ),
            // -- Body
            Padding(
              padding: EdgeInsets.all(CSizes.defaultSpace),
              child: Column(
                children: [
                  // -- Account Settings
                  CSectorHeading(
                    title: 'Account Settings',
                    padding: 0,
                    textColor: Colors.white,
                    showActionButton: false,
                  ),
                  SizedBox(height: CSizes.spaceBtwSections),

                  CSettingsMenuTitle(
                    icon: Iconsax.truck_copy,
                    title: 'My Addresses',
                    subTitle: 'Set shopping delivery addresses',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.shopping_cart_copy,
                    title: 'My Cart',
                    subTitle: 'View and manage your cart',
                    onTap:
                        () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CartScreen()),
                          ),
                        },
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.bag_tick_copy,
                    title: 'My Orders',
                    subTitle: 'View and manage your orders',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.lovely_copy,
                    title: 'My Wishlist',
                    subTitle: 'View and manage your wishlist',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.star_1_copy,
                    title: 'My Reviews',
                    subTitle: 'View and manage your reviews',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.notification_1_copy,
                    title: 'Notifications',
                    subTitle: 'View and manage your notifications',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.paypal_copy,
                    title: 'My Payment Methods',
                    subTitle: 'View and manage your payment methods',
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.discount_shape_copy,
                    title: 'My Coupons',
                    subTitle: 'View and manage your coupons',
                  ),

                  // -- App Settings
                  SizedBox(height: CSizes.spaceBtwSections),
                  CSectorHeading(
                    title: 'App Settings',
                    padding: 0,
                    textColor: Colors.white,
                    showActionButton: false,
                  ),
                  SizedBox(height: CSizes.spaceBtwSections),

                  CSettingsMenuTitle(
                    icon: Iconsax.safe_home_copy,
                    title: 'Safe Mode',
                    subTitle: 'Set shopping safe mode',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),
                  CSettingsMenuTitle(
                    icon: Iconsax.data_copy,
                    title: 'Load Data',
                    subTitle: 'Load data shopping',
                    trailing: Switch(value: false, onChanged: (value) {}),
                  ),

                  // -- Logout Button
                  SizedBox(height: CSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            CSizes.borderRadiusMd,
                          ),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.apply(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
