import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/vertical_category.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CHomeCategory extends StatelessWidget {
  const CHomeCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"image": CImages.pcIcon, "label": "PC"},
      {"image": CImages.laptopIcon, "label": "Laptop"},
      {"image": CImages.headphonesIcon, "label": "Phụ kiện"},
      {"image": CImages.ramIcon, "label": "Linh kiện"},
      {"image": CImages.wifiIcon, "label": "Thiết bị mạng"},
      {"image": CImages.osIcon, "label": "Phần mềm"},
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
              return CVerticalItem(titleName: categories[index]["label"]!, imageString: categories[index]["image"]!, onTapAction: (){},);
            }
          ),
        ),
      ],
    );
  }
}