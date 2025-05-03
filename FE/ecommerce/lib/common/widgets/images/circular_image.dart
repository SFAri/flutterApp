import 'package:flutter/material.dart';

class CCircularImage extends StatelessWidget {
  const CCircularImage({
    super.key,
    required this.width,
    required this.height,
    required this.image,
    this.isNetworkImage = false,
  });

  final double width, height;
  final String image;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: isNetworkImage ? NetworkImage(image) : AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
