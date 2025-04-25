import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => CouponScreenState();
  
  
}

class CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          children: [
            Header(title: 'Coupon'),
            Divider()
          ],
        ),
      )
    );
  }
  
}