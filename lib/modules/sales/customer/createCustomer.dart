import 'package:easy/modules/sales/customer/viewCustomer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Territory {
  final String id;
  final String name;

  Territory({required this.id, required this.name});

  factory Territory.fromJson(Map<String, dynamic> json) {
    return Territory(
      id: json['territory_id'].toString(),
      name: json['territory_name'],
    );
  }
}

class CustomerFormScreen extends StatefulWidget {
  @override
  _CustomerFormScreenState createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _customerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _contactPersonNameController = TextEditingController();
  final _contactPersonDesignationController = TextEditingController();
  final _tinController = TextEditingController();
  final _binController = TextEditingController();
  final _nidController = TextEditingController();

  final List<String> _customerTypes = [
    'direct customer',
    'Distributor',
    'regular Customer',
    'other'
  ];

  String? _selectedCustomerType;
  Territory? _selectedTerritory;
  List<Territory> _territories = [];

  @override
  void initState() {
    super.initState();
    _fetchTerritories();
  }

  Future<void> _fetchTerritories() async {
    final response = await http.get(
      Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/customer/getTerritory.php'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['statusCode'] == "200") {
        List data = jsonResponse['data'];
        setState(() {
          _territories = data.map((item) => Territory.fromJson(item)).toList();
        });
      } else {
        print('API returned error status: ${jsonResponse['statusCode']}');
      }
    } else {
      print('Failed to load territories');
    }
  }


  Future<void> _submitForm() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userid = preferences.getInt('PBI_ID') ?? 0;

    if (_formKey.currentState!.validate()) {
      final customerData = {
        "customer_name": _customerNameController.text,
        "address": _addressController.text,
        "mobile_no": _mobileNoController.text,
        "contact_person_name": _contactPersonNameController.text,
        "contact_person_designation": _contactPersonDesignationController.text,
        "tin": _tinController.text,
        "bin": _binController.text,
        "nid": _nidController.text,
        "customer_type": _selectedCustomerType,
        "territory": _selectedTerritory?.id,
        "entryBy": userid,
      };

      final response = await http.post(
        Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/customer/addNewCustomer.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customerData),
      );

      if (response.statusCode == 200) {
        // Clear all the fields
        _formKey.currentState!.reset(); // Reset the form (validators, dropdowns)

        setState(() {
          // Clear controllers
          _customerNameController.clear();
          _addressController.clear();
          _mobileNoController.clear();
          _contactPersonNameController.clear();
          _contactPersonDesignationController.clear();
          _tinController.clear();
          _binController.clear();
          _nidController.clear();

          // Clear dropdown selections
          _selectedCustomerType = null;
          _selectedTerritory = null;
        });

        // Dismiss keyboard if open
        FocusScope.of(context).unfocus();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Customer added successfully")),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to add customer")));
      }
    }
  }


  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isMandatory = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration:
        InputDecoration(labelText: labelText, border: OutlineInputBorder()),
        validator: (value) {
          if (isMandatory && (value == null || value.isEmpty)) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCustomerTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
            labelText: 'Customer Type', border: OutlineInputBorder()),
        value: _selectedCustomerType,
        items: _customerTypes
            .map((type) => DropdownMenuItem(
          child: Text(type),
          value: type,
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedCustomerType = value;
          });
        },
        validator: (value) =>
        value == null ? 'Please select customer type' : null,
      ),
    );
  }

  Widget _buildTerritoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Territory>(
        decoration:
        InputDecoration(labelText: 'Territory', border: OutlineInputBorder()),
        value: _selectedTerritory,
        items: _territories
            .map((territory) => DropdownMenuItem(
          child: Text(territory.name),
          value: territory,
        ))
            .toList(),
        onChanged: (Territory? value) {
          setState(() {
            _selectedTerritory = value;
          });
        },
        validator: (value) => value == null ? 'Please select territory' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: "Customer List",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerListScreen(), // Make sure this is imported
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_customerNameController, 'Customer Name',
                  isMandatory: true),
              _buildTextField(_addressController, 'Address'),
              _buildTextField(_mobileNoController, 'Mobile No',
                  isMandatory: true),
              _buildTextField(_contactPersonNameController, 'Contact Person Name'),
              _buildTextField(_contactPersonDesignationController,
                  'Contact Person Designation'),
              _buildTextField(_tinController, 'TIN'),
              _buildTextField(_binController, 'BIN'),
              _buildTextField(_nidController, 'NID'),
              _buildCustomerTypeDropdown(),
              _buildTerritoryDropdown(),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
