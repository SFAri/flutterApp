import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/vertical_category.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CHomeCategory extends StatelessWidget {
  final void Function(Map<String, dynamic> filter)? onCategorySelected;
  const CHomeCategory({
    super.key,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"image": CImages.pcIcon, "label": "Monitor"},
      {"image": CImages.laptopIcon, "label": "Laptop"},
      {"image": CImages.headphonesIcon, "label": "Accessory"},
      {"image": CImages.ramIcon, "label": "RAM"},
      {"image": CImages.wifiIcon, "label": "SSD"},
      {"image": CImages.osIcon, "label": "Motherboard"},
    ];


    
    return Column(
      spacing: 12,
      children: [
        // Heading sector:
        CSectorHeading(
          title: 'Popular Categories',
          showActionButton: false,
        ),
        // Categories :
        Container(
          height: 100,
          padding: EdgeInsets.only(left: CSizes.defaultSpace, right: CSizes.defaultSpace),
          child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return CVerticalItem(
                titleName: categories[index]["label"]!, 
                imageString: categories[index]["image"]!,
                onTapAction: (){
                  onCategorySelected?.call({
                    'category': categories[index]["label"]!,
                  });
                },
              );
            }
          ),
        ),
      ],
    );
  }
}