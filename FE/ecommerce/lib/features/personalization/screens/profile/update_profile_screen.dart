import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/common/widgets/images/circular_image.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/format_functions.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UpdateProfileScreen({super.key, required this.userData});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formUpdateProfileKey = GlobalKey<FormState>();
  final ProfileController _profileController = ProfileController();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _genderController;
  late TextEditingController _dateOfBirthController;
  // List of gender options
  final List<String> _genderOptions = ['Male', 'Female'];
  bool isLoading = false;

  String _get(String key, [String defaultValue = '']) =>
      widget.userData[key] ?? defaultValue;

  String get fullName => _get('fullName');
  String get username => _get('userName');
  String get email => _get('email');
  String get userId => _get('_id');
  String get phoneNumber => _get('phone');
  String get gender => _get('gender');
  DateTime? get dateOfBirth =>
      _get('dateOfBirth').isNotEmpty ? _parseDate(_get('dateOfBirth')) : null;

  DateTime? _selectedDate;
  String get profileImage =>
      _get('profileImage', 'assets/images/users/default-user.jpg');

  DateTime? _parseDate(String dateString) {
    DateTime? dt = DateTime.tryParse(dateString);
    if (dt != null) {
      DateTime localDateTime = dt.toLocal();
      return DateTime(
        localDateTime.year,
        localDateTime.month,
        localDateTime.day,
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: fullName);
    _usernameController = TextEditingController(text: username);
    _phoneNumberController = TextEditingController(text: phoneNumber);
    _genderController = TextEditingController(text: gender);
    _selectedDate = dateOfBirth;
    _dateOfBirthController = TextEditingController(
      text:
          _selectedDate != null
              ? CFormatFunction.formatDate(_selectedDate!)
              : '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(context) async {
    setState(() {
      isLoading = true;
    });
    if (_formUpdateProfileKey.currentState!.validate()) {
      // Save the profile data
      try {
        await Future.delayed(const Duration(seconds: 1));

        // Call the API to save the profile data
        final updatedUser = await _profileController.updateProfile(
          _fullNameController.text,
          _usernameController.text,
          _phoneNumberController.text,
          _genderController.text,
          _dateOfBirthController.text,
          null,
        );

        if (mounted) {
          Provider.of<SettingsProvider>(
            context,
            listen: false,
          ).setUserData(updatedUser);

          CHelperFunctions.showSnackBar(
            'Profile updated successfully',
            context: context,
          );

          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, true);
        }
      } catch (e) {
        String errorMessage = e.toString();
        print("Error save profile: $errorMessage");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CSizes.defaultSpace),
          child: Form(
            key: _formUpdateProfileKey,
            child: Column(
              children: [
                // -- Profile Picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      CCircularImage(
                        width: 80,
                        height: 80,
                        image: profileImage,
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implement change photo logic
                        },
                        child: Text('Change Photo'),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: CSizes.spaceBtwItems),
                Divider(),
                SizedBox(height: CSizes.spaceBtwItems),

                // -- Profile Information
                CSectorHeading(
                  title: 'Profile Information',
                  padding: 0,
                  showActionButton: false,
                ),
                SizedBox(height: CSizes.spaceBtwItems),
                // -- Full Name
                TextFormField(
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Iconsax.user_edit_copy),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: CSizes.spaceBtwInputFields),

                // -- Username
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Iconsax.user_tag_copy),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                SizedBox(height: CSizes.spaceBtwItems),
                Divider(),
                SizedBox(height: CSizes.spaceBtwItems),

                // -- Personal Information
                CSectorHeading(
                  title: 'Personal Information',
                  padding: 0,
                  showActionButton: false,
                ),
                SizedBox(height: CSizes.spaceBtwItems),

                // -- Email
                TextFormField(
                  controller: TextEditingController(text: email),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Iconsax.direct_copy),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  readOnly: true, // Make email read-only
                ),
                SizedBox(height: CSizes.spaceBtwInputFields),
                // -- User ID
                TextFormField(
                  controller: TextEditingController(
                    text: userId.substring(0, 9),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    prefixIcon: Icon(Iconsax.copy_copy),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  readOnly: true, // Make User ID read-only
                ),
                SizedBox(height: CSizes.spaceBtwInputFields),
                // -- Phone Number
                TextFormField(
                  controller: _phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Iconsax.call_copy),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: CSizes.spaceBtwInputFields),
                // -- Gender
                DropdownButtonFormField<String>(
                  value:
                      _genderOptions.contains(_genderController.text)
                          ? _genderController.text
                          : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Iconsax.user_cirlce_add_copy),
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _genderOptions
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value!;
                    });
                  },
                ),
                SizedBox(height: CSizes.spaceBtwInputFields),
                // -- Date of Birth
                TextFormField(
                  controller: _dateOfBirthController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Iconsax.calendar_copy),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime initialDate = _selectedDate ?? DateTime.now();
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _dateOfBirthController
                            .text = CFormatFunction.formatDate(pickedDate);
                      });
                    }
                  },
                ),

                SizedBox(height: CSizes.spaceBtwItems),
                Divider(),
                SizedBox(height: CSizes.spaceBtwItems),

                // -- Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => {_saveProfile(context)},
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Update Profile'),
                  ),
                ),

                SizedBox(height: CSizes.spaceBtwItems),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
