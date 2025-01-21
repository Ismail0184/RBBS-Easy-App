import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(OrderFormApp());
}

class OrderFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrderFormScreen(),
    );
  }
}

class OrderFormScreen extends StatefulWidget {
  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _addressController = TextEditingController();

  Future<void> submitOrder() async {
    final url = 'http://yourdomain.com/insert_order.php'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': _nameController.text,
        'email': _emailController.text,
        'product': _productController.text,
        'quantity': _quantityController.text,
        'address': _addressController.text,
      },
    );

    if (response.statusCode == 200) {
      final result = response.body;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to place the order!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _productController,
              decoration: InputDecoration(labelText: 'Product'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitOrder,
              child: Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
