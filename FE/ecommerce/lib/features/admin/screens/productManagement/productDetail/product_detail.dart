import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
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

  List<String> attributes = [
    'Color',
    'RAM',
    'Storage'
  ];

  List<String> options = [
    'Red',
    'Grey',
    'Yellow'
  ];

  String? _selectedAttribute;
  String? _selectedAttributeOption;

  List<String> imagePath = [
    CImages.macImage,
    CImages.blackFridayLaptop,
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

  // Show modal add and edit category:
  Future<void> _showDialog(BuildContext context, String title, Widget widgets, Function acceptFunction ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DialogForm(title: title, widgets: widgets, acceptFunction: acceptFunction,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        Header(title: 'Product Detail:'),
        Divider(),

        // List view image strings:
        SizedBox(
          height: 300,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 20,),
            itemCount: imagePath.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  // Image -> string -> delete button
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(imagePath[index]),
                  ),
                  // Text(imagePath[index], overflow: TextOverflow.ellipsis,),
                  IconButton(
                    onPressed: (){}, 
                    icon: Icon(Icons.cancel, color: Colors.red,)
                  )
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (){}, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Icon(Icons.add),
                Text('Add Image')
              ],
            )
          ),
        ),

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
        ),

        // Dưới là 1 cái listview động chứa thông tin variants: [code, name, type ,retail price, sale price, inStock]
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (){}, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Icon(Icons.add),
                Text('Add variant')
              ],
            )
          ),
        ),

        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: Icon(Icons.account_tree_rounded),
                contentPadding: EdgeInsets.all(5),
                title: Text('SKU: LTLNVJD8K'),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text('RAM 8Gb'),
                    Text('Color Grey'),
                    Text('Storage 128Gb'),
                    Text('Instock 123'),
                    Text('18,000,000 VNĐ'), // Price here
                  ],
                ),
                trailing: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: (){
                        TextEditingController _editImportController = TextEditingController();
                        TextEditingController _editSaleController = TextEditingController();
                        TextEditingController _editDiscountController = TextEditingController();
                        _editImportController.text = '16000000';
                        _editSaleController.text = '18000000';
                        _editDiscountController.text = '10';
                        _showDialog(context, 'Edit Variant: SKU-LTLNVJD8K', //----- SKU of variant here syntax: Edit Variant: SKU -$skuCode ----------
                          SingleChildScrollView(
                            child: Column(
                              spacing: 10,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: (){
                                      // Show dialog cho chọn dropdownbuttonform attribute; chọn dropdownbuttonForm là attribute value
                                      // Ví dụ: Chọn color -> bên dưới sẽ cho chọn màu red/grey/yellow/white/...
                                      _showDialog(context, 'Edit Option', 
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 10,
                                          children: [
                                            SizedBox(
                                              width: 300,
                                              child: DropdownButtonFormField<String>(
                                                value: _selectedAttribute,
                                                decoration: InputDecoration(
                                                  labelText: 'Attribute',
                                                  border: OutlineInputBorder(),
                                                ),
                                                items: attributes.map((String attribute) {
                                                  return DropdownMenuItem<String>(
                                                    value: attribute,
                                                    child: Text(attribute),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedAttribute = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: DropdownButtonFormField<String>(
                                                value: _selectedAttributeOption,
                                                decoration: InputDecoration(
                                                  labelText: 'Option',
                                                  border: OutlineInputBorder(),
                                                ),
                                                items: options.map((String option) {
                                                  return DropdownMenuItem<String>(
                                                    value: option,
                                                    child: Text(option),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedAttributeOption = newValue;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ), 
                                        (){
                                          // Thực hiện cập nhật ở đây
                                        }
                                      );
                                    }, 
                                    child: Text('Add option')
                                  ),
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text('Variants'),
                                    Expanded(
                                      child: Divider()
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 200,
                                  width: 300,
                                  child: ListView.builder(
                                    itemCount: 3,
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          leading: Icon(Icons.account_tree_rounded),
                                          contentPadding: EdgeInsets.all(5),
                                          title: Text('RAM'),
                                          subtitle: Text('8Gb'),
                                          trailing: Row(
                                            spacing: 5,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: (){}, 
                                                icon: Icon(Icons.edit)
                                              ),
                                              IconButton(
                                                onPressed: (){}, 
                                                icon: Icon(Icons.delete, color: Colors.red,)
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text('General information'),
                                    Expanded(
                                      child: Divider()
                                    ),
                                  ],
                                ),
                                CTextFormField(
                                  label: 'Import price', 
                                  hintText: 'Enter import price', 
                                  controller: _editImportController, 
                                ),
                                CTextFormField(
                                  label: 'Sale price', 
                                  hintText: 'Enter sale price', 
                                  controller: _editSaleController, 
                                ),
                              ],
                            ),
                          ),
                          (){
                              // Thực hiện cập nhật ở đây
                          }
                        ); 
                      }, 
                      icon: Icon(Icons.edit)
                    ),
                    IconButton(
                      onPressed: (){
                        _showDialog(context, 'Attribute Category',
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Are you sure delete option Red')
                            ],
                          ),
                          (){}
                        ); 
                      },  
                      icon: Icon(Icons.delete, color: Colors.red,)
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(5)
                ),
                onPressed: (){}, 
                child: Text('Cancel')
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(5)
                ),
                onPressed: (){}, 
                child: Text('Update')
              ),
            ],
          ),
        )
      ],
    );
  }
  
}