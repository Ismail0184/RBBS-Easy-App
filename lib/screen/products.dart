import 'package:easy/screen/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.amber),
        debugShowCheckedModeBanner: false,
        home: ProductsActivity()
    );
  }
}

class ProductsActivity extends StatelessWidget {
  const ProductsActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("RBBS Easy"),
          backgroundColor: Colors.red,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: Colors.red,
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



