import 'package:ecommerce/common/widgets/images/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CUserProfileTitle extends StatelessWidget {
  const CUserProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CCircularImage(
        image: 'assets/images/users/default-user.jpg',
        width: 56,
        height: 56,
      ),
      title: Text(
        'John Doe',
        style: Theme.of(
          context,
        ).textTheme.headlineMedium!.apply(color: Colors.white),
      ),
      subtitle: Text(
        '@johndoe',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.apply(color: Colors.white),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Iconsax.edit_copy, color: Colors.white),
      ),
    );
  }
}
