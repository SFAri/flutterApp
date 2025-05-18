import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce/common/widgets/form/custom_dialogform.dart';
import 'package:ecommerce/common/widgets/form/custom_textformfield.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/features/admin/screens/dashboard/widgets/header.dart';
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
  String testImgUrl = '';

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
                ),
                CTextFormField(
                  label: 'Import price', 
                  hintText: 'Enter import price', 
                  controller: importPriceController, 
                ),
                CTextFormField(
                  label: 'Sale price', 
                  hintText: 'Enter sale price', 
                  controller: salePriceController, 
                ),
                CTextFormField(
                  label: 'Color', 
                  hintText: 'Choose color', 
                  controller: colorController, 
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
                  keyboardType: TextInputType.number,
                  label: 'Inventory', 
                  hintText: 'Enter Inventory number', 
                  controller: inventoryController, 
                ),
              ],
            ),
          ), 
          acceptFunction: acceptFunction,
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

  Future<void> _uploadImage() async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dfgfyxjfx/upload/');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'dldndst';
      // ..files.add(await http.MultipartFile.fromPath('file', !kIsWeb ? selectedImagesMobile[0].path : ''));
      if (kIsWeb) {
        // Xử lý cho trường hợp web
        for (var imageFuture in selectedImagesWeb) {
          Uint8List imageData = await imageFuture; // Chờ cho Future hoàn thành
          request.files.add(http.MultipartFile.fromBytes(
            'file', 
            imageData,
            filename: 'image_${DateTime.now().millisecondsSinceEpoch}.png', // Tạo tên file
          ));
        }
      } else {
        // Xử lý cho trường hợp mobile
        request.files.add(await http.MultipartFile.fromPath('file', selectedImagesMobile[0].path));
      }
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        setState(() {
          final url = jsonMap['url'];
          testImgUrl = url;
          print("URL -----$url");
        });
      }
      else {
        print('ERROR WHILE UPLOADING IMAGE');
      }
  }

  void handleUpdate (){

  }

  void handleCreate (){
    _uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        // Header(title: 'Product Detail:'),
        // Divider(),

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
                  child: CTextFormField(
                    controller: _codeController,
                    label: 'Product Id',
                  ),
                ),
                SizedBox(
                  width: 450,
                  child: CTextFormField(
                    controller: _nameController,
                    label: 'Product Name',
                    hintText: 'Enter product name',
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
                  ),
                ),
              ],
            )
          ],
        ),

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
                            // Handle updating the existing variant with the provided data
                          },
                          variant: variants[index],
                        );
                      }, 
                      icon: Icon(Icons.edit)
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
                onPressed: widget.item != null ? handleUpdate : handleCreate, 
                child: Text(widget.item != null ? 'Update' : 'Create')
              ),
            ],
          ),
        )
      ],
    );
  }
  
}