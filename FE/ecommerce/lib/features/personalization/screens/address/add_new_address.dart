import 'dart:convert';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/common/widgets/appbar/appbar.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController _profileController = ProfileController();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _provinceController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  late TextEditingController _detailAddressController;
  late bool _isDefaultController;

  bool isLoading = false;
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;

  @override
  void initState() {
    super.initState();
    _isDefaultController = false;
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _provinceController = TextEditingController();
    _districtController = TextEditingController();
    _wardController = TextEditingController();
    _detailAddressController = TextEditingController();
    fetchProvinces().then((data) {
      setState(() {
        provinces = data;
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _detailAddressController.dispose();
    _isDefaultController = false;
    super.dispose();
  }

  Future<List<dynamic>> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('https://provinces.open-api.vn/api/'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return json.decode(decodedBody);
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<void> fetchDistricts(String provinceCode) async {
    final response = await http.get(
      Uri.parse('https://provinces.open-api.vn/api/p/$provinceCode/?depth=2'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);

      setState(() {
        districts = data['districts']; // Lấy danh sách quận từ dữ liệu
        selectedWard = null;
        selectedDistrict = null; // Reset quận khi thay đổi tỉnh
      });
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<void> fetchWards(String districtCode) async {
    final response = await http.get(
      Uri.parse('https://provinces.open-api.vn/api/d/$districtCode/?depth=2'),
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);
      setState(() {
        wards = data['wards']; // Lấy danh sách quận từ dữ liệu
      });
      print(wards);
    } else {
      throw Exception('Failed to load wards');
    }
  }

  Future<void> _addNewAddress(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String provinceName =
            provinces.firstWhere(
              (p) => p['code'].toString() == selectedProvince,
              orElse: () => {'name': 'Not Found'},
            )['name'];
        String districtName =
            districts.firstWhere(
              (district) => district['code'].toString() == selectedDistrict,
              orElse: () => {'name': 'Not Found'},
            )['name'];
        String wardName =
            wards.firstWhere(
              (ward) => ward['code'].toString() == selectedWard,
              orElse: () => {'name': 'Not Found'},
            )['name'];
        _provinceController.text = provinceName;
        _districtController.text = districtName;
        _wardController.text = wardName;

        print(_isDefaultController);

        await _profileController.addNewAddress(
          _fullNameController.text,
          _phoneNumberController.text,
          _provinceController.text,
          _districtController.text,
          _wardController.text,
          _detailAddressController.text,
          _isDefaultController,
        );

        if (mounted) {
          CHelperFunctions.showSnackBar(
            'Add new address successfully',
            context: context,
          );
          final List<Map<String, dynamic>> fetchedData =
              await _profileController.fetchUserAddress();

          Provider.of<SettingsProvider>(
            context,
            listen: false,
          ).setUserAddress(fetchedData);

          setState(() {
            isLoading = true;
          });

          Navigator.pop(context, true);
        }
      } catch (e) {
        String message = e.toString();
        print("Error adding new address: $message");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CAppBar(
        showBackArrows: true,
        title: Text(
          'Add new Address',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(CSizes.defaultSpace),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(CSizes.borderRadiusMd),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: CSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(CSizes.borderRadiusMd),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: CSizes.spaceBtwInputFields),
                  SizedBox(
                    width: 400,
                    child: DropdownButtonFormField<String>(
                      value: selectedProvince,
                      hint: Text('Choose province'),
                      items:
                          provinces.map((province) {
                            return DropdownMenuItem<String>(
                              value: province['code'].toString(),
                              child: Text(province['name']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProvince = value;
                          fetchDistricts(value!); // Lấy quận khi chọn tỉnh
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Iconsax.building),
                        labelText: 'Province',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select a province';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: CSizes.spaceBtwInputFields),
                  SizedBox(
                    width: 400,
                    child: DropdownButtonFormField<String>(
                      value: selectedDistrict,
                      hint: Text('Choose district'),
                      items:
                          districts.map((district) {
                            return DropdownMenuItem<String>(
                              value: district['code'].toString(),
                              child: Text(district['name']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value;
                          fetchWards(value!);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Iconsax.map),
                        labelText: 'District',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a district';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: CSizes.spaceBtwInputFields),
                  SizedBox(
                    width: 400,
                    child: DropdownButtonFormField<String>(
                      value: selectedWard,
                      hint: Text('Choose ward'),
                      items:
                          wards.map((ward) {
                            return DropdownMenuItem<String>(
                              value: ward['code'].toString(),
                              child: Text(ward['name']),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWard = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Iconsax.location),
                        labelText: 'Ward',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a ward';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: CSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: _detailAddressController,
                    maxLines: 3,
                    minLines: 1,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.note),
                      labelText: 'Address Details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(CSizes.borderRadiusMd),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: CSizes.defaultSpace),
                  // is Default Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isDefaultController,
                        onChanged: (value) {
                          setState(() {
                            _isDefaultController = value!;
                          });
                        },
                      ),
                      Text(
                        'Set as default address',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: CSizes.defaultSpace),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                FocusScope.of(context).unfocus();
                                _formKey.currentState?.save();
                                // Validate the form
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _addNewAddress(context);
                                }
                              },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
