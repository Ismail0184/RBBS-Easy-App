import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'attendance/leave/leaveApplication.dart';
import 'drawerEmployeeDashboard.dart';

class EmployeeDashboard extends StatefulWidget {
  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  late Future<Map<String, dynamic>> _attendanceSummary;
  late SharedPreferences preferences;

  String userName = '';
  String userPosition = '';
  String profilePicture = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendanceSummary = fetchAttendanceSummary();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });

    preferences = await SharedPreferences.getInstance();

    setState(() {
      userName = preferences.getString('name') ?? 'Unknown';
      userPosition = preferences.getString('designation') ?? 'Employee';
      profilePicture = preferences.getString('profilePicture') ??
          'https://i.pravatar.cc/150?img=3'; // default
      isLoading = false;
    });
  }


  Future<Map<String, dynamic>> fetchAttendanceSummary() async {
    final response = await http.get(Uri.parse('https://your-api-url.com/attendance-summary'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load attendance summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Employee Dashboard'),
        backgroundColor: Colors.red,
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            SizedBox(height: 16),
            _buildMetricsGrid(),
            SizedBox(height: 24),
            Text('Attendance', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            _buildAttendanceSection(),
            SizedBox(height: 24),
            Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            _buildQuickActions()
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profilePicture),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(userPosition, style: TextStyle(color: Colors.grey[600])),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricCard('Attendance', '92%', Icons.access_time),
        _buildMetricCard('Tasks', '15', Icons.task_alt),
        _buildMetricCard('Leaves', '2', Icons.beach_access),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.blue),
              SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeaveApplicationForm()),
            );
          },
          icon: Icon(Icons.note_add),
          label: Text('Apply Leave'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.receipt_long),
          label: Text('View Payslip'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _attendanceSummary,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available.'));
        } else {
          final data = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Total Day')),
                DataColumn(label: Text('Off Day')),
                DataColumn(label: Text('Holiday')),
                DataColumn(label: Text('Present')),
                DataColumn(label: Text('Late Present')),
                DataColumn(label: Text('Leave')),
                DataColumn(label: Text('Early Leave')),
                DataColumn(label: Text('Absent')),
                DataColumn(label: Text('Outdoor Duty')),
                DataColumn(label: Text('Overtime')),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('${data['total_days']}')),
                    DataCell(Text('${data['off_days']}')),
                    DataCell(Text('${data['holidays']}')),
                    DataCell(Text('${data['present']}')),
                    DataCell(Text('${data['late_present']}')),
                    DataCell(Text('${data['leave']}')),
                    DataCell(Text('${data['early_leave']}')),
                    DataCell(Text('${data['absent']}')),
                    DataCell(Text('${data['outdoor_duty']}')),
                    DataCell(Text('${data['overtime']}')),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
