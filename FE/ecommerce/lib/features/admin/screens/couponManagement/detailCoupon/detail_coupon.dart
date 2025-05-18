import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:ecommerce/features/auth/controllers/coupon_controller.dart';
import 'package:ecommerce/features/auth/controllers/order_controller_admin.dart';
import 'package:flutter/material.dart';

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
  // late TextEditingController createdDateController;
  late bool isActive; 
  List<dynamic> orders = [];
  bool isLoading = true;
  final OrderAdminController orderAdminController = OrderAdminController();
  final CouponController couponController = CouponController();
  final GlobalKey<FormState> _couponFormKey = GlobalKey<FormState>();

  // Fetch data:
  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await orderAdminController.filterOrders(filter: {'couponCode': widget.coupon['code']});
      if (response['status'] == 'success') {
        setState(() {
          orders = response['data'];
        });
        print("orders: ${orders.join(',')}");
      } else {
        print('error: $response');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    valueController = TextEditingController();
    limitController = TextEditingController();
    usedCountController = TextEditingController();
    // createdDateController = TextEditingController();

    codeController.text = widget.coupon['code'].toString();
    valueController.text = widget.coupon['discountAmount'].toString();
    limitController.text = widget.coupon['usageLimit'].toString();
    usedCountController.text = widget.coupon['usedCount'].toString();
    // createdDateController.text = widget.coupon['isActive'].toString();
    isActive = widget.coupon['isActive'];

    fetchOrders();
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
    limitController.dispose();
    valueController.dispose();
    usedCountController.dispose();
    // createdDateController.dispose();
  }

  Future<void> handleUpdate(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> couponData = {
        'code': codeController.text,
        'discountAmount': int.parse(valueController.text),
        'usageLimit': int.parse(limitController.text),
        'isActive': isActive,
      };
      final response = await couponController.updateCoupon(widget.coupon['code'], couponData);
      if (response['status'] == 'success') {
        const snackBar = SnackBar(content: Text('Update Coupon successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(content: Text('Error while updating coupon, please retry.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('error: $response');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
    ? Center(child: CircularProgressIndicator())
    : SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Information of coupon
            // Code, value, total usage, used count, createdDate
            Form(
              key: _couponFormKey,
              child: Wrap(
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
                        controller: codeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please coupon code'; 
                          }
                          return null; 
                        },
                      ),
                      CFieldDetail(
                        label: 'Discount Amount', 
                        hintText: '20000',
                        keyboardType: TextInputType.number,
                        controller: valueController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter discount amount'; 
                          }
                          return null; 
                        },
                      ),
                      CFieldDetail(
                        label: 'Limit Usage', 
                        hintText: '20',
                        keyboardType: TextInputType.number,
                        controller: limitController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter limit usage'; 
                          }
                          return null; 
                        },
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
                        controller: usedCountController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter used count'; 
                          }
                          return null; 
                        },
                      ),
                      SizedBox(
                          width: 450,
                          child: DropdownButtonFormField<String>(
                            value: isActive.toString(),
                            decoration: InputDecoration(
                              labelText: 'Active',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem<String>(
                                value: 'true',
                                child: Text('True'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'false',
                                child: Text('False'),
                              ),
                            ],
                              
                            onChanged: (String? newValue) {
                              setState(() {
                                isActive = bool.parse(newValue!);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select true/false'; 
                              }
                              return null; 
                            },
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            
            PaginatedTable(
              header: 'List orders',
              lists: orders,
              // removeFunction: (item){}, 
              columns: [
                DataColumn(label: Text('Order Id')),
                DataColumn(label: Text('Order Date')),
                DataColumn(label: Text('Order Value')),
                DataColumn(label: Text('Customer Id')),
                // DataColumn(label: Text('Action')),
              ], 
              columnKeys: ['_id', 'createdAt', 'totalAmount', 'userId'],
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
                    onPressed: (){
                      if (_couponFormKey.currentState?.validate() ?? false) {
                        // Nếu form hợp lệ, thực hiện hành động
                        // widget.item != null ? handleUpdate(context) : handleCreate(context);
                        handleUpdate(context);
                      }
                    }, 
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
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isEnable;
  final double height;
  final double width;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 450,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabled: isEnable,
          contentPadding: EdgeInsets.all(8),
          hintText: hintText,
          label: Text(label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        validator: validator,
      ),
    );
  }
}