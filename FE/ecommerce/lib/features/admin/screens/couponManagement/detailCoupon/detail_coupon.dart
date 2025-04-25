import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:flutter/material.dart';

class DetailCouponScreen extends StatefulWidget {
  const DetailCouponScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => DetailCouponScreenState();
}

class DetailCouponScreenState extends State<DetailCouponScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          children: [
            Header(title: 'Detail coupon'),
            Divider(),

            
          ],
        ),
      )
    );
  }
  
}