import 'package:ecommerce/features/admin/controller/menu_controller.dart';
import 'package:ecommerce/features/admin/responsive.dart';
import 'package:ecommerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    this.title = 'Dashboard'
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        
        Text(
          title,
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
            Icon(Icons.keyboard_arrow_down)
          ],
        )
      ],
    );
  }
}