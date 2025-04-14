import 'package:ecommerce/common/widgets/layout/custom_carousel_slider.dart';
import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> products = [
      {
        "name": "Macbook air 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "27.000.000",
      },
      {
        "name": "Macbook pro 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "32.536.000", "salePrice": "11"
      },
      {
        "name": "Lenovo Ideapad 3", "brand": "Lenovo", "imageUrl": CImages.macImage, "price": "19.330.000",
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
              // padding: EdgeInsets.only(left: 10, right: 10),
              // height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CSizes.md),
              ),
              child: CCarouselSliderWithDot()
            ),

            // Product Gridview:
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular products: ', 
                    style: TextStyle(
                      fontSize: CSizes.fontSizeLg,
                      fontWeight: FontWeight.w600
                    )
                  ),
                  TextButton(
                    onPressed: (){}, 
                    child: Text('View all')
                  )
                ],
              ),
            ),
            CGridView(items: products),
          ],
        ),
      ),
    );
  }
}