import 'package:ecommerce/common/widgets/custom_shapes/curved_edges.dart';
import 'package:flutter/material.dart';

class CCurvedEdgesWidget extends StatelessWidget {
  const CCurvedEdgesWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CCustomCurvedEdges(),
      child: child,
    );
  }
}
