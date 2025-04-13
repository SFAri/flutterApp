import 'package:flutter/material.dart';
import 'package:ecommerce/utils/constants/sizes.dart';

class TCircularIcon extends StatelessWidget {
  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  const TCircularIcon({
    Key? key,
    required this.icon,
    this.width,
    this.height,
    this.size = CSizes.lg,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            )
          : null,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: size,
          color: color ?? Theme.of(context).iconTheme.color,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: CSizes.lg,
      ),
    );
  }
}
