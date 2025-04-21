import 'package:easy/screen/attendance.dart';
import 'package:easy/screen/login.dart';
import 'package:easy/screen/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'attendance/leave/leaveApplication.dart';
import '../sales/order/createOrders.dart';
import '../../screen/dashboards.dart';



class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _HomeState();
}


class _HomeState extends State<CustomDrawer> {

  late SharedPreferences preferences;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
  }

  void logout() {
    preferences.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  padding: EdgeInsets.all(0),
                  child:
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.red),
                    accountName: Text("${preferences.getString('name').toString()}", style: TextStyle(color: Colors.white)),
                    accountEmail: Text("${preferences.getString('mobile').toString()}", style: TextStyle(color: Colors.white)),
                    currentAccountPicture: Image.network("${preferences.getString('profilePicture').toString()}",),
                  )
              ),
              ListTile(leading:Icon(Icons.home), title: Text("Home"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDashboard()));
                },
              ),
              ListTile(leading:Icon(Icons.assignment_turned_in), title: Text("Leave Application"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveApplicationForm()));
                },
              ),
              ListTile(leading:Icon(Icons.assignment_turned_in), title: Text("Late Attendance Application"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveApplicationForm()));
                },
              ),
              ListTile(leading:Icon(Icons.assignment_turned_in), title: Text("OSD Application"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveApplicationForm()));
                },
              ),
              ListTile(leading:Icon(Icons.assignment_turned_in), title: Text("WFH Application"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeaveApplicationForm()));
                },
              ),
              ListTile(leading:Icon(Icons.assignment_turned_in), title: Text("Attendance Report"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendancePage()));
                },
              ),
              ListTile(leading:Icon(Icons.logout),title: Text("Logout"),
                onTap: () {
                  logout();                },
              ),
            ],
          ),
        );
  }
}
