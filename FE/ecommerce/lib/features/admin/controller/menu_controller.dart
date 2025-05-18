import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldMenuKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldMenuKey;

  void controlMenu() {
    if (!_scaffoldMenuKey.currentState!.isDrawerOpen) {
      _scaffoldMenuKey.currentState!.openDrawer();
    }
  }
}