import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/common/widgets/images/radius_image.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class CCarouselSliderWithDot extends StatefulWidget {
  const CCarouselSliderWithDot({
    super.key,
  });

  @override
  State<CCarouselSliderWithDot> createState() => _CCarouselSliderWithDotState();
}

class _CCarouselSliderWithDotState extends State<CCarouselSliderWithDot> {
  late CarouselSliderController controller;
  late int selected;

  @override
  void initState() {
    selected = 0;
    controller = CarouselSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: true,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                selected = index;
              });
            },
          ),
          items: [
            CRadiusImage(imageUrl: CImages.blackFridayLaptop, onTap: (){}),
            CRadiusImage(imageUrl: CImages.blackFridayLaptop, onTap: (){}),
            CRadiusImage(imageUrl: CImages.blackFridayLaptop, onTap: (){}),
          ]
        ),

        // Indicators:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3, 
            (index) {
              bool isCurrent = selected == index;
              return GestureDetector(
                onTap: () {
                  controller.animateToPage(index);
                },
                child: AnimatedContainer(
                  width: isCurrent ? 55 : 17,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: isCurrent ? 6 : 3),
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.blue.shade200 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              );
            }  
          ),
        )
      ],
    );
  }
}