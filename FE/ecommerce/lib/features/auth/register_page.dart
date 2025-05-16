import 'dart:convert';

import 'package:ecommerce/features/auth/controllers/login_controller.dart';
import 'package:ecommerce/features/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final loginController = LoginController();
  bool isLoading = false;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController pswController;
  late TextEditingController confirmPswController;
  late TextEditingController cityController;
  late TextEditingController districtController;
  late TextEditingController detailAddressController;
  bool _obscureText = true;
  bool _obscureConfirmText = true;
  List<dynamic> provinces = [];
  List<dynamic> districts = [];
  List<dynamic> wards = [];
  String? selectedProvince;
  String? selectedDistrict;
  String? selectedWard;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Đảo ngược trạng thái
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText; // Đảo ngược trạng thái
    });
  }

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    pswController = TextEditingController();
    confirmPswController = TextEditingController();
    detailAddressController = TextEditingController();
    fetchProvinces().then((data) {
      setState(() {
        provinces = data;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    pswController.dispose();
    confirmPswController.dispose();
    detailAddressController.dispose();
  }

  Future<List<dynamic>> fetchProvinces() async {
    final response = await http.get(
      Uri.parse('https://provinces.open-api.vn/api/'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<void> fetchDistricts(String provinceCode) async {
    final response = await http.get(
      Uri.parse('https://provinces.open-api.vn/api/p/$provinceCode/?depth=2'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
      final data = json.decode(response.body);
      setState(() {
        wards = data['wards']; // Lấy danh sách quận từ dữ liệu
      });
      print(wards);
    } else {
      throw Exception('Failed to load wards');
    }
  }

  void _handleSignup(context) async{
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Set loading state to true
      });
      try {
        String provinceName = provinces.firstWhere(
            (p) => p['code'].toString() == selectedProvince,
            orElse: () => {'name': 'Not Found'},
          )['name'];
        String districtName = districts.firstWhere(
            (district) => district['code'].toString() == selectedDistrict,
            orElse: () => {'name': 'Not Found'},
          )['name'];
        String wardName = wards.firstWhere(
          (ward) => ward['code'].toString() == selectedWard,
          orElse: () => {'name': 'Not Found'},
        )['name'];
        var test = [
          nameController.text,
          emailController.text,
          pswController.text,
          confirmPswController.text,
          provinceName,
          districtName,
          wardName,
          detailAddressController.text
        ];
        print("TEST ====" + test.join(', '));
        final result = await loginController.register(
          nameController.text,
          emailController.text,
          pswController.text,
          confirmPswController.text,
          provinceName,
          districtName,
          wardName,
          detailAddressController.text
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register successfully, please login!'))
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('There are some errors, please try again!'))
        );
      } finally {
        setState(() {
          isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15,
              children: [
                SizedBox(height: 10),
                CustomTextFormFieldRegister(
                  controller: nameController,
                  hint: 'Enter FullName',
                  label: 'FullName',
                  icon: Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'FullName is required, not empty';
                    }
                    if (value.length < 10 && !value.contains(' ')) {
                      return 'Please enter name have length > 10';
                    }
                    return null;
                  },
                ),
                CustomTextFormFieldRegister(
                  controller: emailController,
                  hint: 'Enter Email Address',
                  label: 'Email',
                  icon: Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required, not empty';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter valid email with @';
                    }
                  },
                ),
                CustomTextFormFieldRegister(
                  controller: pswController,
                  hint: 'Enter password',
                  label: 'Password',
                  icon: Icon(Icons.lock),
                  isObscure: true,
                  obscureText: _obscureText,
                  obscureCallBack: _togglePasswordVisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required, not empty';
                    }
                    if (value.length < 8) {
                      return 'Password has at least 8 characters';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least 1 Capital letter';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Password must contain at least 1 digit';
                    }
                    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                      return 'Password must contain at least 1 special character';
                    }
                    return null;
                  },
                ),
                CustomTextFormFieldRegister(
                  controller: confirmPswController,
                  hint: 'Enter confirm password',
                  label: 'Confirm Password',
                  icon: Icon(Icons.lock),
                  isObscure: true,
                  obscureText: _obscureConfirmText,
                  obscureCallBack: _toggleConfirmPasswordVisibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required, not empty';
                    } else if (value != pswController.text) {
                      return 'Not match password';
                    }
                    return null;
                  },
                ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a province';
                      }
                      return null;
                    },
                  ),
                ),
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

                SizedBox(
                  // padding: EdgeInsets.all(20),
                  width: 400,
                  child: TextFormField(
                    controller: detailAddressController,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.white,
                      hintText: 'Enter your address',
                      labelText: 'Address',
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        offset: const Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Colors.blue,
                        offset: const Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.black,
                      ], // Đổi gradient thành xanh dương-xám đậm
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: isLoading ? null : () => _handleSignup(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 42.0,
                      ),
                      child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                          "REGISTER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold",
                          ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormFieldRegister extends StatelessWidget {
  const CustomTextFormFieldRegister({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.isObscure = false,
    this.obscureText = true,
    this.obscureCallBack,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isObscure;
  final bool obscureText;
  final VoidCallback? obscureCallBack;
  final Icon icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextFormField(
        controller: controller,
        obscureText: isObscure ? obscureText : false,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          fillColor: Colors.white,
          hintText: hint,
          labelText: label,
          prefixIcon: icon,
          suffix:
              isObscure
                  ? IconButton(
                    onPressed: obscureCallBack,
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }
}
