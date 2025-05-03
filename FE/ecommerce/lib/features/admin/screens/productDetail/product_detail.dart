import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(Map<String, dynamic> item, {super.key});

  @override
  State<StatefulWidget> createState() => _ProductDetailScreenState();
  
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Header(title: 'Product Detail'),
        Divider(),

        // Form chứa thông tin của product: 
        // Thông tin trong các textfield gồm: ID, Code, name, description, imageStrings[], brand, category, discount
        // Dưới là 1 cái listview động chứa thông tin variants: [code, name, type ,retail price, sale price, inStock]

      ],
    );
  }
  
}