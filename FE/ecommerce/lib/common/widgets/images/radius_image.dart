import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CRadiusImage extends StatelessWidget {
  const CRadiusImage({
    super.key,
    required this.onTap,
    required this.imageUrl,
    this.isNetworkImage = false
  });

  final String imageUrl;
  final void Function() onTap;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CSizes.md),
        child: Image(image: isNetworkImage? NetworkImage(imageUrl) : AssetImage(imageUrl))
      ),
    );
  }
}