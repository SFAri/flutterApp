import 'package:ecommerce/common/widgets/custom_shapes/curved_edges.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/circular_container.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CCustomCurvedEdges(),
              child: Container(
                color: CColors.primary,
                padding: EdgeInsets.all(0),
                child: SizedBox(
                  height: 400,
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
                          // Appbar
                          CHomeAppBar(),

                          // Categories
                          Padding(
                            padding: EdgeInsets.only(left: CSizes.defaultSpace),
                            child: Column(
                              spacing: 12,
                              children: [
                                // Heading sector:
                                CSectorHeading(
                                  title: 'Popular Categories',
                                  showActionButton: false,
                                ),

                                // Cates:
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    itemCount: 6,
                                    
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: CSizes.spaceBtwItems),
                                        child: Column(
                                          spacing: 12,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              padding: EdgeInsets.all(CSizes.sm),
                                              decoration: BoxDecoration(
                                                color: CColors.textWhite,
                                                borderRadius: BorderRadius.circular(100)
                                              ),
                                              child: Center(
                                                child: Image(image: AssetImage(''), fit: BoxFit.cover, color: CColors.dark,)
                                              ),
                                            ),
                                        
                                            // Text:
                                            SizedBox(
                                              width: 55, 
                                              child: Text(
                                                'Computer', 
                                                style: Theme.of(context).textTheme.labelMedium,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Filter
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
