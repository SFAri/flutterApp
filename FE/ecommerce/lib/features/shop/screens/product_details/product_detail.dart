import 'package:ecommerce/common/widgets/products/product_card.dart';
import 'package:ecommerce/features/auth/controllers/product_controller.dart';
import 'package:ecommerce/features/auth/login_page.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Cart.dart'; // Assuming CartModel is here or accessible
import 'package:ecommerce/features/shop/screens/cart/models/Product.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Specs.dart';
import 'package:ecommerce/features/shop/screens/cart/models/Variant.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/comment_piece.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/detail_appbar.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/filter_button.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/rating_progress.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/review_piece.dart';
import 'package:ecommerce/features/shop/screens/product_details/widgets/variant_image.dart';
import 'package:ecommerce/utils/constants/colors.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/formatters/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final String id;
  const ProductDetail({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  late int _currentIndex;
  late PageController _pageController;
  int configChoice = 0;
  bool isLoading = true;
  dynamic productData;
  final productController = ProductController();
  int _quantity = 1;
  String moreInfo = '';

  Future<void> fetchProduct() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await productController.getProductDetail(widget.id);
      if (response['status'] == 'success') {
        setState(() {
          // products = List.from(response['data']).take(4).toList();
          productData = response['data'];
          final variant = productData["variants"][configChoice];
          switch (productData["category"]) {
            case "Laptop":
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \nProcessor: ${variant["specs"]["processor"]} \nRAM: ${variant["specs"]["ram"]} \nStorage: ${variant["specs"]["storage"]} \nScreenSize: ${variant["specs"]["screenSize"]} \nRefreshRate: ${variant["specs"]["refreshRate"]} \nResolution: ${variant["specs"]["resolution"]} \nInventory: ${variant["inventory"]}';
              break;
            case "GPU":
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \n${variant["specs"]["gpu"]} \n${variant["specs"]["interface"]}';
              break;
            case "SSD":
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \n${variant["specs"]["storage"]} \n${variant["specs"]["interface"]} \n${variant["specs"]["formFactor"]}';
              break;
            case "RAM":
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \n${variant["specs"]["ram"]} \n${variant["specs"]["interface"]} \n${variant["specs"]["formFactor"]}';
              break;
            case "Motherboard":
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \n${variant["specs"]["socket"]} \n${variant["specs"]["chipset"]} \n${variant["specs"]["interface"]} \n${variant["specs"]["formFactor"]}';
              break;
            case "CPU":
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \n${variant["specs"]["processor"]} \n${variant["specs"]["socket"]} \n${variant["specs"]["chipset"]} \n${variant["specs"]["interface"]}';
              break;
            default:
              moreInfo =
                  'SKU: ${variant["variantId"]} \nColor: ${variant["color"]} \nInventory: ${variant["inventory"]}'; // Giá trị mặc định nếu không khớp
          }
        });
        print("pRODUCTS =======: $productData");
      } else {
        print('error');
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController();
    fetchProduct();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Giải phóng PageController
    super.dispose();
  }

  void _incrementQuantity() {
    if (productData != null &&
        productData["variants"] != null &&
        configChoice < productData["variants"].length) {
      final selectedVariantData = productData["variants"][configChoice];
      final inventory =
          int.tryParse(selectedVariantData["inventory"].toString()) ?? 0;

      if (_quantity < inventory) {
        setState(() {
          _quantity++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Cannot add more. Stock limit reached for this variant.',
            ),
          ),
        );
      }
    } else {
      print("Product data or variant not available to check inventory.");
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    if (productData == null) return;

    final selectedVariantData = productData["variants"][configChoice];

    // Create Specs object
    final specsData = selectedVariantData["specs"];
    final specs = Specs(
      processor: specsData['processor'],
      gpu: specsData['gpu'],
      ram: specsData['ram'],
      storage: specsData['storage'],
      motherboard: specsData['motherboard'],
      powerSupply: specsData['powerSupply'],
      socket: specsData['socket'],
      chipset: specsData['chipset'],
      interfaceType: specsData['interface'],
      formFactor: specsData['formFactor'],
      screenSize: specsData['screenSize'],
      refreshRate: specsData['refreshRate'],
      resolution: specsData['resolution'],
    );

    // Create Variant object
    final variant = Variant(
      variantId: selectedVariantData["variantId"].toString(),
      type: selectedVariantData["type"].toString(),
      specs: specs,
      color: selectedVariantData["color"].toString(),
      inventory: int.tryParse(selectedVariantData["inventory"].toString()) ?? 0,
      salePrice:
          double.tryParse(selectedVariantData["price"].toString()) ?? 0.0,
    );

    // Create Product object
    final productToAdd = Product(
      id: productData["_id"].toString(),
      name: productData["name"].toString(),
      brand: productData["brand"].toString(),
      category: productData["category"].toString(),
      image:
          productData["images"] != null && productData["images"].isNotEmpty
              ? productData["images"][0].toString()
              : '',
      variant: variant,
      discount:
          double.tryParse(productData["discount"]?.toString() ?? "0.0") ?? 0.0,
      quantity: _quantity,
    );

    Provider.of<CartModel>(context, listen: false).add(productToAdd);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${productData["name"]} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.blue),
                      child: CDetailAppBar(isBack: true),
                    ),
                    SizedBox(height: 10),
                    // Product Image:
                    SizedBox(
                      height: 280,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: productData["images"].length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index; // Cập nhật chỉ số hiện tại
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.network(
                                productData['images'][index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        itemCount: productData["images"].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final isSelected =
                              _currentIndex == index; // Kiểm tra hình được chọn
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentIndex =
                                    index; // Cập nhật hình ảnh chính
                              });
                              _pageController.animateToPage(
                                index,
                                duration: Duration(
                                  milliseconds: 300,
                                ), // Thời gian chuyển đổi
                                curve: Curves.easeInOut, // Hiệu ứng chuyển đổi
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      isSelected
                                          ? Border.all(
                                            color: Colors.red,
                                            width: 2,
                                          ) // Viền đỏ cho hình được chọn
                                          : Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    productData["images"][index],
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
                            Icon(Icons.star_rate_rounded, color: Colors.amber),
                            Text(
                              productData["ratings"].length == 0
                                  ? '5'
                                  : productData["averageRating"].toString(),
                            ),
                            Text('(${productData["ratings"].length})'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Icon(Icons.share, color: Colors.blue),
                        ),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          productData["name"],
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: CSizes.lg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bookmark_add_rounded),
                              Text(productData["brand"]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            if (productData["discount"] != 0)
                              Text(
                                CFormatter.formatMoney(
                                  productData["price"].toString(),
                                ),
                                style: TextStyle(
                                  fontSize: CSizes.fontSizeLg,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            SizedBox(width: 5), // Khoảng cách giữa các giá
                            Text(
                              CFormatter.formatMoney(
                                productData["discount"] != 0
                                    ? (productData["price"] -
                                            productData["price"] *
                                                productData["discount"])
                                        .toString()
                                    : productData["price"].toString(),
                              ),
                              style: TextStyle(
                                fontSize: CSizes.fontSizeLg,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        if (productData["discount"] != 0)
                          CRoundedContainer(
                            radius: CSizes.sm,
                            backgroundColor: CColors.secondary.withValues(
                              alpha: 0.8,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: CSizes.sm,
                              vertical: CSizes.xs,
                            ),
                            child: Text(
                              '${productData["discount"]}%',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .apply(color: CColors.dark),
                            ),
                          ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 1),
                    ),

                    SizedBox(height: 10),
                    // 2.Config
                    Text(
                      'Variant',
                      style: TextStyle(
                        fontSize: CSizes.fontSizeLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 15,
                      children: List.generate(productData["variants"].length, (
                        index,
                      ) {
                        final variant = productData["variants"][index];

                        String title;
                        switch (variant["type"]) {
                          case "Laptop":
                            title =
                                '${variant["color"]} \n${variant["specs"]["processor"]} \n${variant["specs"]["ram"]} \n${variant["specs"]["storage"]}';
                            break;
                          case "GPU":
                            title =
                                '${variant["specs"]["gpu"]} \n${variant["specs"]["interface"]}';
                            break;
                          case "SSD":
                            title =
                                '${variant["specs"]["storage"]} \n${variant["specs"]["interface"]} \n${variant["specs"]["formFactor"]}';
                            break;
                          case "RAM":
                            title =
                                '${variant["specs"]["ram"]} \n${variant["specs"]["interface"]} \n${variant["specs"]["formFactor"]}';
                            break;
                          case "Motherboard":
                            title =
                                '${variant["specs"]["socket"]} \n${variant["specs"]["chipset"]} \n${variant["specs"]["interface"]} \n${variant["specs"]["formFactor"]}';
                            break;
                          case "CPU":
                            title =
                                '${variant["specs"]["processor"]} \n${variant["specs"]["socket"]} \n${variant["specs"]["chipset"]} \n${variant["specs"]["interface"]}';
                            break;
                          default:
                            title =
                                'Unknown Variant'; // Giá trị mặc định nếu không khớp
                        }
                        return VariantWithImage(
                          isSelected: configChoice == index,
                          title: title,
                          price: CFormatter.formatMoney(
                            variant["price"].toString(),
                          ),
                          onSelect: () {
                            setState(() {
                              configChoice =
                                  index; // Cập nhật chỉ số khi chip được chọn
                            });
                          },
                        );
                      }),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 1),
                    ),
                    // Detail Information:
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: CSizes.fontSizeLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          productData["description"],
                          softWrap: true,
                          maxLines: 100000,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Text(
                          '------\n$moreInfo',
                          softWrap: true,
                          maxLines: 100000,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 1),
                    ),
                    // Reviews:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews (${productData["ratings"].length})',
                          style: TextStyle(
                            fontSize: CSizes.fontSizeLg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {},
                          child: Icon(Icons.arrow_forward_ios, size: 14),
                        ),
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
                                Text(
                                  productData["ratings"].length == 0
                                      ? '5.0'
                                      : productData["averageRating"].toString(),
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  '/5',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            RatingBarIndicator(
                              itemCount: 5,
                              rating:
                                  productData["ratings"].length == 0
                                      ? 5.0
                                      : productData["averageRating"],
                              itemSize: 20,
                              itemBuilder: (context, index) => Icon(Icons.star),
                            ),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          children: [
                            WRatingProgress(label: '5', progress: 0),
                            WRatingProgress(label: '4', progress: 0),
                            WRatingProgress(label: '3', progress: 0),
                            WRatingProgress(label: '2', progress: 0),
                            WRatingProgress(label: '1', progress: 0),
                          ],
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Divider(),
                    ),

                    // Filter:
                    Text(
                      'Filter by:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    if (productData["ratings"].length == 0)
                      Column(
                        spacing: 10,
                        children: [
                          Center(
                            child: Text(
                              'This product havent receive any ratings.',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                              // Here will pop a new page to rate that product or show an alert that user must login before rate.
                              onPressed: () => showDialogLogin(),
                              child: Text('Click here to rate this product!'),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        spacing: 10,
                        children: [
                          WReviewPiece(
                            userName: 'Tran Van Thanh',
                            time: '01/04/2025',
                            review:
                                'This product brought me an amazing experience ever I have had! I love how it is work! Thanks the shop so much for this.',
                            rating: 5,
                          ),
                          WReviewPiece(
                            userName: 'Tran Van Thanh',
                            time: '01/04/2025',
                            review:
                                'This product brought me an amazing experience ever I have had! I love how it is work! Thanks the shop so much for this.',
                            rating: 5,
                          ),
                          WReviewPiece(
                            userName: 'Tran Van Thanh',
                            time: '01/04/2025',
                            review:
                                'This product brought me an amazing experience ever I have had! I love how it is work! Thanks the shop so much for this.',
                            rating: 5,
                          ),
                          // Button to rate
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                              // Here will pop a new page to rate that product or show an alert that user must login before rate.
                              onPressed: () => showDialogLogin(),
                              child: Text('Click here to rate this product!'),
                            ),
                          ),
                        ],
                      ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 1),
                    ),
                    // Comments:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments (200)',
                          style: TextStyle(
                            fontSize: CSizes.fontSizeLg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {},
                          child: Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    WCommentPiece(
                      userName: 'Van A',
                      time: '01/04/2025',
                      comment:
                          'I wonder whether why I didnt know this product earlier!',
                    ),
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
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _decrementQuantity,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),

                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey.shade300,
                    shape: CircleBorder(),
                    shadowColor: Colors.transparent,
                    side: BorderSide.none,
                  ),
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 5),
                Text(
                  _quantity.toString(),
                  style: TextStyle(fontSize: CSizes.fontSizeLg),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: _incrementQuantity,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey.shade300,
                    shape: CircleBorder(),
                    shadowColor: Colors.transparent,
                    side: BorderSide.none,
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _addToCart,
              child: Text('Add to cart'),
            ),
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
            content: const Text(
              'You have to login before left rating. Go back to login page?',
            ),
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
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
