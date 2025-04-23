import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  String? selectedLeaveType;
  int leavePolicy = 0;
  int leaveTaken = 0;
  int leaveBalance = 0;
  int appliedDays = 0;

  bool isLoading = false;
  bool isLoadingLeaveTypes = true;
  bool isLoadingPersons = true;

  List<Map<String, dynamic>> leaveTypes = [];
  List<Map<String, dynamic>> persons = [];

  final TextEditingController leavePolicyController = TextEditingController();
  final TextEditingController leaveTakenController = TextEditingController();
  final TextEditingController leaveBalanceController = TextEditingController();

  final TextEditingController leaveAddressController = TextEditingController();
  final TextEditingController leaveReasonController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController appliedDaysController = TextEditingController();


  String? responsiblePerson;
  String? recommenderPerson;
  String? authorizerPerson;

  DateTime? leaveFromDate;
  DateTime? leaveToDate;

  @override
  void initState() {
    super.initState();
    fetchLeaveTypes();
    fetchPersons();
  }

  @override
  void dispose() {
    leavePolicyController.dispose();
    leaveTakenController.dispose();
    leaveBalanceController.dispose();
    leaveAddressController.dispose();
    leaveReasonController.dispose();
    mobileNumberController.dispose();
    appliedDaysController.dispose();
    super.dispose();
  }

  Future<void> fetchLeaveTypes() async {
    final url = Uri.parse("http://icpd.icpbd-erp.com/api/app/modules/employee-dashboard/attendance/leave/leaveType.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List types = body['data'];
        setState(() {
          leaveTypes = types.map((item) => {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching leave types: $e");
    } finally {
      setState(() => isLoadingLeaveTypes = false);
    }
  }

  Future<void> fetchPersons() async {
    final url = Uri.parse("http://icpd.icpbd-erp.com/api/app/modules/employee-dashboard/getActivePerson.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List personList = data['data'];
        setState(() {
          persons = personList.map((item) => {
            'id': item['id'].toString(),
            'name': item['name'].toString(),
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching persons: $e");
    } finally {
      setState(() => isLoadingPersons = false);
    }
  }

  Future<void> fetchLeaveDetails(String leaveTypeId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt('PBI_ID') ?? 0;
    final url = Uri.parse('http://icpd.icpbd-erp.com/api/app/modules/employee-dashboard/attendance/leave/getLeaveTypeBalance.php?type=$leaveTypeId&user_id=$userId');
    setState(() => isLoading = true);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          leavePolicy = int.tryParse(data['leavePolicy'].toString()) ?? 0;
          leaveTaken = int.tryParse(data['totalLeaveTaken'].toString()) ?? 0;
          leaveBalance = int.tryParse(data['leaveBalance'].toString()) ?? 0;

          leavePolicyController.text = leavePolicy.toString();
          leaveTakenController.text = leaveTaken.toString();
          leaveBalanceController.text = leaveBalance.toString();
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final from = picked.start;
      final to = picked.end;
      final days = to.difference(from).inDays + 1;

      if (days > leaveBalance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Leave Limit Exceeded"),
            content: Text("Selected days exceed your leave balance."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
        setState(() {
          leaveFromDate = null;
          leaveToDate = null;
          appliedDaysController.text = '';
        });
      } else {
        setState(() {
          leaveFromDate = from;
          leaveToDate = to;
          appliedDaysController.text = days.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leave Application Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoadingLeaveTypes || isLoadingPersons
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Leave Type', border: OutlineInputBorder()),
                value: selectedLeaveType,
                items: leaveTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['id'],
                    child: Text(type['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedLeaveType = value);
                  if (value != null) {
                    fetchLeaveDetails(value);
                  }
                },
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator() else Row(
                children: [
                  Expanded(child: TextFormField(enabled: false, controller: leavePolicyController, decoration: InputDecoration(labelText: 'Leave Policy', border: OutlineInputBorder()))),
                  SizedBox(width: 10),
                  Expanded(child: TextFormField(enabled: false, controller: leaveTakenController, decoration: InputDecoration(labelText: 'Leave Taken', border: OutlineInputBorder()))),
                  SizedBox(width: 10),
                  Expanded(child: TextFormField(enabled: false, controller: leaveBalanceController, decoration: InputDecoration(labelText: 'Leave Balance', border: OutlineInputBorder()))),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(controller: leaveAddressController, decoration: InputDecoration(labelText: 'Leave Address (optional)', border: OutlineInputBorder())),
              SizedBox(height: 20),
              TextFormField(controller: leaveReasonController, decoration: InputDecoration(labelText: 'Leave Reason', border: OutlineInputBorder()), validator: (value) => value!.isEmpty ? 'Required' : null),
              SizedBox(height: 20),
              TextFormField(controller: mobileNumberController, decoration: InputDecoration(labelText: 'Mobile Number (optional)', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Responsible Person',
                  border: OutlineInputBorder(),
                ),
                value: responsiblePerson,
                items: persons.map((p) {
                  return DropdownMenuItem<String>(
                    value: p['id'],
                    child: Text(
                      p['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => responsiblePerson = val),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Recommender Person',
                  border: OutlineInputBorder(),
                ),
                value: recommenderPerson,
                items: persons.map((p) {
                  return DropdownMenuItem<String>(
                    value: p['id'],
                    child: Text(
                      p['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => recommenderPerson = val),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Authorizer Person',
                  border: OutlineInputBorder(),
                ),
                value: authorizerPerson,
                items: persons.map((p) {
                  return DropdownMenuItem<String>(
                    value: p['id'],
                    child: Text(
                      p['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => authorizerPerson = val),
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: pickDateRange,
                      icon: Icon(Icons.date_range, size: 20),
                      label: Text(
                        'Pick Leave Dates',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: appliedDaysController,
                      decoration: InputDecoration(labelText: 'Applied Days', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (leaveFromDate != null && leaveToDate != null && appliedDaysController.text.isNotEmpty)
                    ? () {
                  // Submit logic here
                }
                    : null,
                child: Text('Submit the Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
