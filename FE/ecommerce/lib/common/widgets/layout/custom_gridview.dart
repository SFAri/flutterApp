import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:flutter/material.dart';

class CGridView extends StatelessWidget {
  const CGridView({
    super.key,
    required this.items,
    this.mainAxisExtent = 290,
    this.crossAxisCount = 2
  });

  final List<dynamic> items;
  final int crossAxisCount;
  final double mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: items.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: mainAxisExtent
        ), 
        itemBuilder: (_, index) => CProductCard(
          productName: items[index]["name"]!, 
          imageProduct: items[index]["images"][0]!, 
          productBrand: items[index]["brand"]!, 
          price: items[index]["price"]!.toString(), 
          salePrice: items[index]["discount"] != null ? items[index]["discount"]!.toString() : '0',
          rateStar: double.parse(items[index]['averageRating'].toString()),
        ),
      ),
    );
  }
}