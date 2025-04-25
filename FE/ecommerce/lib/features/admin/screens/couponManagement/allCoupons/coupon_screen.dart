import 'package:ecommerce/common/widgets/filters/search_filter.dart';
import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/screens/couponManagement/detailCoupon/detail_coupon.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => CouponScreenState();
}

class CouponScreenState extends State<CouponScreen> {
  List<Map<String, dynamic>> coupons = [
    {
      'code': 'SAVE20',
      'value': 20.0, // Giá trị coupon
      'totalUsages': 100, // Số lượng coupon có sẵn
      'usedCount': 50, // Số lượng đã sử dụng
      'createdDate': DateTime(2023, 1, 15), // Ngày tạo coupon
      'orders': [
        {
          'orderId': 'ORD001',
          'orderDate': DateTime(2023, 2, 10),
          'orderValue': 100.0,
          'customerName': 'John Doe',
        },
        {
          'orderId': 'ORD002',
          'orderDate': DateTime(2023, 2, 15),
          'orderValue': 150.0,
          'customerName': 'Jane Smith',
        },
      ],
    },
    {
      'code': 'FREESHIP',
      'value': 0.0, // Giá trị coupon (miễn phí vận chuyển)
      'totalUsages': 200,
      'usedCount': 150,
      'createdDate': DateTime(2023, 3, 1),
      'orders': [
        {
          'orderId': 'ORD003',
          'orderDate': DateTime(2023, 3, 5),
          'orderValue': 200.0,
          'customerName': 'Alice Brown',
        },
      ],
    },
    {
      'code': 'SUMMER30',
      'value': 30.0, // Giá trị coupon
      'totalUsages': 50,
      'usedCount': 20,
      'createdDate': DateTime(2023, 4, 10),
      'orders': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Header(title: 'Coupon'),
            Divider(),
        
            // Filter row:
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                SearchFilter(),
                DropdownButton(
                  value: 'All',
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  items: [
                    DropdownMenuItem<String>(value: 'All',child: Text('All'),),
                    DropdownMenuItem<String>(value: 'Expired',child: Text('Expired'),),
                    DropdownMenuItem<String>(value: 'Still alive',child: Text('Still alive'),)
                  ], 
                  onChanged: (value) {
                    
                  },
                )
              ],
            ),
            // Coupon table:
            PaginatedTable(
              lists: coupons,
              removeFunction: (){},
              viewFunction: (){
                streamController.add(DetailCouponScreen());
              },
              header: 'List coupons',
              columns: [
                DataColumn(label: Text('Code')),
                DataColumn(label: Text('Value')),
                DataColumn(label: Text('Total Usage')),
                DataColumn(label: Text('Used Count')),
                DataColumn(label: Text('Created Date')),
                DataColumn(label: Text('Action')),
              ],
            )
          ],
        ),
      )
    );
  }
  
}