import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(OrderFormApp());
}

class OrderFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          subtitle1: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: OrderFormPage(),
    );
  }
}

class OrderFormPage extends StatefulWidget {
  @override
  _OrderFormPageState createState() => _OrderFormPageState();
}

class _OrderFormPageState extends State<OrderFormPage> {
  String? selectedBusinessCenter;
  String? selectedCustomer;
  String? selectedItem;
  String? orderNo;
  double? presentStock = 0.0;
  double? rate = 0.0;
  double? orderQuantity = 0.0;
  double? amount = 0.0;

  List<dynamic> businessCenters = [];
  List<dynamic> customers = [];
  List<dynamic> items = [];
  TextEditingController customerController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController orderQuantityController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController orderNoController = TextEditingController();

  bool isOrderQuantityValid = true;

  @override
  void initState() {
    super.initState();
    fetchBusinessCenters();
    fetchItems();
    _fetchInvoiceNumber();
  }



  Future<void> _fetchInvoiceNumber() async {
    // Example userID (replace with dynamic userID if necessary)
    String userID = '61';
    final String apiUrl = 'http://icpd.icpbd-erp.com/api/app/modules/sales/order/getLatestOrderNo.php'; // Your API URL
    final response = await http.get(Uri.parse('$apiUrl?userID=$userID'));

    if (response.statusCode == 200) {
      // Decode the JSON response
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        // Set the generated invoice number to the controller
        setState(() {
          orderNoController.text = data['invoiceNumber'];
        });
      } else {
        // Handle error response from API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['message']}')),
        );
      }
    } else {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch invoice number')),
      );
    }
  }

  Future<void> fetchBusinessCenters() async {
    final response = await http.get(Uri.parse('http://icpd.icpbd-erp.com/api/app/businessPartnerList.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        businessCenters = data['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch business centers')));
    }
  }

  Future<void> fetchCustomers(String businessCenterId) async {
    final response = await http.get(Uri.parse('http://icpd.icpbd-erp.com/api/app/customerList.php?businessCenterId=$businessCenterId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        customers = data['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch customers')));
    }
  }

  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('http://icpd.icpbd-erp.com/api/app/itemList.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        items = data['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch items')));
    }
  }

  Future<void> fetchStockAndRate(String itemId) async {
    final response = await http.get(Uri.parse('http://icpd.icpbd-erp.com/api/app/stockReportForSingleItem.php?itemId=$itemId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        final stockData = data['data'][0];
        setState(() {
          presentStock = double.tryParse(stockData['stock'].toString()) ?? 0.0;
          rate = double.tryParse(stockData['rate'].toString()) ?? 0.0;
          // Ensure presentStock is not null
          if ((presentStock ?? 0.0) > 0) {
            stockController.text = 'Stock available';
          } else {
            stockController.text = 'No stock available';
          }
          rateController.text = rate.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No stock data found')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch stock data')));
    }
  }

  void calculateAmount() {
    setState(() {
      if (orderQuantity != null && rate != null) {
        amount = orderQuantity! * rate!;
        amountController.text = amount!.toStringAsFixed(2);
      } else {
        amount = 0.0;
        amountController.text = '0.00';
      }
    });
  }

  Future<void> addItem() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userid = preferences.getInt('PBI_ID') ?? 0;  // Fetch the stored user ID, default to 0 if not found

    final response = await http.post(
      Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/order/addItem.php'),
      body: jsonEncode({
        'businessCenter': selectedBusinessCenter,
        'customer': selectedCustomer,
        'item': selectedItem,
        'orderNo': orderNoController.text,
        'quantity': orderQuantity?.toString(),
        'rate': rate?.toString(),
        'amount': amount?.toString(),
        'entryBy': userid, // Add the entryBy value here (can be 'user' or whatever you need)
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        selectedItem = null;
        presentStock = 0.0;
        rate = 0.0;
        orderQuantity = 0.0;
        amount = 0.0;
        stockController.clear();
        rateController.clear();
        itemController.clear();
        orderQuantityController.clear();
        amountController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: ${response.body}')),
      );
    }
  }




  void finalizeOrder() {
    setState(() {
      selectedBusinessCenter = null;
      selectedCustomer = null;
      selectedItem = null;
      presentStock = 0.0;
      rate = 0.0;
      orderQuantity = 0.0;
      amount = 0.0;
      stockController.clear();
      rateController.clear();
      customerController.clear();
      itemController.clear();
      amountController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order finalized')));
  }

  void validateOrderQuantity() {
    setState(() {
      isOrderQuantityValid = (orderQuantity ?? 0) <= (presentStock ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Forms'),
        backgroundColor: Colors.red,
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: orderNoController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Order No',
                        labelStyle: TextStyle(
                          color: Colors.grey, // Label color for read-only field
                        ),
                        filled: true,
                        fillColor: Colors.grey[200], // Background color for read-only state
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Border color for read-only state
                          ),
                          borderRadius: BorderRadius.circular(5.0), // Optional: Rounded corners
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedBusinessCenter,
                                  hint: Text('Choose Business Partner'),
                                  items: businessCenters.map<DropdownMenuItem<String>>((center) {
                                    return DropdownMenuItem<String>(
                                      value: center['id'].toString(),
                                      child: Text(center['name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBusinessCenter = value;
                                      selectedCustomer = null;
                                      selectedItem = null;
                                      presentStock = 0.0;
                                      rate = 0.0;
                                      orderQuantity = 0.0;
                                      amount = 0.0;
                                      stockController.clear();
                                      rateController.clear();
                                      customerController.clear();
                                      itemController.clear();
                                      amountController.clear();
                                      fetchCustomers(value!);
                                    });
                                  },
                                  underline: SizedBox(), // Removes the default underline
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: customerController,
                        decoration: InputDecoration(
                          labelText: 'Customer',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return customers.where((customer) =>
                        customer['name'].toLowerCase().contains(pattern.toLowerCase()) ||
                            customer['code'].toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, customer) {
                        return ListTile(
                          title: Text('${customer['code']} : ${customer['name']}'),
                        );
                      },
                      onSuggestionSelected: (customer) {
                        setState(() {
                          selectedItem = null;
                          presentStock = 0.0;
                          rate = 0.0;
                          orderQuantity = 0.0;
                          amount = 0.0;
                          stockController.clear();
                          rateController.clear();
                          customerController.clear();
                          itemController.clear();
                          amountController.clear();
                          selectedCustomer = customer['id'].toString();
                          customerController.text = '${customer['name']}';

                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: itemController,
                        decoration: InputDecoration(
                          labelText: 'Item',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return items.where((item) =>
                            item['name'].toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, item) {
                        return ListTile(
                          title: Text('${item['code']} : ${item['name']}'),
                        );
                      },
                      onSuggestionSelected: (item) {
                        setState(() {
                          selectedItem = item['id'].toString();
                          itemController.text = item['name'];
                        });
                        fetchStockAndRate(selectedItem!);
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: rateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Rate',
                              labelStyle: TextStyle(
                                color: Colors.grey, // Label color for read-only field
                              ),
                              filled: true,
                              fillColor: Colors.grey[200], // Background color for read-only state
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey, // Border color for read-only state
                                ),
                                borderRadius: BorderRadius.circular(5.0), // Optional: Adjust border radius
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: stockController,
                            readOnly: true,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: 'Stock',
                              labelStyle: TextStyle(
                                color: Colors.grey, // Label color
                              ),
                              filled: true,
                              fillColor: Colors.grey[200], // Background color for read-only state
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey, // Border color for read-only state
                                ),
                                borderRadius: BorderRadius.circular(5.0), // Optional: Adjust border radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: orderQuantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Order Quantity',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              orderQuantity = double.tryParse(value);
                              if ((orderQuantity ?? 0) > (presentStock ?? 0)) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Order Quantity exceeds Present Stock'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              orderQuantityController.clear();
                                              amountController.clear();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                              }
                              calculateAmount();
                              validateOrderQuantity();
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: amountController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle: TextStyle(
                                color: Colors.grey, // Label color for read-only field
                              ),
                              filled: true,
                              fillColor: Colors.grey[200], // Background color for read-only state
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey, // Border color for read-only state
                                ),
                                borderRadius: BorderRadius.circular(5.0), // Optional: Rounded corners
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: isOrderQuantityValid ? addItem : null,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Add Item'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: isOrderQuantityValid ? finalizeOrder : null,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Submit Order'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
