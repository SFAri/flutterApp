import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formChangePasswordKey = GlobalKey<FormState>();
  final ProfileController _profileController = ProfileController();

  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (_formChangePasswordKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await Future.delayed(const Duration(seconds: 1));
        final Map<String, dynamic> response = await _profileController
            .changePassword(
              _currentPasswordController.text,
              _newPasswordController.text,
              _confirmPasswordController.text,
            );

        if (response['status'] == "failure") {
          if (mounted) {
            CHelperFunctions.showSnackBar(
              response['message'],
              context: context,
            );
          }

          return;
        }
        CHelperFunctions.showSnackBar(
          'Password changed successfully!',
          context: context,
        );
        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          CHelperFunctions.showSnackBar(
            'An error occurred: ${e.toString()}',
            context: context,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback toggleObscureText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Iconsax.password_check_copy),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Iconsax.eye_slash_copy : Iconsax.eye_copy),
          onPressed: toggleObscureText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CSizes.borderRadiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Change Password',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Form(
            key: _formChangePasswordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordField(
                  controller: _currentPasswordController,
                  labelText: 'Current Password',
                  obscureText: _obscureCurrentPassword,
                  toggleObscureText:
                      () => setState(
                        () =>
                            _obscureCurrentPassword = !_obscureCurrentPassword,
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: CSizes.spaceBtwInputFields),
                _buildPasswordField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  obscureText: _obscureNewPassword,
                  toggleObscureText:
                      () => setState(
                        () => _obscureNewPassword = !_obscureNewPassword,
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: CSizes.spaceBtwInputFields),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm New Password',
                  obscureText: _obscureConfirmPassword,
                  toggleObscureText:
                      () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: CSizes.spaceBtwSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _handleChangePassword,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Change Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
