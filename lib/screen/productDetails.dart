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
      appBar: AppBar(
        title: Text('Product Name'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Product Image
            Image.network('https://example.com/product_image.jpg'),

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
                'Price: \$99.99',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement the functionality to add the product to the cart.
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
