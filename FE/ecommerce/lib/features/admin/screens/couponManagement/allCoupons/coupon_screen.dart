import 'package:ecommerce/common/widgets/filters/search_filter.dart';
import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/screens/couponManagement/detailCoupon/detail_coupon.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:ecommerce/features/auth/controllers/coupon_controller.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => CouponScreenState();
}

class CouponScreenState extends State<CouponScreen> {
  final CouponController couponController = CouponController();
  List<dynamic> coupons = [];
  String selectedStatus = 'All';
  bool isLoading = true;
  String searchQuery = '';


  @override
  void initState() {
    super.initState();
    fetchCoupons();
  }

  // Fetch data:
  Future<void> fetchCoupons() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await couponController.getCoupons();
      if (response['status'] == 'success') {
        setState(() {
          coupons = response['data'];
        });
        print("coupons: ${coupons.join(',')}");
      } else {
        print('error');
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

  // Filter product:
  List<dynamic> getFilteredCoupons() {
    return coupons.where((coup) {
      final matchesActive = selectedStatus == 'All' ||
                              coup['isActive'] == bool.parse(selectedStatus);
      final matchesSearch = coup['code'].toLowerCase().contains(searchQuery.toLowerCase());

      return matchesActive && matchesSearch;
    }).toList();
  }

  // Show modal add and edit category:
  Future<void> _showDialog(BuildContext context, String title, Function acceptFunction) {
    final couponCodeController = TextEditingController();
    final discountController = TextEditingController();
    final usageController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DialogForm(title: title, 
          widgets: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                SizedBox(height: 8),
                CTextFormField(
                  label: 'Coupon code', 
                  hintText: 'Enter Coupon code', 
                  controller: couponCodeController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a coupon code'; // Thông báo lỗi nếu không có giá trị
                    }
                    return null; // Trả về null nếu không có lỗi
                  },
                ),
                CTextFormField(
                  label: 'Discount amount', 
                  hintText: 'Enter Discount amount', 
                  controller: discountController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter discount amount'; 
                    }
                    return null; 
                  },
                ),
                CTextFormField(
                  label: 'Usage limit', 
                  hintText: 'Enter number of usage', 
                  controller: usageController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of usage'; 
                    }
                    return null; 
                  },
                ),
              ],
            ),
          ), 
          acceptFunction: () {
            final updatedCoupon = {
              'code': couponCodeController.text,
              'discountAmount': double.tryParse(discountController.text) ?? 0.0,
              'usageLimit': double.tryParse(usageController.text) ?? 10,
              'isActive': true,
            };
            acceptFunction(updatedCoupon); 
          },
        );
      },
    );
  }

  Future<void> handleAddCoupon(context, data) async {
    try {
      final response = await couponController.createCoupon(data);
      if (response['status'] == 'success') {
        // setState(() {
        //   coupons = response['data'];
        // });
        // print("creating coupon successfully: ${coupons.join(',')}");
        const snackBar = SnackBar(content: Text('Create Coupon successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('error');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
    finally{
      fetchCoupons();
    }
  }

  Future<void> handleDelete(context, dynamic item) async {
    print('ITEM DELETINGGGG: $item');
    final code = item['code'];
    try {
      final response = await couponController.deleteCoupon(code);
      if (response['status'] == 'success') {
        const snackBar = SnackBar(content: Text('Delete Coupon successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('error');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
    finally{
      fetchCoupons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
    ? Center(child: CircularProgressIndicator(),)
    : SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            // Header(title: 'Coupon'),
            // Divider(),
        
            // Filter row:
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide()
                      )
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                DropdownButton(
                  value: selectedStatus,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  items: [
                    DropdownMenuItem<String>(value: 'All',child: Text('All'),),
                    DropdownMenuItem<String>(value: 'false',child: Text('Expired'),),
                    DropdownMenuItem<String>(value: 'true',child: Text('Still active'),)
                  ], 
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green
                  ),
                  onPressed: () {
                    _showDialog(
                      context, 
                      'Add new coupon', 
                      (data) {
                        // Handle adding the new variant data here
                        handleAddCoupon(context, data);
                      },
                    );
                  }, // show modal add here!
                )
              ],
            ),
            // Coupon table:
           
            PaginatedTable(
              lists: getFilteredCoupons(),
              removeFunction: (item){
                handleDelete(context, item);
              },
              viewFunction: (item) {
                streamController.add(DetailCouponScreen(coupon: item));
              },
              header: 'List coupons',
              columns: [
                DataColumn(label: Text('Code')),
                DataColumn(label: Text('Value')),
                DataColumn(label: Text('Limit usage')),
                DataColumn(label: Text('Used Count')),
                DataColumn(label: Text('Active')),
                DataColumn(label: Text('Action')),
              ],
              columnKeys: ['code', 'discountAmount', 'usageLimit', 'usedCount', 'isActive'],
            )
          ],
        ),
      )
    );
  }
  
}