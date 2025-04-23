import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

    final List<String> brands = ['MAC', 'ASUS', 'Lenovo', 'Samsung', 'Dell', 'E-Dra', 'HP'];

    final List<String> categories = ['Best sellers', 'Popular products', 'New products', 'Laptop', 'PC', 'Accessory', 'Switch/hub', 'Software/OS'];
    List<Map<String, String>> products = [
      {
        "name": "Macbook air 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "27.000.000",
      },
      {
        "name": "Macbook pro 14", "brand": "Apple", "imageUrl": CImages.macImage, "price": "32.536.000", "salePrice": "11"
      },
      {
        "name": "Lenovo Ideapad 3", "brand": "Lenovo", "imageUrl": CImages.macImage, "price": "19.330.000",
      },
    ];

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
                listWidgets: [
                  SizedBox(height: 2),
                  CHomeAppBar(),
                  
                  // Tiêu chí lọc:
                  CSectorHeading(title: 'Tiêu chí lọc'),
                  // Lọc cho PC và laptop: brand, CPU, dung lượng RAM ,giá, rate
                  Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // padding: EdgeInsets.only(left: 14, right: 20),
                      child: Row(
                        spacing: 14,
                        children: [
                          // Category:
                          CFilterButton(title: 'Danh mục', onPressed: () => _showFilterModal('Danh mục', categories, selectedCategories)),
                    
                          // Brand:
                          CFilterButton(title: 'Hãng', onPressed: () => _showFilterModal('Hãng', brands, selectedBrands)),
                      
                          // Gía:
                          CFilterButton(title: 'Mức giá', onPressed: () => _showFilterMoney('Mức giá')),
                      
                          // Rate:
                          CFilterButton(title: 'Đánh giá', onPressed: () => _showFilterRate('Đánh giá'),),
                      
                          // CPU:
                          CFilterButton(title: 'CPU', onPressed: (){},),
                      
                          // RAM:
                          CFilterButton(title: 'RAM', onPressed: (){},),
                        ],
                      ),
                    ),
                  ),

                  // Lọc cho phụ kiện/linh kiện: giá, rate, brand

                  // Sắp xếp:
                  CSectorHeading(title: 'Sắp xếp'),
                  Container(
                    padding: EdgeInsets.only(left: 14, right: 14),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        spacing: 14,
                        children: [
                          // Gía cao - thấp:
                          CSortButton(title: 'Giá cao - thấp', icon: Icon(Icons.filter_list), onPressed: (){},),
                      
                          // Gía thấp - cao:
                          CSortButton(title: 'Giá thấp - cao', icon: Icon(Icons.filter_list), onPressed: (){}),
                    
                          // Khuyến mãi hot:
                          CSortButton(title: 'Khuyến mãi hot', icon: Icon(Icons.discount), onPressed: (){}),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              CGridView(items: products),
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
