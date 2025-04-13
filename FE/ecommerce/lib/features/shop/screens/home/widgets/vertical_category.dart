import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CVerticalItem extends StatelessWidget {
  const CVerticalItem({
    super.key,
    required this.imageString,
    required this.titleName,
    required this.onTapAction,
  });

  final String imageString;
  final String titleName;
  final void Function() onTapAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAction,
      child: Padding(
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
                child: Image(image: AssetImage(imageString), fit: BoxFit.cover)
              ),
            ),
        
            // Text:
            SizedBox(
              width: 55, 
              child: Center(
                child: Text(
                  titleName, 
                  style: Theme.of(context).textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}