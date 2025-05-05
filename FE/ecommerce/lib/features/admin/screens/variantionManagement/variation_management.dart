import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';

class VariantScreen extends StatefulWidget {
  const VariantScreen({super.key});

  @override
  State<VariantScreen> createState() => _VariantScreenState();
}

class _VariantScreenState extends State<VariantScreen> {
  late TextEditingController _categoryNameController;
  late TextEditingController _brandNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryNameController = TextEditingController();
    _brandNameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _categoryNameController.dispose();
    _brandNameController.dispose();
  }
  List<Map<String, dynamic>> categories = [
    {
      'categoryId': '1',
      'categoryName': 'PC'
    },
    {
      'categoryId': '2',
      'categoryName': 'Laptop'
    },
    {
      'categoryId': '3',
      'categoryName': 'Accessory'
    },
    {
      'categoryId': '4',
      'categoryName': 'Hard drive'
    },
  ];

  List<Map<String, dynamic>> brands = [
    {
      'brandId': '1',
      'brandName': 'Apple'
    },
    {
      'brandId': '2',
      'brandName': 'Lenovo'
    },
    {
      'brandId': '3',
      'brandName': 'HP'
    },
    {
      'brandId': '4',
      'brandName': 'Huawei'
    },
  ];

  List<Map<String, dynamic>> attributes = [
    {
      'attributeId': '1',
      'attributeName': 'Color'
    },
    {
      'attributeId': '2',
      'attributeName': 'RAM'
    },
    {
      'attributeId': '3',
      'attributeName': 'Storage'
    },
  ];

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
      spacing: 20,
      children: [
        Header(title: 'Variant Management'),
        Divider(),

        // Category management:
        Row(
          spacing: 30,
          children: [
            Text('List Categories', style: TextStyle(fontSize: 20)),
            Expanded(child: Divider())
          ],
        ),
        Align(
          alignment: Alignment.centerRight, 
          child: TextButton(style: IconButton.styleFrom() ,
          onPressed: () => _showDialog(context, 'Create Category',
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CTextFormField(label: 'Category Name', hintText: 'Enter new category name', controller: _categoryNameController),
              ],
            ),
            (){}
          ), 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Icon(Icons.add),
              Text('Add Category')
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 300,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                // margin: EdgeInsets.all(5),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.all(5),
                  title: Text(categories[index]['categoryName']),
                  trailing: Row(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                          TextEditingController _editController = TextEditingController();
                          _editController.text = categories[index]['categoryName']!;

                          _showDialog(context, 'Edit Category',
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CTextFormField(
                                  label: 'Category Name', 
                                  hintText: 'Enter edit category name', 
                                  controller: _editController, 
                                ),
                              ],
                            ),
                            (){
                               // Lưu giá trị khi người dùng nhấn OK
                                // String newCateName = _editController.text;
                                // Thực hiện cập nhật ở đây
                            }
                          ); 
                        }, 
                        icon: Icon(Icons.edit)
                      ),
                      IconButton(
                        onPressed: (){
                          _showDialog(context, 'Delete Category',
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Are you sure delete ${categories[index]['categoryName']}')
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
        ),

        // Brand management
        Row(
          spacing: 30,
          children: [
            Text('List Brands', style: TextStyle(fontSize: 20)),
            Expanded(child: Divider())
          ],
        ),
        Align(
          alignment: Alignment.centerRight, 
          child: TextButton(style: IconButton.styleFrom() ,
          onPressed: () => _showDialog(context, 'Create brand',
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CTextFormField(label: 'Brand Name', hintText: 'Enter new brand name', controller: _brandNameController),
              ],
            ),
            (){}
          ), 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Icon(Icons.add),
              Text('Add Brand')
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 300,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return Card(
                // margin: EdgeInsets.all(5),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.all(5),
                  title: Text(brands[index]['brandName']),
                  trailing: Row(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                          TextEditingController _editController = TextEditingController();
                          _editController.text = brands[index]['brandName']!;

                          _showDialog(context, 'Edit brand',
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CTextFormField(
                                  label: 'Brand Name', 
                                  hintText: 'Enter edit brand name', 
                                  controller: _editController, 
                                ),
                              ],
                            ),
                            (){
                               // Lưu giá trị khi người dùng nhấn OK
                                // String newBrandName = _editController.text;
                                // Thực hiện cập nhật ở đây
                            }
                          ); 
                        },
                        icon: Icon(Icons.edit)
                      ),
                      IconButton(
                        onPressed: (){
                          _showDialog(context, 'Delete brand',
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Are you sure delete ${brands[index]['brandName']}')
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
        ),

        Row(
          spacing: 30,
          children: [
            Text('List Variants', style: TextStyle(fontSize: 20)),
            Expanded(child: Divider())
          ],
        ),
        Align(
          alignment: Alignment.centerRight, 
          child: TextButton(
            style: IconButton.styleFrom() ,
            onPressed: () {}, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Icon(Icons.add),
                Text('Add Variant')
              ],
            ),
          )
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: attributes.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.all(5),
                title: Text(attributes[index]['attributeId']),
                subtitle: Text(attributes[index]['attributeName']),
                trailing: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: (){
                        TextEditingController _editController = TextEditingController();
                        _editController.text = attributes[index]['attributeName']!;
                        _showDialog(context, 'Edit Attribute',
                          Column(
                            spacing: 3,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CTextFormField(
                                label: 'Attribute Name', 
                                hintText: 'Enter edit attribute name', 
                                controller: _editController, 
                              ),
                              Divider(),
        
                              // Button add option
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: (){}, 
                                  child: Row(
                                    spacing: 2,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add),
                                      Text('Add option')
                                    ],
                                  ) 
                                ),
                              ),
        
                              // Listview các option:
                              SizedBox(
                                height: 300.0, // Change as per your requirement
                                width: 300.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        contentPadding: EdgeInsets.all(5),
                                        title: Text(index.toString()),
                                        subtitle: Text('Red'),
                                        trailing: Row(
                                          spacing: 5,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: (){
                                                TextEditingController _editOptionController = TextEditingController();
                                                _editOptionController.text = 'Red';
                                                _showDialog(context, 'Edit Option',
                                                  Column(
                                                    spacing: 3,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CTextFormField(
                                                        label: 'Option', 
                                                        hintText: 'Enter attribute option', 
                                                        controller: _editOptionController, 
                                                      ),
                                                    ],
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
                                                _showDialog(context, 'Delete Attribute Option',
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
                              )
                            ],
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
                        _showDialog(context, 'Delete Attribute',
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Are you sure delete ${attributes[index]['attributeName']}')
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
          } 
        )
      ],
    );
  }
  
}