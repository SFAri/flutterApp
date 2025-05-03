import 'package:ecommerce/utils/constants/sizes.dart';
import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:ecommerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrows = false,
    this.isTranfer = false,
  });

  final Widget? title;
  final bool showBackArrows;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool isTranfer;

  @override
  Widget build(BuildContext context) {
    final dark = CHelperFunctions.isDarkMode(context);
    return AppBar(
      backgroundColor:
          isTranfer
              ? Colors.transparent
              : dark
              ? Colors.black
              : Colors.blue,
      automaticallyImplyLeading: false,
      leading:
          showBackArrows
              ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              )
              : leadingIcon != null
              ? IconButton(
                onPressed: leadingOnPressed,
                icon: Icon(leadingIcon, color: Colors.white),
              )
              : null,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
