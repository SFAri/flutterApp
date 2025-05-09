
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CSectorHeading extends StatelessWidget {
  const CSectorHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle = 'View all',
    required this.title,
    this.showActionButton = false,
    this.padding = CSizes.defaultSpace
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final double padding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis,),
          if(showActionButton) 
            TextButton(
              onPressed: onPressed, 
              child: Text(buttonTitle)
            ),
        ],
      ),
    );
  }
}