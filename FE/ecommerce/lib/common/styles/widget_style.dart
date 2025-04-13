// import 'package:ecommerce/utils/constants/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

class CShadowStyle {
  static final productShadow = BoxShadow(
    color: Colors.grey.shade400.withValues(alpha: 0.3),
    blurRadius: 50,
    spreadRadius: 7,
    offset: Offset(0, 2)
  );
}