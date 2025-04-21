import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ecommerce/navigation_menu.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeConfirmPassword = FocusNode();

  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupNameController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupConfirmPasswordController = TextEditingController();

  bool _obscureTextSignup = true;
  bool _obscureTextConfirm = true;

  Color loginGradientStart = Colors.black; // Đen
  Color loginGradientEnd = Colors.blueAccent; // Xanh

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    myFocusNodeConfirmPassword.dispose();
    signupEmailController.dispose();
    signupNameController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        "Đăng ký thành công",
        "Vui lòng đăng nhập để tiếp tục",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(); // Quay lại trang đăng nhập
      });
    }
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleConfirm() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [loginGradientStart, loginGradientEnd], // Gradient đen-xanh lá
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 23.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Card(
                      elevation: 2.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                              child: TextFormField(
                                focusNode: myFocusNodeName,
                                controller: signupNameController,
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.user, color: Colors.black),
                                  hintText: "Fullname...",
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Cần phải nhập tên đầy đủ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                              child: TextFormField(
                                focusNode: myFocusNodeEmail,
                                controller: signupEmailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  icon: Icon(FontAwesomeIcons.envelope, color: Colors.black),
                                  hintText: "Email address...",
                                ),
                                validator: (value) {
                                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập email';
                                  } else if (!emailRegex.hasMatch(value)) {
                                    return 'Email không hợp lệ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                              child: TextFormField(
                                focusNode: myFocusNodePassword,
                                controller: signupPasswordController,
                                obscureText: _obscureTextSignup,
                                style: const TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  icon: const Icon(FontAwesomeIcons.lock, color: Colors.black),
                                  hintText: "Password...",
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleSignup,
                                    child: const Icon(FontAwesomeIcons.eye, size: 15.0, color: Colors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  }
                                  if (value.length < 8) {
                                    return 'Mật khẩu phải có ít nhất 8 ký tự!';
                                  }
                                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'Mật khẩu phải có ít nhất 1 chữ in hoa';
                                  }
                                  if(!RegExp(r'\d').hasMatch(value)){
                                    return 'Mật khẩu phải có ít nhất 1 chữ số';
                                  }
                                  if(!RegExp(r'[!@#\$&*~]').hasMatch(value)){
                                    return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                              child: TextFormField(
                                focusNode: myFocusNodeConfirmPassword,
                                controller: signupConfirmPasswordController,
                                obscureText: _obscureTextConfirm,
                                style: const TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.check, color: Colors.black),
                                  hintText: "Confirm password...",
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleConfirm,
                                    child: const Icon(FontAwesomeIcons.eye, size: 15.0, color: Colors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng xác nhận mật khẩu';
                                  } else if (value != signupPasswordController.text) {
                                    return 'Mật khẩu không khớp';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 400.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: loginGradientStart, offset: const Offset(1.0, 6.0), blurRadius: 20.0),
                          BoxShadow(color: loginGradientEnd, offset: const Offset(1.0, 6.0), blurRadius: 20.0),
                        ],
                        gradient: LinearGradient(
                          colors: [loginGradientEnd, loginGradientStart], // Gradient đen-xanh lá
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      child: MaterialButton(
                        onPressed: _handleSignup,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: "WorkSansBold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}