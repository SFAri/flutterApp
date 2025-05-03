import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/productDetail/product_detail.dart';
import 'package:ecommerce/features/admin/screens/userManagement/widgets/paginated_table.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement>{
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

  List<Map<String, dynamic>> products = [
    {
      'productId': '1',
      'productCode': 'LAP627',
      'productName': 'Laptop Lenovo ThinkPad',
      'categoryName': 'Laptop',
      'brandName': 'Lenovo',
      'variants': ['16GB RAM', '512GB SSD'],
      // 'imagePath': CImages.laptopIcon,
      'instock': 100,
      'discount': 0,
      'retailPrice': 20000000,
      'salePrice': 18000000,
    },
    {
      'productId': '2',
      'productCode': 'DESK123',
      'productName': 'Máy Tính Để Bàn HP',
      'categoryName': 'Desktop',
      'brandName': 'HP',
      'variants': ['Intel i5', '16GB RAM', '1TB HDD'],
      // 'imagePath': CImages.macImage,
      'instock': 50,
      'discount': 0,
      'retailPrice': 15000000,
      'salePrice': 14000000,
    },
    {
      'productId': '3',
      'productCode': 'HDP789',
      'productName': 'Hard Drive Seagate 1TB',
      'categoryName': 'Storage',
      'brandName': 'Seagate',
      'variants': ['USB 3.0', 'USB-C'],
      // 'imagePath':  CImages.macImage,
      'instock': 200,
      'discount': 0,
      'retailPrice': 1500000,
      'salePrice': 1200000,
    },
    {
      'productId': '4',
      'productCode': 'MOU321',
      'productName': 'Wireless Mouse Logitech',
      'categoryName': 'Accessories',
      'brandName': 'Logitech',
      'variants': ['Black', 'White'],
      // 'imagePath':  CImages.macImage,
      'instock': 150,
      'discount': 0,
      'retailPrice': 500000,
      'salePrice': 450000,
    },
    {
      'productId': '5',
      'productCode': 'KEY456',
      'productName': 'Bàn Phím Cơ Corsair',
      'categoryName': 'Accessories',
      'brandName': 'Corsair',
      'variants': ['Red Switch', 'Blue Switch'],
      // 'imagePath':  CImages.macImage,
      'instock': 80,
      'discount': 0,
      'retailPrice': 1200000,
      'salePrice': 1100000,
    },
  ];

  // Show modal add and edit category:
  Future<void> _showDialog(BuildContext context, String title, Widget widgets, Function acceptFunction ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DialogForm(title: '', widgets: widgets, acceptFunction: acceptFunction,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        // Header:
        Header(title: 'Product Management',),
        Divider(),

        // Filter Row:
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            // 1. searchbar:
            SizedBox(
              height: 50,
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide()
                  )
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: IconButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                icon: Icon(Icons.search),
              ),
            ),
            // 2. button desc/asc
            SizedBox(
              height: 50,
              width: 100,
              child: TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sort),
                    Text('Desc'),
                  ],
                )
              ),
            ),

            // Choose category:
            DropdownButton(
              value: 'All Category',
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.symmetric(horizontal: 8),
              items: [
                DropdownMenuItem<String>(value: 'All Category',child: Text('All Category'),),
                DropdownMenuItem<String>(value: 'Laptop',child: Text('Laptop'),),
                DropdownMenuItem<String>(value: 'PC',child: Text('PC'),),
                // Thêm 1 số danh mục nữa
              ], 
              onChanged: (value) {
                
              },
            ),

            // Choose brand:
            DropdownButton(
              value: 'All Brand',
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.symmetric(horizontal: 8),
              items: [
                DropdownMenuItem<String>(value: 'All Brand',child: Text('All Brand'),),
                DropdownMenuItem<String>(value: 'Apple',child: Text('Apple'),),
                DropdownMenuItem<String>(value: 'Lenovo',child: Text('Lenovo'),),
                DropdownMenuItem<String>(value: 'Huawei',child: Text('Huawei'),),
                DropdownMenuItem<String>(value: 'HP',child: Text('HP'),),
                // Thêm 1 số danh mục nữa
              ], 
              onChanged: (value) {
                
              },
            ),
          ],
        ),

        // Table of category:
        Divider(),
        Align(
          alignment: Alignment.centerRight, 
          child: IconButton(style: IconButton.styleFrom() ,
          onPressed: () => _showDialog(context, 'Create Category',
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CTextFormField(label: 'Category Name', hintText: 'Enter new category name', controller: _categoryNameController),
              ],
            ),
            (){}
          ), 
          icon: Icon(Icons.add)
        )),
        Center(child: Text('List category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
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
                                String newCateName = _editController.text;
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

        // Table of brand:
        Divider(),
        Align(
          alignment: Alignment.centerRight, 
          child: IconButton(style: IconButton.styleFrom() ,
          onPressed: () => _showDialog(context, 'Create brand',
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CTextFormField(label: 'Brand Name', hintText: 'Enter new brand name', controller: _brandNameController),
              ],
            ),
            (){}
          ), 
          icon: Icon(Icons.add)
        )),
        Center(child: Text('List brands', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
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
                                String newBrandName = _editController.text;
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

        // Table of products:
        Divider(),
        PaginatedTable(
          lists: products,
          removeFunction: (){},
          viewFunction: (item) {
            streamController.add(ProductDetailScreen(item));
          },
          header: 'List products',
          columns: [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Product Code')),
            DataColumn(label: Text('Product Name')),
            DataColumn(label: Text('Category Name')),
            DataColumn(label: Text('Variants')),
            DataColumn(label: Text('Instock')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('Retail Price')),
            DataColumn(label: Text('Sale Price')),
            DataColumn(label: Text('Action')),
          ],
        )
      ],
    );
  }
  
}