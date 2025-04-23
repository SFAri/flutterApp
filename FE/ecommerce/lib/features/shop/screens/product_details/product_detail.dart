
import 'package:ecommerce/common/widgets/layout/custom_clippath_appbar.dart';
import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/common/widgets/texts/section_heading.dart';
import 'package:ecommerce/features/auth/login_page.dart';
import 'package:ecommerce/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/comment_piece.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/detail_appbar.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/filter_button.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/rating_progress.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/review_piece.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/variant_image.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<StatefulWidget> createState() => ProductDetailState();
  
}

class ProductDetailState extends State<ProductDetail> {
  late int _currentIndex;
  late PageController _pageController;
  int colorChoice = -1;
  int configChoice = -1;
  final List<String> images = [
    'https://worklap.vn/image/laptop-tam-gia-15-trieu-dang-mua-ollvczd.jpg',
    'https://bizweb.dktcdn.net/100/446/400/products/laptop-dell-latitude-7420-1-gia-loc.jpg?v=1686626945173',
    'https://cdnv2.tgdd.vn/mwg-static/tgdd/Products/Images/44/313333/lenovo-ideapad-slim-3-15iah8-i5-83er00evn-thumb-638754848306439358-600x600.jpg',
    'https://bizweb.dktcdn.net/thumb/large/100/362/971/products/screenshot-2024-08-08-182121.png?v=1723122912060',
  ];

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Giải phóng PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Product Details', style: TextStyle(fontSize: 18)),
      //   title: CClipPathAppBar(
      //     listWidgets: [
      //       SizedBox(height: 2),
      //       CHomeAppBar(),
      //     ],
      //   ),
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue
              ),
              child: CDetailAppBar(isBack: true)
            ),
            // Product Image:
            SizedBox(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index; // Cập nhật chỉ số hiện tại
                  });
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final isSelected = _currentIndex == index; // Kiểm tra hình được chọn
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index; // Cập nhật hình ảnh chính
                      });
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300), // Thời gian chuyển đổi
                        curve: Curves.easeInOut, // Hiệu ứng chuyển đổi
                      ); 
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                          ? Border.all(color: Colors.red, width: 2) // Viền đỏ cho hình được chọn
                          : Border.all(color: Colors.grey, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            images[index],
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            // Product details:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.star_rate_rounded, color: Colors.amber,),
                    Text('5.0'),
                    Text('(2004)'),
                  ],
                ),
                TextButton(
                  onPressed: (){}, 
                  child: Icon(Icons.share, color: Colors.blue,)
                )
                
              ]
            ),
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Laptop Lenovo Ideapad 3', 
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: CSizes.lg,
                    fontWeight: FontWeight.bold
                  )
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade100,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_add_rounded),
                      Text('Lenovo'),
                    ],
                  ),
                ),
              ]
            ),
            Row(
              spacing: 10,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      '21.450.000 VND',
                      style: TextStyle(
                        fontSize: CSizes.fontSizeLg,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 5), // Khoảng cách giữa các giá
                    Text(
                      '20.000.000 VND',
                      style: TextStyle(
                        fontSize: CSizes.fontSizeLg,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                CRoundedContainer(
                  radius: CSizes.sm,
                  backgroundColor:
                      CColors.secondary.withValues(alpha: 0.8),
                  padding: EdgeInsets.symmetric(
                      horizontal: CSizes.sm, vertical: CSizes.xs),
                  child: Text(
                    '10%',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .apply(color: CColors.dark),
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 1)
            ),

            // Variants:
            // 1.Color
            Text('Color', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
            Wrap(
              direction: Axis.horizontal,
              spacing: 15,
              children: <Widget>[
                VariantWithImage(
                  images: images[0], 
                  isSelected: colorChoice == 0, 
                  onSelect: () {
                    setState(() {
                      colorChoice = 0; // Cập nhật chỉ số khi chip được chọn
                    });
                  },
                ),
                VariantWithImage(
                  images: images[1], 
                  isSelected: colorChoice == 1,
                  title: 'Green',
                  price: '21.000.000 VNĐ',
                  onSelect: () {
                    setState(() {
                      colorChoice = 1; // Cập nhật chỉ số khi chip được chọn
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 10),
            // 2.Config
            Text('Config', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
            Wrap(
              direction: Axis.horizontal,
              spacing: 15,
              children: <Widget>[
                VariantWithImage(
                  isSelected: configChoice == 0, 
                  title: 'I5-13420H \n16GB - 512GB \nRTX 4050',
                  price: '20.000.000 VNĐ',
                  onSelect: () {
                    setState(() {
                      configChoice = 0; // Cập nhật chỉ số khi chip được chọn
                    });
                  },
                ),
                VariantWithImage(
                  isSelected: configChoice == 1,
                  title: 'i7-13620H \n16GB - 512GB \nRTX 4050',
                  price: '21.000.000 VNĐ',
                  onSelect: () {
                    setState(() {
                      configChoice = 1; // Cập nhật chỉ số khi chip được chọn
                    });
                  },
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 1)
            ),
            // Detail Information:
            Text('Description', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text(
                  'This is the description of the product provided by admin, it can include many information',
                  softWrap: true,
                  maxLines: 100000,
                  overflow: TextOverflow.visible,
                  ),
              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 1)
            ),
            // Reviews:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reviews (899)', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black
                  ),
                  onPressed: (){}, 
                  child: Icon(Icons.arrow_forward_ios, size: 14)
                )
              ],
            ),
            Text('Belows are the rate for this product'),
            // Rating illustration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('4.7', style: TextStyle(fontSize: 40)),
                        Text('/5', style: TextStyle(fontSize: 20), textAlign: TextAlign.end)
                      ],
                    ),
                    RatingBarIndicator(
                      itemCount: 5,
                      rating: 4.7,
                      itemSize: 20,
                      itemBuilder: (context, index) => Icon(Icons.star),
                    ),
                  ],
                ),
                Column(
                  spacing: 5,
                  children: [
                    WRatingProgress(label: '5', progress: 90),
                    WRatingProgress(label: '4', progress: 10),
                    WRatingProgress(label: '3', progress: 0),
                    WRatingProgress(label: '2', progress: 0),
                    WRatingProgress(label: '1', progress: 0),
                  ],
                )
              ]
            ),
            
            Padding(
              padding: const EdgeInsets.all(10),
              child: Divider(),
            ),

            // Filter:
            Text('Filter by:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              children: [
                WFilterButton(label: '5', icon: Icon(Icons.star)),
                WFilterButton(label: '4', icon: Icon(Icons.star)),
                WFilterButton(label: '3', icon: Icon(Icons.star)),
                WFilterButton(label: '2', icon: Icon(Icons.star)),
                WFilterButton(label: '1', icon: Icon(Icons.star)),
              ],
            ),
            SizedBox(height: 10),
            // List of reviews:
            Column(
              spacing: 10,
              children: [
                WReviewPiece(userName: 'Tran Van Thanh', time: '01/04/2025', review: 'This product brought me an amazing experience ever I have had! I love how it is work! Thanks the shop so much for this.', rating: 5),
                WReviewPiece(userName: 'Tran Van Thanh', time: '01/04/2025', review: 'This product brought me an amazing experience ever I have had! I love how it is work! Thanks the shop so much for this.', rating: 5),
                WReviewPiece(userName: 'Tran Van Thanh', time: '01/04/2025', review: 'This product brought me an amazing experience ever I have had! I love how it is work! Thanks the shop so much for this.', rating: 5),
                // Button to rate
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    // Here will pop a new page to rate that product or show an alert that user must login before rate.
                    onPressed: () => showDialogLogin(), 
                    child: Text('Click here to rate this product!')
                  ),
                )
              ],
            ),
            
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 1)
            ),
            // Comments:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Comments (200)', style: TextStyle(fontSize: CSizes.fontSizeLg, fontWeight: FontWeight.bold)),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black
                  ),
                  onPressed: (){}, 
                  child: Icon(Icons.arrow_forward_ios, size: 14)
                )
              ],
            ),
            SizedBox(height: 10),
            WCommentPiece(userName: 'Van A', time: '01/04/2025', comment: 'I wonder whether why I didnt know this product earlier!')
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),

                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey.shade300,
                    shape: CircleBorder(),
                    shadowColor: Colors.transparent,
                    side: BorderSide.none
                  ),
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 5),
                Text('2', style: TextStyle(fontSize: CSizes.fontSizeLg)),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey.shade300,
                    shape: CircleBorder(),
                    shadowColor: Colors.transparent,
                    side: BorderSide.none
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
              onPressed: (){}, 
              child: Text('Add to cart')
            )
          ],
        ),
      ),
    );
  }

  void showDialogLogin() {
    showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Rating alert'),
            content: const Text('You have to login before left rating. Go back to login page?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                  );
                } ,
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}