import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ecommerce/features/auth/controllers/product_controller.dart';

class CategoryHomeScreen extends StatefulWidget {

  const CategoryHomeScreen({super.key});

  @override
  State<CategoryHomeScreen> createState() => _CategoryHomeScreenState();
}

class _CategoryHomeScreenState extends State<CategoryHomeScreen> {
    late List<String> selectedBrands;
    late List<String> selectedCategories;
    late RangeValues selectedRange;
    late double rating;

    late final ProductController productController = ProductController();

    final List<String> brands = ['MAC', 'ASUS', 'Lenovo', 'Samsung', 'Dell', 'E-Dra', 'HP'];

    final List<String> categories = ['Best sellers', 'Popular products', 'New products', 'Laptop', 'PC', 'Accessory', 'Switch/hub', 'Software/OS'];
    late Future<Map<String, dynamic>> products = productController.getProducts();
    // List<Map<String, String>> products = [
    //   {
    //     "name": "Macbook air 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "27000000",
    //   },
    //   {
    //     "name": "Macbook pro 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "32536000", "salePrice": "11"
    //   },
    //   {
    //     "name": "Lenovo Ideapad 3", "brand": "Lenovo", "imageUrl": CImages.macImage, "price": "19330000",
    //   },
    // ];


    @override
  void initState() {
    selectedBrands = [];
    selectedCategories =[];
    selectedRange = RangeValues(1000000, 99000000);
    rating = 0;
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CClipPathAppBar(
                // ... your CClipPathAppBar listWidgets
                listWidgets: [
                  SizedBox(height: 2),
                  CHomeAppBar(),
                  CSectorHeading(title: 'Tiêu chí lọc'),
                  Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // Use Wrap for children with spacing to avoid manual spacing widgets if preferred
                        // spacing: 14, // if using Row's spacing
                        children: [
                          CFilterButton(title: 'Danh mục', onPressed: () => _showFilterModal('Danh mục', categories, selectedCategories)),
                          SizedBox(width: 14), // Manual spacing if not using Row's spacing
                          CFilterButton(title: 'Hãng', onPressed: () => _showFilterModal('Hãng', brands, selectedBrands)),
                          SizedBox(width: 14),
                          CFilterButton(title: 'Mức giá', onPressed: () => _showFilterMoney('Mức giá')),
                          SizedBox(width: 14),
                          CFilterButton(title: 'Đánh giá', onPressed: () => _showFilterRate('Đánh giá')),
                          SizedBox(width: 14),
                          CFilterButton(title: 'CPU', onPressed: () {}),
                          SizedBox(width: 14),
                          CFilterButton(title: 'RAM', onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                  CSectorHeading(title: 'Sắp xếp'),
                  Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CSortButton(title: 'Giá cao - thấp', icon: Icon(Icons.filter_list), onPressed: () {}),
                          SizedBox(width: 14),
                          CSortButton(title: 'Giá thấp - cao', icon: Icon(Icons.filter_list), onPressed: () {}),
                          SizedBox(width: 14),
                          CSortButton(title: 'Khuyến mãi hot', icon: Icon(Icons.discount), onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<Map<String, dynamic>>(
                future: products, // Your future
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){ // Builder starts
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, show a loading indicator
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // If the Future completed with an error, show an error message
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // If the Future completed successfully and has data
                    Map<String, dynamic>? singleProductData = snapshot.data; // snapshot.data is your single product Map

                    if (singleProductData == null || singleProductData.isEmpty) {
                      return Center(child: Text('No product found.'));
                    }

                    List<Map<String, String>> productListForGrid = [];

                    // Since 'singleProductData' is the product itself, we directly convert it
                    // and add it to our list.
                    Map<String, String> productForGrid = {};
                    productForGrid['name'] = singleProductData['name']?.toString() ?? 'N/A';
                    productForGrid['brand'] = singleProductData['brand']?.toString() ?? 'N/A';
                    productForGrid['price'] = singleProductData['price']?.toString() ?? '0';

                    // You need to decide which image to show if there are multiple.
                    // Here, we're taking the first one if available.
                    if (singleProductData['images'] is List && (singleProductData['images'] as List).isNotEmpty) {
                      productForGrid['imageUrl'] = (singleProductData['images'] as List).first.toString();
                    } else {
                      productForGrid['imageUrl'] = CImages.macImage; // Fallback image
                    }

                    // Add other fields your CGridView might need, converting them to String
                    // For example, if CGridView expects 'description':
                    // productForGrid['description'] = singleProductData['description']?.toString() ?? '';
                    productListForGrid.add(productForGrid);
                    return CGridView(items: productListForGrid);
                  } else {
                    // Fallback for other ConnectionStates (like .none or .active without data yet)
                    // Or if you want a specific UI when hasData is false but no error and not waiting.
                    return Center(child: Text("Loading products...")); // Or some placeholder
                  }
                }, // Closing brace for builder, ADD COMMA
              ), // CLOSING PARENTHESIS FOR FutureBuilder, ADD COMMA IF NEEDED
            ],
          ),
        ),
      );
    }

    void _showFilterModal(String title, List<String> items, List<String> selected) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext innerContext, StateSetter innerSetState) {
              List selectedItems = selected;
              return Container(
                padding: EdgeInsets.all(16.0),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(items[index]),
                            value: selected.contains(items[index]),
                            onChanged: (bool? value) {
                              innerSetState(() {
                                  // Kiểm tra nếu item chưa có trong currentSelection
                                  if (!selectedItems.contains(items[index])) {
                                    selectedItems.add(items[index]); // Thêm vào danh sách nếu được chọn
                                    print('${items[index]} added to current selection');
                                    print('Current Selection: ${selectedItems.toString()}');
                                  }
                                  else {
                                    selectedItems.remove(items[index]); // Bỏ nếu không được chọn
                                    print('${items[index]} removed from current selection');
                                    print('Current Selection: ${selectedItems.toString()}');
                                  }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("Áp dụng"),
                            onPressed: () {
                              setState(() {
                                selected = List.from(selectedItems);
                              });
                              Navigator.pop(context); // Đóng modal
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      );
    }

    void _showFilterMoney(String title) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          RangeValues innerValues = selectedRange;

          return StatefulBuilder(
            builder: (BuildContext innerContext, StateSetter innerSetState) {

              return Container(
                padding: EdgeInsets.all(16.0),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: RangeSlider(
                        values: innerValues, // Use the observable value
                        min: 0,
                        max: 100000000,
                        divisions: 100,
                        labels: RangeLabels('${innerValues.start}', '${innerValues.end}'),
                        onChanged: (RangeValues values) {
                          print('===== fi $innerValues');
                          print('===== $innerValues');
                          print('$values');
                          innerSetState(() {
                            innerValues = values; // Cập nhật giá trị khoảng giá
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${innerValues.start}'),
                        Text('${innerValues.end}'),
                      ]
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("Áp dụng"),
                            onPressed: () {
                              print('===== butotn: $innerValues');
                              setState(() {
                                selectedRange = innerValues;
                              });
                              Navigator.pop(context); // Đóng modal
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      );
    }

    void _showFilterRate(String title) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext innerContext, StateSetter innerSetState) {
              return Container(
                padding: EdgeInsets.all(16.0),
                width: CDeviceUtils.getScreenWidth(context),
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Expanded(
                        child: RatingBar.builder(
                          itemCount: 5,
                          initialRating: rating,
                          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (value){
                            setState(() {
                              rating = value;
                              Navigator.pop(context);
                            });
                          }
                        )
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      );
    }
}



class CSortButton extends StatelessWidget {
  const CSortButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed
  });

  final String title;
  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.all(10)
      ),
      child: Row(
        children: [
          icon,
          Text(title),
        ],
      )
    );
  }
}

class CFilterButton extends StatelessWidget {
  const CFilterButton({
    super.key,
    required this.title,
    required this.onPressed
  });

  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.all(10)
      ),
      child: Row(
        children: [
          Text(title),
          Icon(Icons.keyboard_arrow_down),
        ],
      )
    );
  }
}
