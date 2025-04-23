import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
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
}

class CustomerType {
  final String id;
  final String type;

  CustomerType({required this.id, required this.type});

  factory CustomerType.fromJson(Map<String, dynamic> json) {
    return CustomerType(
      id: json['id'].toString(),
      type: json['type'],
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

  List<CustomerType> _customerTypes = [];
  CustomerType? _selectedCustomerType;

  Territory? _selectedTerritory;
  List<Territory> _territories = [];

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchTerritories();
    _fetchCustomerTypes();
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

  Future<void> _fetchCustomerTypes() async {
    final response = await http.get(
      Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/customer/getCustomerType.php'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['statusCode'] == "200") {
        List data = jsonResponse['data'];
        setState(() {
          _customerTypes = data.map((item) => CustomerType.fromJson(item)).toList();
        });
      } else {
        print('Error in customer type API: ${jsonResponse['statusCode']}');
      }
    } else {
      print('Failed to load customer types');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final int userid = preferences.getInt('PBI_ID') ?? 0;

    if (_formKey.currentState!.validate()) {
      String? imageUrl;

      if (_selectedImage != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/customer/uploadImage.php'),
        );

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
          filename: path.basename(_selectedImage!.path),
        ));

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseData);
          imageUrl = jsonResponse['image_url'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Image upload failed")));
          return;
        }
      }

      final customerData = {
        "customer_name": _customerNameController.text,
        "address": _addressController.text,
        "mobile_no": _mobileNoController.text,
        "contact_person_name": _contactPersonNameController.text,
        "contact_person_designation": _contactPersonDesignationController.text,
        "tin": _tinController.text,
        "bin": _binController.text,
        "nid": _nidController.text,
        "customer_type": _selectedCustomerType?.id,
        "territory": _selectedTerritory?.id,
        "entryBy": userid,
        "photo": imageUrl,
      };

      final response = await http.post(
        Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/sales/customer/addNewCustomer.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(customerData),
      );

      if (response.statusCode == 200) {
        _formKey.currentState!.reset();
        setState(() {
          _customerNameController.clear();
          _addressController.clear();
          _mobileNoController.clear();
          _contactPersonNameController.clear();
          _contactPersonDesignationController.clear();
          _tinController.clear();
          _binController.clear();
          _nidController.clear();
          _selectedCustomerType = null;
          _selectedTerritory = null;
          _selectedImage = null;
        });
        FocusScope.of(context).unfocus();

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
      child: DropdownButtonFormField<CustomerType>(
        decoration: InputDecoration(
            labelText: 'Customer Type', border: OutlineInputBorder()),
        value: _selectedCustomerType,
        items: _customerTypes
            .map((type) => DropdownMenuItem(
          child: Text(type.type),
          value: type,
        ))
            .toList(),
        onChanged: (CustomerType? value) {
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

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upload Customer Photo", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: _selectedImage != null
                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                : Center(child: Text("Tap to select image")),
          ),
        ),
      ],
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
              _buildImagePicker(),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
