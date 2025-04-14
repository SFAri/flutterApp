import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/layout/custom_gridview.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class CategoryHomeScreen extends StatefulWidget {

  const CategoryHomeScreen({super.key});

  @override
  State<CategoryHomeScreen> createState() => _CategoryHomeScreenState();
}

class _CategoryHomeScreenState extends State<CategoryHomeScreen> {
    List<String> selectedBrands = [];
    List<String> selectedCategories = [];
    RangeValues selectedRange = RangeValues(1000, 99000000);

    final List<String> brands = ['Brand A', 'Brand B', 'Brand C'];

    final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
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
    Widget build(BuildContext context) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CClipPathAppBar(
                height: 330,
                listWidgets: [
                  SizedBox(height: 2),
                  CHomeAppBar(),
                  
                  // Tiêu chí lọc:
                  CSectorHeading(title: 'Tiêu chí lọc'),
                  // Lọc cho PC và laptop: brand, CPU, dung lượng RAM ,giá, rate
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      spacing: 14,
                      children: [
                        // Category:
                        CFilterButton(title: 'Danh mục', onPressed: () => _showFilterModal(context, 'Danh mục', categories)),

                        // Brand:
                        CFilterButton(title: 'Hãng', onPressed: (){}),
                    
                        // Gía:
                        CFilterButton(title: 'Mức giá', onPressed: (){},),
                    
                        // Rate:
                        CFilterButton(title: 'Đánh giá', onPressed: (){},),
                    
                        // CPU:
                        CFilterButton(title: 'CPU', onPressed: (){},),
                    
                        // RAM:
                        CFilterButton(title: 'RAM', onPressed: (){},),
                      ],
                    ),
                  ),

                  // Lọc cho phụ kiện/linh kiện: giá, rate, brand

                  // Sắp xếp:
                  CSectorHeading(title: 'Sắp xếp'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 20, right: 20),
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
                ],
              ),
              CGridView(items: products),
            ],
          ),
        ),
      );
    }

    void _showFilterModal(BuildContext context, String title, List items) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<String> currentSelection = []; // Danh sách lưu trữ lựa chọn hiện tại

          // Tùy chọn cho từng tiêu đề
          switch (title) {
            case 'Hãng':
              currentSelection = List.from(selectedBrands);
              break;
            case 'Danh mục':
              currentSelection = List.from(selectedCategories);
              break;
            default:
          }

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
                        value: currentSelection.contains(items[index]),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              currentSelection.add(items[index]); // Thêm vào danh sách nếu được chọn
                            } else {
                              currentSelection.remove(items[index]); // Bỏ nếu không được chọn
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text("Xác nhận"),
                  onPressed: () {
                    setState(() {
                      selectedBrands = List.from(currentSelection); // Cập nhật danh sách đã chọn
                    });
                    Navigator.pop(context); // Đóng modal
                  },
                ),
              ],
            ),
          );
        },
      );
    }

  // void _showFilterBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) {
  //       return StatefulBuilder(
  //       builder: (BuildContext innerContext, StateSetter innerSetState) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height * 0.7,
  //           width: CDeviceUtils.getScreenWidth(context),
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             spacing: 10,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Bộ lọc sản phẩm',
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //               ),
  //               // Lọc brand
  //               Text('Thương hiệu', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
  //               GestureDetector(
  //                 onTap: (){
  //                   print('Tap!');
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(12),
  //                     border: Border.all(
                        
  //                     )
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Icon(Icons.search),
  //                       Text('Tìm kiếm thương hiệu')
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               // Lọc category
  //               Text('Danh mục', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
  //               GestureDetector(
  //                 onTap: (){
  //                   print('Tap!');
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.all(10),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(12),
  //                     border: Border.all(
                        
  //                     )
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Icon(Icons.search),
  //                       Text('Tìm kiếm danh mục')
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               // Lọc giá tiền
  //               Text(
  //                 'Khoảng giá',
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               RangeSlider(
  //                   values: selectedRange, // Use the observable value
  //                   min: 0,
  //                   max: 100000000,
  //                   divisions: 100,
  //                   labels: RangeLabels('${selectedRange.start}', '${selectedRange.end}'),
  //                   onChanged: (RangeValues values) {
  //                     innerSetState(() {
  //                       selectedRange = values; // Cập nhật giá trị khoảng giá
  //                     });
  //                   },
  //                 ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(selectedRange.start.toStringAsFixed(0)),
  //                   Text(selectedRange.end.toStringAsFixed(0)),
  //                 ],
  //               ),
  //               // Lọc rate
  //               // Nút áp dụng filter
  //               Expanded(
  //                 child: Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Container(
  //                     margin: EdgeInsets.all(5),
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         // Xử lý khi nhấn nút áp dụng
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text('Áp dụng'),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
        
  //         );
  //       });
  //   });
  // }
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
      onPressed: () => onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.all(10)
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list),
          Text('Giá cao - thấp'),
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
      onPressed: () => onPressed, 
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
