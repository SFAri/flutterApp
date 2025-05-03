import 'package:ecommerce/common/widgets/layout/custom_carousel_slider.dart';
import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> products = [
      {
        "name": "Macbook air 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "27000000",
      },
      {
        "name": "Macbook pro 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "32536000", "salePrice": "11"
      },
      {
        "name": "Lenovo Ideapad 3", "brand": "Lenovo", "imageUrl": CImages.macImage, "price": "19330000",
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CClipPathAppBar(
              listWidgets: [
                SizedBox(height: 2),
                CHomeAppBar(),
                CHomeCategory()
              ],
            ),

            // BODY------------
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Promoting products: ', 
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
                Tab(child: Text('Best sellers')),
                Tab(child: Text('Laptop')),
                Tab(child: Text('PC')),
                Tab(child: Text('Hard drives')),
              ]
            ),
            SizedBox(
              height: 690,
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CGridView(items: products),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){}, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: products),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){}, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: products),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){}, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: products),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){}, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: products),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){}, 
                          child: Text('View all >>>')
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CGridView(items: products),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){}, 
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