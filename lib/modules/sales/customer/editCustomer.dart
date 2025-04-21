import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy/modules/sales/customer/viewCustomer.dart';

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

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Territory &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class EditCustomerForm extends StatefulWidget {
  final String customerId;

  const EditCustomerForm({required this.customerId});

  @override
  _EditCustomerFormState createState() => _EditCustomerFormState();
}

class _EditCustomerFormState extends State<EditCustomerForm> {
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
    final response = await http.get(Uri.parse(
        'http://icpd.icpbd-erp.com/api/app/modules/sales/customer/getTerritory.php'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['statusCode'] == "200") {
        List data = jsonResponse['data'];
        _territories = data.map((item) => Territory.fromJson(item)).toList();
        setState(() {});
        _fetchCustomerDetails(); // Call after territories are loaded
      }
    }
  }

  Future<void> _fetchCustomerDetails() async {
    final response = await http.get(Uri.parse(
        'http://icpd.icpbd-erp.com/api/app/modules/sales/customer/getSingleCustomer.php?customer_id=${widget.customerId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "200" &&
          data['data'] != null &&
          data['data'].isNotEmpty) {
        final customer = data['data'][0];
        setState(() {
          _customerNameController.text = customer['customer_name'] ?? '';
          _addressController.text = customer['address'] ?? '';
          _mobileNoController.text = customer['mobile_no'] ?? '';
          _contactPersonNameController.text =
              customer['contact_person_name'] ?? '';
          _contactPersonDesignationController.text =
              customer['contact_person_designation'] ?? '';
          _tinController.text = customer['tin'] ?? '';
          _binController.text = customer['bin'] ?? '';
          _nidController.text = customer['nid'] ?? '';
          _selectedCustomerType = customer['customer_type'];

          _selectedTerritory = _territories.isNotEmpty
              ? _territories.firstWhere(
                (territory) => territory.name == customer['territory_name'],
            orElse: () => _territories[0], // Default to first territory if no match found
          )
              : null;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userid = preferences.getInt('PBI_ID') ?? 0;

    if (_formKey.currentState!.validate()) {
      final customerData = {
        "customer_id": widget.customerId,
        "customer_name": _customerNameController.text,
        "address": _addressController.text,
        "mobile_no": _mobileNoController.text,
        "contact_person_name": _contactPersonNameController.text,
        "contact_person_designation":
        _contactPersonDesignationController.text,
        "tin": _tinController.text,
        "bin": _binController.text,
        "nid": _nidController.text,
        "customer_type": _selectedCustomerType,
        "territory": _selectedTerritory?.id,
        "entryBy": userid,
      };

      final response = await http.post(
        Uri.parse(
            'http://icpd.icpbd-erp.com/api/app/modules/sales/customer/updateCustomer.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customerData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Customer updated successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update customer")),
        );
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
        decoration: InputDecoration(
            labelText: 'Territory', border: OutlineInputBorder()),
        value: _selectedTerritory,
        items: _territories
            .map((territory) => DropdownMenuItem<Territory>(
          child: Text(territory.name),
          value: territory,
        ))
            .toList(),
        onChanged: (Territory? value) {
          setState(() {
            _selectedTerritory = value;
          });
        },
        validator: (value) =>
        value == null ? 'Please select territory' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Customer"),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            tooltip: "Customer List",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerListScreen(),
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
              _buildTextField(
                  _contactPersonNameController, 'Contact Person Name'),
              _buildTextField(_contactPersonDesignationController,
                  'Contact Person Designation'),
              _buildTextField(_tinController, 'TIN'),
              _buildTextField(_binController, 'BIN'),
              _buildTextField(_nidController, 'NID'),
              _buildCustomerTypeDropdown(),
              _buildTerritoryDropdown(),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
