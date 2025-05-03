import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class DetailCouponScreen extends StatefulWidget {
  final Map<String, dynamic> coupon;
  const DetailCouponScreen({super.key, required this.coupon});
  
  @override
  State<StatefulWidget> createState() => DetailCouponScreenState();
}

class DetailCouponScreenState extends State<DetailCouponScreen> {
  late TextEditingController codeController;
  late TextEditingController valueController;
  late TextEditingController limitController;
  late TextEditingController usedCountController;
  late TextEditingController createdDateController;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    valueController = TextEditingController();
    limitController = TextEditingController();
    usedCountController = TextEditingController();
    createdDateController = TextEditingController();

    codeController.text = widget.coupon['code'].toString();
    valueController.text = widget.coupon['value'].toString();
    limitController.text = widget.coupon['totalUsages'].toString();
    usedCountController.text = widget.coupon['usedCount'].toString();
    createdDateController.text = widget.coupon['createdDate'].toString();
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
    limitController.dispose();
    valueController.dispose();
    usedCountController.dispose();
    createdDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(title: 'Detail coupon'),
            Divider(),

            // Information of coupon
            // Code, value, total usage, used count, createdDate
            Wrap(
              spacing: 30,
              runSpacing: 10,
              direction: Axis.horizontal,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    CFieldDetail(
                      label: 'Coupon Code', 
                      hintText: 'Coupon code',
                      controller: codeController
                    ),
                    CFieldDetail(
                      label: 'Value', 
                      hintText: '20000',
                      keyboardType: TextInputType.number,
                      controller: valueController
                    ),
                    CFieldDetail(
                      label: 'Total Usage', 
                      hintText: '20',
                      keyboardType: TextInputType.number,
                      controller: limitController
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    CFieldDetail(
                      label: 'Used count', 
                      hintText: '12',
                      keyboardType: TextInputType.number,
                      isEnable: false,
                      controller: usedCountController
                    ),
                    CFieldDetail(
                      label: 'Created Date', 
                      hintText: '20/03/2025',
                      keyboardType: TextInputType.datetime,
                      controller: createdDateController,
                    ),
                  ],
                )
              ],
            ),
            
            PaginatedTable(
              header: 'List orders',
              lists: (widget.coupon['orders'] as List).isEmpty ? [] : widget.coupon['orders'],
              removeFunction: (){}, 
              columns: [
                DataColumn(label: Text('Order Id')),
                DataColumn(label: Text('Order Date')),
                DataColumn(label: Text('Order Value')),
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Action')),
              ], 
            ),

            // Row button:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: Text('Cancel')
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_outlined),
                        Text('Update'),
                      ],
                    )
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
  
}

class CFieldDetail extends StatelessWidget {
  const CFieldDetail({
    super.key,
    required this.controller,
    this.width = 450,
    this.height = 50,
    this.hintText = '',
    this.label = '',
    this.isEnable = true,
    this.keyboardType = TextInputType.text
  });

  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isEnable;
  final double height;
  final double width;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 450,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabled: isEnable,
          contentPadding: EdgeInsets.all(8),
          hintText: hintText,
          label: Text(label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
      ),
    );
  }
}