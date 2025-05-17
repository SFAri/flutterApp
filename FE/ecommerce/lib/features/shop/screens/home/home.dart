import 'package:ecommerce/common/widgets/layout/custom_carousel_slider.dart';
import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/features/auth/controllers/product_controller.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  final void Function(Map<String, dynamic> filter)? onCategorySelected;
  final void Function(Map<String, dynamic> sortBy)? onSortSelected;

  const HomeScreen({super.key, this.onCategorySelected, this.onSortSelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final productController = ProductController();
  late TabController tabController;
  // List<dynamic> products = [];
  List<dynamic> popularProducts = [];
  List<dynamic> newProducts = [];
  List<dynamic> laptopProducts = [];
  List<dynamic> cpuProducts = [];
  List<dynamic> motherboardProducts = [];

  // Filter product:
  Future<void> fetchProducts(Function(List<dynamic>) assignFn, {Map<String, dynamic>? filter, Map<String, dynamic>? sortBy}) async {
    try {
      final response = await productController.filterProducts(filter: filter, sortBy: sortBy);
      if (response['status'] == 'success') {
        setState(() {
          // products = List.from(response['data']).take(4).toList();
          assignFn(List.from(response['data']).take(4).toList());
        });
      } else {
        print('error');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
  }

  Future<void> loadAllProducts() async {
    await Future.wait([
      fetchProducts((data) => popularProducts = data, sortBy: {"averageRating": -1}),
      fetchProducts((data) => newProducts = data, sortBy: {"createdAt": -1}),
      fetchProducts((data) => laptopProducts = data, filter: {"category": "Laptop"}),
      fetchProducts((data) => cpuProducts = data, filter: {"category": "CPU"}),
      fetchProducts((data) => motherboardProducts = data, filter: {"category": "Motherboard"}),
    ]);

    setState(() {}); // Refresh UI after all data is loaded
  }

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 5, vsync: this);
    // fetchProducts(filter, sortBy);
    loadAllProducts();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CClipPathAppBar(
              listWidgets: [
                SizedBox(height: 2),
                CHomeAppBar(),
                CHomeCategory(onCategorySelected: widget.onCategorySelected)
              ],
            ),

            // BODY------------
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Special events: ', 
                style: TextStyle(
                  fontSize: CSizes.fontSizeLg,
                  fontWeight: FontWeight.w600
                )
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CSizes.md),
              ),
              child: CCarouselSliderWithDot()
            ),

            SizedBox(height: 8),

            // Tabbar:
            TabBar(
              padding: EdgeInsets.zero,
              isScrollable:  true,
              indicatorColor: Colors.blue,
              tabAlignment: TabAlignment.center,
              unselectedLabelColor: Colors.grey.shade600,
              labelColor: Colors.blue,
              controller: tabController,
              tabs: [
                Tab(child: Text('Popular products')),
                Tab(child: Text('New products')),
                Tab(child: Text('Laptop')),
                Tab(child: Text('CPU')),
                Tab(child: Text('Motherboard')),
              ]
            ),
            SizedBox(
              height: 690,
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    children: [
                      CGridView(items: popularProducts),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){
                            widget.onSortSelected?.call({
                              'averageRating' : -1
                            });
                          }, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: newProducts),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){
                            widget.onSortSelected?.call({
                              'createdAt' : -1
                            });
                          }, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: laptopProducts),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){
                            widget.onCategorySelected?.call({
                              'category' : 'Laptop'
                            });
                          }, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: cpuProducts),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){
                            widget.onCategorySelected?.call({
                              'category' : 'CPU'
                            });
                          }, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: motherboardProducts),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){
                            widget.onCategorySelected?.call({
                              'category' : 'Motherboard'
                            });
                          }, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}