import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AttendancePage(),
    );
  }
}

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<dynamic> _attendanceData = [];
  TextEditingController _dateController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false; // Track loading state
  String? _errorMessage; // Track error message

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  // Function to show date range picker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange ?? DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 7)),
        end: DateTime.now(),
      ),
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _dateController.text = "${DateFormat('yyyy-MM-dd').format(picked.start)} - ${DateFormat('yyyy-MM-dd').format(picked.end)}";
      });
      fetchAttendanceData();
    }
  }

  // Function to fetch data from the API with date range
  Future<void> fetchAttendanceData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final int userid = preferences.getInt('PBI_ID') ?? 0;  // Fetch the stored user ID, default to 0 if not found

      if (userid == 0) {
        setState(() {
          _errorMessage = 'User ID is not found.';
        });
        return;
      }

      if (_selectedDateRange == null) {
        setState(() {
          _errorMessage = 'Date range not selected.';
        });
        return;
      }

      final String startDate = DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start);
      final String endDate = DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end);

      final String url = 'http://icpd.icpbd-erp.com/api/app/attendanceDataForSingleUser.php?userid=$userid&start_date=$startDate&end_date=$endDate';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == '200' && data['data'].isNotEmpty) {
          setState(() {
            _attendanceData = data['data'];
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = 'No data found for the selected date range.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load data from the server.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Report'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Date Range',
                hintText: 'Start Date - End Date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDateRange(context),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
              : Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Clock In')),
                    DataColumn(label: Text('Clock In Status')),
                    DataColumn(label: Text('Late')),
                    DataColumn(label: Text('Clock Out')),
                    DataColumn(label: Text('Clock Out Status')),
                    DataColumn(label: Text('Early')),
                  ],
                  rows: _attendanceData.map<DataRow>((attendance) {
                    return DataRow(cells: [
                      DataCell(Text(attendance['date'])),
                      DataCell(Text(attendance['clock_in'])),
                      DataCell(Text(attendance['clock_in_status'])),
                      DataCell(
                        Text(
                          // Split the time into hours, minutes, and seconds
                          (attendance['late'] != null && _isLateAfterMidnight(attendance['late']))
                              ? attendance['late']
                              : '-',
                        ),
                      ),
                      DataCell(Text(attendance['clock_out'])),
                      DataCell(Text(attendance['clock_out_status'])),
                      DataCell(
                        Text(
                          // Split the time into hours, minutes, and seconds
                          (attendance['early'] != null && _isLateAfterMidnight(attendance['early']))
                              ? attendance['early']
                              : '-',
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to check if the late time is after 00:00:00
bool _isLateAfterMidnight(String lateTime) {
  List<String> timeParts = lateTime.split(':');
  if (timeParts.length == 3) {
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = int.parse(timeParts[2]);
    if (hours > 0 || minutes > 0 || seconds > 0) {
      return true;
    }
  }
  return false;
}

