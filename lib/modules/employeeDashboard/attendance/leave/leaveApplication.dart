import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LeaveApplicationForm extends StatefulWidget {
  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController leaveAddressController = TextEditingController();
  TextEditingController leaveReasonController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController appliedDaysController = TextEditingController();

  // Dropdown values
  String? selectedLeaveType;
  String? selectedResponsiblePerson;
  String? selectedRecommenderPerson;
  String? selectedAuthorizerPerson;

  // Data from APIs
  List<dynamic> leaveTypes = [];
  List<dynamic> users = [];
  int leavePolicy = 0;
  int leaveTaken = 0;
  int leaveBalance = 0;

  // API URLs
  final String leaveTypeApi = "http://icpd.icpbd-erp.com/api/app/modules/employee-dashboard/attendance/leave/leaveType.php";
  final String usersApi = "YOUR_API_URL/users";
  final String submitApi = "YOUR_API_URL/submit-leave";

  @override
  void initState() {
    super.initState();
    fetchLeaveTypes();
    fetchUsers();
  }

  Future<void> fetchLeaveTypes() async {
    try {
      final response = await http.get(Uri.parse("http://icpd.icpbd-erp.com/api/app/modules/employee-dashboard/attendance/leave/leaveType.php"));

      if (response.statusCode == 200) {
        setState(() {
          leaveTypes = json.decode(response.body);
        });
      } else {
        showAlert("Failed to fetch leave types. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      showAlert("Error fetching leave types: $e");
    }
  }


  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(usersApi));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    }
  }

  Future<void> fetchLeaveDetails(String leaveType) async {
    final response = await http.get(Uri.parse("http://icpd.icpbd-erp.com/api/app/modules/employee-dashboard/attendance/leave/getLeaveTypeBalance.php?user_id=61&type=$leaveType"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        leavePolicy = data['leave_policy'];
        leaveTaken = data['leave_taken'];
        leaveBalance = leavePolicy - leaveTaken;
      });
    }
  }

  void calculateAppliedDays() {
    if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
      final startDate = DateFormat('yyyy-MM-dd').parse(startDateController.text);
      final endDate = DateFormat('yyyy-MM-dd').parse(endDateController.text);
      final days = endDate.difference(startDate).inDays + 1;

      if (days > leaveBalance) {
        showAlert("You cannot exceed the leave balance.");
        setState(() {
          startDateController.clear();
          endDateController.clear();
        });
      } else {
        setState(() {
          appliedDaysController.text = days.toString();
        });
      }
    }
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alert"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "type": selectedLeaveType,
        "leave_address": leaveAddressController.text,
        "leave_reason": leaveReasonController.text,
        "mobile_number": mobileNumberController.text,
        "responsible_person": selectedResponsiblePerson,
        "recommender_person": selectedRecommenderPerson,
        "authorizer_person": selectedAuthorizerPerson,
        "leave_from": startDateController.text,
        "leave_to": endDateController.text,
        "applied_days": appliedDaysController.text,
      };

      final response = await http.post(
        Uri.parse(submitApi),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        showAlert("Leave application submitted successfully.");
      } else {
        showAlert("Failed to submit leave application.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leave Application")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Type of Leave"),
                  value: selectedLeaveType,
                  items: leaveTypes.map((type) {
                    return DropdownMenuItem(
                      value: type['id'],
                      child: Text(type['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLeaveType = value as String?;
                    });
                    fetchLeaveDetails(selectedLeaveType!);
                  },
                  validator: (value) => value == null ? "Please select a leave type" : null,
                ),

                SizedBox(height: 16),
                Text("Leave Policy: $leavePolicy"),
                Text("Leave Taken: $leaveTaken"),
                Text("Leave Balance: $leaveBalance"),
                SizedBox(height: 16),
                TextFormField(
                  controller: leaveAddressController,
                  decoration: InputDecoration(labelText: "Leave Address"),
                  validator: (value) => value!.isEmpty ? "Please enter leave address" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: leaveReasonController,
                  decoration: InputDecoration(labelText: "Leave Reason"),
                  validator: (value) => value!.isEmpty ? "Please enter leave reason" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: mobileNumberController,
                  decoration: InputDecoration(labelText: "Mobile Number"),
                  validator: (value) => value!.isEmpty ? "Please enter mobile number" : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Responsible Person"),
                  value: selectedResponsiblePerson,
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user['id'],
                      child: Text(user['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedResponsiblePerson = value as String?;
                    });
                  },
                  validator: (value) => value == null ? "Please select a responsible person" : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Recommender Person"),
                  value: selectedRecommenderPerson,
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user['id'],
                      child: Text(user['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRecommenderPerson = value as String?;
                    });
                  },
                  validator: (value) => value == null ? "Please select a recommender person" : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Authorizer Person"),
                  value: selectedAuthorizerPerson,
                  items: users.map((user) {
                    return DropdownMenuItem(
                      value: user['id'],
                      child: Text(user['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAuthorizerPerson = value as String?;
                    });
                  },
                  validator: (value) => value == null ? "Please select an authorizer person" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: "Leave From"),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        startDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      });
                      calculateAppliedDays();
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Please select a start date" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: "Leave To"),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        endDateController.text = DateFormat('yyyy-MM-dd').format(date);
                      });
                      calculateAppliedDays();
                    }
                  },
                  validator: (value) => value!.isEmpty ? "Please select an end date" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: appliedDaysController,
                  decoration: InputDecoration(labelText: "Total Applied Days"),
                  readOnly: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: leaveBalance > 0 && appliedDaysController.text.isNotEmpty
                      ? submitForm
                      : null,
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
