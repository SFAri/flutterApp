import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/images/circular_image.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'My Order',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            children: [
              // -- Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const CCircularImage(
                      width: 80,
                      height: 80,
                      image: 'assets/images/users/default-user.jpg',
                    ),
                    TextButton(onPressed: () {}, child: Text('Change Photo')),
                  ],
                ),
              ),

              SizedBox(width: CSizes.spaceBtwItems / 2),
              Divider(),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Profile Information
              // -- Heading Profile Info
              CSectorHeading(
                title: 'Profile Information',
                padding: 0,
                showActionButton: true,
              ),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Profile Info
              CProfileMenu(onPressed: () {}, title: 'Name', value: 'John Doe'),
              CProfileMenu(
                onPressed: () {},
                title: 'Username',
                value: 'johndoe',
              ),

              SizedBox(width: CSizes.spaceBtwItems / 2),
              Divider(),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Heading Personal Info
              CSectorHeading(
                title: 'Personal Information',
                padding: 0,
                showActionButton: true,
              ),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- User Personal Info
              CProfileMenu(
                onPressed: () {},
                title: 'User ID',
                value: '123456789',
                icon: Iconsax.copy_copy,
              ),
              CProfileMenu(
                onPressed: () {},
                title: 'Email',
                value: 'johndoe@example.com',
              ),
              CProfileMenu(
                onPressed: () {},
                title: 'Phone Number',
                value: '+123456789',
              ),
              CProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              CProfileMenu(
                onPressed: () {},
                title: 'Date of birth',
                value: '1 January 2000',
              ),
              Divider(),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Close Account Button
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Close Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
