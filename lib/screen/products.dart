import 'package:easy/screen/appbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductCategoryPage(),
    );
  }
}

class ProductCategoryPage extends StatelessWidget {
  final List<String> products = [
    "Product 1",
    "Product 2",
    "Product 3",
    "Product 4",
    "Product 5",
    "Product 6",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: 'RBBS Easy'),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: products.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.blue, // You can change the color as per your requirement
              child: Center(
                child: Text(
                  products[index],
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
