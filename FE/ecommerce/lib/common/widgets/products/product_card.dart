import 'package:ecommerce/common/styles/widget_style.dart';
import 'package:ecommerce/features/shop/screens/product_details/product_detail.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CProductCard extends StatelessWidget {
  const CProductCard(
      {super.key,
      required this.imageProduct,
      required this.productName,
      required this.productBrand,
      required this.price,
      this.salePrice = '0',
      this.rateStar = 5});

  final double rateStar;
  final String imageProduct, productName, productBrand;
  final String price;
  final String salePrice;

  @override
  Widget build(BuildContext context) {
    final bool dark = CHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetail(),
          ),
        );
      },
      child: Container(
        width: 170,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CSizes.productImageRadius),
            boxShadow: [CShadowStyle.productShadow],
            color: dark ? Colors.grey : Colors.white),
        child: Column(
          children: [
            // Product image
            CRoundedContainer(
              width: 170,
              height: 130,
              padding: EdgeInsets.all(0),
              radius: CSizes.productImageRadius,
              // backgroundColor: dark ? CColors.dark : CColors.light,
              child: Column(
                children: [
                  Stack(children: [
                    // Image
                    Container(
                      alignment: Alignment.center,
                      width: 170,
                      height: 130,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(CSizes.productImageRadius),
                        child: Image(
                            image: AssetImage(imageProduct), fit: BoxFit.cover),
                      ),
                    ),

                    // Sale tag:
                    if (salePrice != '0')
                      Positioned(
                        top: 5,
                        left: 2,
                        child: CRoundedContainer(
                          radius: CSizes.sm,
                          backgroundColor:
                              CColors.secondary.withValues(alpha: 0.8),
                          padding: EdgeInsets.symmetric(
                              horizontal: CSizes.sm, vertical: CSizes.xs),
                          child: Text(
                            '$salePrice%',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .apply(color: CColors.dark),
                          ),
                        ),
                      )
                  ]),
                ],
              ),
            ),

            // ----- PRODUCT DETAIL:
            Padding(
              padding: EdgeInsets.only(left: CSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CProductCardTitle(title: productName, smallSize: false),
                  Text(productBrand,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium),
                  Text('$price VND',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall),
                  // Rate and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBar.builder(
                          initialRating: rateStar,
                          ignoreGestures: true,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                          onRatingUpdate: ((rating) {
                            print(rating);
                          })),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: SizedBox(
                          width: CSizes.iconLg * 1.2,
                          height: CSizes.iconLg * 1.2,
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CProductCardTitle extends StatelessWidget {
  const CProductCardTitle(
      {super.key,
      required this.title,
      this.smallSize = false,
      this.maxLines = 2,
      this.textAlign = TextAlign.left});

  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallSize
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class CRoundedContainer extends StatelessWidget {
  const CRoundedContainer(
      {super.key,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.showBorder = false,
      this.radius = CSizes.borderRadiusMd,
      this.borderColor = CColors.grey,
      this.backgroundColor = CColors.textWhite,
      this.child});

  final double? height, width;
  final double radius;
  final EdgeInsetsGeometry? padding, margin;
  final Color borderColor;
  final Color backgroundColor;
  final Widget? child;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
