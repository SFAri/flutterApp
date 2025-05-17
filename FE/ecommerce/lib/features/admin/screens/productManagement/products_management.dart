import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
import 'package:ecommerce/features/admin/screens/productManagement/productDetail/product_detail.dart';
import 'package:ecommerce/features/auth/controllers/product_controller.dart';
import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';
import '../../../../utils/data/categories_data.dart';
import '../../../../utils/data/brands_data.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement>{
  List<dynamic> products = [];
  final productController = ProductController();
  String selectedCategory = 'All Category';
  String selectedBrand = 'All Brand';
  String searchQuery = '';
  bool isDesc = true;

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  // Fetch data:
  Future<void> fetchProducts() async {
    try {
      final response = await productController.getProducts();
      // print("rES: " + response.toString());
      // Check if response is a Map and contains 'data'
      if (response['status'] == 'success') {
        setState(() {
          products = response['data'];
        });
        print("Products: " + products.join(','));
      } else {
        print('error');
      }
      
    } catch (e) {
      print('Error: $e'); // Handle errors here
    }
  }

  // Filter product:
  List<dynamic> getFilteredProducts() {
  return products.where((product) {
    final matchesCategory = selectedCategory == 'All Category' ||
                            product['category'] == selectedCategory;
    final matchesBrand = selectedBrand == 'All Brand' || 
                         product['brand'] == selectedBrand;
    final matchesSearch = product['name'].toLowerCase().contains(searchQuery.toLowerCase());

    return matchesCategory && matchesBrand && matchesSearch;
  }).toList();
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
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
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
            // SizedBox(
            //   height: 50,
            //   width: 100,
            //   child: TextButton(
            //     onPressed: (){
            //       setState(() {
            //         isDesc = !isDesc;
            //       });
            //     },
            //     style: TextButton.styleFrom(
            //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         isDesc ? Icon(Icons.arrow_downward_sharp) : Icon(Icons.arrow_upward_sharp),
            //         isDesc ? Text('Desc') : Text('Asc'),
            //       ],
            //     )
            //   ),
            // ),

            // Choose category:
            DropdownButton(
              value: selectedCategory,
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.symmetric(horizontal: 8),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(), 
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            // Choose brand:
            DropdownButton(
              value: selectedBrand,
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.symmetric(horizontal: 8),
              items: brands.map((String brand) {
                return DropdownMenuItem<String>(
                  value: brand,
                  child: Text(brand),
                );
              }).toList(), 
              onChanged: (value) {
                setState(() {
                  selectedBrand = value!;
                });
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
          itemCount: getFilteredProducts().length,
          itemBuilder: (context, index) {
            final filteredProducts = getFilteredProducts();
            return Card(
              child: ListTile(
                onTap: () {
                  streamController.add(ProductDetailScreen(item: filteredProducts[index]));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  // child: Image.asset(products[index]['images'][0])
                  child: Image.network(filteredProducts[index]['images'][0]),
                ),
                contentPadding: EdgeInsets.all(5),
                title: Text(filteredProducts[index]['name']),
                subtitle: Column(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(filteredProducts[index]['brand']),
                    Text(filteredProducts[index]['category']),
                    Text('Variants: ${filteredProducts[index]['variants'][0]['variantId']}'),
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