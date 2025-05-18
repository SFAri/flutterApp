import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/navigation_menu.dart';
import 'package:ecommerce/services/auth_service.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:ecommerce/utils/local_storage/storage_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
    this.title = 'Dashboard', 
    required this.onMenuButtonPressed
  });

  final String title;
  final VoidCallback onMenuButtonPressed;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  Future<void> logoutUser() async {
    final localStorage = CLocalStorage.instance();
    await localStorage.deleteData('user_profile');
    await AuthService.clearToken();
    // setState(() {}); // Used to refresh
  }

  void handleLogOut() {
    logoutUser();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => NavigationMenu()), // Thay thế LoginPage bằng trang bạn muốn điều hướng
      (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: widget.onMenuButtonPressed,
          ),
        
        Text(
          widget.title,
          style: Responsive.isDesktop(context) ? Theme.of(context).textTheme.headlineMedium : Theme.of(context).textTheme.headlineSmall,
        ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Row(
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(CImages.avatar),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Admin'),
              ),
            // Icon(Icons.keyboard_arrow_down)

            PopupMenuButton<String>(
              icon: Icon(Icons.keyboard_arrow_down),
              onSelected: (value) {
                
                if (value == 'logout') {
                  handleLogOut();
                } 
                else if (value == 'change_password') {
                  
                }
              },
              itemBuilder: (BuildContext context) {
                return {
                  'Logout',
                  'Change Password',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase().replaceAll(' ', '_'), // Tạo giá trị cho item
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        )
      ],
    );
  }
}