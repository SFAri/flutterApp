// import 'package:ecommerce/features/admin/main.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/productManagement/productDetail/product_detail.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement>{

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
      'productName': 'Laptop Lenovo ThinkPad',
      'categoryName': 'Laptop',
      'brandName': 'Lenovo',
      'variants': ['16GB RAM', '512GB SSD'],
      'imagePath':[CImages.macImage],
    },
    {
      'productId': '2',
      'productName': 'Máy Tính Để Bàn HP',
      'categoryName': 'Desktop',
      'brandName': 'HP',
      'variants': ['Intel i5', '16GB RAM', '1TB HDD'],
      'imagePath':[CImages.macImage],
    },
    {
      'productId': '3',
      'productName': 'Hard Drive Seagate 1TB',
      'categoryName': 'Storage',
      'brandName': 'Seagate',
      'variants': ['USB 3.0', 'USB-C'],
      'imagePath':[CImages.macImage],
    },
    {
      'productId': '4',
      'productName': 'Wireless Mouse Logitech',
      'categoryName': 'Accessories',
      'brandName': 'Logitech',
      'variants': ['Black', 'White'],
      'imagePath':[CImages.macImage],
    },
    {
      'productId': '5',
      'productName': 'Bàn Phím Cơ Corsair',
      'categoryName': 'Accessories',
      'brandName': 'Corsair',
      'variants': ['Red Switch', 'Blue Switch'],
      'imagePath':[CImages.macImage],
    },
  ];

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

            TextButton(
              onPressed: (){
                streamController.add(ProductDetailScreen());
              }, 
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.create_new_folder_rounded),
                  Text('Create new Product')
                ],
              )
            )
          ],
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: products.length,
          // separatorBuilder: separatorBuilder, 
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  streamController.add(ProductDetailScreen(item: products[index]));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(products[index]['imagePath'][0])
                ),
                contentPadding: EdgeInsets.all(5),
                title: Text(products[index]['productName']),
                subtitle: Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(products[index]['brandName']),
                    Text(products[index]['categoryName']),
                    Text('Variants: ${products[index]['productName']}'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: (){}, 
                  icon: Icon(Icons.delete, color: Colors.red,)
                ),
              ),
            );
          }, 
        ),
      ],
    );
  }
  
}