import 'package:ecommerce/common/widgets/custom_shapes/curved_edges.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/circular_container.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CClipPathAppBar extends StatelessWidget {
  const CClipPathAppBar({
    super.key,
    this.height = 270,
    required this.listWidgets
  });

  final double height;
  final List<Widget> listWidgets;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CCustomCurvedEdges(),
      child: Container(
        color: CColors.primary,
        padding: EdgeInsets.all(0),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: CCircularContainer(
                  backgroundColor: CColors.textWhite.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: 300,
                child: CCircularContainer(
                  backgroundColor: CColors.textWhite.withValues(alpha: 0.1),
                ),
              ),
              Column(
                spacing: 14,
                children: listWidgets
              )
            ],
          ),
        ),
      ),
    );
  }
}