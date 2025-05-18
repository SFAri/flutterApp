import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/auth/controllers/product_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/data/categories_data.dart';
import '../../../../../utils/data/brands_data.dart';
import 'package:http/http.dart' as http;

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

  String? _selectedBrand;
  String? _selectedCategory;
  List<dynamic> imagePath = [];
  List<File> selectedImages = [];
  List<Future<Uint8List>> selectedImagesWeb = [];
  List<File> selectedImagesMobile = [];
  final ImagePicker _picker = ImagePicker();
  List<dynamic> variants = [];
  List<String> testImgUrl = [];
  final GlobalKey<FormState> _formProductKey = GlobalKey<FormState>();
  bool isLoading = false;
  final productController = ProductController();

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _brandController = TextEditingController();
    _categoryController = TextEditingController();
    _discountController = TextEditingController();

    imagePath = widget.item?['images'] ?? [];
    if (widget.item != null) {
      variants = widget.item!['variants'];
      _codeController.text = widget.item!['_id'];
      _nameController.text = widget.item!['name'];
      _descriptionController.text = widget.item!['description'];
      _selectedBrand = widget.item!['brand'];
      _selectedCategory = widget.item!['category'];
      _discountController.text = widget.item!['discount'].toString();
    }
    else {
      isLoading = false;
    }
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
  }

  // Show modal add and edit category:
  Future<void> _showDialog(BuildContext context, String title, Function acceptFunction, {dynamic variant}) {
    // Create text controllers and initialize them with variant values
    final variantIdController = TextEditingController(text: variant?['variantId']?.toString() ?? '');
    final importPriceController = TextEditingController(text: variant?['importPrice']?.toString() ?? '');
    final salePriceController = TextEditingController(text: variant?['salePrice']?.toString() ?? '');
    final colorController = TextEditingController(text: variant?['color']?.toString() ?? '');
    final processorController = TextEditingController(text: variant?['specs']['processor']?.toString() ?? '');
    final gpuController = TextEditingController(text: variant?['specs']['gpu']?.toString() ?? '');
    final ramController = TextEditingController(text: variant?['specs']['ram']?.toString() ?? '');
    final storageController = TextEditingController(text: variant?['specs']['storage']?.toString() ?? '');
    final screenSizeController = TextEditingController(text: variant?['specs']['screenSize']?.toString() ?? '');
    final refreshRateController = TextEditingController(text: variant?['specs']['refreshRate']?.toString() ?? '');
    final resolutionController = TextEditingController(text: variant?['specs']['resolution']?.toString() ?? '');
    final socketController = TextEditingController(text: variant?['specs']['socket']?.toString() ?? '');
    final chipsetController = TextEditingController(text: variant?['specs']['chipset']?.toString() ?? '');
    final interfaceController = TextEditingController(text: variant?['specs']['interface']?.toString() ?? '');
    final formFactorController = TextEditingController(text: variant?['specs']['formFactor']?.toString() ?? '');
    final inventoryController = TextEditingController(text: variant?['inventory']?.toString() ?? '');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return DialogForm(title: title, 
          widgets: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                SizedBox(height: 8),
                CTextFormField(
                  label: 'Variant Id', 
                  hintText: 'Enter Variant Id', 
                  controller: variantIdController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Variant ID'; // Thông báo lỗi nếu không có giá trị
                    }
                    return null; // Trả về null nếu không có lỗi
                  },
                ),
                CTextFormField(
                  label: 'Import price', 
                  hintText: 'Enter import price', 
                  controller: importPriceController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter import price'; 
                    }
                    return null; 
                  },
                ),
                CTextFormField(
                  label: 'Sale price', 
                  hintText: 'Enter sale price', 
                  controller: salePriceController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sale price'; 
                    }
                    return null; 
                  },
                ),
                CTextFormField(
                  label: 'Color', 
                  hintText: 'Choose color', 
                  controller: colorController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter color'; 
                    }
                    return null; 
                  },
                ),
                CTextFormField(
                  keyboardType: TextInputType.number,
                  label: 'Inventory', 
                  hintText: 'Enter Inventory number', 
                  controller: inventoryController, 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid inventory amount'; 
                    }
                    return null; 
                  },
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
                  controller: processorController, 
                ),
                CTextFormField(
                  label: 'GPU', 
                  hintText: 'Enter GPU', 
                  controller: gpuController, 
                ),
                CTextFormField(
                  label: 'RAM', 
                  hintText: 'Enter RAM', 
                  controller: ramController, 
                ),
                CTextFormField(
                  label: 'Storage', 
                  hintText: 'Enter Storage', 
                  controller: storageController, 
                ),
                CTextFormField(
                  label: 'Screen Size', 
                  hintText: 'Enter Screen Size', 
                  controller: screenSizeController, 
                ),
                CTextFormField(
                  label: 'Refresh Rate', 
                  hintText: 'Enter Refresh Rate', 
                  controller: refreshRateController, 
                ),
                CTextFormField(
                  label: 'Resolution', 
                  hintText: 'Enter Resolution', 
                  controller: resolutionController, 
                ),
                CTextFormField(
                  label: 'Socket', 
                  hintText: 'Enter Socket', 
                  controller: socketController, 
                ),
                CTextFormField(
                  label: 'Chipset', 
                  hintText: 'Enter Chipset', 
                  controller: chipsetController, 
                ),
                CTextFormField(
                  label: 'Interface', 
                  hintText: 'Enter Interface', 
                  controller: interfaceController, 
                ),
                CTextFormField(
                  label: 'Form Factor', 
                  hintText: 'Enter Form Factor', 
                  controller: formFactorController, 
                ),
              ],
            ),
          ), 
          acceptFunction: () {
            final updatedVariant = {
              'variantId': variantIdController.text,
              'importPrice': double.tryParse(importPriceController.text) ?? 0.0,
              'salePrice': double.tryParse(salePriceController.text) ?? 0.0,
              'color': colorController.text,
              'specs': {
                'processor': processorController.text,
                'gpu': gpuController.text,
                'ram': ramController.text,
                'storage': storageController.text,
                'screenSize': screenSizeController.text,
                'refreshRate': refreshRateController.text,
                'resolution': resolutionController.text,
              },
              'inventory': int.tryParse(inventoryController.text) ?? 0,
            };

            acceptFunction(updatedVariant); // Gọi hàm với biến thể đã cập nhật
            // Navigator.of(context).pop(); // Đóng dialog
          },
        );
      },
    );
  }

  // For image:
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        if (kIsWeb) {
          // Append the new Futures for web
          selectedImagesWeb.addAll(images.map((image) async => await image.readAsBytes()));
        } else {
          // Append the new Files for mobile
          selectedImagesMobile.addAll(images.map((image) => File(image.path)));
        }
      });
    } else {
      print('No images selected');
    }
  }

  Future<List<String>> _uploadImage() async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dfgfyxjfx/upload/');
    final List<String> imageUrls = [];
    try {
      if (kIsWeb) {
        // Xử lý cho trường hợp web
        for (var imageFuture in selectedImagesWeb) {
          // Chờ cho Future hoàn thành
          Uint8List imageData = await imageFuture as Uint8List; 

          final request = http.MultipartRequest('POST', url)
            ..fields['upload_preset'] = 'dldndst'
            ..files.add(http.MultipartFile.fromBytes(
              'file',
              imageData,
              filename: 'image_${DateTime.now().millisecondsSinceEpoch}.png', // Tạo tên file
            ));

          final response = await request.send();
          if (response.statusCode == 200) {
            final responseData = await response.stream.toBytes();
            final responseString = String.fromCharCodes(responseData);
            final jsonMap = jsonDecode(responseString);
            final String imageUrl = jsonMap['url'];
            
            imageUrls.add(imageUrl); // Thêm URL vào danh sách
          } else {
            print('ERROR WHILE UPLOADING IMAGE: ${response.statusCode}');
          }
        }
      } else {
        // Xử lý cho trường hợp mobile
        for (var image in selectedImagesMobile) {
          Uint8List imageData = await File(image.path).readAsBytes(); // Đọc dữ liệu từ file

          final request = http.MultipartRequest('POST', url)
            ..fields['upload_preset'] = 'dldndst'
            ..files.add(http.MultipartFile.fromBytes(
              'file',
              imageData,
              filename: 'image_${DateTime.now().millisecondsSinceEpoch}.png', // Tạo tên file
            ));

          final response = await request.send();
          if (response.statusCode == 200) {
            final responseData = await response.stream.toBytes();
            final responseString = String.fromCharCodes(responseData);
            final jsonMap = jsonDecode(responseString);
            final String imageUrl = jsonMap['url'];
            
            imageUrls.add(imageUrl); // Thêm URL vào danh sách
          } else {
            print('ERROR WHILE UPLOADING IMAGE: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      print('Exception: $e');
    }
    print(imageUrls);
    setState(() {
      testImgUrl = imageUrls;
    });
    return imageUrls; // Trả về danh sách URL
  }

  Future<void> handleSubmit (context, isUpdate) async {
    // _uploadImage();
    // Kiểm tra danh sách variants
    if (variants.isEmpty) {
      // Hiển thị Snackbar nếu variants rỗng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one variant.')),
      );
      return;
    }

    // Kiểm tra danh sách hình ảnh
    int totalImages = (imagePath.length) + 
                    (selectedImagesMobile.length) + 
                    (selectedImagesWeb.length);

    if (totalImages == 0) {
      // Hiển thị Snackbar nếu không có hình ảnh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one image.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    // CALL API HERE:
    // Call api upload ảnh lên:
    await _uploadImage();
    print('URL FROM upload: ' + testImgUrl.join('\n'));
    
    List<Map> updatedVariants = variants.map((variant) {
      return {
        ...variant,
        'type': _selectedCategory, // Thêm trường "type"
      };
    }).toList();

    Map<String, dynamic> productData = {
      'name': _nameController.text,
      'brand': _selectedBrand,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'images': imagePath + testImgUrl, 
      'variants': updatedVariants, 
      'discount': double.parse(_discountController.text), 
    };

    // Cập nhật sản phẩm:
    if (isUpdate){
      final response = await productController.updateProduct(widget.item?['_id'],productData);
      if (response['status'] == 'success') {
        // Xử lý thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product update successfully.')),
        );
        print('Product update successfully: ${response['data']}');
      } else {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product.')),
        );
        print('Error updating product: ${response['message']}');
      }
    }
    else {
      final response = await productController.createProduct(productData);
      if (response['status'] == 'success') {
        // Xử lý thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product created successfully.')),
        );
        print('Product created successfully: ${response['data']}');
      } else {
        // Xử lý lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating product.')),
        );
        print('Error creating product: ${response['message']}');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading 
    ? Center(child: CircularProgressIndicator())
    : Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [

        // List view image strings:
        SizedBox(
          height: 300,
          child: imagePath.isNotEmpty || selectedImagesWeb.isNotEmpty || selectedImagesMobile.isNotEmpty
            ? ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 20),
              itemCount: imagePath.length + selectedImagesWeb.length + selectedImagesMobile.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index < imagePath.length) {
                  // Existing images
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 180,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(imagePath[index]),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            imagePath.removeAt(index); // Remove image
                          });
                        },
                        icon: Icon(Icons.cancel, color: Colors.red),
                      ),
                    ],
                  );
                } else if (index < imagePath.length + selectedImagesWeb.length) {
                  // Newly selected images for web
                  final selectedIndex = index - imagePath.length;
                  return FutureBuilder<Uint8List>(
                    future: selectedImagesWeb[selectedIndex],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error loading image: ${snapshot.error}'); // Handle error
                      } else if (snapshot.hasData) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: 250,
                              height: 180,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.memory(snapshot.data!),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedImagesWeb.removeAt(selectedIndex);
                                });
                              },
                              icon: Icon(Icons.cancel, color: Colors.red),
                            ),
                          ],
                        );
                      } else {
                        return Text('No image data available'); // Handle no data case
                      }
                    },
                  );
                } else {
                  // Newly selected images for mobile
                  final selectedIndex = index - imagePath.length - selectedImagesWeb.length;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 180,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.file(selectedImagesMobile[selectedIndex]),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedImagesMobile.removeAt(selectedIndex); // Remove selected image
                          });
                        },
                        icon: Icon(Icons.cancel, color: Colors.red),
                      ),
                    ],
                  );
                }
              },
            )
            : DottedBorder(
              color: Colors.grey,
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              padding: EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 250,
                  width: 180,
                  alignment: Alignment.center,
                  child: Text(
                    'Need to upload the images',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () async {
              await pickImages(); // Call the method to pick images
            },
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
        Form(
          key: _formProductKey,
          child: Column(
            children: [
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
                        // child: CTextFormField(
                        //   controller: _codeController,
                        //   label: 'Product Id',
                        // ),
                        child: TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            label: Text('Product Id'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabled: false
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 450,
                        child: CTextFormField(
                          controller: _nameController,
                          label: 'Product Name',
                          hintText: 'Enter product name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Product Name'; // Thông báo lỗi nếu không có giá trị
                            }
                            return null; // Trả về null nếu không có lỗi
                          },
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
                          items: brands.map((String brand) {
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a brand'; // Thông báo lỗi nếu không có giá trị
                            }
                            return null; // Trả về null nếu không có lỗi
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
                          items: categories.map((String category) {
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a category'; // Thông báo lỗi nếu không có giá trị
                            }
                            return null; // Trả về null nếu không có lỗi
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter discount for this product'; // Thông báo lỗi nếu không có giá trị
                            }
                            return null; // Trả về null nếu không có lỗi
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 10,),

              SizedBox(
                width: Responsive.isDesktop(context) ? 950 : 450,
                child: TextFormField(
                  controller: _descriptionController,
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
            ],
          )
        ),

        // Dưới là 1 cái listview động chứa thông tin variants: [code, name, type ,retail price, sale price, inStock]
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: (){
              _showDialog(
                context, 
                'Add new variant', 
                (data) {
                  // Handle adding the new variant data here
                  setState(() {
                    variants.add(data);
                  });
                },
              );
            },
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
          itemCount: variants.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: Icon(Icons.account_tree_rounded),
                contentPadding: EdgeInsets.all(5),
                title: Text('SKU: ${variants[index]["variantId"]}'),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text('RAM: ${variants[index]["specs"]["ram"] ?? 'N/A'}'), // Default to 'N/A' if null
                    Text('Color: ${variants[index]["color"] ?? 'N/A'}'), // Default to 'N/A' if null
                    Text('Storage: ${variants[index]["specs"]["storage"] ?? 'N/A'}'), // Default to 'N/A' if null
                    Text('In Stock: ${variants[index]["inventory"] ?? 'N/A'}'), // Default to 'N/A' if null
                    Text('Import Price: ${variants[index]["importPrice"] != null ? '${variants[index]["importPrice"]} VNĐ' : 'N/A'}'), // Default to 'N/A' if null
                  ],
                ),
                trailing: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: (){
                        _showDialog(
                          context, 
                          'Edit Variant: ${variants[index]['variantId']}', //----- SKU of variant here syntax: Edit Variant: SKU -$skuCode ----------
                          (data) {
                            setState(() {
                              variants[index] = data;
                            });
                          },
                          variant: variants[index],
                        );
                      }, 
                      icon: Icon(Icons.edit)
                    ),
                    IconButton(
                      onPressed: (){
                        setState(() {
                          variants.removeAt(index); // Xóa biến thể tại chỉ số index
                        });
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
                onPressed: (){
                  if (_formProductKey.currentState?.validate() ?? false) {
                    // Nếu form hợp lệ, thực hiện hành động
                    // widget.item != null ? handleUpdate(context) : handleCreate(context);
                    handleSubmit(context, widget.item != null ? true : false);
                  }
                }, 
                child: Text(widget.item != null ? 'Update' : 'Create')
              ),
            ],
          ),
        )
      ],
    );
  }
  
}