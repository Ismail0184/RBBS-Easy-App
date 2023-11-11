import 'package:easy/screen/appbar.dart';
import 'package:easy/screen/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductView(),
    );
  }
}

class ProductView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'RBBS Easy'),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Product Image
            Container(
              margin: EdgeInsets.only(top: 30),
              child:
              Image.network('https://i.i-sgcm.com/products/items/10/2015/09/10746_1.jpg'),

            ),

            // Product Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Product Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Product Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Product Description: This is a detailed description of the product.',
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Product Price
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Price: BDT 99.99',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red; // Color when pressed
                    }
                    return Colors.red; // Default color
                  }),
                ),
                onPressed: () {
                },
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
