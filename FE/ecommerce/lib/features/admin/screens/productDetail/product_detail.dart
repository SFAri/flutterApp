import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(Map<String, dynamic> item, {super.key});

  @override
  State<StatefulWidget> createState() => _ProductDetailScreenState();
  
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _brandController;
  late TextEditingController _categoryController;
  late TextEditingController _discountController;
  // double _discount = 0.0;

  String? _selectedBrand;
  final List<String> _brands = [
    'Apple', 
    'Lenovo', 
    'HP', 
    'Dell'
  ];

  String? _selectedCategory;
  final List<String> _categories = [
    'Laptop', 
    'PC', 
    'Monitor',
    'Accessory', 
    'Software'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _brandController = TextEditingController();
    _categoryController = TextEditingController();
    _discountController = TextEditingController();
  } 

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    _discountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Header(title: 'Product Detail:'),
        Divider(),

        // Form chứa thông tin của product: 
        // Thông tin trong các textfield gồm: ID, Code, name, description, imageStrings[], brand, category, discount
        Wrap(
          direction: Axis.horizontal,
          runSpacing: 10,
          spacing: 50,
          children: [
            Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 450,
                  child: CTextFormField(
                    controller: _codeController,
                    label: 'Product Id',
                  ),
                ),
                SizedBox(
                  width: 450,
                  child: CTextFormField(
                    controller: _codeController,
                    label: 'Product Code',
                  ),
                ),
                SizedBox(
                  width: 450,
                  child: CTextFormField(
                    controller: _nameController,
                    label: 'Product Name',
                    hintText: 'Enter product name',
                  ),
                ),
              ],
            ),
            Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 450,
                  child: DropdownButtonFormField<String>(
                    value: _selectedBrand,
                    decoration: InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                    items: _brands.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBrand = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 450,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 450,
                  child: CTextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: _discountController,
                    label: 'Discount',
                    onChanged: (value) {
                      
                    },
                  ),
                ),
              ],
            )
          ],
        ),

        SizedBox(
          width: Responsive.isDesktop(context) ? 950 : 450,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: '',
              labelText: 'Description',
            ),
            maxLines: 10,
          ),
        )

        // Dưới là 1 cái listview động chứa thông tin variants: [code, name, type ,retail price, sale price, inStock]

      ],
    );
  }
  
}