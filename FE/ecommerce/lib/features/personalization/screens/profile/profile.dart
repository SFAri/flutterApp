import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/images/circular_image.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  const ProfileScreen({super.key, required this.userData});

  String _get(String key, [String defaultValue = '']) =>
      userData[key] ?? defaultValue;

  String get fullName => _get('fullName');
  String get email => _get('email');
  String get userId => _get('_id');
  String get phoneNumber => _get('phone');
  String get gender => _get('gender');
  String get dateOfBirth => _get('dateOfBirth');
  String get profileImage =>
      _get('profileImage', 'assets/images/users/default-user.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'My Profile',
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
                    CCircularImage(width: 80, height: 80, image: profileImage),
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
              CProfileMenu(
                onPressed: () {},
                title: 'Full Name',
                value: fullName,
              ),
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
                value: userId.substring(0, 9),
                icon: Iconsax.copy_copy,
              ),
              CProfileMenu(onPressed: () {}, title: 'Email', value: email),
              CProfileMenu(
                onPressed: () {},
                title: 'Phone Number',
                value: phoneNumber,
              ),
              CProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              CProfileMenu(
                onPressed: () {},
                title: 'Date of birth',
                value: dateOfBirth,
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
