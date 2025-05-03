import 'package:ecommerce/common/widgets/custom_shapes/curved_edges_widget.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/circular_container.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CPrimaryHeaderContainer extends StatelessWidget {
  const CPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CCurvedEdgesWidget(
      child: SizedBox(
        height: 220,
        child: Container(
          color: CColors.primary,
          child: Stack(
            children: [
              // -- Background Custom Shape
              Positioned(
                top: -150,
                right: -250,
                child: CCircularContainer(
                  backgroundColor: CColors.textWhite.withOpacity(0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: CCircularContainer(
                  backgroundColor: CColors.textWhite.withOpacity(0.1),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
