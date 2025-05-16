import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  // const ProductDetailScreen(Map<String, dynamic> item, {super.key});
  final Map<String, dynamic>? item; // optional

  const ProductDetailScreen({super.key, this.item});

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

  late TextEditingController _variantIdController;
  late TextEditingController _importPriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _colorController;

  late TextEditingController _processorController;
  late TextEditingController _gpuController;
  late TextEditingController _ramController;
  late TextEditingController _storageController;
  late TextEditingController _screenSizeController;
  late TextEditingController _refreshRateController;
  late TextEditingController _resolutionController;
  late TextEditingController _inventoryController;

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

  List<String> imagePath = [
    CImages.macImage,
    CImages.blackFridayLaptop,
  ];

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _brandController = TextEditingController();
    _categoryController = TextEditingController();
    _discountController = TextEditingController();

    _variantIdController = TextEditingController();
    _importPriceController = TextEditingController();
    _salePriceController = TextEditingController();
    _colorController = TextEditingController();

    _processorController = TextEditingController();
    _gpuController = TextEditingController();
    _ramController = TextEditingController();
    _storageController = TextEditingController();
    _screenSizeController = TextEditingController();
    _refreshRateController = TextEditingController();
    _resolutionController = TextEditingController();
    _inventoryController = TextEditingController();
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

    _variantIdController.dispose();
    _importPriceController.dispose();
    _salePriceController.dispose();
    _colorController.dispose();

    _processorController.dispose();
    _gpuController.dispose();
    _ramController.dispose();
    _storageController.dispose();
    _screenSizeController.dispose();
    _refreshRateController.dispose();
    _resolutionController.dispose();
    _inventoryController.dispose();
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
                              children: [
                                CTextFormField(
                                  label: 'Variant Id', 
                                  hintText: 'Enter Variant Id', 
                                  controller: _variantIdController, 
                                ),
                                CTextFormField(
                                  label: 'Import price', 
                                  hintText: 'Enter import price', 
                                  controller: _importPriceController, 
                                ),
                                CTextFormField(
                                  label: 'Sale price', 
                                  hintText: 'Enter sale price', 
                                  controller: _salePriceController, 
                                ),
                                CTextFormField(
                                  label: 'Color', 
                                  hintText: 'Choose color', 
                                  controller: _colorController, 
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text('Spec information'),
                                    Expanded(child: Divider()),
                                  ],
                                ),
                                CTextFormField(
                                  label: 'Processor', 
                                  hintText: 'Enter Processor', 
                                  controller: _processorController, 
                                ),
                                CTextFormField(
                                  label: 'GPU', 
                                  hintText: 'Enter GPU', 
                                  controller: _gpuController, 
                                ),
                                CTextFormField(
                                  label: 'RAM', 
                                  hintText: 'Enter RAM', 
                                  controller: _ramController, 
                                ),
                                CTextFormField(
                                  label: 'Storage', 
                                  hintText: 'Enter Storage', 
                                  controller: _storageController, 
                                ),
                                CTextFormField(
                                  label: 'Screen Size', 
                                  hintText: 'Enter Screen Size', 
                                  controller: _screenSizeController, 
                                ),
                                CTextFormField(
                                  label: 'Refresh Rate', 
                                  hintText: 'Enter Refresh Rate', 
                                  controller: _refreshRateController, 
                                ),
                                CTextFormField(
                                  label: 'Resolution', 
                                  hintText: 'Enter Resolution', 
                                  controller: _resolutionController, 
                                ),
                                CTextFormField(
                                  keyboardType: TextInputType.number,
                                  label: 'Inventory', 
                                  hintText: 'Enter Inventory number', 
                                  controller: _inventoryController, 
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