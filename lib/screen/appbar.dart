import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.red,
      // Customize the AppBar here as needed
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}