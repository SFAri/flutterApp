import 'package:ecommerce/common/widgets/images/circular_image.dart';
import 'package:ecommerce/features/personalization/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CUserProfileTitle extends StatelessWidget {
  final Map<String, dynamic>? userData;
  String get fullName => userData?['fullName'] ?? '';
  String get email => userData?['email'] ?? '';

  const CUserProfileTitle({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CCircularImage(
        image: 'assets/images/users/default-user.jpg',
        width: 56,
        height: 56,
      ),
      title: Text(
        fullName,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium!.apply(color: Colors.white),
      ),
      subtitle: Text(
        email,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.apply(color: Colors.white),
      ),
      trailing: IconButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
        icon: const Icon(Iconsax.edit_copy, color: Colors.white),
      ),
    );
  }
}
