import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class VariantWithImage extends StatelessWidget {
  const VariantWithImage({
    super.key,
    this.images = '',
    required this.isSelected,
    required this.onSelect,
    this.title = 'Grey',
    this.price = '20.000.000 VNĐ'
  });

  final String images;
  final bool isSelected;
  final String title;
  final String price;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ChoiceChip(
        padding: EdgeInsets.symmetric(vertical: 5),
        label: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  // Image:
                  if (images.isNotEmpty)
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          images,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            
                  // Column includes name color and price:
                  Column(
                    spacing: 5,
                    children: [
                      Text(
                        title,
                        maxLines: 3, // Số dòng tối đa
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.visible
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: CSizes.fontSizeSm,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            if (isSelected) // Hiển thị checkmark khi được chọn
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24, // Điều chỉnh kích thước checkmark
                ),
              ),
          ]
        ), 
        selected: isSelected,
        selectedColor: Colors.transparent,
        onSelected: (value) {
          onSelect();
        },
        disabledColor: Colors.white,
        showCheckmark: false,
      ),
    );
  }
}