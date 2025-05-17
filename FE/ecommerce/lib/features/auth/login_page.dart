// import 'package:ecommerce/features/admin/admin_home.dart';
import 'package:ecommerce/features/admin/admin_home.dart';
import 'package:ecommerce/features/auth/controllers/login_controller.dart';
import 'package:ecommerce/features/personalization/controllers/profile_controller.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:ecommerce/utils/helpers/role_function.dart';
import 'package:ecommerce/utils/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:provider/provider.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final LoginController _loginController = LoginController();
  final ProfileController _profileController = ProfileController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  bool _obscureTextLogin = true;
  PageController? _pageController;
  Color left = Colors.white; // Màu cho "Sign In" khi được chọn
  Color right = Colors.grey; // Màu cho "Sign Up" khi không được chọn

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    myFocusNodeEmailLogin.dispose();
    myFocusNodePasswordLogin.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  bool isLoading = false;
  String? errorMessage;

  void handleLogin(context) async {
    print("Enter login");
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _loginController.login(
        loginEmailController.text,
        loginPasswordController.text,
      );

      if (result['status'] == "failure") {
        setState(() {
          errorMessage = result['message'];
        });
        CHelperFunctions.showSnackBar(result['message'], context: context);
        return;
      }

      // Lưu token vào SharedPreferences
      await AuthService.saveToken(result['accessToken']);

      // Lưu thông tin người dùng vào SharedPreferences
      final fetchedUser = await _profileController.fetchProfile();
      if (mounted) {
        Provider.of<SettingsProvider>(
          context,
          listen: false,
        ).setUserData(fetchedUser);
        CHelperFunctions.showSnackBar("Login success", context: context);
      }

      int role = getRoleFromToken(result['accessToken']);
      print("Enter loginROLE: $role");

      if (role == 1) {
        // Nếu vai trò là 1 (admin)

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHome(streamController.stream),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationMenu()),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        print("Error logging in: $errorMessage");
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold",
          ),
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController?.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _continueAsGuest() {
    Get.offAll(() => const NavigationMenu());
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        Get.snackbar(
          "Đăng nhập thành công",
          "Chào mừng ${googleUser.displayName}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => const NavigationMenu());
      } else {
        showInSnackBar("Hủy đăng nhập Google");
      }
    } catch (e) {
      showInSnackBar("Đăng nhập Google thất bại: $e");
    }
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    left == Colors.white
                        ? Colors.lightBlueAccent.withOpacity(0.3)
                        : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              ),
              child: TextButton(
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    right == Colors.white
                        ? Colors.lightBlueAccent.withOpacity(0.3)
                        : Colors
                            .transparent, // Nền xanh lá nhạt khi "Sign Up" được chọn
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              ),
              child: TextButton(
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                    fontFamily: "WorkSansSemiBold",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.black, // Đổi màu nền thành màu đen
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.white, // Đổi màu ổ khóa thành trắng
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildMenuBar(context),
              ),
              Expanded(
                flex: 2,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() {
                      left = i == 0 ? Colors.white : Colors.grey;
                      right = i == 1 ? Colors.white : Colors.grey;
                    });
                  },
                  children: <Widget>[
                    // ✅ Sửa ở đây: dùng SingleChildScrollView bao Column
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildLoginForm(),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _signInWithGoogle,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(15.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const RegisterPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
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
                child: Container(
                  width: 350.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 20.0,
                        ),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Email address...",
                            hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                          vertical: 20.0,
                        ),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: const TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black, // Đổi màu ổ khóa thành trắng
                            ),
                            hintText: "Password...",
                            hintStyle: const TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 17.0,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: const Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 200.0),
                width: 300,
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
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (loginEmailController.text.isEmpty ||
                                loginPasswordController.text.isEmpty) {
                              CHelperFunctions.showSnackBar(
                                "Vui lòng nhập email và mật khẩu",
                                context: context,
                              );
                            } else {
                              handleLogin(context);
                            }
                          },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 42.0,
                    ),
                    child: Text(
                      "SIGN IN",
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 16.0,
                  fontFamily: "WorkSansMedium",
                ),
              ),
            ),
          ),
          // Dòng gạch ngang OR
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white54,
                    thickness: 1,
                    indent: 15,
                    endIndent: 5,
                  ),
                ),
                const Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "WorkSansMedium",
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white54,
                    thickness: 1,
                    indent: 10,
                    endIndent: 30,
                  ),
                ),
              ],
            ),
          ),
          // Nút Continue as Guest
          TextButton.icon(
            onPressed: _continueAsGuest,
            icon: const Icon(Icons.person_outline, color: Colors.white),
            label: const Text(
              "Continue as a Guest",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: "WorkSansMedium",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
