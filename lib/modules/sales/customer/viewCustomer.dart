import 'package:easy/modules/sales/customer/createCustomer.dart';
import 'package:easy/modules/sales/customer/editCustomer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Customer {
  final String id;
  final String name;
  final String mobile;
  final String territory;
  final String status;

  Customer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.territory,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['customer_id'].toString(),
      name: json['customer_name'],
      mobile: json['mobile_no'],
      territory: json['territory_name'],
      status: json['status'],
    );
  }
}

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Customer> _customers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? "N/A"),
          ),
        ],
      ),
    );
  }

  // Fetch customers from the API
  Future<void> _fetchCustomers() async {
    final response = await http.get(Uri.parse(
        'http://icpd.icpbd-erp.com/api/app/modules/sales/customer/pendingCustomerList.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['statusCode'] == "200") {
        List data = jsonResponse['data'];
        setState(() {
          _customers = data.map((item) => Customer.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        print("Error loading customers: ${jsonResponse['statusCode']}");
      }
    } else {
      print("Failed to fetch customer list");
    }
  }

  // Delete customer using delete API
  Future<void> _deleteCustomer(String id) async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // If user confirmed, proceed to delete
    if (confirmed == true) {
      final response = await http.post(
        Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/customer/deleteAddedCustomer.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"customer_id": id}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        /// ✅ FIXED: Updated the success condition
        if (result['status'] == "success") {
          setState(() {
            _customers.removeWhere((customer) => customer.id == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Customer deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete customer: ${result['message'] ?? ''}')),
          );
        }
      } else {
        print('Failed to delete customer');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete customer')),
        );
      }
    }
  }

  // View customer details
  Future<void> _viewCustomerDetails(String id) async {
    final response = await http.get(Uri.parse(
        'http://icpd.icpbd-erp.com/api/app/modules/sales/customer/getSingleCustomer.php?customer_id=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data");

      final status = data['status'].toString();
      final customerList = data['data'];

      if (status == "200" && customerList != null && customerList.isNotEmpty) {
        final customer = customerList[0]; // Get first customer
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Customer Details"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Customer Name", customer['customer_name']),
                  _buildInfoRow("Address", customer['address']),
                  _buildInfoRow("Mobile No", customer['mobile_no']),
                  _buildInfoRow("Contact Person", customer['contact_person_name']),
                  _buildInfoRow("Designation", customer['contact_person_designation']),
                  _buildInfoRow("TIN", customer['tin']),
                  _buildInfoRow("BIN", customer['bin']),
                  _buildInfoRow("NID", customer['nid']),
                  _buildInfoRow("Customer Type", customer['customer_type']),
                  _buildInfoRow("Territory", customer['territory_name']),
                  _buildInfoRow("Status", customer['status']),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No data found for this customer")),
        );
      }
    } else {
      print("Failed to load details");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load customer details")),
      );
    }
  }

  // Add this method to refresh the customer list after an update
  Future<void> _refreshCustomerList() async {
    setState(() {
      _isLoading = true; // Optional: Show a loading indicator while refreshing
    });
    await _fetchCustomers(); // Re-fetch customers from the server
  }
  // Navigate to edit customer form
  Future<void> _editCustomer(Customer customer) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomerForm(customerId: customer.id),
      ),
    ).then((_) {
      // After editing, refresh the customer list
      _refreshCustomerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer List"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: "Add New Customer",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerFormScreen(), // Your add form screen
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _customers.isEmpty
          ? Center(
        child: Text(
          'There is no data in the table',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(customer.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mobile: ${customer.mobile}"),
                  Text("Territory: ${customer.territory}"),
                  Text("Status: ${customer.status}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () => _viewCustomerDetails(customer.id),
                  ),
                  if (customer.status != "ACCEPTED") ...[
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () => _editCustomer(customer),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCustomer(customer.id),
                    ),
                  ],
                ],
              ),

            ),
          );
        },
      ),
    );
  }
}

// Edit Customer Form (replace with your actual form)
void _editCustomer(BuildContext context, Customer customer) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditCustomerForm(customerId: customer.id),
    ),
  );
}


