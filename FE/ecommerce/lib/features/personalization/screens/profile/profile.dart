import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/images/circular_image.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/personalization/screens/profile/change_password_screen.dart';
import 'package:ecommerce/features/personalization/screens/profile/update_profile_screen.dart';
import 'package:ecommerce/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settings = Provider.of<SettingsProvider>(context);
    if (userData != settings.userData) {
      setState(() {
        userData = settings.userData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    const userKey = 'user_profile';
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(userKey);

      if (userDataString != null && userDataString.isNotEmpty) {
        userData = json.decode(userDataString);
        setState(() {
          userData = userData;
        });
      }
    } catch (e) {
      print('Error reading user data: $e');
      if (mounted) {
        Provider.of<SettingsProvider>(context, listen: false).setUserData({});
      }
    }
  }

  String _get(String key, [String defaultValue = '']) =>
      userData?[key] as String? ?? defaultValue;
  String get fullName => _get('fullName');
  String get username => _get('userName');
  String get email => _get('email');
  String get userId => _get('_id');
  String get phoneNumber => _get('phone');
  String get gender => _get('gender');
  DateTime? get dateOfBirth =>
      userData?['dateOfBirth'] != null
          ? DateTime.tryParse(userData!['dateOfBirth'])
          : null;
  String get profileImage =>
      _get('profileImage', 'assets/images/users/default-user.jpg');
  @override
  Widget build(BuildContext context) {
    if (userData == null) {
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateProfileScreen(userData: userData!),
                    ),
                  );
                },
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
                value: username,
              ),

              SizedBox(width: CSizes.spaceBtwItems / 2),
              Divider(),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Heading Personal Info
              CSectorHeading(
                title: 'Personal Information',
                padding: 0,
                showActionButton: true,
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateProfileScreen(userData: userData!),
                    ),
                  );
                },
              ),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- User Personal Info
              CProfileMenu(
                onPressed: () {},
                title: 'User ID',
                value: userId.toString().substring(0, 9),
                icon: Iconsax.copy_copy,
              ),
              CProfileMenu(onPressed: () {}, title: 'Email', value: email),
              CProfileMenu(
                onPressed: () {},
                title: 'Phone Number',
                value: phoneNumber,
              ),
              CProfileMenu(onPressed: () {}, title: 'Gender', value: gender),
              CProfileMenu(
                onPressed: () {},
                title: 'Date of birth',
                value:
                    dateOfBirth != null
                        ? CFormatFunction.formatDate(dateOfBirth!)
                        : 'Not set',
              ),
              Divider(),
              SizedBox(width: CSizes.spaceBtwItems),

              SizedBox(width: CSizes.spaceBtwItems / 2),
              Divider(),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Change Password
              CSectorHeading(
                title: 'Password Settings',
                buttonTitle: 'Change Password',
                padding: 0,
                showActionButton: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                  );
                },
              ),
              SizedBox(width: CSizes.spaceBtwItems),

              // -- Password Info
              CProfileMenu(
                onPressed: () {},
                title: 'Password',
                value: '******',
                icon: Iconsax.copy_copy,
              ),

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
