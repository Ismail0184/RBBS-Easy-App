import 'package:easy/screen/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appbar.dart';

main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red,
        ),
        debugShowCheckedModeBanner: false,
        home: DashboardActivity()
    );
  }
}

class DashboardActivity extends StatelessWidget {
  const DashboardActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'RBBS Easy'),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Order"),
            BottomNavigationBarItem(icon: Icon(Icons.scanner), label: "Coupon Scan"),
          ],
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}



