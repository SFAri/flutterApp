import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/material.dart';

class CProfileMenu extends StatelessWidget {
  const CProfileMenu({
    super.key,
    required this.onPressed,
    required this.title,
    required this.value,
    this.icon = Iconsax.arrow_right_3_copy,
  });

  final VoidCallback onPressed;
  final String title, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: CSizes.spaceBtwItems / 1.5,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(child: Icon(icon, size: CSizes.iconSm)),
          ],
        ),
      ),
    );
  }
}
