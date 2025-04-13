import 'package:ecommerce/common/widgets/custom_shapes/curved_edges.dart';
import 'package:ecommerce/common/widgets/layout/custom_carousel_slider.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/circular_container.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ecommerce/utils/constants/colors.dart';
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
            ClipPath(
              clipper: CCustomCurvedEdges(),
              child: Container(
                color: CColors.primary,
                padding: EdgeInsets.all(0),
                child: SizedBox(
                  height: 270,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -150,
                        right: -250,
                        child: CCircularContainer(
                          backgroundColor: CColors.textWhite.withValues(alpha: 0.1),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        right: 300,
                        child: CCircularContainer(
                          backgroundColor: CColors.textWhite.withValues(alpha: 0.1),
                        ),
                      ),
                      Column(
                        spacing: CSizes.defaultSpace,
                        children: [
                          SizedBox(height: 2),
                          // Appbar
                          CHomeAppBar(),

                          // Categories
                          CHomeCategory(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
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






